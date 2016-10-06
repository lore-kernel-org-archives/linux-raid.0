From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 04/54] md/raid0: Replace printk() calls by the usage of higher
 level interfaces
Date: Thu, 6 Oct 2016 10:56:27 +0200
Message-ID: <caf57dad-07c8-1ca8-03ca-613f80aa8a60@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 4 Oct 2016 13:30:39 +0200

1. Add a definition for the macros "MY_LOG_PREFIX" and "pr_fmt"
   so that their information can be used for consistent message output.

2. Prefer usage of some higher level macros over calling "printk" directly
   in this software module.

3. Remove prefixes from strings which were passed to some function
   and macro calls.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid0.c | 100 +++++++++++++++++++++++++----------------------------
 1 file changed, 47 insertions(+), 53 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 71bd398..3079c3e 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -17,6 +17,8 @@
    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define MY_LOG_PREFIX KBUILD_MODNAME ": "
+#define pr_fmt(fmt) MY_LOG_PREFIX fmt
 #include <linux/blkdev.h>
 #include <linux/seq_file.h>
 #include <linux/module.h>
@@ -51,20 +53,20 @@ static void dump_zones(struct mddev *mddev)
 	char b[BDEVNAME_SIZE];
 	struct r0conf *conf = mddev->private;
 	int raid_disks = conf->strip_zone[0].nb_dev;
-	printk(KERN_INFO "md: RAID0 configuration for %s - %d zone%s\n",
+	pr_info("configuration for %s - %d zone%s\n",
 	       mdname(mddev),
 	       conf->nr_strip_zones, conf->nr_strip_zones==1?"":"s");
 	for (j = 0; j < conf->nr_strip_zones; j++) {
-		printk(KERN_INFO "md: zone%d=[", j);
+		pr_info("zone%d=[", j);
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
-			printk(KERN_CONT "%s%s", k?"/":"",
-			bdevname(conf->devlist[j*raid_disks
-						+ k]->bdev, b));
-		printk(KERN_CONT "]\n");
-
+			pr_cont("%s%s",
+				k ? "/" : "",
+				bdevname(conf->devlist[j * raid_disks + k]
+					 ->bdev,
+					 b));
+		pr_cont("]\n");
 		zone_size  = conf->strip_zone[j].zone_end - zone_start;
-		printk(KERN_INFO "      zone-offset=%10lluKB, "
-				"device-offset=%10lluKB, size=%10lluKB\n",
+		pr_info("      zone-offset=%10lluKB, device-offset=%10lluKB, size=%10lluKB\n",
 			(unsigned long long)zone_start>>1,
 			(unsigned long long)conf->strip_zone[j].dev_start>>1,
 			(unsigned long long)zone_size>>1);
@@ -88,7 +90,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	if (!conf)
 		return -ENOMEM;
 	rdev_for_each(rdev1, mddev) {
-		pr_debug("md/raid0:%s: looking at %s\n",
+		pr_debug("%s: looking at %s\n",
 			 mdname(mddev),
 			 bdevname(rdev1->bdev, b));
 		c = 0;
@@ -102,15 +104,14 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 				      rdev1->bdev->bd_disk->queue));
 
 		rdev_for_each(rdev2, mddev) {
-			pr_debug("md/raid0:%s:   comparing %s(%llu)"
-				 " with %s(%llu)\n",
+			pr_debug("%s:   comparing %s(%llu) with %s(%llu)\n",
 				 mdname(mddev),
 				 bdevname(rdev1->bdev,b),
 				 (unsigned long long)rdev1->sectors,
 				 bdevname(rdev2->bdev,b2),
 				 (unsigned long long)rdev2->sectors);
 			if (rdev2 == rdev1) {
-				pr_debug("md/raid0:%s:   END\n",
+				pr_debug("%s:   END\n",
 					 mdname(mddev));
 				break;
 			}
@@ -119,30 +120,30 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 				 * Not unique, don't count it as a new
 				 * group
 				 */
-				pr_debug("md/raid0:%s:   EQUAL\n",
+				pr_debug("%s:   EQUAL\n",
 					 mdname(mddev));
 				c = 1;
 				break;
 			}
-			pr_debug("md/raid0:%s:   NOT EQUAL\n",
+			pr_debug("%s:   NOT EQUAL\n",
 				 mdname(mddev));
 		}
 		if (!c) {
-			pr_debug("md/raid0:%s:   ==> UNIQUE\n",
+			pr_debug("%s:   ==> UNIQUE\n",
 				 mdname(mddev));
 			conf->nr_strip_zones++;
-			pr_debug("md/raid0:%s: %d zones\n",
+			pr_debug("%s: %d zones\n",
 				 mdname(mddev), conf->nr_strip_zones);
 		}
 	}
-	pr_debug("md/raid0:%s: FINAL %d zones\n",
+	pr_debug("%s: FINAL %d zones\n",
 		 mdname(mddev), conf->nr_strip_zones);
 	/*
 	 * now since we have the hard sector sizes, we can make sure
 	 * chunk size is a multiple of that sector size
 	 */
 	if ((mddev->chunk_sectors << 9) % blksize) {
-		printk(KERN_ERR "md/raid0:%s: chunk_size of %d not multiple of block size %d\n",
+		pr_err("%s: chunk_size of %d not multiple of block size %d\n",
 		       mdname(mddev),
 		       mddev->chunk_sectors << 9, blksize);
 		err = -EINVAL;
@@ -191,19 +192,18 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		}
 
 		if (j < 0) {
-			printk(KERN_ERR
-			       "md/raid0:%s: remove inactive devices before converting to RAID0\n",
+			pr_err("%s: remove inactive devices before converting to RAID0\n",
 			       mdname(mddev));
 			goto free_device_list;
 		}
 		if (j >= mddev->raid_disks) {
-			printk(KERN_ERR "md/raid0:%s: bad disk number %d - "
-			       "aborting!\n", mdname(mddev), j);
+			pr_err("%s: bad disk number %d%s",
+			       mdname(mddev), j, " - aborting!\n");
 			goto free_device_list;
 		}
 		if (dev[j]) {
-			printk(KERN_ERR "md/raid0:%s: multiple devices for %d - "
-			       "aborting!\n", mdname(mddev), j);
+			pr_err("%s: multiple devices for %d%s",
+			       mdname(mddev), j, " - aborting!\n");
 			goto free_device_list;
 		}
 		dev[j] = rdev1;
@@ -213,8 +213,8 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		cnt++;
 	}
 	if (cnt != mddev->raid_disks) {
-		printk(KERN_ERR "md/raid0:%s: too few disks (%d of %d) - "
-		       "aborting!\n", mdname(mddev), cnt, mddev->raid_disks);
+		pr_err("%s: too few disks (%d of %d)%s",
+		       mdname(mddev), cnt, mddev->raid_disks, " - aborting!\n");
 		goto free_device_list;
 	}
 	zone->nb_dev = cnt;
@@ -229,8 +229,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 
 		zone = conf->strip_zone + i;
 		dev = conf->devlist + i * mddev->raid_disks;
-
-		pr_debug("md/raid0:%s: zone %d\n", mdname(mddev), i);
+		pr_debug("%s: zone %d\n", mdname(mddev), i);
 		zone->dev_start = smallest->sectors;
 		smallest = NULL;
 		c = 0;
@@ -238,20 +237,19 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		for (j=0; j<cnt; j++) {
 			rdev = conf->devlist[j];
 			if (rdev->sectors <= zone->dev_start) {
-				pr_debug("md/raid0:%s: checking %s ... nope\n",
+				pr_debug("%s: checking %s ... nope\n",
 					 mdname(mddev),
 					 bdevname(rdev->bdev, b));
 				continue;
 			}
-			pr_debug("md/raid0:%s: checking %s ..."
-				 " contained as device %d\n",
+			pr_debug("%s: checking %s ... contained as device %d\n",
 				 mdname(mddev),
 				 bdevname(rdev->bdev, b), c);
 			dev[c] = rdev;
 			c++;
 			if (!smallest || rdev->sectors < smallest->sectors) {
 				smallest = rdev;
-				pr_debug("md/raid0:%s:  (%llu) is smallest!.\n",
+				pr_debug("%s: (%llu) is smallest!.\n",
 					 mdname(mddev),
 					 (unsigned long long)rdev->sectors);
 			}
@@ -259,19 +257,18 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 
 		zone->nb_dev = c;
 		sectors = (smallest->sectors - zone->dev_start) * c;
-		pr_debug("md/raid0:%s: zone->nb_dev: %d, sectors: %llu\n",
+		pr_debug("%s: zone->nb_dev: %d, sectors: %llu\n",
 			 mdname(mddev),
 			 zone->nb_dev, (unsigned long long)sectors);
 
 		curr_zone_end += sectors;
 		zone->zone_end = curr_zone_end;
-
-		pr_debug("md/raid0:%s: current zone start: %llu\n",
+		pr_debug("%s: current zone start: %llu\n",
 			 mdname(mddev),
 			 (unsigned long long)smallest->sectors);
 	}
 
-	pr_debug("md/raid0:%s: done.\n", mdname(mddev));
+	pr_debug("%s: done.\n", mdname(mddev));
 	*private_conf = conf;
 
 	return 0;
@@ -364,8 +361,7 @@ static int raid0_run(struct mddev *mddev)
 	int ret;
 
 	if (mddev->chunk_sectors == 0) {
-		printk(KERN_ERR "md/raid0:%s: chunk size must be set.\n",
-		       mdname(mddev));
+		pr_err("%s: chunk size must be set.\n", mdname(mddev));
 		return -EINVAL;
 	}
 	if (md_check_no_bitmap(mddev))
@@ -405,10 +401,9 @@ static int raid0_run(struct mddev *mddev)
 
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
-
-	printk(KERN_INFO "md/raid0:%s: md_size is %llu sectors.\n",
-	       mdname(mddev),
-	       (unsigned long long)mddev->array_sectors);
+	pr_info("%s: md_size is %llu sectors.\n",
+		mdname(mddev),
+		(unsigned long long)mddev->array_sectors);
 
 	if (mddev->queue) {
 		/* calculate the max read-ahead size.
@@ -516,7 +511,7 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
 	struct r0conf *priv_conf;
 
 	if (mddev->degraded != 1) {
-		printk(KERN_ERR "md/raid0:%s: raid5 must be degraded! Degraded disks: %d\n",
+		pr_err("%s: raid5 must be degraded! Degraded disks: %d\n",
 		       mdname(mddev),
 		       mddev->degraded);
 		return ERR_PTR(-EINVAL);
@@ -525,7 +520,7 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
 	rdev_for_each(rdev, mddev) {
 		/* check slot number for a disk */
 		if (rdev->raid_disk == mddev->raid_disks-1) {
-			printk(KERN_ERR "md/raid0:%s: raid5 must have missing parity disk!\n",
+			pr_err("%s: raid5 must have missing parity disk!\n",
 			       mdname(mddev));
 			return ERR_PTR(-EINVAL);
 		}
@@ -556,18 +551,18 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
 	 *  - all mirrors must be already degraded
 	 */
 	if (mddev->layout != ((1 << 8) + 2)) {
-		printk(KERN_ERR "md/raid0:%s:: Raid0 cannot takeover layout: 0x%x\n",
+		pr_err("%s: Raid0 cannot takeover layout: 0x%x\n",
 		       mdname(mddev),
 		       mddev->layout);
 		return ERR_PTR(-EINVAL);
 	}
 	if (mddev->raid_disks & 1) {
-		printk(KERN_ERR "md/raid0:%s: Raid0 cannot takeover Raid10 with odd disk number.\n",
+		pr_err("%s: Raid0 cannot takeover Raid10 with odd disk number.\n",
 		       mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
 	if (mddev->degraded != (mddev->raid_disks>>1)) {
-		printk(KERN_ERR "md/raid0:%s: All mirrors must be already degraded!\n",
+		pr_err("%s: All mirrors must be already degraded!\n",
 		       mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
@@ -595,7 +590,7 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
 	 *  - (N - 1) mirror drives must be already faulty
 	 */
 	if ((mddev->raid_disks - 1) != mddev->degraded) {
-		printk(KERN_ERR "md/raid0:%s: (N - 1) mirrors drives must be already faulty!\n",
+		pr_err("%s: (N - 1) mirrors drives must be already faulty!\n",
 		       mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
@@ -638,7 +633,7 @@ static void *raid0_takeover(struct mddev *mddev)
 	 */
 
 	if (mddev->bitmap) {
-		printk(KERN_ERR "md/raid0: %s: cannot takeover array with bitmap\n",
+		pr_err("%s: cannot takeover array with bitmap\n",
 		       mdname(mddev));
 		return ERR_PTR(-EBUSY);
 	}
@@ -649,7 +644,7 @@ static void *raid0_takeover(struct mddev *mddev)
 		if (mddev->layout == ALGORITHM_PARITY_N)
 			return raid0_takeover_raid45(mddev);
 
-		printk(KERN_ERR "md/raid0:%s: Raid can only takeover Raid5 with layout: %d\n",
+		pr_err("%s: Raid can only takeover Raid5 with layout: %d\n",
 		       mdname(mddev), ALGORITHM_PARITY_N);
 	}
 
@@ -659,9 +654,8 @@ static void *raid0_takeover(struct mddev *mddev)
 	if (mddev->level == 1)
 		return raid0_takeover_raid1(mddev);
 
-	printk(KERN_ERR "Takeover from raid%i to raid0 not supported\n",
+	pr_err("Takeover from raid%i to raid0 not supported\n",
 		mddev->level);
-
 	return ERR_PTR(-EINVAL);
 }
 
-- 
2.10.1
