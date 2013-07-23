From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2 v2] md: set write-intent bit first in sync-bitmap
 for rwm in non-insync region.
Date: Tue, 23 Jul 2013 15:36:21 +1000
Message-ID: <20130723153621.3f7e0eac@notabene.brown>
References: <1374473271-18551-1-git-send-email-robin.k.dong@gmail.com>
	<1374473271-18551-2-git-send-email-robin.k.dong@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DMOr/IKDPvs.ugWwC1njiDi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374473271-18551-2-git-send-email-robin.k.dong@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/DMOr/IKDPvs.ugWwC1njiDi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Jul 2013 14:07:51 +0800 Robin Dong <robin.k.dong@gmail.com> wrot=
e:

> From: Robin Dong <sanbai@taobao.com>
>=20
> If part of the RAID456 array is not in sync, then a read-modify-write cyc=
le will
> update incorrect parity to new incorrect parity.  If you subsequently get=
 a
> drive failure, any data on that drive in the not-in-sync region will be l=
ost.
>=20
> To avoid this, we:
>  1. In first bitmap_endwrite to a not-in-sync region, set the write-inten=
t bit and
>     wake up resync thread.
>  2. When resync finishes, set the sync bit and clear write-intent bit.
>=20
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> Cc: NeilBrown <neilb@suse.de>
> ---
>  drivers/md/bitmap.c |   51 +++++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  drivers/md/bitmap.h |    2 ++
>  drivers/md/raid5.c  |   11 +++++++++++
>  3 files changed, 63 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 0d894af..b4967c4 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1447,6 +1447,24 @@ int bitmap_startwrite(struct bitmap *bitmap, secto=
r_t offset, unsigned long sect
>  }
>  EXPORT_SYMBOL(bitmap_startwrite);
> =20
> +void syncbitmap_endwrite(struct bitmap *bitmap, sector_t offset,
> +		bitmap_counter_t *bmc)
> +{
> +	struct mddev *mddev =3D bitmap->mddev;
> +
> +	if (mddev->level >=3D 4 &&
> +	    offset > mddev->curr_resync_completed) {
> +		*bmc |=3D NEEDED_MASK;
> +		if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> +			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> +			md_wakeup_thread(mddev->sync_thread);
> +			sysfs_notify_dirent_safe(mddev->sysfs_action);
> +		}
> +	} else
> +		syncbitmap_file_set_bit(bitmap, offset);
> +}
> +

I don't like the test for "level >=3D 4" here.
This would cause RAID10 to be treated differently to RAID1 and that isn't
right.

Can we just have the raid personality pass a flag (or maybe set a flag in
bitmap_info) to say if it wants auto-resync or not?


>  void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned lo=
ng sectors,
>  		     int success, int behind)
>  {
> @@ -1479,7 +1497,8 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_=
t offset, unsigned long secto
>  			sysfs_notify_dirent_safe(bitmap->sysfs_can_clear);
>  		}
> =20
> -		syncbitmap_file_set_bit(bitmap, offset);
> +		if (bitmap->mddev->bitmap_info.sync_bitmap)
> +			syncbitmap_endwrite(bitmap, offset, bmc);
> =20
>  		if (!success && !NEEDED(*bmc))
>  			*bmc |=3D NEEDED_MASK;
> @@ -1502,6 +1521,36 @@ void bitmap_endwrite(struct bitmap *bitmap, sector=
_t offset, unsigned long secto
>  }
>  EXPORT_SYMBOL(bitmap_endwrite);
> =20
> +void bitmap_in_synced(struct bitmap *bitmap, sector_t offset,
> +				unsigned long sectors)
> +{
> +	while (sectors) {
> +		sector_t blocks;
> +		unsigned long flags;
> +		bitmap_counter_t *bmc;
> +
> +		spin_lock_irqsave(&bitmap->counts.lock, flags);
> +		bmc =3D bitmap_get_counter(&bitmap->counts, offset, &blocks, 0);
> +		if (!bmc) {
> +			spin_unlock_irqrestore(&bitmap->counts.lock, flags);
> +			return;
> +		}
> +
> +		if (NEEDED(*bmc) || (!NEEDED(*bmc) && RESYNC(*bmc))) {
> +			*bmc &=3D ~NEEDED_MASK;
> +			syncbitmap_file_set_bit(bitmap, offset);
> +		}
> +
> +		spin_unlock_irqrestore(&bitmap->counts.lock, flags);
> +		offset +=3D blocks;
> +		if (sectors > blocks)
> +			sectors -=3D blocks;
> +		else
> +			sectors =3D 0;
> +	}
> +}
> +EXPORT_SYMBOL(bitmap_in_synced);

This function is confusing me.  (maybe a comment at the top to explain it
would help???)

I think to get clarity we need a clear statement of which bitmap has priori=
ty.

I would expect:

 write-intent   sync bitmap     meaning
    0               0           chunk is unused.  No data here.
    0               1           chunk is clean and in sync. data is safe.
    1               0           Data might be here, full sync is needed.
    1               1           Data is here, full sync is needed.

So the syncbitmap bit can safely be set when the write-intent bit is set, b=
ut
must be set before it is cleared.

So I would always set the syncbitmap bit when setting the write-intent bit
(so the "1  0" row never exists).  For RAID5 if the syncbitmap bit wasn't s=
et,
set set the NEEDED_MASK at the same time and trigger a resync.  Then the=20
write-intent bit will not get cleared until the resync has happened.
So this special clearing of the NEEDED_MASK should not be needed.

Does that make sense?


Thanks,
NeilBrown



> +
>  static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, s=
ector_t *blocks,
>  			       int degraded)
>  {
> diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
> index ddc30da..6d22d8b 100644
> --- a/drivers/md/bitmap.h
> +++ b/drivers/md/bitmap.h
> @@ -253,6 +253,8 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t=
 offset,
>  			unsigned long sectors, int behind);
>  void bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
>  			unsigned long sectors, int success, int behind);
> +void bitmap_in_synced(struct bitmap *bitmap, sector_t offset,
> +			unsigned long sectors);
>  int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *=
blocks, int degraded);
>  void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *b=
locks, int aborted);
> =20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2bf094a..bb7de94 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3622,6 +3622,8 @@ static void handle_stripe(struct stripe_head *sh)
>  	if ((s.syncing || s.replacing) && s.locked =3D=3D 0 &&
>  	    test_bit(STRIPE_INSYNC, &sh->state)) {
>  		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
> +		bitmap_in_synced(conf->mddev->bitmap, sh->sector,
> +			STRIPE_SECTORS);
>  		clear_bit(STRIPE_SYNCING, &sh->state);
>  		if (test_and_clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags))
>  			wake_up(&conf->wait_for_overlap);
> @@ -4690,6 +4692,15 @@ static inline sector_t sync_request(struct mddev *=
mddev, sector_t sector_nr, int
>  		return sync_blocks * STRIPE_SECTORS; /* keep things rounded to whole s=
tripes */
>  	}
> =20
> +	if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
> +	    conf->fullsync &&
> +	    !syncbitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks) &&
> +	    sync_blocks >=3D STRIPE_SECTORS) {
> +		sync_blocks /=3D STRIPE_SECTORS;
> +		*skipped =3D 1;
> +		return sync_blocks * STRIPE_SECTORS;
> +	}
> +
>  	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
> =20
>  	sh =3D get_active_stripe(conf, sector_nr, 0, 1, 0);


--Sig_/DMOr/IKDPvs.ugWwC1njiDi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUe4WVTnsnt1WYoG5AQJTXw//fgBC9js11tGztIbqBw3lSOGHjDtUydY5
D7W9k6jIMqCuk+78NCprpNPfy8Lfki7iEGZ2zsi6xCu0yvbJGhMux6Ubshr8Riga
RC5D4iy4jripcYuTS+3JSvSKoPkxwQPIXRCIdFupeDxESzEZuyCbU8j8e06In8dW
p1PJu4n+CbJwwg+egV0Gqq1+Yw4x5JMWpUWEZLdHj4aZe3EqdlOeGTCHyu1YFe7u
jSXJHSZYOaV7/NLIh9tZ0NqueESkOE5BvcMLkNMc0hvlpTFgwSo37sp6yqUK2+V3
WgqaUpfjaSLYvOEnYM67jT/XruShsPj7heXM2sSHSsh0Qcgrklp27lW1/OmpilUS
bawVMnQBq/QQRPV50/4ZytYNuerNqx/2RI+vY+zCBJPzTyNbM+0+86GuVTO32Uet
IfjmbSe073yF7+LhkiJPKjgQ4P7kDubySU2jYFnXeeVERtCCOk3ekRueA2rkosXo
iItayfVfXxgZ/JlP1bmFKvS1JDFtVmfhQFI+DA6DyVYoIZHj6N1rsnjyazHIfLEG
ZYKzI3VrAGKwyWQzPah1oJl5TaZkPCY9uHUN2tVe9++qvWJt1JHCf11751QZm+m6
Z4GA1r7N3vnxKGCEdRsY87W/w1aze9A3djTwr6gKMUX/tvSKDzeVvKuwfH7QLQM7
lIp6zOGNlNo=
=e/CB
-----END PGP SIGNATURE-----

--Sig_/DMOr/IKDPvs.ugWwC1njiDi--
