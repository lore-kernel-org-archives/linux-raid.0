From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH] md - 3 of 3 - Don't check a device size before bd_get in md.c
Date: Thu, 13 Mar 2003 10:22:09 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030313092209.GD32759@marowsky-bree.de>
References: <E18tH4s-0008ID-00@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E18tH4s-0008ID-00@notabene.cse.unsw.edu.au>
To: NeilBrown <neilb@cse.unsw.edu.au>, Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-03-13T12:00:10,
   NeilBrown <neilb@cse.unsw.edu.au> said:

> Lars Marowsky-Bree <lmb@suse.de> noted that we shouldn't
> be using blk_size for a device before calling bd_get.
> This code rearrangement fixes this little issue.
>=20
>=20
>  ----------- Diffstat output ------------
>  ./drivers/md/md.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
>=20
> diff ./drivers/md/md.c~current~ ./drivers/md/md.c
> --- ./drivers/md/md.c~current~	2003-03-13 10:47:13.000000000 +1100
> +++ ./drivers/md/md.c	2003-03-13 11:46:25.000000000 +1100
> @@ -2395,13 +2395,6 @@ static int hot_add_disk(mddev_t * mddev,
>  	}
> =20
>  	persistent =3D !mddev->sb->not_persistent;
> -	size =3D calc_dev_size(dev, mddev, persistent);
> -
> -	if (size < mddev->sb->size) {
> -		printk(KERN_WARNING "md%d: disk size %d blocks < array size %d\n",
> -				mdidx(mddev), size, mddev->sb->size);
> -		return -ENOSPC;
> -	}
> =20
>  	rdev =3D find_rdev(mddev, dev);
>  	if (rdev)
> @@ -2423,6 +2416,14 @@ static int hot_add_disk(mddev_t * mddev,
>  		err =3D -EINVAL;
>  		goto abort_export;
>  	}
> +	size =3D calc_dev_size(dev, mddev, persistent);
> +
> +	if (size < mddev->sb->size) {
> +		printk(KERN_WARNING "md%d: disk size %d blocks < array size %d\n",
> +				mdidx(mddev), size, mddev->sb->size);
> +		err =3D -ENOSPC;
> +		gotot abort_export;

Hi Neil, the patch seems to have gotten mangled here, I'm reasonably su=
re
"gotot" won't compile at least ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
Principal Squirrel=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)=
=2E"
  -- Capt. Edward A. Murphy            -- Louis Pasteur
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
