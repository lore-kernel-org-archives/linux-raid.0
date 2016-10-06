From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 49/54] md/raid10: Replace printk() calls by the usage of
 higher level interfaces
Date: Thu, 6 Oct 2016 11:49:02 +0200
Message-ID: <f9f16d1c-c50d-d4be-a6ba-2cb7081eb9b5@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 21:00:05 +0200

1. Add a definition for the macros "MY_LOG_PREFIX" and "pr_fmt"
   so that their information can be used for consistent message output.

2. Prefer usage of some higher level macros over calling "printk" directly
   in this software module.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 168 +++++++++++++++++++++++-----------------------------
 1 file changed, 74 insertions(+), 94 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5119846..0f2cb20 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -18,6 +18,8 @@
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define MY_LOG_PREFIX KBUILD_MODNAME ": "
+#define pr_fmt(fmt) MY_LOG_PREFIX fmt
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
@@ -404,8 +406,8 @@ static void raid10_end_read_request(struct bio *bio)
 		 * oops, read error - keep the refcount on the rdev
 		 */
 		char b[BDEVNAME_SIZE];
-		printk_ratelimited(KERN_ERR
-				   "md/raid10:%s: %s: rescheduling sector %llu\n",
+
+		pr_err_ratelimited("%s: %s: rescheduling sector %llu\n",
 				   mdname(conf->mddev),
 				   bdevname(rdev->bdev, b),
 				   (unsigned long long)r10_bio->sector);
@@ -1586,11 +1588,10 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_mask_bits(&mddev->flags, 0,
 		      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
 	spin_unlock_irqrestore(&conf->device_lock, flags);
-	printk(KERN_ALERT
-	       "md/raid10:%s: Disk failure on %s, disabling device.\n"
-	       "md/raid10:%s: Operation continuing on %d devices.\n",
-	       mdname(mddev), bdevname(rdev->bdev, b),
-	       mdname(mddev), conf->geo.raid_disks - mddev->degraded);
+	pr_alert("%s: Disk failure on %s, disabling device.\n"
+		 MY_LOG_PREFIX "%s: Operation continuing on %d devices.\n",
+		 mdname(mddev), bdevname(rdev->bdev, b),
+		 mdname(mddev), conf->geo.raid_disks - mddev->degraded);
 }
 
 static void print_conf(struct r10conf *conf)
@@ -1598,13 +1599,14 @@ static void print_conf(struct r10conf *conf)
 	int i;
 	struct md_rdev *rdev;
 
-	printk(KERN_DEBUG "RAID10 conf printout:\n");
+	pr_debug("conf printout:\n");
 	if (!conf) {
-		printk(KERN_DEBUG "(!conf)\n");
+		pr_debug("(!conf)\n");
 		return;
 	}
-	printk(KERN_DEBUG " --- wd:%d rd:%d\n", conf->geo.raid_disks - conf->mddev->degraded,
-		conf->geo.raid_disks);
+	pr_debug("--- wd:%d rd:%d\n",
+		 conf->geo.raid_disks - conf->mddev->degraded,
+		 conf->geo.raid_disks);
 
 	/* This is only called with ->reconfix_mutex held, so
 	 * rcu protection of rdev is not needed */
@@ -1612,10 +1614,10 @@ static void print_conf(struct r10conf *conf)
 		char b[BDEVNAME_SIZE];
 		rdev = conf->mirrors[i].rdev;
 		if (rdev)
-			printk(KERN_DEBUG " disk %d, wo:%d, o:%d, dev:%s\n",
-				i, !test_bit(In_sync, &rdev->flags),
-			        !test_bit(Faulty, &rdev->flags),
-				bdevname(rdev->bdev,b));
+			pr_debug("disk %d, wo:%d, o:%d, dev:%s\n",
+				 i, !test_bit(In_sync, &rdev->flags),
+				 !test_bit(Faulty, &rdev->flags),
+				 bdevname(rdev->bdev, b));
 	}
 }
 
@@ -2106,11 +2108,8 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 				ok = rdev_set_badblocks(rdev2, addr, s, 0);
 				if (!ok) {
 					/* just abort the recovery */
-					printk(KERN_NOTICE
-					       "md/raid10:%s: recovery aborted"
-					       " due to read error\n",
-					       mdname(mddev));
-
+					pr_notice("%s: recovery aborted due to read error\n",
+						  mdname(mddev));
 					conf->mirrors[dw].recovery_disabled
 						= mddev->recovery_disabled;
 					set_bit(MD_RECOVERY_INTR,
@@ -2256,14 +2255,10 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
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
+		pr_notice("%s: %s: Raid device exceeded read_error threshold [cur %d:max %d]\n",
+			  mdname(mddev), b,
+			  atomic_read(&rdev->read_errors), max_read_errors);
+		pr_notice("%s: %s: Failing raid device\n", mdname(mddev), b);
 		md_error(mddev, rdev);
 		r10_bio->devs[r10_bio->read_slot].bio = IO_BLOCKED;
 		return;
@@ -2353,20 +2348,17 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
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
+				pr_notice("%s: read correction write failed ("
+					  "%d sectors at %llu on %s)\n",
+					  mdname(mddev),
+					  s,
+					  (unsigned long long)
+					  (sect
+					  + choose_data_offset(r10_bio, rdev)),
+					  bdevname(rdev->bdev, b));
+				pr_notice("%s: %s: failing drive\n",
+					  mdname(mddev),
+					  bdevname(rdev->bdev, b));
 			}
 			rdev_dec_pending(rdev, mddev);
 			rcu_read_lock();
@@ -2394,29 +2386,27 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 						 READ)) {
 			case 0:
 				/* Well, this device is dead */
-				printk(KERN_NOTICE
-				       "md/raid10:%s: unable to read back "
-				       "corrected sectors"
-				       " (%d sectors at %llu on %s)\n",
-				       mdname(mddev), s,
-				       (unsigned long long)(
-					       sect +
-					       choose_data_offset(r10_bio, rdev)),
-				       bdevname(rdev->bdev, b));
-				printk(KERN_NOTICE "md/raid10:%s: %s: failing "
-				       "drive\n",
-				       mdname(mddev),
-				       bdevname(rdev->bdev, b));
+				pr_notice("%s: unable to read back corrected sectors ("
+					  "%d sectors at %llu on %s)\n",
+					  mdname(mddev),
+					  s,
+					  (unsigned long long)
+					  (sect
+					  + choose_data_offset(r10_bio, rdev)),
+					  bdevname(rdev->bdev, b));
+				pr_notice("%s: %s: failing drive\n",
+					  mdname(mddev),
+					  bdevname(rdev->bdev, b));
 				break;
 			case 1:
-				printk(KERN_INFO
-				       "md/raid10:%s: read error corrected"
-				       " (%d sectors at %llu on %s)\n",
-				       mdname(mddev), s,
-				       (unsigned long long)(
-					       sect +
-					       choose_data_offset(r10_bio, rdev)),
-				       bdevname(rdev->bdev, b));
+				pr_info("%s: read error corrected ("
+					"%d sectors at %llu on %s)\n",
+					mdname(mddev),
+					s,
+					(unsigned long long)
+					(sect
+					+ choose_data_offset(r10_bio, rdev)),
+					bdevname(rdev->bdev, b));
 				atomic_add(s, &rdev->corrected_errors);
 			}
 
@@ -2526,23 +2516,19 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 read_more:
 	rdev = read_balance(conf, r10_bio, &max_sectors);
 	if (rdev == NULL) {
-		printk(KERN_ALERT "md/raid10:%s: %s: unrecoverable I/O"
-		       " read error for block %llu\n",
-		       mdname(mddev), b,
-		       (unsigned long long)r10_bio->sector);
+		pr_alert("%s: %s: unrecoverable I/O read error for block %llu\n",
+			 mdname(mddev), b,
+			 (unsigned long long)r10_bio->sector);
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
+	pr_err_ratelimited("%s: %s: redirecting sector %llu to another mirror\n",
+			   mdname(mddev),
+			   bdevname(rdev->bdev, b),
+			   (unsigned long long)r10_bio->sector);
 	bio = bio_clone_mddev(r10_bio->master_bio,
 			      GFP_NOIO, mddev);
 	bio_trim(bio, r10_bio->sector - bio->bi_iter.bi_sector, max_sectors);
@@ -3157,9 +3143,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				if (!any_working)  {
 					if (!test_and_set_bit(MD_RECOVERY_INTR,
 							      &mddev->recovery))
-						printk(KERN_INFO "md/raid10:%s: insufficient "
-						       "working devices for recovery.\n",
-						       mdname(mddev));
+						pr_info("%s: insufficient working devices for recovery.\n",
+							mdname(mddev));
 					mirror->recovery_disabled
 						= mddev->recovery_disabled;
 				}
@@ -3486,14 +3471,13 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	copies = setup_geo(&geo, mddev, geo_new);
 
 	if (copies == -2) {
-		printk(KERN_ERR "md/raid10:%s: chunk size must be "
-		       "at least PAGE_SIZE(%ld) and be a power of 2.\n",
+		pr_err("%s: chunk size must be at least PAGE_SIZE(%ld) and be a power of 2.\n",
 		       mdname(mddev), PAGE_SIZE);
 		return ERR_PTR(-EINVAL);
 	}
 
 	if (copies < 2 || copies > mddev->raid_disks) {
-		printk(KERN_ERR "md/raid10:%s: unsupported raid10 layout: 0x%8x\n",
+		pr_err("%s: unsupported raid10 layout: 0x%8x\n",
 		       mdname(mddev), mddev->new_layout);
 		return ERR_PTR(-EINVAL);
 	}
@@ -3657,8 +3641,7 @@ static int raid10_run(struct mddev *mddev)
 	}
 	/* need to check that every block has at least one working mirror */
 	if (!enough(conf, -1)) {
-		printk(KERN_ERR "md/raid10:%s: not enough operational mirrors.\n",
-		       mdname(mddev));
+		pr_err("%s: not enough operational mirrors.\n", mdname(mddev));
 		goto out_free_conf;
 	}
 
@@ -3699,12 +3682,11 @@ static int raid10_run(struct mddev *mddev)
 	}
 
 	if (mddev->recovery_cp != MaxSector)
-		printk(KERN_NOTICE "md/raid10:%s: not clean"
-		       " -- starting background reconstruction\n",
-		       mdname(mddev));
-	printk(KERN_INFO
-		"md/raid10:%s: active with %d out of %d devices\n",
-		mdname(mddev), conf->geo.raid_disks - mddev->degraded,
+		pr_notice("%s: not clean - starting background reconstruction\n",
+			  mdname(mddev));
+	pr_info("%s: active with %d out of %d devices\n",
+		mdname(mddev),
+		conf->geo.raid_disks - mddev->degraded,
 		conf->geo.raid_disks);
 	/*
 	 * Ok, everything is just fine now
@@ -3740,7 +3722,7 @@ static int raid10_run(struct mddev *mddev)
 
 		if (max(before_length, after_length) > min_offset_diff) {
 			/* This cannot work */
-			printk("md/raid10: offset difference not enough to continue reshape\n");
+			pr_notice("offset difference not enough to continue reshape\n");
 			goto out_free_conf;
 		}
 		conf->offset_diff = min_offset_diff;
@@ -3847,8 +3829,7 @@ static void *raid10_takeover_raid0(struct mddev *mddev, sector_t size, int devs)
 	struct r10conf *conf;
 
 	if (mddev->degraded > 0) {
-		printk(KERN_ERR "md/raid10:%s: Error: degraded raid0!\n",
-		       mdname(mddev));
+		pr_err("%s: Error: degraded raid0!\n", mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
 	sector_div(size, devs);
@@ -3888,8 +3869,7 @@ static void *raid10_takeover(struct mddev *mddev)
 		/* for raid0 takeover only one zone is supported */
 		raid0_conf = mddev->private;
 		if (raid0_conf->nr_strip_zones > 1) {
-			printk(KERN_ERR "md/raid10:%s: cannot takeover raid 0"
-			       " with more than one zone.\n",
+			pr_err("%s: cannot takeover raid 0 with more than one zone.\n",
 			       mdname(mddev));
 			return ERR_PTR(-EINVAL);
 		}
@@ -4078,7 +4058,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		sector_t size = raid10_size(mddev, 0, 0);
 		if (size < mddev->array_sectors) {
 			spin_unlock_irq(&conf->device_lock);
-			printk(KERN_ERR "md/raid10:%s: array size must be reduce before number of disks\n",
+			pr_err("%s: array size must be reduced before number of disks\n",
 			       mdname(mddev));
 			return -EINVAL;
 		}
-- 
2.10.1
