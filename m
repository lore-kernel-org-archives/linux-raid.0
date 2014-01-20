From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Allow to check mdadm with clangs static checker
 (scan-build)
Date: Tue, 21 Jan 2014 10:06:43 +1100
Message-ID: <20140121100643.0ebaf13d@notabene.brown>
References: <52DD4B54.4060809@fastmail.fm>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gK.X58PBe.bx9bscOicIDgz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52DD4B54.4060809@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/gK.X58PBe.bx9bscOicIDgz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Jan 2014 17:14:12 +0100 Bernd Schubert
<bernd.schubert@fastmail.fm> wrote:

> Clangs scan-build tool (static checker) set the environmental variable CC,
> so Makefile should allow to use that value.
>=20
> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
> ---
>  Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Makefile b/Makefile
> index 043bcea..63cc3ac 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -41,7 +41,7 @@ KLIBC=3D/home/src/klibc/klibc-0.77
> =20
>  KLIBC_GCC =3D gcc -nostdinc -iwithprefix include -I$(KLIBC)/klibc/includ=
e -I$(KLIBC)/linux/include -I$(KLIBC)/klibc/arch/i386/include -I$(KLIBC)/kl=
ibc/include/bits32
> =20
> -CC =3D $(CROSS_COMPILE)gcc
> +CC ?=3D $(CROSS_COMPILE)gcc
>  CXFLAGS ?=3D -ggdb
>  CWFLAGS =3D -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parame=
ter
>  ifdef WARN_UNUSED

I'm not exactly against this, but presumably you could tell scan-build to r=
un

  make CC=3D$CC

to achieve the same effect with no patch ??

i.e.

  scan-build 'make CC=3D$CC'

But maybe I'll apply it anyway.

NeilBrown

--Sig_/gK.X58PBe.bx9bscOicIDgz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUt2sAznsnt1WYoG5AQITwA//UVU6YD1eUKXO3WsMc1jm19DRY5pUU0sF
GPZEO+3VL2RxIEpA7JPByu8Bjxf4dQkD1nyQGzzwb6W1icJpfVzNb+LpGrmqCXQe
x/sxLLyWUOa2Oz2uw6kGGY64A3Jdx662UagL6alzRUMcd7QhloNb02bp0rsHq6i7
KhIG/EugAAhDlsvBGEsHch08dPhlh7V4tUWbqnhWYGq+WKyH2lFzCBx0AmIhiTS7
ajRyAeksBNDWs0Mv5StC9q3uQVzRWxVQbr6uiGnjO8J7v/KWI7BhLjwJGCUuJV2/
DSy3BQZkjJim0hiQ/jwQ6p+kEPsppNXTwlaanJwXBE8Q9Nhxx/4WT8NF27cuK0Jf
4d6tp9hozX/WLep4ZD0D2XIdBmwuhv1ZlobxBuUUFINs+WByYWLgfonpEDRkHbdF
sdFWNyuBbSZgYc8deozF8QK5SaQCzLVJzg400c/nVEGEiDd4lXfeE0Ya2jGLTCi7
h7d/ogkxEcLww2R6Ic83TJeeEtraV7sVyeBznULNFvcWDCCKdpHn9G09JaeURT4W
NCdEcAzgp7Z4Cm7flXs7CaxwfUFaQk1e9fJAftFpqg+Lu9v+DC0jW2moU63X9CgT
4zwbmpgeo/IG/L0glq985oA4TfUfWB6XvpREIxgfbILgzhZT5QvZGs5T3wASn3Sa
TNeOUdkmZzg=
=xgln
-----END PGP SIGNATURE-----

--Sig_/gK.X58PBe.bx9bscOicIDgz--
