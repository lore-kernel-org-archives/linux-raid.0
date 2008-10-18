From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 6/8] md: raid0 create_strip_zones(): Add KERN_INFO/KERN_ERR to printk's.
Date: Sat, 18 Oct 2008 17:24:27 +0200
Message-ID: <1224343469-2831-7-git-send-email-maan@systemlinux.org>
References: <1224343469-2831-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1224343469-2831-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

This patch consists only of these trivial changes.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid0.c |   46 +++++++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 9074ea4..c759436 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -68,18 +68,18 @@ static int create_strip_zones (mddev_t *mddev)
 	conf->nr_strip_zones = 0;
  
 	rdev_for_each(rdev1, tmp1, mddev) {
-		printk("raid0: looking at %s\n",
+		printk(KERN_INFO "raid0: looking at %s\n",
 			bdevname(rdev1->bdev,b));
 		c = 0;
 		rdev_for_each(rdev2, tmp2, mddev) {
-			printk("raid0:   comparing %s(%llu)",
+			printk(KERN_INFO "raid0:   comparing %s(%llu)",
 			       bdevname(rdev1->bdev,b),
 			       (unsigned long long)rdev1->size);
-			printk(" with %s(%llu)\n",
+			printk(KERN_INFO " with %s(%llu)\n",
 			       bdevname(rdev2->bdev,b),
 			       (unsigned long long)rdev2->size);
 			if (rdev2 == rdev1) {
-				printk("raid0:   END\n");
+				printk(KERN_INFO "raid0:   END\n");
 				break;
 			}
 			if (rdev2->size == rdev1->size)
@@ -88,19 +88,20 @@ static int create_strip_zones (mddev_t *mddev)
 				 * Not unique, don't count it as a new
 				 * group
 				 */
-				printk("raid0:   EQUAL\n");
+				printk(KERN_INFO "raid0:   EQUAL\n");
 				c = 1;
 				break;
 			}
-			printk("raid0:   NOT EQUAL\n");
+			printk(KERN_INFO "raid0:   NOT EQUAL\n");
 		}
 		if (!c) {
-			printk("raid0:   ==> UNIQUE\n");
+			printk(KERN_INFO "raid0:   ==> UNIQUE\n");
 			conf->nr_strip_zones++;
-			printk("raid0: %d zones\n", conf->nr_strip_zones);
+			printk(KERN_INFO "raid0: %d zones\n",
+				conf->nr_strip_zones);
 		}
 	}
-	printk("raid0: FINAL %d zones\n", conf->nr_strip_zones);
+	printk(KERN_INFO "raid0: FINAL %d zones\n", conf->nr_strip_zones);
 
 	conf->strip_zone = kzalloc(sizeof(struct strip_zone)*
 				conf->nr_strip_zones, GFP_KERNEL);
@@ -123,12 +124,13 @@ static int create_strip_zones (mddev_t *mddev)
 		int j = rdev1->raid_disk;
 
 		if (j < 0 || j >= mddev->raid_disks) {
-			printk("raid0: bad disk number %d - aborting!\n", j);
+			printk(KERN_ERR "raid0: bad disk number %d - "
+				"aborting!\n", j);
 			goto abort;
 		}
 		if (zone->dev[j]) {
-			printk("raid0: multiple devices for %d - aborting!\n",
-				j);
+			printk(KERN_ERR "raid0: multiple devices for %d - "
+				"aborting!\n", j);
 			goto abort;
 		}
 		zone->dev[j] = rdev1;
@@ -149,8 +151,8 @@ static int create_strip_zones (mddev_t *mddev)
 		cnt++;
 	}
 	if (cnt != mddev->raid_disks) {
-		printk("raid0: too few disks (%d of %d) - aborting!\n",
-			cnt, mddev->raid_disks);
+		printk(KERN_ERR "raid0: too few disks (%d of %d) - "
+			"aborting!\n", cnt, mddev->raid_disks);
 		goto abort;
 	}
 	zone->nb_dev = cnt;
@@ -166,7 +168,7 @@ static int create_strip_zones (mddev_t *mddev)
 		zone = conf->strip_zone + i;
 		zone->dev = conf->strip_zone[i-1].dev + mddev->raid_disks;
 
-		printk("raid0: zone %d\n", i);
+		printk(KERN_INFO "raid0: zone %d\n", i);
 		zone->dev_start = current_start;
 		smallest = NULL;
 		c = 0;
@@ -174,23 +176,25 @@ static int create_strip_zones (mddev_t *mddev)
 		for (j=0; j<cnt; j++) {
 			char b[BDEVNAME_SIZE];
 			rdev = conf->strip_zone[0].dev[j];
-			printk("raid0: checking %s ...", bdevname(rdev->bdev,b));
+			printk(KERN_INFO "raid0: checking %s ...",
+				bdevname(rdev->bdev, b));
 			if (rdev->size > current_start / 2) {
-				printk(" contained as device %d\n", c);
+				printk(KERN_INFO " contained as device %d\n",
+					c);
 				zone->dev[c] = rdev;
 				c++;
 				if (!smallest || (rdev->size <smallest->size)) {
 					smallest = rdev;
-					printk("  (%llu) is smallest!.\n", 
+					printk(KERN_INFO "  (%llu) is smallest!.\n",
 						(unsigned long long)rdev->size);
 				}
 			} else
-				printk(" nope.\n");
+				printk(KERN_INFO " nope.\n");
 		}
 
 		zone->nb_dev = c;
 		zone->size = (smallest->size - current_start / 2) * c;
-		printk("raid0: zone->nb_dev: %d, size: %llu\n",
+		printk(KERN_INFO "raid0: zone->nb_dev: %d, size: %llu\n",
 			zone->nb_dev, (unsigned long long)zone->size);
 
 		zone->zone_start = curr_zone_start;
@@ -226,7 +230,7 @@ static int create_strip_zones (mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
 
-	printk("raid0: done.\n");
+	printk(KERN_INFO "raid0: done.\n");
 	return 0;
  abort:
 	return 1;
-- 
1.5.3.8

