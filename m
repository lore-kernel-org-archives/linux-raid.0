From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH/Resend] md: Push down data integrity code to personalities.
Date: Fri, 31 Jul 2009 15:06:34 +1000
Message-ID: <19058.31706.803177.77914@notabene.brown>
References: <20090701083802.GC9910@skl-net.de>
	<19026.50240.504728.428875@notabene.brown>
	<20090713085442.GJ9910@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Monday July 13
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday July 13, maan@systemlinux.org wrote:

Only 18 days later.....

> 
> Here is a revised patch that puts calls to the new functions into
> the ->hot_*_disk methods as you propose.

Thanks.  Much better.
Calling md_integrity_check from the ->error routines isn't a good idea
though.  They can be called in interrupt context, and
md_integrity_check can call kmalloc(..., GFP_KERNEL) which might try
to sleep.  That would be bad.
We don't need the call in ->error, having it in ->hot_remove_disk is
adequate, as that is called soon after any failure (it doesn't wait
for the sysadmin to "mdadm --remove ...".).

So I have made that change and updated the comment accordingly.

> 
> Side note: The patch causes the new gcc warning
> 
> 	drivers/md/md.c: In function 'md_integrity_add_rdev':
> 	drivers/md/md.c:1546: warning: unused variable 'gd'
> 
> if data integrity is not compiled in. Any ideas on how to avoid it
> without introducing an #ifdef-mess are welcome.

I just replaced ever occurrence of "gd" with "mddev->gendisk".  It
isn't too ugly.
Alternately, blkdev.h could have

static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
{
	return NULL;
}

in place of

#define blk_get_integrity(a)			(0)

and then there would be no complaints about unused variables, and
slightly improved type checking.

Thanks.

NeilBrown


From 66f4f3f41f5c334f399e920b2aaad9b82514acda Mon Sep 17 00:00:00 2001
From: Andre Noll <maan@systemlinux.org>
Date: Fri, 31 Jul 2009 15:04:50 +1000
Subject: [PATCH] md: Push down data integrity code to personalities.

This patch replaces md_integrity_check() by two new public functions:
md_integrity_register() and md_integrity_add_rdev() which are both
personality-independent.

md_integrity_register() is called from the ->run and ->hot_remove
methods of all personalities that support data integrity.  The
function iterates over the component devices of the array and
determines if all active devices are integrity capable and if their
profiles match. If this is the case, the common profile is registered
for the mddev via blk_integrity_register().

The second new function, md_integrity_add_rdev() is called from the
->hot_add_disk methods, i.e. whenever a new device is being added
to a raid array. If the new device does not support data integrity,
or has a profile different from the one already registered, data
integrity for the mddev is disabled.

For raid0 and linear, only the call to md_integrity_register() from
the ->run method is necessary.

Signed-off-by: Andre Noll <maan@systemlinux.org>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/linear.c    |    1 +
 drivers/md/md.c        |   93 ++++++++++++++++++++++++++++++++---------------
 drivers/md/md.h        |    2 +
 drivers/md/multipath.c |    5 ++-
 drivers/md/raid0.c     |    1 +
 drivers/md/raid1.c     |    6 ++-
 drivers/md/raid10.c    |    4 ++
 7 files changed, 79 insertions(+), 33 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 5810fa9..54c8677 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -220,6 +220,7 @@ static int linear_run (mddev_t *mddev)
 	mddev->queue->unplug_fn = linear_unplug;
 	mddev->queue->backing_dev_info.congested_fn = linear_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
+	md_integrity_register(mddev);
 	return 0;
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d4351ff..13535f0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1487,36 +1487,74 @@ static int match_mddev_units(mddev_t *mddev1, mddev_t *mddev2)
 
 static LIST_HEAD(pending_raid_disks);
 
-static void md_integrity_check(mdk_rdev_t *rdev, mddev_t *mddev)
+/*
+ * Try to register data integrity profile for an mddev
+ *
+ * This is called when an array is started and after a disk has been kicked
+ * from the array. It only succeeds if all working and active component devices
+ * are integrity capable with matching profiles.
+ */
+int md_integrity_register(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev, *reference = NULL;
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
+			reference = rdev;
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
+			bdev_get_integrity(reference->bdev)) != 0) {
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
+/* Disable data integrity if non-capable/non-matching disk is being added */
+void md_integrity_add_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
 {
-	struct mdk_personality *pers = mddev->pers;
-	struct gendisk *disk = mddev->gendisk;
 	struct blk_integrity *bi_rdev = bdev_get_integrity(rdev->bdev);
-	struct blk_integrity *bi_mddev = blk_get_integrity(disk);
+	struct blk_integrity *bi_mddev = blk_get_integrity(mddev->gendisk);
 
-	/* Data integrity passthrough not supported on RAID 4, 5 and 6 */
-	if (pers && pers->level >= 4 && pers->level <= 6)
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
+	if (bi_rdev && blk_integrity_compare(mddev->gendisk,
+					     rdev->bdev->bd_disk) >= 0)
+		return;
+	printk(KERN_NOTICE "disabling data integrity on %s\n", mdname(mddev));
+	blk_integrity_unregister(mddev->gendisk);
 }
 
 static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
@@ -1591,7 +1629,6 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 	/* May as well allow recovery to be retried once */
 	mddev->recovery_disabled = 0;
 
-	md_integrity_check(rdev, mddev);
 	return 0;
 
  fail:
@@ -4048,10 +4085,6 @@ static int do_md_run(mddev_t * mddev)
 	}
 	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
 
-	if (pers->level >= 4 && pers->level <= 6)
-		/* Cannot support integrity (yet) */
-		blk_integrity_unregister(mddev->gendisk);
-
 	if (mddev->reshape_position != MaxSector &&
 	    pers->start_reshape == NULL) {
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
 
 #endif /* _MD_MD_H */
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 237fe3f..7140909 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -313,6 +313,7 @@ static int multipath_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 			set_bit(In_sync, &rdev->flags);
 			rcu_assign_pointer(p->rdev, rdev);
 			err = 0;
+			md_integrity_add_rdev(rdev, mddev);
 			break;
 		}
 
@@ -345,7 +346,9 @@ static int multipath_remove_disk(mddev_t *mddev, int number)
 			/* lost the race, try later */
 			err = -EBUSY;
 			p->rdev = rdev;
+			goto abort;
 		}
+		md_integrity_register(mddev);
 	}
 abort:
 
@@ -519,7 +522,7 @@ static int multipath_run (mddev_t *mddev)
 	mddev->queue->unplug_fn = multipath_unplug;
 	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
-
+	md_integrity_register(mddev);
 	return 0;
 
 out_free_conf:
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 335f490..898e2bd 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -351,6 +351,7 @@ static int raid0_run(mddev_t *mddev)
 
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	dump_zones(mddev);
+	md_integrity_register(mddev);
 	return 0;
 }
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0569efb..67e794d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1144,7 +1144,7 @@ static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 			rcu_assign_pointer(p->rdev, rdev);
 			break;
 		}
-
+	md_integrity_add_rdev(rdev, mddev);
 	print_conf(conf);
 	return err;
 }
@@ -1178,7 +1178,9 @@ static int raid1_remove_disk(mddev_t *mddev, int number)
 			/* lost the race, try later */
 			err = -EBUSY;
 			p->rdev = rdev;
+			goto abort;
 		}
+		md_integrity_register(mddev);
 	}
 abort:
 
@@ -2067,7 +2069,7 @@ static int run(mddev_t *mddev)
 	mddev->queue->unplug_fn = raid1_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
-
+	md_integrity_register(mddev);
 	return 0;
 
 out_no_mem:
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7298a5e..3d9020c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1170,6 +1170,7 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 			break;
 		}
 
+	md_integrity_add_rdev(rdev, mddev);
 	print_conf(conf);
 	return err;
 }
@@ -1203,7 +1204,9 @@ static int raid10_remove_disk(mddev_t *mddev, int number)
 			/* lost the race, try later */
 			err = -EBUSY;
 			p->rdev = rdev;
+			goto abort;
 		}
+		md_integrity_register(mddev);
 	}
 abort:
 
@@ -2225,6 +2228,7 @@ static int run(mddev_t *mddev)
 
 	if (conf->near_copies < mddev->raid_disks)
 		blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
+	md_integrity_register(mddev);
 	return 0;
 
 out_free_conf:
-- 
1.6.3.3

