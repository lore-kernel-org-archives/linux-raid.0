From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 6] md: Move warning about creating a raid array on partitions of the one device.
Date: Tue, 20 Feb 2007 17:35:00 +1100
Message-ID: <1070220063500.16163@suse.de>
References: <20070220172544.15678.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


md tries to warn the user if they e.g. create a raid1 using two partitions
of the same device, as this does not provide true redundancy.

However it also warns if a raid0 is created like this, and there is
nothing wrong with that.

At the place where the warning is currently printer, we don't necessarily
know what level the array will be, so move the warning from the point
where the device is added to the point where the array is started.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   63 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 26 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-02-20 17:10:06.000000000 +1100
+++ ./drivers/md/md.c	2007-02-20 17:12:16.000000000 +1100
@@ -1296,27 +1296,17 @@ static struct super_type super_types[] =
 		.sync_super	= super_1_sync,
 	},
 };
-	
-static mdk_rdev_t * match_dev_unit(mddev_t *mddev, mdk_rdev_t *dev)
-{
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
-
-	ITERATE_RDEV(mddev,rdev,tmp)
-		if (rdev->bdev->bd_contains == dev->bdev->bd_contains)
-			return rdev;
-
-	return NULL;
-}
 
 static int match_mddev_units(mddev_t *mddev1, mddev_t *mddev2)
 {
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
+	struct list_head *tmp, *tmp2;
+	mdk_rdev_t *rdev, *rdev2;
 
 	ITERATE_RDEV(mddev1,rdev,tmp)
-		if (match_dev_unit(mddev2, rdev))
-			return 1;
+		ITERATE_RDEV(mddev2, rdev2, tmp2)
+			if (rdev->bdev->bd_contains ==
+			    rdev2->bdev->bd_contains)
+				return 1;
 
 	return 0;
 }
@@ -1325,8 +1315,7 @@ static LIST_HEAD(pending_raid_disks);
 
 static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 {
-	mdk_rdev_t *same_pdev;
-	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
+	char b[BDEVNAME_SIZE];
 	struct kobject *ko;
 	char *s;
 
@@ -1342,14 +1331,6 @@ static int bind_rdev_to_array(mdk_rdev_t
 		else
 			mddev->size = rdev->size;
 	}
-	same_pdev = match_dev_unit(mddev, rdev);
-	if (same_pdev)
-		printk(KERN_WARNING
-			"%s: WARNING: %s appears to be on the same physical"
-	 		" disk as %s. True\n     protection against single-disk"
-			" failure might be compromised.\n",
-			mdname(mddev), bdevname(rdev->bdev,b),
-			bdevname(same_pdev->bdev,b2));
 
 	/* Verify rdev->desc_nr is unique.
 	 * If it is -1, assign a free number, else
@@ -3109,6 +3090,36 @@ static int do_md_run(mddev_t * mddev)
 		return -EINVAL;
 	}
 
+	if (pers->sync_request) {
+		/* Warn if this is a potentially silly
+		 * configuration.
+		 */
+		char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
+		mdk_rdev_t *rdev2;
+		struct list_head *tmp2;
+		int warned = 0;
+		ITERATE_RDEV(mddev, rdev, tmp) {
+			ITERATE_RDEV(mddev, rdev2, tmp2) {
+				if (rdev < rdev2 &&
+				    rdev->bdev->bd_contains ==
+				    rdev2->bdev->bd_contains) {
+					printk(KERN_WARNING
+					       "%s: WARNING: %s appears to be"
+					       " on the same physical disk as"
+					       " %s.\n",
+					       mdname(mddev),
+					       bdevname(rdev->bdev,b),
+					       bdevname(rdev2->bdev,b2));
+					warned = 1;
+				}
+			}
+		}
+		if (warned)
+			printk(KERN_WARNING
+			       "True protection against single-disk"
+			       " failure might be compromised.\n");
+	}
+
 	mddev->recovery = 0;
 	mddev->resync_max_sectors = mddev->size << 1; /* may be over-ridden by personality */
 	mddev->barriers_work = 1;
