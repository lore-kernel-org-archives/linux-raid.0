From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 8/8] raid5: create multiple threads to handle stripes
Date: Thu, 7 Jun 2012 11:39:58 +1000
Message-ID: <20120607113958.04b9d5b8@notabene.brown>
References: <20120604080152.098975870@kernel.org>
	<20120604080354.686050081@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KH.N00AXaA5d=oFWc7brl1I"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120604080354.686050081@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/KH.N00AXaA5d=oFWc7brl1I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jun 2012 16:02:00 +0800 Shaohua Li <shli@kernel.org> wrote:

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

I think it is great that you have got RAID5 to the point where multiple
threads improve performance.
I really don't like the idea of having to configure that number of threads.

It would be great if it would auto-configure.
Maybe the main thread could fork aux threads when it notices a high load.
e.g. if it has been servicing requests for more than 100ms without a break,
and the number of threads is less than the number of CPUs, then it forks a =
new
helper and resets the timer.

If a thread has been idle for more than 30 minutes, it exits.

Might that be reasonable?

Thanks,
NeilBrown

> ---
>  drivers/md/raid5.c |  118 ++++++++++++++++++++++++++++++++++++++++++++++=
+++++++
>  drivers/md/raid5.h |    2=20
>  2 files changed, 120 insertions(+)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-01 15:23:56.001992200 +0800
> +++ linux/drivers/md/raid5.c	2012-06-04 11:54:25.775331361 +0800
> @@ -4602,6 +4602,41 @@ static int __get_stripe_batch(struct r5c
>  	return batch->count;
>  }
> =20
> +static void raid5auxd(struct mddev *mddev)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +	struct blk_plug plug;
> +	struct stripe_head_batch batch;
> +	int handled, i;
> +
> +	pr_debug("+++ raid5auxd active\n");
> +
> +	blk_start_plug(&plug);
> +	handled =3D 0;
> +	spin_lock_irq(&conf->device_lock);
> +	while (1) {
> +		if (!__get_stripe_batch(conf, &batch))
> +			break;
> +		spin_unlock_irq(&conf->device_lock);
> +
> +		for (i =3D 0; i < batch.count; i++) {
> +			handled++;
> +			handle_stripe(batch.stripes[i]);
> +		}
> +
> +		release_stripe_flush_batch(&batch);
> +		cond_resched();
> +
> +		spin_lock_irq(&conf->device_lock);
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
> @@ -4651,6 +4686,8 @@ static void raid5d(struct mddev *mddev)
> =20
>  		if (!__get_stripe_batch(conf, &batch))
>  			break;
> +		for (i =3D 0; i < conf->aux_thread_num; i++)
> +			md_wakeup_thread(conf->aux_threads[i]);
>  		spin_unlock_irq(&conf->device_lock);
> =20
>  		for (i =3D 0; i < batch.count; i++) {
> @@ -4784,10 +4821,86 @@ stripe_cache_active_show(struct mddev *m
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
> +
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
> @@ -4835,6 +4948,7 @@ static void raid5_free_percpu(struct r5c
> =20
>  static void free_conf(struct r5conf *conf)
>  {
> +	kfree(conf->aux_threads);
>  	shrink_stripes(conf);
>  	raid5_free_percpu(conf);
>  	kfree(conf->disks);
> @@ -5391,6 +5505,10 @@ abort:
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
> --- linux.orig/drivers/md/raid5.h	2012-06-01 15:23:56.017991998 +0800
> +++ linux/drivers/md/raid5.h	2012-06-01 15:27:12.515521685 +0800
> @@ -463,6 +463,8 @@ struct r5conf {
>  	 * the new thread here until we fully activate the array.
>  	 */
>  	struct md_thread	*thread;
> +	int			aux_thread_num;
> +	struct md_thread	**aux_threads;
>  };
> =20
>  /*


--Sig_/KH.N00AXaA5d=oFWc7brl1I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9AGbjnsnt1WYoG5AQI4NRAAjZATBSyiav7/8eGNtnNO/tECSufE70+g
0zLvoSwUkHbyvmlHEcgCK1HtTY1+QgWJWSuZVV1tjs1rtu5IADhrD9CHrSbkU8k3
R2QL+aPIKodpTlVPt36C8704ztrpYIiSXQxGG9gTDyPjvNH5cbti/wn7u4d8swdQ
sqyzZsY8Iv3skKc0Daa8qfRDL5D16yzYwvOckGg7H0Rffy3h1pmGTwKYLDzkQZ1t
IJeFNbQkAcDTfwbH3ycwZgP3YbyTeYRGxXclMXZ3OYk2kWwQvCUE8xC/T1K0Mh4x
Ri8njSyY7ylL04cKGfTp6BMMqFuP6GNaxK7p92TxZ13reM/AwjYGUpiUlkiiRRi1
BqH/86GmrQDiiH8qcA09ekMIkS8zesIyOfEaPXkNY/cqQerHjhUSOTDYAwz7TLOT
6XQJxCXm7Xv27EIq9Ary9RjFYzTU6h9FL+PQ5O5wBE5Tt/ilB5nqUGg59BHW6iTu
9K+foIN1qfkTa3zLd4xO70N8P7x8ATO/cECue93RE0tCmiFnyMpH41WjS8XYhpye
quDWUDDyLkwvRUVLvY8Rzl1BI68a0ed55xwq7uP/F7CdGzSLlVMd71Ls+2coL0+x
u4ZVeOQBBHU3svgH6qGKWMHArKiEZWUlMUB3yvKGbx0VHt5TIGz8B7Y/F6SR3P0n
owfeCV1BGu8=
=c3bI
-----END PGP SIGNATURE-----

--Sig_/KH.N00AXaA5d=oFWc7brl1I--
