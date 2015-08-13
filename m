From: Shaohua Li <shli@fb.com>
Subject: [patch v2 04/11] raid5: export some functions
Date: Thu, 13 Aug 2015 14:31:57 -0700
Message-ID: <052a95c04dab447199683dcc5ac0259a0cf25d4c.1439500639.git.shli@fb.com>
References: <cover.1439500639.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1439500639.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Next several patches use some raid5 functions, rename them with raid5
prefix and export out.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 94 ++++++++++++++++++++++++++----------------------------
 drivers/md/raid5.h |  8 +++++
 2 files changed, 54 insertions(+), 48 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f757023..786f811 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -357,7 +357,7 @@ static void release_inactive_stripe_list(struct r5conf *conf,
 		struct list_head *list = &temp_inactive_list[size - 1];
 
 		/*
-		 * We don't hold any lock here yet, get_active_stripe() might
+		 * We don't hold any lock here yet, raid5_get_active_stripe() might
 		 * remove stripes from the list
 		 */
 		if (!list_empty_careful(list)) {
@@ -417,7 +417,7 @@ static int release_stripe_list(struct r5conf *conf,
 	return count;
 }
 
-static void release_stripe(struct stripe_head *sh)
+void raid5_release_stripe(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 	unsigned long flags;
@@ -662,8 +662,8 @@ static int has_failed(struct r5conf *conf)
 	return 0;
 }
 
-static struct stripe_head *
-get_active_stripe(struct r5conf *conf, sector_t sector,
+struct stripe_head *
+raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 		  int previous, int noblock, int noquiesce)
 {
 	struct stripe_head *sh;
@@ -862,7 +862,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 unlock_out:
 	unlock_two_stripes(head, sh);
 out:
-	release_stripe(head);
+	raid5_release_stripe(head);
 }
 
 /* Determine if 'data_offset' or 'new_data_offset' should be used
@@ -1214,7 +1214,7 @@ static void ops_complete_biofill(void *stripe_head_ref)
 	return_io(return_bi);
 
 	set_bit(STRIPE_HANDLE, &sh->state);
-	release_stripe(sh);
+	raid5_release_stripe(sh);
 }
 
 static void ops_run_biofill(struct stripe_head *sh)
@@ -1277,7 +1277,7 @@ static void ops_complete_compute(void *stripe_head_ref)
 	if (sh->check_state == check_state_compute_run)
 		sh->check_state = check_state_compute_result;
 	set_bit(STRIPE_HANDLE, &sh->state);
-	release_stripe(sh);
+	raid5_release_stripe(sh);
 }
 
 /* return a pointer to the address conversion region of the scribble buffer */
@@ -1703,7 +1703,7 @@ static void ops_complete_reconstruct(void *stripe_head_ref)
 	}
 
 	set_bit(STRIPE_HANDLE, &sh->state);
-	release_stripe(sh);
+	raid5_release_stripe(sh);
 }
 
 static void
@@ -1861,7 +1861,7 @@ static void ops_complete_check(void *stripe_head_ref)
 
 	sh->check_state = check_state_check_result;
 	set_bit(STRIPE_HANDLE, &sh->state);
-	release_stripe(sh);
+	raid5_release_stripe(sh);
 }
 
 static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
@@ -2023,7 +2023,7 @@ static int grow_one_stripe(struct r5conf *conf, gfp_t gfp)
 	/* we just created an active stripe so... */
 	atomic_inc(&conf->active_stripes);
 
-	release_stripe(sh);
+	raid5_release_stripe(sh);
 	conf->max_nr_stripes++;
 	return 1;
 }
@@ -2242,7 +2242,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 				if (!p)
 					err = -ENOMEM;
 			}
-		release_stripe(nsh);
+		raid5_release_stripe(nsh);
 	}
 	/* critical section pass, GFP_NOIO no longer needed */
 
@@ -2402,7 +2402,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 	rdev_dec_pending(rdev, conf->mddev);
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
-	release_stripe(sh);
+	raid5_release_stripe(sh);
 }
 
 static void raid5_end_write_request(struct bio *bi, int error)
@@ -2477,14 +2477,12 @@ static void raid5_end_write_request(struct bio *bi, int error)
 	if (!test_and_clear_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags))
 		clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
-	release_stripe(sh);
+	raid5_release_stripe(sh);
 
 	if (sh->batch_head && sh != sh->batch_head)
-		release_stripe(sh->batch_head);
+		raid5_release_stripe(sh->batch_head);
 }
 
-static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous);
-
 static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 {
 	struct r5dev *dev = &sh->dev[i];
@@ -2500,7 +2498,7 @@ static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 	dev->rreq.bi_private = sh;
 
 	dev->flags = 0;
-	dev->sector = compute_blocknr(sh, i, previous);
+	dev->sector = raid5_compute_blocknr(sh, i, previous);
 }
 
 static void error(struct mddev *mddev, struct md_rdev *rdev)
@@ -2532,7 +2530,7 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
  * Input: a 'big' sector number,
  * Output: index of the data and parity disk, and the sector # in them.
  */
-static sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
+sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
 				     int previous, int *dd_idx,
 				     struct stripe_head *sh)
 {
@@ -2734,7 +2732,7 @@ static sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
 	return new_sector;
 }
 
-static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
+sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
 {
 	struct r5conf *conf = sh->raid_conf;
 	int raid_disks = sh->disks;
@@ -3943,10 +3941,10 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 			struct stripe_head *sh2;
 			struct async_submit_ctl submit;
 
-			sector_t bn = compute_blocknr(sh, i, 1);
+			sector_t bn = raid5_compute_blocknr(sh, i, 1);
 			sector_t s = raid5_compute_sector(conf, bn, 0,
 							  &dd_idx, NULL);
-			sh2 = get_active_stripe(conf, s, 0, 1, 1);
+			sh2 = raid5_get_active_stripe(conf, s, 0, 1, 1);
 			if (sh2 == NULL)
 				/* so far only the early blocks of this stripe
 				 * have been requested.  When later blocks
@@ -3956,7 +3954,7 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 			if (!test_bit(STRIPE_EXPANDING, &sh2->state) ||
 			   test_bit(R5_Expanded, &sh2->dev[dd_idx].flags)) {
 				/* must have already done this block */
-				release_stripe(sh2);
+				raid5_release_stripe(sh2);
 				continue;
 			}
 
@@ -3977,7 +3975,7 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 				set_bit(STRIPE_EXPAND_READY, &sh2->state);
 				set_bit(STRIPE_HANDLE, &sh2->state);
 			}
-			release_stripe(sh2);
+			raid5_release_stripe(sh2);
 
 		}
 	/* done submitting copies, wait for them to complete */
@@ -4263,7 +4261,7 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 		if (handle_flags == 0 ||
 		    sh->state & handle_flags)
 			set_bit(STRIPE_HANDLE, &sh->state);
-		release_stripe(sh);
+		raid5_release_stripe(sh);
 	}
 	spin_lock_irq(&head_sh->stripe_lock);
 	head_sh->batch_head = NULL;
@@ -4510,7 +4508,7 @@ static void handle_stripe(struct stripe_head *sh)
 	/* Finish reconstruct operations initiated by the expansion process */
 	if (sh->reconstruct_state == reconstruct_state_result) {
 		struct stripe_head *sh_src
-			= get_active_stripe(conf, sh->sector, 1, 1, 1);
+			= raid5_get_active_stripe(conf, sh->sector, 1, 1, 1);
 		if (sh_src && test_bit(STRIPE_EXPAND_SOURCE, &sh_src->state)) {
 			/* sh cannot be written until sh_src has been read.
 			 * so arrange for sh to be delayed a little
@@ -4520,11 +4518,11 @@ static void handle_stripe(struct stripe_head *sh)
 			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE,
 					      &sh_src->state))
 				atomic_inc(&conf->preread_active_stripes);
-			release_stripe(sh_src);
+			raid5_release_stripe(sh_src);
 			goto finish;
 		}
 		if (sh_src)
-			release_stripe(sh_src);
+			raid5_release_stripe(sh_src);
 
 		sh->reconstruct_state = reconstruct_state_idle;
 		clear_bit(STRIPE_EXPANDING, &sh->state);
@@ -5033,7 +5031,7 @@ static void release_stripe_plug(struct mddev *mddev,
 	struct raid5_plug_cb *cb;
 
 	if (!blk_cb) {
-		release_stripe(sh);
+		raid5_release_stripe(sh);
 		return;
 	}
 
@@ -5049,7 +5047,7 @@ static void release_stripe_plug(struct mddev *mddev,
 	if (!test_and_set_bit(STRIPE_ON_UNPLUG_LIST, &sh->state))
 		list_add_tail(&sh->lru, &cb->list);
 	else
-		release_stripe(sh);
+		raid5_release_stripe(sh);
 }
 
 static void make_discard_request(struct mddev *mddev, struct bio *bi)
@@ -5084,12 +5082,12 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		DEFINE_WAIT(w);
 		int d;
 	again:
-		sh = get_active_stripe(conf, logical_sector, 0, 0, 0);
+		sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
 		prepare_to_wait(&conf->wait_for_overlap, &w,
 				TASK_UNINTERRUPTIBLE);
 		set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
 		if (test_bit(STRIPE_SYNCING, &sh->state)) {
-			release_stripe(sh);
+			raid5_release_stripe(sh);
 			schedule();
 			goto again;
 		}
@@ -5101,7 +5099,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 			if (sh->dev[d].towrite || sh->dev[d].toread) {
 				set_bit(R5_Overlap, &sh->dev[d].flags);
 				spin_unlock_irq(&sh->stripe_lock);
-				release_stripe(sh);
+				raid5_release_stripe(sh);
 				schedule();
 				goto again;
 			}
@@ -5229,7 +5227,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 			(unsigned long long)new_sector,
 			(unsigned long long)logical_sector);
 
-		sh = get_active_stripe(conf, new_sector, previous,
+		sh = raid5_get_active_stripe(conf, new_sector, previous,
 				       (bi->bi_rw&RWA_MASK), 0);
 		if (sh) {
 			if (unlikely(previous)) {
@@ -5250,7 +5248,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 					must_retry = 1;
 				spin_unlock_irq(&conf->device_lock);
 				if (must_retry) {
-					release_stripe(sh);
+					raid5_release_stripe(sh);
 					schedule();
 					do_prepare = true;
 					goto retry;
@@ -5260,14 +5258,14 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 				/* Might have got the wrong stripe_head
 				 * by accident
 				 */
-				release_stripe(sh);
+				raid5_release_stripe(sh);
 				goto retry;
 			}
 
 			if (rw == WRITE &&
 			    logical_sector >= mddev->suspend_lo &&
 			    logical_sector < mddev->suspend_hi) {
-				release_stripe(sh);
+				raid5_release_stripe(sh);
 				/* As the suspend_* range is controlled by
 				 * userspace, we want an interruptible
 				 * wait.
@@ -5290,7 +5288,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 				 * and wait a while
 				 */
 				md_wakeup_thread(mddev->thread);
-				release_stripe(sh);
+				raid5_release_stripe(sh);
 				schedule();
 				do_prepare = true;
 				goto retry;
@@ -5468,7 +5466,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	for (i = 0; i < reshape_sectors; i += STRIPE_SECTORS) {
 		int j;
 		int skipped_disk = 0;
-		sh = get_active_stripe(conf, stripe_addr+i, 0, 0, 1);
+		sh = raid5_get_active_stripe(conf, stripe_addr+i, 0, 0, 1);
 		set_bit(STRIPE_EXPANDING, &sh->state);
 		atomic_inc(&conf->reshape_stripes);
 		/* If any of this stripe is beyond the end of the old
@@ -5481,7 +5479,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 			if (conf->level == 6 &&
 			    j == sh->qd_idx)
 				continue;
-			s = compute_blocknr(sh, j, 0);
+			s = raid5_compute_blocknr(sh, j, 0);
 			if (s < raid5_size(mddev, 0, 0)) {
 				skipped_disk = 1;
 				continue;
@@ -5517,10 +5515,10 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	if (last_sector >= mddev->dev_sectors)
 		last_sector = mddev->dev_sectors - 1;
 	while (first_sector <= last_sector) {
-		sh = get_active_stripe(conf, first_sector, 1, 0, 1);
+		sh = raid5_get_active_stripe(conf, first_sector, 1, 0, 1);
 		set_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 		set_bit(STRIPE_HANDLE, &sh->state);
-		release_stripe(sh);
+		raid5_release_stripe(sh);
 		first_sector += STRIPE_SECTORS;
 	}
 	/* Now that the sources are clearly marked, we can release
@@ -5529,7 +5527,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	while (!list_empty(&stripes)) {
 		sh = list_entry(stripes.next, struct stripe_head, lru);
 		list_del_init(&sh->lru);
-		release_stripe(sh);
+		raid5_release_stripe(sh);
 	}
 	/* If this takes us to the resync_max point where we have to pause,
 	 * then we need to write out the superblock.
@@ -5624,9 +5622,9 @@ static inline sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int
 
 	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
 
-	sh = get_active_stripe(conf, sector_nr, 0, 1, 0);
+	sh = raid5_get_active_stripe(conf, sector_nr, 0, 1, 0);
 	if (sh == NULL) {
-		sh = get_active_stripe(conf, sector_nr, 0, 0, 0);
+		sh = raid5_get_active_stripe(conf, sector_nr, 0, 0, 0);
 		/* make sure we don't swamp the stripe cache if someone else
 		 * is trying to get access
 		 */
@@ -5650,7 +5648,7 @@ static inline sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int
 	set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
 	set_bit(STRIPE_HANDLE, &sh->state);
 
-	release_stripe(sh);
+	raid5_release_stripe(sh);
 
 	return STRIPE_SECTORS;
 }
@@ -5689,7 +5687,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 			/* already done this stripe */
 			continue;
 
-		sh = get_active_stripe(conf, sector, 0, 1, 1);
+		sh = raid5_get_active_stripe(conf, sector, 0, 1, 1);
 
 		if (!sh) {
 			/* failed to get a stripe - must wait */
@@ -5699,7 +5697,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 		}
 
 		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0, 0)) {
-			release_stripe(sh);
+			raid5_release_stripe(sh);
 			raid5_set_bi_processed_stripes(raid_bio, scnt);
 			conf->retry_read_aligned = raid_bio;
 			return handled;
@@ -5707,7 +5705,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 
 		set_bit(R5_ReadNoMerge, &sh->dev[dd_idx].flags);
 		handle_stripe(sh);
-		release_stripe(sh);
+		raid5_release_stripe(sh);
 		handled++;
 	}
 	remaining = raid5_dec_bi_active_stripes(raid_bio);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index d051442..d8785df 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -606,4 +606,12 @@ static inline int algorithm_is_DDF(int layout)
 
 extern void md_raid5_kick_device(struct r5conf *conf);
 extern int raid5_set_cache_size(struct mddev *mddev, int size);
+extern sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous);
+extern void raid5_release_stripe(struct stripe_head *sh);
+extern sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
+				     int previous, int *dd_idx,
+				     struct stripe_head *sh);
+extern struct stripe_head *
+raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
+		  int previous, int noblock, int noquiesce);
 #endif
-- 
1.8.1

