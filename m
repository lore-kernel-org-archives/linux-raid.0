From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 9/13] md: make return of 0 explicit
Date: Tue, 20 May 2014 15:45:20 +1000
Message-ID: <20140520154520.61487a1c@notabene.brown>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
	<1400473875-22228-10-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6i2xjpM+H9RXZaZdYdU2Wv7"; protocol="application/pgp-signature"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1400473875-22228-10-git-send-email-Julia.Lawall@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6i2xjpM+H9RXZaZdYdU2Wv7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 May 2014 06:31:11 +0200 Julia Lawall <Julia.Lawall@lip6.fr> wrot=
e:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Delete unnecessary local variable whose value is always 0 and that hides
> the fact that the result is always 0.
>=20
> A simplified version of the semantic patch that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @r exists@
> local idexpression ret;
> expression e;
> position p;
> @@
>=20
> -ret =3D 0;
> ... when !=3D ret =3D e
> return=20
> - ret
> + 0
>   ;
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
> Alternatively, was an error code intended in the MD_MAX_BADBLOCKS case?

Yes, I did want an error code in that case  - thanks!
I'll make a patch.

NeilBrown


>=20
>  drivers/md/md.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f477e4c..23b7fee 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8297,7 +8297,6 @@ static int md_clear_badblocks(struct badblocks *bb,=
 sector_t s, int sectors)
>  	u64 *p;
>  	int lo, hi;
>  	sector_t target =3D s + sectors;
> -	int rv =3D 0;
> =20
>  	if (bb->shift > 0) {
>  		/* When clearing we round the start up and the end down.
> @@ -8339,10 +8338,8 @@ static int md_clear_badblocks(struct badblocks *bb=
, sector_t s, int sectors)
> =20
>  			if (a < s) {
>  				/* we need to split this range */
> -				if (bb->count >=3D MD_MAX_BADBLOCKS) {
> -					rv =3D 0;
> +				if (bb->count >=3D MD_MAX_BADBLOCKS)
>  					goto out;
> -				}
>  				memmove(p+lo+1, p+lo, (bb->count - lo) * 8);
>  				bb->count++;
>  				p[lo] =3D BB_MAKE(a, s-a, ack);
> @@ -8378,7 +8375,7 @@ static int md_clear_badblocks(struct badblocks *bb,=
 sector_t s, int sectors)
>  	bb->changed =3D 1;
>  out:
>  	write_sequnlock_irq(&bb->lock);
> -	return rv;
> +	return 0;
>  }
> =20
>  int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,


--Sig_/6i2xjpM+H9RXZaZdYdU2Wv7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU3rr8Dnsnt1WYoG5AQLRBA/+PVU5YHddOZOc3b4sCFBfLRxXZYOP84Ha
k1CV/CN51zGsfY7JQFaDbznI0TGLQny6TTzutdTIDvomFRKWDe9ZojOZUPPyO2zJ
URfo6eSmGypJeqMRRQnnXuYiLx8N6Iq8HTSIfdPB7xKT1Sg/AAB13AHTVJhVAe2Z
xwD72JE1te5grHRiys66qUy9r+RT49M9/AVoxwXqLHhSMoQyeuJPidlJQSSJ/8cW
PYvRQn6fF+rKWBdVuzGN5bzCAWp9DNXirTEPPk7ramOYURg7hE0+1h4zMs1G4fY8
D8NoCwmg8xxK3VQsqREbooJ5opW2WbJjhXKClZK7ywcf5tlL4Q4GRyB3yPZ31B3D
h246K/p5wifzxjpp3MsdcbYyfKqIGKjB9o40ShuP7w34JD28oM8Ak/CV79R1ZDjt
zfW4WeH7X3keGx/8TQFPwtOzF2yanpRJDaCR+IHJCHs9yyGuFaMBq6QLtT15jVbi
4IXJZ99WKdjpcPmwU6c186cDxZ6b6fibpklogx3Mb5mfeDLjOckj3sEpQPEHENLU
OqIFC1YRPkOKOHf3YasmxNNxuqVGgJwgi6zPPplYo5daVZBACM1qPOPdgM2mSRZa
JOgv2bkPrIb64vbcis4dsrRxKnWHJ4W50vGhfzUcU8Jce6AAmlQXGKAdaL9Er0qE
Ye0ypwZC6Pw=
=umV2
-----END PGP SIGNATURE-----

--Sig_/6i2xjpM+H9RXZaZdYdU2Wv7--
