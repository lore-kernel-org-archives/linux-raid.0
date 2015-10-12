From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2/9] raid5-cache: add trim support for log
Date: Mon, 12 Oct 2015 17:00:14 +1100
Message-ID: <877fms1v9t.fsf@notabene.neil.brown.name>
References: <cover.1444360850.git.shli@fb.com> <effe8247d5013e4951fd7efa06cc45efe66a94c4.1444360850.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <effe8247d5013e4951fd7efa06cc45efe66a94c4.1444360850.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> Since superblock is updated infrequently, we do a simple trim of log
> disk (a synchronous trim)
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5-cache.c | 63 ++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 62 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index caeec10..5dbe084 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -85,6 +85,7 @@ struct r5l_log {
>  	spinlock_t no_space_stripes_lock;
>=20=20
>  	bool need_cache_flush;
> +	bool in_teardown;
>  };
>=20=20
>  /*
> @@ -644,6 +645,60 @@ void r5l_flush_stripe_to_raid(struct r5l_log *log)
>  }
>=20=20
>  static void r5l_write_super(struct r5l_log *log, sector_t cp);
> +static void r5l_write_super_and_discard_space(struct r5l_log *log,
> +	sector_t end)
> +{
> +	struct block_device *bdev =3D log->rdev->bdev;
> +	struct mddev *mddev;
> +
> +	r5l_write_super(log, end);
> +
> +	if (!blk_queue_discard(bdev_get_queue(bdev)))
> +		return;
> +
> +	mddev =3D log->rdev->mddev;
> +	/*
> +	 * This is to avoid a deadlock. r5l_quiesce holds reconfig_mutex and
> +	 * wait for this thread to finish. This thread waits for
> +	 * MD_CHANGE_PENDING clear, which is supposed to be done in
> +	 * md_check_recovery(). md_check_recovery() tries to get
> +	 * reconfig_mutex. Since r5l_quiesce already holds the mutex,
> +	 * md_check_recovery() fails, so the PENDING never get cleared. The
> +	 * in_teardown check workaround this issue.
> +	 * */

Thanks for this comment (but can we just end the comment with "*/"
instead of  "* */" - that's what everyone else does).
It helps a lot.  If feels a bit clumsy, but maybe that is just me.  At
least I understand now and it make sense.

> +	if (!log->in_teardown) {
> +		set_bit(MD_CHANGE_DEVS, &mddev->flags);
> +		set_bit(MD_CHANGE_PENDING, &mddev->flags);
> +		md_wakeup_thread(mddev->thread);
> +		wait_event(mddev->sb_wait,
> +			!test_bit(MD_CHANGE_PENDING, &mddev->flags) ||
> +			log->in_teardown);
> +		/*
> +		 * r5l_quiesce could run after in_teardown check and hold
> +		 * mutex first. Superblock might get updated twice.
> +		 * */
> +		if (log->in_teardown)
> +			md_update_sb(mddev, 1);
> +	} else {
> +		BUG_ON(!mddev_is_locked(mddev));
> +		md_update_sb(mddev, 1);
> +	}
> +
> +	if (log->last_checkpoint < end) {
> +		blkdev_issue_discard(bdev,
> +				log->last_checkpoint + log->rdev->data_offset,
> +				end - log->last_checkpoint, GFP_NOIO, 0);
> +	} else {
> +		blkdev_issue_discard(bdev,
> +				log->last_checkpoint + log->rdev->data_offset,
> +				log->device_size - log->last_checkpoint,
> +				GFP_NOIO, 0);
> +		blkdev_issue_discard(bdev, log->rdev->data_offset, end,
> +				GFP_NOIO, 0);
> +	}
> +}
> +
> +
>  static void r5l_do_reclaim(struct r5l_log *log)
>  {
>  	sector_t reclaim_target =3D xchg(&log->reclaim_target, 0);
> @@ -685,7 +740,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
>  	 * here, because the log area might be reused soon and we don't want to
>  	 * confuse recovery
>  	 */
> -	r5l_write_super(log, next_checkpoint);
> +	r5l_write_super_and_discard_space(log, next_checkpoint);
>=20=20
>  	mutex_lock(&log->io_mutex);
>  	log->last_checkpoint =3D next_checkpoint;
> @@ -721,9 +776,11 @@ static void r5l_wake_reclaim(struct r5l_log *log, se=
ctor_t space)
>=20=20
>  void r5l_quiesce(struct r5l_log *log, int state)
>  {
> +	struct mddev *mddev;
>  	if (!log || state =3D=3D 2)
>  		return;
>  	if (state =3D=3D 0) {
> +		log->in_teardown =3D 0;
>  		log->reclaim_thread =3D md_register_thread(r5l_reclaim_thread,
>  					log->rdev->mddev, "reclaim");
>  	} else if (state =3D=3D 1) {
> @@ -731,6 +788,10 @@ void r5l_quiesce(struct r5l_log *log, int state)
>  		 * at this point all stripes are finished, so io_unit is at
>  		 * least in STRIPE_END state
>  		 */
> +		log->in_teardown =3D 1;
> +		/* make sure r5l_write_super_and_discard_space exits */
> +		mddev =3D log->rdev->mddev;
> +		wake_up(&mddev->sb_wait);
>  		r5l_wake_reclaim(log, -1L);
>  		md_unregister_thread(&log->reclaim_thread);

I think this is racey (though you haven't changed the code, so it must
have been racy before).
There is no guarantee that the thread will actually wake up to handle
the reclaim before md_unregister_thread marks the thread as
kthread_should_stop().
Maybe the thing to do would be
   md_unregister_thread()
   log->reclaim_target =3D (unsigned long) -1;
   r5l_do_reclaim(log);

or something like that.  i.e. just do it synchronously.

Then.... maybe you don't need in_teardown.
When r5l_do_reclaim() is called from the thread, you wait.
When called from r5l_quiesce(), you md_update_sb().

Would that work?

Thanks,
NeilBrown



>  		r5l_do_reclaim(log);
> --=20
> 2.4.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWG0xuAAoJEDnsnt1WYoG5y9IP/ROIFD/KzFGjO3i9j0t333vI
NmWt9Vz2C1RY6krZxvwCQoV9RVBcGYzD7QGrnEZ6TEzE1odydXUVwuX7NyWk0+Vc
DeaQ0nlfS34p3AEp2HZd8x9jwt5mXM/EOjMRBET66KduqEznny5lB74rywMIDjjd
sAbvdbStpsOxoha7v5ywT1OI4x7k/zSs4ZOxnc88yZ0eKbXkMbcJWpSBLZ0pQXUf
xgJj/jtHD6dlLLm8mOgsgKopkrLGEZR5vvwyOD9HGrh/b8D57cuOb5YCJ7LqkrER
0FPjdBaurqjlC6MkWzcmlB/I31WhmhvW1fTOwFbf/f+besETMgQ2QwWGV4FnafkU
zkN0X+jCE9w55YWlAsPIlF0TxBZ1dpTWiG1N/0x+3LMPsoDGGnnIcLecVWxbJ/Ga
QRIPRxf87schta8AhXpqz/gZkCL9lvSnY6tqzbpo8QPSHzCN+JgPwjOjb4txzC8x
XIq0OhrzAQtXQWv1bWteIP0pGvYO4mOBDwY3FLTYmS9X3rLsnCIiHn1A2HP2+GMg
avmnjSHCATuJotKlEa6AGWvefhCdNouJUWSFKtYBIh5bARmojlcofL/kcum1uSAQ
B9t5nyhcQeAiP9lfoa4dLRIqbNOxs0yKkIWNiVLiWuRMTh8ZEGtHFYVUeoAOu6DC
AhTQkhmM5UKqY5GRKBwh
=Bka/
-----END PGP SIGNATURE-----
--=-=-=--
