From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 1/3] md: add 'size' as a personality method
Date: Fri, 6 Mar 2009 17:15:51 +0100
Message-ID: <20090306161551.GI32416@skl-net.de>
References: <20090306002341.9882.61625.stgit@dwillia2-linux.ch.intel.com> <20090306002448.9882.88409.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="boAH8PqvUi1v1f55"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090306002448.9882.88409.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids


--boAH8PqvUi1v1f55
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:24, Dan Williams wrote:
> +raid10_size(mddev_t *mddev, sector_t sectors, int raid_disks)
> +{
> +	sector_t size;
> +	int chunk_shift;
> +	conf_t *conf =3D mddev_to_conf(mddev);
> +	int chunk_size =3D mddev->chunk_size;
> +
> +	if (!raid_disks)
> +		raid_disks =3D mddev->raid_disks;
> +	if (!sectors)
> +		sectors =3D mddev->dev_sectors;
> +
> +	chunk_shift =3D ffz(~chunk_size) - 9;
> +	size =3D sectors >> chunk_shift;
> +	sector_div(size, conf->far_copies);
> +	size =3D size * raid_disks;
> +	sector_div(size, conf->near_copies);
> +
> +	return size << chunk_shift;
> +}

Is there a reason you are recomputing chunk_shift instead of using
conf->chunk_shift.

> +static sector_t
> +raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
> +{
> +	raid5_conf_t *conf =3D mddev_to_conf(mddev);
> +	int chunk_size =3D mddev->chunk_size;
> +
> +	if (!sectors)
> +		sectors =3D mddev->dev_sectors;
> +	if (!raid_disks)
> +		raid_disks =3D conf->previous_raid_disks;
> +
> +	sectors &=3D ~(chunk_size / 512 - 1);

Don't we need a cast to sector_t here?

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--boAH8PqvUi1v1f55
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJsUw3Wto1QDEAkw8RArJzAKCgUKPNEACcLT/D/Gd/EGORmJzC6wCgq3wi
HCvK16GRtnzQLvNmhMs+Jbg=
=nCRW
-----END PGP SIGNATURE-----

--boAH8PqvUi1v1f55--
