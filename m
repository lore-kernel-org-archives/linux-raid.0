From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] DDF: brief_examine_subarrays_ddf: print array name
Date: Thu, 12 Sep 2013 15:44:41 +1000
Message-ID: <20130912154441.0658f011@notabene.brown>
References: <5230C98B.7030902@arcor.de>
	<1378929335-12606-2-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GdCEDtnlsf6rLQDujg7k6/3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1378929335-12606-2-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GdCEDtnlsf6rLQDujg7k6/3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sep 2013 21:55:35 +0200 mwilck@arcor.de wrote:

> Print an array name in brief output, like IMSM does.
>=20
> SUSE's YaST2 (libstorage) needs this in order to detect MD arrays
> during installation.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  super-ddf.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index c2ac88b..00a5c8b 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -1518,6 +1518,7 @@ static void getinfo_super_ddf(struct supertype *st,=
 struct mdinfo *info, char *m
> =20
>  static void uuid_from_ddf_guid(const char *guid, int uuid[4]);
>  static void uuid_from_super_ddf(struct supertype *st, int uuid[4]);
> +static void _ddf_array_name(char *name, const struct ddf_super *ddf, int=
 i);
> =20
>  static unsigned int get_vd_num_of_subarray(struct supertype *st)
>  {
> @@ -1577,6 +1578,7 @@ static void brief_examine_subarrays_ddf(struct supe=
rtype *st, int verbose)
>  		struct virtual_entry *ve =3D &ddf->virt->entries[i];
>  		struct vcl vcl;
>  		char nbuf1[64];
> +		char namebuf[17];
>  		if (all_ff(ve->guid))
>  			continue;
>  		memcpy(vcl.conf.guid, ve->guid, DDF_GUID_LEN);
> @@ -1584,7 +1586,9 @@ static void brief_examine_subarrays_ddf(struct supe=
rtype *st, int verbose)
>  		vcl.vcnum =3D i;
>  		uuid_from_super_ddf(st, info.uuid);
>  		fname_from_uuid(st, &info, nbuf1, ':');
> -		printf("ARRAY container=3D%s member=3D%d UUID=3D%s\n",
> +		_ddf_array_name(namebuf, ddf, i);
> +		printf("ARRAY%s%s container=3D%s member=3D%d UUID=3D%s\n",
> +		       namebuf[0] =3D=3D '\0' ? "" : " /dev/md/", namebuf,
>  		       nbuf+5, i, nbuf1+5);
>  	}
>  }

This an previous applied - thanks.

NeilBrown

--Sig_/GdCEDtnlsf6rLQDujg7k6/3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjFUyTnsnt1WYoG5AQLPcw/9HxoacneRPEEhNI26sdkXbvNi6qa23K30
ZtzT6g3uB4ESJPo9GVrxCUD9Qphmw2y3yjPRM6QwFNYvPnQYeyLEPtZTviK/di+v
IrKdeW6SB12qaUFZjkmKiutvpZ0OSTZeuUMLwgJ/12Ji+sdwAfk3MAAP5ERmBCwd
gM/dqr6NZUMos3mkRACRtP4x0M6jRgzhwR77YFxB66jPYrHsvIccTWiwgxaPGTyA
+Q2jutgmEVEpgg+/p6lVOGj5pAx+sw6YxlMmFJsk1H4zs7pQIBnELyieOtZTa7n9
wyQMFRvADyTue0zgKNllzw6QirwH5B8wS8cPq9gWgvbVk7/mwR5GIWt+odhIKw2r
G+QUA2lq8wqy6bzupkAuj/JqKEKFuG1obOIfJQ5wM8j88vWBCfLrR0c/3AYo/XaD
SnPXo1kzcQsBjQxeqSX6w3Q4+6x2n5u41L2xIfVbrUGk2YoLsji4gJWkuJh7f0QZ
hpFCr8DwWf+33LRL5bfv1Zhfj2TGDsOdlaTub+PWRFy1XR5gHNp1TdIJsC7BhJ0s
xmcj6hTed6YrSdZZz3Hzvd5b20lRIvpJf14508cfOiL9nZDv9uoXxK6J+o5vDbrT
wqlOGOvXY+NUgOyweMboeiAF5oybnF0WtuBakSxc7RCWcnLg9RtLsJgTKPvkKg9D
0diU2DSlUVs=
=8nrY
-----END PGP SIGNATURE-----

--Sig_/GdCEDtnlsf6rLQDujg7k6/3--
