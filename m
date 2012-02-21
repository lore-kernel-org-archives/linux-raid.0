From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] avoid double-free upon "old buggy kernel" sysfs_read
 failure
Date: Wed, 22 Feb 2012 07:14:57 +1100
Message-ID: <20120222071457.72ec0456@notabene.brown>
References: <87sji42zab.fsf@rho.meyering.net>
	<87fwe42vc1.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/l.7plXiGRoOjHSr/awOZR.j"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fwe42vc1.fsf@rho.meyering.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/l.7plXiGRoOjHSr/awOZR.j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Feb 2012 14:02:22 +0100 Jim Meyering <jim@meyering.net> wrote:

> Jim Meyering wrote:
> > * Incremental.c (Incremental): On sysfs_read failure, don't call
> > sysfs_free(sra) just before "goto out_unlock", since that very
> > same "sra" is freed the same way by the clean-up code below.
>=20
> Here it is again, but with the Signed-off-by line:
>=20
> >From 981af2b292448a9daa56af86b4c514ad9339665a Mon Sep 17 00:00:00 2001
> From: Jim Meyering <meyering@redhat.com>
> Date: Tue, 21 Feb 2012 11:08:25 +0100
> Subject: [PATCH] avoid double-free upon "old buggy kernel" sysfs_read fai=
lure
>=20
> * Incremental.c (Incremental): On sysfs_read failure, don't call
> sysfs_free(sra) just before "goto out_unlock", since that very
> same "sra" is freed the same way by the clean-up code below.
>=20
> Signed-off-by: Jim Meyering <meyering@redhat.com>
> ---
>  Incremental.c |    1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/Incremental.c b/Incremental.c
> index b457bf3..836a6f1 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -325,7 +325,6 @@ int Incremental(char *devname, int verbose, int runst=
op,
>  			fprintf(stderr, Name
>  		      ": You have an old buggy kernel which cannot support\n"
>  				"      --incremental reliably.  Aborting.\n");
> -			sysfs_free(sra);
>  			rv =3D 2;
>  			goto out_unlock;
>  		}
> --
> 1.7.9.1.266.g24ee9
> --

Applied, thanks.

NeilBrown

--Sig_/l.7plXiGRoOjHSr/awOZR.j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0P7Qjnsnt1WYoG5AQJpqA/7BhcjrrxnB19h1DmjCJTTwv91NmXX2zVN
rGF3PSq6acsH8/2G3MQ8Qlffv0dKvuVztwvw0AhoWuPuoI8C+YQmmn8FQmIbuBpQ
hmjnQ8RZ8G5dzldrt8xtLMsOnBjZk/VYAwWJrh+PAWPaoDgrEg2UB5/BHzDhmlzU
lrHZu8Xhi2+NjouZTjV/bEX44Q0LRYA7X8shwifWT4JfW7FR/9nxMCogzf/6p3Fc
DyN5LcT4speJqbp0/GaD16NO9zxABjkuIXY23dFGLZ2Bv/Yy568aIgfBwSRjM6tJ
VSYKU2asDlSxb/0A/jJmki41UJYqDhAoNskk1+VYyAD/boiBtIl4q6d3PIZjxU66
AYigRRLNGO53+wiITSzrz1qSyGV3Hbn5o82iR5g2gHtsK8azqD20iWZNFINxCQJE
mHxK+HiYJFU+6YCD4Af2S96Uhw8yhp+A4mOGfHafjGaWwhqCpGPVE+c4wkWRGQC4
LpjipDa124Qtdif7aQS2t32iyTocCHUWXTRG+KWw07XCrKr6j3IzisngIIR54UjF
MwGHWmJlF7OrQjzZcYUVspM7t823NJpFuXlzNE7t8fzKUOtn4yGqbLJzwFUdOByi
pNfRoBrbR6SZKz3TYlSBh84rKcohvShXv5oGV1i6tjrnhJuu2idttbB1gkbo/ep4
PY3BHXrTBA8=
=m3xV
-----END PGP SIGNATURE-----

--Sig_/l.7plXiGRoOjHSr/awOZR.j--
