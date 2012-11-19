From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2 V1] md:Avoid write invalid address if read_seqretry
 returned true.
Date: Mon, 19 Nov 2012 12:31:45 +1100
Message-ID: <20121119123145.2d9c0fc1@notabene.brown>
References: <201211080856156202401@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ptzB23SLjMmzIOtGiJDLibw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201211080856156202401@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, zhuwenfeng <zhuwenfeng@kedacom.com>
List-Id: linux-raid.ids

--Sig_/ptzB23SLjMmzIOtGiJDLibw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Nov 2012 08:56:27 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Hi Neil,
> 	I updated this patch.There are two place to changed
> 1:The previous patch omit the parameter 'p'
> 2:Using p[i] instead of *p++; bbp[i] instead *bbp++.It make the code look=
s better.
> After rewriting ,i tested and it looked good.
>=20
>=20
> If read_seqretry returned true and bbp was changed, it will write
> invalid address which can cause some serious problem.
>=20
> This bug was introduced by commit v3.0-rc7-130-g2699b67.
> So fix is suitable for 3.0.y thru 3.6.y.
>=20
> Reported-by: zhuwenfeng@kedacom.com
> Tested-by: zhuwenfeng@kedacom.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9ab768a..1f86c48 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1817,10 +1817,10 @@ retry:
>  			memset(bbp, 0xff, PAGE_SIZE);
> =20
>  			for (i =3D 0 ; i < bb->count ; i++) {
> -				u64 internal_bb =3D *p++;
> +				u64 internal_bb =3D p[i];
>  				u64 store_bb =3D ((BB_OFFSET(internal_bb) << 10)
>  						| BB_LEN(internal_bb));
> -				*bbp++ =3D cpu_to_le64(store_bb);
> +				bbp[i] =3D cpu_to_le64(store_bb);
>  			}
>  			bb->changed =3D 0;
>  			if (read_seqretry(&bb->lock, seq))

Yes, that does look cleaner.  Thanks.

Applied in place of the previous version.

Thanks,
NeilBrown

--Sig_/ptzB23SLjMmzIOtGiJDLibw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKmMATnsnt1WYoG5AQLqXQ//RxFKBAcMVH5hwcRsoPaMBtTY3GR50tBX
Ke3xyBKfPFcky+/JWb0QxqxWVgOicfJvPPfGRvjON5hpdKunpQGTN3aSs9CAE4jJ
BnN19sAmbh4iXsuotb5vY2iISYcIdmvaSqekKzs0m6POdbu2q9atSWVWnhGhxaot
tQUsYfwB2SSyGzc8dDXtuEu13di9BV0mt0NsnirEniJqLx90qZhv4xJfC94vdb4Z
dR/JhfshjR1wO1Y6dWSIWiXUkVaiOvSGL7oTHWAPJ7dy/m0epO7Boioar4KR5AhP
5IGnGb/hkvYQLFQFEl+7QZ61TT8+FLL28DMpxeqJFn5xRzhZXJtWr4SzFXZy4ai8
N6WCjQPQJ8ZwcBZ8VaWl4LJKt42tu8GEUUJo5LD+1SM6H/8nf1ldsmAFFuyCfw9p
ae/1GDc9SiHAtEt5erVfiMQlQlgKeMYBTrDtUEQ2deTeIVzME42jxIs+Zz3SzHum
Xs3C3Q5962mYmWiED7sklgR2baopOzEdkqp/i6xlzRqjGf0zivd33/nf1OH2LXN4
kHRNVnT4Dg/VxVrCuCr1uoy2SulfMDisJcflV/axaeT14uvQQ/5MxV5uwPp4va+z
KnhegnUY0MkJYcvEP2PeojcHbP5FfwXVd9nwHyddNqYJpw5qDpwPTaGcgA4oijhh
fB36ISIvI/8=
=UU9H
-----END PGP SIGNATURE-----

--Sig_/ptzB23SLjMmzIOtGiJDLibw--
