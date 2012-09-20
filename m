From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/2]MD: raid5 trim support
Date: Thu, 20 Sep 2012 11:15:17 +1000
Message-ID: <20120920111517.54d05380@notabene.brown>
References: <20120918082511.GA6298@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1+o+_vcDV3zYyQLbMZB/pzG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120918082511.GA6298@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1+o+_vcDV3zYyQLbMZB/pzG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Sep 2012 16:25:11 +0800 Shaohua Li <shli@kernel.org> wrote:

> Discard for raid4/5/6 has limitation. If discard request size is small, w=
e do
> discard for one disk, but we need calculate parity and write parity disk.=
  To
> correctly calculate parity, zero_after_discard must be guaranteed. Even i=
t's
> true, we need do discard for one disk but write another disks, which make=
s the
> parity disks wear out fast. This doesn't make sense. So an efficient disc=
ard
> for raid4/5/6 should discard all data disks and parity disks, which requi=
res
> the write pattern to be (A, A+chunk_size, A+chunk_size*2...). If A's size=
 is
> smaller than chunk_size, such pattern is almost impossible in practice. S=
o in
> this patch, I only handle the case that A's size equals to chunk_size. Th=
at is
> discard request should be aligned to stripe size and its size is multiple=
 of
> stripe size.
>=20
> Since we can only handle request with specific alignment and size (or par=
t of
> the request fitting stripes), we can't guarantee zero_after_discard even
> zero_after_discard is true in low level drives.
>=20
> The block layer doesn't send down correctly aligned requests even correct
> discard alignment is set, so I must filter out.
>=20
> For raid4/5/6 parity calculation, if data is 0, parity is 0. So if
> zero_after_discard is true for all disks, data is consistent after discar=
d.
> Otherwise, data might be lost. Let's consider a scenario: discard a strip=
e,
> write data to one disk and write parity disk. The stripe could be still
> inconsistent till then depending on using data from other data disks or p=
arity
> disks to calculate new parity. If the disk is broken, we can't restore it=
. So
> in this patch, we only enable discard support if all disks have
> zero_after_discard.
>=20
> If discard fails in one disk, we face the similar inconsistent issue abov=
e. The
> patch will make discard follow the same path as normal write request. If
> discard fails, a resync will be scheduled to make the data consistent. Th=
is
> isn't good to have extra writes, but data consistency is important.
>=20
> If a subsequent read/write request hits raid5 cache of a discarded stripe=
, the
> discarded dev page should have zero filled, so the data is consistent. Th=
is
> patch will always zero dev page for discarded request stripe. This isn't
> optimal because discard request doesn't need such payload. Next patch will
> avoid it.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |  176 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++-
>  drivers/md/raid5.h |    1=20
>  2 files changed, 174 insertions(+), 3 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-09-18 16:15:51.219353357 +0800
> +++ linux/drivers/md/raid5.c	2012-09-18 16:15:55.471299904 +0800
> @@ -547,6 +547,8 @@ static void ops_run_io(struct stripe_hea
>  				rw =3D WRITE_FUA;
>  			else
>  				rw =3D WRITE;
> +			if (test_and_clear_bit(R5_Discard, &sh->dev[i].flags))
> +				rw |=3D REQ_DISCARD;
>  		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
>  			rw =3D READ;
>  		else if (test_and_clear_bit(R5_WantReplace,
> @@ -1170,8 +1172,13 @@ ops_run_biodrain(struct stripe_head *sh,
>  					set_bit(R5_WantFUA, &dev->flags);
>  				if (wbi->bi_rw & REQ_SYNC)
>  					set_bit(R5_SyncIO, &dev->flags);
> -				tx =3D async_copy_data(1, wbi, dev->page,
> -					dev->sector, tx);
> +				if (wbi->bi_rw & REQ_DISCARD) {
> +					memset(page_address(dev->page), 0,
> +						STRIPE_SECTORS << 9);
> +					set_bit(R5_Discard, &dev->flags);
> +				} else
> +					tx =3D async_copy_data(1, wbi, dev->page,
> +						dev->sector, tx);
>  				wbi =3D r5_next_bio(wbi, dev->sector);
>  			}
>  		}
> @@ -1237,6 +1244,20 @@ ops_run_reconstruct5(struct stripe_head
>  	pr_debug("%s: stripe %llu\n", __func__,
>  		(unsigned long long)sh->sector);
> =20
> +	for (i =3D 0; i < sh->disks; i++) {
> +		if (pd_idx =3D=3D i)
> +			continue;
> +		if (!test_bit(R5_Discard, &sh->dev[i].flags))
> +			break;
> +	}
> +	if (i >=3D sh->disks) {
> +		atomic_inc(&sh->count);
> +		memset(page_address(sh->dev[pd_idx].page), 0,
> +			STRIPE_SECTORS << 9);
> +		set_bit(R5_Discard, &sh->dev[pd_idx].flags);
> +		ops_complete_reconstruct(sh);
> +		return;
> +	}
>  	/* check if prexor is active which means only process blocks
>  	 * that are part of a read-modify-write (written)
>  	 */
> @@ -1281,10 +1302,28 @@ ops_run_reconstruct6(struct stripe_head
>  {
>  	struct async_submit_ctl submit;
>  	struct page **blocks =3D percpu->scribble;
> -	int count;
> +	int count, i;
> =20
>  	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
> =20
> +	for (i =3D 0; i < sh->disks; i++) {
> +		if (sh->pd_idx =3D=3D i || sh->qd_idx =3D=3D i)
> +			continue;
> +		if (!test_bit(R5_Discard, &sh->dev[i].flags))
> +			break;
> +	}
> +	if (i >=3D sh->disks) {
> +		atomic_inc(&sh->count);
> +		memset(page_address(sh->dev[sh->pd_idx].page), 0,
> +			STRIPE_SECTORS << 9);
> +		memset(page_address(sh->dev[sh->qd_idx].page), 0,
> +			STRIPE_SECTORS << 9);
> +		set_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
> +		set_bit(R5_Discard, &sh->dev[sh->qd_idx].flags);
> +		ops_complete_reconstruct(sh);
> +		return;
> +	}
> +
>  	count =3D set_syndrome_sources(blocks, sh);
> =20
>  	atomic_inc(&sh->count);
> @@ -4067,6 +4106,96 @@ static void release_stripe_plug(struct m
>  		release_stripe(sh);
>  }
> =20
> +static void make_discard_request(struct mddev *mddev, struct bio *bi)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +	sector_t logical_sector, last_sector;
> +	struct stripe_head *sh;
> +	int remaining;
> +	int stripe_sectors;
> +
> +	if (mddev->reshape_position !=3D MaxSector)
> +		/* Skip discard while reshape is happening */
> +		return;
> +
> +	logical_sector =3D bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
> +	last_sector =3D bi->bi_sector + (bi->bi_size>>9);
> +
> +	bi->bi_next =3D NULL;
> +	bi->bi_phys_segments =3D 1; /* over-loaded to count active stripes */
> +
> +	stripe_sectors =3D conf->chunk_sectors *
> +		(conf->raid_disks - conf->max_degraded);
> +	logical_sector =3D DIV_ROUND_UP_SECTOR_T(logical_sector,
> +			stripe_sectors);
> +	sector_div(last_sector, stripe_sectors);
> +
> +	logical_sector *=3D stripe_sectors;
> +	last_sector *=3D stripe_sectors;
> +
> +	for (;logical_sector < last_sector;
> +					logical_sector +=3D STRIPE_SECTORS) {
> +		DEFINE_WAIT(w);
> +		sector_t new_sector;
> +		int d;
> +
> +		new_sector =3D raid5_compute_sector(conf, logical_sector,
> +						  0, &d, NULL);

This is pointless.  Look at the patch I posted again.  You don't need to ca=
ll
raid5_compute_sector().  It essentially just divides logical_sector by
stripe_sectors.  It is cleaner not to do the multiple in the first place.

NeilBrown


> +again:
> +		sh =3D get_active_stripe(conf, new_sector, 0, 0, 0);
> +		prepare_to_wait(&conf->wait_for_overlap, &w,
> +						TASK_UNINTERRUPTIBLE);
> +		spin_lock_irq(&sh->stripe_lock);
> +		for (d =3D 0; d < conf->raid_disks; d++) {
> +			if (d =3D=3D sh->pd_idx || d =3D=3D sh->qd_idx)
> +				continue;
> +			if (sh->dev[d].towrite || sh->dev[d].toread) {
> +				set_bit(R5_Overlap, &sh->dev[d].flags);
> +				spin_unlock_irq(&sh->stripe_lock);
> +				release_stripe(sh);
> +				schedule();
> +				goto again;
> +			}
> +		}
> +		finish_wait(&conf->wait_for_overlap, &w);
> +		for (d =3D 0; d < conf->raid_disks; d++) {
> +			if (d =3D=3D sh->pd_idx || d =3D=3D sh->qd_idx)
> +				continue;
> +			sh->dev[d].towrite =3D bi;
> +			set_bit(R5_OVERWRITE, &sh->dev[d].flags);
> +			raid5_inc_bi_active_stripes(bi);
> +		}
> +		spin_unlock_irq(&sh->stripe_lock);
> +		if (conf->mddev->bitmap) {
> +			for (d =3D 0; d < conf->raid_disks - conf->max_degraded;
> +									d++)
> +				bitmap_startwrite(mddev->bitmap,
> +						sh->sector,
> +						STRIPE_SECTORS,
> +						0);
> +			sh->bm_seq =3D conf->seq_flush + 1;
> +			set_bit(STRIPE_BIT_DELAY, &sh->state);
> +		}
> +
> +		set_bit(STRIPE_HANDLE, &sh->state);
> +		clear_bit(STRIPE_DELAYED, &sh->state);
> +		if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> +			atomic_inc(&conf->preread_active_stripes);
> +		release_stripe_plug(mddev, sh);
> +
> +		new_sector =3D logical_sector + STRIPE_SECTORS;
> +		if (!sector_div(new_sector, conf->chunk_sectors))
> +			logical_sector +=3D conf->chunk_sectors *
> +				(conf->raid_disks - conf->max_degraded - 1);
> +	}
> +
> +	remaining =3D raid5_dec_bi_active_stripes(bi);
> +	if (remaining =3D=3D 0) {
> +		md_write_end(mddev);
> +		bio_endio(bi, 0);
> +	}
> +}
> +
>  static void make_request(struct mddev *mddev, struct bio * bi)
>  {
>  	struct r5conf *conf =3D mddev->private;
> @@ -4089,6 +4218,11 @@ static void make_request(struct mddev *m
>  	     chunk_aligned_read(mddev,bi))
>  		return;
> =20
> +	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
> +		make_discard_request(mddev, bi);
> +		return;
> +	}
> +
>  	logical_sector =3D bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
>  	last_sector =3D bi->bi_sector + (bi->bi_size>>9);
>  	bi->bi_next =3D NULL;
> @@ -5361,6 +5495,7 @@ static int run(struct mddev *mddev)
> =20
>  	if (mddev->queue) {
>  		int chunk_size;
> +		bool discard_supported =3D true;
>  		/* read-ahead size must cover two whole stripes, which
>  		 * is 2 * (datadisks) * chunksize where 'n' is the
>  		 * number of raid devices
> @@ -5380,13 +5515,48 @@ static int run(struct mddev *mddev)
>  		blk_queue_io_min(mddev->queue, chunk_size);
>  		blk_queue_io_opt(mddev->queue, chunk_size *
>  				 (conf->raid_disks - conf->max_degraded));
> +		/*
> +		 * We can only discard a whole stripe. It doesn't make sense to
> +		 * discard data disk but write parity disk
> +		 */
> +		stripe =3D stripe * PAGE_SIZE;
> +		mddev->queue->limits.discard_alignment =3D stripe;
> +		mddev->queue->limits.discard_granularity =3D stripe;
> +		/*
> +		 * unaligned part of discard request will be ignored, so can't
> +		 * guarantee discard_zerors_data
> +		 */
> +		mddev->queue->limits.discard_zeroes_data =3D 0;
> =20
>  		rdev_for_each(rdev, mddev) {
>  			disk_stack_limits(mddev->gendisk, rdev->bdev,
>  					  rdev->data_offset << 9);
>  			disk_stack_limits(mddev->gendisk, rdev->bdev,
>  					  rdev->new_data_offset << 9);
> +			/*
> +			 * discard_zeroes_data is required, otherwise data
> +			 * could be lost. Consider a scenario: discard a stripe
> +			 * (the stripe could be inconsistent if
> +			 * discard_zeroes_data is 0); write one disk of the
> +			 * stripe (the stripe could be inconsistent again
> +			 * depending on which disks are used to calculate
> +			 * parity); the disk is broken; The stripe data of this
> +			 * disk is lost.
> +			 */
> +			if (!blk_queue_discard(bdev_get_queue(rdev->bdev)) ||
> +			    !bdev_get_queue(rdev->bdev)->
> +						limits.discard_zeroes_data)
> +				discard_supported =3D false;
>  		}
> +
> +		if (discard_supported &&
> +		   mddev->queue->limits.max_discard_sectors >=3D stripe &&
> +		   mddev->queue->limits.discard_granularity >=3D stripe)
> +			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
> +						mddev->queue);
> +		else
> +			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD,
> +						mddev->queue);
>  	}
> =20
>  	return 0;
> Index: linux/drivers/md/raid5.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.h	2012-09-18 16:15:51.235353157 +0800
> +++ linux/drivers/md/raid5.h	2012-09-18 16:15:55.471299904 +0800
> @@ -298,6 +298,7 @@ enum r5dev_flags {
>  	R5_WantReplace, /* We need to update the replacement, we have read
>  			 * data in, and now is a good time to write it out.
>  			 */
> +	R5_Discard,	/* Discard the stripe */
>  };
> =20
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/1+o+_vcDV3zYyQLbMZB/pzG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFpuJTnsnt1WYoG5AQKByg//abAnwoL6QbjqiV0l1JqYu4pQtfxAaFhA
8olJnIXLBsamb0TbZw1xTaqxyxCdIEo2FhY6srvImtgJRqmeAvb3wp6moxLsaSc6
0OxfpQVF0ckFztHhWo1XpWTPI+d9UxJgzxDbN2gc/2B83HcQZvuTw62IVQElTuud
XDf8ZljY7hPmOeEpsxCxV58e+PymhaXqwiVOz79Aj+6geklOS4JYbzN05yFAiCDT
WndZyFeTbtEIsFQeDoY0qYwwKtF8kzKTqlKk3DL5g+u6nHxS7apOBh+hI/102LXO
HIagRoAOUk6i4DftCDxRfWW9ceGdCRSUpKFgCZd7IkuZ6o5IJ5NYXExk+cK5GZj+
0H/huML+rNn4jP+8fLCOBZEuAf4KAuhXsY9fFEfoXCDxdTu9++4Qw6xYsviCRkUs
DjcMp2PZQocMXFJbCM/eYcy+uAuU4vpFTxu61NFYlFpA37PJA9ifwdMO24lufXjT
xmZ8sLLwjImqmYFTiwJ8HPImU7boBt6mcJ/0GkpvQMQZUUTWNmUuSzn4aj2k7bT6
u859ZhozrnwheWRUC5YEs/peNu6hP+iB+fA9W9idEP+dYqTxfRNYZav3GfYU2gDf
4YUGhd+omi2hCJQ4MR0VdwpGnKeKYDgAk+eyBqWkWyWyiMgF22bfOES563s+mx1C
yYDEr4We5Is=
=27Ai
-----END PGP SIGNATURE-----

--Sig_/1+o+_vcDV3zYyQLbMZB/pzG--
