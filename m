From: NeilBrown <neilb@suse.com>
Subject: Re: [mdadm PATCH] mdadm: make create clustered raid10 possible
Date: Wed, 25 Oct 2017 07:05:14 +1100
Message-ID: <87efpse2h1.fsf@notabene.neil.brown.name>
References: <20171024073124.7751-1-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171024073124.7751-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, jsorensen@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24 2017, Guoqing Jiang wrote:

> This change to make we can create a clustered
> raid10 array as well.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  mdadm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mdadm.c b/mdadm.c
> index 7cdcdba7c652..60d80e0103f4 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1542,8 +1542,9 @@ int main(int argc, char *argv[])
>  				break;
>  			}
>=20=20
> -			if (s.level !=3D 1) {
> -				pr_err("--bitmap=3Dclustered is currently supported with RAID mirror=
 only\n");
> +			if (s.level !=3D 1 && s.level !=3D 10) {
> +				pr_err("--bitmap=3Dclustered is currently "
> +				       "supported with raid1/10 only\n");


Please don't wrap strings.  It makes it hard to search for them.
Long line might be bad, but wrapped strings are worse.

Thanks,
NeilBrown


>  				rv =3D 1;
>  				break;
>  			}
> --=20
> 2.10.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnvnPwACgkQOeye3VZi
gbkODBAAnNgxX5u/7C09KnPQgCYzxRAfmoIcsDdLzj66g4MnV0BM7Fvj3dG7ngyD
bvIGW/A9Y2bBVFl481ECrlCBxQQSE+fOLjnHuyAKs6mG79OeBAaGmdeeJ5fbmFn6
BZIOWqWwk3Ten5snASJeMq/nKas6x6uhhCmTZIJRRy9dkuQYu2+Si5Gk8fe1ygoE
v7inzFo0fi/JC1T0Ij7m6P015+NKf0/FNAJ8/WD9H52KF+6Q7youlQ3ARXdJhqhq
2y34WrUAhvU3j2j4TmqW0lkJydHm3YUQBDEwftJcoUkVCkoPetRbJNNK1Exssacy
qBf9hlpoM2r3BAq5FO8rq6yCOXTgwnhjQ87a6hpDzGr8vvfvNxHqSRu9NmFQz8MC
S4gY0ha+D5BTMuBVW2QOmCXpgyAk5FTkY0e4u3MKXhVTzqRxyacROG6we7aLI8Ub
ECR9B3W7/R6Ys0ZuSnG5JpS0jZyIcHfJ13AaspVyiIYBVbHBDLGLbLSldNnXVCru
LAMt/cAJ24voLSmE4p9N4vuZRujB7hJ+uhHevJbcCt/P0wRiUq8B24qJAFVZY5Uo
iGD40lwhpZf/rRPaY+7zAlGLF345PzeRDTsSfNvSFZZRmvpZDPEHj5xAujycg3FF
j3z3Vy6QNf20ZC23n/dcNgn0ytPMGmM7khUfQs0GBKj+TWokJ0E=
=+aM7
-----END PGP SIGNATURE-----
--=-=-=--
