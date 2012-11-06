From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] md: Reassigned the parameters if read_seqretry
 returned true in func md_is_badblock.
Date: Tue, 6 Nov 2012 21:19:07 +1100
Message-ID: <20121106211907.7df50c4a@notabene.brown>
References: <201211061713404301164@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8YKc+wvwJmAcwV/K7cy4+h1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201211061713404301164@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, zhuwenfeng <zhuwenfeng@kedacom.com>
List-Id: linux-raid.ids

--Sig_/8YKc+wvwJmAcwV/K7cy4+h1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Nov 2012 17:13:44 +0800 majianpeng <majianpeng@gmail.com> wrote:

> This bug was introduced by commit(v3.0-rc7-126-g2230dfe).
> So fix is suitable for 3.0.y thru 3.6.y.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d63aa78..541c74c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7936,9 +7936,9 @@ int md_is_badblock(struct badblocks *bb, sector_t s=
, int sectors,
>  		   sector_t *first_bad, int *bad_sectors)
>  {
>  	int hi;
> -	int lo =3D 0;
> +	int lo;
>  	u64 *p =3D bb->page;
> -	int rv =3D 0;
> +	int rv;
>  	sector_t target =3D s + sectors;
>  	unsigned seq;
> =20
> @@ -7953,7 +7953,8 @@ int md_is_badblock(struct badblocks *bb, sector_t s=
, int sectors,
> =20
>  retry:
>  	seq =3D read_seqbegin(&bb->lock);
> -
> +	lo =3D 0;
> +	rv =3D 0;
>  	hi =3D bb->count;
> =20
>  	/* Binary search between lo and hi for 'target'

Applied, thanks.

NeilBrown

--Sig_/8YKc+wvwJmAcwV/K7cy4+h1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJjkGznsnt1WYoG5AQKRRRAAvKLNCGmM86yqg6FaLnYUzf2MNYtQt3HB
VmLx8z/7iwtyiF6qWq2+hI1FpVLkpN769N+2nxQvxqfmXVyusU6MaM1VuhDZwFca
0pLgW/eid7WQS8oHu6uaS/yeir+p4AE3JHm/uOpTdbZrrpUo6/dXcR8Nc8DzFGpa
nXGkguQ2YSBdM1XnSYOzAUJKXFvIFtIFeUa6szmYIxFoSZ4LTEwY95XLuQvHfVd7
THqpkHBMkz0Jt4Oa1kUgUODYchsdwfLIzc83xXgku4nymXSsGd0/db1Jq8Jlp95B
Eg1gzOmHTHMaQXvuzS4i38ruwAFgbeLHticj95BfCLov1k43JKjXdy3jlwGgl6bO
liGqTX7HW6FN3sGvq8SN5bDvgIRnL7IeFoOMXchvGi13PI8z7fTZUDkHrKf8WN5w
QrV6U8loX5RLo3Lgk3eIu3l+4GRC+GwDLfmBt/alxzV9MgmrlTQpIQ9D3VtDI1xR
X2cldvtyduGp2ha0oodSLRSqQs0AoZIZNUfbyJNaKn60Ki6ZhL2m1KE8gRnAF+QA
O4mJAJxFZaeAVNe0ew7rATQK5PqoDPK1uI7Bh+GdUfUVNSH44YFaF/wxX3T8C8iR
HzmVRyUizHl2xZNxTB24EcgxUCfP3hjGdP6eU3ZGqJQT03oup8hILKKa/MtObf5u
ctsW/agQpDA=
=CzAW
-----END PGP SIGNATURE-----

--Sig_/8YKc+wvwJmAcwV/K7cy4+h1--
