From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 19/54] md/raid1: Replace printk() calls by the usage of higher
 level interfaces
Date: Thu, 6 Oct 2016 11:16:55 +0200
Message-ID: <10a63a58-0bcc-125f-3693-cb719a1297a8@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 4 Oct 2016 20:30:07 +0200

1. Add a definition for the macros "MY_LOG_PREFIX" and "pr_fmt"
   so that their information can be used for consistent message output.

2. Prefer usage of some higher level macros over calling "printk" directly
   in this software module.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 91 ++++++++++++++++++++++++++----------------------------
 1 file changed, 43 insertions(+), 48 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3a1194e..9754b7d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -31,6 +31,8 @@
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define MY_LOG_PREFIX KBUILD_MODNAME ": "
+#define pr_fmt(fmt) MY_LOG_PREFIX fmt
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
@@ -347,13 +349,11 @@ static void raid1_end_read_request(struct bio *bio)
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
+
+		pr_err_ratelimited("%s: %s: rescheduling sector %llu\n",
+				   mdname(conf->mddev),
+				   bdevname(rdev->bdev, b),
+				   (unsigned long long)r1_bio->sector);
 		set_bit(R1BIO_ReadError, &r1_bio->state);
 		reschedule_retry(r1_bio);
 		/* don't drop the reference on read_disk yet */
@@ -1457,34 +1457,34 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_mask_bits(&mddev->flags, 0,
 		      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
-	printk(KERN_ALERT
-	       "md/raid1:%s: Disk failure on %s, disabling device.\n"
-	       "md/raid1:%s: Operation continuing on %d devices.\n",
-	       mdname(mddev), bdevname(rdev->bdev, b),
-	       mdname(mddev), conf->raid_disks - mddev->degraded);
+	pr_alert("%s: Disk failure on %s, disabling device.\n"
+		 MY_LOG_PREFIX "%s: Operation continuing on %d devices.\n",
+		 mdname(mddev), bdevname(rdev->bdev, b),
+		 mdname(mddev), conf->raid_disks - mddev->degraded);
 }
 
 static void print_conf(struct r1conf *conf)
 {
 	int i;
 
-	printk(KERN_DEBUG "RAID1 conf printout:\n");
+	pr_debug("conf printout:\n");
 	if (!conf) {
-		printk(KERN_DEBUG "(!conf)\n");
+		pr_debug("(!conf)\n");
 		return;
 	}
-	printk(KERN_DEBUG " --- wd:%d rd:%d\n", conf->raid_disks - conf->mddev->degraded,
-		conf->raid_disks);
+	pr_debug("--- wd:%d rd:%d\n",
+		 conf->raid_disks - conf->mddev->degraded,
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
+			pr_debug("disk %d, wo:%d, o:%d, dev:%s\n",
+				 i, !test_bit(In_sync, &rdev->flags),
+				 !test_bit(Faulty, &rdev->flags),
+				 bdevname(rdev->bdev, b));
 	}
 	rcu_read_unlock();
 }
@@ -1821,11 +1821,10 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			 * work just disable and interrupt the recovery.
 			 * Don't fail devices as that won't really help.
 			 */
-			printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O read error"
-			       " for block %llu\n",
-			       mdname(mddev),
-			       bdevname(bio->bi_bdev, b),
-			       (unsigned long long)r1_bio->sector);
+			pr_alert("%s: %s: unrecoverable I/O read error for block %llu\n",
+				 mdname(mddev),
+				 bdevname(bio->bi_bdev, b),
+				 (unsigned long long)r1_bio->sector);
 			for (d = 0; d < conf->raid_disks * 2; d++) {
 				rdev = conf->mirrors[d].rdev;
 				if (!rdev || test_bit(Faulty, &rdev->flags))
@@ -2118,13 +2117,13 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
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
+					pr_info("%s: read error corrected "
+						"(%d sectors at %llu on %s)\n",
+						mdname(mddev),
+						s,
+						(unsigned long long)(sect +
+								     rdev->data_offset),
+						bdevname(rdev->bdev, b));
 				}
 				rdev_dec_pending(rdev, mddev);
 			} else
@@ -2307,9 +2306,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 read_more:
 	disk = read_balance(conf, r1_bio, &max_sectors);
 	if (disk == -1) {
-		printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O"
-		       " read error for block %llu\n",
-		       mdname(mddev), b, (unsigned long long)r1_bio->sector);
+		pr_alert("%s: %s: unrecoverable I/O read error for block %llu\n",
+			 mdname(mddev), b, (unsigned long long)r1_bio->sector);
 		raid_end_bio_io(r1_bio);
 	} else {
 		const unsigned long do_sync
@@ -2325,8 +2323,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 			 max_sectors);
 		r1_bio->bios[r1_bio->read_disk] = bio;
 		rdev = conf->mirrors[disk].rdev;
-		printk_ratelimited(KERN_ERR
-				   "md/raid1:%s: redirecting sector %llu"
+		pr_err_ratelimited("%s: redirecting sector %llu"
 				   " to other mirror: %s\n",
 				   mdname(mddev),
 				   (unsigned long long)r1_bio->sector,
@@ -2910,12 +2907,12 @@ static int raid1_run(struct mddev *mddev)
 	bool discard_supported = false;
 
 	if (mddev->level != 1) {
-		printk(KERN_ERR "md/raid1:%s: raid level not set to mirroring (%d)\n",
+		pr_err("%s: raid level not set to mirroring (%d)\n",
 		       mdname(mddev), mddev->level);
 		return -EIO;
 	}
 	if (mddev->reshape_position != MaxSector) {
-		printk(KERN_ERR "md/raid1:%s: reshape_position set but not supported\n",
+		pr_err("%s: reshape_position set but not supported\n",
 		       mdname(mddev));
 		return -EIO;
 	}
@@ -2955,12 +2952,11 @@ static int raid1_run(struct mddev *mddev)
 		mddev->recovery_cp = MaxSector;
 
 	if (mddev->recovery_cp != MaxSector)
-		printk(KERN_NOTICE "md/raid1:%s: not clean"
-		       " -- starting background reconstruction\n",
-		       mdname(mddev));
-	printk(KERN_INFO
-		"md/raid1:%s: active with %d out of %d mirrors\n",
-		mdname(mddev), mddev->raid_disks - mddev->degraded,
+		pr_notice("%s: not clean -- starting background reconstruction\n",
+			  mdname(mddev));
+	pr_info("%s: active with %d out of %d mirrors\n",
+		mdname(mddev),
+		mddev->raid_disks - mddev->degraded,
 		mddev->raid_disks);
 
 	/*
@@ -3112,9 +3108,8 @@ static int raid1_reshape(struct mddev *mddev)
 			rdev->raid_disk = d2;
 			sysfs_unlink_rdev(mddev, rdev);
 			if (sysfs_link_rdev(mddev, rdev))
-				printk(KERN_WARNING
-				       "md/raid1:%s: cannot register rd%d\n",
-				       mdname(mddev), rdev->raid_disk);
+				pr_warn("%s: cannot register rd%d\n",
+					mdname(mddev), rdev->raid_disk);
 		}
 		if (rdev)
 			newmirrors[d2++].rdev = rdev;
-- 
2.10.1

