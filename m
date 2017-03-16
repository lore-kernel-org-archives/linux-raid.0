From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 15/15] MD: use per-cpu counter for writes_pending
Date: Thu, 16 Mar 2017 13:57:30 +1100
Message-ID: <87zigmc4it.fsf@notabene.neil.brown.name>
References: <148954692173.18641.1294690639716682540.stgit@noble> <148954711465.18641.8222940807591984069.stgit@noble> <20170316010557.bjccpzke4gta6tfr@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170316010557.bjccpzke4gta6tfr@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15 2017, Shaohua Li wrote:

> On Wed, Mar 15, 2017 at 02:05:14PM +1100, Neil Brown wrote:
>> The 'writes_pending' counter is used to determine when the
>> array is stable so that it can be marked in the superblock
>> as "Clean".  Consequently it needs to be updated frequently
>> but only checked for zero occasionally.  Recent changes to
>> raid5 cause the count to be updated even more often - once
>> per 4K rather than once per bio.  This provided
>> justification for making the updates more efficient.
>>=20
>> So we replace the atomic counter a percpu-refcount.
>> This can be incremented and decremented cheaply most of the
>> time, and can be switched to "atomic" mode when more
>> precise counting is needed.  As it is possible for multiple
>> threads to want a precise count, we introduce a
>> "sync_checker" counter to count the number of threads
>> in "set_in_sync()", and only switch the refcount back
>> to percpu mode when that is zero.
>>=20
>> We need to be careful about races between set_in_sync()
>> setting ->in_sync to 1, and md_write_start() setting it
>> to zero.  md_write_start() holds the rcu_read_lock()
>> while checking if the refcount is in percpu mode.  If
>> it is, then we know a switch to 'atomic' will not happen until
>> after we call rcu_read_unlock(), in which case set_in_sync()
>> will see the elevated count, and not set in_sync to 1.
>> If it is not in percpu mode, we take the mddev->lock to
>> ensure proper synchronization.
>>=20
>> It is no longer possible to quickly check if the count is zero, which
>> we previously did to update a timer or to schedule the md_thread.
>> So now we do these every time we decrement that counter, but make
>> sure they are fast.
>>=20
>> mod_timer() already optimizes the case where the timeout value doesn't
>> actually change.  We leverage that further by always rounding off the
>> jiffies to the timeout value.  This may delay the marking of 'clean'
>> slightly, but ensure we only perform atomic operation here when absolute=
ly
>> needed.
>>=20
>> md_wakeup_thread() current always calls wake_up(), even if
>> THREAD_WAKEUP is already set.  That too can be optimised to avoid
>> calls to wake_up().
>>=20
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  drivers/md/md.c |   70 +++++++++++++++++++++++++++++++++++++-----------=
-------
>>  drivers/md/md.h |    3 ++
>>  2 files changed, 49 insertions(+), 24 deletions(-)
>>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index c33ec97b23d4..adf2b5bdfd67 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -65,6 +65,8 @@
>>  #include <linux/raid/md_p.h>
>>  #include <linux/raid/md_u.h>
>>  #include <linux/slab.h>
>> +#include <linux/percpu-refcount.h>
>> +
>>  #include <trace/events/block.h>
>>  #include "md.h"
>>  #include "bitmap.h"
>> @@ -2255,16 +2257,24 @@ static void export_array(struct mddev *mddev)
>>  static bool set_in_sync(struct mddev *mddev)
>>  {
>>  	WARN_ON_ONCE(!spin_is_locked(&mddev->lock));
>> -	if (atomic_read(&mddev->writes_pending) =3D=3D 0) {
>> -		if (mddev->in_sync =3D=3D 0) {
>> +	if (!mddev->in_sync) {
>> +		mddev->sync_checkers++;
>> +		spin_unlock(&mddev->lock);
>> +		percpu_ref_switch_to_atomic_sync(&mddev->writes_pending);
>> +		spin_lock(&mddev->lock);
>> +		if (!mddev->in_sync &&
>> +		    percpu_ref_is_zero(&mddev->writes_pending)) {
>>  			mddev->in_sync =3D 1;
>> +			/*
>> +			 * Ensure in_sync is visible before switch back
>> +			 * to percpu
>> +			 */
>>  			smp_mb();
>> -			if (atomic_read(&mddev->writes_pending))
>> -				/* lost a race with md_write_start() */
>> -				mddev->in_sync =3D 0;
>>  			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>>  			sysfs_notify_dirent_safe(mddev->sysfs_state);
>>  		}
>> +		if (--mddev->sync_checkers =3D=3D 0)
>> +			percpu_ref_switch_to_percpu(&mddev->writes_pending);
>
> percpu_ref_switch_to_percpu could sleep. Maybe let set_in_sync return a v=
alue
> to indicate if caller should drop lock and then do the switch.

percpu_ref_switch_to_percpu() documentation says:
 * This function may block if @ref is in the process of switching to atomic
 * mode.  If the caller ensures that @ref is not in the process of
 * switching to atomic mode, this function can be called from any context.

The percpu_ref_switch_to_atomic_sync() will have ensured that a switch
to atomic mode completed, and the use of ->sync_checkers will ensure
that no other mode change has happened. So according to the
documentation, "this function can be called from any context".

Convinced?

>
>>  	}
>>  	if (mddev->safemode =3D=3D 1)
>>  		mddev->safemode =3D 0;
>> @@ -5120,6 +5130,7 @@ static void md_free(struct kobject *ko)
>>  		del_gendisk(mddev->gendisk);
>>  		put_disk(mddev->gendisk);
>>  	}
>> +	percpu_ref_exit(&mddev->writes_pending);
>>=20=20
>>  	kfree(mddev);
>>  }
>> @@ -5145,6 +5156,8 @@ static void mddev_delayed_delete(struct work_struc=
t *ws)
>>  	kobject_put(&mddev->kobj);
>>  }
>>=20=20
>> +static void no_op(struct percpu_ref *r) {}
>> +
>>  static int md_alloc(dev_t dev, char *name)
>>  {
>>  	static DEFINE_MUTEX(disks_mutex);
>> @@ -5196,6 +5209,10 @@ static int md_alloc(dev_t dev, char *name)
>>  	blk_queue_make_request(mddev->queue, md_make_request);
>>  	blk_set_stacking_limits(&mddev->queue->limits);
>>=20=20
>> +	if (percpu_ref_init(&mddev->writes_pending, no_op, 0, GFP_KERNEL) < 0)
>> +		goto abort;
>> +	/* We want to start with the refcount at zero */
>> +	percpu_ref_put(&mddev->writes_pending);
>>  	disk =3D alloc_disk(1 << shift);
>>  	if (!disk) {
>>  		blk_cleanup_queue(mddev->queue);
>> @@ -5279,11 +5296,10 @@ static void md_safemode_timeout(unsigned long da=
ta)
>>  {
>>  	struct mddev *mddev =3D (struct mddev *) data;
>>=20=20
>> -	if (!atomic_read(&mddev->writes_pending)) {
>> -		mddev->safemode =3D 1;
>> -		if (mddev->external)
>> -			sysfs_notify_dirent_safe(mddev->sysfs_state);
>> -	}
>> +	mddev->safemode =3D 1;
>> +	if (mddev->external)
>> +		sysfs_notify_dirent_safe(mddev->sysfs_state);
>> +
>>  	md_wakeup_thread(mddev->thread);
>>  }
>>=20=20
>> @@ -5488,7 +5504,6 @@ int md_run(struct mddev *mddev)
>>  	} else if (mddev->ro =3D=3D 2) /* auto-readonly not meaningful */
>>  		mddev->ro =3D 0;
>>=20=20
>> -	atomic_set(&mddev->writes_pending,0);
>>  	atomic_set(&mddev->max_corr_read_errors,
>>  		   MD_DEFAULT_MAX_CORRECTED_READ_ERRORS);
>>  	mddev->safemode =3D 0;
>> @@ -7351,8 +7366,8 @@ void md_wakeup_thread(struct md_thread *thread)
>>  {
>>  	if (thread) {
>>  		pr_debug("md: waking up MD thread %s.\n", thread->tsk->comm);
>> -		set_bit(THREAD_WAKEUP, &thread->flags);
>> -		wake_up(&thread->wqueue);
>> +		if (!test_and_set_bit(THREAD_WAKEUP, &thread->flags))
>> +			wake_up(&thread->wqueue);
>>  	}
>>  }
>>  EXPORT_SYMBOL(md_wakeup_thread);
>> @@ -7886,6 +7901,7 @@ EXPORT_SYMBOL(md_done_sync);
>>   */
>>  void md_write_start(struct mddev *mddev, struct bio *bi)
>>  {
>> +	unsigned long __percpu *notused;
>>  	int did_change =3D 0;
>>  	if (bio_data_dir(bi) !=3D WRITE)
>>  		return;
>> @@ -7899,11 +7915,12 @@ void md_write_start(struct mddev *mddev, struct =
bio *bi)
>>  		md_wakeup_thread(mddev->sync_thread);
>>  		did_change =3D 1;
>>  	}
>> -	atomic_inc(&mddev->writes_pending);
>> +	rcu_read_lock();
>> +	percpu_ref_get(&mddev->writes_pending);
>>  	smp_mb(); /* Match smp_mb in set_in_sync() */
>>  	if (mddev->safemode =3D=3D 1)
>>  		mddev->safemode =3D 0;
>> -	if (mddev->in_sync) {
>> +	if (mddev->in_sync || !__ref_is_percpu(&mddev->writes_pending, &notuse=
d)) {
>
> this need review from percpu-ref guys. The api doc declares it's internal=
 use only.

I might add a "ref_is_percpu()", which just takes one arg, to
percpu-reference.h and post that with the other percpu-ref changes.

Thanks for the review.

NeilBrown

>
>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljJ/xoACgkQOeye3VZi
gbkNcg//VGZTjpX909OpbqAcfwjOOlZHa+nBt4yMmonbZaDRbLu6Y9h7BJ+RVcoa
AdvNl44ma3gWLjSg+tC8GDt7F1Q8PsTtTGLRnGYABa/nXPasohYnrIc9E5VvV2qD
SM/HxyUo9ILi64oVqHZnukV5lDPv9DzYV9Afr0QOKnXWbr7R16gsGtVTM8skdfX6
eHEefzl0pnZOcG2L1OneGjn6lNyat5Zi9oHxt71DDyZ8Ju+pR4P6kp21ERlQ4ubj
6snI/pfcBxwOU5kPqv8tshim7QDvwEHkzBOfMKSfpU6QdsHeTHFjGBUYpp4Q/WYB
0feqRJWfvQxp2AI/zkymIZENByRQLqvB0YQ3ljxiZ7zSmczv8VtsAfMFKzqwjaOa
XYGZbmcbP+FaCi8jw0eIbO8pkBmFyRxNN68s8w6YCgpEKxIUxOnWVb4f8WRjdLcu
Tmg2DgBrBYHXj18CiZavOJRCOg5j7+mai4frg8bxTDjtF5DTMvLAQejBiBgOWU+X
ykYBNLIZ8/iJaNNkieQOo8qLefDpMIkup0+LEfMHprZARPkzo5msWa+wDLoJrIyM
gGVqQDrYb9P2rjUgT6Arg2hqZSDuGCQe78SpUoW4bvhS7ft0DHhZsKEaseW5uPuV
7mqpPDZrR5jrRD2CKeQEZ4bWOjoS+poIpdt1VeQTOKhKQpPkOS4=
=P94h
-----END PGP SIGNATURE-----
--=-=-=--
