From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: Allow restarting an interrupted incremental
 recovery.
Date: Tue, 18 Oct 2011 12:22:39 +1100
Message-ID: <20111018122239.72685887@notabene.brown>
References: <1318893731-27717-1-git-send-email-andreiw@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MLgPXQCN4TVBHT9qnmQCsgD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1318893731-27717-1-git-send-email-andreiw@vmware.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Warkentin <andreiw@vmware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/MLgPXQCN4TVBHT9qnmQCsgD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Oct 2011 19:22:11 -0400 Andrei Warkentin <andreiw@vmware.com>
wrote:

> If an incremental recovery was interrupted, a subsequent
> re-add will result in a full recovery, even though an
> incremental should be possible (seen with raid1).
>=20
> Solve this problem by not updating the superblock on the
> recovering device until array is not degraded any longer.
>=20
> Cc: Neil Brown <neilb@suse.de>
> Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
> ---
>  drivers/md/md.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5404b22..8ebbae4 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2444,9 +2444,12 @@ repeat:
>  			continue; /* no noise on spare devices */
>  		if (test_bit(Faulty, &rdev->flags))
>  			dprintk("(skipping faulty ");
> +		else if (rdev->saved_raid_disk !=3D -1)
> +			dprintk("(skipping incremental s/r ");
> =20
>  		dprintk("%s ", bdevname(rdev->bdev,b));
> -		if (!test_bit(Faulty, &rdev->flags)) {
> +		if (!test_bit(Faulty, &rdev->flags) &&
> +		    rdev->saved_raid_disk =3D=3D -1) {
>  			md_super_write(mddev,rdev,
>  				       rdev->sb_start, rdev->sb_size,
>  				       rdev->sb_page);
> @@ -7353,15 +7356,16 @@ static void reap_sync_thread(mddev_t *mddev)
>  	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>  	    mddev->pers->finish_reshape)
>  		mddev->pers->finish_reshape(mddev);
> -	md_update_sb(mddev, 1);
> =20
>  	/* if array is no-longer degraded, then any saved_raid_disk
> -	 * information must be scrapped
> +	 * information must be scrapped, and superblock for
> +	 * incrementally recovered device written out.
>  	 */
>  	if (!mddev->degraded)
>  		list_for_each_entry(rdev, &mddev->disks, same_set)
>  			rdev->saved_raid_disk =3D -1;
> =20
> +	md_update_sb(mddev, 1);
>  	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>  	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
>  	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);


Thanks.  I've applied this and pushed it to my for-next branch.

My current HEAD use pr_debug instead of dprintk so I fixed that.

Also I realised that clearing saved_raid_disk when an array is not degraded
is no longer enough.  We also need to clear it when the device becomes
In_sync.
Consider a 3-drive RAID1 with two drives missing.  You add back one of them
and when it is recovered it needs saved_raid_disk cleared so that the
superblock gets written out.

So below is what I applied.

Thanks,
NeilBrown

commit d70ed2e4fafdbef0800e73942482bb075c21578b
Author: Andrei Warkentin <andreiw@vmware.com>
Date:   Tue Oct 18 12:16:48 2011 +1100

    MD: Allow restarting an interrupted incremental recovery.
   =20
    If an incremental recovery was interrupted, a subsequent
    re-add will result in a full recovery, even though an
    incremental should be possible (seen with raid1).
   =20
    Solve this problem by not updating the superblock on the
    recovering device until array is not degraded any longer.
   =20
    Cc: Neil Brown <neilb@suse.de>
    Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0ea3485..e8d198d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2449,7 +2449,8 @@ repeat:
 		if (rdev->sb_loaded !=3D 1)
 			continue; /* no noise on spare devices */
=20
-		if (!test_bit(Faulty, &rdev->flags)) {
+		if (!test_bit(Faulty, &rdev->flags) &&
+		    rdev->saved_raid_disk =3D=3D -1) {
 			md_super_write(mddev,rdev,
 				       rdev->sb_start, rdev->sb_size,
 				       rdev->sb_page);
@@ -2465,9 +2466,12 @@ repeat:
 				rdev->badblocks.size =3D 0;
 			}
=20
-		} else
+		} else if (test_bit(Faulty, &rdev->flags))
 			pr_debug("md: %s (skipping faulty)\n",
 				 bdevname(rdev->bdev, b));
+		else
+			pr_debug("(skipping incremental s/r ");
+
 		if (mddev->level =3D=3D LEVEL_MULTIPATH)
 			/* only need to write one superblock... */
 			break;
@@ -7366,15 +7370,19 @@ static void reap_sync_thread(struct mddev *mddev)
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    mddev->pers->finish_reshape)
 		mddev->pers->finish_reshape(mddev);
-	md_update_sb(mddev, 1);
=20
-	/* if array is no-longer degraded, then any saved_raid_disk
-	 * information must be scrapped
+	/* If array is no-longer degraded, then any saved_raid_disk
+	 * information must be scrapped.  Also if any device is now
+	 * In_sync we must scrape the saved_raid_disk for that device
+	 * do the superblock for an incrementally recovered device
+	 * written out.
 	 */
-	if (!mddev->degraded)
-		list_for_each_entry(rdev, &mddev->disks, same_set)
+	list_for_each_entry(rdev, &mddev->disks, same_set)
+		if (!mddev->degraded ||
+		    test_bit(In_sync, &rdev->flags))
 			rdev->saved_raid_disk =3D -1;
=20
+	md_update_sb(mddev, 1);
 	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);


--Sig_/MLgPXQCN4TVBHT9qnmQCsgD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpzU5znsnt1WYoG5AQJ1EBAAqBiXS9040ShWPsQ6rCREnN2vVe+vCES7
rwFd7oDQNYQt2zQyXyJkjCd1X4wQ6w++1474m5zxqHvX/BgaaRCCPgATf2jay2Co
mJeH8jrHmK8jvdLrJW7A5iQESRqLnFTwMye7A+U5mULqMUOcocdN93rtwcnt2nDm
Bn99LtGG4jxRe2bhwCJT5YFNWVwKRv7IShxvTiMOcq0v47xwzaqfLvrwGv9Bcx2K
4e3nqXttxyIq54jix4b8Mnu18N/lJXwQF+QuiHry2RHy8StrPLEEPRp5MVkHOi2n
48+wZ9xbuk1ZY11WhH01vEuUOPOj2pssPpAkpA4XtMch8mD1nnOKcGGsRGr5XHwZ
R0qi7PwqK3c8ravgo4gIglFwg6x5soXMJiElLKxkynO3qO3MvaI8dM77EVXj6uNy
sJJWMScJ4PtRsVNCtYe38QCp8TosBHev0bMwIqcEsTLI01Tn4PSEddyXE1TyHqRC
jvUfS/+asHXEHTHfZT6pK4lHiBOQNJvvDS6pjuNzdHrfU8vukDog7Am1VNeI8w+W
5aUBJ0pQElUXHQ4rpLgufTZjyYi/Em9w5rdiGj7G7gjMgzvDxpNQBEtEW42429DJ
3ribTQu8w08BZLKcEzr4QSxC4bAZUFbxH6sSKQslKcBofAf68QzBZ/jC60rZFFty
AwbgGnTao+I=
=jXBX
-----END PGP SIGNATURE-----

--Sig_/MLgPXQCN4TVBHT9qnmQCsgD--
