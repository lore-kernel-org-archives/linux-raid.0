From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/raid10: remove unnecessary checks with 'first'
Date: Mon, 03 Apr 2017 12:21:21 +1000
Message-ID: <87inmmdye6.fsf@notabene.neil.brown.name>
References: <1491017900-8150-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1491017900-8150-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
Cc: shli@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 01 2017, Guoqing Jiang wrote:

> Since the value of first is always '1', we can
> set min_offset_diff directly.

Alternately, maybe the fact that first is always '1', is a sign of a bug
that should be fixed.

The calculation of "min_offset_diff" doesn't make much sense now.  It is
just the last_offset_diff.

I think the correct fix is to set "first =3D 0;" at the end of the
rdev_for_each() loop.

Thanks for spotting this.

NeilBrown

>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/raid10.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0f13d57..edaf8f4 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3702,7 +3702,6 @@ static int raid10_run(struct mddev *mddev)
>  	struct md_rdev *rdev;
>  	sector_t size;
>  	sector_t min_offset_diff =3D 0;
> -	int first =3D 1;
>  	bool discard_supported =3D false;
>=20=20
>  	if (mddev->private =3D=3D NULL) {
> @@ -3758,8 +3757,7 @@ static int raid10_run(struct mddev *mddev)
>  			diff =3D -diff;
>  		if (diff < 0)
>  			diff =3D 0;
> -		if (first || diff < min_offset_diff)
> -			min_offset_diff =3D diff;
> +		min_offset_diff =3D diff;
>=20=20
>  		if (mddev->gendisk)
>  			disk_stack_limits(mddev->gendisk, rdev->bdev,
> @@ -4140,7 +4138,6 @@ static int raid10_start_reshape(struct mddev *mddev)
>=20=20
>  	unsigned long before_length, after_length;
>  	sector_t min_offset_diff =3D 0;
> -	int first =3D 1;
>  	struct geom new;
>  	struct r10conf *conf =3D mddev->private;
>  	struct md_rdev *rdev;
> @@ -4169,8 +4166,7 @@ static int raid10_start_reshape(struct mddev *mddev)
>  				diff =3D -diff;
>  			if (diff < 0)
>  				diff =3D 0;
> -			if (first || diff < min_offset_diff)
> -				min_offset_diff =3D diff;
> +			min_offset_diff =3D diff;
>  		}
>  	}
>=20=20
> --=20
> 2.6.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljhsaEACgkQOeye3VZi
gbljQQ/6A9KME9hzlpwjbDLZH/UvTIReX0GM9OjiSqqOazKgs+ijaSOOepF3vByD
uWTwC3qG8oYc/h9Gk9y68RxOPJeX7Ha+I33aBH14yF3rgDB1XkrjLWLJDHwcdrjb
IB9OoXKiVIrWXsc+CYD6LbarOdmN9Isre7xDGRLkymAujoVJTWRJ9HVJuEVR4VJc
SQN5xoWF+AMmPjUfYj0MQ5SD6n2tgNOhBnnhw7j5oshbVYLnkZCaxDzTedYv+OP9
vkWmXflgXF80Remr9yn87ckfvilHP0g2rGTuJA5GS/c+JcXkHA5PDouOfQ+0Onzg
gQW3KQghRIWgaVxWcPQiwLNW49GBZiCchY/SAV/9/60wt7ARlDWJ0QBEYyRZeeGC
aDCecVYAZ17AQyXwcxM+RTi7UFNQi1MpccsSfjgVbM4xr6dwuWiAiFiuCFMivZJN
CFdEqxLo3dcvLRIrcuPEqcC+i6WAgFBU2rz+vDOsSio/CndsgMZ2NTnPrIBU4foK
/VOAoGRMjVEduCxsLh31yj3CRuG16J3fWUX3wrq8vbP2TQdYvwQkOaT1flEORjeH
YaNwGkL1hmPjoLwXOVCKuzBrku4ztYPNc60WnKyXOrszzCF/DvbEhP8acTvwPj/E
G+pbjdWDRojGYyeMTUWs0pxtt53JSJmbahfryMupovojEmAaUeM=
=SkEW
-----END PGP SIGNATURE-----
--=-=-=--
