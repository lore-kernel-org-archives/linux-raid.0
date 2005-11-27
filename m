From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 012 of 18] Fix raid6 resync check/repair code.
Date: Mon, 28 Nov 2005 10:40:38 +1100
Message-ID: <1051127234038.14877@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


raid6 currently does not check the P/Q syndromes when doing a resync,
it just calculates the correct value and writes it.
Doing the check can reduce writes (often to 0) for a resync,
and it is needed to properly implement the 
  echo check > sync_action
operation.

This patch implements the appropriate checks and tidies up some related
code.

It also allows raid6 user-requested resync to bypass the intent bitmap.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid6main.c     |  184 +++++++++++++++++++++++++------------------
 ./include/linux/raid/raid5.h |    2 
 2 files changed, 109 insertions(+), 77 deletions(-)

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-11-28 10:12:40.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-11-28 10:12:56.000000000 +1100
@@ -805,7 +805,7 @@ static void compute_parity(struct stripe
 }
 
 /* Compute one missing block */
-static void compute_block_1(struct stripe_head *sh, int dd_idx)
+static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 {
 	raid6_conf_t *conf = sh->raid_conf;
 	int i, count, disks = conf->raid_disks;
@@ -821,7 +821,7 @@ static void compute_block_1(struct strip
 		compute_parity(sh, UPDATE_PARITY);
 	} else {
 		ptr[0] = page_address(sh->dev[dd_idx].page);
-		memset(ptr[0], 0, STRIPE_SIZE);
+		if (!nozero) memset(ptr[0], 0, STRIPE_SIZE);
 		count = 1;
 		for (i = disks ; i--; ) {
 			if (i == dd_idx || i == qd_idx)
@@ -838,7 +838,8 @@ static void compute_block_1(struct strip
 		}
 		if (count != 1)
 			xor_block(count, STRIPE_SIZE, ptr);
-		set_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
+		if (!nozero) set_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
+		else clear_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
 	}
 }
 
@@ -871,7 +872,7 @@ static void compute_block_2(struct strip
 			return;
 		} else {
 			/* We're missing D+Q; recompute D from P */
-			compute_block_1(sh, (dd_idx1 == qd_idx) ? dd_idx2 : dd_idx1);
+			compute_block_1(sh, (dd_idx1 == qd_idx) ? dd_idx2 : dd_idx1, 0);
 			compute_parity(sh, UPDATE_PARITY); /* Is this necessary? */
 			return;
 		}
@@ -982,6 +983,12 @@ static int add_stripe_bio(struct stripe_
 }
 
 
+static int page_is_zero(struct page *p)
+{
+	char *a = page_address(p);
+	return ((*(u32*)a) == 0 &&
+		memcmp(a, a+4, STRIPE_SIZE-4)==0);
+}
 /*
  * handle_stripe - do things to a stripe.
  *
@@ -1000,7 +1007,7 @@ static int add_stripe_bio(struct stripe_
  *
  */
 
-static void handle_stripe(struct stripe_head *sh)
+static void handle_stripe(struct stripe_head *sh, struct page *tmp_page)
 {
 	raid6_conf_t *conf = sh->raid_conf;
 	int disks = conf->raid_disks;
@@ -1228,7 +1235,7 @@ static void handle_stripe(struct stripe_
 				if (uptodate == disks-1) {
 					PRINTK("Computing stripe %llu block %d\n",
 					       (unsigned long long)sh->sector, i);
-					compute_block_1(sh, i);
+					compute_block_1(sh, i, 0);
 					uptodate++;
 				} else if ( uptodate == disks-2 && failed >= 2 ) {
 					/* Computing 2-failure is *very* expensive; only do it if failed >= 2 */
@@ -1323,7 +1330,7 @@ static void handle_stripe(struct stripe_
 				/* We have failed blocks and need to compute them */
 				switch ( failed ) {
 				case 0:	BUG();
-				case 1: compute_block_1(sh, failed_num[0]); break;
+				case 1: compute_block_1(sh, failed_num[0], 0); break;
 				case 2: compute_block_2(sh, failed_num[0], failed_num[1]); break;
 				default: BUG();	/* This request should have been failed? */
 				}
@@ -1338,12 +1345,10 @@ static void handle_stripe(struct stripe_
 					       (unsigned long long)sh->sector, i);
 					locked++;
 					set_bit(R5_Wantwrite, &sh->dev[i].flags);
-#if 0 /**** FIX: I don't understand the logic here... ****/
-					if (!test_bit(R5_Insync, &sh->dev[i].flags)
-					    || ((i==pd_idx || i==qd_idx) && failed == 0)) /* FIX? */
-						set_bit(STRIPE_INSYNC, &sh->state);
-#endif
 				}
+			/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
+			set_bit(STRIPE_INSYNC, &sh->state);
+
 			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 				atomic_dec(&conf->preread_active_stripes);
 				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
@@ -1356,79 +1361,97 @@ static void handle_stripe(struct stripe_
 	 * Any reads will already have been scheduled, so we just see if enough data
 	 * is available
 	 */
-	if (syncing && locked == 0 &&
-	    !test_bit(STRIPE_INSYNC, &sh->state) && failed <= 2) {
-		set_bit(STRIPE_HANDLE, &sh->state);
-#if 0 /* RAID-6: Don't support CHECK PARITY yet */
-		if (failed == 0) {
-			char *pagea;
-			if (uptodate != disks)
-				BUG();
-			compute_parity(sh, CHECK_PARITY);
-			uptodate--;
-			pagea = page_address(sh->dev[pd_idx].page);
-			if ((*(u32*)pagea) == 0 &&
-			    !memcmp(pagea, pagea+4, STRIPE_SIZE-4)) {
-				/* parity is correct (on disc, not in buffer any more) */
-				set_bit(STRIPE_INSYNC, &sh->state);
-			}
-		}
-#endif
-		if (!test_bit(STRIPE_INSYNC, &sh->state)) {
-			int failed_needupdate[2];
-			struct r5dev *adev, *bdev;
-
-			if ( failed < 1 )
-				failed_num[0] = pd_idx;
-			if ( failed < 2 )
-				failed_num[1] = (failed_num[0] == qd_idx) ? pd_idx : qd_idx;
+	if (syncing && locked == 0 && !test_bit(STRIPE_INSYNC, &sh->state)) {
+		int update_p = 0, update_q = 0;
+		struct r5dev *dev;
 
-			failed_needupdate[0] = !test_bit(R5_UPTODATE, &sh->dev[failed_num[0]].flags);
-			failed_needupdate[1] = !test_bit(R5_UPTODATE, &sh->dev[failed_num[1]].flags);
+		set_bit(STRIPE_HANDLE, &sh->state);
 
-			PRINTK("sync: failed=%d num=%d,%d fnu=%u%u\n",
-			       failed, failed_num[0], failed_num[1], failed_needupdate[0], failed_needupdate[1]);
+		BUG_ON(failed>2);
+		BUG_ON(uptodate < disks);
+		/* Want to check and possibly repair P and Q.
+		 * However there could be one 'failed' device, in which
+		 * case we can only check one of them, possibly using the
+		 * other to generate missing data
+		 */
 
-#if 0  /* RAID-6: This code seems to require that CHECK_PARITY destroys the uptodateness of the parity */
-			/* should be able to compute the missing block(s) and write to spare */
-			if ( failed_needupdate[0] ^ failed_needupdate[1] ) {
-				if (uptodate+1 != disks)
-					BUG();
-				compute_block_1(sh, failed_needupdate[0] ? failed_num[0] : failed_num[1]);
-				uptodate++;
-			} else if ( failed_needupdate[0] & failed_needupdate[1] ) {
-				if (uptodate+2 != disks)
-					BUG();
-				compute_block_2(sh, failed_num[0], failed_num[1]);
-				uptodate += 2;
+		/* If !tmp_page, we cannot do the calculations,
+		 * but as we have set STRIPE_HANDLE, we will soon be called
+		 * by stripe_handle with a tmp_page - just wait until then.
+		 */
+		if (tmp_page) {
+			if (failed == q_failed) {
+				/* The only possible failed device holds 'Q', so it makes
+				 * sense to check P (If anything else were failed, we would
+				 * have used P to recreate it).
+				 */
+				compute_block_1(sh, pd_idx, 1);
+				if (!page_is_zero(sh->dev[pd_idx].page)) {
+					compute_block_1(sh,pd_idx,0);
+					update_p = 1;
+				}
+			}
+			if (!q_failed && failed < 2) {
+				/* q is not failed, and we didn't use it to generate
+				 * anything, so it makes sense to check it
+				 */
+				memcpy(page_address(tmp_page),
+				       page_address(sh->dev[qd_idx].page),
+				       STRIPE_SIZE);
+				compute_parity(sh, UPDATE_PARITY);
+				if (memcmp(page_address(tmp_page),
+					   page_address(sh->dev[qd_idx].page),
+					   STRIPE_SIZE)!= 0) {
+					clear_bit(STRIPE_INSYNC, &sh->state);
+					update_q = 1;
+				}
+			}
+			if (update_p || update_q) {
+				conf->mddev->resync_mismatches += STRIPE_SECTORS;
+				if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+					/* don't try to repair!! */
+					update_p = update_q = 0;
 			}
-#else
-			compute_block_2(sh, failed_num[0], failed_num[1]);
-			uptodate += failed_needupdate[0] + failed_needupdate[1];
-#endif
-
-			if (uptodate != disks)
-				BUG();
 
-			PRINTK("Marking for sync stripe %llu blocks %d,%d\n",
-			       (unsigned long long)sh->sector, failed_num[0], failed_num[1]);
+			/* now write out any block on a failed drive,
+			 * or P or Q if they need it
+			 */
+
+			if (failed == 2) {
+				dev = &sh->dev[failed_num[1]];
+				locked++;
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantwrite, &dev->flags);
+				set_bit(R5_Syncio, &dev->flags);
+			}
+			if (failed >= 1) {
+				dev = &sh->dev[failed_num[0]];
+				locked++;
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantwrite, &dev->flags);
+				set_bit(R5_Syncio, &dev->flags);
+			}
 
-			/**** FIX: Should we really do both of these unconditionally? ****/
-			adev = &sh->dev[failed_num[0]];
-			locked += !test_bit(R5_LOCKED, &adev->flags);
-			set_bit(R5_LOCKED, &adev->flags);
-			set_bit(R5_Wantwrite, &adev->flags);
-			bdev = &sh->dev[failed_num[1]];
-			locked += !test_bit(R5_LOCKED, &bdev->flags);
-			set_bit(R5_LOCKED, &bdev->flags);
+			if (update_p) {
+				dev = &sh->dev[pd_idx];
+				locked ++;
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantwrite, &dev->flags);
+				set_bit(R5_Syncio, &dev->flags);
+			}
+			if (update_q) {
+				dev = &sh->dev[qd_idx];
+				locked++;
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantwrite, &dev->flags);
+				set_bit(R5_Syncio, &dev->flags);
+			}
 			clear_bit(STRIPE_DEGRADED, &sh->state);
-			set_bit(R5_Wantwrite, &bdev->flags);
 
 			set_bit(STRIPE_INSYNC, &sh->state);
-			set_bit(R5_Syncio, &adev->flags);
-			set_bit(R5_Syncio, &bdev->flags);
 		}
 	}
+
 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
@@ -1664,7 +1687,7 @@ static int make_request (request_queue_t
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
 			raid6_plug_device(conf);
-			handle_stripe(sh);
+			handle_stripe(sh, NULL);
 			release_stripe(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
@@ -1728,6 +1751,7 @@ static sector_t sync_request(mddev_t *md
 		return rv;
 	}
 	if (!bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
+	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    !conf->fullsync && sync_blocks >= STRIPE_SECTORS) {
 		/* we can skip this block, and probably more */
 		sync_blocks /= STRIPE_SECTORS;
@@ -1765,7 +1789,7 @@ static sector_t sync_request(mddev_t *md
 	clear_bit(STRIPE_INSYNC, &sh->state);
 	spin_unlock(&sh->lock);
 
-	handle_stripe(sh);
+	handle_stripe(sh, NULL);
 	release_stripe(sh);
 
 	return STRIPE_SECTORS;
@@ -1821,7 +1845,7 @@ static void raid6d (mddev_t *mddev)
 		spin_unlock_irq(&conf->device_lock);
 
 		handled++;
-		handle_stripe(sh);
+		handle_stripe(sh, conf->spare_page);
 		release_stripe(sh);
 
 		spin_lock_irq(&conf->device_lock);
@@ -1860,6 +1884,10 @@ static int run(mddev_t *mddev)
 		goto abort;
 	memset(conf->stripe_hashtbl, 0, HASH_PAGES * PAGE_SIZE);
 
+	conf->spare_page = alloc_page(GFP_KERNEL);
+	if (!conf->spare_page)
+		goto abort;
+
 	spin_lock_init(&conf->device_lock);
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
@@ -1996,6 +2024,8 @@ static int run(mddev_t *mddev)
 abort:
 	if (conf) {
 		print_raid6_conf(conf);
+		if (conf->spare_page)
+			page_cache_release(conf->spare_page);
 		if (conf->stripe_hashtbl)
 			free_pages((unsigned long) conf->stripe_hashtbl,
 							HASH_PAGES_ORDER);

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2005-11-28 10:08:19.000000000 +1100
+++ ./include/linux/raid/raid5.h	2005-11-28 10:12:56.000000000 +1100
@@ -228,6 +228,8 @@ struct raid5_private_data {
 					    * Cleared when a sync completes.
 					    */
 
+	struct page 		*spare_page; /* Used when checking P/Q in raid6 */
+
 	/*
 	 * Free stripes pool
 	 */
