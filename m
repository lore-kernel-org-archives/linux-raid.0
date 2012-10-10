From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix tests sh too many arguments warnings
Date: Thu, 11 Oct 2012 10:39:12 +1100
Message-ID: <20121011103912.7deef5a4@notabene.brown>
References: <1349869095-26167-1-git-send-email-g.esp@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oU2bANTZ6IytZo2wMUZ1FoA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1349869095-26167-1-git-send-email-g.esp@free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Gilles Espinasse <g.esp@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/oU2bANTZ6IytZo2wMUZ1FoA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Oct 2012 13:38:15 +0200 Gilles Espinasse <g.esp@free.fr> wrote:

> Signed-off-by: Gilles Espinasse <g.esp@free.fr>
>=20
> Add quotes on if [ $sum !=3D $sum1 ]
> Fix 2 typo /sh1sum/sha1sum/ /matc /match /
> ---
>  tests/01r5integ    |    6 +++---
>  tests/01raid6integ |   10 +++++-----
>  2 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/tests/01r5integ b/tests/01r5integ
> index 714a57f..97a71f3 100644
> --- a/tests/01r5integ
> +++ b/tests/01r5integ
> @@ -1,7 +1,7 @@
> =20
>  # Check integrity of raid5 in degraded mode
>  # Create a 4 disk raid5, create a filesystem and
> -# sh1sum it with each device failed
> +# sha1sum it with each device failed
> =20
>  for layout in ls rs la ra
>  do
> @@ -16,9 +16,9 @@ do
>      mdadm $md0 -r $i
>      blockdev --flushbufs $md0
>      sum1=3D`sha1sum $md0`
> -    if [ $sum !=3D $sum1 ]
> +    if [ "$sum" !=3D "$sum1" ]
>      then
> -     echo $sum does not matc $sum1 with $i missing
> +     echo $sum does not match $sum1 with $i missing
>       exit 1
>      fi
>      mdadm $md0 -a $i
> diff --git a/tests/01raid6integ b/tests/01raid6integ
> index 245b0da..7123e2b 100644
> --- a/tests/01raid6integ
> +++ b/tests/01raid6integ
> @@ -1,7 +1,7 @@
> =20
>  # Check integrity of raid6 in degraded modes
>  # Create a 5 disk raid6, dump some data to it, then
> -# sh1sum it with different pairs of devices failed
> +# sha1sum it with different pairs of devices failed
> =20
>  layouts=3D'ls rs la ra'
>  lv=3D`uname -r`
> @@ -25,9 +25,9 @@ do
>      mdadm $md0 -r $second
>      blockdev --flushbufs $md0
>      sum1=3D`sha1sum $md0`
> -    if [ $sum !=3D $sum1 ]
> +    if [ "$sum" !=3D "$sum1" ]
>      then
> -      echo $sum does not matc $sum1 with $second missing
> +      echo $sum does not match $sum1 with $second missing
>        exit 1
>      fi
>      for first in $totest
> @@ -36,9 +36,9 @@ do
>         mdadm $md0 -r $first
>         blockdev --flushbufs $md0
>         sum1=3D`sha1sum $md0`
> -       if [ $sum !=3D $sum1 ]
> +       if [ "$sum" !=3D "$sum1" ]
>         then
> -         echo $sum does not matc $sum1 with $first and $second missing
> +         echo $sum does not match $sum1 with $first and $second missing
>           exit 1
>         fi
>         mdadm $md0 -a $first


applied,
thanks.
NeilBrown

--Sig_/oU2bANTZ6IytZo2wMUZ1FoA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHYHIDnsnt1WYoG5AQL80Q//SqT2U3Uwxx3CXFmFg9aYTUVQHlaunZah
I3r8FVK6EToruLsxiZ96yA7iPffXbt5dp9MeX88slF4+3rOFGAJ0vCVjKTFexPKE
29ppxxfk3qDVABQd7LsvWTDh9c4a1sqOCArScvr7pCTEnCPtpCV3+LodLxyA39P4
FTAUwuSP4xHzgaEeDUtMXXGxlEpGXHX1xT4o0xogLG8i2kqy6Z7EMgj/uyhQda6S
gUzgQjIkJeqXJfb7th0UF0Puv4Qe9n0LVn2h3GQpIkmY8Pj79Lr8fzMz5mnbyXyJ
uPwxHrm1V1VqOS4xomdiz7nQC5txGOXWnief5s8UmVgp9GVR7UjERNwdWrqKyntN
Zg9hVYwLOaj4sRCV0y3E9n9kAoBcy5b+ir4m3nuMap/XO6ORVbXq5auU7cthn4A2
R/wEGz3RaF2TVW/gvp8Wi0aPpflIiV8E71vUIsBQyY2oYQS8Zce4wQTQGG74K/zz
dUcsJqKFC9GgxkTFXXl0Y1/Xj4LkMLG+W38s9uhWmKQ45paSu7GCNrr7Ls0xkT73
CT6ltSRl2jzXMH38eh9sIqrdACQPO1b0Wz6ySHlJD6E7cZK9C5buGcqmDntZ12gz
7NPfGMqcs/exeKZZAMCjC1csnbNSAPK2Gp15wOH2U1GOSceEA1EMoYUYt6wAK/sp
WIbxBDz9+bI=
=si6V
-----END PGP SIGNATURE-----

--Sig_/oU2bANTZ6IytZo2wMUZ1FoA--
