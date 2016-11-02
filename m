From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 7/9] md/raid1: change printk() to pr_*()
Date: Wed, 02 Nov 2016 14:16:50 +1100
Message-ID: <147805661013.23566.14989893961440455026.stgit@noble>
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
 drivers/md/raid1.c |   99 ++++++++++++++++++++++------------------------------
 1 file changed, 41 insertions(+), 58 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1961d827dbd1..86ecf57ec612 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -347,13 +347,10 @@ static void raid1_end_read_request(struct bio *bio)
 		 * oops, read error:
 		 */
 		char b[BDEVNAME_SIZE];
-		printk_ratelimited(
-			KERN_ERR "md/raid1:%s: %s: "
-			"rescheduling sector %llu\n",
-			mdname(conf->mddev),
-			bdevname(rdev->bdev,
-				 b),
-			(unsigned long long)r1_bio->sector);
+		pr_err_ratelimited("md/raid1:%s: %s: rescheduling sector %llu\n",
+				   mdname(conf->mddev),
+				   bdevname(rdev->bdev, b),
+				   (unsigned long long)r1_bio->sector);
 		set_bit(R1BIO_ReadError, &r1_bio->state);
 		reschedule_retry(r1_bio);
 		/* don't drop the reference on read_disk yet */
@@ -1458,34 +1455,33 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_mask_bits(&mddev->flags, 0,
 		      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
-	printk(KERN_ALERT
-	       "md/raid1:%s: Disk failure on %s, disabling device.\n"
-	       "md/raid1:%s: Operation continuing on %d devices.\n",
-	       mdname(mddev), bdevname(rdev->bdev, b),
-	       mdname(mddev), conf->raid_disks - mddev->degraded);
+	pr_crit("md/raid1:%s: Disk failure on %s, disabling device.\n"
+		"md/raid1:%s: Operation continuing on %d devices.\n",
+		mdname(mddev), bdevname(rdev->bdev, b),
+		mdname(mddev), conf->raid_disks - mddev->degraded);
 }
 
 static void print_conf(struct r1conf *conf)
 {
 	int i;
 
-	printk(KERN_DEBUG "RAID1 conf printout:\n");
+	pr_debug("RAID1 conf printout:\n");
 	if (!conf) {
-		printk(KERN_DEBUG "(!conf)\n");
+		pr_debug("(!conf)\n");
 		return;
 	}
-	printk(KERN_DEBUG " --- wd:%d rd:%d\n", conf->raid_disks - conf->mddev->degraded,
-		conf->raid_disks);
+	pr_debug(" --- wd:%d rd:%d\n", conf->raid_disks - conf->mddev->degraded,
+		 conf->raid_disks);
 
 	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
 		char b[BDEVNAME_SIZE];
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev)
-			printk(KERN_DEBUG " disk %d, wo:%d, o:%d, dev:%s\n",
-			       i, !test_bit(In_sync, &rdev->flags),
-			       !test_bit(Faulty, &rdev->flags),
-			       bdevname(rdev->bdev,b));
+			pr_debug(" disk %d, wo:%d, o:%d, dev:%s\n",
+				 i, !test_bit(In_sync, &rdev->flags),
+				 !test_bit(Faulty, &rdev->flags),
+				 bdevname(rdev->bdev,b));
 	}
 	rcu_read_unlock();
 }
@@ -1822,11 +1818,10 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			 * work just disable and interrupt the recovery.
 			 * Don't fail devices as that won't really help.
 			 */
-			printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O read error"
-			       " for block %llu\n",
-			       mdname(mddev),
-			       bdevname(bio->bi_bdev, b),
-			       (unsigned long long)r1_bio->sector);
+			pr_crit_ratelimited("md/raid1:%s: %s: unrecoverable I/O read error for block %llu\n",
+					    mdname(mddev),
+					    bdevname(bio->bi_bdev, b),
+					    (unsigned long long)r1_bio->sector);
 			for (d = 0; d < conf->raid_disks * 2; d++) {
 				rdev = conf->mirrors[d].rdev;
 				if (!rdev || test_bit(Faulty, &rdev->flags))
@@ -2119,13 +2114,11 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 				if (r1_sync_page_io(rdev, sect, s,
 						    conf->tmppage, READ)) {
 					atomic_add(s, &rdev->corrected_errors);
-					printk(KERN_INFO
-					       "md/raid1:%s: read error corrected "
-					       "(%d sectors at %llu on %s)\n",
-					       mdname(mddev), s,
-					       (unsigned long long)(sect +
-								    rdev->data_offset),
-					       bdevname(rdev->bdev, b));
+					pr_info("md/raid1:%s: read error corrected (%d sectors at %llu on %s)\n",
+						mdname(mddev), s,
+						(unsigned long long)(sect +
+								     rdev->data_offset),
+						bdevname(rdev->bdev, b));
 				}
 				rdev_dec_pending(rdev, mddev);
 			} else
@@ -2308,9 +2301,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 read_more:
 	disk = read_balance(conf, r1_bio, &max_sectors);
 	if (disk == -1) {
-		printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O"
-		       " read error for block %llu\n",
-		       mdname(mddev), b, (unsigned long long)r1_bio->sector);
+		pr_crit_ratelimited("md/raid1:%s: %s: unrecoverable I/O read error for block %llu\n",
+				    mdname(mddev), b, (unsigned long long)r1_bio->sector);
 		raid_end_bio_io(r1_bio);
 	} else {
 		const unsigned long do_sync
@@ -2326,12 +2318,10 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 			 max_sectors);
 		r1_bio->bios[r1_bio->read_disk] = bio;
 		rdev = conf->mirrors[disk].rdev;
-		printk_ratelimited(KERN_ERR
-				   "md/raid1:%s: redirecting sector %llu"
-				   " to other mirror: %s\n",
-				   mdname(mddev),
-				   (unsigned long long)r1_bio->sector,
-				   bdevname(rdev->bdev, b));
+		pr_info_ratelimited("md/raid1:%s: redirecting sector %llu to other mirror: %s\n",
+				    mdname(mddev),
+				    (unsigned long long)r1_bio->sector,
+				    bdevname(rdev->bdev, b));
 		bio->bi_iter.bi_sector = r1_bio->sector + rdev->data_offset;
 		bio->bi_bdev = rdev->bdev;
 		bio->bi_end_io = raid1_end_read_request;
@@ -2871,12 +2861,8 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 
 	err = -ENOMEM;
 	conf->thread = md_register_thread(raid1d, mddev, "raid1");
-	if (!conf->thread) {
-		printk(KERN_ERR
-		       "md/raid1:%s: couldn't allocate thread\n",
-		       mdname(mddev));
+	if (!conf->thread)
 		goto abort;
-	}
 
 	return conf;
 
@@ -2901,13 +2887,13 @@ static int raid1_run(struct mddev *mddev)
 	bool discard_supported = false;
 
 	if (mddev->level != 1) {
-		printk(KERN_ERR "md/raid1:%s: raid level not set to mirroring (%d)\n",
-		       mdname(mddev), mddev->level);
+		pr_warn("md/raid1:%s: raid level not set to mirroring (%d)\n",
+			mdname(mddev), mddev->level);
 		return -EIO;
 	}
 	if (mddev->reshape_position != MaxSector) {
-		printk(KERN_ERR "md/raid1:%s: reshape_position set but not supported\n",
-		       mdname(mddev));
+		pr_warn("md/raid1:%s: reshape_position set but not supported\n",
+			mdname(mddev));
 		return -EIO;
 	}
 	/*
@@ -2946,11 +2932,9 @@ static int raid1_run(struct mddev *mddev)
 		mddev->recovery_cp = MaxSector;
 
 	if (mddev->recovery_cp != MaxSector)
-		printk(KERN_NOTICE "md/raid1:%s: not clean"
-		       " -- starting background reconstruction\n",
-		       mdname(mddev));
-	printk(KERN_INFO
-		"md/raid1:%s: active with %d out of %d mirrors\n",
+		pr_info("md/raid1:%s: not clean -- starting background reconstruction\n",
+			mdname(mddev));
+	pr_info("md/raid1:%s: active with %d out of %d mirrors\n",
 		mdname(mddev), mddev->raid_disks - mddev->degraded,
 		mddev->raid_disks);
 
@@ -3103,9 +3087,8 @@ static int raid1_reshape(struct mddev *mddev)
 			rdev->raid_disk = d2;
 			sysfs_unlink_rdev(mddev, rdev);
 			if (sysfs_link_rdev(mddev, rdev))
-				printk(KERN_WARNING
-				       "md/raid1:%s: cannot register rd%d\n",
-				       mdname(mddev), rdev->raid_disk);
+				pr_warn("md/raid1:%s: cannot register rd%d\n",
+					mdname(mddev), rdev->raid_disk);
 		}
 		if (rdev)
 			newmirrors[d2++].rdev = rdev;


