From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: FIX: Spare disk has wrong serial after takeover
Date: Mon, 19 Sep 2011 13:22:32 +1000
Message-ID: <20110919132232.5b4de2a8@notabene.brown>
References: <20110915163839.5674.99218.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q1qZs6lG0D_/XW1OIcDfs=."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110915163839.5674.99218.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/Q1qZs6lG0D_/XW1OIcDfs=.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Sep 2011 18:38:39 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> Takeover marks disk as failed and adds to serial ':0' string and then
> turns it in to spare. This causes that when new spare is about to be used,
> it cannot be found due to different disk serial number.
>=20
> Restore disk serial number to avoid this problem.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

This looks believeable, and I really like the fact that you have factored o=
ut
'mark_spare' as a separate function rather having something open-coded at
various points.

I can't really say if it is 'right' as I don't understand all the details of
exactly how serial numbers are supposed to work.
So I'll apply it and hope than Dan will speak up if he sees any problems.

Thanks,
NeilBrown


> ---
>=20
>  super-intel.c |   46 ++++++++++++++++++++++++++++++++++++----------
>  1 files changed, 36 insertions(+), 10 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index a78d723..f1c924f 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -4407,6 +4407,37 @@ static int add_to_super_imsm_volume(struct superty=
pe *st, mdu_disk_info_t *dk,
>  	return 0;
>  }
> =20
> +/* mark_spare()
> + *   Function marks disk as spare and restores disk serial
> + *   in case it was previously marked as failed by takeover operation
> + * reruns:
> + *   -1 : critical error
> + *    0 : disk is marked as spare but serial is not set
> + *    1 : success
> + */
> +int mark_spare(struct dl *disk)
> +{
> +	__u8 serial[MAX_RAID_SERIAL_LEN];
> +	int ret_val =3D -1;
> +
> +	if (!disk)
> +		return ret_val;
> +
> +	ret_val =3D 0;
> +	if (!imsm_read_serial(disk->fd, NULL, serial)) {
> +		/* Restore disk serial number, because takeover marks disk
> +		 * as failed and adds to serial ':0' before it becomes
> +		 * a spare disk.
> +		 */
> +		serialcpy(disk->serial, serial);
> +		serialcpy(disk->disk.serial, serial);
> +		ret_val =3D 1;
> +	}
> +	disk->disk.status =3D SPARE_DISK;
> +	disk->index =3D -1;
> +
> +	return ret_val;
> +}
> =20
>  static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
>  			     int fd, char *devname)
> @@ -4444,7 +4475,6 @@ static int add_to_super_imsm(struct supertype *st, =
mdu_disk_info_t *dk,
>  	memset(dd, 0, sizeof(*dd));
>  	dd->major =3D major(stb.st_rdev);
>  	dd->minor =3D minor(stb.st_rdev);
> -	dd->index =3D -1;
>  	dd->devname =3D devname ? strdup(devname) : NULL;
>  	dd->fd =3D fd;
>  	dd->e =3D NULL;
> @@ -4461,7 +4491,7 @@ static int add_to_super_imsm(struct supertype *st, =
mdu_disk_info_t *dk,
>  	size /=3D 512;
>  	serialcpy(dd->disk.serial, dd->serial);
>  	dd->disk.total_blocks =3D __cpu_to_le32(size);
> -	dd->disk.status =3D SPARE_DISK;
> +	mark_spare(dd);
>  	if (sysfs_disk_to_scsi_id(fd, &id) =3D=3D 0)
>  		dd->disk.scsi_id =3D __cpu_to_le32(id);
>  	else
> @@ -4504,9 +4534,8 @@ static int remove_from_super_imsm(struct supertype =
*st, mdu_disk_info_t *dk)
>  	memset(dd, 0, sizeof(*dd));
>  	dd->major =3D dk->major;
>  	dd->minor =3D dk->minor;
> -	dd->index =3D -1;
>  	dd->fd =3D -1;
> -	dd->disk.status =3D SPARE_DISK;
> +	mark_spare(dd);
>  	dd->action =3D DISK_REMOVE;
> =20
>  	dd->next =3D super->disk_mgmt_list;
> @@ -5424,10 +5453,8 @@ static int kill_subarray_imsm(struct supertype *st)
>  		struct dl *d;
> =20
>  		for (d =3D super->disks; d; d =3D d->next)
> -			if (d->index > -2) {
> -				d->index =3D -1;
> -				d->disk.status =3D SPARE_DISK;
> -			}
> +			if (d->index > -2)
> +				mark_spare(d);
>  	}
> =20
>  	super->updates_pending++;
> @@ -7011,8 +7038,7 @@ static int apply_takeover_update(struct imsm_update=
_takeover *u,
>  					if (du->index > idx)
>  						du->index--;
>  				/* mark as spare disk */
> -				dm->disk.status =3D SPARE_DISK;
> -				dm->index =3D -1;
> +				mark_spare(dm);
>  			}
>  		}
>  		/* update map */


--Sig_/Q1qZs6lG0D_/XW1OIcDfs=.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOdrV4G5fc6gV+Wb0RAsjLAJ9DWpL3mDNWIzSNMtz5b3fxit0AjQCgn2+s
ialwzY8rbdioeMQsBry7I8U=
=1E7q
-----END PGP SIGNATURE-----

--Sig_/Q1qZs6lG0D_/XW1OIcDfs=.--
