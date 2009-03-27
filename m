From: Andre Noll <maan@systemlinux.org>
Subject: Re: [md PATCH 5/6] md: allow number of drives in raid5 to be reduced
Date: Fri, 27 Mar 2009 17:19:42 +0100
Message-ID: <20090327161942.GR17185@skl-net.de>
References: <20090324084629.15383.10271.stgit@notabene.brown> <20090324085332.15383.76701.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R9lH2i8s2YEs6mH7"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090324085332.15383.76701.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--R9lH2i8s2YEs6mH7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19:53, NeilBrown wrote:

> Never allow the size to be reduced below the minimum (4 doe raid6,
> 3 otherwise).

doe?

> @@ -3723,6 +3723,7 @@ static sector_t reshape_request(mddev_t *mddev, sec=
tor_t sector_nr, int *skipped
>  	int i;
>  	int dd_idx;
>  	sector_t writepos, safepos, gap;
> +	sector_t stripe_addr;
> =20
>  	if (sector_nr =3D=3D 0) {
>  		/* If restarting in the middle, skip the initial sectors */
> @@ -3779,10 +3780,21 @@ static sector_t reshape_request(mddev_t *mddev, s=
ector_t sector_nr, int *skipped
>  		wake_up(&conf->wait_for_overlap);
>  	}
> =20
> +	if (mddev->delta_disks < 0) {
> +		BUG_ON(conf->reshape_progress =3D=3D 0);
> +		stripe_addr =3D writepos;
> +		BUG_ON((mddev->dev_sectors &
> +			~((sector_t)mddev->chunk_size / 512 - 1))
> +		       - (conf->chunk_size / 512) - stripe_addr
> +		       !=3D sector_nr);
> +	} else {
> +		BUG_ON(writepos !=3D sector_nr + conf->chunk_size / 512);
> +		stripe_addr =3D writepos;
> +	}

What's the point of the new stripe_addr variable? Isn't it equal to
writepos in any case?

> @@ -4738,14 +4755,25 @@ static int raid5_check_reshape(mddev_t *mddev)
>  	raid5_conf_t *conf =3D mddev_to_conf(mddev);
>  	int err;
> =20
> -	if (mddev->delta_disks < 0 ||
> -	    mddev->new_level !=3D mddev->level)
> -		return -EINVAL; /* Cannot shrink array or change level yet */
>  	if (mddev->delta_disks =3D=3D 0)
>  		return 0; /* nothing to do */
>  	if (mddev->bitmap)
>  		/* Cannot grow a bitmap yet */
>  		return -EBUSY;
> +	if (mddev->degraded > conf->max_degraded)
> +		return -EINVAL;
> +	if (mddev->delta_disks < 0) {
> +		/* We might be able to shrink, but the devices must
> +		 * be made bigger first.
> +		 * For raid6, 4 is the minimum size.
> +		 * Otherwise 2 is the minimum
> +		 */
> +		int min =3D 2;
> +		if (mddev->level =3D=3D 6)
> +			min =3D 4;
> +		if (mddev->raid_disks + mddev->delta_disks < min)
> +			return -EINVAL;
> +	}

Hm, this code doesn't seem to do what the comment suggests. IMHO,
we must check that

	(a) (raid_disks + delta_disks) * sizeof(smallest) is big enough
and
	(b) raid_disks + delta_disks >=3D minimal admissible number of disks

The comment says the devices must be made bigger (to satisfy (a))
but the code only checks (b).

> @@ -4862,21 +4905,38 @@ static void raid5_finish_reshape(mddev_t *mddev)
>  	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
> =20
>  		conf->previous_raid_disks =3D conf->raid_disks;
> -		md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
> -		set_capacity(mddev->gendisk, mddev->array_sectors);
> -		mddev->changed =3D 1;
> -
> -		bdev =3D bdget_disk(mddev->gendisk, 0);
> -		if (bdev) {
> -			mutex_lock(&bdev->bd_inode->i_mutex);
> -			i_size_write(bdev->bd_inode,
> -				     (loff_t)mddev->array_sectors << 9);
> -			mutex_unlock(&bdev->bd_inode->i_mutex);
> -			bdput(bdev);
> -		}
>  		spin_lock_irq(&conf->device_lock);
>  		conf->reshape_progress =3D MaxSector;
>  		spin_unlock_irq(&conf->device_lock);
> +		if (mddev->delta_disks > 0) {
> +			conf->previous_raid_disks =3D conf->raid_disks;

previous_raid_disks was already assigned earlier, so this can go away,
imo.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--R9lH2i8s2YEs6mH7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJzPyeWto1QDEAkw8RAg5cAJ4vXn1uu70oGgsx59qGob/tKuzJcACfYGDH
RNX78WMjtlja+G+R8HtJdeE=
=CehN
-----END PGP SIGNATURE-----

--R9lH2i8s2YEs6mH7--
