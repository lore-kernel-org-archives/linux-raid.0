From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH RFC 3/4] md: writeback caching policy for raid5 [experimental]
Date: Tue, 10 Apr 2007 23:00:36 -0700
Message-ID: <20070411060036.15745.7016.stgit@dwillia2-linux.ch.intel.com>
References: <20070411055729.15745.51513.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070411055729.15745.51513.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In write-through mode bi_end_io is called once writes to the data disk(s)
and the parity disk have completed.

In write-back mode bi_end_io is called immediately after data has been
copied into the stripe cache, which also causes the stripe to be marked
dirty.  The STRIPE_DIRTY state implies that parity will need to be
reconstructed at eviction time.  In other words, the read-modify-write case
implemented for write-through mode is not supported; all writes are
reconstruct-writes.  An eviction brings the backing disks up to date with
data in the cache.  A dirty stripe is set for eviction when a new stripe
needs to be activated and there are no stripes on the inactive list.  All
dirty stripes are evicted when the array is being shutdown.

In its current implementation write-back mode acknowledges writes before
they have reached non-volatile media.  Unclean shutdowns will result in
filesystem corruption.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/Kconfig         |   13 ++
 drivers/md/md.c            |    2 
 drivers/md/raid5.c         |  354 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/raid/md_k.h  |    2 
 include/linux/raid/raid5.h |   31 ++++
 5 files changed, 400 insertions(+), 2 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 79a361e..7ab6c55 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -138,6 +138,19 @@ config MD_RAID456
 
 	  If unsure, say Y.
 
+config RAID5_CACHE_POLICY_WRITE_BACK
+	bool "EXPERIMENTAL: Set the raid cache policy to write-back"
+	default n
+	depends on EXPERIMENTAL && MD_RAID456
+	---help---
+	  Enable this feature if you want to test this experiemental
+	  caching policy instead of the default write-through.
+	  Do not enable this on a system with data that you care
+	  about.  Filesytem corruption will occur if an array in write-back
+	  mode is not shutdown cleanly.
+
+	  If unsure, say N.
+
 config MD_RAID5_RESHAPE
 	bool "Support adding drives to a raid-5 array"
 	depends on MD_RAID456
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 509171c..b83f434 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3344,6 +3344,8 @@ static int do_md_stop(mddev_t * mddev, int mode)
 			break;
 		case 0: /* disassemble */
 		case 2: /* stop */
+			if (mddev->pers->cache_flush)
+				mddev->pers->cache_flush(mddev);
 			bitmap_flush(mddev);
 			md_super_wait(mddev);
 			if (mddev->ro)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3b32a19..1a2d6b5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -267,6 +267,7 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 					     int pd_idx, int noblock)
 {
 	struct stripe_head *sh;
+	struct stripe_cache_policy *cp = conf->cache_policy;
 
 	PRINTK("get_stripe, sector %llu\n", (unsigned long long)sector);
 
@@ -280,6 +281,8 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 		if (!sh) {
 			if (!conf->inactive_blocked)
 				sh = get_free_stripe(conf);
+			if (!sh && cp->try_to_free_stripe)
+				cp->try_to_free_stripe(conf, 0);
 			if (noblock && sh == NULL)
 				break;
 			if (!sh) {
@@ -299,7 +302,8 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 			if (atomic_read(&sh->count)) {
 			  BUG_ON(!list_empty(&sh->lru));
 			} else {
-				if (!test_bit(STRIPE_HANDLE, &sh->state))
+				if (!test_bit(STRIPE_HANDLE, &sh->state) &&
+					!test_bit(STRIPE_EVICT, &sh->state))
 					atomic_inc(&conf->active_stripes);
 				if (list_empty(&sh->lru) &&
 				    !test_bit(STRIPE_EXPANDING, &sh->state))
@@ -668,6 +672,8 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
 	int pd_idx = sh->pd_idx, i;
+	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_cache_policy *cp = conf->cache_policy;
 
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (Wantprexor)
@@ -688,7 +694,8 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 				towrite = 1;
 		} else { /* rcw */
 			if (i!=pd_idx && dev->towrite &&
-				test_bit(R5_LOCKED, &dev->flags))
+				(test_bit(R5_LOCKED, &dev->flags) ||
+				test_bit(R5_DIRTY, &dev->flags)))
 				towrite = 1;
 		}
 
@@ -710,6 +717,9 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 		}
 	}
 
+	if (cp->complete_biodrain_action)
+		tx = cp->complete_biodrain_action(sh, tx);
+
 	return tx;
 }
 
@@ -1805,6 +1815,39 @@ static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
 }
 
 static int
+raid5_wb_cache_release_stripe(raid5_conf_t *conf, struct stripe_head *sh,
+	int handle)
+{
+	/* EVICT==HANDLE */
+	if (test_bit(STRIPE_EVICT, &sh->state) && !handle) {
+		set_bit(STRIPE_HANDLE, &sh->state);
+		return 0;
+	}
+
+	if (!handle) {
+		BUG_ON(sh->ops.pending);	
+		atomic_dec(&conf->active_stripes);
+		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
+			if (test_bit(STRIPE_DIRTY, &sh->state)) {
+				PRINTK("adding stripe %llu to dirty_list\n",
+					(unsigned long long)sh->sector);
+				list_add_tail(&sh->lru, &conf->cache_policy->dirty_list);
+			} else {
+				BUG_ON(test_bit(STRIPE_EVICT, &sh->state));
+				list_add_tail(&sh->lru, &conf->inactive_list);
+				wake_up(&conf->wait_for_stripe);
+			}
+			if (conf->retry_read_aligned)
+				md_wakeup_thread(conf->mddev->thread);
+		}
+		
+		return 1;
+	}
+
+	return 0;
+}
+
+static int
 raid5_wt_cache_release_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 	int handle)
 {
@@ -1875,6 +1918,19 @@ static void raid5_wt_cache_complete_postxor_action(void *stripe_head_ref)
 	release_stripe(sh);
 }
 
+static void raid5_wb_cache_complete_postxor_action(void *stripe_head_ref)
+{
+	struct stripe_head *sh = stripe_head_ref;
+
+	PRINTK("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	set_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
+	set_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+	set_bit(STRIPE_HANDLE, &sh->state);
+	release_stripe(sh);
+}
+
 static struct bio *
 raid5_wt_cache_handle_completed_writes(struct stripe_head *sh,
 	struct stripe_head_state *s)
@@ -1932,6 +1988,34 @@ raid5_wt_cache_handle_completed_writes(struct stripe_head *sh,
 	return return_bi;
 }
 
+static struct bio *
+raid5_wb_cache_handle_completed_writes(struct stripe_head *sh,
+	struct stripe_head_state *s)
+{
+	int i;
+	raid5_conf_t *conf = sh->raid_conf;
+
+	/* the stripe is consistent with the disks when STRIPE_EVICT is sampled
+	 * set and there are no dirty blocks
+	 */
+	if (test_bit(STRIPE_EVICT, &sh->state) &&
+		s->locked == 0 && s->dirty == 0) {
+
+		PRINTK("%s: stripe %llu\n", __FUNCTION__,
+			(unsigned long long)sh->sector);
+
+		for (i = sh->write_requests_pending; i--; )
+			md_write_end(conf->mddev);
+		bitmap_endwrite(conf->mddev->bitmap, sh->sector, STRIPE_SECTORS,
+			!test_bit(STRIPE_DEGRADED, &sh->state), 0);
+		clear_bit(STRIPE_EVICT, &sh->state);
+		atomic_dec(&conf->cache_policy->evict_active_stripes);
+	}
+
+	return NULL;
+}
+
+
 static void
 raid5_wt_cache_submit_pending_writes(struct stripe_head *sh,
 	struct stripe_head_state *s)
@@ -2115,7 +2199,230 @@ static void raid5_wt_cache_unplug_device(raid5_conf_t *conf)
 	raid5_wt_cache_activate_delayed(conf);
 }
 
+static void raid5_wb_cache_init(raid5_conf_t *conf)
+{
+	atomic_set(&conf->cache_policy->evict_active_stripes, 0);
+	INIT_LIST_HEAD(&conf->cache_policy->dirty_list);
+}
+
+static void
+raid5_wb_cache_submit_pending_writes(struct stripe_head *sh,
+	struct stripe_head_state *s)
+{
+	int pd_idx = sh->pd_idx;
+
+	if (test_bit(STRIPE_EVICT, &sh->state) &&
+		s->dirty && test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
+		int i;
+
+		PRINTK("%s: stripe %llu\n", __FUNCTION__,
+			(unsigned long long)sh->sector);
+
+		/* All the 'dirty' buffers and the parity block are ready to be
+		 * written back to disk
+		 */
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags));
+		for (i=sh->disks; i--;) {
+			struct r5dev *dev = &sh->dev[i];
+			/* transitition write-back 'dirty' blocks to
+			 * write-through 'dirty' blocks
+			 */
+			if (test_bit(R5_LOCKED, &dev->flags) &&
+				(i == pd_idx || test_bit(R5_DIRTY, &dev->flags))) {
+				PRINTK("Writing block %d\n", i);
+				set_bit(R5_Wantwrite, &dev->flags);
+				if (test_and_clear_bit(R5_DIRTY, &dev->flags))
+					s->dirty--;
+				if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+					sh->ops.count++;
+				if (!test_bit(R5_Insync, &dev->flags) ||
+					(i==pd_idx && s->failed == 0))
+					set_bit(STRIPE_INSYNC, &sh->state);
+			}
+		}
+
+		BUG_ON(s->dirty);
+		clear_bit(STRIPE_DIRTY, &sh->state);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+	}
+
+}
+
+static void
+raid5_wb_cache_handle_new_writes(struct stripe_head *sh, struct stripe_head_state *s)
+{
+	int i, disks = sh->disks;
+	int pd_idx = sh->pd_idx;
+	struct r5dev *dev;
+
+	/* allow new data into the cache once dependent operations are clear */
+	if (s->to_write && !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
+		!test_bit(STRIPE_OP_CHECK, &sh->ops.pending) &&
+		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
+
+		PRINTK("%s: stripe %llu schedule biodrain\n", __FUNCTION__,
+			(unsigned long long)sh->sector);
+
+		for (i=disks; i--;) {
+			dev = &sh->dev[i];
+			if (dev->towrite && !test_bit(R5_LOCKED, &dev->flags)) {
+				set_bit(R5_DIRTY, &dev->flags);
+				s->dirty++;
+				BUG_ON(!test_bit(R5_UPTODATE, &dev->flags) &&
+					!test_bit(R5_OVERWRITE, &dev->flags));
+			}
+		}
+
+		clear_bit(STRIPE_INSYNC, &sh->state);
+		set_bit(STRIPE_DIRTY, &sh->state);
+		set_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
+		sh->ops.count++;
+	}
+
+	/* check if we need to preread data to satisfy an eviction */
+	if (!s->to_write && test_bit(STRIPE_EVICT, &sh->state) &&
+		test_bit(STRIPE_DIRTY, &sh->state))
+		for (i=disks; i--;) {
+			dev = &sh->dev[i];
+			if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
+			    !test_bit(R5_LOCKED, &dev->flags) &&
+			    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags)) &&
+			    test_bit(R5_Insync, &dev->flags)) {
+				PRINTK("Read_old block %d for eviction\n", i);
+				set_bit(R5_LOCKED, &dev->flags);
+				s->locked++;
+				set_bit(R5_Wantread, &dev->flags);
+				if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+					sh->ops.count++;
+			}
+		}
+
+	/* now if nothing is locked we can start a stripe-clean write request */
+	if (s->locked == 0 && !s->to_write &&
+		test_bit(STRIPE_EVICT, &sh->state) &&
+		test_bit(STRIPE_DIRTY, &sh->state) &&
+		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
+		for (i=disks ; i-- ;) {
+			dev = &sh->dev[i];
+			/* only the dirty blocks and parity will be written back */
+			if (test_bit(R5_DIRTY, &dev->flags) || i == pd_idx) {
+				set_bit(R5_LOCKED, &sh->dev[i].flags);
+				s->locked++;
+			}
+		}
+
+		set_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+		sh->ops.count++;
+	}
+}
+
+static void raid5_wb_cache_complete_biodrain(void *stripe_head_ref)
+{
+	struct stripe_head *sh = stripe_head_ref;
+	struct bio *return_bi = NULL, *bi;
+	int written = 0, i;
+	raid5_conf_t *conf = sh->raid_conf;
+
+	PRINTK("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	/* clear complete biodrain operations */
+	for (i=sh->disks; i--; )
+		if (sh->dev[i].written) {
+			struct r5dev *dev = &sh->dev[i];
+			struct bio *wbi, *wbi2;
+			written++;
+			PRINTK("%s: Return write for disc %d\n",
+				__FUNCTION__, i);
+			spin_lock_irq(&conf->device_lock);
+			set_bit(R5_UPTODATE, &dev->flags);
+			wbi = dev->written;
+			dev->written = NULL;
+			while (wbi && wbi->bi_sector < dev->sector + STRIPE_SECTORS) {
+				wbi2 = r5_next_bio(wbi, dev->sector);
+				if (--wbi->bi_phys_segments == 0) {
+					sh->write_requests_pending++;
+					wbi->bi_next = return_bi;
+					return_bi = wbi;
+				}
+				wbi = wbi2;
+			}
+			spin_unlock_irq(&conf->device_lock);
+		}
+
+	if (likely(written)) {
+		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
+		/* no need to clear 'complete' it was never set */
+	} else
+		BUG();
+
+	while ((bi=return_bi)) {
+		int bytes = bi->bi_size;
+
+		return_bi = bi->bi_next;
+		bi->bi_next = NULL;
+		bi->bi_size = 0;
+		bi->bi_end_io(bi, bytes,
+			      test_bit(BIO_UPTODATE, &bi->bi_flags)
+			        ? 0 : -EIO);
+	}
+
+	release_stripe(sh);
+}
+
+static struct dma_async_tx_descriptor *
+raid5_wb_cache_complete_biodrain_action(struct stripe_head *sh,
+	struct dma_async_tx_descriptor *tx)
+{
+	PRINTK("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	atomic_inc(&sh->count);
+	tx = async_trigger_callback(ASYNC_TX_DEP_ACK | ASYNC_TX_ACK, tx,
+		raid5_wb_cache_complete_biodrain, sh);
+	return tx;
+}
+
+static struct stripe_head *
+raid5_wb_cache_try_to_free_stripe(raid5_conf_t *conf, int flush)
+{
+	struct stripe_head *sh = NULL;
+	struct list_head *first;
+	struct stripe_cache_policy *cp = conf->cache_policy;
+
+	CHECK_DEVLOCK();
+	if (list_empty(&cp->dirty_list))
+		goto out;
+
+	/* if we are not flushing only evict one stripe at a time
+	 * and plug the device to wait for more writers
+	 */
+	if (!flush && atomic_read(&cp->evict_active_stripes)) {
+		blk_plug_device(conf->mddev->queue);
+		goto out;
+	}
+
+	first = cp->dirty_list.next;
+	sh = list_entry(first, struct stripe_head, lru);
+	list_del_init(first);
+	atomic_inc(&conf->active_stripes);
+	set_bit(STRIPE_EVICT, &sh->state);
+	atomic_inc(&cp->evict_active_stripes);
+	set_bit(STRIPE_HANDLE, &sh->state);
+	atomic_inc(&sh->count);
+	BUG_ON(atomic_read(&sh->count)!= 1);
+	__release_stripe(conf, sh);
+	PRINTK("stripe %llu queued for eviction\n",
+		(unsigned long long)sh->sector);
+out:
+	return sh;
+}
+
 static struct stripe_cache_policy raid5_cache_policy_write_through = {
+	.complete_biodrain_action = NULL,
 	.release_stripe = raid5_wt_cache_release_stripe,
 	.complete_postxor_action = raid5_wt_cache_complete_postxor_action,
 	.submit_pending_writes = raid5_wt_cache_submit_pending_writes,
@@ -2124,6 +2431,21 @@ static struct stripe_cache_policy raid5_cache_policy_write_through = {
 	.raid5d = raid5_wt_cache_raid5d,
 	.init = raid5_wt_cache_init,
 	.unplug_device = raid5_wt_cache_unplug_device,
+	.try_to_free_stripe = NULL,
+};
+
+static struct stripe_cache_policy raid5_cache_policy_write_back = {
+	.complete_biodrain_action = raid5_wb_cache_complete_biodrain_action,
+	.release_stripe = raid5_wb_cache_release_stripe,
+	.complete_postxor_action = raid5_wb_cache_complete_postxor_action,
+	.submit_pending_writes = raid5_wb_cache_submit_pending_writes,
+	.handle_new_writes = raid5_wb_cache_handle_new_writes,
+	.handle_completed_writes = raid5_wb_cache_handle_completed_writes,
+	.raid5d = NULL,
+	.init = raid5_wb_cache_init,
+	.unplug_device = NULL,
+	.try_to_free_stripe = raid5_wb_cache_try_to_free_stripe,
+
 };
 
 /*
@@ -2193,6 +2515,7 @@ static void handle_stripe5(struct stripe_head *sh)
 		/* now count some things */
 		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
 		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
+		if (test_bit(R5_DIRTY, &dev->flags)) s.dirty++;
 
 		if (test_bit(R5_Wantfill, &dev->flags))
 			s.to_fill++;
@@ -2226,6 +2549,12 @@ static void handle_stripe5(struct stripe_head *sh)
 	if (s.to_fill && !test_and_set_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
 		sh->ops.count++;
 
+	/* do we need to evict the stripe for writeback caching? */
+	if (s.dirty && s.syncing) {
+		set_bit(STRIPE_EVICT, &sh->state);
+		set_bit(STRIPE_HANDLE, &sh->state);
+	}
+		
 	PRINTK("locked=%d dirty=%d uptodate=%d to_read=%d"
 		" to_write=%d to_fill=%d failed=%d failed_num=%d\n",
 		s.locked, s.dirty, s.uptodate, s.to_read, s.to_write, s.to_fill,
@@ -4801,6 +5130,24 @@ static void raid5_quiesce(mddev_t *mddev, int state)
 	}
 }
 
+static void raid5_cache_flush(mddev_t *mddev)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	struct stripe_cache_policy *cp = conf->cache_policy;
+	struct stripe_head *sh;
+	unsigned long flags;
+
+	if (cp->try_to_free_stripe) {
+		spin_lock_irqsave(&conf->device_lock, flags);
+		do {
+			sh = cp->try_to_free_stripe(conf, 1);
+		} while (sh != NULL);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+		raid5_quiesce(mddev, 1);
+		raid5_quiesce(mddev, 0);
+	}
+}
+
 static struct mdk_personality raid6_personality =
 {
 	.name		= "raid6",
@@ -4821,6 +5168,7 @@ static struct mdk_personality raid6_personality =
 	.start_reshape  = raid5_start_reshape,
 #endif
 	.quiesce	= raid5_quiesce,
+	.cache_flush	= raid5_cache_flush
 };
 static struct mdk_personality raid5_personality =
 {
@@ -4842,6 +5190,7 @@ static struct mdk_personality raid5_personality =
 	.start_reshape  = raid5_start_reshape,
 #endif
 	.quiesce	= raid5_quiesce,
+	.cache_flush	= raid5_cache_flush
 };
 
 static struct mdk_personality raid4_personality =
@@ -4864,6 +5213,7 @@ static struct mdk_personality raid4_personality =
 	.start_reshape  = raid5_start_reshape,
 #endif
 	.quiesce	= raid5_quiesce,
+	.cache_flush	= raid5_cache_flush
 };
 
 static int __init raid5_init(void)
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index de72c49..5455de9 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -287,6 +287,8 @@ struct mdk_personality
 	 * others - reserved
 	 */
 	void (*quiesce) (mddev_t *mddev, int state);
+	/* notifies a writeback cache to dump its dirty blocks */
+	void (*cache_flush)(mddev_t *mddev);
 };
 
 
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index f00da23..560d460 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -165,6 +165,7 @@ struct stripe_head {
 	spinlock_t		lock;
 	int			bm_seq;	/* sequence number for bitmap flushes */
 	int			disks;			/* disks in stripe */
+	int			write_requests_pending;
 	struct stripe_operations {
 		unsigned long	   pending;  /* pending operations (set for request->issue->complete) */
 		unsigned long	   ack;	     /* submitted operations (set for issue->complete */
@@ -209,6 +210,7 @@ struct stripe_head_state {
 #define	R5_Wantcompute	11	/* compute_block in progress treat as uptodate */
 #define	R5_Wantfill	12	/* dev->toread contains a bio that needs filling */
 #define	R5_Wantprexor	13	/* distinguish blocks ready for rmw from other "towrites" */
+#define	R5_DIRTY	14	/* data entered the cache without a parity calculation */
 
 /*
  * Write method
@@ -231,6 +233,8 @@ struct stripe_head_state {
 #define	STRIPE_EXPANDING	9
 #define	STRIPE_EXPAND_SOURCE	10
 #define	STRIPE_EXPAND_READY	11
+#define STRIPE_DIRTY		12 /* wb cache state */
+#define STRIPE_EVICT		13 /* wb cache action */
 
 /*
  * Operations flags (in issue order)
@@ -295,23 +299,35 @@ struct disk_info {
  * wb = write back
  */
 struct stripe_cache_policy {
+	/* complete_biodrain_action
+	 * wt: n/a
+	 * wb: inject bi_end_io calls once data is copied into the cache
+	 */
+	struct dma_async_tx_descriptor *(*complete_biodrain_action)
+		(struct stripe_head *sh, struct dma_async_tx_descriptor *tx);
 	/* release_stripe - returns '1' if stripe was moved to cache-private list
 	 *  else '0'
 	 * [ called from __release_stripe under spin_lock_irq(&conf->device_lock) ]
 	 * wt: catch 'delayed' stripes and poke the 'preread' state machine
 	 * if necessary
+	 * wb: store inactive+dirty stripes on a private list, to be flushed
+	 * by get_active_stripe pressure or a sync-request
 	 */
 	int (*release_stripe)(struct raid5_private_data *conf,
 		struct stripe_head *sh,	int handle);
 	/* complete_postxor_action
 	 * wt: check if this is the end of a rcw/rmw write request and set
 	 * the state bits accordingly.  set 'handle' and release.
+	 * wb: simply record the completion of 'postxor', set 'handle' and release
 	 */
 	void (*complete_postxor_action)(void *stripe_head_ref);
 	/* submit_pending_writes
 	 * [ called from handle_stripe under spin_lock(&sh->lock) ]
 	 * wt: check if 'biodrain' and 'postxor' are complete and schedule writes
 	 * to the backing disks
+	 * wb: if the stripe is set to be evicted and parity is uptodate transition
+	 * 'update+dirty' blocks to 'uptodate+locked' blocks (i.e. wt dirty) and
+	 * schedule writes to the backing disks
 	 */
 	void (*submit_pending_writes)(struct stripe_head *sh,
 		struct stripe_head_state *s);
@@ -319,6 +335,9 @@ struct stripe_cache_policy {
 	 * [ called from handle_stripe under spin_lock(&sh->lock) ]
 	 * wt: schedule reads to prepare for a rcw or rmw operation.  once preread
 	 * data is available lock the blocks and schedule '[prexor]+biodrain+postxor'
+	 * wb: if the stripe is set to be evicted schedule reads to prepare a rcw.
+	 * once preread data is available schedule a 'postxor' to update parity.
+	 * if the stripe is not set to be evicted just schedule a 'biodrain'
 	 */
 	void (*handle_new_writes)(struct stripe_head *sh,
 		struct stripe_head_state *s);
@@ -326,11 +345,13 @@ struct stripe_cache_policy {
 	 * [ called from handle_stripe under spin_lock(&sh->lock) ]
 	 * wt: call bi_end_io on all written blocks and perform general md/bitmap
 	 * post write housekeeping.
+	 * wb: perform general md/bitmap post write housekeeping
 	 */
 	struct bio *(*handle_completed_writes)(struct stripe_head *sh,
 		struct stripe_head_state *s);
 	/* raid5d
 	 * wt: check for stripes that can be taken off the delayed list
+	 * wb: n/a
 	 */
 	void (*raid5d)(mddev_t *mddev, struct raid5_private_data *conf);
 	/* init
@@ -341,13 +362,23 @@ struct stripe_cache_policy {
 	/* unplug_device
 	 * [ called from raid5_unplug_device under spin_lock_irqsave(&conf->device_lock) ]
 	 * wt: activate stripes on the delayed list
+	 * wb: n/a
 	 */
 	void (*unplug_device)(struct raid5_private_data *conf);
+	/* try_to_free_stripe
+	 * [ called from get_active_stripe and raid5_cache_flush ]
+	 * wt: n/a
+	 * wb: evict the oldest dirty stripe to refill the inactive list
+	 */
+	struct stripe_head *(*try_to_free_stripe)(struct raid5_private_data *conf,
+		int flush);
 	union {
 		struct list_head delayed_list; /* wt: stripes that have plugged requests */
+		struct list_head dirty_list; /* wb: inactive stripes with dirty data */
 	};
 	union {
 		atomic_t preread_active_stripes;
+		atomic_t evict_active_stripes;
 	};
 };
 
