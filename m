From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/bitmap: avoid read out of the disk
Date: Thu, 12 Oct 2017 14:09:21 +1100
Message-ID: <87bmldnjtq.fsf@notabene.neil.brown.name>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: kumba@gentoo.org, Shaohua Li <shli@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 10 2017, Shaohua Li wrote:

> From: Shaohua Li <shli@fb.com>
>
> If PAGE_SIZE is bigger than 4k, we could read out of the disk boundary. L=
imit
> the read size to the end of disk. Write path already has similar limitati=
on.
>
> Fix: 8031c3ddc70a(md/bitmap: copy correct data for bitmap super)
> Reported-by: Joshua Kinard <kumba@gentoo.org>
> Tested-by: Joshua Kinard <kumba@gentoo.org>
> Cc: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>

Given that this bug was introduced by
Commit: 8031c3ddc70a ("md/bitmap: copy correct data for bitmap super")

and that patch is markted:

    Cc: stable@vger.kernel.org (4.10+)

I think this patch should be tagged "CC: stable" too.

However ... that earlier patch looks strange to me.
Why is it that "raid5 cache could write bitmap superblock before bitmap sup=
erblock is
initialized."  Can we just get raid5 cache *not* to write the bitmap
superblock too early?
I think that would better than breaking code that previously worked.

We really need to stop assuming that PAGE_SIZE is 4K.  I'm probably as
guilty as anyone else, but it would be good to stop.

Thanks,
NeilBrown


> ---
>  drivers/md/bitmap.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index d2121637b4ab..f68ec973fbdd 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -153,6 +153,7 @@ static int read_sb_page(struct mddev *mddev, loff_t o=
ffset,
>=20=20
>  	struct md_rdev *rdev;
>  	sector_t target;
> +	int target_size;
>=20=20
>  	rdev_for_each(rdev, mddev) {
>  		if (! test_bit(In_sync, &rdev->flags)
> @@ -161,9 +162,12 @@ static int read_sb_page(struct mddev *mddev, loff_t =
offset,
>  			continue;
>=20=20
>  		target =3D offset + index * (PAGE_SIZE/512);
> +		target_size =3D min_t(u64, size, i_size_read(rdev->bdev->bd_inode) -
> +			((target + rdev->sb_start) << 9));
> +		target_size =3D roundup(target_size,
> +			bdev_logical_block_size(rdev->bdev));
>=20=20
> -		if (sync_page_io(rdev, target,
> -				 roundup(size, bdev_logical_block_size(rdev->bdev)),
> +		if (sync_page_io(rdev, target, target_size,
>  				 page, REQ_OP_READ, 0, true)) {
>  			page->index =3D index;
>  			return 0;
> --=20
> 2.11.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlne3OIACgkQOeye3VZi
gblKpw//UiB42Vz+nXbGtwag1hjp7FXP0KWjGkKb5+HM1MajMuu42zSRtCl3XSl4
vGzPheXOiamWgbGxkrG3QFemZLQCiTX+IDhRqtfE1JeUy/bYTvtehRCys0DXgF+F
YwOLCayw7sj5uh03tI16pCko9c9QifhhStsVgFcHlgu1kV6N3JkN7/tqHH9/GGJQ
bJ74V2daWXO3EsgSU+Xg/fD1JjJ0RVCFrnNmtJHbVNSN+6TZkGLGqpDrLVO2tF0B
o89pH+ABRBaOnIipuw9m5qb6xCxsKphD63+bexOA81TOD0v0JO6Xl2JKvDOS/Oxv
5Q1my/Uq9bxK709R/f2D4rqAf03p+OSypdLcOKMzZifPYWQZnhEAIE+/j1zSKPYw
wh7kzNpNGfAfUmJ5Rv1S2v+oUk8b0VLlUz+OXwkB/uMI6HqZ2MRUXgKskkPN0fhF
IScG80EAc7agxlVUXMxFNg69iHoZbgSe3XVrN9/O528H/vxghVv7fAroytcOCWIj
XBsViUaVsJVECKgG1sgFSHuksiQG+HV1tjmGIlCVDLok+Saec6sUSQM666T14Mmv
KMuc+S6uu1ZYEeRCAq7bxtc1VE0Aw64VOmDdfsnh3CqmnF2PDQK22NkNO5BB1lIp
6fGb07RiITSlCYnzpyNeJCiiskwXMIrGzAIyl9U/eFcdmkbo1+s=
=cgk4
-----END PGP SIGNATURE-----
--=-=-=--
