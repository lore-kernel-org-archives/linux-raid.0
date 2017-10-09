From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/3] mdadm/Grow: fix the broken raid level conversion
Date: Mon, 09 Oct 2017 21:49:17 +1100
Message-ID: <87shesy4sy.fsf@notabene.neil.brown.name>
References: <1507537274-29350-1-git-send-email-zlliu@suse.com> <1507537274-29350-2-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1507537274-29350-2-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 09 2017, Zhilong Liu wrote:

> To fix the commit: 4b74a905a67e
> (mdadm/grow: Component size must be larger than chunk size)
> Since cannot change component size at the same time as other
> changes, ensure the 'level' is UnSet when changing component
> size, and also not affect the raid level conversion.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Grow.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/Grow.c b/Grow.c
> index 1149753..180fd78 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1814,7 +1814,8 @@ int Grow_reshape(char *devname, int fd,
>  	}
>=20=20
>  	if (array.level > 1 &&
> -	   (array.chunk_size / 1024) > (int)s->size) {
> +	   (array.chunk_size / 1024) > (int)s->size &&
> +	    s->level =3D=3D UnSet) {
>  		pr_err("component size must be larger than chunk size.\n");
>  		return 1;
>  	}

This patch doesn't make any sense to me.
If the chunk_size is meaningful, then is must be less than the new
s->size.
This is true whether the level is being changed or not.

Why do you think that the component size cannot be changed at the same
time as other changes?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnbVC0ACgkQOeye3VZi
gblqxQ//Yq03GzGCSIkVTX5Y4maCLtYvc3DKv7B8HNoMaeFXWsdTYyFOMHhRoVLh
59KmCZo/mekV544T9AgdQGYjILn1ZM8mahgljs/uwDaKtj7jFZPVmSdxhOYpIZfQ
ZGslSwLxZYGPhHYyljIZGR0w2WZ9ctXmXpnzW7UxR3if7oscLezNNdlj7RXwseJQ
FvHPOhsk2A7NTqz7LFC1izGOti1lVUZxFqah5piMBycRRaq2tY9trrioCmEy0zL5
Ha16OKtJQKx38Tg/obeCptcosgvxRPKWnakFjTW3WX8ccGPaZ4em8eUG/fh8Hn9O
kdq/WY62bRY0a+/bF2feyBNpm2YZy2CiQ/OjsiE6yprZBnLJy3R5hMTTy78ra5i1
N03oqGN0MlhKVCSCmXyZC4uaxqQQZGWVfMaWBvcarM62Cui3DYT9HZSWVvYs+vg8
dgBG1yNwCewWkIgLhuDFRGIeIernFEL/qfLU4G84tWUOfKls25H+/Qc32uZoh0jv
hqDGiO2h9SiEGGIoUxLCWNjZR37Ei8r7MTTe63Fwu3pQz10qV4eq9Xyj8VkM75eA
K2r8zWS6cNRqtfSt9Hc2G9d3Lmbv5qVJeKgGJQDcLHBrdR9rMm6Rg+WD1wZCRD5M
ukmiSEVmpbBr/IdkZa2c5fc/mNTS1LWgLOOwgKfmAPUabs0eNZ8=
=GKsj
-----END PGP SIGNATURE-----
--=-=-=--
