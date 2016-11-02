From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 9/9] md/raid5: change printk() to pr_*()
Date: Wed, 02 Nov 2016 14:16:50 +1100
Message-ID: <147805661046.23566.539086854053981531.stgit@noble>
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
 drivers/md/raid5.c |  207 ++++++++++++++++++++++------------------------------
 1 file changed, 86 insertions(+), 121 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 92ac251e91e6..57cee47c116a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -541,7 +541,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 
 		if (dev->toread || dev->read || dev->towrite || dev->written ||
 		    test_bit(R5_LOCKED, &dev->flags)) {
-			printk(KERN_ERR "sector=%llx i=%d %p %p %p %p %d\n",
+			pr_err("sector=%llx i=%d %p %p %p %p %d\n",
 			       (unsigned long long)sh->sector, i, dev->toread,
 			       dev->read, dev->towrite, dev->written,
 			       test_bit(R5_LOCKED, &dev->flags));
@@ -2347,10 +2347,8 @@ static void raid5_end_read_request(struct bio * bi)
 			 * replacement device.  We just fail those on
 			 * any error
 			 */
-			printk_ratelimited(
-				KERN_INFO
-				"md/raid:%s: read error corrected"
-				" (%lu sectors at %llu on %s)\n",
+			pr_info_ratelimited(
+				"md/raid:%s: read error corrected (%lu sectors at %llu on %s)\n",
 				mdname(conf->mddev), STRIPE_SECTORS,
 				(unsigned long long)s,
 				bdevname(rdev->bdev, b));
@@ -2370,36 +2368,29 @@ static void raid5_end_read_request(struct bio * bi)
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
 		if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
-			printk_ratelimited(
-				KERN_WARNING
-				"md/raid:%s: read error on replacement device "
-				"(sector %llu on %s).\n",
+			pr_warn_ratelimited(
+				"md/raid:%s: read error on replacement device (sector %llu on %s).\n",
 				mdname(conf->mddev),
 				(unsigned long long)s,
 				bdn);
 		else if (conf->mddev->degraded >= conf->max_degraded) {
 			set_bad = 1;
-			printk_ratelimited(
-				KERN_WARNING
-				"md/raid:%s: read error not correctable "
-				"(sector %llu on %s).\n",
+			pr_warn_ratelimited(
+				"md/raid:%s: read error not correctable (sector %llu on %s).\n",
 				mdname(conf->mddev),
 				(unsigned long long)s,
 				bdn);
 		} else if (test_bit(R5_ReWrite, &sh->dev[i].flags)) {
 			/* Oh, no!!! */
 			set_bad = 1;
-			printk_ratelimited(
-				KERN_WARNING
-				"md/raid:%s: read error NOT corrected!! "
-				"(sector %llu on %s).\n",
+			pr_warn_ratelimited(
+				"md/raid:%s: read error NOT corrected!! (sector %llu on %s).\n",
 				mdname(conf->mddev),
 				(unsigned long long)s,
 				bdn);
 		} else if (atomic_read(&rdev->read_errors)
 			 > conf->max_nr_stripes)
-			printk(KERN_WARNING
-			       "md/raid:%s: Too many read errors, failing device %s.\n",
+			pr_warn("md/raid:%s: Too many read errors, failing device %s.\n",
 			       mdname(conf->mddev), bdn);
 		else
 			retry = 1;
@@ -2533,13 +2524,12 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
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
+	pr_crit("md/raid:%s: Disk failure on %s, disabling device.\n"
+		"md/raid:%s: Operation continuing on %d devices.\n",
+		mdname(mddev),
+		bdevname(rdev->bdev, b),
+		mdname(mddev),
+		conf->raid_disks - mddev->degraded);
 }
 
 /*
@@ -2861,8 +2851,8 @@ sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
 				     previous, &dummy1, &sh2);
 	if (check != sh->sector || dummy1 != dd_idx || sh2.pd_idx != sh->pd_idx
 		|| sh2.qd_idx != sh->qd_idx) {
-		printk(KERN_ERR "md/raid:%s: compute_blocknr: map not correct\n",
-		       mdname(conf->mddev));
+		pr_warn("md/raid:%s: compute_blocknr: map not correct\n",
+			mdname(conf->mddev));
 		return 0;
 	}
 	return r_sector;
@@ -3782,7 +3772,7 @@ static void handle_parity_checks5(struct r5conf *conf, struct stripe_head *sh,
 	case check_state_compute_run:
 		break;
 	default:
-		printk(KERN_ERR "%s: unknown check_state: %d sector: %llu\n",
+		pr_err("%s: unknown check_state: %d sector: %llu\n",
 		       __func__, sh->check_state,
 		       (unsigned long long) sh->sector);
 		BUG();
@@ -3946,9 +3936,9 @@ static void handle_parity_checks6(struct r5conf *conf, struct stripe_head *sh,
 	case check_state_compute_run:
 		break;
 	default:
-		printk(KERN_ERR "%s: unknown check_state: %d sector: %llu\n",
-		       __func__, sh->check_state,
-		       (unsigned long long) sh->sector);
+		pr_warn("%s: unknown check_state: %d sector: %llu\n",
+			__func__, sh->check_state,
+			(unsigned long long) sh->sector);
 		BUG();
 	}
 }
@@ -6387,8 +6377,8 @@ static int raid456_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
 	struct raid5_percpu *percpu = per_cpu_ptr(conf->percpu, cpu);
 
 	if (alloc_scratch_buffer(conf, percpu)) {
-		pr_err("%s: failed memory allocation for cpu%u\n",
-		       __func__, cpu);
+		pr_warn("%s: failed memory allocation for cpu%u\n",
+			__func__, cpu);
 		return -ENOMEM;
 	}
 	return 0;
@@ -6458,29 +6448,29 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (mddev->new_level != 5
 	    && mddev->new_level != 4
 	    && mddev->new_level != 6) {
-		printk(KERN_ERR "md/raid:%s: raid level not set to 4/5/6 (%d)\n",
-		       mdname(mddev), mddev->new_level);
+		pr_warn("md/raid:%s: raid level not set to 4/5/6 (%d)\n",
+			mdname(mddev), mddev->new_level);
 		return ERR_PTR(-EIO);
 	}
 	if ((mddev->new_level == 5
 	     && !algorithm_valid_raid5(mddev->new_layout)) ||
 	    (mddev->new_level == 6
 	     && !algorithm_valid_raid6(mddev->new_layout))) {
-		printk(KERN_ERR "md/raid:%s: layout %d not supported\n",
-		       mdname(mddev), mddev->new_layout);
+		pr_warn("md/raid:%s: layout %d not supported\n",
+			mdname(mddev), mddev->new_layout);
 		return ERR_PTR(-EIO);
 	}
 	if (mddev->new_level == 6 && mddev->raid_disks < 4) {
-		printk(KERN_ERR "md/raid:%s: not enough configured devices (%d, minimum 4)\n",
-		       mdname(mddev), mddev->raid_disks);
+		pr_warn("md/raid:%s: not enough configured devices (%d, minimum 4)\n",
+			mdname(mddev), mddev->raid_disks);
 		return ERR_PTR(-EINVAL);
 	}
 
 	if (!mddev->new_chunk_sectors ||
 	    (mddev->new_chunk_sectors << 9) % PAGE_SIZE ||
 	    !is_power_of_2(mddev->new_chunk_sectors)) {
-		printk(KERN_ERR "md/raid:%s: invalid chunk size %d\n",
-		       mdname(mddev), mddev->new_chunk_sectors << 9);
+		pr_warn("md/raid:%s: invalid chunk size %d\n",
+			mdname(mddev), mddev->new_chunk_sectors << 9);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -6571,9 +6561,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 		if (test_bit(In_sync, &rdev->flags)) {
 			char b[BDEVNAME_SIZE];
-			printk(KERN_INFO "md/raid:%s: device %s operational as raid"
-			       " disk %d\n",
-			       mdname(mddev), bdevname(rdev->bdev, b), raid_disk);
+			pr_info("md/raid:%s: device %s operational as raid disk %d\n",
+				mdname(mddev), bdevname(rdev->bdev, b), raid_disk);
 		} else if (rdev->saved_raid_disk != raid_disk)
 			/* Cannot rely on bitmap to complete recovery */
 			conf->fullsync = 1;
@@ -6607,21 +6596,18 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 			((mddev->new_chunk_sectors << 9) / STRIPE_SIZE) * 4);
 		conf->min_nr_stripes = max(NR_STRIPES, stripes);
 		if (conf->min_nr_stripes != NR_STRIPES)
-			printk(KERN_INFO
-				"md/raid:%s: force stripe size %d for reshape\n",
+			pr_info("md/raid:%s: force stripe size %d for reshape\n",
 				mdname(mddev), conf->min_nr_stripes);
 	}
 	memory = conf->min_nr_stripes * (sizeof(struct stripe_head) +
 		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
 	atomic_set(&conf->empty_inactive_list_nr, NR_STRIPE_HASH_LOCKS);
 	if (grow_stripes(conf, conf->min_nr_stripes)) {
-		printk(KERN_ERR
-		       "md/raid:%s: couldn't allocate %dkB for buffers\n",
-		       mdname(mddev), memory);
+		pr_warn("md/raid:%s: couldn't allocate %dkB for buffers\n",
+			mdname(mddev), memory);
 		goto abort;
 	} else
-		printk(KERN_INFO "md/raid:%s: allocated %dkB\n",
-		       mdname(mddev), memory);
+		pr_debug("md/raid:%s: allocated %dkB\n", mdname(mddev), memory);
 	/*
 	 * Losing a stripe head costs more than the time to refill it,
 	 * it reduces the queue depth and so can hurt throughput.
@@ -6633,18 +6619,16 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	conf->shrinker.batch = 128;
 	conf->shrinker.flags = 0;
 	if (register_shrinker(&conf->shrinker)) {
-		printk(KERN_ERR
-		       "md/raid:%s: couldn't register shrinker.\n",
-		       mdname(mddev));
+		pr_warn("md/raid:%s: couldn't register shrinker.\n",
+			mdname(mddev));
 		goto abort;
 	}
 
 	sprintf(pers_name, "raid%d", mddev->new_level);
 	conf->thread = md_register_thread(raid5d, mddev, pers_name);
 	if (!conf->thread) {
-		printk(KERN_ERR
-		       "md/raid:%s: couldn't allocate thread.\n",
-		       mdname(mddev));
+		pr_warn("md/raid:%s: couldn't allocate thread.\n",
+			mdname(mddev));
 		goto abort;
 	}
 
@@ -6697,9 +6681,8 @@ static int raid5_run(struct mddev *mddev)
 	int first = 1;
 
 	if (mddev->recovery_cp != MaxSector)
-		printk(KERN_NOTICE "md/raid:%s: not clean"
-		       " -- starting background reconstruction\n",
-		       mdname(mddev));
+		pr_notice("md/raid:%s: not clean -- starting background reconstruction\n",
+			  mdname(mddev));
 
 	rdev_for_each(rdev, mddev) {
 		long long diff;
@@ -6742,15 +6725,14 @@ static int raid5_run(struct mddev *mddev)
 		int new_data_disks;
 
 		if (journal_dev) {
-			printk(KERN_ERR "md/raid:%s: don't support reshape with journal - aborting.\n",
-			       mdname(mddev));
+			pr_warn("md/raid:%s: don't support reshape with journal - aborting.\n",
+				mdname(mddev));
 			return -EINVAL;
 		}
 
 		if (mddev->new_level != mddev->level) {
-			printk(KERN_ERR "md/raid:%s: unsupported reshape "
-			       "required - aborting.\n",
-			       mdname(mddev));
+			pr_warn("md/raid:%s: unsupported reshape required - aborting.\n",
+				mdname(mddev));
 			return -EINVAL;
 		}
 		old_disks = mddev->raid_disks - mddev->delta_disks;
@@ -6765,8 +6747,8 @@ static int raid5_run(struct mddev *mddev)
 		chunk_sectors = max(mddev->chunk_sectors, mddev->new_chunk_sectors);
 		new_data_disks = mddev->raid_disks - max_degraded;
 		if (sector_div(here_new, chunk_sectors * new_data_disks)) {
-			printk(KERN_ERR "md/raid:%s: reshape_position not "
-			       "on a stripe boundary\n", mdname(mddev));
+			pr_warn("md/raid:%s: reshape_position not on a stripe boundary\n",
+				mdname(mddev));
 			return -EINVAL;
 		}
 		reshape_offset = here_new * chunk_sectors;
@@ -6787,10 +6769,8 @@ static int raid5_run(struct mddev *mddev)
 			    abs(min_offset_diff) >= mddev->new_chunk_sectors)
 				/* not really in-place - so OK */;
 			else if (mddev->ro == 0) {
-				printk(KERN_ERR "md/raid:%s: in-place reshape "
-				       "must be started in read-only mode "
-				       "- aborting\n",
-				       mdname(mddev));
+				pr_warn("md/raid:%s: in-place reshape must be started in read-only mode - aborting\n",
+					mdname(mddev));
 				return -EINVAL;
 			}
 		} else if (mddev->reshape_backwards
@@ -6799,13 +6779,11 @@ static int raid5_run(struct mddev *mddev)
 		    : (here_new * chunk_sectors >=
 		       here_old * chunk_sectors + (-min_offset_diff))) {
 			/* Reading from the same stripe as writing to - bad */
-			printk(KERN_ERR "md/raid:%s: reshape_position too early for "
-			       "auto-recovery - aborting.\n",
-			       mdname(mddev));
+			pr_warn("md/raid:%s: reshape_position too early for auto-recovery - aborting.\n",
+				mdname(mddev));
 			return -EINVAL;
 		}
-		printk(KERN_INFO "md/raid:%s: reshape will continue\n",
-		       mdname(mddev));
+		pr_debug("md/raid:%s: reshape will continue\n", mdname(mddev));
 		/* OK, we should be able to continue; */
 	} else {
 		BUG_ON(mddev->level != mddev->new_level);
@@ -6824,8 +6802,8 @@ static int raid5_run(struct mddev *mddev)
 
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
 		if (!journal_dev) {
-			pr_err("md/raid:%s: journal disk is missing, force array readonly\n",
-			       mdname(mddev));
+			pr_warn("md/raid:%s: journal disk is missing, force array readonly\n",
+				mdname(mddev));
 			mddev->ro = 1;
 			set_disk_ro(mddev->gendisk, 1);
 		} else if (mddev->recovery_cp == MaxSector)
@@ -6852,8 +6830,7 @@ static int raid5_run(struct mddev *mddev)
 		if (conf->disks[i].replacement &&
 		    conf->reshape_progress != MaxSector) {
 			/* replacements and reshape simply do not mix. */
-			printk(KERN_ERR "md: cannot handle concurrent "
-			       "replacement and reshape.\n");
+			pr_warn("md: cannot handle concurrent replacement and reshape.\n");
 			goto abort;
 		}
 		if (test_bit(In_sync, &rdev->flags)) {
@@ -6895,8 +6872,7 @@ static int raid5_run(struct mddev *mddev)
 	mddev->degraded = calc_degraded(conf);
 
 	if (has_failed(conf)) {
-		printk(KERN_ERR "md/raid:%s: not enough operational devices"
-			" (%d/%d failed)\n",
+		pr_crit("md/raid:%s: not enough operational devices (%d/%d failed)\n",
 			mdname(mddev), mddev->degraded, conf->raid_disks);
 		goto abort;
 	}
@@ -6908,29 +6884,19 @@ static int raid5_run(struct mddev *mddev)
 	if (mddev->degraded > dirty_parity_disks &&
 	    mddev->recovery_cp != MaxSector) {
 		if (mddev->ok_start_degraded)
-			printk(KERN_WARNING
-			       "md/raid:%s: starting dirty degraded array"
-			       " - data corruption possible.\n",
-			       mdname(mddev));
+			pr_crit("md/raid:%s: starting dirty degraded array - data corruption possible.\n",
+				mdname(mddev));
 		else {
-			printk(KERN_ERR
-			       "md/raid:%s: cannot start dirty degraded array.\n",
-			       mdname(mddev));
+			pr_crit("md/raid:%s: cannot start dirty degraded array.\n",
+				mdname(mddev));
 			goto abort;
 		}
 	}
 
-	if (mddev->degraded == 0)
-		printk(KERN_INFO "md/raid:%s: raid level %d active with %d out of %d"
-		       " devices, algorithm %d\n", mdname(mddev), conf->level,
-		       mddev->raid_disks-mddev->degraded, mddev->raid_disks,
-		       mddev->new_layout);
-	else
-		printk(KERN_ALERT "md/raid:%s: raid level %d active with %d"
-		       " out of %d devices, algorithm %d\n",
-		       mdname(mddev), conf->level,
-		       mddev->raid_disks - mddev->degraded,
-		       mddev->raid_disks, mddev->new_layout);
+	pr_info("md/raid:%s: raid level %d active with %d out of %d devices, algorithm %d\n",
+		mdname(mddev), conf->level,
+		mddev->raid_disks-mddev->degraded, mddev->raid_disks,
+		mddev->new_layout);
 
 	print_raid5_conf(conf);
 
@@ -6950,9 +6916,8 @@ static int raid5_run(struct mddev *mddev)
 		mddev->to_remove = NULL;
 	else if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
-		printk(KERN_WARNING
-		       "raid5: failed to create sysfs attributes for %s\n",
-		       mdname(mddev));
+		pr_warn("raid5: failed to create sysfs attributes for %s\n",
+			mdname(mddev));
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
 	if (mddev->queue) {
@@ -7040,8 +7005,8 @@ static int raid5_run(struct mddev *mddev)
 	if (journal_dev) {
 		char b[BDEVNAME_SIZE];
 
-		printk(KERN_INFO"md/raid:%s: using device %s as journal\n",
-		       mdname(mddev), bdevname(journal_dev->bdev, b));
+		pr_debug("md/raid:%s: using device %s as journal\n",
+			 mdname(mddev), bdevname(journal_dev->bdev, b));
 		r5l_init_log(conf, journal_dev);
 	}
 
@@ -7051,7 +7016,7 @@ static int raid5_run(struct mddev *mddev)
 	print_raid5_conf(conf);
 	free_conf(conf);
 	mddev->private = NULL;
-	printk(KERN_ALERT "md/raid:%s: failed to run raid set.\n", mdname(mddev));
+	pr_warn("md/raid:%s: failed to run raid set.\n", mdname(mddev));
 	return -EIO;
 }
 
@@ -7085,12 +7050,12 @@ static void print_raid5_conf (struct r5conf *conf)
 	int i;
 	struct disk_info *tmp;
 
-	printk(KERN_DEBUG "RAID conf printout:\n");
+	pr_debug("RAID conf printout:\n");
 	if (!conf) {
-		printk("(conf==NULL)\n");
+		pr_debug("(conf==NULL)\n");
 		return;
 	}
-	printk(KERN_DEBUG " --- level:%d rd:%d wd:%d\n", conf->level,
+	pr_debug(" --- level:%d rd:%d wd:%d\n", conf->level,
 	       conf->raid_disks,
 	       conf->raid_disks - conf->mddev->degraded);
 
@@ -7098,7 +7063,7 @@ static void print_raid5_conf (struct r5conf *conf)
 		char b[BDEVNAME_SIZE];
 		tmp = conf->disks + i;
 		if (tmp->rdev)
-			printk(KERN_DEBUG " disk %d, o:%d, dev:%s\n",
+			pr_debug(" disk %d, o:%d, dev:%s\n",
 			       i, !test_bit(Faulty, &tmp->rdev->flags),
 			       bdevname(tmp->rdev->bdev, b));
 	}
@@ -7246,8 +7211,8 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * write requests running. We should be safe
 		 */
 		r5l_init_log(conf, rdev);
-		printk(KERN_INFO"md/raid:%s: using device %s as journal\n",
-		       mdname(mddev), bdevname(rdev->bdev, b));
+		pr_debug("md/raid:%s: using device %s as journal\n",
+			 mdname(mddev), bdevname(rdev->bdev, b));
 		return 0;
 	}
 	if (mddev->recovery_disabled == conf->recovery_disabled)
@@ -7351,10 +7316,10 @@ static int check_stripe_cache(struct mddev *mddev)
 	    > conf->min_nr_stripes ||
 	    ((mddev->new_chunk_sectors << 9) / STRIPE_SIZE) * 4
 	    > conf->min_nr_stripes) {
-		printk(KERN_WARNING "md/raid:%s: reshape: not enough stripes.  Needed %lu\n",
-		       mdname(mddev),
-		       ((max(mddev->chunk_sectors, mddev->new_chunk_sectors) << 9)
-			/ STRIPE_SIZE)*4);
+		pr_warn("md/raid:%s: reshape: not enough stripes.  Needed %lu\n",
+			mdname(mddev),
+			((max(mddev->chunk_sectors, mddev->new_chunk_sectors) << 9)
+			 / STRIPE_SIZE)*4);
 		return 0;
 	}
 	return 1;
@@ -7435,8 +7400,8 @@ static int raid5_start_reshape(struct mddev *mddev)
 	 */
 	if (raid5_size(mddev, 0, conf->raid_disks + mddev->delta_disks)
 	    < mddev->array_sectors) {
-		printk(KERN_ERR "md/raid:%s: array size must be reduced "
-		       "before number of disks\n", mdname(mddev));
+		pr_warn("md/raid:%s: array size must be reduced before number of disks\n",
+			mdname(mddev));
 		return -EINVAL;
 	}
 
@@ -7654,8 +7619,8 @@ static void *raid45_takeover_raid0(struct mddev *mddev, int level)
 
 	/* for raid0 takeover only one zone is supported */
 	if (raid0_conf->nr_strip_zones > 1) {
-		printk(KERN_ERR "md/raid:%s: cannot takeover raid0 with more than one zone.\n",
-		       mdname(mddev));
+		pr_warn("md/raid:%s: cannot takeover raid0 with more than one zone.\n",
+			mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
 


