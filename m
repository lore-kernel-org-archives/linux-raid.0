From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/4] raid1: Rewrite the implementation of iobarrier.
Date: Thu, 31 Oct 2013 13:33:14 +1100
Message-ID: <20131031133314.522f30ad@notabene.brown>
References: <201308281940511854138@gmail.com>
	<20131024125059.1a440152@notabene.brown>
	<201310290930116677124@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YmAfLUC1c3x5TbH+icMgyGO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201310290930116677124@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/YmAfLUC1c3x5TbH+icMgyGO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Oct 2013 09:30:14 +0800 majianpeng <majianpeng@gmail.com> wrote:


Nearly there!!  Just a few more details.  See below.


> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++=
------
>  drivers/md/raid1.h |  14 ++++++
>  2 files changed, 124 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index b4a6dcd..5b311c0 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -66,7 +66,8 @@
>   */
>  static int max_queued_requests =3D 1024;
> =20
> -static void allow_barrier(struct r1conf *conf);
> +static void allow_barrier(struct r1conf *conf, sector_t start_next_windo=
w,
> +				sector_t bi_sector);
>  static void lower_barrier(struct r1conf *conf);
> =20
>  static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
> @@ -227,6 +228,8 @@ static void call_bio_endio(struct r1bio *r1_bio)
>  	struct bio *bio =3D r1_bio->master_bio;
>  	int done;
>  	struct r1conf *conf =3D r1_bio->mddev->private;
> +	sector_t start_next_window =3D r1_bio->start_next_window;
> +	sector_t bi_sector =3D bio->bi_sector;

This should  be r1_bio->sector, not bio->bi_sector.
They are often the same but if multiple r1_bios are needed for some reason
(e.g. bad blocks) they may not be.

> =20
>  	if (bio->bi_phys_segments) {
>  		unsigned long flags;
> @@ -234,6 +237,11 @@ static void call_bio_endio(struct r1bio *r1_bio)
>  		bio->bi_phys_segments--;
>  		done =3D (bio->bi_phys_segments =3D=3D 0);
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
> +		/*
> +		 * make_request() might be waiting for
> +		 * bi_phys_segments to decrease
> +		 */
> +		wake_up(&conf->wait_barrier);
>  	} else
>  		done =3D 1;
> =20
> @@ -245,7 +253,7 @@ static void call_bio_endio(struct r1bio *r1_bio)
>  		 * Wake up any possible resync thread that waits for the device
>  		 * to go idle.
>  		 */
> -		allow_barrier(conf);
> +		allow_barrier(conf, start_next_window, bi_sector);
>  	}
>  }
> =20
> @@ -827,10 +835,18 @@ static void raise_barrier(struct r1conf *conf)
>  	/* block any new IO from starting */
>  	conf->barrier++;
> =20
> -	/* Now wait for all pending IO to complete */
> +	/* For those conditions we must wait:
> +	 * A:while the array is in frozen state
> +	 * B:while barrier >=3D RESYNC_DEPTH, meaning resync reach
> +	 *   the max count which allowed.
> +	 * C:next_resync + RESYNC_SECTORS > start_next_window, meaning
> +	 *   next resync will reach to window which normal bios are handling.
> +	 */
>  	wait_event_lock_irq(conf->wait_barrier,
>  			    !conf->array_frozen &&
> -			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
> +			    conf->barrier < RESYNC_DEPTH &&
> +			    (conf->start_next_window >=3D
> +			     conf->next_resync + RESYNC_SECTORS),
>  			    conf->resync_lock);

You've removed the test on conf->nr_pending here, which I think is correct.
It counts 'read' requests as well.  Testing start_next_window serves the sa=
me
purpose as it is increased whenever current_window_requests reaches zero.

However you having modified as similar test on nr_pending in wait_barrier().
That worries me a bit.  Should that be changed to a test on start_next_wind=
ow
to match the above change?


> =20
>  	spin_unlock_irq(&conf->resync_lock);
> @@ -846,10 +862,33 @@ static void lower_barrier(struct r1conf *conf)
>  	wake_up(&conf->wait_barrier);
>  }
> =20
> -static void wait_barrier(struct r1conf *conf)
> +static bool need_to_wait_for_sync(struct r1conf *conf, struct bio *bio)
> +{
> +	bool wait =3D false;
> +
> +	if (conf->array_frozen || !bio)
> +		wait =3D true;
> +	else if (conf->barrier && bio_data_dir(bio) =3D=3D WRITE) {
> +		if (conf->next_resync < RESYNC_WINDOW_SECTORS)
> +			wait =3D true;
> +		else if ((conf->next_resync - RESYNC_WINDOW_SECTORS
> +				>=3D bio_end_sector(bio)) ||
> +			 (conf->next_resync + NEXT_NORMALIO_DISTANCE
> +				<=3D bio->bi_sector))
> +			wait =3D false;
> +		else
> +			wait =3D true;
> +	}
> +
> +	return wait;
> +}
> +
> +static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
>  {
> +	sector_t sector =3D 0;
> +
>  	spin_lock_irq(&conf->resync_lock);
> -	if (conf->barrier) {
> +	if (need_to_wait_for_sync(conf, bio)) {
>  		conf->nr_waiting++;
>  		/* Wait for the barrier to drop.
>  		 * However if there are already pending
> @@ -868,16 +907,57 @@ static void wait_barrier(struct r1conf *conf)
>  				     !bio_list_empty(current->bio_list))),
>  				    conf->resync_lock);
>  		conf->nr_waiting--;
> +	} else if (bio_data_dir(bio) =3D=3D WRITE) {
> +		if (conf->next_resync + NEXT_NORMALIO_DISTANCE
> +				<=3D bio->bi_sector) {
> +			if (conf->start_next_window =3D=3D MaxSector)
> +				conf->start_next_window =3D
> +					conf->next_resync +
> +						NEXT_NORMALIO_DISTANCE;
> +
> +			if ((conf->start_next_window + NEXT_NORMALIO_DISTANCE)
> +				<=3D bio->bi_sector)
> +				conf->next_window_requests++;
> +			else
> +				conf->current_window_requests++;
> +		}
> +		if (bio->bi_sector >=3D conf->start_next_window)
> +			sector =3D conf->start_next_window;

You aren't setting 'sector' if we needed to wait.  I don't think that is
correct, is it?


>  	}
> +
>  	conf->nr_pending++;
>  	spin_unlock_irq(&conf->resync_lock);
> +	return sector;
>  }
> =20
> -static void allow_barrier(struct r1conf *conf)
> +static void allow_barrier(struct r1conf *conf, sector_t start_next_windo=
w,
> +				sector_t bi_sector)
>  {
>  	unsigned long flags;
> +
>  	spin_lock_irqsave(&conf->resync_lock, flags);
>  	conf->nr_pending--;
> +	if (start_next_window) {
> +		if (start_next_window =3D=3D conf->start_next_window) {
> +			if (conf->start_next_window + NEXT_NORMALIO_DISTANCE
> +				<=3D bi_sector)
> +				conf->next_window_requests--;
> +			else
> +				conf->current_window_requests--;
> +		} else
> +			conf->current_window_requests--;
> +
> +		if (!conf->current_window_requests) {
> +			if (conf->next_window_requests) {
> +				conf->current_window_requests =3D
> +					conf->next_window_requests;
> +				conf->next_window_requests =3D 0;
> +				conf->start_next_window +=3D
> +					NEXT_NORMALIO_DISTANCE;
> +			} else
> +				conf->start_next_window =3D MaxSector;
> +		}
> +	}
>  	spin_unlock_irqrestore(&conf->resync_lock, flags);
>  	wake_up(&conf->wait_barrier);
>  }
> @@ -1012,6 +1092,7 @@ static void make_request(struct mddev *mddev, struc=
t bio * bio)
>  	int first_clone;
>  	int sectors_handled;
>  	int max_sectors;
> +	sector_t start_next_window;
> =20
>  	/*
>  	 * Register the new request and wait if the reconstruction
> @@ -1041,7 +1122,7 @@ static void make_request(struct mddev *mddev, struc=
t bio * bio)
>  		finish_wait(&conf->wait_barrier, &w);
>  	}
> =20
> -	wait_barrier(conf);
> +	start_next_window =3D wait_barrier(conf, bio);
> =20
>  	bitmap =3D mddev->bitmap;
> =20
> @@ -1162,6 +1243,7 @@ read_again:
> =20
>  	disks =3D conf->raid_disks * 2;
>   retry_write:
> +	r1_bio->start_next_window =3D start_next_window;
>  	blocked_rdev =3D NULL;
>  	rcu_read_lock();
>  	max_sectors =3D r1_bio->sectors;
> @@ -1230,14 +1312,24 @@ read_again:
>  	if (unlikely(blocked_rdev)) {
>  		/* Wait for this device to become unblocked */
>  		int j;
> +		sector_t old =3D start_next_window;
> =20
>  		for (j =3D 0; j < i; j++)
>  			if (r1_bio->bios[j])
>  				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
>  		r1_bio->state =3D 0;
> -		allow_barrier(conf);
> +		allow_barrier(conf, start_next_window, bio->bi_sector);

I think this should be r1_bio->sector, not bio->bi_sector, for the same
reason as earlier.


>  		md_wait_for_blocked_rdev(blocked_rdev, mddev);
> -		wait_barrier(conf);
> +		start_next_window =3D wait_barrier(conf, bio);
> +		/*
> +		 * We must make sure the multi r1bios of bio have
> +		 * the same value of bi_phys_segments
> +		 */
> +		if (bio->bi_phys_segments && old &&
> +			old !=3D start_next_window)
> +			/*wait the former r1bio(s) completed*/
> +			wait_event(conf->wait_barrier,
> +					bio->bi_phys_segments =3D=3D 1);
>  		goto retry_write;
>  	}
> =20
> @@ -1437,11 +1529,14 @@ static void print_conf(struct r1conf *conf)
> =20
>  static void close_sync(struct r1conf *conf)
>  {
> -	wait_barrier(conf);
> -	allow_barrier(conf);
> +	wait_barrier(conf, NULL);
> +	allow_barrier(conf, 0, 0);
> =20
>  	mempool_destroy(conf->r1buf_pool);
>  	conf->r1buf_pool =3D NULL;
> +
> +	conf->next_resync =3D 0;
> +	conf->start_next_window =3D MaxSector;
>  }
> =20
>  static int raid1_spare_active(struct mddev *mddev)
> @@ -2713,6 +2808,9 @@ static struct r1conf *setup_conf(struct mddev *mdde=
v)
>  	conf->pending_count =3D 0;
>  	conf->recovery_disabled =3D mddev->recovery_disabled - 1;
> =20
> +	conf->start_next_window =3D MaxSector;
> +	conf->current_window_requests =3D conf->next_window_requests =3D 0;
> +
>  	err =3D -EIO;
>  	for (i =3D 0; i < conf->raid_disks * 2; i++) {
> =20
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index 331a98a..07425a1 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -41,6 +41,19 @@ struct r1conf {
>  	 */
>  	sector_t		next_resync;
> =20
> +	/*when raid1 start resync,we divide raid into four partitions
> +	 * |---------|--------------|---------------------|-------------|
> +	 *        next_resync   start_next_window        Pc
> +	 * Now start_next_window =3D next_resync + NEXT_NORMALIO_DISTANCE
> +	 * Pc =3D start_next_window + NEXT_NORMALIO_DISTANCE
> +	 * current_window_requests means the count of normalIO between
> +	 * start_next_window and Pc.
> +	 * next_window_requests means the count of nornalIO after Pc.
> +	 * */
> +	sector_t		start_next_window;
> +	int			current_window_requests;
> +	int			next_window_requests;
> +
>  	spinlock_t		device_lock;
> =20
>  	/* list of 'struct r1bio' that need to be processed by raid1d,
> @@ -112,6 +125,7 @@ struct r1bio {
>  						 * in this BehindIO request
>  						 */
>  	sector_t		sector;
> +	sector_t		start_next_window;
>  	int			sectors;
>  	unsigned long		state;
>  	struct mddev		*mddev;


Thanks,
NeilBrown

--Sig_/YmAfLUC1c3x5TbH+icMgyGO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnHBajnsnt1WYoG5AQKpeg/9GnTQkai9KHD1mPtYVJU5FnS9aRr1WCYB
qQbfnA/hgGJpf8PR7uiRSFOiKPMawXBPZJ/IGU7oHuqyhizmj5WWdzQaCDi+K7zm
F2qlBKB3mFCCFAD/UTh40Tv0f5Z2ux3fm/nm+u2ocvDy5e4uG0yQPLtq1s/rEvRx
GFhHHn/+Rdeu92k8Cx8asYsm2Xve4vI9Isp83VefmcwNwhH+/iV1RF9MrKs1oWvW
cfMGd6855xQ8fbGcV+bg5aeSSLWYvbipK49qG38XRZg/an5oQNZ0VPHCJrn4ur7Z
fcRgOcNYgyKexBIYVp9AOXUs4L7mWPK9jH5tO+Ol9mPT+nhwtToxl6NDpRi94z9N
ZPqixws7pIRW21cKtU0RDjMVdT+BK1mrEoV7RyjLdObLEmWScp4j4AMk7w1kFzKk
D/fkz43EezECK9dGUIxS8BVMkwGYuY8bLPmZLBwlEIKnRYv+RngYf8PBr1PmkgF4
6DW7N+c9kodv8ScG7pU513Q+KIYxH+Q3/zabL2X+Ic1lGzrcmqCLfFGa1BESJ0Yq
uV0ll7Z2iwMiXpfa5X1ImCpIgH8I+JstCK8IzS20FGH19/+tfPjGVqv0Qq/QtC3r
vEAHjjpHuj4CtVzDRc6THxrVbU5Xe4COilU9W46uW8IU7e7XEgL/FUR0F47mYV8J
CKbcCFG3Ob8=
=Ainp
-----END PGP SIGNATURE-----

--Sig_/YmAfLUC1c3x5TbH+icMgyGO--
