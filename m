From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/4] raid1: Rewrite the implementation of iobarrier.
Date: Thu, 14 Nov 2013 17:44:38 +1100
Message-ID: <20131114174438.7f2db666@notabene.brown>
References: <201308281940511854138@gmail.com>
	<20131024125059.1a440152@notabene.brown>
	<201310290930116677124@gmail.com>
	<20131031133314.522f30ad@notabene.brown>
	<201310311114307462606@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_hplwLG5iAtQAWwga4YjEtM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201310311114307462606@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/_hplwLG5iAtQAWwga4YjEtM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Oct 2013 11:20:55 +0800 majianpeng <majianpeng@gmail.com> wrote:

Sorry for the delayed reply.


> >On Tue, 29 Oct 2013 09:30:14 +0800 majianpeng <majianpeng@gmail.com> wro=
te:
> >
> >
> >Nearly there!!  Just a few more details.  See below.
> >
> >
> >> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> >> ---
> >>  drivers/md/raid1.c | 122 ++++++++++++++++++++++++++++++++++++++++++++=
+++------
> >>  drivers/md/raid1.h |  14 ++++++
> >>  2 files changed, 124 insertions(+), 12 deletions(-)
> >>=20
> >> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >> index b4a6dcd..5b311c0 100644
> >> --- a/drivers/md/raid1.c
> >> +++ b/drivers/md/raid1.c
> >> @@ -66,7 +66,8 @@
> >>   */
> >>  static int max_queued_requests =3D 1024;
> >> =20
> >> -static void allow_barrier(struct r1conf *conf);
> >> +static void allow_barrier(struct r1conf *conf, sector_t start_next_wi=
ndow,
> >> +				sector_t bi_sector);
> >>  static void lower_barrier(struct r1conf *conf);
> >> =20
> >>  static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
> >> @@ -227,6 +228,8 @@ static void call_bio_endio(struct r1bio *r1_bio)
> >>  	struct bio *bio =3D r1_bio->master_bio;
> >>  	int done;
> >>  	struct r1conf *conf =3D r1_bio->mddev->private;
> >> +	sector_t start_next_window =3D r1_bio->start_next_window;
> >> +	sector_t bi_sector =3D bio->bi_sector;
> >
> >This should  be r1_bio->sector, not bio->bi_sector.
> >They are often the same but if multiple r1_bios are needed for some reas=
on
> >(e.g. bad blocks) they may not be.
> >
> No, allow_barrier() only for bio not for r1bio.It only do when bio->bi_ph=
ys_segments =3D=3D 0.

Yes, I see that now, thanks.


> If this value is r1_bio->sector, the value may has different value as you=
 said.
> So in allow_barrier():
>        if (start_next_window) {
>                 if (start_next_window =3D=3D conf->start_next_window) {
>                         if (conf->start_next_window + NEXT_NORMALIO_DISTA=
NCE
>                                 <=3D bi_sector)
>                                 conf->next_window_requests--;
>                         else=20
>                                 conf->current_window_requests--;
>                 } else=20
> It will has differnt result.
>=20
> >> =20
> >>  	if (bio->bi_phys_segments) {
> >>  		unsigned long flags;
> >> @@ -234,6 +237,11 @@ static void call_bio_endio(struct r1bio *r1_bio)
> >>  		bio->bi_phys_segments--;
> >>  		done =3D (bio->bi_phys_segments =3D=3D 0);
> >>  		spin_unlock_irqrestore(&conf->device_lock, flags);
> >> +		/*
> >> +		 * make_request() might be waiting for
> >> +		 * bi_phys_segments to decrease
> >> +		 */
> >> +		wake_up(&conf->wait_barrier);
> >>  	} else
> >>  		done =3D 1;
> >> =20
> >> @@ -245,7 +253,7 @@ static void call_bio_endio(struct r1bio *r1_bio)
> >>  		 * Wake up any possible resync thread that waits for the device
> >>  		 * to go idle.
> >>  		 */
> >> -		allow_barrier(conf);
> >> +		allow_barrier(conf, start_next_window, bi_sector);
> >>  	}
> >>  }
> >> =20
> >> @@ -827,10 +835,18 @@ static void raise_barrier(struct r1conf *conf)
> >>  	/* block any new IO from starting */
> >>  	conf->barrier++;
> >> =20
> >> -	/* Now wait for all pending IO to complete */
> >> +	/* For those conditions we must wait:
> >> +	 * A:while the array is in frozen state
> >> +	 * B:while barrier >=3D RESYNC_DEPTH, meaning resync reach
> >> +	 *   the max count which allowed.
> >> +	 * C:next_resync + RESYNC_SECTORS > start_next_window, meaning
> >> +	 *   next resync will reach to window which normal bios are handling.
> >> +	 */
> >>  	wait_event_lock_irq(conf->wait_barrier,
> >>  			    !conf->array_frozen &&
> >> -			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
> >> +			    conf->barrier < RESYNC_DEPTH &&
> >> +			    (conf->start_next_window >=3D
> >> +			     conf->next_resync + RESYNC_SECTORS),
> >>  			    conf->resync_lock);
> >
> >You've removed the test on conf->nr_pending here, which I think is corre=
ct.
> >It counts 'read' requests as well.  Testing start_next_window serves the=
 same
> >purpose as it is increased whenever current_window_requests reaches zero.
> >
> In func wait_barrier():
>         if (need_to_wait_for_sync(conf, bio)) {
>               [snip]
>         } else if (bio_data_dir(bio) =3D=3D WRITE) {
>                 if (conf->next_resync + NEXT_NORMALIO_DISTANCE
>                                 <=3D bio->bi_sector) {
>                         if (conf->start_next_window =3D=3D MaxSector)
>                                 conf->start_next_window =3D
>                                         conf->next_resync +
>                                                 NEXT_NORMALIO_DISTANCE;
>=20
>                         if ((conf->start_next_window + NEXT_NORMALIO_DIST=
ANCE)
>                                 <=3D bio->bi_sector)
>                                 conf->next_window_requests++;
>                         else
>                                 conf->current_window_requests++;
>                 }
>                 if (bio->bi_sector >=3D conf->start_next_window)
>                         sector =3D conf->start_next_window;
>         }
> start_next_window only for bio_data_dir(bio) =3D=3D WRITE. So resync can'=
t wait read io to complete.
>=20
> >However you having modified as similar test on nr_pending in wait_barrie=
r().
I meant:       haven't modified a similar test ....
> >That worries me a bit.  Should that be changed to a test on start_next_w=
indow
> >to match the above change?
> For this condition, i only copy it.For this condition, i'm not know clear=
ly.
> Can you give me more details about this?


Before your patch we know if there are pending requests (submitted but not
completed) which stop use from doing resync if conf->nr_pending > 0.
After your patch we cannot use that that test as it counts READ requests, a=
nd
requests that are outside the range being resynced.

The test is now a bit more complicated.  I think it is:

		 conf->start_next_window <
                 conf->next_resync + RESYNC_SECTORS


i.e. while start_next_window is less than next_resync+RESYNC_SECTORS there
cold be outstanding writes that are blocking resync.  As soon as those writ=
es
complete, start_next_window will increase and the resync can complete.
So if start_next_window < next_resync+RESYNC_SECTORS and there are pending
request in current->bio_list, then then there is no point waiting for resync
(it cannot progress anyway) so we may as well submit another write.

So change:

		wait_event_lock_irq(conf->wait_barrier,
				    !conf->array_frozen &&
				    (!conf->barrier ||
				    (conf->nr_pending &&
				     current->bio_list &&
				     !bio_list_empty(current->bio_list))),
				    conf->resync_lock);

in wait barrier to

		wait_event_lock_irq(conf->wait_barrier,
				    !conf->array_frozen &&
				    (!conf->barrier ||
				    (conf->start_next_window < conf->next_resync + RESYNC_SECTORS &&
				     current->bio_list &&
				     !bio_list_empty(current->bio_list))),
				    conf->resync_lock);


> >
> >
> >> =20
> >>  	spin_unlock_irq(&conf->resync_lock);
> >> @@ -846,10 +862,33 @@ static void lower_barrier(struct r1conf *conf)
> >>  	wake_up(&conf->wait_barrier);
> >>  }
> >> =20
> >> -static void wait_barrier(struct r1conf *conf)
> >> +static bool need_to_wait_for_sync(struct r1conf *conf, struct bio *bi=
o)
> >> +{
> >> +	bool wait =3D false;
> >> +
> >> +	if (conf->array_frozen || !bio)
> >> +		wait =3D true;
> >> +	else if (conf->barrier && bio_data_dir(bio) =3D=3D WRITE) {
> >> +		if (conf->next_resync < RESYNC_WINDOW_SECTORS)
> >> +			wait =3D true;
> >> +		else if ((conf->next_resync - RESYNC_WINDOW_SECTORS
> >> +				>=3D bio_end_sector(bio)) ||
> >> +			 (conf->next_resync + NEXT_NORMALIO_DISTANCE
> >> +				<=3D bio->bi_sector))
> >> +			wait =3D false;
> >> +		else
> >> +			wait =3D true;
> >> +	}
> >> +
> >> +	return wait;
> >> +}
> >> +
> >> +static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
> >>  {
> >> +	sector_t sector =3D 0;
> >> +
> >>  	spin_lock_irq(&conf->resync_lock);
> >> -	if (conf->barrier) {
> >> +	if (need_to_wait_for_sync(conf, bio)) {
> >>  		conf->nr_waiting++;
> >>  		/* Wait for the barrier to drop.
> >>  		 * However if there are already pending
> >> @@ -868,16 +907,57 @@ static void wait_barrier(struct r1conf *conf)
> >>  				     !bio_list_empty(current->bio_list))),
> >>  				    conf->resync_lock);
> >>  		conf->nr_waiting--;
> >> +	} else if (bio_data_dir(bio) =3D=3D WRITE) {
> >> +		if (conf->next_resync + NEXT_NORMALIO_DISTANCE
> >> +				<=3D bio->bi_sector) {
> >> +			if (conf->start_next_window =3D=3D MaxSector)
> >> +				conf->start_next_window =3D
> >> +					conf->next_resync +
> >> +						NEXT_NORMALIO_DISTANCE;
> >> +
> >> +			if ((conf->start_next_window + NEXT_NORMALIO_DISTANCE)
> >> +				<=3D bio->bi_sector)
> >> +				conf->next_window_requests++;
> >> +			else
> >> +				conf->current_window_requests++;
> >> +		}
> >> +		if (bio->bi_sector >=3D conf->start_next_window)
> >> +			sector =3D conf->start_next_window;
> >
> >You aren't setting 'sector' if we needed to wait.  I don't think that is
> >correct, is it?
> >
> Yes.How about those code:
> spin_lock_irq(&conf->resync_lock);
> retry_check:
>         if (need_to_wait_for_sync(conf, bio)) {
>                 conf->nr_waiting++;
>                 /* Wait for the barrier to drop.
>                  * However if there are already pending
>                  * requests (preventing the barrier from
>                  * rising completely), and the
>                  * pre-process bio queue isn't empty,
>                  * then don't wait, as we need to empty
>                  * that queue to get the nr_pending
>                  * count down.
>                  */
>                 wait_event_lock_irq(conf->wait_barrier,
>                                     !conf->array_frozen &&
>                                     (!conf->barrier ||
>                                     (conf->nr_pending &&
>                                      current->bio_list &&
>                                      !bio_list_empty(current->bio_list))),
>                                     conf->resync_lock);
>                 conf->nr_waiting--;
> 				goto retry_check;
> >

It would look a lot better if you made it a while loop:

 while (need_to_wait....) {
     nr_waiting++
     wait_event.....
     nr_waiting--
 if (bio_data_dir.....


Thanks,
NeilBrown



> >>  	}
> >> +
> >>  	conf->nr_pending++;
> >>  	spin_unlock_irq(&conf->resync_lock);
> >> +	return sector;
> >>  }
> >> =20
> >> -static void allow_barrier(struct r1conf *conf)
> >> +static void allow_barrier(struct r1conf *conf, sector_t start_next_wi=
ndow,
> >> +				sector_t bi_sector)
> >>  {
> >>  	unsigned long flags;
> >> +
> >>  	spin_lock_irqsave(&conf->resync_lock, flags);
> >>  	conf->nr_pending--;
> >> +	if (start_next_window) {
> >> +		if (start_next_window =3D=3D conf->start_next_window) {
> >> +			if (conf->start_next_window + NEXT_NORMALIO_DISTANCE
> >> +				<=3D bi_sector)
> >> +				conf->next_window_requests--;
> >> +			else
> >> +				conf->current_window_requests--;
> >> +		} else
> >> +			conf->current_window_requests--;
> >> +
> >> +		if (!conf->current_window_requests) {
> >> +			if (conf->next_window_requests) {
> >> +				conf->current_window_requests =3D
> >> +					conf->next_window_requests;
> >> +				conf->next_window_requests =3D 0;
> >> +				conf->start_next_window +=3D
> >> +					NEXT_NORMALIO_DISTANCE;
> >> +			} else
> >> +				conf->start_next_window =3D MaxSector;
> >> +		}
> >> +	}
> >>  	spin_unlock_irqrestore(&conf->resync_lock, flags);
> >>  	wake_up(&conf->wait_barrier);
> >>  }
> >> @@ -1012,6 +1092,7 @@ static void make_request(struct mddev *mddev, st=
ruct bio * bio)
> >>  	int first_clone;
> >>  	int sectors_handled;
> >>  	int max_sectors;
> >> +	sector_t start_next_window;
> >> =20
> >>  	/*
> >>  	 * Register the new request and wait if the reconstruction
> >> @@ -1041,7 +1122,7 @@ static void make_request(struct mddev *mddev, st=
ruct bio * bio)
> >>  		finish_wait(&conf->wait_barrier, &w);
> >>  	}
> >> =20
> >> -	wait_barrier(conf);
> >> +	start_next_window =3D wait_barrier(conf, bio);
> >> =20
> >>  	bitmap =3D mddev->bitmap;
> >> =20
> >> @@ -1162,6 +1243,7 @@ read_again:
> >> =20
> >>  	disks =3D conf->raid_disks * 2;
> >>   retry_write:
> >> +	r1_bio->start_next_window =3D start_next_window;
> >>  	blocked_rdev =3D NULL;
> >>  	rcu_read_lock();
> >>  	max_sectors =3D r1_bio->sectors;
> >> @@ -1230,14 +1312,24 @@ read_again:
> >>  	if (unlikely(blocked_rdev)) {
> >>  		/* Wait for this device to become unblocked */
> >>  		int j;
> >> +		sector_t old =3D start_next_window;
> >> =20
> >>  		for (j =3D 0; j < i; j++)
> >>  			if (r1_bio->bios[j])
> >>  				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
> >>  		r1_bio->state =3D 0;
> >> -		allow_barrier(conf);
> >> +		allow_barrier(conf, start_next_window, bio->bi_sector);
> >
> >I think this should be r1_bio->sector, not bio->bi_sector, for the same
> >reason as earlier.
> >
> The exaplaination is the same at above.
>=20
> Thanks!
> Jianpeng Ma
> >
> >>  		md_wait_for_blocked_rdev(blocked_rdev, mddev);
> >> -		wait_barrier(conf);
> >> +		start_next_window =3D wait_barrier(conf, bio);
> >> +		/*
> >> +		 * We must make sure the multi r1bios of bio have
> >> +		 * the same value of bi_phys_segments
> >> +		 */
> >> +		if (bio->bi_phys_segments && old &&
> >> +			old !=3D start_next_window)
> >> +			/*wait the former r1bio(s) completed*/
> >> +			wait_event(conf->wait_barrier,
> >> +					bio->bi_phys_segments =3D=3D 1);
> >>  		goto retry_write;
> >>  	}
> >> =20
> >> @@ -1437,11 +1529,14 @@ static void print_conf(struct r1conf *conf)
> >> =20
> >>  static void close_sync(struct r1conf *conf)
> >>  {
> >> -	wait_barrier(conf);
> >> -	allow_barrier(conf);
> >> +	wait_barrier(conf, NULL);
> >> +	allow_barrier(conf, 0, 0);
> >> =20
> >>  	mempool_destroy(conf->r1buf_pool);
> >>  	conf->r1buf_pool =3D NULL;
> >> +
> >> +	conf->next_resync =3D 0;
> >> +	conf->start_next_window =3D MaxSector;
> >>  }
> >> =20
> >>  static int raid1_spare_active(struct mddev *mddev)
> >> @@ -2713,6 +2808,9 @@ static struct r1conf *setup_conf(struct mddev *m=
ddev)
> >>  	conf->pending_count =3D 0;
> >>  	conf->recovery_disabled =3D mddev->recovery_disabled - 1;
> >> =20
> >> +	conf->start_next_window =3D MaxSector;
> >> +	conf->current_window_requests =3D conf->next_window_requests =3D 0;
> >> +
> >>  	err =3D -EIO;
> >>  	for (i =3D 0; i < conf->raid_disks * 2; i++) {
> >> =20
> >> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> >> index 331a98a..07425a1 100644
> >> --- a/drivers/md/raid1.h
> >> +++ b/drivers/md/raid1.h
> >> @@ -41,6 +41,19 @@ struct r1conf {
> >>  	 */
> >>  	sector_t		next_resync;
> >> =20
> >> +	/*when raid1 start resync,we divide raid into four partitions
> >> +	 * |---------|--------------|---------------------|-------------|
> >> +	 *        next_resync   start_next_window        Pc
> >> +	 * Now start_next_window =3D next_resync + NEXT_NORMALIO_DISTANCE
> >> +	 * Pc =3D start_next_window + NEXT_NORMALIO_DISTANCE
> >> +	 * current_window_requests means the count of normalIO between
> >> +	 * start_next_window and Pc.
> >> +	 * next_window_requests means the count of nornalIO after Pc.
> >> +	 * */
> >> +	sector_t		start_next_window;
> >> +	int			current_window_requests;
> >> +	int			next_window_requests;
> >> +
> >>  	spinlock_t		device_lock;
> >> =20
> >>  	/* list of 'struct r1bio' that need to be processed by raid1d,
> >> @@ -112,6 +125,7 @@ struct r1bio {
> >>  						 * in this BehindIO request
> >>  						 */
> >>  	sector_t		sector;
> >> +	sector_t		start_next_window;
> >>  	int			sectors;
> >>  	unsigned long		state;
> >>  	struct mddev		*mddev;
> >
> >
> >Thanks,
> >NeilBrown
> >

--Sig_/_hplwLG5iAtQAWwga4YjEtM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoRxVjnsnt1WYoG5AQKsKA/7Bwj4bTSaDhSsIp8MP5mmzSkqmQivVe2u
Nz/pK5laQ1QKAwzSCm7ShWkvt2Rob3096mdzf8iWwYderlDG1XPGpTbB0OQQkhDD
XQl7+8398ygdCdDhEnjqgNMXi+QyvJS0P/SJkt9V6B8gbVyWhdheYuIkj/PwjyAL
+OrqstFg3MfG5MwspQopEfkIat7V5B/vzlcfkqAkXNMNi+BizxZvqqQgRoqJQpPT
pZrFMXgGmNjiS1mKJPAgMIYo4SAX6M9ujRMwAqTB+D8F/MQMJm0BOl+51mmB+eSO
CGsmKb1cCoWRc44hmNnYeIvsE15VOazJbpufBXIaqM070KC5hbIzYYj2OAC0ScRz
XXdfzqbEmJ4Hei3D+lT++c/INKUhOHpqCtT8ETJKZeuafLCW+uVnoQejOFObt3Nr
8P+Ba74JVVlHRVEvbBLfMEf9Mzxb3CbPcslFi6bxDg5siDNVY4ODHWzv4Cs0Rqkh
UI2DpjOEnQmDftfAYtDiWVQ8YILSrcNWZHefaziapkS+uxuNpNGljW7mktcJOB8W
c40YO2ulphpgnlyUK6/MBkC9hZ7x3whSvUZvkBQzSCLLwY9rXx56/PfhL6z+ba6E
YdASsSCmE/L10zzOMFejLKdfkblsnihKaCAqcQ4foc7bj7LecfiqNYZuf0DTK5cm
T6XYGI4Hppg=
=DfEj
-----END PGP SIGNATURE-----

--Sig_/_hplwLG5iAtQAWwga4YjEtM--
