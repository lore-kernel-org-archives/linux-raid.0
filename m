From: Markus Hochholdinger <Markus@hochholdinger.net>
Subject: Re: [PATCH 018 of 29] md: Support changing rdev size on running arrays.
Date: Fri, 27 Jun 2008 18:09:25 +0200
Message-ID: <200806271809.29768.Markus@hochholdinger.net>
References: <20080627164503.9671.patches@notabene> <1080627065116.10596@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1535982.F0lQVYcYCs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1080627065116.10596@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

--nextPart1535982.F0lQVYcYCs
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Am Freitag, 27. Juni 2008 08:51 schrieb NeilBrown:
> From: Chris Webb <chris@arachsys.com>
> Allow /sys/block/mdX/md/rdY/size to change on running arrays, moving the
> superblock if necessary for this metadata version. We prevent the availab=
le
> space from shrinking to less than the used size, and allow it to be set to
> zero to fill all the available space on the underlying device.

I'm very happy of this new feature. But I'm a little confused how to use it=
=20
correctly.
Can md now recognize the change by itself and I only have to run mdadm --gr=
ow?=20
Or have I manually update /sys/block/mdX/md/rdY/size and afterwards run=20
mdadm --grow?

To be on the safe side I'd first lvresize one disk of the raid1, then do=20
mdadm --grow to let md update/move the superblock of this disk. And after=20
this is successful, lvresize the other disk and do mdadm --grow. So in case=
=20
of a failure i wouldn't loose the whole raid1!?
Am I correct or am I missing something?


> Signed-off-by: Chris Webb <chris@arachsys.com>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
>  ./drivers/md/md.c |  100
> ++++++++++++++++++++++++++++++++++++++++++++++-------- 1 file changed, 87
> insertions(+), 13 deletions(-)
>
> diff .prev/drivers/md/md.c ./drivers/md/md.c
> --- .prev/drivers/md/md.c	2008-06-27 16:22:03.000000000 +1000
> +++ ./drivers/md/md.c	2008-06-27 16:22:03.000000000 +1000
> @@ -658,11 +658,14 @@ static unsigned int calc_sb_csum(mdp_sup
>   */
>
>  struct super_type  {
> -	char 		*name;
> -	struct module	*owner;
> -	int		(*load_super)(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int
> minor_version); -	int		(*validate_super)(mddev_t *mddev, mdk_rdev_t *rdev=
);
> -	void		(*sync_super)(mddev_t *mddev, mdk_rdev_t *rdev);
> +	char		    *name;
> +	struct module	    *owner;
> +	int		    (*load_super)(mdk_rdev_t *rdev, mdk_rdev_t *refdev,
> +					  int minor_version);
> +	int		    (*validate_super)(mddev_t *mddev, mdk_rdev_t *rdev);
> +	void		    (*sync_super)(mddev_t *mddev, mdk_rdev_t *rdev);
> +	unsigned long long  (*rdev_size_change)(mdk_rdev_t *rdev,
> +						unsigned long long size);
>  };
>
>  /*
> @@ -1004,6 +1007,27 @@ static void super_90_sync(mddev_t *mddev
>  }
>
>  /*
> + * rdev_size_change for 0.90.0
> + */
> +static unsigned long long
> +super_90_rdev_size_change(mdk_rdev_t *rdev, unsigned long long size)
> +{
> +	if (size && size < rdev->mddev->size)
> +		return 0; /* component must fit device */
> +	size *=3D 2; /* convert to sectors */
> +	if (rdev->mddev->bitmap_offset)
> +		return 0; /* can't move bitmap */
> +	rdev->sb_offset =3D calc_dev_sboffset(rdev->bdev);
> +	if (!size || size > rdev->sb_offset*2)
> +		size =3D rdev->sb_offset*2;
> +	md_super_write(rdev->mddev, rdev, rdev->sb_offset << 1, rdev->sb_size,
> +		       rdev->sb_page);
> +	md_super_wait(rdev->mddev);
> +	return size/2; /* kB for sysfs */
> +}
> +
> +
> +/*
>   * version 1 superblock
>   */
>
> @@ -1328,21 +1352,59 @@ static void super_1_sync(mddev_t *mddev,
>  	sb->sb_csum =3D calc_sb_1_csum(sb);
>  }
>
> +static unsigned long long
> +super_1_rdev_size_change(mdk_rdev_t *rdev, unsigned long long size)
> +{
> +	struct mdp_superblock_1 *sb;
> +	unsigned long long max_size;
> +	if (size && size < rdev->mddev->size)
> +		return 0; /* component must fit device */
> +	size *=3D 2; /* convert to sectors */
> +	if (rdev->sb_offset < rdev->data_offset/2) {
> +		/* minor versions 1 and 2; superblock before data */
> +		max_size =3D (rdev->bdev->bd_inode->i_size >> 9);
> +		max_size -=3D rdev->data_offset;
> +		if (!size || size > max_size)
> +			size =3D max_size;
> +	} else if (rdev->mddev->bitmap_offset) {
> +		/* minor version 0 with bitmap we can't move */
> +		return 0;
> +	} else {
> +		/* minor version 0; superblock after data */
> +		sector_t sb_offset;
> +		sb_offset =3D (rdev->bdev->bd_inode->i_size >> 9) - 8*2;
> +		sb_offset &=3D ~(sector_t)(4*2 - 1);
> +		max_size =3D rdev->size*2 + sb_offset - rdev->sb_offset*2;
> +		if (!size || size > max_size)
> +			size =3D max_size;
> +		rdev->sb_offset =3D sb_offset/2;
> +	}
> +	sb =3D (struct mdp_superblock_1 *) page_address(rdev->sb_page);
> +	sb->data_size =3D cpu_to_le64(size);
> +	sb->super_offset =3D rdev->sb_offset*2;
> +	sb->sb_csum =3D calc_sb_1_csum(sb);
> +	md_super_write(rdev->mddev, rdev, rdev->sb_offset << 1, rdev->sb_size,
> +		       rdev->sb_page);
> +	md_super_wait(rdev->mddev);
> +	return size/2; /* kB for sysfs */
> +}
>
>  static struct super_type super_types[] =3D {
>  	[0] =3D {
>  		.name	=3D "0.90.0",
>  		.owner	=3D THIS_MODULE,
> -		.load_super	=3D super_90_load,
> -		.validate_super	=3D super_90_validate,
> -		.sync_super	=3D super_90_sync,
> +		.load_super	    =3D super_90_load,
> +		.validate_super	    =3D super_90_validate,
> +		.sync_super	    =3D super_90_sync,
> +		.rdev_size_change   =3D super_90_rdev_size_change,
>  	},
>  	[1] =3D {
>  		.name	=3D "md-1",
>  		.owner	=3D THIS_MODULE,
> -		.load_super	=3D super_1_load,
> -		.validate_super	=3D super_1_validate,
> -		.sync_super	=3D super_1_sync,
> +		.load_super	    =3D super_1_load,
> +		.validate_super	    =3D super_1_validate,
> +		.sync_super	    =3D super_1_sync,
> +		.rdev_size_change   =3D super_1_rdev_size_change,
>  	},
>  };
>
> @@ -2060,8 +2122,20 @@ rdev_size_store(mdk_rdev_t *rdev, const
>
>  	if (e=3D=3Dbuf || (*e && *e !=3D '\n'))
>  		return -EINVAL;
> -	if (my_mddev->pers && rdev->raid_disk >=3D 0)
> -		return -EBUSY;
> +	if (my_mddev->pers && rdev->raid_disk >=3D 0) {
> +		if (rdev->mddev->persistent) {
> +			size =3D super_types[rdev->mddev->major_version].
> +				rdev_size_change(rdev, size);
> +			if (!size)
> +				return -EBUSY;
> +		} else if (!size) {
> +			size =3D (rdev->bdev->bd_inode->i_size >> 10);
> +			size -=3D rdev->data_offset/2;
> +		}
> +		if (size < rdev->mddev->size)
> +			return -EINVAL; /* component must fit device */
> +	}
> +
>  	rdev->size =3D size;
>  	if (size > oldsize && rdev->mddev->external) {
>  		/* need to check that all other rdevs with the same ->bdev
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=2D-=20
greetings

eMHa

--nextPart1535982.F0lQVYcYCs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIZRC5XT3LE+AjWCsRAndZAJ0WFu+FpkY4p0CqSN5y2TXus4dzDACgqMCy
1uVx3/HUIkk8ZMJcZjoCjvE=
=eIPa
-----END PGP SIGNATURE-----

--nextPart1535982.F0lQVYcYCs--
