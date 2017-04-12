From: NeilBrown <neilb@suse.com>
Subject: [md PATCH] md: handle read-only member devices better.
Date: Thu, 13 Apr 2017 08:53:48 +1000
Message-ID: <87a87lutj7.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Nanda Kishore Chinnaram <Nanda_Kishore_Chinna@dell.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


1/ If an array has any read-only devices when it is started,
   the array itself must be read-only
2/ A read-only device cannot be added to an array after it is
   started.
3/ Setting an array to read-write should not succeed
   if any member devices are read-only

Reported-and-Tested-by: Nanda Kishore Chinnaram <Nanda_Kishore_Chinna@dell.=
com>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/md.c | 41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 22894303d335..9fe930109012 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2093,6 +2093,10 @@ static int bind_rdev_to_array(struct md_rdev *rdev, =
struct mddev *mddev)
 	if (find_rdev(mddev, rdev->bdev->bd_dev))
 		return -EEXIST;
=20
+	if ((bdev_read_only(rdev->bdev) || bdev_read_only(rdev->meta_bdev)) &&
+	    mddev->pers)
+		return -EROFS;
+
 	/* make sure rdev->sectors exceeds mddev->dev_sectors */
 	if (!test_bit(Journal, &rdev->flags) &&
 	    rdev->sectors &&
@@ -5345,6 +5349,13 @@ int md_run(struct mddev *mddev)
 			continue;
 		sync_blockdev(rdev->bdev);
 		invalidate_bdev(rdev->bdev);
+		if (mddev->ro !=3D 1 &&
+		    (bdev_read_only(rdev->bdev) ||
+		     bdev_read_only(rdev->meta_bdev))) {
+			mddev->ro =3D 1;
+			if (mddev->gendisk)
+				set_disk_ro(mddev->gendisk, 1);
+		}
=20
 		/* perform some consistency tests on the device.
 		 * We don't want the data to overlap the metadata,
@@ -5569,6 +5580,9 @@ static int do_md_run(struct mddev *mddev)
 static int restart_array(struct mddev *mddev)
 {
 	struct gendisk *disk =3D mddev->gendisk;
+	struct md_rdev *rdev;
+	bool has_journal =3D false;
+	bool has_readonly =3D false;
=20
 	/* Complain if it has no devices */
 	if (list_empty(&mddev->disks))
@@ -5577,24 +5591,21 @@ static int restart_array(struct mddev *mddev)
 		return -EINVAL;
 	if (!mddev->ro)
 		return -EBUSY;
=2D	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
=2D		struct md_rdev *rdev;
=2D		bool has_journal =3D false;
=2D
=2D		rcu_read_lock();
=2D		rdev_for_each_rcu(rdev, mddev) {
=2D			if (test_bit(Journal, &rdev->flags) &&
=2D			    !test_bit(Faulty, &rdev->flags)) {
=2D				has_journal =3D true;
=2D				break;
=2D			}
=2D		}
=2D		rcu_read_unlock();
=20
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev) {
+		if (test_bit(Journal, &rdev->flags) &&
+		    !test_bit(Faulty, &rdev->flags))
+			has_journal =3D true;
+		if (bdev_read_only(rdev->bdev))
+			has_readonly =3D true;
+	}
+	rcu_read_unlock();
+	if (test_bit(MD_HAS_JOURNAL, &mddev->flags) && !has_journal)
 		/* Don't restart rw with journal missing/faulty */
=2D		if (!has_journal)
 			return -EINVAL;
=2D	}
+	if (has_readonly)
+		return -EROFS;
=20
 	mddev->safemode =3D 0;
 	mddev->ro =3D 0;
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljur/wACgkQOeye3VZi
gbkHvg//Tqk1s5iq9tFQSTlFTmh7M7DcgySm1iBwByhCR4DUPtVodCGlQmQEq1+I
y4W5a20fs+gY8QqMGlzss7m06sw+mzzLPonW4v87KSGCugPZ7wWUNt5X/YhtZHpH
Ace7g+BZuO/gkwQ/r4dWqkG9Sf7UMBS3Mn4GnANBAYI/moqgclBJCucqlaoFtuaS
211xXeFknjZRIAWO7I7SbOAww3+QeAArQhIV4Ib13225x86c449+u8zp22aHyw00
/o3kFlRT1h6aS9TPcpjFJCXxOD4gkTVebRPJbH+g7Kc5GMqndRhz5DI9zTN9ieBy
dlpJo1BJQT8BWCe0Qu/dSbOPypuwIVAn4Z/GXDRPlmGpFAb9hWgK14weyD5HRWO2
Mm7MV6y9pDmwOsA3tBZq4q99TxOSoqawfW/mqX8Hk03qENXmwGFZtBjvhecEhifG
F/RdCGk6Ih0dpnWBAnXTPyry+mU0mkvFI9zg95IKFDcX59VDhGXcf7EdNUYSVtmu
VqHw/wDD6Xo1BltzJQzVuu8Cwk1YNqVUTLpfFE8XYy7PxSZDwqKzXXk78+ITGUMS
rAnodt4crS/yHAU6EisoTD407qkusaRy0VivJDZiLhp3rzlogUWBjgUfYaj5uECF
cMHimcNzUOHFGD0mm5ask0Flf4vnS2iY58fmLc4NE0d2TL3VpWA=
=XvuM
-----END PGP SIGNATURE-----
--=-=-=--
