From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 3/3] md: 'array_size' sysfs attribute
Date: Fri, 6 Mar 2009 17:15:59 +0100
Message-ID: <20090306161559.GJ32416@skl-net.de>
References: <20090306002341.9882.61625.stgit@dwillia2-linux.ch.intel.com> <20090306002458.9882.82188.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/D3X8sky0X3AmG5"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090306002458.9882.82188.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids


--W/D3X8sky0X3AmG5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:24, Dan Williams wrote:
> Allow userspace to set the size of the array according to the following
> semantics:
>=20
> 1/ size must be <=3D to the size returned by mddev->pers->size(mddev, 0, =
0)
>    a) If size is set before the array is running, do_md_run will fail
>       if size is greater than the default size
>    b) A reshape attempt that reduces the default size to less than the set
>       array size should be blocked
> 2/ once userspace sets the size the kernel will not change it

This holds only until the array is stopped and reassembled (for
example due to a reboot). Is that correct and intended?

> +static ssize_t
> +array_size_store(mddev_t *mddev, const char *buf, size_t len)
> +{
> +	unsigned long long sectors;
> +	struct block_device *bdev;
> +
> +	if (strncmp(buf, "default", 7) =3D=3D 0) {
> +		if (mddev->pers)
> +			sectors =3D mddev->pers->size(mddev, 0, 0);
> +		else
> +			sectors =3D mddev->array_sectors;
> +
> +		mddev->external_size =3D 0;
> +	} else {
> +		int err;
> +		sector_t new;
> +
> +		err =3D strict_strtoull(buf, 10, &sectors);
> +		if (err < 0)
> +			return err;
> +		sectors *=3D 2;
> +		new =3D sectors;
> +		if (new !=3D sectors) /* overflow */
> +			return -EINVAL;

Is it possible that already the "sectors *=3D 2" overflows? If this
happens a much too small value is going to be stored by set_capacity()
later.

> +	mddev->array_sectors =3D sectors;
> +	set_capacity(mddev->gendisk, mddev->array_sectors);
> +	if (mddev->pers) {
> +		bdev =3D bdget_disk(mddev->gendisk, 0);
> +		if (bdev) {
> +			mutex_lock(&bdev->bd_inode->i_mutex);
> +			i_size_write(bdev->bd_inode,
> +				     (loff_t)mddev->array_sectors << 9);
> +			mutex_unlock(&bdev->bd_inode->i_mutex);
> +			bdput(bdev);
> +		}
> +	}

bdev is only used inside the if (mddev->pers). No need to define it at
the top of the function.

> @@ -4043,7 +4108,17 @@ static int do_md_run(mddev_t * mddev)
>  	err =3D mddev->pers->run(mddev);
>  	if (err)
>  		printk(KERN_ERR "md: pers->run() failed ...\n");
> -	else if (mddev->pers->sync_request) {
> +	else if (mddev->pers->size(mddev, 0, 0) < mddev->array_sectors) {
> +		WARN_ONCE(!mddev->external_size, "%s: default size too small,"
> +			  " but 'external_size' not in effect?\n", __func__);
> +		printk(KERN_ERR
> +		       "md: invalid array_size %llu > default size %llu\n",
> +		       (unsigned long long)mddev->array_sectors / 2,
> +		       (unsigned long long)mddev->pers->size(mddev, 0, 0) / 2);
> +		err =3D -EINVAL;
> +		mddev->pers->stop(mddev);
> +	}

What's the point of the WARN_ONCE() if it is followed by a printk() that
is always being printed?

>  void md_set_size(mddev_t *mddev, sector_t array_sectors)
>  {
> +	WARN(!mddev_is_locked(mddev), "%s: unlocked mddev!\n", __func__);

An unlocked mddev would actually be a bug, no? Also, the name
"md_set_size" is a bit unfortunate as an exported function name because
it's not clear from the name that the size should be specified in
sectors. "md_set_sector_count" or "md_set_array_sectors" is probably
clearer.

Regards
Andre

--=20
The only person who always got his work done by Friday was Robinson Crusoe

--W/D3X8sky0X3AmG5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJsUw/Wto1QDEAkw8RAjWpAJ9sxEV2RJqNAPY+AJZCpLT2ZN2eHQCeK2TM
73jzQ/dbi4W/+rd27p9WPKo=
=X4V9
-----END PGP SIGNATURE-----

--W/D3X8sky0X3AmG5--
