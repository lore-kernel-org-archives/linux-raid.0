From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] Retry HOT_REMOVE_DISK a few times.
Date: Mon, 27 Mar 2017 12:50:16 +1100
Message-ID: <87d1d38p47.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


HOT_REMOVE_DISK can fail with EBUSY if there are outstanding
IO request that have not completed yet.  It can sometimes
be helpful to wait a little while for these to complete.

We already do this in impose_level() when reshaping a device,
but not in Manage.c in response to an explicit --remove request.

So create hot_remove_disk() to central this code, and call it
where-ever it makes sense to wait for a HOT_REMOVE_DISK to succeed.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 Grow.c   |  9 +--------
 Manage.c |  4 ++--
 mdadm.h  |  1 +
 util.c   | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/Grow.c b/Grow.c
index 455c5f90bf58..218a70649c1f 100755
=2D-- a/Grow.c
+++ b/Grow.c
@@ -2736,7 +2736,6 @@ static int impose_level(int fd, int level, char *devn=
ame, int verbose)
 		for (d =3D 0, found =3D 0;
 		     d < MAX_DISKS && found < array.nr_disks;
 		     d++) {
=2D			int cnt;
 			mdu_disk_info_t disk;
 			disk.number =3D d;
 			if (ioctl(fd, GET_DISK_INFO, &disk) < 0)
@@ -2750,13 +2749,7 @@ static int impose_level(int fd, int level, char *dev=
name, int verbose)
 				continue;
 			ioctl(fd, SET_DISK_FAULTY,
 			      makedev(disk.major, disk.minor));
=2D			cnt =3D 5;
=2D			while (ioctl(fd, HOT_REMOVE_DISK,
=2D				     makedev(disk.major, disk.minor)) < 0
=2D			       && errno =3D=3D EBUSY
=2D			       && cnt--) {
=2D				usleep(10000);
=2D			}
+			hot_remove_disk(fd, makedev(disk.major, disk.minor));
 		}
 	}
 	c =3D map_num(pers, level);
diff --git a/Manage.c b/Manage.c
index 5c3d2b9b1a9f..9139f96e1431 100644
=2D-- a/Manage.c
+++ b/Manage.c
@@ -1183,7 +1183,7 @@ int Manage_remove(struct supertype *tst, int fd, stru=
ct mddev_dev *dv,
 		else
 			err =3D 0;
 	} else {
=2D		err =3D ioctl(fd, HOT_REMOVE_DISK, rdev);
+		err =3D hot_remove_disk(fd, rdev);
 		if (err && errno =3D=3D ENODEV) {
 			/* Old kernels rejected this if no personality
 			 * is registered */
@@ -1607,7 +1607,7 @@ int Manage_subdevs(char *devname, int fd,
=20
 			if (dv->disposition =3D=3D 'F')
 				/* Need to remove first */
=2D				ioctl(fd, HOT_REMOVE_DISK, rdev);
+				hot_remove_disk(fd, rdev);
 			/* Make sure it isn't in use (in 2.6 or later) */
 			tfd =3D dev_open(dv->devname, O_RDONLY|O_EXCL);
 			if (tfd >=3D 0) {
diff --git a/mdadm.h b/mdadm.h
index 71b8afb9fee6..53b3b5836841 100644
=2D-- a/mdadm.h
+++ b/mdadm.h
@@ -1476,6 +1476,7 @@ extern int add_disk(int mdfd, struct supertype *st,
 		    struct mdinfo *sra, struct mdinfo *info);
 extern int remove_disk(int mdfd, struct supertype *st,
 		       struct mdinfo *sra, struct mdinfo *info);
+extern int hot_remove_disk(int mdfd, unsigned long dev);
 extern int set_array_info(int mdfd, struct supertype *st, struct mdinfo *i=
nfo);
 unsigned long long min_recovery_start(struct mdinfo *array);
=20
diff --git a/util.c b/util.c
index f1009723ed04..e176a9d466cf 100644
=2D-- a/util.c
+++ b/util.c
@@ -1795,6 +1795,24 @@ int remove_disk(int mdfd, struct supertype *st,
 	return rv;
 }
=20
+int hot_remove_disk(int mdfd, unsigned long dev)
+{
+	int cnt =3D 5;
+	int ret;
+
+	/* HOT_REMOVE_DISK can fail with EBUSY if there are
+	 * outstanding IO requests to the device.
+	 * In this case, it can be helpful to wait a little while,
+	 * up to half a second, for that IO to flush.
+	 */
+	while ((ret =3D ioctl(mdfd, HOT_REMOVE_DISK, dev)) =3D=3D -1 &&
+	       errno =3D=3D EBUSY &&
+	       cnt-- > 0)
+		usleep(10000);
+
+	return ret;
+}
+
 int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info)
 {
 	/* Initialise kernel's knowledge of array.
=2D-=20
2.12.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljYb9gACgkQOeye3VZi
gbkk1A/+PR5BI1an6Yfpu3zCu49Tfda1PdsFpK4kFhFxIXbKhye8laPYri3npsIK
q/YyMSgjhS9ighXuz3EKv04GcDdI1s64RCQdlqv4hPWy1rrccI09D6GbjQxCBF3c
in3zAO2ZayLBlg8NS3iazHN3LeEyBSvidEfl4fR5yO2Iw8TP73PqI0SbEff3K+82
JRKRlwP0n/zr6+WgT7RPBJ9xZ87gzQWNIp5dt3gPozjNBcxS8/mb8eDH/zmvMFEG
QWjXFQjbcfRWW4WEalLbdmquohtrwTCFMn3HgazwsTGOdQH6bbMVpms7xuPSvkt1
6yzgTjdGgGvl6An9o5F1hGniBvDGsDJm+UmiFuC6xxbx/Zp+k9mZ6CKR1DOQVvYP
K5Iw/ioPp6GPJLlTm3qo0qzV7L78G621FCvTVr5CYzIRmnLHJj5WmHRY4ZQ5q2Ra
xK4uHTJMFiwfagBus0mF0QK8qAG2PfJFoxFPUoL4qeWGaIB465IOt3x5RK25M4Ie
SQKnhRtcExaV+ZAJrmsMlg3fOO17MhRAcav/9MV4etfsO3SUyQKRcsJJYvsRjVci
NRoYFBHRMPD8VHL0fcv6hNDxFnkcC8gjOlOhLpLWUZl0lJOEWFXVcaIWkzsBa932
DvALlCBTZZRO2PZKWrwc5hO/5DOhUfeycLjjpquTFBKf8yIpaPo=
=vBKk
-----END PGP SIGNATURE-----
--=-=-=--
