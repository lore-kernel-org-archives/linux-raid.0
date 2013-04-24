From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DDF: fix bug in compare_super_ddf
Date: Wed, 24 Apr 2013 16:34:44 +1000
Message-ID: <20130424163444.55f8114f@notabene.brown>
References: <20130423171548.3d438b79@notabene.brown>
	<1366740616-7803-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BjlHK/e=aHx5cRrJzH=tvi8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1366740616-7803-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/BjlHK/e=aHx5cRrJzH=tvi8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Apr 2013 20:10:16 +0200 mwilck@arcor.de wrote:

> Fix bug in previous patch
> "DDF: compare_super_ddf: merge local info of other superblock"
>=20
> Just discovered this bug in my last patch set - unfortunately, just after
> you committed it.

Life's like that sometimes :-)

Applied- thanks.
NeilBrown


>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  super-ddf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index 455f0f8..ea8439b 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -3514,7 +3514,7 @@ static int compare_super_ddf(struct supertype *st, =
struct supertype *tst)
> =20
>  		vl1->next =3D first->conflist;
>  		vl1->block_sizes =3D NULL;
> -		if (vl1->conf.sec_elmnt_count > 1) {
> +		if (vl2->conf.sec_elmnt_count > 1) {
>  			vl1->other_bvds =3D xcalloc(vl2->conf.sec_elmnt_count - 1,
>  						  sizeof(struct vd_config *));
>  		} else


--Sig_/BjlHK/e=aHx5cRrJzH=tvi8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXd9BDnsnt1WYoG5AQIqyA/9HGkEgdvV2WQeCKlU+xSow17nnBnGBdR8
qxRfMPZf2wC6yCt3jZihH3LU3Yj15tsGQQYDTZMUMRqDSj7PNiENPfYZ58RfUmI3
wlnJN1vTMXMWYf2tcgxiAY+vSn7b9ABEP27Ivah/WpGhtIUqXUhIUumyf2BC0NEl
a9NAK5O6X7wn6uh6M8WSq9Y0QxN3/Z5zogmrFvhT3DVpogrhs2KcIK6mKf0HP6Wk
hTYA5YV4++mRqn3o94vab7UZZuDXRG1vmcOlKOvSt/ryzCa/xmEFwkspAKu4vKUV
G5UEVMcSo17ihMk5skasH+edCEoTWXTtdfmZYNd5rmKiqFBDiLJzzsEPp0ca+9Zz
rgcJitUjy5wjzzxJA8EWcbOlrdtGdOxGSstCrZFwDY9S5dqMtJ3Ofo5vro8uG7bO
j9aW0mWG4u3PYmyz6fUh9V3xsASDTrXspjHQuHLSuy38+Pp+m8kudDRP7iKGxG/h
URWgKXbXkI1kX3iq1AsGneCEVhF2bzLEeq24g7005g1scXItEpX+noh2W1+Ap82u
7SJaAH5jXl2VbTEi8Hkdc3N5Q9MCktFwIsj2/GT6befZO62e7PdFQGX1Zd+aRxaX
gQjh7qhuSVjZo7uQsxTKz3pzGyaEoSBC2wTtlsZgtTtVpmCaBDdszHyXyEGLewui
5pdLl6G7LUc=
=yM/l
-----END PGP SIGNATURE-----

--Sig_/BjlHK/e=aHx5cRrJzH=tvi8--
