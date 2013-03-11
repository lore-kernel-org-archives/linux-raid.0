From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD RAID5: Avoid accessing gendisk or queue structs when
 not available
Date: Mon, 11 Mar 2013 11:35:10 +1100
Message-ID: <20130311113510.5eb480f4@notabene.brown>
References: <1362694921.28152.4.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OBG1/w/DmgA=8SQHf/1.zJy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362694921.28152.4.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/OBG1/w/DmgA=8SQHf/1.zJy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 07 Mar 2013 16:22:01 -0600 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> MD RAID5:  Fix kernel oops when RAID4/5/6 is used via device-mapper
>=20
> Commit a9add5d (v3.8-rc1) added blktrace calls to the RAID4/5/6 driver.
> However, when device-mapper is used to create RAID4/5/6 arrays, the
> mddev->gendisk and mddev->queue fields are not setup.  Therefore, calling
> things like trace_block_bio_remap will cause a kernel oops.  This patch
> conditionalizes those calls on whether the proper fields exist to make
> the calls.  (Device-mapper will call trace_block_bio_remap on its own.)
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/raid5.c
> +++ linux-upstream/drivers/md/raid5.c
> @@ -671,9 +671,11 @@ static void ops_run_io(struct stripe_hea
>  			bi->bi_next =3D NULL;
>  			if (rrdev)
>  				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
> -			trace_block_bio_remap(bdev_get_queue(bi->bi_bdev),
> -					      bi, disk_devt(conf->mddev->gendisk),
> -					      sh->dev[i].sector);
> +
> +			if (conf->mddev->gendisk)
> +				trace_block_bio_remap(bdev_get_queue(bi->bi_bdev),
> +						      bi, disk_devt(conf->mddev->gendisk),
> +						      sh->dev[i].sector);
>  			generic_make_request(bi);
>  		}
>  		if (rrdev) {
> @@ -701,9 +703,10 @@ static void ops_run_io(struct stripe_hea
>  			rbi->bi_io_vec[0].bv_offset =3D 0;
>  			rbi->bi_size =3D STRIPE_SIZE;
>  			rbi->bi_next =3D NULL;
> -			trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
> -					      rbi, disk_devt(conf->mddev->gendisk),
> -					      sh->dev[i].sector);
> +			if (conf->mddev->gendisk)
> +				trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
> +						      rbi, disk_devt(conf->mddev->gendisk),
> +						      sh->dev[i].sector);
>  			generic_make_request(rbi);
>  		}
>  		if (!rdev && !rrdev) {
> @@ -2862,8 +2865,10 @@ static void handle_stripe_dirtying(struc
>  	set_bit(STRIPE_HANDLE, &sh->state);
>  	if (rmw < rcw && rmw > 0) {
>  		/* prefer read-modify-write, but need to get some data */
> -		blk_add_trace_msg(conf->mddev->queue, "raid5 rmw %llu %d",
> -				  (unsigned long long)sh->sector, rmw);
> +		if (conf->mddev->queue)
> +			blk_add_trace_msg(conf->mddev->queue,
> +					  "raid5 rmw %llu %d",
> +					  (unsigned long long)sh->sector, rmw);
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
>  			if ((dev->towrite || i =3D=3D sh->pd_idx) &&
> @@ -2913,7 +2918,7 @@ static void handle_stripe_dirtying(struc
>  				}
>  			}
>  		}
> -		if (rcw)
> +		if (rcw && conf->mddev->queue)
>  			blk_add_trace_msg(conf->mddev->queue, "raid5 rcw %llu %d %d %d",
>  					  (unsigned long long)sh->sector,
>  					  rcw, qread, test_bit(STRIPE_DELAYED, &sh->state));
> @@ -4018,9 +4023,10 @@ static int chunk_aligned_read(struct mdd
>  		atomic_inc(&conf->active_aligned_reads);
>  		spin_unlock_irq(&conf->device_lock);
> =20
> -		trace_block_bio_remap(bdev_get_queue(align_bi->bi_bdev),
> -				      align_bi, disk_devt(mddev->gendisk),
> -				      raid_bio->bi_sector);
> +		if (mddev->gendisk)
> +			trace_block_bio_remap(bdev_get_queue(align_bi->bi_bdev),
> +					      align_bi, disk_devt(mddev->gendisk),
> +					      raid_bio->bi_sector);
>  		generic_make_request(align_bi);
>  		return 1;
>  	} else {
> @@ -4114,7 +4120,8 @@ static void raid5_unplug(struct blk_plug
>  		}
>  		spin_unlock_irq(&conf->device_lock);
>  	}
> -	trace_block_unplug(mddev->queue, cnt, !from_schedule);
> +	if (mddev->queue)
> +		trace_block_unplug(mddev->queue, cnt, !from_schedule);
>  	kfree(cb);
>  }
> =20
>=20


Applied, thanks (and sorry for breaking it...)

NeilBrown

--Sig_/OBG1/w/DmgA=8SQHf/1.zJy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUT0mvjnsnt1WYoG5AQJEeRAAsmr/xw3WMm+y2+Ch4n+EMi9wSL7cwgGB
azlQnpWWeFguVJDW8uUNM7QwnWX4uhcqS6jwRDXXc03xe/Wn4Un8R4VQzlN711QA
c5DYY2523hiwOcr63vFKw1g2tWBUV7ZjoKdXBG03N4P+rUOm0dkjth4eo8nkDq8q
ZYEHMNmZnXDli578uyZW3BBuM+MV2p8C5AkeIt4ku/q2Bf+4xrwxWINhaMg8hEUy
dy6Czr5CvgCGEEy99EL3valO7zK2MdANvb1gNb9wF4piPD3AFQ/Jpul+Ae3ZFjjB
T9BHcMjWX3N/ndJjdq9WJpiJGJ8HGKP5LyQd6yZ585f6x8ylA5YhXDI381LRMAJ7
6f5usyMxoAdj+Fk6bm1jj+5fv6aLo35E5S46XdxkgEJxL+anXpbALjGxQptrbusp
XLlPZifb3+A0olOCObZzPqenI3k13hSY9Bx7C+RUiTn3cV7eE/v5D7tOLdCE227B
OJerbL4RkkT6M1s4d6A/IUbrWrSkiI9HQbW6bzKn3TsoW99GhE/JA5AXS34qiW/G
U6uz4lCeMFzBVeNJi8LKomVYIYM6tFWEvopfGPjJtN2bYQJmfZWzkQXruh7WuDEu
riGfqkurelCNPLNo4vJG6lxJFGmmKM/OtCxyfgvRqJsSedHAAinLfrHOQeu0dQTa
Ao7mm8hpShU=
=nJ5r
-----END PGP SIGNATURE-----

--Sig_/OBG1/w/DmgA=8SQHf/1.zJy--
