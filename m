From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 33/54] md/raid5: Replace printk() calls by the usage of higher
 level interfaces
Date: Thu, 6 Oct 2016 11:33:03 +0200
Message-ID: <1bf0d6e7-81b8-03d5-bf48-eddd84b7542a@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 13:40:03 +0200

1. Add a definition for the macros "MY_LOG_PREFIX" and "pr_fmt"
   so that their information can be used for consistent message output.

2. Prefer usage of some higher level macros over calling "printk" directly
   in this software module.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 215 ++++++++++++++++++++++++-----------------------------
 1 file changed, 96 insertions(+), 119 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f2473fa0..b0a14a6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -43,6 +43,8 @@
  * miss any bits.
  */
 
+#define MY_LOG_PREFIX KBUILD_MODNAME ": "
+#define pr_fmt(fmt) MY_LOG_PREFIX fmt
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
@@ -540,7 +542,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 
 		if (dev->toread || dev->read || dev->towrite || dev->written ||
 		    test_bit(R5_LOCKED, &dev->flags)) {
-			printk(KERN_ERR "sector=%llx i=%d %p %p %p %p %d\n",
+			pr_err("sector=%llx i=%d %p %p %p %p %d\n",
 			       (unsigned long long)sh->sector, i, dev->toread,
 			       dev->read, dev->towrite, dev->written,
 			       test_bit(R5_LOCKED, &dev->flags));
@@ -2346,13 +2348,12 @@ static void raid5_end_read_request(struct bio * bi)
 			 * replacement device.  We just fail those on
 			 * any error
 			 */
-			printk_ratelimited(
-				KERN_INFO
-				"md/raid:%s: read error corrected"
-				" (%lu sectors at %llu on %s)\n",
-				mdname(conf->mddev), STRIPE_SECTORS,
-				(unsigned long long)s,
-				bdevname(rdev->bdev, b));
+			pr_info_ratelimited("%s: read error corrected ("
+					    "%lu sectors at %llu on %s)\n",
+					    mdname(conf->mddev),
+					    STRIPE_SECTORS,
+					    (unsigned long long)s,
+					    bdevname(rdev->bdev, b));
 			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
@@ -2369,37 +2370,27 @@ static void raid5_end_read_request(struct bio * bi)
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
 		if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
-			printk_ratelimited(
-				KERN_WARNING
-				"md/raid:%s: read error on replacement device "
-				"(sector %llu on %s).\n",
-				mdname(conf->mddev),
-				(unsigned long long)s,
-				bdn);
+			pr_warn_ratelimited("%s: read error on replacement device (sector %llu on %s).\n",
+					    mdname(conf->mddev),
+					    (unsigned long long)s,
+					    bdn);
 		else if (conf->mddev->degraded >= conf->max_degraded) {
 			set_bad = 1;
-			printk_ratelimited(
-				KERN_WARNING
-				"md/raid:%s: read error not correctable "
-				"(sector %llu on %s).\n",
-				mdname(conf->mddev),
-				(unsigned long long)s,
-				bdn);
+			pr_warn_ratelimited("%s: read error not correctable (sector %llu on %s).\n",
+					    mdname(conf->mddev),
+					    (unsigned long long)s,
+					    bdn);
 		} else if (test_bit(R5_ReWrite, &sh->dev[i].flags)) {
 			/* Oh, no!!! */
 			set_bad = 1;
-			printk_ratelimited(
-				KERN_WARNING
-				"md/raid:%s: read error NOT corrected!! "
-				"(sector %llu on %s).\n",
-				mdname(conf->mddev),
-				(unsigned long long)s,
-				bdn);
+			pr_warn_ratelimited("%s: read error NOT corrected! (sector %llu on %s).\n",
+					    mdname(conf->mddev),
+					    (unsigned long long)s,
+					    bdn);
 		} else if (atomic_read(&rdev->read_errors)
 			 > conf->max_nr_stripes)
-			printk(KERN_WARNING
-			       "md/raid:%s: Too many read errors, failing device %s.\n",
-			       mdname(conf->mddev), bdn);
+			pr_warn("%s: Too many read errors, failing device %s.\n",
+				mdname(conf->mddev), bdn);
 		else
 			retry = 1;
 		if (set_bad && test_bit(In_sync, &rdev->flags)
@@ -2532,13 +2523,12 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(Faulty, &rdev->flags);
 	set_mask_bits(&mddev->flags, 0,
 		      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
-	printk(KERN_ALERT
-	       "md/raid:%s: Disk failure on %s, disabling device.\n"
-	       "md/raid:%s: Operation continuing on %d devices.\n",
-	       mdname(mddev),
-	       bdevname(rdev->bdev, b),
-	       mdname(mddev),
-	       conf->raid_disks - mddev->degraded);
+	pr_alert("%s: Disk failure on %s, disabling device.\n"
+		 MY_LOG_PREFIX "%s: Operation continuing on %d devices.\n",
+		 mdname(mddev),
+		 bdevname(rdev->bdev, b),
+		 mdname(mddev),
+		 conf->raid_disks - mddev->degraded);
 }
 
 /*
@@ -2860,7 +2850,7 @@ sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
 				     previous, &dummy1, &sh2);
 	if (check != sh->sector || dummy1 != dd_idx || sh2.pd_idx != sh->pd_idx
 		|| sh2.qd_idx != sh->qd_idx) {
-		printk(KERN_ERR "md/raid:%s: compute_blocknr: map not correct\n",
+		pr_err("%s: compute_blocknr: map not correct\n",
 		       mdname(conf->mddev));
 		return 0;
 	}
@@ -3781,7 +3771,7 @@ static void handle_parity_checks5(struct r5conf *conf, struct stripe_head *sh,
 	case check_state_compute_run:
 		break;
 	default:
-		printk(KERN_ERR "%s: unknown check_state: %d sector: %llu\n",
+		pr_err("%s: unknown check_state: %d sector: %llu\n",
 		       __func__, sh->check_state,
 		       (unsigned long long) sh->sector);
 		BUG();
@@ -3945,7 +3935,7 @@ static void handle_parity_checks6(struct r5conf *conf, struct stripe_head *sh,
 	case check_state_compute_run:
 		break;
 	default:
-		printk(KERN_ERR "%s: unknown check_state: %d sector: %llu\n",
+		pr_err("%s: unknown check_state: %d sector: %llu\n",
 		       __func__, sh->check_state,
 		       (unsigned long long) sh->sector);
 		BUG();
@@ -6456,7 +6446,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (mddev->new_level != 5
 	    && mddev->new_level != 4
 	    && mddev->new_level != 6) {
-		printk(KERN_ERR "md/raid:%s: raid level not set to 4/5/6 (%d)\n",
+		pr_err("%s: raid level not set to 4/5/6 (%d)\n",
 		       mdname(mddev), mddev->new_level);
 		return ERR_PTR(-EIO);
 	}
@@ -6464,12 +6454,12 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	     && !algorithm_valid_raid5(mddev->new_layout)) ||
 	    (mddev->new_level == 6
 	     && !algorithm_valid_raid6(mddev->new_layout))) {
-		printk(KERN_ERR "md/raid:%s: layout %d not supported\n",
+		pr_err("%s: layout %d not supported\n",
 		       mdname(mddev), mddev->new_layout);
 		return ERR_PTR(-EIO);
 	}
 	if (mddev->new_level == 6 && mddev->raid_disks < 4) {
-		printk(KERN_ERR "md/raid:%s: not enough configured devices (%d, minimum 4)\n",
+		pr_err("%s: not enough configured devices (%d, minimum 4)\n",
 		       mdname(mddev), mddev->raid_disks);
 		return ERR_PTR(-EINVAL);
 	}
@@ -6477,7 +6467,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (!mddev->new_chunk_sectors ||
 	    (mddev->new_chunk_sectors << 9) % PAGE_SIZE ||
 	    !is_power_of_2(mddev->new_chunk_sectors)) {
-		printk(KERN_ERR "md/raid:%s: invalid chunk size %d\n",
+		pr_err("%s: invalid chunk size %d\n",
 		       mdname(mddev), mddev->new_chunk_sectors << 9);
 		return ERR_PTR(-EINVAL);
 	}
@@ -6569,8 +6559,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 		if (test_bit(In_sync, &rdev->flags)) {
 			char b[BDEVNAME_SIZE];
-			printk(KERN_INFO "md/raid:%s: device %s operational as raid"
-			       " disk %d\n",
+			pr_info("%s: device %s operational as raid disk %d\n",
 			       mdname(mddev), bdevname(rdev->bdev, b), raid_disk);
 		} else if (rdev->saved_raid_disk != raid_disk)
 			/* Cannot rely on bitmap to complete recovery */
@@ -6605,8 +6594,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 			((mddev->new_chunk_sectors << 9) / STRIPE_SIZE) * 4);
 		conf->min_nr_stripes = max(NR_STRIPES, stripes);
 		if (conf->min_nr_stripes != NR_STRIPES)
-			printk(KERN_INFO
-				"md/raid:%s: force stripe size %d for reshape\n",
+			pr_info("%s: force stripe size %d for reshape\n",
 				mdname(mddev), conf->min_nr_stripes);
 	}
 	memory = conf->min_nr_stripes * (sizeof(struct stripe_head) +
@@ -6615,8 +6603,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (grow_stripes(conf, conf->min_nr_stripes))
 		goto free_conf;
 	else
-		printk(KERN_INFO "md/raid:%s: allocated %dkB\n",
-		       mdname(mddev), memory);
+		pr_info("%s: allocated %dkB\n", mdname(mddev), memory);
 	/*
 	 * Losing a stripe head costs more than the time to refill it,
 	 * it reduces the queue depth and so can hurt throughput.
@@ -6628,9 +6615,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	conf->shrinker.batch = 128;
 	conf->shrinker.flags = 0;
 	if (register_shrinker(&conf->shrinker)) {
-		printk(KERN_ERR
-		       "md/raid:%s: couldn't register shrinker.\n",
-		       mdname(mddev));
+		pr_err("%s: couldn't register shrinker.\n", mdname(mddev));
 		goto free_conf;
 	}
 
@@ -6684,9 +6669,8 @@ static int raid5_run(struct mddev *mddev)
 	int first = 1;
 
 	if (mddev->recovery_cp != MaxSector)
-		printk(KERN_NOTICE "md/raid:%s: not clean"
-		       " -- starting background reconstruction\n",
-		       mdname(mddev));
+		pr_notice("%s: not clean - starting background reconstruction\n",
+			  mdname(mddev));
 
 	rdev_for_each(rdev, mddev) {
 		long long diff;
@@ -6729,15 +6713,14 @@ static int raid5_run(struct mddev *mddev)
 		int new_data_disks;
 
 		if (journal_dev) {
-			printk(KERN_ERR "md/raid:%s: don't support reshape with journal - aborting.\n",
-			       mdname(mddev));
+			pr_err("%s: don't support reshape with journal%s",
+			       mdname(mddev), " - aborting.\n");
 			return -EINVAL;
 		}
 
 		if (mddev->new_level != mddev->level) {
-			printk(KERN_ERR "md/raid:%s: unsupported reshape "
-			       "required - aborting.\n",
-			       mdname(mddev));
+			pr_err("%s: unsupported reshape required%s",
+			       mdname(mddev), " - aborting.\n");
 			return -EINVAL;
 		}
 		old_disks = mddev->raid_disks - mddev->delta_disks;
@@ -6752,8 +6735,8 @@ static int raid5_run(struct mddev *mddev)
 		chunk_sectors = max(mddev->chunk_sectors, mddev->new_chunk_sectors);
 		new_data_disks = mddev->raid_disks - max_degraded;
 		if (sector_div(here_new, chunk_sectors * new_data_disks)) {
-			printk(KERN_ERR "md/raid:%s: reshape_position not "
-			       "on a stripe boundary\n", mdname(mddev));
+			pr_err("%s: reshape_position not on a stripe boundary\n",
+			       mdname(mddev));
 			return -EINVAL;
 		}
 		reshape_offset = here_new * chunk_sectors;
@@ -6774,10 +6757,8 @@ static int raid5_run(struct mddev *mddev)
 			    abs(min_offset_diff) >= mddev->new_chunk_sectors)
 				/* not really in-place - so OK */;
 			else if (mddev->ro == 0) {
-				printk(KERN_ERR "md/raid:%s: in-place reshape "
-				       "must be started in read-only mode "
-				       "- aborting\n",
-				       mdname(mddev));
+				pr_err("%s: in-place reshape must be started in read-only mode%s",
+				       mdname(mddev), " - aborting.\n");
 				return -EINVAL;
 			}
 		} else if (mddev->reshape_backwards
@@ -6786,13 +6767,11 @@ static int raid5_run(struct mddev *mddev)
 		    : (here_new * chunk_sectors >=
 		       here_old * chunk_sectors + (-min_offset_diff))) {
 			/* Reading from the same stripe as writing to - bad */
-			printk(KERN_ERR "md/raid:%s: reshape_position too early for "
-			       "auto-recovery - aborting.\n",
-			       mdname(mddev));
+			pr_err("%s: reshape_position too early for auto-recovery%s",
+			       mdname(mddev), " - aborting.\n");
 			return -EINVAL;
 		}
-		printk(KERN_INFO "md/raid:%s: reshape will continue\n",
-		       mdname(mddev));
+		pr_info("%s: reshape will continue\n", mdname(mddev));
 		/* OK, we should be able to continue; */
 	} else {
 		BUG_ON(mddev->level != mddev->new_level);
@@ -6811,7 +6790,7 @@ static int raid5_run(struct mddev *mddev)
 
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
 		if (!journal_dev) {
-			pr_err("md/raid:%s: journal disk is missing, force array readonly\n",
+			pr_err("%s: journal disk is missing, force array readonly\n",
 			       mdname(mddev));
 			mddev->ro = 1;
 			set_disk_ro(mddev->gendisk, 1);
@@ -6839,8 +6818,7 @@ static int raid5_run(struct mddev *mddev)
 		if (conf->disks[i].replacement &&
 		    conf->reshape_progress != MaxSector) {
 			/* replacements and reshape simply do not mix. */
-			printk(KERN_ERR "md: cannot handle concurrent "
-			       "replacement and reshape.\n");
+			pr_err("cannot handle concurrent replacement and reshape.\n");
 			goto abort;
 		}
 		if (test_bit(In_sync, &rdev->flags)) {
@@ -6882,9 +6860,8 @@ static int raid5_run(struct mddev *mddev)
 	mddev->degraded = calc_degraded(conf);
 
 	if (has_failed(conf)) {
-		printk(KERN_ERR "md/raid:%s: not enough operational devices"
-			" (%d/%d failed)\n",
-			mdname(mddev), mddev->degraded, conf->raid_disks);
+		pr_err("%s: not enough operational devices (%d/%d failed)\n",
+		       mdname(mddev), mddev->degraded, conf->raid_disks);
 		goto abort;
 	}
 
@@ -6894,30 +6871,30 @@ static int raid5_run(struct mddev *mddev)
 
 	if (mddev->degraded > dirty_parity_disks &&
 	    mddev->recovery_cp != MaxSector) {
-		if (mddev->ok_start_degraded)
-			printk(KERN_WARNING
-			       "md/raid:%s: starting dirty degraded array"
-			       " - data corruption possible.\n",
-			       mdname(mddev));
-		else {
-			printk(KERN_ERR
-			       "md/raid:%s: cannot start dirty degraded array.\n",
+		if (mddev->ok_start_degraded) {
+			pr_warn("%s: starting dirty degraded array - data corruption possible.\n",
+				mdname(mddev));
+		} else {
+			pr_err("%s: cannot start dirty degraded array.\n",
 			       mdname(mddev));
 			goto abort;
 		}
 	}
 
 	if (mddev->degraded == 0)
-		printk(KERN_INFO "md/raid:%s: raid level %d active with %d out of %d"
-		       " devices, algorithm %d\n", mdname(mddev), conf->level,
-		       mddev->raid_disks-mddev->degraded, mddev->raid_disks,
-		       mddev->new_layout);
+		pr_info("%s: raid level %d active with %d out of %d devices, algorithm %d\n",
+			mdname(mddev),
+			conf->level,
+			mddev->raid_disks-mddev->degraded,
+			mddev->raid_disks,
+			mddev->new_layout);
 	else
-		printk(KERN_ALERT "md/raid:%s: raid level %d active with %d"
-		       " out of %d devices, algorithm %d\n",
-		       mdname(mddev), conf->level,
-		       mddev->raid_disks - mddev->degraded,
-		       mddev->raid_disks, mddev->new_layout);
+		pr_alert("%s: raid level %d active with %d out of %d devices, algorithm %d\n",
+			 mdname(mddev),
+			 conf->level,
+			 mddev->raid_disks - mddev->degraded,
+			 mddev->raid_disks,
+			 mddev->new_layout);
 
 	print_raid5_conf(conf);
 
@@ -6937,9 +6914,8 @@ static int raid5_run(struct mddev *mddev)
 		mddev->to_remove = NULL;
 	else if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
-		printk(KERN_WARNING
-		       "raid5: failed to create sysfs attributes for %s\n",
-		       mdname(mddev));
+		pr_warn("failed to create sysfs attributes for %s\n",
+			mdname(mddev));
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
 	if (mddev->queue) {
@@ -7027,8 +7003,8 @@ static int raid5_run(struct mddev *mddev)
 	if (journal_dev) {
 		char b[BDEVNAME_SIZE];
 
-		printk(KERN_INFO"md/raid:%s: using device %s as journal\n",
-		       mdname(mddev), bdevname(journal_dev->bdev, b));
+		pr_info("%s: using device %s as journal\n",
+			mdname(mddev), bdevname(journal_dev->bdev, b));
 		r5l_init_log(conf, journal_dev);
 	}
 
@@ -7038,7 +7014,7 @@ static int raid5_run(struct mddev *mddev)
 	print_raid5_conf(conf);
 	free_conf(conf);
 	mddev->private = NULL;
-	printk(KERN_ALERT "md/raid:%s: failed to run raid set.\n", mdname(mddev));
+	pr_alert("%s: failed to run raid set.\n", mdname(mddev));
 	return -EIO;
 }
 
@@ -7072,22 +7048,23 @@ static void print_raid5_conf (struct r5conf *conf)
 	int i;
 	struct disk_info *tmp;
 
-	printk(KERN_DEBUG "RAID conf printout:\n");
+	pr_debug("conf printout:\n");
 	if (!conf) {
-		printk("(conf==NULL)\n");
+		pr_debug("(conf==NULL)\n");
 		return;
 	}
-	printk(KERN_DEBUG " --- level:%d rd:%d wd:%d\n", conf->level,
-	       conf->raid_disks,
-	       conf->raid_disks - conf->mddev->degraded);
+	pr_debug("--- level:%d rd:%d wd:%d\n",
+		 conf->level,
+		 conf->raid_disks,
+		 conf->raid_disks - conf->mddev->degraded);
 
 	for (i = 0; i < conf->raid_disks; i++) {
 		char b[BDEVNAME_SIZE];
 		tmp = conf->disks + i;
 		if (tmp->rdev)
-			printk(KERN_DEBUG " disk %d, o:%d, dev:%s\n",
-			       i, !test_bit(Faulty, &tmp->rdev->flags),
-			       bdevname(tmp->rdev->bdev, b));
+			pr_debug("disk %d, o:%d, dev:%s\n",
+				 i, !test_bit(Faulty, &tmp->rdev->flags),
+				 bdevname(tmp->rdev->bdev, b));
 	}
 }
 
@@ -7233,8 +7210,8 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * write requests running. We should be safe
 		 */
 		r5l_init_log(conf, rdev);
-		printk(KERN_INFO"md/raid:%s: using device %s as journal\n",
-		       mdname(mddev), bdevname(rdev->bdev, b));
+		pr_info("%s: using device %s as journal\n",
+			mdname(mddev), bdevname(rdev->bdev, b));
 		return 0;
 	}
 	if (mddev->recovery_disabled == conf->recovery_disabled)
@@ -7338,9 +7315,9 @@ static int check_stripe_cache(struct mddev *mddev)
 	    > conf->min_nr_stripes ||
 	    ((mddev->new_chunk_sectors << 9) / STRIPE_SIZE) * 4
 	    > conf->min_nr_stripes) {
-		printk(KERN_WARNING "md/raid:%s: reshape: not enough stripes.  Needed %lu\n",
-		       mdname(mddev),
-		       ((max(mddev->chunk_sectors, mddev->new_chunk_sectors) << 9)
+		pr_warn("%s: reshape: not enough stripes.  Needed %lu\n",
+			mdname(mddev),
+			((max(mddev->chunk_sectors, mddev->new_chunk_sectors) << 9)
 			/ STRIPE_SIZE)*4);
 		return 0;
 	}
@@ -7422,8 +7399,8 @@ static int raid5_start_reshape(struct mddev *mddev)
 	 */
 	if (raid5_size(mddev, 0, conf->raid_disks + mddev->delta_disks)
 	    < mddev->array_sectors) {
-		printk(KERN_ERR "md/raid:%s: array size must be reduced "
-		       "before number of disks\n", mdname(mddev));
+		pr_err("%s: array size must be reduced before number of disks\n",
+		       mdname(mddev));
 		return -EINVAL;
 	}
 
@@ -7641,7 +7618,7 @@ static void *raid45_takeover_raid0(struct mddev *mddev, int level)
 
 	/* for raid0 takeover only one zone is supported */
 	if (raid0_conf->nr_strip_zones > 1) {
-		printk(KERN_ERR "md/raid:%s: cannot takeover raid0 with more than one zone.\n",
+		pr_err("%s: cannot takeover raid0 with more than one zone.\n",
 		       mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
-- 
2.10.1
