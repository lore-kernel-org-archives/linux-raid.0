From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 5/6] md: re-add a failed disk
Date: Mon, 20 Apr 2015 11:56:40 +1000
Message-ID: <20150420115640.1eb3d371@notabene.brown>
References: <20150414154522.GA4105@shrek.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/pNocEVmu3+tVd4SknY2oJpO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150414154522.GA4105@shrek.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: GQJiang@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/pNocEVmu3+tVd4SknY2oJpO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Apr 2015 10:45:22 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wro=
te:

> This adds the capability of re-adding a failed disk by
> writing "re-add" to /sys/block/mdXX/md/dev-YYY/state.
>=20
> This facilitates adding disks which have encountered a temporary
> error such as a network disconnection/hiccup in an iSCSI device,
> or a SAN cable disconnection which has been restored. In such
> a situation, you do not need to remove and re-add the device.
> Writing re-add to the failed device's state would add it again
> to the array and perform the recovery of only the blocks which
> were written after the device failed.
>=20
> This works for generic md, and is not related to clustering. However,
> this patch is to ease re-add operations listed above in clustering
> environments.
>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/md.c | 56 +++++++++++++++++++++++++++++++++++----------------=
-----
>  1 file changed, 35 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9127d11..ba01605 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2379,6 +2379,36 @@ repeat:
>  }
>  EXPORT_SYMBOL(md_update_sb);
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
> +		if (err) {
> +			unbind_rdev_from_array(rdev);
> +			export_rdev(rdev);
> +			return err;
> +		}
> +	}
> +	sysfs_notify_dirent_safe(rdev->sysfs_state);
> +
> +	set_bit(MD_CHANGE_DEVS, &mddev->flags);
> +	if (mddev->degraded)
> +		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> +	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +	md_new_event(mddev);
> +	md_wakeup_thread(mddev->thread);
> +	return 0;
> +}
> +
>  /* words written to sysfs files may, or may not, be \n terminated.
>   * We want to accept with case. For this we use cmd_match.
>   */
> @@ -2568,7 +2598,10 @@ state_store(struct md_rdev *rdev, const char *buf,=
 size_t len)
>  			clear_bit(Replacement, &rdev->flags);
>  			err =3D 0;
>  		}
> -	}
> +	} else if (cmd_match(buf, "re-add") && (test_bit(Faulty, &rdev->flags) =
|| (rdev->raid_disk =3D=3D -1))) {
> +			clear_bit(Faulty, &rdev->flags);
> +			err =3D add_bound_rdev(rdev);
> +		}

I changed this to:

	} else if (cmd_match(buf, "re-add")) {
		if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk =3D=3D -1)) {
			clear_bit(Faulty, &rdev->flags);
			err =3D add_bound_rdev(rdev);
		} else
			err =3D -EBUSY;
	}


because:
1/ I want all branches of the main if/else to be just "cmd_match...",
2/ I want to return EBUSY, if 're-add' was recognised as a command, but
   the default wasn't available for a re-add, and
3/ re-add can only be allowed if the device is faulty AND raid_disk is -1.
   If not faulty, re-add makes no sense.
   If raid_disk is not -1, then the device still has outstanding IO and
   we need to keep waiting for that to complete.

Otherwise, patch accepted - thanks.

NeilBrown


>  	if (!err)
>  		sysfs_notify_dirent_safe(rdev->sysfs_state);
>  	return err ? err : len;
> @@ -5882,29 +5915,10 @@ static int add_new_disk(struct mddev *mddev, mdu_=
disk_info_t *info)
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


--Sig_/pNocEVmu3+tVd4SknY2oJpO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTRc2Tnsnt1WYoG5AQJKTQ//bWkrTZpuGwWxRmvknaP+P8r4CCjb64pW
/XM7jsrHRuVgkXsUbU29cksSr4prEeN3Nb8WDBxVdfexUFuaHIAZ6CXq0J9tpLyD
OHL/C+cp0xKKfrYJmiUcj54mUQKrMGSNHWl/aOq1HKiffpSfSWBwCn0JEnz5MtK/
9FIh3pooK+DBDeRnf7Km3hGtJfOn+BxFcCrAksOc7+i0T21zy8LjhSek9ra2SBAg
TSx1jLQrAXCtFeHd9sti7vDdYBl2u+oqeGl13470BwN+AXBhif8PXXSK7sj38gVl
W0x7Dyw7CUeVJ7hiGOsapeWNJhubXAKcdUa9LEvafv38+wJkJZ6lnTDCQ6fEufWF
qjQuRXPr+i7ePRSeRi6LsDWEufFc8phmwwxvxqOwsIPia6egOApOyZ8rl9NFDUyi
ETCLHjXEzU3qs05GdaBSxCqOlejBz3bmKqtoLViqqKx30QXQBxOKinqOK/8sX1O4
zN2yOyEl9WCIO9yVw1yt/4PAOtHl9d+Z2M7wVoo2XRe/MlHg/Izqk0Pkrll9u0aR
PrllHZjCK1VUEzAMdWJXDuaIe1xCKc5ubhKGs8tBpoI4dCVXaCR8n/7+JABIpLYB
zaWoVI5D2VElX+1yaMYubJfZbALHIjc6c0gqMk4kjJBZWSMbBMVcFiqr3bc/9MGR
Zyc05qqn1Iw=
=3eKB
-----END PGP SIGNATURE-----

--Sig_/pNocEVmu3+tVd4SknY2oJpO--
