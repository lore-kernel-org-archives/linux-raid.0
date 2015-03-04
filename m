From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] IncRemove: Set "auto-read" only after successful excl
 open.
Date: Wed, 4 Mar 2015 16:01:11 +1100
Message-ID: <20150304160111.0f0c3c78@notabene.brown>
References: <20150227144754.9507.71855.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/T29B9Oltm.rRBemP75glEGq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150227144754.9507.71855.stgit@gklab-154-222.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

--Sig_/T29B9Oltm.rRBemP75glEGq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Feb 2015 15:47:54 +0100 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> "mdadm -If" - triggered from udev rules when disk is removed from OS -
> tries to set array in auto-read-only mode. This can interrupt rebuild
> process which is started automatically, e.g. if array is mounted and
> spare disk is available (I/O error is detected faster than removing
> failed disk by mdadm).
> This patch prevents "mdadm -If" from setting array into "auto-read-only",
> by requiring exclusive open to succeed.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  Incremental.c |   16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>=20
> diff --git a/Incremental.c b/Incremental.c
> index 87d9114..b12f144 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -1712,12 +1712,16 @@ int IncrementalRemove(char *devname, char *id_pat=
h, int verbose)
>  		return 1;
>  	}
>  	sysfs_init(&mdi, -1, ent->devnm);
> -	if (sysfs_get_str(&mdi, NULL, "array_state",
> -			  buf, sizeof(buf)) > 0) {
> -		if (strncmp(buf, "active", 6) =3D=3D 0 ||
> -		    strncmp(buf, "clean", 5) =3D=3D 0)
> -			sysfs_set_str(&mdi, NULL,
> -				      "array_state", "read-auto");
> +	mdfd =3D open_dev_excl(ent->devnm);
> +	if (mdfd > 0) {
> +		close(mdfd);
> +		if (sysfs_get_str(&mdi, NULL, "array_state",
> +				  buf, sizeof(buf)) > 0) {
> +			if (strncmp(buf, "active", 6) =3D=3D 0 ||
> +			    strncmp(buf, "clean", 5) =3D=3D 0)
> +				sysfs_set_str(&mdi, NULL,
> +					      "array_state", "read-auto");
> +		}
>  	}
>  	mdfd =3D open_dev(ent->devnm);
>  	if (mdfd < 0) {


Applied, thanks.
NeilBrown

--Sig_/T29B9Oltm.rRBemP75glEGq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVPaRlznsnt1WYoG5AQJ/rg/9GJGGSRjZyygleC4GbLDEEdt3WHQKAyB6
UXcW4h5Ecq6zabxFgmeqxqASOcaS4gg15yocj3y8T1cACsGcQbla2vXTvsByjTeQ
EZRkSnE92wHsaebn3X4AZTSeroPnC/hK9K4JAP6LTkDsfTHUQkRC/nn5HbugfJRc
+aUQlwQLFagGXSmqMUizjSf5w3MHCcEk5DDIdYT13du+oT214Go41j7SGkD0W77Z
T9sYF7aDQQH5iGGcNCwgEcurwygNag86Ua9PlDOObwseLdE1JuC3AqvOWY91UJY3
xE0WPOJQYS7kUT20sYv3re0KoCtI6QTxyVVgHe8taFJveu1aoI+v+ffZV3uiUoSv
8MB7RQ1DHp2Rf5t/jokm0zcfRE+3vZJR3k8pE1aI6Cp34wbocIUW99Psb0YSsVGv
OeyInK4Jlsad5gY0Dq5MSs+8PyvEabWHyGpQmDhIfDEWGc2BGdyOWy4saU8R+jFv
M6cB3PrhhV4qMKJY805rdLVJU38EFiJhz+XBiykDBEvwBC38Y7DeeL5fvAT9nJ1T
JZ6i9kzBzDiDoVcgDDwObxYhtKD5xRCtIyOY3otVhzXP7jBiyQ8sO4JT9D5ZoQgg
KTUVbQEQEd1B1EWBXtK/fKha+P4794DLWoGsWuO6Pa/wK6BiIc4her+BH0nWKGOW
JmzT+HJMOlc=
=rYIZ
-----END PGP SIGNATURE-----

--Sig_/T29B9Oltm.rRBemP75glEGq--
