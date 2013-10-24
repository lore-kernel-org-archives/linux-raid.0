From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/4] raid1: Rewrite the implementation of iobarrier.
Date: Thu, 24 Oct 2013 12:50:59 +1100
Message-ID: <20131024125059.1a440152@notabene.brown>
References: <201308281940511854138@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QxTysC2Q8pVekdA.6nw68.6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201308281940511854138@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/QxTysC2Q8pVekdA.6nw68.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi,
 sorry for the excessive delay in reviewing these.

 I've applied the first three, though I fixed some careless spelling errors=
 in
 the patch descriptions and fixed up some of the grammar.

 This one is fairly good - just a couple of fixes needed.
 It is good that you have a nice details patch description at the top, but =
it
 is a bit hard to read.  Fixing the spelling and improving the formatting
 would help a lot....

 See below for comments in the code....

On Wed, 28 Aug 2013 19:40:54 +0800 majianpeng <majianpeng@gmail.com> wrote:

> There is a iobarrier in raid1 because the contend between normalIO and
> resyncIO.It suspend all normal IO when reysync.
> But if normalIO is outrange the resync windwos,there is no contend.
> So I rewrite the iobarrier.
>=20
> I patition the whole space into five parts.
> |---------|-----------|------------|----------------|-------|
>          Pa    next_resync   start_next_window      Pb
>=20
> Firstly i introduce some concepts:
> 1:RESYNC_WINDOW: For resync, there are 32 sync requests at most.A sync
> request is RESYNC_BLOCK_SIZE(64*1024).So the RESYNC_WINDOW is 32 *
> RESYNC_BLOCK_SIZE, that is 2MB.
> 2:NEXT_NORMALIO_DISTANCE: it indicate the distance between next_resync
> and start_next_window.It also indicate the distance between
> start_next_window and Pb.Now it is 3 * RESYNC_WINDOW_SIZE.It can tune.
> 3:next_resync mean the next start sector which will being do sync.
> 4:Pa means a position which before RESYNC_WINDOW distance from
> next_resync.
> 5:start_next_window means a position which after NEXT_NORMALIO_DISTANCE d=
istance from
> next_resync.For normalio after this position,it can't wait resyncio
> 6:Pb means a position which after 2 * NEXT_NORMALIO_DISTANCE distance from
> next_resync.
> 7:current_window_requests means the count of normalIO between Pb and
> start_next_window.
> 8:next_window_requests means the count of nonmalIO after Pb.
>=20
> NormalIO will be partitioned into four types:
> NoIO1: it means the end sector of bio is smaller or equal the Pa.
> NoIO2: it means the start sector of bio larger or equal Pb
> NoIO3: it means the start sector of bio larger or equal	start_next_window.
> NoIO4: it means the location between Pa and start_next_window
>=20
> For NoIO1,it don't use iobarrier.
> For NoIO4,it used the original iobarrier mechanism.The nornalIO and
> syncIO must be contend.
> For NoIO2/3, i add two filed in struct r1conf "current_window_requests,
> next_window_requests".They indicate the count of two types.
> For those, they don't wait.They only add the relevant parameter.
>=20
> For resync action, if there are NoIO4s, it must be wait.If not,it
> forward.But if current_window_requests > 0 and sync action reached to the
> start_next_window,it must wait until the current_window_requests became
> zero.If current_window_requests became zero,the start_next_window also
> forward. The current_window_requests will replaced by
> next_window_requests.
>=20
> There is a problem which when and how to change from NoIO2 to NoIO3.Only
> so, the sync action can forward.
>=20
> I add a filed in struct r1conf "start_next_window"..What condition will c=
hange?
> A: if start_next_window =3D=3D MaxSector, it means there are no NoIO2/3.
>    So start_next_window =3D next_resync + NEXT_NORMALIO_DISTANCE
> B: if current_window_requests =3D=3D 0 && next_window_requests !=3D 0, it
>    means start_next_window move to Pb
>=20
> There is anthor problem which how to differentiate when NoIO2 became
> NoIO3.
> For example, there are many bios which are NoIO2 and a bio which is
> NoIO3. NoIO3 firstly completed,so the bios of NoIO2 became NoIO3.
> At generil,we should use flags and list_head. The codes should:
> >list_splice_init(NoIO2, NoIO3);
> >current_window_requests =3D next_window_requests;
> >next_window_requests =3D 0;
> >list_for_each_entry(NoIO3){
> >       clear_bit(NoIO2_FLAG),
> >       set_bit(NoIO3_FLAG,
> >}
> If there are many NoIO2, it will take too long in list_for_each_entry.
> Avoid this, i add a filed in struct r1bio "start_next_window".
> I used this to record the position conf->start_next_window when call wait=
_barrier in func
> make_request.
> For NoIO1/4, the value is zero.
> In func allow_barrier, it check the conf->start_next_window
> If r1bio->stat_next_window =3D=3D conf->start_next_window,it mean
> there is no transition which NoIO2 to NoIO3.In this condtion
>  if bio->bi_sector > conf->start_next_window + NEXT_NORMALIO_DISTANCE
>     it means the bio is NoIO2;
>  else
>     it means the bio si NoIO3.
>=20
> If r1bio->start_next_window !=3D conf->start_next_window,it mean
> there is a trnasiton which NoIO2 to NoIO3.Because there is at most one
> transtions.So it only means the bio is NoIO2.
>=20
> For one bio,there are many r1bio.So we make sure the
> r1bio->start_next_window is the same value.
> If we met blocked_dev, it must call allow_barrier and wait_barrier.
> So the first and the second value of conf->start_next_window will
> change.If there are many r1bio's with differnet start_next_window.
> For the relevant bio, it depent on the last value of r1bio.
> It will cause error.To avoid this, we must wait previous r1bios completes.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c | 120 +++++++++++++++++++++++++++++++++++++++++++++++=
------
>  drivers/md/raid1.h |  14 +++++++
>  2 files changed, 121 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 08f076a..4499870 100644
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
> =20
>  	if (bio->bi_phys_segments) {
>  		unsigned long flags;
> @@ -234,6 +237,11 @@ static void call_bio_endio(struct r1bio *r1_bio)
>  		bio->bi_phys_segments--;
>  		done =3D (bio->bi_phys_segments =3D=3D 0);
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
> +		/*
> +		 * make_request might be waiting for
> +		 * bi_phys_sectors to decrease
> +		 */
> +		wake_up(&conf->wait_barrier);

bi_phys_sectors???  I think you mean bi_phys_segments.  This sort of
attention to detail is really important.



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
> @@ -827,10 +835,19 @@ static void raise_barrier(struct r1conf *conf)
>  	/* block any new IO from starting */
>  	conf->barrier++;
> =20
> -	/* Now wait for all pending IO to complete */
> +	/* For those conditions, we must wait
> +	* A:array is in frozen state.
> +	* B:conf->nr_pending > 0 mean in sync window there are normal bios.
> +	* C:total barrier are more than RESYNC_DEPTH
> +	* D:conf->next_resync + RESYNC_SECTORS > conf->start_next_window
> +	*   mean the next nornalIO window not clear and next syncIO will be into
> +	*   this window.
> +	*/

This comment is indented badly.

  /* For these conditions we must wait:
   * A: while the array is in the frozen state
   * B: while nr_pending > 0, meaning that there are normal bios in the
   *    resync window
   ...


>  	wait_event_lock_irq(conf->wait_barrier,
>  			    !conf->array_frozen &&=20
> -			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
> +			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH &&
> +			    (conf->next_resync + RESYNC_SECTORS
> +				    <=3D conf->start_next_window),

I think conditions are much more readable if the thing that you expect to
change comes first.
In this case we might need to wait until start_next_window increases, so
    conf->start_next_window >=3D conf->next_resync + RESYNC_SECTORS

as it is, it looks like you are waiting for next_resync to decrease.


>  			    conf->resync_lock);
> =20
>  	spin_unlock_irq(&conf->resync_lock);
> @@ -846,10 +863,43 @@ static void lower_barrier(struct r1conf *conf)
>  	wake_up(&conf->wait_barrier);
>  }
> =20
> -static void wait_barrier(struct r1conf *conf)
> +static bool need_to_wait_for_sync(struct r1conf *conf, struct bio *bio)
>  {
> +	bool wait =3D false;
> +
> +	if (conf->array_frozen || !bio)
> +		wait =3D true;
> +	else if (conf->barrier && bio_data_dir(bio) =3D=3D WRITE) {
> +		if (conf->next_resync < RESYNC_WINDOW_SECTORS)
> +			wait =3D true;
> +		else if (conf->next_resync - RESYNC_WINDOW_SECTORS >=3D
> +				bio_end_sector(bio))
> +			wait =3D false;
> +		else if (conf->next_resync + NEXT_NORMALIO_DISTANCE
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
> +		} else
> +			wait =3D true;
> +	}
> +
> +	return wait;
> +}

I really don't like it that this function changes start_next_window and
*_window_requests().
It looks like it is a simple function that tests a condition.  But it
actually has a side-effect as well.  And it has the side-effect when it
returns false which is extra confusing.

Also, you are incrementing *_window_requests for READ requests, which you
don't need to do.

I would change it so the below looks something like:
 if (need_to_wait_for_sync(conf, bio)) {
     ....
 } else if (bio_data_dir(bio) =3D=3D WRITE) {
    possibly update start_next_window and *_window_requests here
 }




> +
> +static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
> +{
> +	sector_t sector =3D 0;
> +
>  	spin_lock_irq(&conf->resync_lock);
> -	if (conf->barrier) {
> +	if (need_to_wait_for_sync(conf, bio)) {
>  		conf->nr_waiting++;
>  		/* Wait for the barrier to drop.
>  		 * However if there are already pending
> @@ -868,16 +918,42 @@ static void wait_barrier(struct r1conf *conf)
>  				     !bio_list_empty(current->bio_list))),
>  				    conf->resync_lock);
>  		conf->nr_waiting--;
> -	}
> +	} else if (bio_data_dir(bio) =3D=3D WRITE &&
> +			bio->bi_sector >=3D conf->start_next_window)
> +		sector =3D conf->start_next_window;
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
> @@ -1012,6 +1088,7 @@ static void make_request(struct mddev *mddev, struc=
t bio * bio)
>  	int first_clone;
>  	int sectors_handled;
>  	int max_sectors;
> +	sector_t start_next_window;
> =20
>  	/*
>  	 * Register the new request and wait if the reconstruction
> @@ -1041,7 +1118,7 @@ static void make_request(struct mddev *mddev, struc=
t bio * bio)
>  		finish_wait(&conf->wait_barrier, &w);
>  	}
> =20
> -	wait_barrier(conf);
> +	start_next_window =3D wait_barrier(conf, bio);
> =20
>  	bitmap =3D mddev->bitmap;
> =20
> @@ -1162,6 +1239,7 @@ read_again:
> =20
>  	disks =3D conf->raid_disks * 2;
>   retry_write:
> +	r1_bio->start_next_window =3D start_next_window;
>  	blocked_rdev =3D NULL;
>  	rcu_read_lock();
>  	max_sectors =3D r1_bio->sectors;
> @@ -1230,14 +1308,24 @@ read_again:
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
>  		md_wait_for_blocked_rdev(blocked_rdev, mddev);
> -		wait_barrier(conf);
> +		start_next_window =3D wait_barrier(conf, bio);
> +		/*
> +		 * We must make sure the multi r1bios of bio have
> +		 * the same value of after_threetimes_resync_sector
> +		 */

after_threetimes_resync_sector????  Attention to detail please!


If you resubmit with these things fixed up I'll try to get it reviewed quite
a bit quicker than this time :-)

Thanks,
NeilBrown



> +		if (bio->bi_phys_segments && old &&
> +			old !=3D start_next_window)
> +			/*wait the former r1bio(s) completed*/
> +			wait_event(conf->wait_barrier,
> +					bio->bi_phys_segments =3D=3D 1);
>  		goto retry_write;
>  	}
> =20
> @@ -1437,11 +1525,14 @@ static void print_conf(struct r1conf *conf)
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
> @@ -2712,6 +2803,9 @@ static struct r1conf *setup_conf(struct mddev *mdde=
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


--Sig_/QxTysC2Q8pVekdA.6nw68.6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmh9BDnsnt1WYoG5AQItrg//TB1BVbC03FrzPOUg5Dl2UCY9ry4OQkPN
4YP6jf5oyJ4YBmBp/9eEqGRutwaZKrIcBIh41rnnm9v5eyphwR1Jfi5GmbOxe7Ey
/CO9FTC6/jHxd9MWEicpHgEs1R01EZz65qAjQ0W+ouxjJ5avCfxLDfuNZzabJlBu
2LPryfBSRhRg5sKRl21ObYISiS5R2QDsET6Dd41RXCQ/CJtNBzllXetxxTVWt2NT
kLbe/ovwNgh2fHYnLU2k1YZJmKlcWiH5kT9P3UIirGlGyB6Gdggw3jWOPwCUeC0F
2JmW0VmCYEtOYsx0OVAW+sv0Zrwj2fRE3YHH+Z1256+Qo5v44+dyZ40fHmlfrhc2
5yFr6Q38JjXuSPV+sOMENQdP/11ZP0tsYYJhQkfoF0vyVM0vHtuJQZFr39RWclch
P9SfLYrMt27kn6WVhyFstc+s0L2xhLeG8Ef+0HrNfsvxdniKFL/Syuf7ecDTuSne
1q1jsoQa8pM7NpfefinlSFstY8ysztzZcGMwjT4B0TMKOGLpicpLpdcZXDEi9/st
nfo8f29AyDRjsh5ufVUUUVfX5jOQNlqEqhuiTTZtX2Sz+jjA5jCVb1s+6HUqu8ke
3xKN7yeVQwEq4vUOFmxBSwRa3flPZx+e9yGjXy8EVNiXlL9dF4GjIe5zdKAi46UB
X0KSgAG2gKY=
=LGHG
-----END PGP SIGNATURE-----

--Sig_/QxTysC2Q8pVekdA.6nw68.6--
