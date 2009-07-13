From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH/Resend] md: Push down data integrity code to personalities.
Date: Mon, 13 Jul 2009 10:54:42 +0200
Message-ID: <20090713085442.GJ9910@skl-net.de>
References: <20090701083802.GC9910@skl-net.de> <19026.50240.504728.428875@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dCSxeJc5W8HZXZrD"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19026.50240.504728.428875@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--dCSxeJc5W8HZXZrD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 07, 2009 at 01:42:56PM +1000, Neil Brown wrote:

> On Wednesday July 1, maan@systemlinux.org wrote:

> This patch seems to treat spares inconsistently.
>=20
> md_integrity_register ignores spares.
> However bind_rdev_to_array - which is used for adding a spare - calls
> md_integrity_add_rdev to check that the integrity profile of the new
> device matches.
>=20
> We need to be consistent.
> Either all devices that are bound to the array - whether active,
> spare, or failed - are considered, or only the active devices are
> considered.
>=20
> In the former case we want to take action in bind_rdev_to_array
> and possibly in unbind_rdev_from_array.
> In the latter we need to take action either in remove_and_add_spares,
> or in the per-personality ->hot_add_disk and ->hot_remove_disk
> methods.
>=20
> I think I lean towards the latter, and put code in ->hot_*_disk, but
> it isn't a strong leaning.

Here is a revised patch that puts calls to the new functions into
the ->hot_*_disk methods as you propose.

Side note: The patch causes the new gcc warning

	drivers/md/md.c: In function 'md_integrity_add_rdev':
	drivers/md/md.c:1546: warning: unused variable 'gd'

if data integrity is not compiled in. Any ideas on how to avoid it
without introducing an #ifdef-mess are welcome.

Please review.

Thanks
Andre

commit fff7635e729d3b767855b4435d7c9cc36ed62568
Author: Andre Noll <maan@systemlinux.org>
Date:   Sun Jul 12 22:17:28 2009 +0200

    md: Push down data integrity code to personalities.
   =20
    This patch replaces md_integrity_check() by two new public functions:
    md_integrity_register() and md_integrity_add_rdev() which are both
    personality-independent.
   =20
    md_integrity_register() is called from the ->run, ->hot_remove and
    the ->error methods of all personalities that support data integrity.
    The function iterates over the component devices of the array and
    determines if all active devices are integrity capable and if their
    profiles match. If this is the case, the common profile is registered
    for the mddev via blk_integrity_register().
   =20
    The second new function, md_integrity_add_rdev() is called from the
    ->hot_add_disk methods, i.e. whenever a new device is being added
    to a raid array. If the new device does not support data integrity,
    or has a profile different from the one already registered, data
    integrity for the mddev is disabled.
   =20
    For raid0 and linear, only the call to md_integrity_register() from
    the ->run method is necessary.
   =20
    Signed-off-by: Andre Noll <maan@systemlinux.org>

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 5810fa9..54c8677 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -220,6 +220,7 @@ static int linear_run (mddev_t *mddev)
 	mddev->queue->unplug_fn =3D linear_unplug;
 	mddev->queue->backing_dev_info.congested_fn =3D linear_congested;
 	mddev->queue->backing_dev_info.congested_data =3D mddev;
+	md_integrity_register(mddev);
 	return 0;
 }
=20
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0f4a70c..1cbba68 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1487,36 +1487,74 @@ static int match_mddev_units(mddev_t *mddev1, mddev=
_t *mddev2)
=20
 static LIST_HEAD(pending_raid_disks);
=20
-static void md_integrity_check(mdk_rdev_t *rdev, mddev_t *mddev)
+/*
+ * Try to register data integrity profile for an mddev
+ *
+ * This is called when an array is started and after a disk has been kicked
+ * from the array. It only succeeds if all working and active component de=
vices
+ * are integrity capable with matching profiles.
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
+void md_integrity_add_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
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
+	if (rdev->raid_disk < 0) /* skip spares */
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
+	if (bi_rdev && blk_integrity_compare(gd, rdev->bdev->bd_disk) >=3D 0)
+		return;
+	printk(KERN_NOTICE "disabling data integrity on %s\n", mdname(mddev));
+	blk_integrity_unregister(gd);
 }
=20
 static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
@@ -1591,7 +1629,6 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mdde=
v_t * mddev)
 	/* May as well allow recovery to be retried once */
 	mddev->recovery_disabled =3D 0;
=20
-	md_integrity_check(rdev, mddev);
 	return 0;
=20
  fail:
@@ -4046,10 +4083,6 @@ static int do_md_run(mddev_t * mddev)
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
index 9430a11..78f0316 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -431,5 +431,7 @@ extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
 extern int md_check_no_bitmap(mddev_t *mddev);
+extern int md_integrity_register(mddev_t *mddev);
+void md_integrity_add_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
=20
 #endif /* _MD_MD_H */
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 237fe3f..7289c30 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -248,6 +248,7 @@ static void multipath_error (mddev_t *mddev, mdk_rdev_t=
 *rdev)
 				" on %d IO paths.\n",
 				bdevname (rdev->bdev,b),
 				conf->working_disks);
+			md_integrity_register(mddev);
 		}
 	}
 }
@@ -313,6 +314,7 @@ static int multipath_add_disk(mddev_t *mddev, mdk_rdev_=
t *rdev)
 			set_bit(In_sync, &rdev->flags);
 			rcu_assign_pointer(p->rdev, rdev);
 			err =3D 0;
+			md_integrity_add_rdev(rdev, mddev);
 			break;
 		}
=20
@@ -345,7 +347,9 @@ static int multipath_remove_disk(mddev_t *mddev, int nu=
mber)
 			/* lost the race, try later */
 			err =3D -EBUSY;
 			p->rdev =3D rdev;
+			goto abort;
 		}
+		md_integrity_register(mddev);
 	}
 abort:
=20
@@ -519,7 +523,7 @@ static int multipath_run (mddev_t *mddev)
 	mddev->queue->unplug_fn =3D multipath_unplug;
 	mddev->queue->backing_dev_info.congested_fn =3D multipath_congested;
 	mddev->queue->backing_dev_info.congested_data =3D mddev;
-
+	md_integrity_register(mddev);
 	return 0;
=20
 out_free_conf:
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 335f490..898e2bd 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -351,6 +351,7 @@ static int raid0_run(mddev_t *mddev)
=20
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	dump_zones(mddev);
+	md_integrity_register(mddev);
 	return 0;
 }
=20
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0569efb..f316bfc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1045,6 +1045,7 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device.\n"
 		"raid1: Operation continuing on %d devices.\n",
 		bdevname(rdev->bdev,b), conf->raid_disks - mddev->degraded);
+	md_integrity_register(mddev);
 }
=20
 static void print_conf(conf_t *conf)
@@ -1144,7 +1145,7 @@ static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t =
*rdev)
 			rcu_assign_pointer(p->rdev, rdev);
 			break;
 		}
-
+	md_integrity_add_rdev(rdev, mddev);
 	print_conf(conf);
 	return err;
 }
@@ -1178,7 +1179,9 @@ static int raid1_remove_disk(mddev_t *mddev, int numb=
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
@@ -2067,7 +2070,7 @@ static int run(mddev_t *mddev)
 	mddev->queue->unplug_fn =3D raid1_unplug;
 	mddev->queue->backing_dev_info.congested_fn =3D raid1_congested;
 	mddev->queue->backing_dev_info.congested_data =3D mddev;
-
+	md_integrity_register(mddev);
 	return 0;
=20
 out_no_mem:
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7298a5e..b224b75 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1039,6 +1039,7 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 	printk(KERN_ALERT "raid10: Disk failure on %s, disabling device.\n"
 		"raid10: Operation continuing on %d devices.\n",
 		bdevname(rdev->bdev,b), conf->raid_disks - mddev->degraded);
+	md_integrity_register(mddev);
 }
=20
 static void print_conf(conf_t *conf)
@@ -1170,6 +1171,7 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t=
 *rdev)
 			break;
 		}
=20
+	md_integrity_add_rdev(rdev, mddev);
 	print_conf(conf);
 	return err;
 }
@@ -1203,7 +1205,9 @@ static int raid10_remove_disk(mddev_t *mddev, int num=
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
@@ -2225,6 +2229,7 @@ static int run(mddev_t *mddev)
=20
 	if (conf->near_copies < mddev->raid_disks)
 		blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
+	md_integrity_register(mddev);
 	return 0;
=20
 out_free_conf:
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--dCSxeJc5W8HZXZrD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKWvZSWto1QDEAkw8RAlI3AJ9z+R22DE+cu3exu5CbDVZHp4oY3ACeJLqL
qRX+6BXacRGAAs8YYQ7dcn4=
=oXwE
-----END PGP SIGNATURE-----

--dCSxeJc5W8HZXZrD--
