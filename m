From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH RFC 2/4] md: refactor raid5 cache policy code using 'struct
	stripe_cache_policy'
Date: Tue, 10 Apr 2007 23:00:31 -0700
Message-ID: <20070411060031.15745.50795.stgit@dwillia2-linux.ch.intel.com>
References: <20070411055729.15745.51513.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070411055729.15745.51513.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

struct stripe_cache_policy is introduced as an interface to enable multiple
caching policies.  It adds several methods to be called when cache events
occur.  See the definition of stripe_cache_policy in
include/linux/raid/raid5.h.  This patch does not add any new caching
policies, it just moves the current code to a new location and calls it by
a struct stripe_cache_policy method.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c         |  644 +++++++++++++++++++++++++-------------------
 include/linux/raid/raid5.h |   82 +++++-
 2 files changed, 446 insertions(+), 280 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 684552a..3b32a19 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -112,11 +112,12 @@ static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 	if (atomic_dec_and_test(&sh->count)) {
 		BUG_ON(!list_empty(&sh->lru));
 		BUG_ON(atomic_read(&conf->active_stripes)==0);
+		if (conf->cache_policy->release_stripe(conf, sh,
+						test_bit(STRIPE_HANDLE, &sh->state)))
+			return; /* stripe was moved to a cache policy specific queue */
+
 		if (test_bit(STRIPE_HANDLE, &sh->state)) {
-			if (test_bit(STRIPE_DELAYED, &sh->state)) {
-				list_add_tail(&sh->lru, &conf->delayed_list);
-				blk_plug_device(conf->mddev->queue);
-			} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
+			if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
 				   sh->bm_seq - conf->seq_write > 0) {
 				list_add_tail(&sh->lru, &conf->bitmap_list);
 				blk_plug_device(conf->mddev->queue);
@@ -125,23 +126,11 @@ static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 				list_add_tail(&sh->lru, &conf->handle_list);
 			}
 			md_wakeup_thread(conf->mddev->thread);
-		} else {
-			BUG_ON(sh->ops.pending);
-			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-				atomic_dec(&conf->preread_active_stripes);
-				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
-					md_wakeup_thread(conf->mddev->thread);
-			}
-			atomic_dec(&conf->active_stripes);
-			if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
-				list_add_tail(&sh->lru, &conf->inactive_list);
-				wake_up(&conf->wait_for_stripe);
-				if (conf->retry_read_aligned)
-					md_wakeup_thread(conf->mddev->thread);
-			}
-		}
+		} else
+			BUG();
 	}
 }
+
 static void release_stripe(struct stripe_head *sh)
 {
 	raid5_conf_t *conf = sh->raid_conf;
@@ -724,39 +713,6 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	return tx;
 }
 
-static void ops_complete_postxor(void *stripe_head_ref)
-{
-	struct stripe_head *sh = stripe_head_ref;
-
-	PRINTK("%s: stripe %llu\n", __FUNCTION__,
-		(unsigned long long)sh->sector);
-
-	set_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
-	set_bit(STRIPE_HANDLE, &sh->state);
-	release_stripe(sh);
-}
-
-static void ops_complete_write(void *stripe_head_ref)
-{
-	struct stripe_head *sh = stripe_head_ref;
-	int disks = sh->disks, i, pd_idx = sh->pd_idx;
-
-	PRINTK("%s: stripe %llu\n", __FUNCTION__,
-		(unsigned long long)sh->sector);
-
-	for (i=disks ; i-- ;) {
-		struct r5dev *dev = &sh->dev[i];
-		if (dev->written || i == pd_idx)
-			set_bit(R5_UPTODATE, &dev->flags);
-	}
-
-	set_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
-	set_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
-
-	set_bit(STRIPE_HANDLE, &sh->state);
-	release_stripe(sh);
-}
-
 static void
 ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
@@ -764,6 +720,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	int disks = sh->disks;
 	struct page *xor_srcs[disks];
 
+	raid5_conf_t *conf = sh->raid_conf;
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
 	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
@@ -792,9 +749,8 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 		}
 	}
 
-	/* check whether this postxor is part of a write */
-	callback = test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending) ?
-		ops_complete_write : ops_complete_postxor;
+	/* take cache policy specific action upon completion of the postxor */
+	callback = conf->cache_policy->complete_postxor_action;
 
 	/* 1/ if we prexor'd then the dest is reused as a source
 	 * 2/ if we did not prexor then we are redoing the parity
@@ -1683,7 +1639,8 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 	}
 }
 
-static int handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
+static int 
+raid5_wt_cache_handle_parity_updates(struct stripe_head *sh, int rcw, int expand)
 {
 	int i, pd_idx = sh->pd_idx, disks = sh->disks;
 	int locked=0;
@@ -1847,6 +1804,327 @@ static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
 	return pd_idx;
 }
 
+static int
+raid5_wt_cache_release_stripe(raid5_conf_t *conf, struct stripe_head *sh,
+	int handle)
+{
+	struct stripe_cache_policy *cp = conf->cache_policy;
+
+	PRINTK("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	if (handle && test_bit(STRIPE_DELAYED, &sh->state)) {
+		list_add_tail(&sh->lru, &cp->delayed_list);
+		blk_plug_device(conf->mddev->queue);
+		return 1;
+	} else if (!handle) {
+		BUG_ON(sh->ops.pending);
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+			atomic_dec(&cp->preread_active_stripes);
+			if (atomic_read(&cp->preread_active_stripes) < IO_THRESHOLD)
+				md_wakeup_thread(conf->mddev->thread);
+		}
+		atomic_dec(&conf->active_stripes);
+		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
+			list_add_tail(&sh->lru, &conf->inactive_list);
+			wake_up(&conf->wait_for_stripe);
+			if (conf->retry_read_aligned)
+				md_wakeup_thread(conf->mddev->thread);
+		}
+		return 1;
+	}
+
+	return 0;
+}
+
+static void raid5_wt_cache_complete_postxor_action(void *stripe_head_ref)
+{
+	struct stripe_head *sh = stripe_head_ref;
+
+	PRINTK("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	set_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+
+	/* leaving prexor set until postxor is done allows us to distinguish
+	 * a rmw from a rcw during biodrain
+	 */
+	if (test_bit(STRIPE_OP_PREXOR, &sh->ops.complete)) {
+		int i;
+		for (i=sh->disks; i--;)
+			clear_bit(R5_Wantprexor, &sh->dev[i].flags);
+
+		clear_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
+		clear_bit(STRIPE_OP_PREXOR, &sh->ops.ack);
+		clear_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	}
+
+	if (test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending)) {
+		int disks = sh->disks, i, pd_idx = sh->pd_idx;
+
+		for (i=disks ; i-- ;) {
+			struct r5dev *dev = &sh->dev[i];
+			if (dev->written || i == pd_idx)
+				set_bit(R5_UPTODATE, &dev->flags);
+		}
+
+		set_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
+	}
+
+	set_bit(STRIPE_HANDLE, &sh->state);
+	release_stripe(sh);
+}
+
+static struct bio *
+raid5_wt_cache_handle_completed_writes(struct stripe_head *sh,
+	struct stripe_head_state *s)
+{
+	struct bio *return_bi = NULL;
+
+	/* might be able to return some write requests if the parity block
+	 * is safe, or on a failed drive
+	 */
+	struct r5dev *dev = &sh->dev[sh->pd_idx];
+	if ( s->written &&
+	     ( (test_bit(R5_Insync, &dev->flags) && !test_bit(R5_LOCKED, &dev->flags) &&
+		test_bit(R5_UPTODATE, &dev->flags))
+	       || (s->failed == 1 && s->failed_num == sh->pd_idx))
+	    ) {
+	    raid5_conf_t *conf = sh->raid_conf;
+	    int i;
+	    /* any written block on an uptodate or failed drive can be returned.
+	     * Note that if we 'wrote' to a failed drive, it will be UPTODATE, but 
+	     * never LOCKED, so we don't need to test 'failed' directly.
+	     */
+	    for (i=sh->disks; i--; )
+		if (sh->dev[i].written) {
+		    dev = &sh->dev[i];
+		    if (!test_bit(R5_LOCKED, &dev->flags) &&
+			 test_bit(R5_UPTODATE, &dev->flags) ) {
+			/* We can return any write requests */
+			    struct bio *wbi, *wbi2;
+			    int bitmap_end = 0;
+			    PRINTK("%s: Return write for disc %d\n",
+			    	__FUNCTION__, i);
+			    spin_lock_irq(&conf->device_lock);
+			    wbi = dev->written;
+			    dev->written = NULL;
+			    while (wbi && wbi->bi_sector < dev->sector + STRIPE_SECTORS) {
+				    wbi2 = r5_next_bio(wbi, dev->sector);
+				    if (--wbi->bi_phys_segments == 0) {
+					    md_write_end(conf->mddev);
+					    wbi->bi_next = return_bi;
+					    return_bi = wbi;
+				    }
+				    wbi = wbi2;
+			    }
+			    if (dev->towrite == NULL)
+				    bitmap_end = 1;
+			    spin_unlock_irq(&conf->device_lock);
+			    if (bitmap_end)
+				    bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+						    STRIPE_SECTORS,
+						    !test_bit(STRIPE_DEGRADED, &sh->state), 0);
+		    }
+		}
+	}
+
+	return return_bi;
+}
+
+static void
+raid5_wt_cache_submit_pending_writes(struct stripe_head *sh,
+	struct stripe_head_state *s)
+{
+	/* if only POSTXOR is set then this is an 'expand' postxor */
+	if (test_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete) &&
+		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
+		raid5_conf_t *conf = sh->raid_conf;
+		struct stripe_cache_policy *cp = conf->cache_policy;
+		int i;
+
+		PRINTK("%s: stripe %llu\n", __FUNCTION__,
+			(unsigned long long)sh->sector);
+
+		/* All the 'written' buffers and the parity block are ready to be
+		 * written back to disk
+		 */
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
+		for (i=sh->disks; i--;) {
+			struct r5dev *dev = &sh->dev[i];
+			if (test_bit(R5_LOCKED, &dev->flags) &&
+				(i == sh->pd_idx || dev->written)) {
+				PRINTK("Writing block %d\n", i);
+				set_bit(R5_Wantwrite, &dev->flags);
+				if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+					sh->ops.count++;
+				if (!test_bit(R5_Insync, &dev->flags)
+				    || (i==sh->pd_idx && s->failed == 0))
+					set_bit(STRIPE_INSYNC, &sh->state);
+			}
+		}
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+			atomic_dec(&cp->preread_active_stripes);
+			if (atomic_read(&cp->preread_active_stripes) < IO_THRESHOLD)
+				md_wakeup_thread(conf->mddev->thread);
+		}
+
+		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
+		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
+
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+	}
+
+}
+
+static void
+raid5_wt_cache_handle_new_writes(struct stripe_head *sh, struct stripe_head_state *s)
+{
+	/* 1/ Check operations clobber the parity block so do not start new writes while
+	 *    a check is in flight
+	 * 2/ Write operations do not stack
+	 */
+	if (s->to_write && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending) &&
+		!test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
+		int rmw=0, rcw=0, disks = sh->disks, i;
+		struct r5dev *dev;
+		for (i=disks ; i--;) {
+			/* would I have to read this buffer for read_modify_write */
+			dev = &sh->dev[i];
+			if ((dev->towrite || i == sh->pd_idx) &&
+			    (!test_bit(R5_LOCKED, &dev->flags) 
+				    ) &&
+			    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags))) {
+				if (test_bit(R5_Insync, &dev->flags)
+/*				    && !(!mddev->insync && i == sh->pd_idx) */
+					)
+					rmw++;
+				else rmw += 2*disks;  /* cannot read it */
+			}
+			/* Would I have to read this buffer for reconstruct_write */
+			if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
+			    (!test_bit(R5_LOCKED, &dev->flags) 
+				    ) &&
+			    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags))) {
+				if (test_bit(R5_Insync, &dev->flags)) rcw++;
+				else rcw += 2*disks;
+			}
+		}
+		PRINTK("for sector %llu, rmw=%d rcw=%d\n", 
+			(unsigned long long)sh->sector, rmw, rcw);
+		set_bit(STRIPE_HANDLE, &sh->state);
+		if (rmw < rcw && rmw > 0)
+			/* prefer read-modify-write, but need to get some data */
+			for (i=disks; i--;) {
+				dev = &sh->dev[i];
+				if ((dev->towrite || i == sh->pd_idx) &&
+				    !test_bit(R5_LOCKED, &dev->flags) &&
+				    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags)) &&
+				    test_bit(R5_Insync, &dev->flags)) {
+					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+					{
+						PRINTK("Read_old block %d for r-m-w\n", i);
+						set_bit(R5_LOCKED, &dev->flags);
+						set_bit(R5_Wantread, &dev->flags);
+						if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+							sh->ops.count++;
+						s->locked++;
+					} else {
+						set_bit(STRIPE_DELAYED, &sh->state);
+						set_bit(STRIPE_HANDLE, &sh->state);
+					}
+				}
+			}
+		if (rcw <= rmw && rcw > 0)
+			/* want reconstruct write, but need to get some data */
+			for (i=disks; i--;) {
+				dev = &sh->dev[i];
+				if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
+				    !test_bit(R5_LOCKED, &dev->flags) &&
+				    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags)) &&
+				    test_bit(R5_Insync, &dev->flags)) {
+					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+					{
+						PRINTK("Read_old block %d for Reconstruct\n", i);
+						set_bit(R5_LOCKED, &dev->flags);
+						set_bit(R5_Wantread, &dev->flags);
+						if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+							sh->ops.count++;
+						s->locked++;
+					} else {
+						set_bit(STRIPE_DELAYED, &sh->state);
+						set_bit(STRIPE_HANDLE, &sh->state);
+					}
+				}
+			}
+		/* now if nothing is locked, and if we have enough data, we can start a write request */
+		/* since handle_stripe can be called at any time we need to handle the case
+		 * where a compute block operation has been submitted and then a subsequent
+		 * call wants to start a write request.  raid5_run_ops only handles the case where
+		 * compute block and postxor are requested simultaneously.  If this
+		 * is not the case then new writes need to be held off until the compute
+		 * completes.
+		 */
+		if ((s->req_compute || !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) &&
+			(s->locked == 0 && (rcw == 0 ||rmw == 0) &&
+			!test_bit(STRIPE_BIT_DELAY, &sh->state)))
+			s->locked += raid5_wt_cache_handle_parity_updates(sh, rcw == 0, 0);
+			
+	}
+}
+
+static void raid5_wt_cache_activate_delayed(raid5_conf_t *conf)
+{
+	struct stripe_cache_policy *cp = conf->cache_policy;
+	if (atomic_read(&cp->preread_active_stripes) < IO_THRESHOLD) {
+		while (!list_empty(&cp->delayed_list)) {
+			struct list_head *l = cp->delayed_list.next;
+			struct stripe_head *sh;
+			sh = list_entry(l, struct stripe_head, lru);
+			list_del_init(l);
+			clear_bit(STRIPE_DELAYED, &sh->state);
+			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+				atomic_inc(&cp->preread_active_stripes);
+			list_add_tail(&sh->lru, &conf->handle_list);
+		}
+	}
+}
+
+static void raid5_wt_cache_raid5d(mddev_t *mddev, raid5_conf_t *conf)
+{
+	struct stripe_cache_policy *cp = conf->cache_policy;
+
+	if (list_empty(&conf->handle_list) &&
+	    atomic_read(&cp->preread_active_stripes) < IO_THRESHOLD &&
+	    !blk_queue_plugged(mddev->queue) &&
+	    !list_empty(&cp->delayed_list))
+		raid5_wt_cache_activate_delayed(conf);
+}
+
+static void raid5_wt_cache_init(raid5_conf_t *conf)
+{
+	atomic_set(&conf->cache_policy->preread_active_stripes, 0);
+	INIT_LIST_HEAD(&conf->cache_policy->delayed_list);
+}
+
+static void raid5_wt_cache_unplug_device(raid5_conf_t *conf)
+{
+	raid5_wt_cache_activate_delayed(conf);
+}
+
+static struct stripe_cache_policy raid5_cache_policy_write_through = {
+	.release_stripe = raid5_wt_cache_release_stripe,
+	.complete_postxor_action = raid5_wt_cache_complete_postxor_action,
+	.submit_pending_writes = raid5_wt_cache_submit_pending_writes,
+	.handle_new_writes = raid5_wt_cache_handle_new_writes,
+	.handle_completed_writes = raid5_wt_cache_handle_completed_writes,
+	.raid5d = raid5_wt_cache_raid5d,
+	.init = raid5_wt_cache_init,
+	.unplug_device = raid5_wt_cache_unplug_device,
+};
 
 /*
  * handle_stripe - do things to a stripe.
@@ -1944,12 +2222,13 @@ static void handle_stripe5(struct stripe_head *sh)
 	}
 	rcu_read_unlock();
 
+	/* do we need to request a biofill operation? */
 	if (s.to_fill && !test_and_set_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
 		sh->ops.count++;
 
-	PRINTK("locked=%d uptodate=%d to_read=%d"
+	PRINTK("locked=%d dirty=%d uptodate=%d to_read=%d"
 		" to_write=%d to_fill=%d failed=%d failed_num=%d\n",
-		s.locked, s.uptodate, s.to_read, s.to_write, s.to_fill,
+		s.locked, s.dirty, s.uptodate, s.to_read, s.to_write, s.to_fill,
 		s.failed, s.failed_num);
 	/* check if the array has lost two devices and, if so, some requests might
 	 * need to be failed
@@ -2035,50 +2314,8 @@ static void handle_stripe5(struct stripe_head *sh)
 		s.syncing = 0;
 	}
 
-	/* might be able to return some write requests if the parity block
-	 * is safe, or on a failed drive
-	 */
-	dev = &sh->dev[sh->pd_idx];
-	if ( s.written &&
-	     ( (test_bit(R5_Insync, &dev->flags) && !test_bit(R5_LOCKED, &dev->flags) &&
-		test_bit(R5_UPTODATE, &dev->flags))
-	       || (s.failed == 1 && s.failed_num == sh->pd_idx))
-	    ) {
-	    /* any written block on an uptodate or failed drive can be returned.
-	     * Note that if we 'wrote' to a failed drive, it will be UPTODATE, but 
-	     * never LOCKED, so we don't need to test 'failed' directly.
-	     */
-	    for (i=disks; i--; )
-		if (sh->dev[i].written) {
-		    dev = &sh->dev[i];
-		    if (!test_bit(R5_LOCKED, &dev->flags) &&
-			 test_bit(R5_UPTODATE, &dev->flags) ) {
-			/* We can return any write requests */
-			    struct bio *wbi, *wbi2;
-			    int bitmap_end = 0;
-			    PRINTK("Return write for disc %d\n", i);
-			    spin_lock_irq(&conf->device_lock);
-			    wbi = dev->written;
-			    dev->written = NULL;
-			    while (wbi && wbi->bi_sector < dev->sector + STRIPE_SECTORS) {
-				    wbi2 = r5_next_bio(wbi, dev->sector);
-				    if (--wbi->bi_phys_segments == 0) {
-					    md_write_end(conf->mddev);
-					    wbi->bi_next = return_bi;
-					    return_bi = wbi;
-				    }
-				    wbi = wbi2;
-			    }
-			    if (dev->towrite == NULL)
-				    bitmap_end = 1;
-			    spin_unlock_irq(&conf->device_lock);
-			    if (bitmap_end)
-				    bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-						    STRIPE_SECTORS,
-						    !test_bit(STRIPE_DEGRADED, &sh->state), 0);
-		    }
-		}
-	}
+	/* handle the completion of writes to the backing disks */
+	return_bi = conf->cache_policy->handle_completed_writes(sh, &s);
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
@@ -2135,7 +2372,8 @@ static void handle_stripe5(struct stripe_head *sh)
 					 * 3/ We hold off parity block re-reads until check
 					 * operations have quiesced.
 					 */
-					if ((s.uptodate == disks-1) && !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
+					if (((s.uptodate == disks-1) && !s.dirty) &&
+						!test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 						set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
 						set_bit(R5_Wantcompute, &dev->flags);
 						sh->ops.target = i;
@@ -2148,7 +2386,8 @@ static void handle_stripe5(struct stripe_head *sh)
 						 */
 						s.uptodate++;
 						break; /* uptodate + compute == disks */
-					} else if ((s.uptodate < disks-1) && test_bit(R5_Insync, &dev->flags)) {
+					} else if (((s.uptodate < disks-1) || s.dirty) &&
+							test_bit(R5_Insync, &dev->flags)) {
 						/* Note: we hold off compute operations while checks are in flight,
 						 * but we still prefer 'compute' over 'read' hence we only read if
 						 * (uptodate < disks-1)
@@ -2167,158 +2406,20 @@ static void handle_stripe5(struct stripe_head *sh)
 		set_bit(STRIPE_HANDLE, &sh->state);
 	}
 
-	/* Now we check to see if any write operations have recently
-	 * completed
-	 */
-
-	/* leave prexor set until postxor is done, allows us to distinguish
-	 * a rmw from a rcw during biodrain
-	 */
-	if (test_bit(STRIPE_OP_PREXOR, &sh->ops.complete) &&
-		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
-
-		clear_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
-		clear_bit(STRIPE_OP_PREXOR, &sh->ops.ack);
-		clear_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
-
-		for (i=disks; i--;)
-			clear_bit(R5_Wantprexor, &sh->dev[i].flags);
-	}
-
-	/* if only POSTXOR is set then this is an 'expand' postxor */
-	if (test_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete) &&
-		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
-
-		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
-		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.ack);
-		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
+	/* Now we check to see if any blocks are ready to be written to disk */
+	conf->cache_policy->submit_pending_writes(sh, &s);
 
-		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
-		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
-		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
-
-		/* All the 'written' buffers and the parity block are ready to be
-		 * written back to disk
-		 */
-		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
-		for (i=disks; i--;) {
-			dev = &sh->dev[i];
-			if (test_bit(R5_LOCKED, &dev->flags) &&
-				(i == sh->pd_idx || dev->written)) {
-				PRINTK("Writing block %d\n", i);
-				set_bit(R5_Wantwrite, &dev->flags);
-				if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
-					sh->ops.count++;
-				if (!test_bit(R5_Insync, &dev->flags)
-				    || (i==sh->pd_idx && s.failed == 0))
-					set_bit(STRIPE_INSYNC, &sh->state);
-			}
-		}
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-			atomic_dec(&conf->preread_active_stripes);
-			if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
-				md_wakeup_thread(conf->mddev->thread);
-		}
-	}
-
-	/* 1/ Now to consider new write requests and what else, if anything should be read
-	 * 2/ Check operations clobber the parity block so do not start new writes while
-	 *    a check is in flight
-	 * 3/ Write operations do not stack
-	 */
-	if (s.to_write && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending) &&
-		!test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
-		int rmw=0, rcw=0;
-		for (i=disks ; i--;) {
-			/* would I have to read this buffer for read_modify_write */
-			dev = &sh->dev[i];
-			if ((dev->towrite || i == sh->pd_idx) &&
-			    (!test_bit(R5_LOCKED, &dev->flags) 
-				    ) &&
-			    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags))) {
-				if (test_bit(R5_Insync, &dev->flags)
-/*				    && !(!mddev->insync && i == sh->pd_idx) */
-					)
-					rmw++;
-				else rmw += 2*disks;  /* cannot read it */
-			}
-			/* Would I have to read this buffer for reconstruct_write */
-			if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
-			    (!test_bit(R5_LOCKED, &dev->flags) 
-				    ) &&
-			    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags))) {
-				if (test_bit(R5_Insync, &dev->flags)) rcw++;
-				else rcw += 2*disks;
-			}
-		}
-		PRINTK("for sector %llu, rmw=%d rcw=%d\n", 
-			(unsigned long long)sh->sector, rmw, rcw);
-		set_bit(STRIPE_HANDLE, &sh->state);
-		if (rmw < rcw && rmw > 0)
-			/* prefer read-modify-write, but need to get some data */
-			for (i=disks; i--;) {
-				dev = &sh->dev[i];
-				if ((dev->towrite || i == sh->pd_idx) &&
-				    !test_bit(R5_LOCKED, &dev->flags) &&
-				    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags)) &&
-				    test_bit(R5_Insync, &dev->flags)) {
-					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-					{
-						PRINTK("Read_old block %d for r-m-w\n", i);
-						set_bit(R5_LOCKED, &dev->flags);
-						set_bit(R5_Wantread, &dev->flags);
-						if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
-							sh->ops.count++;
-						s.locked++;
-					} else {
-						set_bit(STRIPE_DELAYED, &sh->state);
-						set_bit(STRIPE_HANDLE, &sh->state);
-					}
-				}
-			}
-		if (rcw <= rmw && rcw > 0)
-			/* want reconstruct write, but need to get some data */
-			for (i=disks; i--;) {
-				dev = &sh->dev[i];
-				if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
-				    !test_bit(R5_LOCKED, &dev->flags) &&
-				    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags)) &&
-				    test_bit(R5_Insync, &dev->flags)) {
-					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-					{
-						PRINTK("Read_old block %d for Reconstruct\n", i);
-						set_bit(R5_LOCKED, &dev->flags);
-						set_bit(R5_Wantread, &dev->flags);
-						if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
-							sh->ops.count++;
-						s.locked++;
-					} else {
-						set_bit(STRIPE_DELAYED, &sh->state);
-						set_bit(STRIPE_HANDLE, &sh->state);
-					}
-				}
-			}
-		/* now if nothing is locked, and if we have enough data, we can start a write request */
-		/* since handle_stripe can be called at any time we need to handle the case
-		 * where a compute block operation has been submitted and then a subsequent
-		 * call wants to start a write request.  raid5_run_ops only handles the case where
-		 * compute block and postxor are requested simultaneously.  If this
-		 * is not the case then new writes need to be held off until the compute
-		 * completes.
-		 */
-		if ((s.req_compute || !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) &&
-			(s.locked == 0 && (rcw == 0 ||rmw == 0) &&
-			!test_bit(STRIPE_BIT_DELAY, &sh->state)))
-			s.locked += handle_write_operations5(sh, rcw == 0, 0);
-	}
+	/* Now to consider new write requests and what else, if anything should be read */
+	conf->cache_policy->handle_new_writes(sh, &s);
 
 	/* 1/ Maybe we need to check and possibly fix the parity for this stripe.
 	 *    Any reads will already have been scheduled, so we just see if enough data
 	 *    is available.
 	 * 2/ Hold off parity checks while parity dependent operations are in flight
-	 *    (conflicting writes are protected by the 'locked' variable)
+	 *    (conflicting writes are protected by the 'locked' and 'dirty' variables)
 	 */
-	if ((s.syncing && s.locked == 0 && !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
+	if ((s.syncing && s.locked == 0 && s.dirty == 0 &&
+		!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
 		!test_bit(STRIPE_INSYNC, &sh->state)) ||
 	    	test_bit(STRIPE_OP_CHECK, &sh->ops.pending) ||
 	    	test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
@@ -2451,7 +2552,7 @@ static void handle_stripe5(struct stripe_head *sh)
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, conf->raid_disks);
-		s.locked += handle_write_operations5(sh, 0, 1);
+		s.locked += raid5_wt_cache_handle_parity_updates(sh, 0, 1);
 	} else if (s.expanded && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
@@ -2885,8 +2986,9 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			set_bit(STRIPE_INSYNC, &sh->state);
 
 			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-				atomic_dec(&conf->preread_active_stripes);
-				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
+				atomic_dec(&conf->cache_policy->preread_active_stripes);
+				if (atomic_read(&conf->cache_policy->preread_active_stripes)
+					< IO_THRESHOLD)
 					md_wakeup_thread(conf->mddev->thread);
 			}
 		}
@@ -3164,22 +3266,6 @@ static void handle_stripe(struct stripe_head *sh, struct page *tmp_page)
 
 
 
-static void raid5_activate_delayed(raid5_conf_t *conf)
-{
-	if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD) {
-		while (!list_empty(&conf->delayed_list)) {
-			struct list_head *l = conf->delayed_list.next;
-			struct stripe_head *sh;
-			sh = list_entry(l, struct stripe_head, lru);
-			list_del_init(l);
-			clear_bit(STRIPE_DELAYED, &sh->state);
-			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-				atomic_inc(&conf->preread_active_stripes);
-			list_add_tail(&sh->lru, &conf->handle_list);
-		}
-	}
-}
-
 static void activate_bit_delay(raid5_conf_t *conf)
 {
 	/* device_lock is held */
@@ -3222,14 +3308,17 @@ static void raid5_unplug_device(request_queue_t *q)
 {
 	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
+	struct stripe_cache_policy *cp = conf->cache_policy;
 	unsigned long flags;
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 
 	if (blk_remove_plug(q)) {
 		conf->seq_flush++;
-		raid5_activate_delayed(conf);
+		if (cp->unplug_device)
+			cp->unplug_device(conf);
 	}
+
 	md_wakeup_thread(mddev->thread);
 
 	spin_unlock_irqrestore(&conf->device_lock, flags);
@@ -3944,11 +4033,8 @@ static void raid5d (mddev_t *mddev)
 			activate_bit_delay(conf);
 		}
 
-		if (list_empty(&conf->handle_list) &&
-		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
-		    !blk_queue_plugged(mddev->queue) &&
-		    !list_empty(&conf->delayed_list))
-			raid5_activate_delayed(conf);
+		if (conf->cache_policy->raid5d)
+			conf->cache_policy->raid5d(mddev, conf);
 
 		while ((bio = remove_bio_from_retry(conf))) {
 			int ok;
@@ -4150,16 +4236,22 @@ static int run(mddev_t *mddev)
 		if (!conf->spare_page)
 			goto abort;
 	}
+
+	#ifdef CONFIG_RAID5_CACHE_POLICY_WRITE_BACK
+	conf->cache_policy = &raid5_cache_policy_write_back;
+	#else
+	conf->cache_policy = &raid5_cache_policy_write_through;
+	#endif
+	
 	spin_lock_init(&conf->device_lock);
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
-	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
 	INIT_LIST_HEAD(&conf->inactive_list);
 	atomic_set(&conf->active_stripes, 0);
-	atomic_set(&conf->preread_active_stripes, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
+	conf->cache_policy->init(conf);
 
 	PRINTK("raid5: run(%s) called.\n", mdname(mddev));
 
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 54e2aa2..f00da23 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -224,8 +224,8 @@ struct stripe_head_state {
 #define STRIPE_HANDLE		2
 #define	STRIPE_SYNCING		3
 #define	STRIPE_INSYNC		4
-#define	STRIPE_PREREAD_ACTIVE	5
-#define	STRIPE_DELAYED		6
+#define	STRIPE_PREREAD_ACTIVE	5 /* wt cache state */
+#define	STRIPE_DELAYED		6 /* wt cache state */
 #define	STRIPE_DEGRADED		7
 #define	STRIPE_BIT_DELAY	8
 #define	STRIPE_EXPANDING	9
@@ -276,6 +276,81 @@ struct disk_info {
 	mdk_rdev_t	*rdev;
 };
 
+/**
+ * struct stripe_cache_policy - handle writethrough/writeback caching
+ * @post_run_biodrain:
+ *  wb: allows writes to be signalled complete once
+ *      they are in the stripe cache
+ *  wt: NULL
+ * @notify_release:
+ *  wb: transition inactive stripes with pending data to a dirty list
+ *  rather than the inactive list
+ *  wt: handle delayed stripes and issuing pre-read actions.
+ * @submit_pending_writes:
+ *  wb: only writeback when STRIPE_EVICT is set
+ *  wt: always writethrough after postxor completes
+ */
+
+/* wt = write through
+ * wb = write back
+ */
+struct stripe_cache_policy {
+	/* release_stripe - returns '1' if stripe was moved to cache-private list
+	 *  else '0'
+	 * [ called from __release_stripe under spin_lock_irq(&conf->device_lock) ]
+	 * wt: catch 'delayed' stripes and poke the 'preread' state machine
+	 * if necessary
+	 */
+	int (*release_stripe)(struct raid5_private_data *conf,
+		struct stripe_head *sh,	int handle);
+	/* complete_postxor_action
+	 * wt: check if this is the end of a rcw/rmw write request and set
+	 * the state bits accordingly.  set 'handle' and release.
+	 */
+	void (*complete_postxor_action)(void *stripe_head_ref);
+	/* submit_pending_writes
+	 * [ called from handle_stripe under spin_lock(&sh->lock) ]
+	 * wt: check if 'biodrain' and 'postxor' are complete and schedule writes
+	 * to the backing disks
+	 */
+	void (*submit_pending_writes)(struct stripe_head *sh,
+		struct stripe_head_state *s);
+	/* handle_new_writes
+	 * [ called from handle_stripe under spin_lock(&sh->lock) ]
+	 * wt: schedule reads to prepare for a rcw or rmw operation.  once preread
+	 * data is available lock the blocks and schedule '[prexor]+biodrain+postxor'
+	 */
+	void (*handle_new_writes)(struct stripe_head *sh,
+		struct stripe_head_state *s);
+	/* handle_completed_writes
+	 * [ called from handle_stripe under spin_lock(&sh->lock) ]
+	 * wt: call bi_end_io on all written blocks and perform general md/bitmap
+	 * post write housekeeping.
+	 */
+	struct bio *(*handle_completed_writes)(struct stripe_head *sh,
+		struct stripe_head_state *s);
+	/* raid5d
+	 * wt: check for stripes that can be taken off the delayed list
+	 */
+	void (*raid5d)(mddev_t *mddev, struct raid5_private_data *conf);
+	/* init
+	 * wt: initialize 'delayed_list' and 'preread_active_stripes'
+	 * wb: initialize 'dirty_list' and 'dirty_stripes'
+	 */
+	void (*init)(struct raid5_private_data *conf);
+	/* unplug_device
+	 * [ called from raid5_unplug_device under spin_lock_irqsave(&conf->device_lock) ]
+	 * wt: activate stripes on the delayed list
+	 */
+	void (*unplug_device)(struct raid5_private_data *conf);
+	union {
+		struct list_head delayed_list; /* wt: stripes that have plugged requests */
+	};
+	union {
+		atomic_t preread_active_stripes;
+	};
+};
+
 struct raid5_private_data {
 	struct hlist_head	*stripe_hashtbl;
 	mddev_t			*mddev;
@@ -284,6 +359,7 @@ struct raid5_private_data {
 	int			max_degraded;
 	int			raid_disks;
 	int			max_nr_stripes;
+	struct stripe_cache_policy *cache_policy;
 
 	/* used during an expand */
 	sector_t		expand_progress;	/* MaxSector when no expand happening */
@@ -293,11 +369,9 @@ struct raid5_private_data {
 	int			previous_raid_disks;
 
 	struct list_head	handle_list; /* stripes needing handling */
-	struct list_head	delayed_list; /* stripes that have plugged requests */
 	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
 	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
 	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
-	atomic_t		preread_active_stripes; /* stripes with scheduled io */
 	atomic_t		active_aligned_reads;
 
 	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
