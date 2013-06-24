From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] Detail: deterministic ordering in --brief --verbose
Date: Mon, 24 Jun 2013 16:57:04 +1000
Message-ID: <20130624165704.0cf94d1e@notabene.brown>
References: <1371759665-5625-1-git-send-email-mwilck@arcor.de>
	<1371759665-5625-2-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SLmRxwfxCybdfVv=zW3c+Sy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1371759665-5625-2-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SLmRxwfxCybdfVv=zW3c+Sy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Jun 2013 22:21:05 +0200 mwilck@arcor.de wrote:

> Have mdadm --Detail --brief --verbose print the list of devices in
> alphabetical order.
>=20
> This is useful for debugging purposes. E.g. the test script
> 10ddf-create compares the output of two mdadm -Dbv calls which
> may be different if the order is not deterministic.
>=20
> (I confess: I use a modified "test" script that always runs
> "mdadm --verbose" rather than "mdadm --quiet", otherwise this
> wouldn't happen in 10ddf-create).
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  Detail.c |   33 +++++++++++++++++++++++++--------
>  1 files changed, 25 insertions(+), 8 deletions(-)
>=20
> diff --git a/Detail.c b/Detail.c
> index 33b3a18..031219a 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -27,6 +27,11 @@
>  #include	"md_u.h"
>  #include	<dirent.h>
> =20
> +static int cmpstringp(const void *p1, const void *p2)
> +{
> +	return strcmp(* (char * const *) p1, * (char * const *) p2);
> +}
> +
>  int Detail(char *dev, struct context *c)
>  {
>  	/*
> @@ -42,7 +47,8 @@ int Detail(char *dev, struct context *c)
>  	int d;
>  	time_t atime;
>  	char *str;
> -	char *devices =3D NULL;
> +	char **devices =3D NULL;
> +	int max_devices =3D 0, n_devices =3D 0;
>  	int spares =3D 0;
>  	struct stat stb;
>  	int is_26 =3D get_linux_version() >=3D 2006000;
> @@ -636,12 +642,15 @@ This is pretty boring
>  		dv=3Dmap_dev_preferred(disk.major, disk.minor, 0, c->prefer);
>  		if (dv !=3D NULL) {
>  			if (c->brief) {
> -				if (devices) {
> -					devices =3D xrealloc(devices,
> -							  strlen(devices)+1+strlen(dv)+1);
> -					strcat(strcat(devices,","),dv);
> -				} else
> -					devices =3D xstrdup(dv);
> +				if (n_devices + 1 >=3D max_devices) {
> +					max_devices +=3D 16;
> +					devices =3D xrealloc(devices, max_devices
> +							   *sizeof(*devices));
> +					if (!devices)
> +						goto out;
> +				};
> +				devices[n_devices] =3D xstrdup(dv);
> +				n_devices++;
>  			} else
>  				printf("   %s", dv);
>  		}
> @@ -653,7 +662,12 @@ This is pretty boring
>  	if (st)
>  		st->ss->free_super(st);
> =20
> -	if (c->brief && c->verbose > 0 && devices) printf("\n   devices=3D%s", =
devices);
> +	if (c->brief && c->verbose > 0 && devices) {
> +		qsort(devices, n_devices, sizeof(*devices), cmpstringp);
> +		printf("\n   devices=3D%s", devices[0]);
> +		for (d =3D 1; d < n_devices; d++)
> +			printf(",%s", devices[d]);
> +	}
>  	if (c->brief)
>  		printf("\n");
>  	if (c->test &&
> @@ -666,6 +680,9 @@ out:
>  	close(fd);
>  	free(subarray);
>  	free(avail);
> +	for (d =3D 0; d < n_devices; d++)
> +		free(devices[d]);
> +	free(devices);
>  	sysfs_free(sra);
>  	return rv;
>  }


Applied, thanks.

NeilBrown

--Sig_/SLmRxwfxCybdfVv=zW3c+Sy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcftwDnsnt1WYoG5AQJH+w//ezM2fnMXDXR2ebd7i4DhH8jAjNa3CBAw
eElIbGVsLr7sMwrwfsRAhDtB46iZURVSymWXjCxrD7N554H0V+l0k4DZ18uLFgPs
SVcwh54QAdJN1Sw6izuee6d9QHarCBackUNzNNcklde2J/NpZAfQCyYsnCjd2tKS
vtRoKYR1D9vkAaOtnDWrZVCs0BcjFjnlk+j7MLp1dAwHsnyBdjBF4gMqRyCyKDba
Wde+lhk+YA0IihYl8npbrifXPLZofmDcLO0s4L8h9hNJtp2dPYCIFMTm7B4GNmIT
ITwShnbvki2qsmdmIn44vVW1pRhuRBQkzqUFCwZEf/9OJG/07N8aZ/1aOhtVnlXn
i5cOjTvhwfSy+TBiVczWyTC3ZGgMjrVeMQKiM+Eso8VGwSphI5aiCEDx/AFj6Ewo
MasQixgXLuk+Jq/G2cTRdRm10FEIt3hnZGtrV/RLdNPhofNGyA8Mx6JhmqUbom/Y
BjSJC/WGM+RUxQr+WZLYGQ8vcQM3waD3VcBRq6zrDlWUNDmI3mi9k5EOErBz6jTs
tBvMQeM2Oqap6grPsw2RmGp0HWO+FQzWTpei4dHaIefBTzlBnMmLWX6joSVjc8iO
fTZXJs/xd9licb1vL1t+imT7Pm48wMkCrlMxIYYKa9mno+IETE5fkaPGR60gqSj5
b4c5lF9ZN38=
=PMgA
-----END PGP SIGNATURE-----

--Sig_/SLmRxwfxCybdfVv=zW3c+Sy--
