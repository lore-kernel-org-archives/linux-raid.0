From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 8/9] md/raid10: change printk() to pr_*()
Date: Wed, 02 Nov 2016 14:16:50 +1100
Message-ID: <147805661031.23566.3846926960470189613.stgit@noble>
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

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |  141 ++++++++++++++++++++-------------------------------
 1 file changed, 56 insertions(+), 85 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index be1a9fca3b2d..bf6980ad8c00 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -404,8 +404,7 @@ static void raid10_end_read_request(struct bio *bio)
 		 * oops, read error - keep the refcount on the rdev
 		 */
 		char b[BDEVNAME_SIZE];
-		printk_ratelimited(KERN_ERR
-				   "md/raid10:%s: %s: rescheduling sector %llu\n",
+		pr_err_ratelimited("md/raid10:%s: %s: rescheduling sector %llu\n",
 				   mdname(conf->mddev),
 				   bdevname(rdev->bdev, b),
 				   (unsigned long long)r10_bio->sector);
@@ -1586,11 +1585,10 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_mask_bits(&mddev->flags, 0,
 		      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
 	spin_unlock_irqrestore(&conf->device_lock, flags);
-	printk(KERN_ALERT
-	       "md/raid10:%s: Disk failure on %s, disabling device.\n"
-	       "md/raid10:%s: Operation continuing on %d devices.\n",
-	       mdname(mddev), bdevname(rdev->bdev, b),
-	       mdname(mddev), conf->geo.raid_disks - mddev->degraded);
+	pr_crit("md/raid10:%s: Disk failure on %s, disabling device.\n"
+		"md/raid10:%s: Operation continuing on %d devices.\n",
+		mdname(mddev), bdevname(rdev->bdev, b),
+		mdname(mddev), conf->geo.raid_disks - mddev->degraded);
 }
 
 static void print_conf(struct r10conf *conf)
@@ -1598,13 +1596,13 @@ static void print_conf(struct r10conf *conf)
 	int i;
 	struct md_rdev *rdev;
 
-	printk(KERN_DEBUG "RAID10 conf printout:\n");
+	pr_debug("RAID10 conf printout:\n");
 	if (!conf) {
-		printk(KERN_DEBUG "(!conf)\n");
+		pr_debug("(!conf)\n");
 		return;
 	}
-	printk(KERN_DEBUG " --- wd:%d rd:%d\n", conf->geo.raid_disks - conf->mddev->degraded,
-		conf->geo.raid_disks);
+	pr_debug(" --- wd:%d rd:%d\n", conf->geo.raid_disks - conf->mddev->degraded,
+		 conf->geo.raid_disks);
 
 	/* This is only called with ->reconfix_mutex held, so
 	 * rcu protection of rdev is not needed */
@@ -1612,10 +1610,10 @@ static void print_conf(struct r10conf *conf)
 		char b[BDEVNAME_SIZE];
 		rdev = conf->mirrors[i].rdev;
 		if (rdev)
-			printk(KERN_DEBUG " disk %d, wo:%d, o:%d, dev:%s\n",
-				i, !test_bit(In_sync, &rdev->flags),
-			        !test_bit(Faulty, &rdev->flags),
-				bdevname(rdev->bdev,b));
+			pr_debug(" disk %d, wo:%d, o:%d, dev:%s\n",
+				 i, !test_bit(In_sync, &rdev->flags),
+				 !test_bit(Faulty, &rdev->flags),
+				 bdevname(rdev->bdev,b));
 	}
 }
 
@@ -2106,10 +2104,8 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 				ok = rdev_set_badblocks(rdev2, addr, s, 0);
 				if (!ok) {
 					/* just abort the recovery */
-					printk(KERN_NOTICE
-					       "md/raid10:%s: recovery aborted"
-					       " due to read error\n",
-					       mdname(mddev));
+					pr_notice("md/raid10:%s: recovery aborted due to read error\n",
+						  mdname(mddev));
 
 					conf->mirrors[dw].recovery_disabled
 						= mddev->recovery_disabled;
@@ -2256,14 +2252,11 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		char b[BDEVNAME_SIZE];
 		bdevname(rdev->bdev, b);
 
-		printk(KERN_NOTICE
-		       "md/raid10:%s: %s: Raid device exceeded "
-		       "read_error threshold [cur %d:max %d]\n",
-		       mdname(mddev), b,
-		       atomic_read(&rdev->read_errors), max_read_errors);
-		printk(KERN_NOTICE
-		       "md/raid10:%s: %s: Failing raid device\n",
-		       mdname(mddev), b);
+		pr_notice("md/raid10:%s: %s: Raid device exceeded read_error threshold [cur %d:max %d]\n",
+			  mdname(mddev), b,
+			  atomic_read(&rdev->read_errors), max_read_errors);
+		pr_notice("md/raid10:%s: %s: Failing raid device\n",
+			  mdname(mddev), b);
 		md_error(mddev, rdev);
 		r10_bio->devs[r10_bio->read_slot].bio = IO_BLOCKED;
 		return;
@@ -2353,20 +2346,16 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 					     s, conf->tmppage, WRITE)
 			    == 0) {
 				/* Well, this device is dead */
-				printk(KERN_NOTICE
-				       "md/raid10:%s: read correction "
-				       "write failed"
-				       " (%d sectors at %llu on %s)\n",
-				       mdname(mddev), s,
-				       (unsigned long long)(
-					       sect +
-					       choose_data_offset(r10_bio,
-								  rdev)),
-				       bdevname(rdev->bdev, b));
-				printk(KERN_NOTICE "md/raid10:%s: %s: failing "
-				       "drive\n",
-				       mdname(mddev),
-				       bdevname(rdev->bdev, b));
+				pr_notice("md/raid10:%s: read correction write failed (%d sectors at %llu on %s)\n",
+					  mdname(mddev), s,
+					  (unsigned long long)(
+						  sect +
+						  choose_data_offset(r10_bio,
+								     rdev)),
+					  bdevname(rdev->bdev, b));
+				pr_notice("md/raid10:%s: %s: failing drive\n",
+					  mdname(mddev),
+					  bdevname(rdev->bdev, b));
 			}
 			rdev_dec_pending(rdev, mddev);
 			rcu_read_lock();
@@ -2394,24 +2383,18 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 						 READ)) {
 			case 0:
 				/* Well, this device is dead */
-				printk(KERN_NOTICE
-				       "md/raid10:%s: unable to read back "
-				       "corrected sectors"
-				       " (%d sectors at %llu on %s)\n",
+				pr_notice("md/raid10:%s: unable to read back corrected sectors (%d sectors at %llu on %s)\n",
 				       mdname(mddev), s,
 				       (unsigned long long)(
 					       sect +
 					       choose_data_offset(r10_bio, rdev)),
 				       bdevname(rdev->bdev, b));
-				printk(KERN_NOTICE "md/raid10:%s: %s: failing "
-				       "drive\n",
+				pr_notice("md/raid10:%s: %s: failing drive\n",
 				       mdname(mddev),
 				       bdevname(rdev->bdev, b));
 				break;
 			case 1:
-				printk(KERN_INFO
-				       "md/raid10:%s: read error corrected"
-				       " (%d sectors at %llu on %s)\n",
+				pr_info("md/raid10:%s: read error corrected (%d sectors at %llu on %s)\n",
 				       mdname(mddev), s,
 				       (unsigned long long)(
 					       sect +
@@ -2526,23 +2509,19 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 read_more:
 	rdev = read_balance(conf, r10_bio, &max_sectors);
 	if (rdev == NULL) {
-		printk(KERN_ALERT "md/raid10:%s: %s: unrecoverable I/O"
-		       " read error for block %llu\n",
-		       mdname(mddev), b,
-		       (unsigned long long)r10_bio->sector);
+		pr_crit_ratelimited("md/raid10:%s: %s: unrecoverable I/O read error for block %llu\n",
+				    mdname(mddev), b,
+				    (unsigned long long)r10_bio->sector);
 		raid_end_bio_io(r10_bio);
 		return;
 	}
 
 	do_sync = (r10_bio->master_bio->bi_opf & REQ_SYNC);
 	slot = r10_bio->read_slot;
-	printk_ratelimited(
-		KERN_ERR
-		"md/raid10:%s: %s: redirecting "
-		"sector %llu to another mirror\n",
-		mdname(mddev),
-		bdevname(rdev->bdev, b),
-		(unsigned long long)r10_bio->sector);
+	pr_err_ratelimited("md/raid10:%s: %s: redirecting sector %llu to another mirror\n",
+			   mdname(mddev),
+			   bdevname(rdev->bdev, b),
+			   (unsigned long long)r10_bio->sector);
 	bio = bio_clone_mddev(r10_bio->master_bio,
 			      GFP_NOIO, mddev);
 	bio_trim(bio, r10_bio->sector - bio->bi_iter.bi_sector, max_sectors);
@@ -3157,8 +3136,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				if (!any_working)  {
 					if (!test_and_set_bit(MD_RECOVERY_INTR,
 							      &mddev->recovery))
-						printk(KERN_INFO "md/raid10:%s: insufficient "
-						       "working devices for recovery.\n",
+						pr_warn("md/raid10:%s: insufficient working devices for recovery.\n",
 						       mdname(mddev));
 					mirror->recovery_disabled
 						= mddev->recovery_disabled;
@@ -3486,15 +3464,14 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	copies = setup_geo(&geo, mddev, geo_new);
 
 	if (copies == -2) {
-		printk(KERN_ERR "md/raid10:%s: chunk size must be "
-		       "at least PAGE_SIZE(%ld) and be a power of 2.\n",
-		       mdname(mddev), PAGE_SIZE);
+		pr_warn("md/raid10:%s: chunk size must be at least PAGE_SIZE(%ld) and be a power of 2.\n",
+			mdname(mddev), PAGE_SIZE);
 		goto out;
 	}
 
 	if (copies < 2 || copies > mddev->raid_disks) {
-		printk(KERN_ERR "md/raid10:%s: unsupported raid10 layout: 0x%8x\n",
-		       mdname(mddev), mddev->new_layout);
+		pr_warn("md/raid10:%s: unsupported raid10 layout: 0x%8x\n",
+			mdname(mddev), mddev->new_layout);
 		goto out;
 	}
 
@@ -3554,9 +3531,6 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	return conf;
 
  out:
-	if (err == -ENOMEM)
-		printk(KERN_ERR "md/raid10:%s: couldn't allocate memory.\n",
-		       mdname(mddev));
 	if (conf) {
 		mempool_destroy(conf->r10bio_pool);
 		kfree(conf->mirrors);
@@ -3653,7 +3627,7 @@ static int raid10_run(struct mddev *mddev)
 	}
 	/* need to check that every block has at least one working mirror */
 	if (!enough(conf, -1)) {
-		printk(KERN_ERR "md/raid10:%s: not enough operational mirrors.\n",
+		pr_err("md/raid10:%s: not enough operational mirrors.\n",
 		       mdname(mddev));
 		goto out_free_conf;
 	}
@@ -3695,11 +3669,9 @@ static int raid10_run(struct mddev *mddev)
 	}
 
 	if (mddev->recovery_cp != MaxSector)
-		printk(KERN_NOTICE "md/raid10:%s: not clean"
-		       " -- starting background reconstruction\n",
-		       mdname(mddev));
-	printk(KERN_INFO
-		"md/raid10:%s: active with %d out of %d devices\n",
+		pr_notice("md/raid10:%s: not clean -- starting background reconstruction\n",
+			  mdname(mddev));
+	pr_info("md/raid10:%s: active with %d out of %d devices\n",
 		mdname(mddev), conf->geo.raid_disks - mddev->degraded,
 		conf->geo.raid_disks);
 	/*
@@ -3736,7 +3708,7 @@ static int raid10_run(struct mddev *mddev)
 
 		if (max(before_length, after_length) > min_offset_diff) {
 			/* This cannot work */
-			printk("md/raid10: offset difference not enough to continue reshape\n");
+			pr_warn("md/raid10: offset difference not enough to continue reshape\n");
 			goto out_free_conf;
 		}
 		conf->offset_diff = min_offset_diff;
@@ -3843,8 +3815,8 @@ static void *raid10_takeover_raid0(struct mddev *mddev, sector_t size, int devs)
 	struct r10conf *conf;
 
 	if (mddev->degraded > 0) {
-		printk(KERN_ERR "md/raid10:%s: Error: degraded raid0!\n",
-		       mdname(mddev));
+		pr_warn("md/raid10:%s: Error: degraded raid0!\n",
+			mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
 	sector_div(size, devs);
@@ -3884,9 +3856,8 @@ static void *raid10_takeover(struct mddev *mddev)
 		/* for raid0 takeover only one zone is supported */
 		raid0_conf = mddev->private;
 		if (raid0_conf->nr_strip_zones > 1) {
-			printk(KERN_ERR "md/raid10:%s: cannot takeover raid 0"
-			       " with more than one zone.\n",
-			       mdname(mddev));
+			pr_warn("md/raid10:%s: cannot takeover raid 0 with more than one zone.\n",
+				mdname(mddev));
 			return ERR_PTR(-EINVAL);
 		}
 		return raid10_takeover_raid0(mddev,
@@ -4075,8 +4046,8 @@ static int raid10_start_reshape(struct mddev *mddev)
 		sector_t size = raid10_size(mddev, 0, 0);
 		if (size < mddev->array_sectors) {
 			spin_unlock_irq(&conf->device_lock);
-			printk(KERN_ERR "md/raid10:%s: array size must be reduce before number of disks\n",
-			       mdname(mddev));
+			pr_warn("md/raid10:%s: array size must be reduce before number of disks\n",
+				mdname(mddev));
 			return -EINVAL;
 		}
 		mddev->resync_max_sectors = size;


