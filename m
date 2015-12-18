From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] Fix remove_and_add_spares removes drive added as spare in slot_store
Date: Fri, 18 Dec 2015 12:10:43 +1100
Message-ID: <87a8p88sto.fsf@notabene.neil.brown.name>
References: <1450359905-8042-1-git-send-email-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450359905-8042-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: rgoldwyn@suse.de, linux-raid@vger.kernel.org
Cc: pawel.baldysiak@intel.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 18 2015, rgoldwyn@suse.de wrote:

> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> Commit 2910ff17d154baa5eb50e362a91104e831eb2bb6
> introduced a regression which would remove a recently added spare via
> slot_store. Revert part of the patch which touches slot_store() and add
> the disk directly using pers->hot_add_disk()
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  drivers/md/md.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index a71b36f..0444afa 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2726,6 +2726,7 @@ slot_store(struct md_rdev *rdev, const char *buf, s=
ize_t len)
>  		/* Activating a spare .. or possibly reactivating
>  		 * if we ever get bitmaps working here.
>  		 */
> +		int err;
>=20=20
>  		if (rdev->raid_disk !=3D -1)
>  			return -EBUSY;
> @@ -2747,9 +2748,15 @@ slot_store(struct md_rdev *rdev, const char *buf, =
size_t len)
>  			rdev->saved_raid_disk =3D -1;
>  		clear_bit(In_sync, &rdev->flags);
>  		clear_bit(Bitmap_sync, &rdev->flags);
> -		remove_and_add_spares(rdev->mddev, rdev);
> -		if (rdev->raid_disk =3D=3D -1)
> -			return -EBUSY;
> +		err =3D rdev->mddev->pers->
> +			hot_add_disk(rdev->mddev, rdev);
> +		if (err) {
> +			rdev->raid_disk =3D -1;
> +			return err;
> +		} else
> +			sysfs_notify_dirent_safe(rdev->sysfs_state);
> +		if (sysfs_link_rdev(rdev->mddev, rdev))
> +			/* failure here is OK */;
>  		/* don't wakeup anyone, leave that to userspace. */
>  	} else {
>  		if (slot >=3D rdev->mddev->raid_disks &&
> --=20
> 2.6.2

applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWc10TAAoJEDnsnt1WYoG5rM4P/jSJePbO4NLPZvkEBXTZujO+
8ZA2vMbKYqM6DKDRu/XWoDWnY0XSg1wMEJyJar6vp52Xn4/TocgqDOesQnKns8tE
qUQ1wF6YMh1JOgOkk3lZU9aDdctqYNA/xPs7832O40Orx6DsNy3g1i7blNKoONIS
aIpSw5+k32tPTYNWUvf/9HTuJN7t639Z1ENTwZCIP32wNbpldcnIVp+VFXc9d0FR
BT7+FnkoC/nIMkCE9iT6QI+8HCghV35i2aQeJoCm3wFBlgitWN449TG9gSeZRyqQ
d+B25gDKQbr9+E+V1SEtvppFKNOwiJLCk6ihUzPcu7qeufii4/9Ad36JUyQlCGfk
rErxYnMb68oLfXTyCsjEShUm3TZD5IkFbr2AWbZsBurolE/bDvqjRSAXp8HXZFXc
BuQ1gSMgqUovA+bwz/xafZ5Y3+fD8PWQTPH6D8QH8DBBs8sWOfmD33ofRaI3jhfz
w99i6Vt3pA0PBV6/ENKtbJ3MKEM5cM+gXm2n8mRYl29OrKvhegPxKHiPefP0NNOD
TbiIzsPR7YQKbPh7dUKOGgA5zfj0VA0GBRZeBFUy8Jw4C5PJnH9jrM5zMFoCpTCv
7fGyMxgUQgUr9SQsQjW0qH+ER1MZsH1+HxCPQTBjrrt/r6z0a2De3FYjk92K9/XV
YXFfKdk81NqUyyrqMF2p
=YhwW
-----END PGP SIGNATURE-----
--=-=-=--
