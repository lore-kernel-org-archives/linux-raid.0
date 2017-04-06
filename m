From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V2] md/raid10: reset the 'first' at the end of loop
Date: Thu, 06 Apr 2017 12:27:13 +1000
Message-ID: <8760iigtj2.fsf@notabene.neil.brown.name>
References: <1491017900-8150-1-git-send-email-gqjiang@suse.com> <1491441138-16155-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1491441138-16155-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
Cc: shli@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 06 2017, Guoqing Jiang wrote:

> We need to set "first =3D 0' at the end of rdev_for_each
> loop, so we can get the array's min_offset_diff correctly
> otherwise min_offset_diff just means the last rdev's
> offset diff.
>
> Suggested-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

Reviewed-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown

> ---
>  drivers/md/raid10.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0f13d57..e055ec9 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3769,6 +3769,7 @@ static int raid10_run(struct mddev *mddev)
>=20=20
>  		if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
>  			discard_supported =3D true;
> +		first =3D 0;
>  	}
>=20=20
>  	if (mddev->queue) {
> @@ -4172,6 +4173,7 @@ static int raid10_start_reshape(struct mddev *mddev)
>  			if (first || diff < min_offset_diff)
>  				min_offset_diff =3D diff;
>  		}
> +		first =3D 0;
>  	}
>=20=20
>  	if (max(before_length, after_length) > min_offset_diff)
> --=20
> 2.6.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljlp4EACgkQOeye3VZi
gbllog/+Lhi5oyW7sMvviDMm5rrdoBggP/t5+kxBExqYSDCGbyu73ps8i1ghSx+P
48PCthIWOnDG2vJ7O2q77TsWFHH4xV7vrRLu1HqWPB7uCgwCriwIEu3CWmCyVq8F
8KS5Ybd2f9QaRm/rgJAr1odjwAxlkX8lBBJOCHEKutmbW77VZvZOcT3GmHqU1lFc
Ft4/vlIoSzymjBoXuC0VXXUB8rLeS7zh4krbUv8NmEfMzXLkj6yWTAJW2eyd1DpP
alzfwc87BuBpPhbqZTZyO4EdSDXoKFE/oP92qemkLv+RX0IHl0F8oCotXPq7Dn2t
t67AqcP38WRUhYc5FjVbv36wnp/iyr2VZTpedWMyHH/XphVxu6/Z9JxwQVmNT2UB
ags+SShC5uB3PrY018c5lqUdB/yKyj58aMt16hJuets4gY6UXu2qrk8KViwY3m3+
g4SMqfpUz7BbM7KYyN/ejhmKpm1htYUPElclrK1kc9V7kFO1YVOY3Vf3kDlaDACh
0xZcrZq9QTDgfhaRe/GupmRVHKbKFdvgC64itxTYHx9m06GfH8NK429dCO5X0wUi
NmY1rkXTQrbaMW55ZYb7QPeb/AKfdpFi4WujtrIhH8XilHKRGyDWrqO7kjtRZNrO
iSul1sH/1W/BOqKjylBsWCxWHP9l8GhW2XD9xBbfuUlzQ/pg+w8=
=8tyc
-----END PGP SIGNATURE-----
--=-=-=--
