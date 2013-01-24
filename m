From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH - for v3.7] DM-RAID: Fix RAID10's check for sufficient
 redundancy
Date: Thu, 24 Jan 2013 12:17:10 +1100
Message-ID: <20130124121710.6220bb60@notabene.brown>
References: <1357783259.9103.5.camel@f16>
	<1358912538.5871.3.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ajuHnJz7+w0ec/EWABNPOUB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1358912538.5871.3.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, agk@redhat.com
List-Id: linux-raid.ids

--Sig_/ajuHnJz7+w0ec/EWABNPOUB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Jan 2013 21:42:18 -0600 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
>  Here is the RAID10 redundancy check fix backported for linux-3.7

Thanks.

So this goes into 3.7.y and bumps the dm-raid version to 1.3.2

It should also go into 3.8-rc and bump the dm-raid version there to 1.4.1

Then "Add support for MD's RAID10 "far" and "offset" algorithms" which is d=
ue
to go into 3.9-rc should bump the dm-raid version to 1.4.2.

Is that right?

I' re-arranged the patches in my for-next to match this - please check I
didn't mess anything up.  Then I'll send them off.

Thanks,
NeilBrown


>=20
> Thanks,
>  brassow
>=20
>=20
> DM RAID:  Fix RAID10's check for sufficient redundancy
>=20
> Before attempting to activate a RAID array, it is checked for sufficient
> redundancy.  That is, we make sure that there are not too many failed
> devices - or devices specified for rebuild - to undermine our ability to
> activate the array.  The current code performs this check twice - once to
> ensure there were not too many devices specified for rebuild by the user
> ('validate_rebuild_devices') and again after possibly experiencing a fail=
ure
> to read the superblock ('analyse_superblocks').  Neither of these checks =
are
> sufficient.  The first check is done properly but with insufficient
> information about the possible failure state of the devices to make a good
> determination if the array can be activated.  The second check is simply
> done wrong in the case of RAID10 because it doesn't account for the
> independence of the stripes (i.e. mirror sets).  The solution is to use t=
he
> properly written check ('validate_rebuild_devices'), but perform the check
> after the superblocks have been read and we know which devices have faile=
d.
> This gives us one check instead of two and performs it in a location where
> it can be done right.
>=20
> Only RAID10 was affected and it was affected in the following ways:
> - the code did not properly catch the condition where a user specified
>   a device for rebuild that already had a failed device in the same mirror
>   set.  (This condition would, however, be caught at a deeper level in MD=
.)
> - the code triggers a false positive and denies activation when devices in
>   independent mirror sets have failed - counting the failures as though t=
hey
>   were all in the same set.
>=20
> The most likely place this error was introduced (or this patch should have
> been included) is in commit 4ec1e369 - first introduced in v3.7-rc1.
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> Index: linux-upstream/Documentation/device-mapper/dm-raid.txt
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/Documentation/device-mapper/dm-raid.txt
> +++ linux-upstream/Documentation/device-mapper/dm-raid.txt
> @@ -141,3 +141,4 @@ Version History
>  1.2.0	Handle creation of arrays that contain failed devices.
>  1.3.0	Added support for RAID 10
>  1.3.1	Allow device replacement/rebuild for RAID 10
> +1.3.2   Fix/improve redundancy checking for RAID10
> Index: linux-upstream/drivers/md/dm-raid.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/dm-raid.c
> +++ linux-upstream/drivers/md/dm-raid.c
> @@ -338,24 +338,22 @@ static int validate_region_size(struct r
>  }
> =20
>  /*
> - * validate_rebuild_devices
> + * validate_raid_redundancy
>   * @rs
>   *
> - * Determine if the devices specified for rebuild can result in a valid
> - * usable array that is capable of rebuilding the given devices.
> + * Determine if there are enough devices in the array that haven't
> + * failed (or are being rebuilt) to form a usable array.
>   *
>   * Returns: 0 on success, -EINVAL on failure.
>   */
> -static int validate_rebuild_devices(struct raid_set *rs)
> +static int validate_raid_redundancy(struct raid_set *rs)
>  {
>  	unsigned i, rebuild_cnt =3D 0;
>  	unsigned rebuilds_per_group, copies, d;
> =20
> -	if (!(rs->print_flags & DMPF_REBUILD))
> -		return 0;
> -
>  	for (i =3D 0; i < rs->md.raid_disks; i++)
> -		if (!test_bit(In_sync, &rs->dev[i].rdev.flags))
> +		if (!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
> +		    !rs->dev[i].rdev.sb_page)
>  			rebuild_cnt++;
> =20
>  	switch (rs->raid_type->level) {
> @@ -391,27 +389,24 @@ static int validate_rebuild_devices(stru
>  		 *          A    A    B    B    C
>  		 *          C    D    D    E    E
>  		 */
> -		rebuilds_per_group =3D 0;
>  		for (i =3D 0; i < rs->md.raid_disks * copies; i++) {
> +			if (!(i % copies))
> +				rebuilds_per_group =3D 0;
>  			d =3D i % rs->md.raid_disks;
> -			if (!test_bit(In_sync, &rs->dev[d].rdev.flags) &&
> +			if ((!rs->dev[d].rdev.sb_page ||
> +			     !test_bit(In_sync, &rs->dev[d].rdev.flags)) &&
>  			    (++rebuilds_per_group >=3D copies))
>  				goto too_many;
> -			if (!((i + 1) % copies))
> -				rebuilds_per_group =3D 0;
>  		}
>  		break;
>  	default:
> -		DMERR("The rebuild parameter is not supported for %s",
> -		      rs->raid_type->name);
> -		rs->ti->error =3D "Rebuild not supported for this RAID type";
> -		return -EINVAL;
> +		if (rebuild_cnt)
> +			return -EINVAL;
>  	}
> =20
>  	return 0;
> =20
>  too_many:
> -	rs->ti->error =3D "Too many rebuild devices specified";
>  	return -EINVAL;
>  }
> =20
> @@ -662,9 +657,6 @@ static int parse_raid_params(struct raid
>  	}
>  	rs->md.dev_sectors =3D sectors_per_dev;
> =20
> -	if (validate_rebuild_devices(rs))
> -		return -EINVAL;
> -
>  	/* Assume there are no metadata devices until the drives are parsed */
>  	rs->md.persistent =3D 0;
>  	rs->md.external =3D 1;
> @@ -993,28 +985,10 @@ static int super_validate(struct mddev *
>  static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
>  {
>  	int ret;
> -	unsigned redundancy =3D 0;
>  	struct raid_dev *dev;
>  	struct md_rdev *rdev, *tmp, *freshest;
>  	struct mddev *mddev =3D &rs->md;
> =20
> -	switch (rs->raid_type->level) {
> -	case 1:
> -		redundancy =3D rs->md.raid_disks - 1;
> -		break;
> -	case 4:
> -	case 5:
> -	case 6:
> -		redundancy =3D rs->raid_type->parity_devs;
> -		break;
> -	case 10:
> -		redundancy =3D raid10_md_layout_to_copies(mddev->layout) - 1;
> -		break;
> -	default:
> -		ti->error =3D "Unknown RAID type";
> -		return -EINVAL;
> -	}
> -
>  	freshest =3D NULL;
>  	rdev_for_each_safe(rdev, tmp, mddev) {
>  		/*
> @@ -1043,44 +1017,43 @@ static int analyse_superblocks(struct dm
>  			break;
>  		default:
>  			dev =3D container_of(rdev, struct raid_dev, rdev);
> -			if (redundancy--) {
> -				if (dev->meta_dev)
> -					dm_put_device(ti, dev->meta_dev);
> +			if (dev->meta_dev)
> +				dm_put_device(ti, dev->meta_dev);
> =20
> -				dev->meta_dev =3D NULL;
> -				rdev->meta_bdev =3D NULL;
> +			dev->meta_dev =3D NULL;
> +			rdev->meta_bdev =3D NULL;
> =20
> -				if (rdev->sb_page)
> -					put_page(rdev->sb_page);
> +			if (rdev->sb_page)
> +				put_page(rdev->sb_page);
> =20
> -				rdev->sb_page =3D NULL;
> +			rdev->sb_page =3D NULL;
> =20
> -				rdev->sb_loaded =3D 0;
> +			rdev->sb_loaded =3D 0;
> =20
> -				/*
> -				 * We might be able to salvage the data device
> -				 * even though the meta device has failed.  For
> -				 * now, we behave as though '- -' had been
> -				 * set for this device in the table.
> -				 */
> -				if (dev->data_dev)
> -					dm_put_device(ti, dev->data_dev);
> -
> -				dev->data_dev =3D NULL;
> -				rdev->bdev =3D NULL;
> +			/*
> +			 * We might be able to salvage the data device
> +			 * even though the meta device has failed.  For
> +			 * now, we behave as though '- -' had been
> +			 * set for this device in the table.
> +			 */
> +			if (dev->data_dev)
> +				dm_put_device(ti, dev->data_dev);
> =20
> -				list_del(&rdev->same_set);
> +			dev->data_dev =3D NULL;
> +			rdev->bdev =3D NULL;
> =20
> -				continue;
> -			}
> -			ti->error =3D "Failed to load superblock";
> -			return ret;
> +			list_del(&rdev->same_set);
>  		}
>  	}
> =20
>  	if (!freshest)
>  		return 0;
> =20
> +	if (validate_raid_redundancy(rs)) {
> +		rs->ti->error =3D "Insufficient redundancy to activate array";
> +		return -EINVAL;
> +	}
> +
>  	/*
>  	 * Validation of the freshest device provides the source of
>  	 * validation for the remaining devices.
> @@ -1430,7 +1403,7 @@ static void raid_resume(struct dm_target
> =20
>  static struct target_type raid_target =3D {
>  	.name =3D "raid",
> -	.version =3D {1, 3, 1},
> +	.version =3D {1, 3, 2},
>  	.module =3D THIS_MODULE,
>  	.ctr =3D raid_ctr,
>  	.dtr =3D raid_dtr,
>=20


--Sig_/ajuHnJz7+w0ec/EWABNPOUB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUQCLljnsnt1WYoG5AQKmMBAAj4Brf0V1reSlzqHojjiQf0eSIEr52c50
CO9zZ6HcOvcBp3d2L6D4tbGQb2/GntwSKDH07K0H9axVobbdPv4bvIuaNFRTGeda
LSl51zpeQ/JJ5VJuY2nJS4TzTOo+6b3/0KExUr/El18LgBJVeIv832NWWRHrUCJr
c1WTb/m1r4MOGpaQ7EsDeR6mjxsaUFV7Jhya7DmLw+xQZ8+irc6bKm7DfLNMbUIl
UCLnKbfdnr21CnILaKy+HCVqk/IuGX8RGjlhHQsNa8vA4rJEXfyHAqWsv62XCqwF
CfQrVsjMGFaikaTMfM3app/4Ay1D+O44XlboxDpBt2JFvMavP8u9+vtM9PK4dVkg
ykS94vEsmGOnX83WHSBdOx6PzgnMta2XHvJcILkM6/qwxoIFk0YlMxnGoG7SA5j9
mmK07aLl4tih0YlipLKi5IFWwHpDGPFoMFhCiY4SbPVzNuC/pdd+B8G2Odrm2Jvz
cZyqVdI4HbsSPanoOdd17U7k5L3uyCX12h3f4Z1VfEh57JR5yQOLxyP7bczWIAcS
4utuSVcEp4ltfWWOuNPcHw15YNPEjZxmb9XyJ7e8fqfzXwxlHwVHtJWNavOoRczu
55bKR6Jy53Ush0xnZOmJuYaFxIivfuCms2rGjexNbPoaFmKnVYg7PDBZncufpFma
97cXLMK0WYU=
=EQPg
-----END PGP SIGNATURE-----

--Sig_/ajuHnJz7+w0ec/EWABNPOUB--
