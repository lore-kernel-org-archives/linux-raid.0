From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH/Resend] md: Push down data integrity code to personalities.
Date: Wed, 1 Jul 2009 10:38:02 +0200
Message-ID: <20090701083802.GC9910@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

here's again the patch that reduces the knowledge about specific
raid levels from md.c by moving the data integrity code to the
personalities. The patch was tested and acked by Martin.

Please review.

Thanks
Andre

commit 51295532895ffe532a5d8401fc32073100268b29
Author: Andre Noll <maan@systemlinux.org>
Date:   Fri Jun 19 14:40:46 2009 +0200

    [PATCH/RFC] md: Push down data integrity code to personalities.
   =20
    This patch replaces md_integrity_check() by two new functions:
    md_integrity_register() and md_integrity_add_rdev() which are both
    personality-independent.
   =20
    md_integrity_register() is a public function which is called from
    the ->run method of all personalities that support data integrity.
    The function iterates over the component devices of the array and
    determines if all active devices are integrity capable and if their
    profiles match. If this is the case, the common profile is registered
    for the mddev via blk_integrity_register().
   =20
    The second new function, md_integrity_add_rdev(), is internal to
    md.c and is called by bind_rdev_to_array(), i.e. whenever a new
    device is about to be added to a raid array. If the new device does
    not support data integrity or has a profile different from the one
    already registered, data integrity for the mddev is disabled.
   =20
    Conversely, removing a device from a (raid1-)array might make the mddev
    integrity-capable. The patch adds a call to md_integrity_register()
    to the error path of raid1.c in order to activate data integrity in
    this case.

    Signed-off-by: Andre Noll <maan@systemlinux.org>
    Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index dda2f1b..15aa325 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -201,6 +201,7 @@ static int linear_run (mddev_t *mddev)
 	mddev->queue->unplug_fn =3D linear_unplug;
 	mddev->queue->backing_dev_info.congested_fn =3D linear_congested;
 	mddev->queue->backing_dev_info.congested_data =3D mddev;
+	md_integrity_register(mddev);
 	return 0;
 }
=20
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0f11fd1..54436cb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1491,36 +1491,71 @@ static int match_mddev_units(mddev_t *mddev1, mddev=
_t *mddev2)
=20
 static LIST_HEAD(pending_raid_disks);
=20
-static void md_integrity_check(mdk_rdev_t *rdev, mddev_t *mddev)
+/*
+ * Try to register data integrity profile for an mddev
+ *
+ * This only succeeds if all working and active component devices are inte=
grity
+ * capable with matching profiles.
+ */
+int md_integrity_register(mddev_t *mddev)
 {
-	struct mdk_personality *pers =3D mddev->pers;
-	struct gendisk *disk =3D mddev->gendisk;
+	mdk_rdev_t *rdev, *reference =3D NULL;
+
+	if (list_empty(&mddev->disks))
+		return 0; /* nothing to do */
+	if (blk_get_integrity(mddev->gendisk))
+		return 0; /* already registered */
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		/* skip spares and non-functional disks */
+		if (test_bit(Faulty, &rdev->flags))
+			continue;
+		if (rdev->raid_disk < 0)
+			continue;
+		/*
+		 * If at least one rdev is not integrity capable, we can not
+		 * enable data integrity for the md device.
+		 */
+		if (!bdev_get_integrity(rdev->bdev))
+			return -EINVAL;
+		if (!reference) {
+			/* Use the first rdev as the reference */
+			reference =3D rdev;
+			continue;
+		}
+		/* does this rdev's profile match the reference profile? */
+		if (blk_integrity_compare(reference->bdev->bd_disk,
+				rdev->bdev->bd_disk) < 0)
+			return -EINVAL;
+	}
+	/*
+	 * All component devices are integrity capable and have matching
+	 * profiles, register the common profile for the md device.
+	 */
+	if (blk_integrity_register(mddev->gendisk,
+			bdev_get_integrity(reference->bdev)) !=3D 0) {
+		printk(KERN_ERR "md: failed to register integrity for %s\n",
+			mdname(mddev));
+		return -EINVAL;
+	}
+	printk(KERN_NOTICE "md: data integrity on %s enabled\n",
+		mdname(mddev));
+	return 0;
+}
+EXPORT_SYMBOL(md_integrity_register);
+
+/* Disable data integrity if non-capable/non-matching disk is being added =
*/
+static void md_integrity_add_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
+{
+	struct gendisk *gd =3D mddev->gendisk;
 	struct blk_integrity *bi_rdev =3D bdev_get_integrity(rdev->bdev);
-	struct blk_integrity *bi_mddev =3D blk_get_integrity(disk);
+	struct blk_integrity *bi_mddev =3D blk_get_integrity(gd);
=20
-	/* Data integrity passthrough not supported on RAID 4, 5 and 6 */
-	if (pers && pers->level >=3D 4 && pers->level <=3D 6)
+	if (!bi_mddev) /* nothing to do */
 		return;
-
-	/* If rdev is integrity capable, register profile for mddev */
-	if (!bi_mddev && bi_rdev) {
-		if (blk_integrity_register(disk, bi_rdev))
-			printk(KERN_ERR "%s: %s Could not register integrity!\n",
-			       __func__, disk->disk_name);
-		else
-			printk(KERN_NOTICE "Enabling data integrity on %s\n",
-			       disk->disk_name);
+	if (bi_rdev && blk_integrity_compare(gd, rdev->bdev->bd_disk) >=3D 0)
 		return;
-	}
-
-	/* Check that mddev and rdev have matching profiles */
-	if (blk_integrity_compare(disk, rdev->bdev->bd_disk) < 0) {
-		printk(KERN_ERR "%s: %s/%s integrity mismatch!\n", __func__,
-		       disk->disk_name, rdev->bdev->bd_disk->disk_name);
-		printk(KERN_NOTICE "Disabling data integrity on %s\n",
-		       disk->disk_name);
-		blk_integrity_unregister(disk);
-	}
+	printk(KERN_NOTICE "disabling data integrity on %s\n", mdname(mddev));
+	blk_integrity_unregister(gd);
 }
=20
 static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
@@ -1595,7 +1630,7 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mdde=
v_t * mddev)
 	/* May as well allow recovery to be retried once */
 	mddev->recovery_disabled =3D 0;
=20
-	md_integrity_check(rdev, mddev);
+	md_integrity_add_rdev(rdev, mddev);
 	return 0;
=20
  fail:
@@ -4048,10 +4083,6 @@ static int do_md_run(mddev_t * mddev)
 	}
 	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
=20
-	if (pers->level >=3D 4 && pers->level <=3D 6)
-		/* Cannot support integrity (yet) */
-		blk_integrity_unregister(mddev->gendisk);
-
 	if (mddev->reshape_position !=3D MaxSector &&
 	    pers->start_reshape =3D=3D NULL) {
 		/* This personality cannot handle reshaping... */
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ea2c441..9433a5d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -430,5 +430,6 @@ extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
+extern int md_integrity_register(mddev_t *mddev);
=20
 #endif /* _MD_MD_H */
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index c1ca63f..3d3a308 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -515,7 +515,7 @@ static int multipath_run (mddev_t *mddev)
 	mddev->queue->unplug_fn =3D multipath_unplug;
 	mddev->queue->backing_dev_info.congested_fn =3D multipath_congested;
 	mddev->queue->backing_dev_info.congested_data =3D mddev;
-
+	md_integrity_register(mddev);
 	return 0;
=20
 out_free_conf:
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 851e631..902de77 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -346,6 +346,7 @@ static int raid0_run(mddev_t *mddev)
=20
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	dump_zones(mddev);
+	md_integrity_register(mddev);
 	return 0;
 }
=20
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 89939a7..44fbeda 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1045,6 +1045,11 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device.\n"
 		"raid1: Operation continuing on %d devices.\n",
 		bdevname(rdev->bdev,b), conf->raid_disks - mddev->degraded);
+	/*
+	 * The good news is that kicking a disk might allow to enable data
+	 * integrity on the mddev.
+	 */
+	md_integrity_register(mddev);
 }
=20
 static void print_conf(conf_t *conf)
@@ -1178,7 +1183,9 @@ static int raid1_remove_disk(mddev_t *mddev, int numb=
er)
 			/* lost the race, try later */
 			err =3D -EBUSY;
 			p->rdev =3D rdev;
+			goto abort;
 		}
+		md_integrity_register(mddev);
 	}
 abort:
=20
@@ -2068,7 +2075,7 @@ static int run(mddev_t *mddev)
 	mddev->queue->unplug_fn =3D raid1_unplug;
 	mddev->queue->backing_dev_info.congested_fn =3D raid1_congested;
 	mddev->queue->backing_dev_info.congested_data =3D mddev;
-
+	md_integrity_register(mddev);
 	return 0;
=20
 out_no_mem:
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ae12cea..3e553e3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1203,7 +1203,9 @@ static int raid10_remove_disk(mddev_t *mddev, int num=
ber)
 			/* lost the race, try later */
 			err =3D -EBUSY;
 			p->rdev =3D rdev;
+			goto abort;
 		}
+		md_integrity_register(mddev);
 	}
 abort:
=20
@@ -2218,6 +2220,7 @@ static int run(mddev_t *mddev)
=20
 	if (conf->near_copies < mddev->raid_disks)
 		blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
+	md_integrity_register(mddev);
 	return 0;
=20
 out_free_conf:
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKSyBqWto1QDEAkw8RAojrAJ9LnWCbrZCK3KIu+SXpLv/0I6L09gCdHxcz
31pwr3ZG1YtmJKQCL1Au6xY=
=kidn
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
