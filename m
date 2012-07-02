From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 10/10 v3] raid5: create multiple threads to handle
 stripes
Date: Mon, 2 Jul 2012 12:39:57 +1000
Message-ID: <20120702123957.474578c7@notabene.brown>
References: <20120625072447.268095276@kernel.org>
	<20120625072726.364743203@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/l8CXlV5Mj2C+rbbhrl+iBHK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625072726.364743203@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/l8CXlV5Mj2C+rbbhrl+iBHK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jun 2012 15:24:57 +0800 Shaohua Li <shli@kernel.org> wrote:

> Like raid 1/10, raid5 uses one thread to handle stripe. In a fast storage=
, the
> thread becomes a bottleneck. raid5 can offload calculation like checksum =
to
> async threads. And if storge is fast, scheduling async work and running a=
sync
> work will introduce heavy lock contention of workqueue, which makes such
> optimization useless. And calculation isn't the only bottleneck. For exam=
ple,
> in my test raid5 thread must handle > 450k requests per second. Just doing
> dispatch and completion will make raid5 thread incapable. The only chance=
 to
> scale is using several threads to handle stripe.
>=20
> With this patch, user can create several extra threads to handle stripe. =
How
> many threads are better depending on disk number, so the thread number ca=
n be
> changed in userspace. By default, the thread number is 0, which means no =
extra
> thread.
>=20
> In a 3-disk raid5 setup, 2 extra threads can provide 130% throughput
> improvement (double stripe_cache_size) and the throughput is pretty close=
 to
> theory value. With >=3D4 disks, the improvement is even bigger, for examp=
le, can
> improve 200% for 4-disk setup, but the throughput is far less than theory
> value, which is caused by several factors like request queue lock content=
ion,
> cache issue, latency introduced by how a stripe is handled in different d=
isks.
> Those factors need further investigations.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |  137 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++-
>  drivers/md/raid5.h |    3 +
>  2 files changed, 139 insertions(+), 1 deletion(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-25 14:58:06.420138526 +0800
> +++ linux/drivers/md/raid5.c	2012-06-25 14:58:06.428138426 +0800
> @@ -211,6 +211,7 @@ static void handle_release_stripe(struct
>  			clear_bit(STRIPE_DELAYED, &sh->state);
>  			clear_bit(STRIPE_BIT_DELAY, &sh->state);
>  			list_add_tail(&sh->lru, &conf->handle_list);
> +			conf->pending_stripes++;
>  		}
>  		md_wakeup_thread(conf->mddev->thread);
>  	} else {
> @@ -489,6 +490,10 @@ get_active_stripe(struct r5conf *conf, s
>  			} else {
>  				if (!test_bit(STRIPE_HANDLE, &sh->state))
>  					atomic_inc(&conf->active_stripes);
> +				else if (!list_empty(&sh->lru)
> +					 && !test_bit(STRIPE_DELAYED, &sh->state)
> +					 && !test_bit(STRIPE_BIT_DELAY, &sh->state))
> +					conf->pending_stripes--;
>  				if (list_empty(&sh->lru) &&
>  				    !test_bit(STRIPE_EXPANDING, &sh->state))
>  					BUG();
> @@ -3670,6 +3675,7 @@ static void raid5_activate_delayed(struc
>  			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				atomic_inc(&conf->preread_active_stripes);
>  			list_add_tail(&sh->lru, &conf->hold_list);
> +			conf->pending_stripes++;
>  		}
>  	}
>  }
> @@ -3979,6 +3985,7 @@ static struct stripe_head *__get_priorit
>  	} else
>  		return NULL;
> =20
> +	conf->pending_stripes--;
>  	list_del_init(&sh->lru);
>  	atomic_inc(&sh->count);
>  	BUG_ON(atomic_read(&sh->count) !=3D 1);
> @@ -4593,6 +4600,33 @@ static int handle_active_stripes(struct
>  	return batch_size;
>  }
> =20
> +static void raid5auxd(struct mddev *mddev)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +	struct blk_plug plug;
> +	int handled;
> +
> +	pr_debug("+++ raid5auxd active\n");
> +
> +	blk_start_plug(&plug);
> +	handled =3D 0;
> +	spin_lock_irq(&conf->device_lock);
> +	while (1) {
> +		int batch_size;
> +
> +		batch_size =3D handle_active_stripes(conf);
> +		if (!batch_size)
> +			break;
> +		handled +=3D batch_size;
> +	}
> +	pr_debug("%d stripes handled\n", handled);
> +
> +	spin_unlock_irq(&conf->device_lock);
> +	blk_finish_plug(&plug);
> +
> +	pr_debug("--- raid5auxd inactive\n");
> +}
> +
>  /*
>   * This is our raid5 kernel thread.
>   *
> @@ -4615,7 +4649,7 @@ static void raid5d(struct mddev *mddev)
>  	spin_lock_irq(&conf->device_lock);
>  	while (1) {
>  		struct bio *bio;
> -		int batch_size;
> +		int batch_size, i;
> =20
>  		if (atomic_read(&mddev->plug_cnt) =3D=3D 0 &&
>  		    !list_empty(&conf->bitmap_list)) {
> @@ -4645,6 +4679,10 @@ static void raid5d(struct mddev *mddev)
>  			break;
>  		handled +=3D batch_size;
> =20
> +		for (i =3D 0; i < conf->aux_thread_num
> +		     && i < conf->pending_stripes/MAX_STRIPE_BATCH + 1; i++)
> +			md_wakeup_thread(conf->aux_threads[i]);
> +
>  		if (mddev->flags & ~(1<<MD_CHANGE_PENDING)) {
>  			spin_unlock_irq(&conf->device_lock);
>  			md_check_recovery(mddev);
> @@ -4769,10 +4807,85 @@ stripe_cache_active_show(struct mddev *m
>  static struct md_sysfs_entry
>  raid5_stripecache_active =3D __ATTR_RO(stripe_cache_active);
> =20
> +static ssize_t
> +raid5_show_auxthread_number(struct mddev *mddev, char *page)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +	if (conf)
> +		return sprintf(page, "%d\n", conf->aux_thread_num);
> +	else
> +		return 0;
> +}
> +
> +static ssize_t
> +raid5_store_auxthread_number(struct mddev *mddev, const char *page, size=
_t len)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +	unsigned long new;
> +	int i;
> +	struct md_thread **threads;
> +
> +	if (len >=3D PAGE_SIZE)
> +		return -EINVAL;
> +	if (!conf)
> +		return -ENODEV;
> +
> +	if (strict_strtoul(page, 10, &new))
> +		return -EINVAL;
> +
> +	if (new =3D=3D conf->aux_thread_num)
> +		return len;
> +
> +	if (new > conf->aux_thread_num) {
> +		threads =3D kmalloc(sizeof(struct md_thread *) * new, GFP_KERNEL);
> +		if (!threads)
> +			return -EFAULT;
> +
> +		i =3D conf->aux_thread_num;
> +		while (i < new) {
> +			char name[10];
> +
> +			sprintf(name, "aux%d", i);
> +			threads[i] =3D md_register_thread(raid5auxd, mddev, name);
> +			if (!threads[i])
> +				goto error;
> +			i++;
> +		}
> +		memcpy(threads, conf->aux_threads,
> +			sizeof(struct md_thread *) * conf->aux_thread_num);
> +		spin_lock_irq(&conf->device_lock);
> +		kfree(conf->aux_threads);
> +		conf->aux_threads =3D threads;
> +		conf->aux_thread_num =3D new;
> +		spin_unlock_irq(&conf->device_lock);
> +	} else {
> +		int old =3D conf->aux_thread_num;
> +
> +		spin_lock_irq(&conf->device_lock);
> +		conf->aux_thread_num =3D new;
> +		spin_unlock_irq(&conf->device_lock);
> +		for (i =3D new; i < old; i++)
> +			md_unregister_thread(&conf->aux_threads[i]);
> +	}
> +
> +	return len;
> +error:
> +	while (--i >=3D conf->aux_thread_num)
> +		md_unregister_thread(&threads[i]);
> +	kfree(threads);
> +	return -EFAULT;
> +}
> +
> +static struct md_sysfs_entry
> +raid5_auxthread_number =3D __ATTR(auxthread_number, S_IRUGO|S_IWUSR,
> +				raid5_show_auxthread_number,
> +				raid5_store_auxthread_number);
> +
>  static struct attribute *raid5_attrs[] =3D  {
>  	&raid5_stripecache_size.attr,
>  	&raid5_stripecache_active.attr,
>  	&raid5_preread_bypass_threshold.attr,
> +	&raid5_auxthread_number.attr,
>  	NULL,
>  };
>  static struct attribute_group raid5_attrs_group =3D {
> @@ -4820,6 +4933,7 @@ static void raid5_free_percpu(struct r5c
> =20
>  static void free_conf(struct r5conf *conf)
>  {
> +	kfree(conf->aux_threads);
>  	shrink_stripes(conf);
>  	raid5_free_percpu(conf);
>  	kfree(conf->disks);
> @@ -4914,6 +5028,7 @@ static struct r5conf *setup_conf(struct
>  	int raid_disk, memory, max_disks;
>  	struct md_rdev *rdev;
>  	struct disk_info *disk;
> +	int i;
> =20
>  	if (mddev->new_level !=3D 5
>  	    && mddev->new_level !=3D 4
> @@ -5037,6 +5152,22 @@ static struct r5conf *setup_conf(struct
>  		printk(KERN_INFO "md/raid:%s: allocated %dkB\n",
>  		       mdname(mddev), memory);
> =20
> +	/* By default, auxthread number equals to disk number */
> +	conf->aux_threads =3D kmalloc(sizeof(struct md_thread *) * max_disks,
> +				    GFP_KERNEL);
> +	if (!conf->aux_threads)
> +		goto abort;
> +	for (i =3D 0; i < max_disks; i++) {
> +		char name[10];
> +
> +		sprintf(name, "aux%d", i);
> +		conf->aux_threads[i] =3D md_register_thread(raid5auxd, mddev, name);
> +		if (!conf->aux_threads[i])
> +			break;
> +	}
> +
> +	conf->aux_thread_num =3D i;
> +
>  	conf->thread =3D md_register_thread(raid5d, mddev, NULL);
>  	if (!conf->thread) {
>  		printk(KERN_ERR
> @@ -5376,6 +5507,10 @@ abort:
>  static int stop(struct mddev *mddev)
>  {
>  	struct r5conf *conf =3D mddev->private;
> +	int i;
> +
> +	for (i =3D 0; i < conf->aux_thread_num; i++)
> +		md_unregister_thread(&conf->aux_threads[i]);
> =20
>  	md_unregister_thread(&mddev->thread);
>  	if (mddev->queue)
> Index: linux/drivers/md/raid5.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.h	2012-06-25 14:58:06.408138677 +0800
> +++ linux/drivers/md/raid5.h	2012-06-25 14:58:06.432138376 +0800
> @@ -450,6 +450,7 @@ struct r5conf {
>  	int			inactive_blocked;	/* release of inactive stripes blocked,
>  							 * waiting for 25% to be free
>  							 */
> +	int			pending_stripes;
>  	int			pool_size; /* number of disks in stripeheads in pool */
>  	spinlock_t		device_lock;
>  	struct disk_info	*disks;
> @@ -458,6 +459,8 @@ struct r5conf {
>  	 * the new thread here until we fully activate the array.
>  	 */
>  	struct md_thread	*thread;
> +	int			aux_thread_num;
> +	struct md_thread	**aux_threads;
>  };
> =20
>  /*


Hi,
 I'm certainly interested in this patch, but I'm not going to apply it yet,
 partly because I want all the other bits to settle and be well tested firs=
t.

 I'm still uncomfortable about setting an explicit number of threads...

 I wonder if a different approach might be useful.  i.e. add an ioctl (or
 similar) while allows a normal user thread to start handling raid5 request=
s.
 Then instead of telling the kernel how many thread to start, we just start
 the right number of processes, bind them to CPUs or whatever might be
 wanted, then call the ioctl.
 Possibly the ioctl would return whenever it runs out of work to do, and th=
is
 could be used somehow to dynamically adjust the number of threads.

 I haven't really thought this through fully yet so it might not work, but
 I'd like to explore the possibility of having the number of threads to
 adjusted automatically, and that probably means allowing user-space a fair
 bit of control and providing it with a fair bit of information.

Thanks,
NeilBrown

--Sig_/l8CXlV5Mj2C+rbbhrl+iBHK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/EJ/Tnsnt1WYoG5AQKu7RAAp27NuqFtHln2I6ZepI01vXCGeek+IRAk
YFhbi8+SERVKQp0D9w4/FKXfWr4VDOJ74jxzpbwHmMogl0sw1nV4T26F2vrKzS6r
emNoFq1kYDg35PNPF+b+YdhXB8YJbfA6tp5gB8iQm5S+Y3eVL4x64nxbG8JLwVck
joFzek4Ombd4zEIYdJpgvVzTWLWtkUUXXDSrYnLExSL0P21EmoOL5G3Ky/92uC7e
L0wi51zS/uvm7zQM4WXoHspQFXmEUQldnr1y1WgnJZGSwzu6CGRUg5+WAzmmYmZe
AKXMhPQEO3LK7GpUNL5NwVaxe1yz1ffPjKOgVXAAm175A1HZGKMW0BPs01hXwv1R
yzXdgMu/CjZ/b4Jmz0kIcRICmSya1rb4M5Fdpgq0AknXdHfeP3SEzUR4CRmgBrJV
nlmoBMJPCZT4k+Ag+asZ/+UoiVH0v3sQjJw9XGMaKZCDTxDQqt5Ezh5LXKXYU4Zo
R40ydUVPTBeXmTOG9zAqNMxkG3zDW+yp3eIB2B7a3FPTwCldAPiFoLHTRiG10VWg
ciPBv/17e0DvmSDEzrOCr/hXmP3GM2z+F0XKWxNkjPVn0Rk6Hw+ewhENaUnokemr
vkuDLb5cC3RuiDHp6hl/+7oqbJMyQGgfX+2qc6HDiP2ghSY+6BQ1bt/nwkl+xEXQ
jvpvSYN38wo=
=oB/Q
-----END PGP SIGNATURE-----

--Sig_/l8CXlV5Mj2C+rbbhrl+iBHK--
