From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 3/3]raid5: remove unnecessary bitmap write optimization
Date: Wed, 4 Jul 2012 13:17:13 +1000
Message-ID: <20120704131713.0feae049@notabene.brown>
References: <20120703075111.GC23488@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nYbxiytvkE3SRM/SvL4XYOv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120703075111.GC23488@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/nYbxiytvkE3SRM/SvL4XYOv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jul 2012 15:51:11 +0800 Shaohua Li <shli@kernel.org> wrote:

> Neil pointed out the bitmap write optimization in handle_stripe_clean_eve=
nt()
> is unnecessary, because the chance one stripe gets written twice in the m=
ean
> time is rare. We can always do a bitmap_startwrite when a write request is
> added to a stripe and bitmap_endwrite after write request is done.  Delet=
e the
> optimization. With it, we can delete some cases of stripe_lock.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |   28 ++++++++--------------------
>  1 file changed, 8 insertions(+), 20 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-07-03 14:58:51.241382361 +0800
> +++ linux/drivers/md/raid5.c	2012-07-03 15:04:48.568889733 +0800
> @@ -2350,7 +2350,7 @@ static int add_stripe_bio(struct stripe_
>  	spin_lock_irq(&sh->stripe_lock);
>  	if (forwrite) {
>  		bip =3D &sh->dev[dd_idx].towrite;
> -		if (*bip =3D=3D NULL && sh->dev[dd_idx].written =3D=3D NULL)
> +		if (*bip =3D=3D NULL)
>  			firstwrite =3D 1;
>  	} else
>  		bip =3D &sh->dev[dd_idx].toread;
> @@ -2427,7 +2427,6 @@ handle_failed_stripe(struct r5conf *conf
>  	int i;
>  	for (i =3D disks; i--; ) {
>  		struct bio *bi;
> -		int bitmap_end =3D 0;
> =20
>  		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
>  			struct md_rdev *rdev;
> @@ -2451,10 +2450,9 @@ handle_failed_stripe(struct r5conf *conf
>  		/* fail all writes first */
>  		bi =3D sh->dev[i].towrite;
>  		sh->dev[i].towrite =3D NULL;
> -		if (bi) {
> +		if (bi)
>  			s->to_write--;
> -			bitmap_end =3D 1;
> -		}
> +		spin_unlock_irq(&sh->stripe_lock);
> =20
>  		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
>  			wake_up(&conf->wait_for_overlap);
> @@ -2473,7 +2471,6 @@ handle_failed_stripe(struct r5conf *conf
>  		/* and fail all 'written' */
>  		bi =3D sh->dev[i].written;
>  		sh->dev[i].written =3D NULL;
> -		if (bi) bitmap_end =3D 1;
>  		while (bi && bi->bi_sector <
>  		       sh->dev[i].sector + STRIPE_SECTORS) {
>  			struct bio *bi2 =3D r5_next_bio(bi, sh->dev[i].sector);
> @@ -2509,10 +2506,8 @@ handle_failed_stripe(struct r5conf *conf
>  				bi =3D nextbi;
>  			}
>  		}
> -		spin_unlock_irq(&sh->stripe_lock);
> -		if (bitmap_end)
> -			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> -					STRIPE_SECTORS, 0, 0);
> +		bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> +				STRIPE_SECTORS, 0, 0);
>  		/* If we were in the middle of a write the parity block might
>  		 * still be locked - so just clear all R5_LOCKED flags
>  		 */

Thanks.
However this section - handle_failed_stripe - isn't correct.

bitmap_startwrite and bitmap_endwrite increment and decrement a
counter and so must be balanced.
We are now counting once for each list that is on either ->towrite or
->written.  We bitmap_startwrite when we set ->towrite, we then move that to
->written.  Then when we remove from ->written we bitmap_endwrite.
In the handle_failed_stripe case we may remove 0, 1, or 2 lists.  So we
need to call bitmap_endwrite 0, 1, or 2 times.
So if towrite was not NULL, we want to call bitmap_endwrite
then if written was not NULL we want to call it again.

Also I think I'd prefer it if this patch were before "add a per-stripe lock=
".
It is best to first get rid of use of device_lock first, then change some of
the remaining ones to stripe_lock.  Changing some to stripe_lock, then
discarding them seems messy.

Thanks,
NeilBrown

> @@ -2713,9 +2708,7 @@ static void handle_stripe_clean_event(st
>  				test_bit(R5_UPTODATE, &dev->flags)) {
>  				/* We can return any write requests */
>  				struct bio *wbi, *wbi2;
> -				int bitmap_end =3D 0;
>  				pr_debug("Return write for disc %d\n", i);
> -				spin_lock_irq(&sh->stripe_lock);
>  				wbi =3D dev->written;
>  				dev->written =3D NULL;
>  				while (wbi && wbi->bi_sector <
> @@ -2728,15 +2721,10 @@ static void handle_stripe_clean_event(st
>  					}
>  					wbi =3D wbi2;
>  				}
> -				if (dev->towrite =3D=3D NULL)
> -					bitmap_end =3D 1;
> -				spin_unlock_irq(&sh->stripe_lock);
> -				if (bitmap_end)
> -					bitmap_endwrite(conf->mddev->bitmap,
> -							sh->sector,
> -							STRIPE_SECTORS,
> +				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> +						STRIPE_SECTORS,
>  					 !test_bit(STRIPE_DEGRADED, &sh->state),
> -							0);
> +						0);
>  			}
>  		}
> =20


--Sig_/nYbxiytvkE3SRM/SvL4XYOv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/O1uTnsnt1WYoG5AQJ6hQ/+OxkQVyGXnlPYJrMVytohUyd+On9XiNLF
xIQeDUn0lR1njH9q9Vv2X618MDfhmXgvOY5ParOXKxPyOBXucUicA5sMqICdVxGh
5Op9lrc92WHuQSgvOihOgYtcW6fLiXUKvfV3oXOkR0nEtxChlemLXT4YoTYDtMKk
379NG7K1lkEYRIc03abkgjlXlRG6YFytI+Qvf/a9aS7GeLH/eU207OlcMMLXQaRv
W1ma+DkWzZy0qYtn5HSWL9hDqLGc6J2M07mcR2dg/hZxYzqetuEhv1fNkfAGsYsI
I4Lm5ZvRqfdjy72X7mBJfaUFouM37Oc3wJAetc+2lSsgAfRk6Enw1+OCVffWahtM
s79WD5/NT7hXG4EaEbjyaQHN/kOhYxpN6YnvBDvaztBD4Zcr1OogEDos5hvx4aPS
Z0RXRPYDvHwGFpszea4Zg/hFtySaCVucB/OUbDe6s3mtgYXhWg56pYDK6DGdWAnz
6rXsuRDfy7rKV0qwEeBEAwv8sFnt88GifIANd0f1Xs9UMzkxYW/lJ5XRIoh46vsr
E2blMXEojNlmWNC5TEZ+igv3gb16DNWtWlsZjjQiHnRQIvCBXGb8GdUlNLaRxU2m
eKCUg9RBORH3Xmi6NSkEbMtwZICgk/xoYcmEiWYyJuXkJG8+fDVHteGXoo2m5guy
mm9V0q0vAMI=
=FOxX
-----END PGP SIGNATURE-----

--Sig_/nYbxiytvkE3SRM/SvL4XYOv--
