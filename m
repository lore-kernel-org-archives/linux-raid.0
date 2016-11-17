From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v7 04/10] md/r5cache: caching phase of r5cache
Date: Thu, 17 Nov 2016 15:24:39 -0800
Message-ID: <20161117232445.1798305-5-songliubraving@fb.com>
References: <20161117232445.1798305-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161117232445.1798305-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

As described in previous patch, write back cache operates in two
phases: caching and writing-out. The caching phase works as:
1. write data to journal
   (r5c_handle_stripe_dirtying, r5c_cache_data)
2. call bio_endio
   (r5c_handle_data_cached, r5c_return_dev_pending_writes).

Then the writing-out phase is as:
1. Mark the stripe as write-out (r5c_make_stripe_write_out)
2. Calcualte parity (reconstruct or RMW)
3. Write parity (and maybe some other data) to journal device
4. Write data and parity to RAID disks

This patch implements caching phase. The cache is integrated with
stripe cache of raid456. It leverages code of r5l_log to write
data to journal device.

Writing-out phase of the cache is implemented in the next patch.

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
being updated.  This is stored in r5dev->orig_page and the old data
is read into it.  Then the prexor calculation subtracts ->orig_page
from the parity block, and the reconstruct calculation adds the
->page data back into the parity block.

r5cache naturally excludes SkipCopy. When the array has write back
cache, async_copy_data() will not skip copy.

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
 drivers/md/raid5-cache.c | 242 +++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/raid5.c       | 152 ++++++++++++++++++++++++-----
 drivers/md/raid5.h       |  19 +++-
 3 files changed, 381 insertions(+), 32 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 02a5544..19c5af9 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -20,6 +20,7 @@
 #include <linux/random.h>
 #include "md.h"
 #include "raid5.h"
+#include "bitmap.h"
 
 /*
  * metadata/data stored in disk with 4k size unit (a block) regardless
@@ -218,6 +219,43 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
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
+		if (sh->dev[i].written) {
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
  * Put the stripe into writing-out phase by clearing STRIPE_R5C_CACHING.
  * This function should only be called in write-back mode.
@@ -231,6 +269,44 @@ static void r5c_make_stripe_write_out(struct stripe_head *sh)
 
 	WARN_ON(!test_bit(STRIPE_R5C_CACHING, &sh->state));
 	clear_bit(STRIPE_R5C_CACHING, &sh->state);
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
+		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags)) {
+			set_bit(R5_InJournal, &sh->dev[i].flags);
+			clear_bit(R5_LOCKED, &sh->dev[i].flags);
+		}
+	clear_bit(STRIPE_LOG_TRAPPED, &sh->state);
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
+		if (test_bit(R5_InJournal, &sh->dev[i].flags))
+			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 }
 
 /*
@@ -250,8 +326,12 @@ static void r5c_finish_cache_stripe(struct stripe_head *sh)
 		 * two parities are written out together.
 		 */
 		set_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags);
-	} else
-		BUG(); /* write-back logic in next patch */
+	} else if (test_bit(STRIPE_R5C_CACHING, &sh->state)) {
+		r5c_handle_data_cached(sh);
+	} else {
+		r5c_handle_parity_cached(sh);
+		set_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags);
+	}
 }
 
 static void r5l_io_run_stripes(struct r5l_io_unit *io)
@@ -491,7 +571,8 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	io = log->current_io;
 
 	for (i = 0; i < sh->disks; i++) {
-		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
+		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags) ||
+		    test_bit(R5_InJournal, &sh->dev[i].flags))
 			continue;
 		if (i == sh->pd_idx || i == sh->qd_idx)
 			continue;
@@ -550,8 +631,10 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	for (i = 0; i < sh->disks; i++) {
 		void *addr;
 
-		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
+		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags) ||
+		    test_bit(R5_InJournal, &sh->dev[i].flags))
 			continue;
+
 		write_disks++;
 		/* checksum is already calculated in last run */
 		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
@@ -817,7 +900,6 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 	}
 }
 
-
 static void r5l_do_reclaim(struct r5l_log *log)
 {
 	sector_t reclaim_target = xchg(&log->reclaim_target, 0);
@@ -1218,12 +1300,80 @@ int r5c_try_caching_write(struct r5conf *conf,
 			  int disks)
 {
 	struct r5l_log *log = conf->log;
+	int i;
+	struct r5dev *dev;
+	int to_cache = 0;
 
 	BUG_ON(!r5c_is_writeback(log));
 
-	/* more write-back logic in next patches */
-	r5c_make_stripe_write_out(sh);
-	return -EAGAIN;
+	if (!test_bit(STRIPE_R5C_CACHING, &sh->state)) {
+		/*
+		 * There are two different scenarios here:
+		 *  1. The stripe has some data cached, and it is sent to
+		 *     write-out phase for reclaim
+		 *  2. The stripe is clean, and this is the first write
+		 *
+		 * For 1, return -EAGAIN, so we continue with
+		 * handle_stripe_dirtying().
+		 *
+		 * For 2, set STRIPE_R5C_CACHING and continue with caching
+		 * write.
+		 */
+
+		/* case 1: anything injournal or anything in written */
+		if (s->injournal > 0 || s->written > 0)
+			return -EAGAIN;
+		/* case 2 */
+		set_bit(STRIPE_R5C_CACHING, &sh->state);
+	}
+
+	for (i = disks; i--; ) {
+		dev = &sh->dev[i];
+		/* if non-overwrite, use writing-out phase */
+		if (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags) &&
+		    !test_bit(R5_InJournal, &dev->flags)) {
+			r5c_make_stripe_write_out(sh);
+			return -EAGAIN;
+		}
+	}
+
+	for (i = disks; i--; ) {
+		dev = &sh->dev[i];
+		if (dev->towrite) {
+			set_bit(R5_Wantwrite, &dev->flags);
+			set_bit(R5_Wantdrain, &dev->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+			to_cache++;
+		}
+	}
+
+	if (to_cache) {
+		set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
+		/*
+		 * set STRIPE_LOG_TRAPPED, which triggers r5c_cache_data()
+		 * in ops_run_io(). STRIPE_LOG_TRAPPED will be cleared in
+		 * r5c_handle_data_cached()
+		 */
+		set_bit(STRIPE_LOG_TRAPPED, &sh->state);
+	}
+
+	return 0;
+}
+
+/*
+ * free extra pages (orig_page) we allocated for prexor
+ */
+void r5c_release_extra_page(struct stripe_head *sh)
+{
+	int i;
+
+	for (i = sh->disks; i--; )
+		if (sh->dev[i].page != sh->dev[i].orig_page) {
+			struct page *p = sh->dev[i].orig_page;
+
+			sh->dev[i].orig_page = sh->dev[i].page;
+			put_page(p);
+		}
 }
 
 /*
@@ -1234,6 +1384,9 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 				 struct stripe_head *sh,
 				 struct stripe_head_state *s)
 {
+	int i;
+	int do_wakeup = 0;
+
 	if (!conf->log ||
 	    !test_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags))
 		return;
@@ -1243,7 +1396,78 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 
 	if (conf->log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
 		return;
-	BUG();  /* write-back logic in following patches */
+
+	for (i = sh->disks; i--; ) {
+		clear_bit(R5_InJournal, &sh->dev[i].flags);
+		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+			do_wakeup = 1;
+	}
+
+	/*
+	 * analyse_stripe() runs before r5c_finish_stripe_write_out(),
+	 * We updated R5_InJournal, so we also update s->injournal.
+	 */
+	s->injournal = 0;
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
+	int pages = 0;
+	int reserve;
+	int i;
+	int ret = 0;
+
+	BUG_ON(!log);
+
+	for (i = 0; i < sh->disks; i++) {
+		void *addr;
+
+		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
+			continue;
+		addr = kmap_atomic(sh->dev[i].page);
+		sh->dev[i].log_checksum = crc32c_le(log->uuid_checksum,
+						    addr, PAGE_SIZE);
+		kunmap_atomic(addr);
+		pages++;
+	}
+	WARN_ON(pages == 0);
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
 
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7c98eb0..f535ce2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -218,8 +218,17 @@ static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
 static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			      struct list_head *temp_inactive_list)
 {
+	int i;
+	int injournal = 0;	/* number of date pages with R5_InJournal */
+
 	BUG_ON(!list_empty(&sh->lru));
 	BUG_ON(atomic_read(&conf->active_stripes)==0);
+
+	if (r5c_is_writeback(conf->log))
+		for (i = sh->disks; i--; )
+			if (test_bit(R5_InJournal, &sh->dev[i].flags))
+				injournal++;
+
 	if (test_bit(STRIPE_HANDLE, &sh->state)) {
 		if (test_bit(STRIPE_DELAYED, &sh->state) &&
 		    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
@@ -245,8 +254,29 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			    < IO_THRESHOLD)
 				md_wakeup_thread(conf->mddev->thread);
 		atomic_dec(&conf->active_stripes);
-		if (!test_bit(STRIPE_EXPANDING, &sh->state))
-			list_add_tail(&sh->lru, temp_inactive_list);
+		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
+			if (!r5c_is_writeback(conf->log))
+				list_add_tail(&sh->lru, temp_inactive_list);
+			else {
+				WARN_ON(test_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags));
+				if (injournal == 0)
+					list_add_tail(&sh->lru, temp_inactive_list);
+				else if (injournal == conf->raid_disks - conf->max_degraded) {
+					/* full stripe */
+					if (!test_and_set_bit(STRIPE_R5C_FULL_STRIPE, &sh->state))
+						atomic_inc(&conf->r5c_cached_full_stripes);
+					if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state))
+						atomic_dec(&conf->r5c_cached_partial_stripes);
+					list_add_tail(&sh->lru, &conf->r5c_full_stripe_list);
+				} else {
+					/* partial stripe */
+					if (!test_and_set_bit(STRIPE_R5C_PARTIAL_STRIPE,
+							      &sh->state))
+						atomic_inc(&conf->r5c_cached_partial_stripes);
+					list_add_tail(&sh->lru, &conf->r5c_partial_stripe_list);
+				}
+			}
+		}
 	}
 }
 
@@ -830,8 +860,17 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
-	if (r5l_write_stripe(conf->log, sh) == 0)
-		return;
+	if (!test_bit(STRIPE_R5C_CACHING, &sh->state)) {
+		/* writing out phase */
+		if (r5l_write_stripe(conf->log, sh) == 0)
+			return;
+	} else {  /* caching phase */
+		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state)) {
+			r5c_cache_data(conf->log, sh, s);
+			return;
+		}
+	}
+
 	for (i = disks; i--; ) {
 		int op, op_flags = 0;
 		int replace_only = 0;
@@ -1044,7 +1083,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 static struct dma_async_tx_descriptor *
 async_copy_data(int frombio, struct bio *bio, struct page **page,
 	sector_t sector, struct dma_async_tx_descriptor *tx,
-	struct stripe_head *sh)
+	struct stripe_head *sh, int no_skipcopy)
 {
 	struct bio_vec bvl;
 	struct bvec_iter iter;
@@ -1084,7 +1123,8 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 			if (frombio) {
 				if (sh->raid_conf->skip_copy &&
 				    b_offset == 0 && page_offset == 0 &&
-				    clen == STRIPE_SIZE)
+				    clen == STRIPE_SIZE &&
+				    !no_skipcopy)
 					*page = bio_page;
 				else
 					tx = async_memcpy(*page, bio_page, page_offset,
@@ -1166,7 +1206,7 @@ static void ops_run_biofill(struct stripe_head *sh)
 			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, &dev->page,
-					dev->sector, tx, sh);
+						     dev->sector, tx, sh, 0);
 				rbi = r5_next_bio(rbi, dev->sector);
 			}
 		}
@@ -1293,10 +1333,15 @@ static int set_syndrome_sources(struct page **srcs,
 		if (i == sh->qd_idx || i == sh->pd_idx ||
 		    (srctype == SYNDROME_SRC_ALL) ||
 		    (srctype == SYNDROME_SRC_WANT_DRAIN &&
-		     test_bit(R5_Wantdrain, &dev->flags)) ||
+		     (test_bit(R5_Wantdrain, &dev->flags) ||
+		      test_bit(R5_InJournal, &dev->flags))) ||
 		    (srctype == SYNDROME_SRC_WRITTEN &&
-		     dev->written))
-			srcs[slot] = sh->dev[i].page;
+		     dev->written)) {
+			if (test_bit(R5_InJournal, &dev->flags))
+				srcs[slot] = sh->dev[i].orig_page;
+			else
+				srcs[slot] = sh->dev[i].page;
+		}
 		i = raid6_next_disk(i, disks);
 	} while (i != d0_idx);
 
@@ -1475,6 +1520,13 @@ static void ops_complete_prexor(void *stripe_head_ref)
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
+
+	if (r5c_is_writeback(sh->raid_conf->log))
+		/*
+		 * raid5-cache write back uses orig_page during prexor.
+		 * After prexor, it is time to free orig_page
+		 */
+		r5c_release_extra_page(sh);
 }
 
 static struct dma_async_tx_descriptor *
@@ -1496,7 +1548,9 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (test_bit(R5_Wantdrain, &dev->flags))
+		if (test_bit(R5_InJournal, &dev->flags))
+			xor_srcs[count++] = dev->orig_page;
+		else if (test_bit(R5_Wantdrain, &dev->flags))
 			xor_srcs[count++] = dev->page;
 	}
 
@@ -1530,6 +1584,7 @@ ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu,
 static struct dma_async_tx_descriptor *
 ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
+	struct r5conf *conf = sh->raid_conf;
 	int disks = sh->disks;
 	int i;
 	struct stripe_head *head_sh = sh;
@@ -1547,6 +1602,11 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 again:
 			dev = &sh->dev[i];
+			/*
+			 * clear R5_InJournal, so when rewriting a page in
+			 * journal, it is not skipped by r5l_log_stripe()
+			 */
+			clear_bit(R5_InJournal, &dev->flags);
 			spin_lock_irq(&sh->stripe_lock);
 			chosen = dev->towrite;
 			dev->towrite = NULL;
@@ -1566,8 +1626,10 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 					set_bit(R5_Discard, &dev->flags);
 				else {
 					tx = async_copy_data(1, wbi, &dev->page,
-						dev->sector, tx, sh);
-					if (dev->page != dev->orig_page) {
+							     dev->sector, tx, sh,
+							     r5c_is_writeback(conf->log));
+					if (dev->page != dev->orig_page &&
+					    !r5c_is_writeback(conf->log)) {
 						set_bit(R5_SkipCopy, &dev->flags);
 						clear_bit(R5_UPTODATE, &dev->flags);
 						clear_bit(R5_OVERWRITE, &dev->flags);
@@ -1675,7 +1737,8 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (head_sh->dev[i].written)
+			if (head_sh->dev[i].written ||
+			    test_bit(R5_InJournal, &head_sh->dev[i].flags))
 				xor_srcs[count++] = dev->page;
 		}
 	} else {
@@ -2796,6 +2859,13 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 	int level = conf->level;
 
 	if (rcw) {
+		/*
+		 * In some cases, handle_stripe_dirtying initially decided to
+		 * run rmw and allocates extra page for prexor. However, rcw is
+		 * cheaper later on. We need to free the extra page now,
+		 * because we won't be able to do that in ops_complete_prexor().
+		 */
+		r5c_release_extra_page(sh);
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
@@ -2806,6 +2876,9 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 				if (!expand)
 					clear_bit(R5_UPTODATE, &dev->flags);
 				s->locked++;
+			} else if (test_bit(R5_InJournal, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				s->locked++;
 			}
 		}
 		/* if we are not expanding this is a proper write request, and
@@ -2845,6 +2918,9 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 				set_bit(R5_LOCKED, &dev->flags);
 				clear_bit(R5_UPTODATE, &dev->flags);
 				s->locked++;
+			} else if (test_bit(R5_InJournal, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				s->locked++;
 			}
 		}
 		if (!s->locked)
@@ -3516,9 +3592,12 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	} else for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
 		struct r5dev *dev = &sh->dev[i];
-		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
+		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx ||
+		     test_bit(R5_InJournal, &dev->flags)) &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
+		    !((test_bit(R5_UPTODATE, &dev->flags) &&
+		       (!test_bit(R5_InJournal, &dev->flags) ||
+			dev->page != dev->orig_page)) ||
 		      test_bit(R5_Wantcompute, &dev->flags))) {
 			if (test_bit(R5_Insync, &dev->flags))
 				rmw++;
@@ -3530,13 +3609,15 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 		    i != sh->pd_idx && i != sh->qd_idx &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		    test_bit(R5_Wantcompute, &dev->flags))) {
+		      test_bit(R5_InJournal, &dev->flags) ||
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
@@ -3548,10 +3629,24 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 					  (unsigned long long)sh->sector, rmw);
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
+			if (test_bit(R5_InJournal, &dev->flags) &&
+			    dev->page == dev->orig_page &&
+			    !test_bit(R5_LOCKED, &sh->dev[sh->pd_idx].flags)) {
+				/* alloc page for prexor */
+				dev->orig_page = alloc_page(GFP_NOIO);
+
+				/* will handle failure in a later patch*/
+				BUG_ON(!dev->orig_page);
+			}
+
+			if ((dev->towrite ||
+			     i == sh->pd_idx || i == sh->qd_idx ||
+			     test_bit(R5_InJournal, &dev->flags)) &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
-			    !(test_bit(R5_UPTODATE, &dev->flags) ||
-			    test_bit(R5_Wantcompute, &dev->flags)) &&
+			    !((test_bit(R5_UPTODATE, &dev->flags) &&
+			       (!test_bit(R5_InJournal, &dev->flags) ||
+				dev->page != dev->orig_page)) ||
+			      test_bit(R5_Wantcompute, &dev->flags)) &&
 			    test_bit(R5_Insync, &dev->flags)) {
 				if (test_bit(STRIPE_PREREAD_ACTIVE,
 					     &sh->state)) {
@@ -3577,6 +3672,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 			    i != sh->pd_idx && i != sh->qd_idx &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
+			      test_bit(R5_InJournal, &dev->flags) ||
 			      test_bit(R5_Wantcompute, &dev->flags))) {
 				rcw++;
 				if (test_bit(R5_Insync, &dev->flags) &&
@@ -3616,7 +3712,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	 */
 	if ((s->req_compute || !test_bit(STRIPE_COMPUTE_RUN, &sh->state)) &&
 	    (s->locked == 0 && (rcw == 0 || rmw == 0) &&
-	    !test_bit(STRIPE_BIT_DELAY, &sh->state)))
+	     !test_bit(STRIPE_BIT_DELAY, &sh->state)))
 		schedule_reconstruction(sh, s, rcw == 0, 0);
 }
 
@@ -4110,6 +4206,8 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 
 		if (test_bit(R5_InJournal, &dev->flags))
 			s->injournal++;
+		if (test_bit(R5_InJournal, &dev->flags) && dev->written)
+			s->just_cached++;
 	}
 	if (test_bit(STRIPE_SYNCING, &sh->state)) {
 		/* If there is a failed device being replaced,
@@ -4338,7 +4436,8 @@ static void handle_stripe(struct stripe_head *sh)
 			struct r5dev *dev = &sh->dev[i];
 			if (test_bit(R5_LOCKED, &dev->flags) &&
 				(i == sh->pd_idx || i == sh->qd_idx ||
-				 dev->written)) {
+				 dev->written || test_bit(R5_InJournal,
+							  &dev->flags))) {
 				pr_debug("Writing block %d\n", i);
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (prexor)
@@ -4378,6 +4477,10 @@ static void handle_stripe(struct stripe_head *sh)
 				 test_bit(R5_Discard, &qdev->flags))))))
 		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
 
+	if (s.just_cached)
+		r5c_handle_cached_data_endio(conf, sh, disks, &s.return_bi);
+	r5l_stripe_write_finished(sh);
+
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
@@ -6499,6 +6602,11 @@ static struct r5conf *setup_conf(struct mddev *mddev)
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
index c9590a8..73c1833 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -264,7 +264,7 @@ struct stripe_head_state {
 	int syncing, expanding, expanded, replacing;
 	int locked, uptodate, to_read, to_write, failed, written;
 	int to_fill, compute, req_compute, non_overwrite;
-	int injournal;
+	int injournal, just_cached;
 	int failed_num[2];
 	int p_failed, q_failed;
 	int dec_preread_active;
@@ -368,6 +368,12 @@ enum {
 	STRIPE_R5C_CACHING,	/* the stripe is in caching phase
 				 * see more detail in the raid5-cache.c
 				 */
+	STRIPE_R5C_PARTIAL_STRIPE,	/* in r5c cache (to-be/being handled or
+					 * in conf->r5c_partial_stripe_list)
+					 */
+	STRIPE_R5C_FULL_STRIPE,	/* in r5c cache (to-be/being handled or
+				 * in conf->r5c_full_stripe_list)
+				 */
 };
 
 #define STRIPE_EXPAND_SYNC_FLAGS \
@@ -618,6 +624,12 @@ struct r5conf {
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
@@ -739,4 +751,9 @@ r5c_try_caching_write(struct r5conf *conf, struct stripe_head *sh,
 extern void
 r5c_finish_stripe_write_out(struct r5conf *conf, struct stripe_head *sh,
 			    struct stripe_head_state *s);
+extern void r5c_release_extra_page(struct stripe_head *sh);
+extern void r5c_handle_cached_data_endio(struct r5conf *conf,
+	struct stripe_head *sh, int disks, struct bio_list *return_bi);
+extern int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
+			  struct stripe_head_state *s);
 #endif
-- 
2.9.3

