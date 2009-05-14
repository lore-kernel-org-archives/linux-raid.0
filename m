From: Andre Noll <maan@systemlinux.org>
Subject: Re: PATCH md [001:002]: raid0: fix chunk size to 4K*n granularity
Date: Thu, 14 May 2009 16:07:29 +0200
Message-ID: <20090514140729.GI11504@skl-net.de>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org> <1242297833-13908-2-git-send-email-maan@systemlinux.org> <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name> <20090514121042.GH11504@skl-net.de> <4743925b38e2d64317e0b6d7c8005a29.squirrel@neil.brown.name> <1242316703.11444.12.camel@raz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="81JctsDUVPekGcy+"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1242316703.11444.12.camel@raz>
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--81JctsDUVPekGcy+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18:58, raz ben yehuda wrote:

>  Andre, Patch is applied on top of your last post. now it is your turn to=
 merge :)

I'll have to rework my patch series and will hopefully send the new
series tomorrow.

If it's clear that moving raid0 to 4K granularity is good thing to do,
I'll add your patches on top of the new series.

>  static sector_t calc_num_sectors(mdk_rdev_t *rdev, unsigned chunk_size)
>  {
>  	sector_t num_sectors =3D rdev->sb_start;
> -
> -	if (chunk_size)
> -		num_sectors &=3D ~((sector_t)chunk_size/512 - 1);
> +	if (chunk_size) {
> +		int chunk_sects =3D chunk_size>>9;

As chunk_size is unsigned, chunk_sects should probably also be unsigned.

> +		num_sectors =3D (num_sectors/chunk_sects)*chunk_sects;

A ROUND_DOWN macro perhaps? There are only four of them in the kernel
tree :-/

> @@ -3512,7 +3514,7 @@ min_sync_store(mddev_t *mddev, const char *buf, siz=
e_t len)
> =20
>  	/* Must be a multiple of chunk_size */
>  	if (mddev->chunk_size) {
> -		if (min & (sector_t)((mddev->chunk_size>>9)-1))
> +		if (min % (sector_t)(mddev->chunk_size>>9))
>  			return -EINVAL;
>  	}
>  	mddev->resync_min =3D min;
> @@ -3549,7 +3551,7 @@ max_sync_store(mddev_t *mddev, const char *buf, siz=
e_t len)
> =20
>  		/* Must be a multiple of chunk_size */
>  		if (mddev->chunk_size) {
> -			if (max & (sector_t)((mddev->chunk_size>>9)-1))
> +			if (max % (sector_t)((mddev->chunk_size>>9)))

If we decide to clean these up, we might as well do it right and
use ffz()/ffs().

> +		/*
> +		* raid0 chunk size has to divide by a page
> +		*/

Nitpick: I'd prefer to say "must be a multiple of", and the indentation
does not match coding style standards.

> +static int raid0_is_power2_chunk(mddev_t *mddev)
> +{
> +	if ((1 << ffz(~mddev->chunk_size)) =3D=3D mddev->chunk_size)
> +		return 1;
> +	return 0;
> +}

This could be go to md.h as an inline function or at least be used
everywhere in raid0.c.

> -/* Find the zone which holds a particular offset */
> -static struct strip_zone *find_zone(struct raid0_private_data *conf,
> -		sector_t sector)
> +static int raid0_position_bio(mddev_t *mddev, struct bio *bio, sector_t =
sector)
>  {
> -	int i;
> -
> -	for (i =3D 0; i < conf->nr_strip_zones; i++) {
> -		struct strip_zone *z =3D conf->strip_zone + i;
> -
> -		if (sector < z->zone_start + z->sectors)
> -			return z;
> -	}
> -	BUG();
> -	return NULL;
> +	sector_t sect_in_chunk;
> +	mdk_rdev_t *tmp_dev;
> +	sector_t chunk_in_dev;
> +	sector_t rsect;
> +	sector_t x;
> +	raid0_conf_t *conf =3D mddev_to_conf(mddev);
> +	sector_t chunk_sects =3D mddev->chunk_size >> 9;
> +	struct strip_zone *zone =3D &conf->strip_zone[0];
> +
> +	while (sector >=3D zone->zone_start + zone->sectors)
> +		zone++;
> +	sect_in_chunk =3D sector % chunk_sects;
> +	x =3D (sector - zone->zone_start) / chunk_sects;
> +	sector_div(x, zone->nb_dev);
> +	chunk_in_dev =3D x;
> +	x =3D sector / chunk_sects;
> +	tmp_dev =3D zone->dev[sector_div(x, zone->nb_dev)];
> +	rsect =3D (chunk_in_dev * chunk_sects) + zone->dev_start + sect_in_chun=
k;
> +	bio->bi_bdev =3D tmp_dev->bdev;
> +	bio->bi_sector =3D rsect + tmp_dev->data_offset;
> +	return 0;
>  }

This clashes of course with the planned changes that extend stripe_zone.

I'll see what I can do.
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--81JctsDUVPekGcy+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKDCWhWto1QDEAkw8RAkyMAJ4wZlniMRoy6npalKYTh5nPUA1isgCfZZxT
eZSFBYIgvtbk44RtyMfbvCY=
=vWJy
-----END PGP SIGNATURE-----

--81JctsDUVPekGcy+--
