From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 6/9] md/raid0: replace printk() with pr_*()
Date: Wed, 02 Nov 2016 14:16:50 +1100
Message-ID: <147805660992.23566.9912952115762737883.stgit@noble>
References: <147805657658.23566.1748253447749986766.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147805657658.23566.1748253447749986766.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This makes md/raid0 much less verbose as the messages about
the array geometry are now pr_debug()

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid0.c |   89 ++++++++++++++++++++++++++--------------------------
 1 file changed, 44 insertions(+), 45 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 258986a2699d..b3ba77a3c3bc 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -51,20 +51,21 @@ static void dump_zones(struct mddev *mddev)
 	char b[BDEVNAME_SIZE];
 	struct r0conf *conf = mddev->private;
 	int raid_disks = conf->strip_zone[0].nb_dev;
-	printk(KERN_INFO "md: RAID0 configuration for %s - %d zone%s\n",
-	       mdname(mddev),
-	       conf->nr_strip_zones, conf->nr_strip_zones==1?"":"s");
+	pr_debug("md: RAID0 configuration for %s - %d zone%s\n",
+		 mdname(mddev),
+		 conf->nr_strip_zones, conf->nr_strip_zones==1?"":"s");
 	for (j = 0; j < conf->nr_strip_zones; j++) {
-		printk(KERN_INFO "md: zone%d=[", j);
+		char line[200];
+		int len = 0;
+
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
-			printk(KERN_CONT "%s%s", k?"/":"",
-			bdevname(conf->devlist[j*raid_disks
-						+ k]->bdev, b));
-		printk(KERN_CONT "]\n");
+			len += snprintf(line+len, 200-len, "%s%s", k?"/":"",
+					bdevname(conf->devlist[j*raid_disks
+							       + k]->bdev, b));
+		pr_debug("md: zone%d=[%s]\n", j, line);
 
 		zone_size  = conf->strip_zone[j].zone_end - zone_start;
-		printk(KERN_INFO "      zone-offset=%10lluKB, "
-				"device-offset=%10lluKB, size=%10lluKB\n",
+		pr_debug("      zone-offset=%10lluKB, device-offset=%10lluKB, size=%10lluKB\n",
 			(unsigned long long)zone_start>>1,
 			(unsigned long long)conf->strip_zone[j].dev_start>>1,
 			(unsigned long long)zone_size>>1);
@@ -142,9 +143,9 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	 * chunk size is a multiple of that sector size
 	 */
 	if ((mddev->chunk_sectors << 9) % blksize) {
-		printk(KERN_ERR "md/raid0:%s: chunk_size of %d not multiple of block size %d\n",
-		       mdname(mddev),
-		       mddev->chunk_sectors << 9, blksize);
+		pr_warn("md/raid0:%s: chunk_size of %d not multiple of block size %d\n",
+			mdname(mddev),
+			mddev->chunk_sectors << 9, blksize);
 		err = -EINVAL;
 		goto abort;
 	}
@@ -186,19 +187,18 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		}
 
 		if (j < 0) {
-			printk(KERN_ERR
-			       "md/raid0:%s: remove inactive devices before converting to RAID0\n",
-			       mdname(mddev));
+			pr_warn("md/raid0:%s: remove inactive devices before converting to RAID0\n",
+				mdname(mddev));
 			goto abort;
 		}
 		if (j >= mddev->raid_disks) {
-			printk(KERN_ERR "md/raid0:%s: bad disk number %d - "
-			       "aborting!\n", mdname(mddev), j);
+			pr_warn("md/raid0:%s: bad disk number %d - aborting!\n",
+				mdname(mddev), j);
 			goto abort;
 		}
 		if (dev[j]) {
-			printk(KERN_ERR "md/raid0:%s: multiple devices for %d - "
-			       "aborting!\n", mdname(mddev), j);
+			pr_warn("md/raid0:%s: multiple devices for %d - aborting!\n",
+				mdname(mddev), j);
 			goto abort;
 		}
 		dev[j] = rdev1;
@@ -208,8 +208,8 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		cnt++;
 	}
 	if (cnt != mddev->raid_disks) {
-		printk(KERN_ERR "md/raid0:%s: too few disks (%d of %d) - "
-		       "aborting!\n", mdname(mddev), cnt, mddev->raid_disks);
+		pr_warn("md/raid0:%s: too few disks (%d of %d) - aborting!\n",
+			mdname(mddev), cnt, mddev->raid_disks);
 		goto abort;
 	}
 	zone->nb_dev = cnt;
@@ -357,8 +357,7 @@ static int raid0_run(struct mddev *mddev)
 	int ret;
 
 	if (mddev->chunk_sectors == 0) {
-		printk(KERN_ERR "md/raid0:%s: chunk size must be set.\n",
-		       mdname(mddev));
+		pr_warn("md/raid0:%s: chunk size must be set.\n", mdname(mddev));
 		return -EINVAL;
 	}
 	if (md_check_no_bitmap(mddev))
@@ -399,9 +398,9 @@ static int raid0_run(struct mddev *mddev)
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
 
-	printk(KERN_INFO "md/raid0:%s: md_size is %llu sectors.\n",
-	       mdname(mddev),
-	       (unsigned long long)mddev->array_sectors);
+	pr_debug("md/raid0:%s: md_size is %llu sectors.\n",
+		 mdname(mddev),
+		 (unsigned long long)mddev->array_sectors);
 
 	if (mddev->queue) {
 		/* calculate the max read-ahead size.
@@ -509,17 +508,17 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
 	struct r0conf *priv_conf;
 
 	if (mddev->degraded != 1) {
-		printk(KERN_ERR "md/raid0:%s: raid5 must be degraded! Degraded disks: %d\n",
-		       mdname(mddev),
-		       mddev->degraded);
+		pr_warn("md/raid0:%s: raid5 must be degraded! Degraded disks: %d\n",
+			mdname(mddev),
+			mddev->degraded);
 		return ERR_PTR(-EINVAL);
 	}
 
 	rdev_for_each(rdev, mddev) {
 		/* check slot number for a disk */
 		if (rdev->raid_disk == mddev->raid_disks-1) {
-			printk(KERN_ERR "md/raid0:%s: raid5 must have missing parity disk!\n",
-			       mdname(mddev));
+			pr_warn("md/raid0:%s: raid5 must have missing parity disk!\n",
+				mdname(mddev));
 			return ERR_PTR(-EINVAL);
 		}
 		rdev->sectors = mddev->dev_sectors;
@@ -549,19 +548,19 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
 	 *  - all mirrors must be already degraded
 	 */
 	if (mddev->layout != ((1 << 8) + 2)) {
-		printk(KERN_ERR "md/raid0:%s:: Raid0 cannot takeover layout: 0x%x\n",
-		       mdname(mddev),
-		       mddev->layout);
+		pr_warn("md/raid0:%s:: Raid0 cannot takeover layout: 0x%x\n",
+			mdname(mddev),
+			mddev->layout);
 		return ERR_PTR(-EINVAL);
 	}
 	if (mddev->raid_disks & 1) {
-		printk(KERN_ERR "md/raid0:%s: Raid0 cannot takeover Raid10 with odd disk number.\n",
-		       mdname(mddev));
+		pr_warn("md/raid0:%s: Raid0 cannot takeover Raid10 with odd disk number.\n",
+			mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
 	if (mddev->degraded != (mddev->raid_disks>>1)) {
-		printk(KERN_ERR "md/raid0:%s: All mirrors must be already degraded!\n",
-		       mdname(mddev));
+		pr_warn("md/raid0:%s: All mirrors must be already degraded!\n",
+			mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -588,7 +587,7 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
 	 *  - (N - 1) mirror drives must be already faulty
 	 */
 	if ((mddev->raid_disks - 1) != mddev->degraded) {
-		printk(KERN_ERR "md/raid0:%s: (N - 1) mirrors drives must be already faulty!\n",
+		pr_err("md/raid0:%s: (N - 1) mirrors drives must be already faulty!\n",
 		       mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
@@ -631,8 +630,8 @@ static void *raid0_takeover(struct mddev *mddev)
 	 */
 
 	if (mddev->bitmap) {
-		printk(KERN_ERR "md/raid0: %s: cannot takeover array with bitmap\n",
-		       mdname(mddev));
+		pr_warn("md/raid0: %s: cannot takeover array with bitmap\n",
+			mdname(mddev));
 		return ERR_PTR(-EBUSY);
 	}
 	if (mddev->level == 4)
@@ -642,8 +641,8 @@ static void *raid0_takeover(struct mddev *mddev)
 		if (mddev->layout == ALGORITHM_PARITY_N)
 			return raid0_takeover_raid45(mddev);
 
-		printk(KERN_ERR "md/raid0:%s: Raid can only takeover Raid5 with layout: %d\n",
-		       mdname(mddev), ALGORITHM_PARITY_N);
+		pr_warn("md/raid0:%s: Raid can only takeover Raid5 with layout: %d\n",
+			mdname(mddev), ALGORITHM_PARITY_N);
 	}
 
 	if (mddev->level == 10)
@@ -652,7 +651,7 @@ static void *raid0_takeover(struct mddev *mddev)
 	if (mddev->level == 1)
 		return raid0_takeover_raid1(mddev);
 
-	printk(KERN_ERR "Takeover from raid%i to raid0 not supported\n",
+	pr_warn("Takeover from raid%i to raid0 not supported\n",
 		mddev->level);
 
 	return ERR_PTR(-EINVAL);


