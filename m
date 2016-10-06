From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 4/8] md/r5cache: write part of r5cache
Date: Thu, 6 Oct 2016 00:14:12 -0700
Message-ID: <20161006071416.3295093-5-songliubraving@fb.com>
References: <20161006071416.3295093-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161006071416.3295093-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

This is the write part of r5cache. The cache is integrated with
stripe cache of raid456. It leverages code of r5l_log to write
data to journal device.

r5cache split current write path into 2 parts: the write path
and the reclaim path. The write path is as following:
1. write data to journal
   (r5c_handle_stripe_dirtying, r5c_cache_data)
2. call bio_endio
   (r5c_handle_data_cached, r5c_return_dev_pending_writes).

Then the reclaim path is as:
1. Freeze the stripe (r5c_freeze_stripe_for_reclaim)
2. Calcualte parity (reconstruct or RMW)
3. Write parity (and maybe some other data) to journal device
4. Write data and parity to RAID disks

Reclaim path of the cache is implemented in the next patch.

With r5cache, write operation does not wait for parity calculation
and write out, so the write latency is lower (1 write to journal
device vs. read and then write to raid disks). Also, r5cache will
reduce RAID overhead (multipile IO due to read-modify-write of
parity) and provide more opportunities of full stripe writes.

This patch adds 2 flags to stripe_head.state:
 - STRIPE_R5C_PARTIAL_STRIPE,
 - STRIPE_R5C_FULL_STRIPE,

Instead of inactive_list, stripes with cached data are tracked in
r5conf->r5c_full_stripe_list and r5conf->r5c_partial_stripe_list.
STRIPE_R5C_FULL_STRIPE and STRIPE_R5C_PARTIAL_STRIPE are flags for
stripes in these lists. Note: stripes in r5c_full/partial_stripe_list
are not considered as "active".

For RMW, the code allocates an extra page for each data block
being updated.  This is stored in r5dev->page and the old data
is read into it.  Then the prexor calculation subtracts ->page
from the parity block, and the reconstruct calculation adds the
->orig_page data back into the parity block.

r5cache naturally excludes SkipCopy. With R5_Wantcache bit set,
async_copy_data will not skip copy.

There are some known limitations of the cache implementation:

1. Write cache only covers full page writes (R5_OVERWRITE). Writes
   of smaller granularity are write through.
2. Only one log io (sh->log_io) for each stripe at anytime. Later
   writes for the same stripe have to wait. This can be improved by
   moving log_io to r5dev.
3. With writeback cache, read path must enter state machine, which
   is a significant bottleneck for some workloads.
4. There is no per stripe checkpoint (with r5l_payload_flush) in
   the log, so recovery code has to replay more than necessary data
   (sometimes all the log from last_checkpoint). This reduces
   availability of the array.

This patch includes a fix proposed by ZhengYuan Liu
<liuzhengyuan@kylinos.cn>

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 204 +++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/raid5.c       | 137 ++++++++++++++++++++++++++-----
 drivers/md/raid5.h       |  22 +++++
 3 files changed, 336 insertions(+), 27 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 9e05850..92d3d7b 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -20,6 +20,7 @@
 #include <linux/random.h>
 #include "md.h"
 #include "raid5.h"
+#include "bitmap.h"
 
 /*
  * metadata/data stored in disk with 4k size unit (a block) regardless
@@ -217,6 +218,44 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
 }
 
+static void
+r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev,
+			      struct bio_list *return_bi)
+{
+	struct bio *wbi, *wbi2;
+
+	wbi = dev->written;
+	dev->written = NULL;
+	while (wbi && wbi->bi_iter.bi_sector <
+	       dev->sector + STRIPE_SECTORS) {
+		wbi2 = r5_next_bio(wbi, dev->sector);
+		if (!raid5_dec_bi_active_stripes(wbi)) {
+			md_write_end(conf->mddev);
+			bio_list_add(return_bi, wbi);
+		}
+		wbi = wbi2;
+	}
+}
+
+void r5c_handle_cached_data_endio(struct r5conf *conf,
+	  struct stripe_head *sh, int disks, struct bio_list *return_bi)
+{
+	int i;
+
+	for (i = sh->disks; i--; ) {
+		if (test_bit(R5_InCache, &sh->dev[i].flags) &&
+		    sh->dev[i].written) {
+			set_bit(R5_UPTODATE, &sh->dev[i].flags);
+			r5c_return_dev_pending_writes(conf, &sh->dev[i],
+						      return_bi);
+			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+					STRIPE_SECTORS,
+					!test_bit(STRIPE_DEGRADED, &sh->state),
+					0);
+		}
+	}
+}
+
 /*
  * Freeze the stripe, thus send the stripe into reclaim path.
  *
@@ -233,6 +272,48 @@ void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh)
 		return;
 	WARN_ON(test_bit(STRIPE_R5C_FROZEN, &sh->state));
 	set_bit(STRIPE_R5C_FROZEN, &sh->state);
+
+	if (log->r5c_state == R5C_STATE_WRITE_THROUGH)
+		return;
+
+	if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+		atomic_inc(&conf->preread_active_stripes);
+
+	if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state)) {
+		BUG_ON(atomic_read(&conf->r5c_cached_partial_stripes) == 0);
+		atomic_dec(&conf->r5c_cached_partial_stripes);
+	}
+
+	if (test_and_clear_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
+		BUG_ON(atomic_read(&conf->r5c_cached_full_stripes) == 0);
+		atomic_dec(&conf->r5c_cached_full_stripes);
+	}
+}
+
+static void r5c_handle_data_cached(struct stripe_head *sh)
+{
+	int i;
+
+	for (i = sh->disks; i--; )
+		if (test_and_clear_bit(R5_Wantcache, &sh->dev[i].flags)) {
+			set_bit(R5_InCache, &sh->dev[i].flags);
+			clear_bit(R5_LOCKED, &sh->dev[i].flags);
+			atomic_inc(&sh->dev_in_cache);
+		}
+}
+
+/*
+ * this journal write must contain full parity,
+ * it may also contain some data pages
+ */
+static void r5c_handle_parity_cached(struct stripe_head *sh)
+{
+	int i;
+
+	for (i = sh->disks; i--; )
+		if (test_bit(R5_InCache, &sh->dev[i].flags))
+			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+	set_bit(STRIPE_R5C_WRITTEN, &sh->state);
 }
 
 static void r5c_finish_cache_stripe(struct stripe_head *sh)
@@ -242,8 +323,10 @@ static void r5c_finish_cache_stripe(struct stripe_head *sh)
 	if (log->r5c_state == R5C_STATE_WRITE_THROUGH) {
 		BUG_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
 		set_bit(STRIPE_R5C_WRITTEN, &sh->state);
-	} else
-		BUG(); /* write back logic in next patch */
+	} else if (test_bit(STRIPE_R5C_FROZEN, &sh->state))
+		r5c_handle_parity_cached(sh);
+	else
+		r5c_handle_data_cached(sh);
 }
 
 static void r5l_io_run_stripes(struct r5l_io_unit *io)
@@ -483,7 +566,8 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	io = log->current_io;
 
 	for (i = 0; i < sh->disks; i++) {
-		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
+		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags) &&
+		    !test_bit(R5_Wantcache, &sh->dev[i].flags))
 			continue;
 		if (i == sh->pd_idx || i == sh->qd_idx)
 			continue;
@@ -514,7 +598,6 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	return 0;
 }
 
-static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
 /*
  * running in raid5d, where reclaim could wait for raid5d too (when it flushes
  * data from log to raid disks), so we shouldn't wait for reclaim here
@@ -544,6 +627,10 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 
 		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
 			continue;
+
+		if (test_bit(R5_InCache, &sh->dev[i].flags))
+			continue;
+
 		write_disks++;
 		/* checksum is already calculated in last run */
 		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
@@ -809,7 +896,6 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 	}
 }
 
-
 static void r5l_do_reclaim(struct r5l_log *log)
 {
 	sector_t reclaim_target = xchg(&log->reclaim_target, 0);
@@ -872,7 +958,7 @@ static void r5l_reclaim_thread(struct md_thread *thread)
 	r5l_do_reclaim(log);
 }
 
-static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
+void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 {
 	unsigned long target;
 	unsigned long new = (unsigned long)space; /* overflow in theory */
@@ -1191,6 +1277,8 @@ int r5c_handle_stripe_dirtying(struct r5conf *conf,
 			       int disks)
 {
 	struct r5l_log *log = conf->log;
+	int i;
+	struct r5dev *dev;
 
 	if (!log || test_bit(STRIPE_R5C_FROZEN, &sh->state))
 		return -EAGAIN;
@@ -1201,21 +1289,121 @@ int r5c_handle_stripe_dirtying(struct r5conf *conf,
 		r5c_freeze_stripe_for_reclaim(sh);
 		return -EAGAIN;
 	}
-	BUG();  /* write back logic in next commit */
+
+	s->to_cache = 0;
+
+	for (i = disks; i--; ) {
+		dev = &sh->dev[i];
+		/* if none-overwrite, use the reclaim path (write through) */
+		if (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags) &&
+		    !test_bit(R5_InCache, &dev->flags)) {
+			r5c_freeze_stripe_for_reclaim(sh);
+			return -EAGAIN;
+		}
+	}
+
+	for (i = disks; i--; ) {
+		dev = &sh->dev[i];
+		if (dev->towrite) {
+			set_bit(R5_Wantcache, &dev->flags);
+			set_bit(R5_Wantdrain, &dev->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+			s->to_cache++;
+		}
+	}
+
+	if (s->to_cache)
+		set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
+
 	return 0;
 }
 
 /*
  * clean up the stripe (clear STRIPE_R5C_FROZEN etc.) after the stripe is
  * committed to RAID disks
-*/
+ */
 void r5c_handle_stripe_written(struct r5conf *conf,
 			       struct stripe_head *sh)
 {
+	int i;
+	int do_wakeup = 0;
+
 	if (!test_and_clear_bit(STRIPE_R5C_WRITTEN, &sh->state))
 		return;
 	WARN_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
 	clear_bit(STRIPE_R5C_FROZEN, &sh->state);
+
+	if (conf->log->r5c_state == R5C_STATE_WRITE_THROUGH)
+		return;
+
+	for (i = sh->disks; i--; ) {
+		if (test_and_clear_bit(R5_InCache, &sh->dev[i].flags))
+			atomic_dec(&sh->dev_in_cache);
+		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+			do_wakeup = 1;
+	}
+
+	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
+		if (atomic_dec_and_test(&conf->pending_full_writes))
+			md_wakeup_thread(conf->mddev->thread);
+
+	if (do_wakeup)
+		wake_up(&conf->wait_for_overlap);
+}
+
+int
+r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
+	       struct stripe_head_state *s)
+{
+	int pages;
+	int reserve;
+	int i;
+	int ret = 0;
+	int page_count = 0;
+
+	BUG_ON(!log);
+
+	for (i = 0; i < sh->disks; i++) {
+		void *addr;
+
+		if (!test_bit(R5_Wantcache, &sh->dev[i].flags))
+			continue;
+		addr = kmap_atomic(sh->dev[i].page);
+		sh->dev[i].log_checksum = crc32c_le(log->uuid_checksum,
+						    addr, PAGE_SIZE);
+		kunmap_atomic(addr);
+		page_count++;
+	}
+	WARN_ON(page_count != s->to_cache);
+	pages = s->to_cache;
+
+	/*
+	 * The stripe must enter state machine again to call endio, so
+	 * don't delay.
+	 */
+	clear_bit(STRIPE_DELAYED, &sh->state);
+	atomic_inc(&sh->count);
+
+	mutex_lock(&log->io_mutex);
+	/* meta + data */
+	reserve = (1 + pages) << (PAGE_SHIFT - 9);
+	if (!r5l_has_free_space(log, reserve)) {
+		spin_lock(&log->no_space_stripes_lock);
+		list_add_tail(&sh->log_list, &log->no_space_stripes);
+		spin_unlock(&log->no_space_stripes_lock);
+
+		r5l_wake_reclaim(log, reserve);
+	} else {
+		ret = r5l_log_stripe(log, sh, pages, 0);
+		if (ret) {
+			spin_lock_irq(&log->io_list_lock);
+			list_add_tail(&sh->log_list, &log->no_mem_stripes);
+			spin_unlock_irq(&log->io_list_lock);
+		}
+	}
+
+	mutex_unlock(&log->io_mutex);
+	return 0;
 }
 
 static int r5l_load_log(struct r5l_log *log)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2e3e61a..27fd183 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -245,8 +245,25 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			    < IO_THRESHOLD)
 				md_wakeup_thread(conf->mddev->thread);
 		atomic_dec(&conf->active_stripes);
-		if (!test_bit(STRIPE_EXPANDING, &sh->state))
-			list_add_tail(&sh->lru, temp_inactive_list);
+		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
+			if (atomic_read(&sh->dev_in_cache) == 0) {
+				list_add_tail(&sh->lru, temp_inactive_list);
+			} else if (atomic_read(&sh->dev_in_cache) ==
+				   conf->raid_disks - conf->max_degraded) {
+				/* full stripe */
+				if (!test_and_set_bit(STRIPE_R5C_FULL_STRIPE, &sh->state))
+					atomic_inc(&conf->r5c_cached_full_stripes);
+				if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state))
+					atomic_dec(&conf->r5c_cached_partial_stripes);
+				list_add_tail(&sh->lru, &conf->r5c_full_stripe_list);
+			} else {
+				/* partial stripe */
+				if (!test_and_set_bit(STRIPE_R5C_PARTIAL_STRIPE,
+						      &sh->state))
+					atomic_inc(&conf->r5c_cached_partial_stripes);
+				list_add_tail(&sh->lru, &conf->r5c_partial_stripe_list);
+			}
+		}
 	}
 }
 
@@ -830,6 +847,11 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
+	if (s->to_cache) {
+		r5c_cache_data(conf->log, sh, s);
+		return;
+	}
+
 	if (r5l_write_stripe(conf->log, sh) == 0)
 		return;
 	for (i = disks; i--; ) {
@@ -1044,7 +1066,7 @@ again:
 static struct dma_async_tx_descriptor *
 async_copy_data(int frombio, struct bio *bio, struct page **page,
 	sector_t sector, struct dma_async_tx_descriptor *tx,
-	struct stripe_head *sh)
+	struct stripe_head *sh, int no_skipcopy)
 {
 	struct bio_vec bvl;
 	struct bvec_iter iter;
@@ -1084,7 +1106,8 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 			if (frombio) {
 				if (sh->raid_conf->skip_copy &&
 				    b_offset == 0 && page_offset == 0 &&
-				    clen == STRIPE_SIZE)
+				    clen == STRIPE_SIZE &&
+				    !no_skipcopy)
 					*page = bio_page;
 				else
 					tx = async_memcpy(*page, bio_page, page_offset,
@@ -1166,7 +1189,7 @@ static void ops_run_biofill(struct stripe_head *sh)
 			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, &dev->page,
-					dev->sector, tx, sh);
+						     dev->sector, tx, sh, 0);
 				rbi = r5_next_bio(rbi, dev->sector);
 			}
 		}
@@ -1293,7 +1316,8 @@ static int set_syndrome_sources(struct page **srcs,
 		if (i == sh->qd_idx || i == sh->pd_idx ||
 		    (srctype == SYNDROME_SRC_ALL) ||
 		    (srctype == SYNDROME_SRC_WANT_DRAIN &&
-		     test_bit(R5_Wantdrain, &dev->flags)) ||
+		     (test_bit(R5_Wantdrain, &dev->flags) ||
+		      test_bit(R5_InCache, &dev->flags))) ||
 		    (srctype == SYNDROME_SRC_WRITTEN &&
 		     dev->written))
 			srcs[slot] = sh->dev[i].page;
@@ -1472,9 +1496,25 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 static void ops_complete_prexor(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
+	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
+
+	if (!r5c_is_writeback(sh->raid_conf->log))
+		return;
+
+	/*
+	 * raid5-cache write back uses orig_page during prexor. after prexor,
+	 * it is time to free orig_page
+	 */
+	for (i = sh->disks; i--; )
+		if (sh->dev[i].page != sh->dev[i].orig_page) {
+			struct page *p = sh->dev[i].page;
+
+			sh->dev[i].page = sh->dev[i].orig_page;
+			put_page(p);
+		}
 }
 
 static struct dma_async_tx_descriptor *
@@ -1496,7 +1536,8 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (test_bit(R5_Wantdrain, &dev->flags))
+		if (test_bit(R5_Wantdrain, &dev->flags) ||
+		    test_bit(R5_InCache, &dev->flags))
 			xor_srcs[count++] = dev->page;
 	}
 
@@ -1547,6 +1588,10 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 again:
 			dev = &sh->dev[i];
+			if (test_and_clear_bit(R5_InCache, &dev->flags)) {
+				BUG_ON(atomic_read(&sh->dev_in_cache) == 0);
+				atomic_dec(&sh->dev_in_cache);
+			}
 			spin_lock_irq(&sh->stripe_lock);
 			chosen = dev->towrite;
 			dev->towrite = NULL;
@@ -1554,7 +1599,13 @@ again:
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
 			spin_unlock_irq(&sh->stripe_lock);
-			WARN_ON(dev->page != dev->orig_page);
+
+			/*
+			 * in biodrain stage, prexor for data in raid5-cache
+			 * is the only case where page != orig_page
+			 */
+			if (!test_bit(R5_Wantcache, &dev->flags))
+				WARN_ON(dev->page != dev->orig_page);
 
 			while (wbi && wbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
@@ -1566,8 +1617,10 @@ again:
 					set_bit(R5_Discard, &dev->flags);
 				else {
 					tx = async_copy_data(1, wbi, &dev->page,
-						dev->sector, tx, sh);
-					if (dev->page != dev->orig_page) {
+							     dev->sector, tx, sh,
+							     test_bit(R5_Wantcache, &dev->flags));
+					if (dev->page != dev->orig_page &&
+					    !test_bit(R5_Wantcache, &dev->flags)) {
 						set_bit(R5_SkipCopy, &dev->flags);
 						clear_bit(R5_UPTODATE, &dev->flags);
 						clear_bit(R5_OVERWRITE, &dev->flags);
@@ -1675,7 +1728,8 @@ again:
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (head_sh->dev[i].written)
+			if (head_sh->dev[i].written ||
+			    test_bit(R5_InCache, &head_sh->dev[i].flags))
 				xor_srcs[count++] = dev->page;
 		}
 	} else {
@@ -1930,6 +1984,7 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 		INIT_LIST_HEAD(&sh->batch_list);
 		INIT_LIST_HEAD(&sh->lru);
 		atomic_set(&sh->count, 1);
+		atomic_set(&sh->dev_in_cache, 0);
 		for (i = 0; i < disks; i++) {
 			struct r5dev *dev = &sh->dev[i];
 
@@ -2816,6 +2871,9 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 				if (!expand)
 					clear_bit(R5_UPTODATE, &dev->flags);
 				s->locked++;
+			} else if (test_bit(R5_InCache, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				s->locked++;
 			}
 		}
 		/* if we are not expanding this is a proper write request, and
@@ -2855,6 +2913,9 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 				set_bit(R5_LOCKED, &dev->flags);
 				clear_bit(R5_UPTODATE, &dev->flags);
 				s->locked++;
+			} else if (test_bit(R5_InCache, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				s->locked++;
 			}
 		}
 		if (!s->locked)
@@ -3529,9 +3590,12 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	} else for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
 		struct r5dev *dev = &sh->dev[i];
-		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
+		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx ||
+		     test_bit(R5_InCache, &dev->flags)) &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
+		    !((test_bit(R5_UPTODATE, &dev->flags) &&
+		       (!test_bit(R5_InCache, &dev->flags) ||
+			dev->page != dev->orig_page)) ||
 		      test_bit(R5_Wantcompute, &dev->flags))) {
 			if (test_bit(R5_Insync, &dev->flags))
 				rmw++;
@@ -3543,13 +3607,15 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 		    i != sh->pd_idx && i != sh->qd_idx &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		    test_bit(R5_Wantcompute, &dev->flags))) {
+		      test_bit(R5_InCache, &dev->flags) ||
+		      test_bit(R5_Wantcompute, &dev->flags))) {
 			if (test_bit(R5_Insync, &dev->flags))
 				rcw++;
 			else
 				rcw += 2*disks;
 		}
 	}
+
 	pr_debug("for sector %llu, rmw=%d rcw=%d\n",
 		(unsigned long long)sh->sector, rmw, rcw);
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -3561,10 +3627,18 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 					  (unsigned long long)sh->sector, rmw);
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
+			if (test_bit(R5_InCache, &dev->flags) &&
+			    dev->page == dev->orig_page)
+				dev->page = alloc_page(GFP_NOIO);  /* prexor */
+
+			if ((dev->towrite ||
+			     i == sh->pd_idx || i == sh->qd_idx ||
+			     test_bit(R5_InCache, &dev->flags)) &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
-			    !(test_bit(R5_UPTODATE, &dev->flags) ||
-			    test_bit(R5_Wantcompute, &dev->flags)) &&
+			    !((test_bit(R5_UPTODATE, &dev->flags) &&
+			       (!test_bit(R5_InCache, &dev->flags) ||
+				dev->page != dev->orig_page)) ||
+			      test_bit(R5_Wantcompute, &dev->flags)) &&
 			    test_bit(R5_Insync, &dev->flags)) {
 				if (test_bit(STRIPE_PREREAD_ACTIVE,
 					     &sh->state)) {
@@ -3590,6 +3664,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 			    i != sh->pd_idx && i != sh->qd_idx &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
+			      test_bit(R5_InCache, &dev->flags) ||
 			      test_bit(R5_Wantcompute, &dev->flags))) {
 				rcw++;
 				if (test_bit(R5_Insync, &dev->flags) &&
@@ -3629,7 +3704,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	 */
 	if ((s->req_compute || !test_bit(STRIPE_COMPUTE_RUN, &sh->state)) &&
 	    (s->locked == 0 && (rcw == 0 || rmw == 0) &&
-	    !test_bit(STRIPE_BIT_DELAY, &sh->state)))
+	     !test_bit(STRIPE_BIT_DELAY, &sh->state)))
 		schedule_reconstruction(sh, s, rcw == 0, 0);
 }
 
@@ -4120,6 +4195,10 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 			if (rdev && !test_bit(Faulty, &rdev->flags))
 				do_recovery = 1;
 		}
+		if (test_bit(R5_InCache, &dev->flags) && dev->written)
+			s->just_cached++;
+		if (test_bit(R5_Wantcache, &dev->flags) && dev->written)
+			s->want_cache++;
 	}
 	if (test_bit(STRIPE_SYNCING, &sh->state)) {
 		/* If there is a failed device being replaced,
@@ -4285,6 +4364,17 @@ static void handle_stripe(struct stripe_head *sh)
 
 	analyse_stripe(sh, &s);
 
+	if (s.want_cache) {
+		/* In last run of handle_stripe, we have finished
+		 * r5c_handle_stripe_dirtying and ops_run_biodrain, but
+		 * r5c_cache_data didn't finish because the journal device
+		 * didn't have enough space. This time we should continue
+		 * r5c_cache_data
+		 */
+		s.to_cache = s.want_cache;
+		goto finish;
+	}
+
 	if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
 		goto finish;
 
@@ -4348,7 +4438,7 @@ static void handle_stripe(struct stripe_head *sh)
 			struct r5dev *dev = &sh->dev[i];
 			if (test_bit(R5_LOCKED, &dev->flags) &&
 				(i == sh->pd_idx || i == sh->qd_idx ||
-				 dev->written)) {
+				 dev->written || test_bit(R5_InCache, &dev->flags))) {
 				pr_debug("Writing block %d\n", i);
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (prexor)
@@ -4388,6 +4478,10 @@ static void handle_stripe(struct stripe_head *sh)
 				 test_bit(R5_Discard, &qdev->flags))))))
 		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
 
+	if (s.just_cached)
+		r5c_handle_cached_data_endio(conf, sh, disks, &s.return_bi);
+	r5l_stripe_write_finished(sh);
+
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
@@ -6526,6 +6620,11 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
 		INIT_LIST_HEAD(conf->temp_inactive_list + i);
 
+	atomic_set(&conf->r5c_cached_full_stripes, 0);
+	INIT_LIST_HEAD(&conf->r5c_full_stripe_list);
+	atomic_set(&conf->r5c_cached_partial_stripes, 0);
+	INIT_LIST_HEAD(&conf->r5c_partial_stripe_list);
+
 	conf->level = mddev->new_level;
 	conf->chunk_sectors = mddev->new_chunk_sectors;
 	if (raid5_alloc_percpu(conf) != 0)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 8bae64b..ac6d7c7 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -226,6 +226,7 @@ struct stripe_head {
 
 	struct r5l_io_unit	*log_io;
 	struct list_head	log_list;
+	atomic_t		dev_in_cache;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -263,6 +264,7 @@ struct stripe_head_state {
 	 */
 	int syncing, expanding, expanded, replacing;
 	int locked, uptodate, to_read, to_write, failed, written;
+	int to_cache, want_cache, just_cached;
 	int to_fill, compute, req_compute, non_overwrite;
 	int failed_num[2];
 	int p_failed, q_failed;
@@ -313,6 +315,8 @@ enum r5dev_flags {
 			 */
 	R5_Discard,	/* Discard the stripe */
 	R5_SkipCopy,	/* Don't copy data from bio to stripe cache */
+	R5_Wantcache,	/* Want write data to write cache */
+	R5_InCache,	/* Data in cache */
 };
 
 /*
@@ -348,6 +352,12 @@ enum {
 	STRIPE_LOG_TRAPPED,	/* trapped into log */
 	STRIPE_R5C_FROZEN,	/* r5c_cache frozen and being written out */
 	STRIPE_R5C_WRITTEN,	/* ready for r5c_handle_stripe_written() */
+	STRIPE_R5C_PARTIAL_STRIPE,	/* in r5c cache (to-be/being handled or
+					 * in conf->r5c_partial_stripe_list)
+					 */
+	STRIPE_R5C_FULL_STRIPE,	/* in r5c cache (to-be/being handled or
+				 * in conf->r5c_full_stripe_list)
+				 */
 };
 
 #define STRIPE_EXPAND_SYNC_FLAGS \
@@ -600,6 +610,12 @@ struct r5conf {
 	 */
 	atomic_t		active_stripes;
 	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
+
+	atomic_t		r5c_cached_full_stripes;
+	struct list_head	r5c_full_stripe_list;
+	atomic_t		r5c_cached_partial_stripes;
+	struct list_head	r5c_partial_stripe_list;
+
 	atomic_t		empty_inactive_list_nr;
 	struct llist_head	released_stripes;
 	wait_queue_head_t	wait_for_quiescent;
@@ -720,4 +736,10 @@ r5c_handle_stripe_dirtying(struct r5conf *conf, struct stripe_head *sh,
 			   struct stripe_head_state *s, int disks);
 extern void
 r5c_handle_stripe_written(struct r5conf *conf, struct stripe_head *sh);
+extern void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
+extern void r5c_handle_cached_data_endio(struct r5conf *conf,
+	struct stripe_head *sh, int disks, struct bio_list *return_bi);
+extern int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
+			  struct stripe_head_state *s);
+extern void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh);
 #endif
-- 
2.9.3

