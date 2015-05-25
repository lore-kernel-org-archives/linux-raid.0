From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v4 06/11] md/raid5: get rid of bio_fits_rdev()
Date: Mon, 25 May 2015 15:48:29 +1000
Message-ID: <20150525154829.4330f149@notabene.brown>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-7-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.SZ0IFjDJAPZZR26s.JOJCo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432318723-18829-7-git-send-email-mlin@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.SZ0IFjDJAPZZR26s.JOJCo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 May 2015 11:18:38 -0700 Ming Lin <mlin@kernel.org> wrote:

> From: Kent Overstreet <kent.overstreet@gmail.com>
>=20
> Remove bio_fits_rdev() completely, because ->merge_bvec_fn() has now
> gone. There's no point in calling bio_fits_rdev() only for ensuring
> aligned read from rdev.

Surely this patch should come *before*=20
  [PATCH v4 07/11] md/raid5: split bio for chunk_aligned_read

and the comment says ->merge_bvec_fn() has gone, but that isn't until
  [PATCH v4 08/11] block: kill merge_bvec_fn() completely


If those issues are resolved, then

  Acked-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown


>=20
> Cc: Neil Brown <neilb@suse.de>
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> [dpark: add more description in commit message]
> Signed-off-by: Dongsu Park <dpark@posteo.net>
> Signed-off-by: Ming Lin <mlin@kernel.org>
> ---
>  drivers/md/raid5.c | 23 +----------------------
>  1 file changed, 1 insertion(+), 22 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 1ba97fd..b303ded 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4743,25 +4743,6 @@ static void raid5_align_endio(struct bio *bi, int =
error)
>  	add_bio_to_retry(raid_bi, conf);
>  }
> =20
> -static int bio_fits_rdev(struct bio *bi)
> -{
> -	struct request_queue *q =3D bdev_get_queue(bi->bi_bdev);
> -
> -	if (bio_sectors(bi) > queue_max_sectors(q))
> -		return 0;
> -	blk_recount_segments(q, bi);
> -	if (bi->bi_phys_segments > queue_max_segments(q))
> -		return 0;
> -
> -	if (q->merge_bvec_fn)
> -		/* it's too hard to apply the merge_bvec_fn at this stage,
> -		 * just just give up
> -		 */
> -		return 0;
> -
> -	return 1;
> -}
> -
>  static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
>  {
>  	struct r5conf *conf =3D mddev->private;
> @@ -4815,11 +4796,9 @@ static int chunk_aligned_read(struct mddev *mddev,=
 struct bio * raid_bio)
>  		align_bi->bi_bdev =3D  rdev->bdev;
>  		__clear_bit(BIO_SEG_VALID, &align_bi->bi_flags);
> =20
> -		if (!bio_fits_rdev(align_bi) ||
> -		    is_badblock(rdev, align_bi->bi_iter.bi_sector,
> +		if (is_badblock(rdev, align_bi->bi_iter.bi_sector,
>  				bio_sectors(align_bi),
>  				&first_bad, &bad_sectors)) {
> -			/* too big in some way, or has a known bad block */
>  			bio_put(align_bi);
>  			rdev_dec_pending(rdev, mddev);
>  			return 0;


--Sig_/.SZ0IFjDJAPZZR26s.JOJCo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWK3rTnsnt1WYoG5AQI0og//WnUVTGUU/hWI8JOpipb/RhVDbvhLP5sg
wgrZDmcc6Luo+5Ta1BG+POYaK4Hi6P+RW8r5n16vT6FG4mbTV2A7YYkeuYvH+EoM
/iuq1F86Mu7V0D2bt6bKbk1PKrfziGJZqMlLVWjmP5nlTXgfNsUa3v5u5yWy/brX
5XFsl5yecwxkfxn+9feuLgJFXrh5I1GnwyCno/WeUDw10XaZiGnz6uti74/XkuBj
GFCYINjnODVCTlXc204ftjgEhI7V2VN2QEiTnJbpToR0XyLpocboRgSEwJ5vYjD/
PV54hfJj4Lo5OCOPBZpqM+FhVuQBoSzbOYM1O/T6Z7fAPpLeN02xbnrgudZGma/N
5GDTp3mnH/IZKNqVSfCl/4RBUZzJsR5X9TSYzzdLDjG+gxqHnjYO7YoaJc07zOlA
FDeN1jv2YYEZl/vHcopS0ie+CfAPCOA0ugJPKshVHyuuXTHMFs7UZnKVqkFAp+uV
iXvENWM0llkPNmbt2QZxx9a49nITVYav3PLZNC6t7tGlZ0at7DBih4YKoJgJj7tN
/h/Eq83m+3kXM+LP9I2tcs6AXmIJ1STOPIBuQ+zVpwYfuul4DceYkDdi15MJ69rZ
5Rc5plUzSUrrnDXDYqyjbQUNV4Sjc5QPAPu4Eo6k5tDaqyF3uai1OSQHn0UyrMQ4
NJfl9eaBpk8=
=3wot
-----END PGP SIGNATURE-----

--Sig_/.SZ0IFjDJAPZZR26s.JOJCo--
