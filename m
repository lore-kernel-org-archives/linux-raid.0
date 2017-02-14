From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V2] md: disable WRITE SAME if it fails in underlayer disks
Date: Tue, 14 Feb 2017 13:39:30 +1100
Message-ID: <87y3x9338d.fsf@notabene.neil.brown.name>
References: <728f3fb3d63e6c9512a68fe5fdc61812d95aa2bd.1487031632.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <728f3fb3d63e6c9512a68fe5fdc61812d95aa2bd.1487031632.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13 2017, Shaohua Li wrote:

> This makes md do the same thing as dm for write same IO failure. Please
> see 7eee4ae(dm: disable WRITE SAME if it fails) for details why we need
> this.
>
> We did a little bit different than dm. Instead of disabling writesame in
> the first IO error, we disable it till next writesame IO coming after
> the first IO error. This way we don't need to clone a bio.
>
> Also reported here: https://bugzilla.kernel.org/show_bug.cgi?id=3D118581
>
> Suggested-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Shaohua Li <shli@fb.com>

Looks good to be, thanks.
  Acked-by: NeilBrown <neilb@suse.com>

NeilBrown

> ---
>  drivers/md/linear.c    | 1 +
>  drivers/md/md.h        | 7 +++++++
>  drivers/md/multipath.c | 1 +
>  drivers/md/raid0.c     | 1 +
>  4 files changed, 10 insertions(+)
>
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 26a73b2..789008b 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -291,6 +291,7 @@ static void linear_make_request(struct mddev *mddev, =
struct bio *bio)
>  				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
>  						      split, disk_devt(mddev->gendisk),
>  						      bio_sector);
> +			mddev_check_writesame(mddev, split);
>  			generic_make_request(split);
>  		}
>  	} while (split !=3D bio);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 2a51403..42f8398 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -710,4 +710,11 @@ static inline void mddev_clear_unsupported_flags(str=
uct mddev *mddev,
>  {
>  	mddev->flags &=3D ~unsupported_flags;
>  }
> +
> +static inline void mddev_check_writesame(struct mddev *mddev, struct bio=
 *bio)
> +{
> +	if (bio_op(bio) =3D=3D REQ_OP_WRITE_SAME &&
> +	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
> +		mddev->queue->limits.max_write_same_sectors =3D 0;
> +}
>  #endif /* _MD_MD_H */
> diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
> index aa8c4e5c..065fe28 100644
> --- a/drivers/md/multipath.c
> +++ b/drivers/md/multipath.c
> @@ -138,6 +138,7 @@ static void multipath_make_request(struct mddev *mdde=
v, struct bio * bio)
>  	mp_bh->bio.bi_opf |=3D REQ_FAILFAST_TRANSPORT;
>  	mp_bh->bio.bi_end_io =3D multipath_end_request;
>  	mp_bh->bio.bi_private =3D mp_bh;
> +	mddev_check_writesame(mddev, &mp_bh->bio);
>  	generic_make_request(&mp_bh->bio);
>  	return;
>  }
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 848365d..b3d2644 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -503,6 +503,7 @@ static void raid0_make_request(struct mddev *mddev, s=
truct bio *bio)
>  				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
>  						      split, disk_devt(mddev->gendisk),
>  						      bio_sector);
> +			mddev_check_writesame(mddev, split);
>  			generic_make_request(split);
>  		}
>  	} while (split !=3D bio);
> --=20
> 2.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliibeIACgkQOeye3VZi
gbmLyg//YZ8MKGiS92Vep7jZiHV7iqwjh6aeSFGYbZfhKTCYNxATPWa/qOkGT7sP
2LofMjgfv5LCY0pIjRfqbuYOeMhb1Z/vwUBGPuDJbzMfgGJfSykg0G2KTAFV7WgC
WtRK+RE2dVPKWQ9ibY+O/shcVzpZ+Yf4mfEQ56yNOgqrn/9S/YDLX1P1NGCKOdIo
9rSxl2le6zERRPGS1l+WhBDqCm9aEhOUtJ2Nv88pp20Gr0NHJsKyEaJ7n5FQaaPm
QlakmizeV/boS2jsRg72xIJlQXUPES6v39Q66Xe7v0z1UHnRotLYQKJCwnQJR1gu
lbokT+MiPaj5Wk4QMLfJ3qvAyr7/ro6XjXXeyWMBb6Z6GFl1SpclhsbStJ/PTNGV
SVlerrLYdO032J+xG4xIw4KcS2/S3kVZu0tfVmyUbGDXrAS5zVPT9GoDHlzUrH+r
qwcnT4J0RaRAqd/eDhYljgZ/GCWYVBzx2KH1SCDhmlS9yOUHB70AqTXbR54+TnQt
tETrQ4oCJ8ObWU2vGMZwoI2KnaY60ZonVQs/0MxzNI3q1Tlnl4oM1maWzaF0cKQu
cK2fD+23Q8C+zg8DbE9Ty1ELE4Y2RxA8hBqvg+TPeECtKPMmymvwcUcVw+RPQKFl
SryECbClWDMgz/u2cLslPxA/oF8y0RNLRCbaKD3HLrJRbM92fD0=
=Xd1i
-----END PGP SIGNATURE-----
--=-=-=--
