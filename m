From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix, the second array need to have the whole
 available space on devices
Date: Mon, 30 Jan 2012 12:21:46 +1100
Message-ID: <20120130122146.44866b14@notabene.brown>
References: <F9123E44003394499FDD2B17C60621D408A87C@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9Xbl2OMI485ekZ7cEWmZ_gK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D408A87C@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids

--Sig_/9Xbl2OMI485ekZ7cEWmZ_gK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Jan 2012 15:28:36 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> Fix the case with creating an array with given container in command line
> instead of real devices:
> mdadm -CR /dev/md/raid0 -l 0 -n 2 -z5G /dev/md/imsm
>=20
> Signed-off-by: Marcin Labun <marcin.labun@intel.com>
> ---
>  super-intel.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 0e9269f..03e10bd 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5525,8 +5525,15 @@ static int reserve_space(struct supertype *st, int=
 raiddisks,
>  			size /=3D 2 * chunk;
>  			size *=3D 2 * chunk;
>  		}
> +		maxsize =3D size;
> +	}
> +	if (!check_env("IMSM_NO_PLATFORM") &&
> +	    mpb->num_raid_devs > 0 && size && size !=3D maxsize) {
> +		fprintf(stderr, Name ": attempting to create a second "
> +			"volume with size less then remaining space. "
> +			"Aborting...\n");
> +		return 0;
>  	}
> -
>  	cnt =3D 0;
>  	for (dl =3D super->disks; dl; dl =3D dl->next)
>  		if (dl->e)

It is a shame that we need the same test in two different places...

I've applied this patch,
Thanks,
NeilBrown

--Sig_/9Xbl2OMI485ekZ7cEWmZ_gK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTyXwqjnsnt1WYoG5AQJR6BAAkpOWOV+7C7DmAuA7jIQm/NR/sgGDrF65
f4OrQ7frUeeZWSAbGzgKnhBCfVYuwlfb67JJ3Iw5wbTRpQZILRtKvAdRgMC7XwG7
xl5t5lghd3wE0ibo78VyxrR2bGwPu0zhmxQvRECuq/fdRZByEzIwEULbeSfiS3y7
Ilyt0xudYtSpVfJ+pJGH9sOwl36pdutsdkSPDDXciJ/K6tCejalZhndLsAUN5eGy
gq877vuHIiBVuIc64rXl3Sk79oAG6EpQc/XylKmOOrQBZQSaul6M0SzkZzIZd5BA
gtewxWwwOM1/hz1LJqiQhbgyyUz+llDW95jLJFhmVH9AVT54yWkv2ctv7obqNoTE
Enogr04Mm6B45zB8ix1Qeh2eOppHtPAHNnJomqigrqDj2tzBTeOZEXbQDMg2mXk2
PK7oK9yo9ErUzFhHxoj3wsBzyyJuUBUlYe5S0Ab1BvS2pJ+f4FRpoqVYRcd37k8b
9Xqoa3NCTxpKtXgOpXmutfD0DW8Vv1JF8kddHfgWCRWM9oe8jsHzgRccQA95Q9nk
daCkrs8aYzxKjjZzK4+E+eecUTLeRjSWIokC4N2zLa3UtWjZtewaSbjOkMK0nk/U
YZXtit//Jub5gc7KtgTNDdIACF6veFTbh/Gja8Fgvfe/3il7g2ptHZoHesiu3Vys
9moymMivNCQ=
=cMGT
-----END PGP SIGNATURE-----

--Sig_/9Xbl2OMI485ekZ7cEWmZ_gK--
