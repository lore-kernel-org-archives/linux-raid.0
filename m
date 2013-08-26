From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] raid1: Rewrite the implementation of iobarrier.
Date: Mon, 26 Aug 2013 17:46:32 +1000
Message-ID: <20130826174632.7224da0b@notabene.brown>
References: <201308191958041664556@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zkqdCSwoEREZDYyEL0hZ3V6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201308191958041664556@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/zkqdCSwoEREZDYyEL0hZ3V6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Aug 2013 19:58:07 +0800 majianpeng <majianpeng@gmail.com> wrote:

> There is a iobarrier in raid1 because the contend between nornalIO and
> resyncIO.It suspend all nornal IO when reysync.
> But if nornal IO is outrange the resync windwos,there is no contend.
> So I rewrite the iobarrier.
>=20
> I patition the whole space into three parts.
>=20
> |---------|-----------|------------|-----------|----------
> 	     Pa 	   next_resync	   Pb	       Pc
>=20
> Firtly i introduce some concept:
> 1:RESYNC_WINDOW: For resync, there are 32 sync requests at most.A sync
> request is RESYNC_BLOCK_SIZE(64*1024).So the RESYNC_WINDOW is 32 *
> RESYNC_BLOCK_SIZE, that is 2MB.
> 2:next_resync mean the next start sector which will being do sync.
> 3:Pa means a position which before RESYNC_WINDOW distance from
> next_resync.
> 4:Pb means a position which after 3 * RESYNC_WINDOW distance from
> next_resync.
> 5:Pc means a position which after 6 * RESYNC_WINDOWS disttance from
> next_resync.
>=20
> NornalIO will be partitioned into four types.
>=20
> NoIO1: it means the end sector of bio is smaller or equal the Pa.
> NoIO2: it means the start sector of bio larger or equal Pc.
> NoIO3: it means the start sector of bio larger or equal Pb.For those
> 	tyeps, i don't care the location of end sector.
> NoIO4: it means the location between Pa and Pb.
>=20
> For NoIO1,it don't use iobarrier.
> For NoIO4,it used the original iobarrier mechanism.The nornalIO and
> syncIO must be contend.
> For NoIO2/3, i add two filed in struct r1conf "after_resync_three_count,
> after_resync_six_count".They indicate the count of
> two types.For those, they don't wait.They only add the relevant the
> counter.
>=20
> For resync action, if there are NoIO4s, it must be wait.If not,it
> forward.But if there are NoIO3,it must wait until the counter of NoIO3
> became zero.If there are NoIO2, it must wait until the counter of NoIO2
> became zero.
>=20
> There is a problem which when and how to change from NoIO2 to NoIO3.Only
> so, the sync action can forward.
>=20
> I add a filed in struct r1conf "after_resync_sector".It means the
> position Pb.What condition will change?
> A: if after_resync_sector =3D=3D MaxSector, it means there are no NoIO2/3.
>    So after_resync_sector =3D Pb.
> B: if after_resync_six_count =3D=3D 0 && after_resync_six_count !=3D 0, it
>    means after_resync_sector forward 3 * RESYNC_WINDOW.
>=20
> There is anthor problem which how to differentiate when NoIO2 became
> NoIO3.For example: firstly r1bioA is NoIO2.Before r1bioA completed,
> there is no NoIO3.So r1bioA will be became to NoIO3.
> At generil,we should use flags and list_head. The codes should:
> >list_splice_init(six_head, three_head);
> >after_reysnc_three_count =3D after_resync_six_count;
> >after_resync_six_count =3D 0;
> >list_for_each_entry(three_head){
> >	clear_bit(RESYNC_SIX_FLAG),
> >	set_bit(RESYNC_THREE_FLAG),
> >}
> If there are many NoIO2, it will take too long in list_for_each_entry.
> Avoid this, i add a filed in struct r1bio
> "after_threetimes_resync_sector".
> I used this to record the position Pb when call wait_barrier in func
> make_request.
> For NoIO1/4, the value is zero.
> In func allow_barrier, it check the conf->after_resync_sector.
> If after_threetimes_resync_sector =3D=3D conf->after_resync_sector,it mean
> there is no transition which NoIO2 to NoIO3.In this condtion
>  if bio->bi_sector > conf->after_resync_sector + 3 * RESYNC_WINWOD
>     it means the bio is NoIO2;
>  else
>     it means the bio si NoIO3.
>=20
> If after_threetimes_resync_sector !=3D conf->after_resync_sector,it mean
> there is a trnasiton which NoIO2 to NoIO3.Because there is at most one
> transtions.So it only means the bio is NoIO2.
>=20
> For one bio,there are many r1bio.So we make sure the
> r1bio->after_threetimes_resync_sector is the same value.
> If we met blocked_dev, it must call allow_barrier and wait_barrier.
> So the first and the second value of conf->after_resync_sector will
> change.If there are many r1bio's with differnet
> after_threetimes_resync_sector.For the relevant bio, it depent on the
> last value of r1bio.It will cause error.To avoid this, we must wait
> former r1bios completes.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>

Hi,
 this is certainly looking better.  I've made a number of comments below...



> ---
>  drivers/md/raid1.c | 153 +++++++++++++++++++++++++++++++++++++++++++++--=
------
>  drivers/md/raid1.h |   4 ++
>  2 files changed, 134 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 2fd74ec..92909ea 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -66,7 +66,9 @@
>   */
>  static int max_queued_requests =3D 1024;
> =20
> -static void allow_barrier(struct r1conf *conf);
> +static void allow_barrier(struct r1conf *conf,
> +				sector_t after_threetimes_resync_sector,
> +				sector_t bi_start_sector);
>  static void lower_barrier(struct r1conf *conf);
> =20
>  static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
> @@ -84,10 +86,11 @@ static void r1bio_pool_free(void *r1_bio, void *data)
>  }
> =20
>  #define RESYNC_BLOCK_SIZE (64*1024)
> -//#define RESYNC_BLOCK_SIZE PAGE_SIZE
> +#define RESYNC_DEPTH 32
>  #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
>  #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
> -#define RESYNC_WINDOW (2048*1024)
> +#define RESYNC_WINDOW (RESYNC_BLOCK_SIZE * RESYNC_DEPTH)
> +#define RESYNC_WINDOW_SECTORS (RESYNC_WINDOW >> 9)

A patch which just tidies up these #defines might be nice.  This patch is
rather large and anything that can be split into a separate patch should be=
 I
think.


> =20
>  static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
>  {
> @@ -225,13 +228,17 @@ static void call_bio_endio(struct r1bio *r1_bio)
>  	struct bio *bio =3D r1_bio->master_bio;
>  	int done;
>  	struct r1conf *conf =3D r1_bio->mddev->private;
> -
> +	unsigned long flags;

Why have you moved 'flags' from where it was to here?  There is no need so
best to leave it alone.

> +	sector_t after_threetimes_resync_sector =3D
> +		r1_bio->after_threetimes_resync_sector;
> +	sector_t bi_start_sector =3D bio->bi_sector;
> +

"after_threetimes_resync_sector" is much too long for a variable name.
And if one day I decide that 4 times resync_sectors is better, I would need
to change that name everywhere.

There are (as you describe above) two windows, each 3*resync_sectors in siz=
e.
A "current" window in which no normal writes are permitted, and a "next"
window.  "after_threetimes_resync_sector" is the send of the current window,
and the start of the next window.  So
  start_next_sync_window
would be a much better name, and is noticeably shorter.  I would probably
prefer
  start_next_window
which is quite a manageable size.
  end_current_window
would also be OK.


>  	if (bio->bi_phys_segments) {
> -		unsigned long flags;
>  		spin_lock_irqsave(&conf->device_lock, flags);
>  		bio->bi_phys_segments--;
>  		done =3D (bio->bi_phys_segments =3D=3D 0);
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
> +		wake_up(&conf->wait_barrier);

A brief comment explaining why this wake_up is needed would help.
   /* make_request might be waiting for bi_phys_sectors to decrease */


>  	} else
>  		done =3D 1;
> =20
> @@ -243,7 +250,8 @@ static void call_bio_endio(struct r1bio *r1_bio)
>  		 * Wake up any possible resync thread that waits for the device
>  		 * to go idle.
>  		 */
> -		allow_barrier(conf);
> +		allow_barrier(conf, after_threetimes_resync_sector,
> +				bi_start_sector);
>  	}
>  }
> =20
> @@ -814,8 +822,6 @@ static void flush_pending_writes(struct r1conf *conf)
>   *    there is no normal IO happeing.  It must arrange to call
>   *    lower_barrier when the particular background IO completes.
>   */
> -#define RESYNC_DEPTH 32
> -
>  static void raise_barrier(struct r1conf *conf)
>  {
>  	spin_lock_irq(&conf->resync_lock);
> @@ -826,11 +832,18 @@ static void raise_barrier(struct r1conf *conf)
> =20
>  	/* block any new IO from starting */
>  	conf->barrier++;
> -
> -	/* Now wait for all pending IO to complete */
> +	/* For those conditions, we must wait
> +	 * A:array is in freeze state.
> +	 * B:When starting resync and there are normal IO
> +	 * C:There is no nornal io after three times in resync window
> +	 * D: total barrier are less than RESYNC_DEPTH*/
>  	wait_event_lock_irq(conf->wait_barrier,
> -			    !conf->freeze_array &&=20
> -			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
> +			    !conf->freeze_array &&
> +			    ((conf->next_resync < RESYNC_WINDOW_SECTORS
> +				&& !conf->nr_pending)
> +			    || (conf->next_resync + RESYNC_SECTORS
> +				    <=3D conf->after_resync_sector))
> +			    && conf->barrier < RESYNC_DEPTH,
>  			    conf->resync_lock);

For "C:There is no nornal io after three times in resync window" I expected
to see
          conf->after_resync_three_count =3D=3D 0

but I don't see that.  Why not?


> =20
>  	spin_unlock_irq(&conf->resync_lock);
> @@ -846,10 +859,57 @@ static void lower_barrier(struct r1conf *conf)
>  	wake_up(&conf->wait_barrier);
>  }
> =20
> -static void wait_barrier(struct r1conf *conf)
> +static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
>  {
> +	sector_t sector =3D 0;
>  	spin_lock_irq(&conf->resync_lock);
> -	if (conf->barrier) {
> +	if (conf->barrier || unlikely(conf->freeze_array)) {
> +		if (unlikely(!conf->freeze_array && bio) &&
> +			bio_data_dir(bio) =3D=3D WRITE &&
> +			conf->next_resync > RESYNC_WINDOW_SECTORS) {
> +			if (bio_end_sector(bio) <=3D conf->next_resync -
> +				RESYNC_WINDOW_SECTORS)
> +				goto no_wait;
> +			if (conf->after_resync_sector =3D=3D MaxSector) {
> +				if (bio->bi_sector >=3D conf->next_resync +
> +					6 * RESYNC_WINDOW_SECTORS) {
> +					if (conf->after_resync_six_count +
> +						conf->after_resync_three_count =3D=3D 0)
> +						conf->after_resync_sector =3D
> +							conf->next_resync + 3 *
> +							RESYNC_WINDOW_SECTORS;
> +					conf->after_resync_six_count++;
> +					sector =3D conf->after_resync_sector;
> +					goto no_wait;
> +				}
> +				if (bio->bi_sector >=3D conf->next_resync +
> +					3 * RESYNC_WINDOW_SECTORS) {
> +					if (conf->after_resync_six_count +
> +						conf->after_resync_three_count =3D=3D 0)
> +						conf->after_resync_sector =3D
> +							conf->next_resync + 3 *
> +							RESYNC_WINDOW_SECTORS;
> +					conf->after_resync_three_count++;
> +					sector =3D conf->after_resync_sector;
> +					goto no_wait;
> +				}
> +
> +			} else {
> +				if (bio->bi_sector >=3D conf->after_resync_sector + 3 *
> +							RESYNC_WINDOW_SECTORS) {
> +					conf->after_resync_six_count++;
> +					sector =3D conf->after_resync_sector;
> +					goto no_wait;
> +				}
> +				if (bio->bi_sector >=3D conf->after_resync_sector) {
> +					conf->after_resync_three_count++;
> +					sector =3D conf->after_resync_sector;
> +					goto no_wait;
> +				}
> +			}
> +		} else if (unlikely(!conf->freeze_array && bio) &&
> +				bio_data_dir(bio) !=3D WRITE)
> +			goto no_wait;

This is really long set of nested conditions that is probably more complex
than needed, and certainly should be in a separate function.
Then you could have something like:
   if (need_to_wait_for_sync(...) {
        conf->nr_waiting++
        wait.....
        conf->nr_waiting--;
   }

and not need the "no_wait" label.

I suspect there should only be one place in the function which does
after_resync_three_count++ and one for after_resync_six_count++;

And they should be something like
   current_window_requests
and
   next_window_requests.

>  		conf->nr_waiting++;
>  		/* Wait for the barrier to drop.
>  		 * However if there are already pending
> @@ -869,15 +929,46 @@ static void wait_barrier(struct r1conf *conf)
>  				    conf->resync_lock);
>  		conf->nr_waiting--;
>  	}
> +no_wait:
>  	conf->nr_pending++;
>  	spin_unlock_irq(&conf->resync_lock);
> +	return sector;
>  }
> =20
> -static void allow_barrier(struct r1conf *conf)
> +static void

Please avoid this sort of unnecessary change.  Leave "allow_barrier" on the
same line as "static void".

> +allow_barrier(struct r1conf *conf,
> +		sector_t after_threetimes_resync_sector,
> +		sector_t bi_start_sector)
>  {
>  	unsigned long flags;
>  	spin_lock_irqsave(&conf->resync_lock, flags);
>  	conf->nr_pending--;
> +
> +	if (after_threetimes_resync_sector) {
> +		if (after_threetimes_resync_sector =3D=3D
> +				conf->after_resync_sector) {
> +			if (bi_start_sector >=3D (after_threetimes_resync_sector
> +						+ 3 * RESYNC_WINDOW_SECTORS))
> +				conf->after_resync_six_count--;
> +			else
> +				conf->after_resync_three_count--;
> +		} else
> +			conf->after_resync_three_count--;
> +
> +		if (!conf->after_resync_three_count) {
> +			if (conf->after_resync_six_count) {
> +				conf->after_resync_three_count =3D
> +					conf->after_resync_six_count;
> +				conf->after_resync_six_count =3D 0;
> +				conf->after_resync_sector +=3D
> +					3 * RESYNC_WINDOW_SECTORS;
> +			} else
> +				conf->after_resync_sector =3D MaxSector;
> +		}
> +		BUG_ON(conf->after_resync_three_count < 0 ||
> +			conf->after_resync_six_count < 0);
> +	}
> +
>  	spin_unlock_irqrestore(&conf->resync_lock, flags);
>  	wake_up(&conf->wait_barrier);
>  }
> @@ -908,8 +999,8 @@ static void unfreeze_array(struct r1conf *conf)
>  	/* reverse the effect of the freeze */
>  	spin_lock_irq(&conf->resync_lock);
>  	conf->freeze_array =3D 0;
> -	wake_up(&conf->wait_barrier);
>  	spin_unlock_irq(&conf->resync_lock);
> +	wake_up(&conf->wait_barrier);

This seems unnecessary, so should not be here.  Is there a reason you made
this change?

>  }
> =20
> =20
> @@ -1012,6 +1103,7 @@ static void make_request(struct mddev *mddev, struc=
t bio * bio)
>  	int first_clone;
>  	int sectors_handled;
>  	int max_sectors;
> +	sector_t after_threetimes_resync_sector =3D 0;
> =20
>  	/*
>  	 * Register the new request and wait if the reconstruction
> @@ -1041,7 +1133,7 @@ static void make_request(struct mddev *mddev, struc=
t bio * bio)
>  		finish_wait(&conf->wait_barrier, &w);
>  	}
> =20
> -	wait_barrier(conf);
> +	after_threetimes_resync_sector =3D wait_barrier(conf, bio);
> =20
>  	bitmap =3D mddev->bitmap;
> =20
> @@ -1057,7 +1149,6 @@ static void make_request(struct mddev *mddev, struc=
t bio * bio)
>  	r1_bio->state =3D 0;
>  	r1_bio->mddev =3D mddev;
>  	r1_bio->sector =3D bio->bi_sector;
> -

Don't delete blanks lines unnecessarily.

>  	/* We might need to issue multiple reads to different
>  	 * devices if there are bad blocks around, so we keep
>  	 * track of the number of reads in bio->bi_phys_segments.
> @@ -1162,6 +1253,8 @@ read_again:
> =20
>  	disks =3D conf->raid_disks * 2;
>   retry_write:
> +	r1_bio->after_threetimes_resync_sector =3D after_threetimes_resync_sect=
or;
> +
>  	blocked_rdev =3D NULL;
>  	rcu_read_lock();
>  	max_sectors =3D r1_bio->sectors;
> @@ -1230,14 +1323,23 @@ read_again:
>  	if (unlikely(blocked_rdev)) {
>  		/* Wait for this device to become unblocked */
>  		int j;
> -
> +		sector_t old =3D after_threetimes_resync_sector;

Please keep a blank line between variable declarations and code.


>  		for (j =3D 0; j < i; j++)
>  			if (r1_bio->bios[j])
>  				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
>  		r1_bio->state =3D 0;
> -		allow_barrier(conf);
> +		allow_barrier(conf, old, bio->bi_sector);
>  		md_wait_for_blocked_rdev(blocked_rdev, mddev);
> -		wait_barrier(conf);
> +		after_threetimes_resync_sector =3D wait_barrier(conf, bio);
> +		/*
> +		 * We must make sure the multi r1bios of bio have
> +		 * the same value of after_threetimes_resync_sector
> +		 */
> +		if (bio->bi_phys_segments && old &&
> +			old !=3D after_threetimes_resync_sector)
> +			/*wait the former r1bio(s) completed*/
> +			wait_event(conf->wait_barrier,
> +					bio->bi_phys_segments =3D=3D 1);

I think it is quite possible that bi_phys_segments=3D=3D0 at this point.
So you probably want "<=3D 1".

>  		goto retry_write;
>  	}
> =20
> @@ -1437,11 +1539,13 @@ static void print_conf(struct r1conf *conf)
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
> +	conf->next_resync =3D 0;
> +	conf->after_resync_sector =3D conf->mddev->dev_sectors;
>  }
> =20
>  static int raid1_spare_active(struct mddev *mddev)
> @@ -2712,6 +2816,9 @@ static struct r1conf *setup_conf(struct mddev *mdde=
v)
>  	conf->pending_count =3D 0;
>  	conf->recovery_disabled =3D mddev->recovery_disabled - 1;
> =20
> +	conf->after_resync_sector =3D MaxSector;
> +	conf->after_resync_six_count =3D conf->after_resync_three_count =3D 0;
> +
>  	err =3D -EIO;
>  	for (i =3D 0; i < conf->raid_disks * 2; i++) {
> =20
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index 8afd300..3ab1405 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -40,6 +40,9 @@ struct r1conf {
>  	 * where that is.
>  	 */
>  	sector_t		next_resync;
> +	sector_t		after_resync_sector;
> +	int			after_resync_three_count;
> +	int			after_resync_six_count;
> =20
>  	spinlock_t		device_lock;
> =20
> @@ -112,6 +115,7 @@ struct r1bio {
>  						 * in this BehindIO request
>  						 */
>  	sector_t		sector;
> +	sector_t		after_threetimes_resync_sector;
>  	int			sectors;
>  	unsigned long		state;
>  	struct mddev		*mddev;

Thanks,
NeilBrown

--Sig_/zkqdCSwoEREZDYyEL0hZ3V6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhsH2Dnsnt1WYoG5AQLphA//UnIX9pGOUadMkkW3UduJaa9WPb+oSNFi
ydQSIwMo0wL58lSxNV1rm39Hvubp+2WpdcFmE+EA8BReJb3iX8DQwi6+qRo0hVr2
r1x1qQPP/aZ4LFoOmPoB4RWBK8HFgab9uumafwGqsWStE8Zzrzddu4frym5S6/jw
i5sxEbn/y174LYjrLE+0JzKRNnGf9Gdyc7OHw8TMe9YSLJP+2wxxfXGoBnJCgzek
2B/T0gByd+YzjOLoNgD4PBqgdV5SOhc8tpKoPiRkFH+KF56G7IqwjWQ7mVLS/cHw
Sm/aKMt5riWiqG8YIuXtgQCf5YRPNMZ2YPcNY3kQM9CrX8nCEhNGTMTU06+5gbQL
y3C50W51GLQHkXlHmoELZ0k8SfBFh6qFx+iuWw6iIdMvlvZChjKH+Tyk8vkdZweK
Rx3vyiS1r98RKGRo7N7BVBVAdPj4psbDnkkxNY04SOd3l1M0CKGfqNOKf56dqg63
Pg8JOVyl75bqh0bA+mpn2Ofr/fBqrcOnl7KvqoANQxJzENCpxL0Jr04qCyXD9bYF
rsS2G+RPGaQp2EdF9bbxp6MmBa2Zmyfcmge3SHq7pwhINXn20nzTeF6o0OY0fGbG
Gung7Gh3sNjsFqOL7FCf5Ujv5iYgFllUD7ltum+kCrImGAc+OKkPzDdm2QsvYdq1
5ICMr4ym2Gs=
=BvVz
-----END PGP SIGNATURE-----

--Sig_/zkqdCSwoEREZDYyEL0hZ3V6--
