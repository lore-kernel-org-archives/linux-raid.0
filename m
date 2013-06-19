From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/6] Makefile: Allow the user to pass EXTRA_CFLAGS
Date: Wed, 19 Jun 2013 10:07:30 +1000
Message-ID: <20130619100730.0a0e5240@notabene.brown>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
	<20130618090921.1161109.54531.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jEAo9TwF=7J0yapslPRZGas"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130618090921.1161109.54531.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: piergiorgio.sartor@nexgo.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/jEAo9TwF=7J0yapslPRZGas
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Jun 2013 11:09:21 +0200 Bernd Schubert
<bernd.schubert@itwm.fraunhofer.de> wrote:

> Users might want to compile with optimization levels and
> CXFLAGS as suggested in the Makefile comment does not work.

Doesn't it?  It works for me.

   make CXFLAGS=3D-O3

compiled with "-O3".


I haven't applied this patch (feel free to try to be more convincing) but h=
as
applied all the others (after removing a little bit of trailing white space=
).

Thanks,
NeilBrown


>=20
> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
> ---
>  Makefile |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/Makefile b/Makefile
> index 8cb8d51..09e08fa 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -27,8 +27,8 @@
>  #           Australia
>  #
> =20
> -# define "CXFLAGS" to give extra flags to CC.
> -# e.g.  make CXFLAGS=3D-O to optimise
> +# define "EXTRA_CFLAGS" to give extra flags to CC.
> +# e.g.  make EXTRA_CFLAGS=3D-O to optimise
>  TCC =3D tcc
>  UCLIBC_GCC =3D $(shell for nm in i386-uclibc-linux-gcc i386-uclibc-gcc; =
do which $$nm > /dev/null && { echo $$nm ; exit; } ; done; echo false No uc=
libc found )
>  #DIET_GCC =3D diet gcc
> @@ -41,7 +41,7 @@ KLIBC=3D/home/src/klibc/klibc-0.77
>  KLIBC_GCC =3D gcc -nostdinc -iwithprefix include -I$(KLIBC)/klibc/includ=
e -I$(KLIBC)/linux/include -I$(KLIBC)/klibc/arch/i386/include -I$(KLIBC)/kl=
ibc/include/bits32
> =20
>  CC =3D $(CROSS_COMPILE)gcc
> -CXFLAGS =3D -ggdb
> +CXFLAGS =3D -ggdb $(EXTRA_CFLAGS)
>  CWFLAGS =3D -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parame=
ter
>  ifdef WARN_UNUSED
>  CWFLAGS +=3D -Wp,-D_FORTIFY_SOURCE=3D2 -O


--Sig_/jEAo9TwF=7J0yapslPRZGas
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcD2Qjnsnt1WYoG5AQJnNA/6A0lTm0hiIZ5vOVHHnq1LP8DGsmw6B9Wy
/RuB/L38RvgBwy5tX/QrfBb6h8ZwiFGkk9k5Nkr1JUQ1MOJUak0sh1gNw1NRcCLc
BPURPSOAni2A3+ueE3whJiiBcxzWBtVeMXp0Kde/6n1eksG0pxNJpp/smi3aItyF
TK90rwx7A7f7/JOAMwf1op2qgILhnt003iYs+q6+f8TY/m0CPMZHNFZjzQP6zobq
Z3UEhnIeC12Mj5PcRm4iU2rKEVD5evDxIAIjZHcSErF90ZCOJ6O2GP/xEhU9CSVx
PVDY/MnXUTguLXl6YkKZ8uhJuygWHck+zRyl1qoaIsnQiiRCAnHdNXkM7yRoaSZG
adeln2nAsyUL8qKvwgDTXU7SR2oYZ6HC1eTNkTa7ZT7R/zMYPhlCfXvACDfpEt0I
sOdNE3Z9RSGcI/3VicC3BVm1ioouTVK55ZKthZXDIP9DxOgzZdP8bsKzziUrqgC0
Q1He+ojNIkAQYHBhL9ad8aNJ5oYZbpZRXl8+Rb0PWjhmjBDIrtO+NROldohSvfA+
SpgkmxM4dVsHqEPYaUIB5nu0cxcUXifRK73rBa//b6nSTOSDsPpm4XcXHo+BXKLi
9e2A5UFyZUMXPjA3HTYBluMWZPH44B6afvF2N+uEqwP+riNlCMzvKFoy5ooli4U9
n0NXE2mqBRU=
=F+BU
-----END PGP SIGNATURE-----

--Sig_/jEAo9TwF=7J0yapslPRZGas--
