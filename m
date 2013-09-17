From: NeilBrown <neilb@suse.de>
Subject: Re: Remove bashism from Makefile
Date: Wed, 18 Sep 2013 09:22:07 +1000
Message-ID: <20130918092207.4f3784dc@notabene.brown>
References: <1379434840-9971-1-git-send-email-mjt@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/D/.+eFr.bY8uqnpay1a9BR1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1379434840-9971-1-git-send-email-mjt@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/D/.+eFr.bY8uqnpay1a9BR1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Sep 2013 20:20:40 +0400 Michael Tokarev <mjt@tls.msk.ru> wrote:

> Makefile uses [ x =3D=3D y ] construct which does not work
> with POSIX shell.  Since this is just testing a flag,
> replace it with string comparison (=3D) operator instead.
>=20
> Signed-off-By: Michael Tokarev <mjt@tls.msk.ru>
>=20
> diff --git a/Makefile b/Makefile
> index e8da3a5..c60cc2c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -156,7 +156,7 @@ all : check_rundir mdadm mdmon
>  man : mdadm.man md.man mdadm.conf.man mdmon.man raid6check.man
> =20
>  check_rundir:
> -	@if [ ! -d "$(dir $(RUN_DIR))" -a  "$(CHECK_RUN_DIR)" =3D=3D 1 ]; then \
> +	@if [ ! -d "$(dir $(RUN_DIR))" -a  "$(CHECK_RUN_DIR)" =3D 1 ]; then \
>  		echo "***** Parent of $(RUN_DIR) does not exist.  Maybe set different =
RUN_DIR=3D"; \
>  		echo "*****  e.g. make RUN_DIR=3D/dev/.mdadm" ; \
>  		echo "***** or set CHECK_RUN_DIR=3D0"; exit 1; \

Applied, thanks.

NeilBrown

--Sig_/D/.+eFr.bY8uqnpay1a9BR1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjjkHznsnt1WYoG5AQIlOg//QczaWHiIdSaP3tLPGv4eSzKrX3kmW2YC
/1ScCLJICncD93ekvd1uDcBh8EjojjRhan8aR7db+ynCUFwFwqHd9sGkse5vW0f/
WGkCwo9J74s0SZccvc3QMgB28SHu+QVszVl211KsNvux7mda5HLIcEIJnRiN3Mgi
bknkZEtgirjOgDkh5HWjxXh7OP0qgMyX+fD8p3r37699/S79GJk4C/ZWUQSn4950
xCCwAg2MHGqaBdzmMljMFYsTY+iqOgTWBupJYbFOXJpGNdVbs9rdoy9OimuuFEzb
+ovJZjt/9cPjibKS+cFq7/z5R9qbXJbkWP378v8Ckhjjb6dydw8kWsHAaU8l17zb
ALvCFpMUg+QMfRnZB7rKXzejBKxTy/5QMaTs4tQIZhgKYR4eKLdBj3IUq0PNple6
foL6H+alsjW1IvfjrWaaLpaJn1AUZ9fC1d1KZQvjxezj2Q1anHlTWknm0bkZ1VGf
8eUxLkAIpKANbQvON553naZJf9c4nVa9sv3F+qxnCiq+Ktxvs1abeA4vADFHpgSe
Mh69AHO/hm5oHGkb2ullZnKA/BgYVGwKBvDWdd3Azw5K/pwDonEUO+3DViQGeyHe
dQ++YhvN8UK/YrmY7xESmS5zB6Ve/VeOlnigedw/H2JJ8KfTIRTCwCDkSRgadamE
PCEHCvlPIkM=
=0zWs
-----END PGP SIGNATURE-----

--Sig_/D/.+eFr.bY8uqnpay1a9BR1--
