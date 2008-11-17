From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH] md: fix multipath oops
Date: Mon, 17 Nov 2008 11:32:03 +0100
Message-ID: <20081117103203.GL17300@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vTUhhhdwRI43FzeR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--vTUhhhdwRI43FzeR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

the current for-next kernel oopses on the 00multipath test of the
mdadm test suite. I'm not sure if the patch below is the best way to
fix this problem, but it avoids the oops and makes the 00multipath
test succeed. In the long run it might be preferable to use a wrapper
for sysfs_notify_dirent() that checks for NULL pointers, or even teach
sysfs_notify_dirent() to return early if it gets passed a NULL pointer.

Please consider for inclusion.

Thanks
Andre

commit 9448a199ff0e4706ff8146f889bf5c3ff96dee7a
Author: Andre Noll <maan@systemlinux.org>
Date:   Mon Nov 17 11:36:19 2008 +0100

    md: Avoid NULL pointer dereference in sysfs_notify_dirent().
   =20
    The 00multipath test of the mdadm test suite causes the oops below
    in sysfs_notify_dirent() due to mddev->sysfs_action being NULL in
    md_check_recovery().
   =20
    Check if mddev->sysfs_action is NULL and do not call
    sysfs_notify_dirent() in this case.
   =20
    Signed-off-by: Andre Noll <maan@systemlinux.org>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 61a87f4..7c5617d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6233,8 +6233,8 @@ void md_check_recovery(mddev_t *mddev)
 	unlock:
 		if (!mddev->sync_thread) {
 			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-			if (test_and_clear_bit(MD_RECOVERY_RECOVER,
-					       &mddev->recovery))
+			if (mddev->sysfs_action && test_and_clear_bit(
+				MD_RECOVERY_RECOVER, &mddev->recovery))
 				sysfs_notify_dirent(mddev->sysfs_action);
 		}
 		mddev_unlock(mddev);
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--vTUhhhdwRI43FzeR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJIUgjWto1QDEAkw8RAq2tAJwLxJjegt6pB/efGiYSRo6b5uiHPgCeNfr7
WnR0NHdI4hY5fFZfrGMk2IU=
=7mPU
-----END PGP SIGNATURE-----

--vTUhhhdwRI43FzeR--
