From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/4] re-add a failed disk
Date: Thu, 9 Apr 2015 09:32:59 +1000
Message-ID: <20150409093259.58601eff@notabene.brown>
References: <20150408192337.GA9686@shrek.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/GhhfjkAVmjBZ_F51/uerN5u"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150408192337.GA9686@shrek.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-raid@vger.kernel.org, GQJiang@suse.com
List-Id: linux-raid.ids

--Sig_/GhhfjkAVmjBZ_F51/uerN5u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Apr 2015 14:23:37 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrot=
e:

> This adds the capability of re-adding a failed disk by
> writing "re-add" to /sys/block/mdXX/md/dev-YYY/state.
>=20
> This works for generic md, and is not (completely)
> related to clustering.

Again, more words here would help.
Explain why "remove, then add" isn't sufficient.

>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/md.c | 56 ++++++++++++++++++++++++++++++++++++---------------=
-----
>  1 file changed, 36 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0c65e51..83a8e91 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -79,6 +79,7 @@ static struct workqueue_struct *md_misc_wq;
> =20
>  static int remove_and_add_spares(struct mddev *mddev,
>  				 struct md_rdev *this);
> +static int add_bound_rdev(struct md_rdev *);
> =20
>  #define MD_BUG(x...) { printk("md: bug in file %s, line %d\n", __FILE__,=
 __LINE__); md_print_devices(); }
> =20
> @@ -2845,6 +2846,9 @@ state_store(struct md_rdev *rdev, const char *buf, =
size_t len)
>  			clear_bit(Replacement, &rdev->flags);
>  			err =3D 0;
>  		}
> +	} else if (cmd_match(buf, "re-add")) {
> +		clear_bit(Faulty, &rdev->flags);
> +		err =3D add_bound_rdev(rdev);

Shouldn't this  fail if the device isn't Faulty, of if raid_disk isn't '-1'=
 ??


>  	}
>  	if (!err)
>  		sysfs_notify_dirent_safe(rdev->sysfs_state);
> @@ -5861,6 +5865,37 @@ static int get_disk_info(struct mddev * mddev, voi=
d __user * arg)
>  	return 0;
>  }
> =20
> +static int add_bound_rdev(struct md_rdev *rdev)
> +{
> +	struct mddev *mddev =3D rdev->mddev;
> +	int err =3D 0;
> +
> +	if (!mddev->pers->hot_remove_disk) {
> +		/* If there is hot_add_disk but no hot_remove_disk
> +		 * then added disks for geometry changes,
> +		 * and should be added immediately.
> +		 */
> +		super_types[mddev->major_version].
> +			validate_super(mddev, rdev);
> +		err =3D mddev->pers->hot_add_disk(mddev, rdev);
> +		if (err)
> +			unbind_rdev_from_array(rdev);
> +	}
> +	if (err)
> +		export_rdev(rdev);
> +	else
> +		sysfs_notify_dirent_safe(rdev->sysfs_state);
> +
> +	set_bit(MD_CHANGE_DEVS, &mddev->flags);
> +	if (mddev->degraded)
> +		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> +	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +	if (!err)
> +		md_new_event(mddev);
> +	md_wakeup_thread(mddev->thread);
> +	return err;
> +}
> +
>  static int add_new_disk(struct mddev * mddev, mdu_disk_info_t *info)
>  {
>  	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
> @@ -5989,29 +6024,10 @@ static int add_new_disk(struct mddev * mddev, mdu=
_disk_info_t *info)
> =20
>  		rdev->raid_disk =3D -1;
>  		err =3D bind_rdev_to_array(rdev, mddev);
> -		if (!err && !mddev->pers->hot_remove_disk) {
> -			/* If there is hot_add_disk but no hot_remove_disk
> -			 * then added disks for geometry changes,
> -			 * and should be added immediately.
> -			 */
> -			super_types[mddev->major_version].
> -				validate_super(mddev, rdev);
> -			err =3D mddev->pers->hot_add_disk(mddev, rdev);
> -			if (err)
> -				unbind_rdev_from_array(rdev);
> -		}
>  		if (err)
>  			export_rdev(rdev);
>  		else
> -			sysfs_notify_dirent_safe(rdev->sysfs_state);
> -
> -		set_bit(MD_CHANGE_DEVS, &mddev->flags);
> -		if (mddev->degraded)
> -			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> -		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -		if (!err)
> -			md_new_event(mddev);
> -		md_wakeup_thread(mddev->thread);
> +			err =3D add_bound_rdev(rdev);
>  		if (mddev_is_clustered(mddev) &&
>  				(info->state & (1 << MD_DISK_CLUSTER_ADD)))
>  			md_cluster_ops->add_new_disk_finish(mddev);

This is a rather nice clean-up.  Possibly it could go in a separate patch -
or maybe not.

Also I think there is more room for improvement.
There is only one place in add_bound_rdev() that can set 'err', and I think
that when that happens we can just clean up and return. There is no real
need for the 'set_bit's or the wakeup.

Would you mind cleaning up a bit more?

Thanks,
NeilBrown


--Sig_/GhhfjkAVmjBZ_F51/uerN5u
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSW6qznsnt1WYoG5AQKPBg//X1kzZ3UZp6vlDwen2jePvD0GjjnFVww1
QboM0WjBTtrr/6kyF7SiB/3nemyFeg/xnkV3Uzx7PTSc9OiaUuyZNlrOj9aiduMn
zS77LSZBeJriQ5P1UU/BopH4Mz+UddUJhp56/WuILFe6hZ1N9la0x5IiceSVx4ee
kS5sGtaXRlWAtgM6kq1iz4ZEanGJKJrIJHcHC8zBBG7wxrLOf9dGnTs+GN1aEZQL
+aE7B3ho0QzsdSnIEBmQWOeu+kNwjPaj9DjuX/Ak13c2+ILrC37HFzQR8oEGs+aO
dKDE0mbatsssGseU15b+4dJ8TJ8CcDSTvLSUnLFvV3Wo987t4EY393yYT/qO3T/R
rs7o9/g4MGLlYMrTNzqGQZLSksZNFajVbwrqdE0MXBP7sbgUWH0aGBh+QvmhQF/e
UPVuDBVAtb1H6BcOiXJb8SjzSeluq8fBXe8tH3bF2S1iN/zmWCQBT3ZNKxoQsZ1l
DJNOfeUveMgzYEJlinXDGKNa7RoOsfUIid/R8ARPfJc7HG90fWH2tY0Jp48qYPx7
tEO/vRXHs+zhVXyHFlpKVpJesG/m4QzZGDjtlJhd+3if95vPFvvMMAaNwQT55U95
BKdlGxYbX4hDJLz9orXNOLDcX8XQ6r+Pp+xplqC/xGemqrRn7vp6Ktk7n5kSQ/6K
9kkIfreheAM=
=99i5
-----END PGP SIGNATURE-----

--Sig_/GhhfjkAVmjBZ_F51/uerN5u--
