From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v4] md/r5cache: enable chunk_aligned_read with write back cache
Date: Wed, 11 Jan 2017 13:39:14 -0800
Message-ID: <20170111213914.2429024-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

Chunk aligned read significantly reduces CPU usage of raid456.
However, it is not safe to fully bypass the write back cache.
This patch enables chunk aligned read with write back cache.

For chunk aligned read, we track stripes in write back cache at
a bigger granularity, "big_stripe". Each chunk may contain more
than one stripe (for example, a 256kB chunk contains 64 4kB-page,
so this chunk contain 64 stripes). For chunk_aligned_read, these
stripes are grouped into one big_stripe, so we only need one lookup
for the whole chunk.

For each big_stripe, struct big_stripe_info tracks how many stripes
of this big_stripe are in the write back cache. We count how many
stripes of this big_stripe are in the write back cache. These
counters are tracked in a radix tree (big_stripe_tree).
r5c_tree_index() is used to calculate keys for the radix tree.

chunk_aligned_read() calls r5c_big_stripe_cached() to look up
big_stripe of each chunk in the tree. If this big_stripe is in the
tree, chunk_aligned_read() aborts. This look up is protected by
rcu_read_lock().

It is necessary to remember whether a stripe is counted in
big_stripe_tree. Instead of adding new flag, we reuses existing flags:
STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE. If either of these
two flags are set, the stripe is counted in big_stripe_tree. This
requires moving set_bit(STRIPE_R5C_PARTIAL_STRIPE) to
r5c_try_caching_write(); and moving clear_bit of
STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE to
r5c_finish_stripe_write_out().

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 169 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/raid5.c       |  20 ++++--
 drivers/md/raid5.h       |   1 +
 3 files changed, 166 insertions(+), 24 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 3e3e5dc..d71e79e 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -20,6 +20,7 @@
 #include <linux/crc32c.h>
 #include <linux/random.h>
 #include <linux/kthread.h>
+#include <linux/types.h>
 #include "md.h"
 #include "raid5.h"
 #include "bitmap.h"
@@ -162,9 +163,60 @@ struct r5l_log {
 
 	/* to submit async io_units, to fulfill ordering of flush */
 	struct work_struct deferred_io_work;
+
+	/* to for chunk_aligned_read in writeback mode, details below */
+	spinlock_t tree_lock;
+	struct radix_tree_root big_stripe_tree;
 };
 
 /*
+ * Enable chunk_aligned_read() with write back cache.
+ *
+ * Each chunk may contain more than one stripe (for example, a 256kB
+ * chunk contains 64 4kB-page, so this chunk contain 64 stripes). For
+ * chunk_aligned_read, these stripes are grouped into one "big_stripe".
+ * For each big_stripe, we count how many stripes of this big_stripe
+ * are in the write back cache. These data are tracked in a radix tree
+ * (big_stripe_tree). We use radix_tree item pointer as the counter.
+ * r5c_tree_index() is used to calculate keys for the radix tree.
+ *
+ * chunk_aligned_read() calls r5c_big_stripe_cached() to look up
+ * big_stripe of each chunk in the tree. If this big_stripe is in the
+ * tree, chunk_aligned_read() aborts. This look up is protected by
+ * rcu_read_lock().
+ *
+ * It is necessary to remember whether a stripe is counted in
+ * big_stripe_tree. Instead of adding new flag, we reuses existing flags:
+ * STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE. If either of these
+ * two flags are set, the stripe is counted in big_stripe_tree. This
+ * requires moving set_bit(STRIPE_R5C_PARTIAL_STRIPE) to
+ * r5c_try_caching_write(); and moving clear_bit of
+ * STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE to
+ * r5c_finish_stripe_write_out().
+ */
+
+/*
+ * radix tree requests lowest 2 bits of data pointer to be 2b'00.
+ * So it is necessary to left shift the counter by 2 bits before using it
+ * as data pointer of the tree.
+ */
+#define R5C_RADIX_COUNT_SHIFT 2
+
+/*
+ * calculate key for big_stripe_tree
+ *
+ * sect: align_bi->bi_iter.bi_sector or sh->sector
+ */
+static inline sector_t r5c_tree_index(struct r5conf *conf,
+				      sector_t sect)
+{
+	sector_t offset;
+
+	offset = sector_div(sect, conf->chunk_sectors);
+	return sect;
+}
+
+/*
  * an IO range starts from a meta data block and end at the next meta data
  * block. The io unit's the meta data block tracks data/parity followed it. io
  * unit is written to log disk with normal write, as we always flush log disk
@@ -410,16 +462,6 @@ void r5c_make_stripe_write_out(struct stripe_head *sh)
 
 	if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 		atomic_inc(&conf->preread_active_stripes);
-
-	if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state)) {
-		BUG_ON(atomic_read(&conf->r5c_cached_partial_stripes) == 0);
-		atomic_dec(&conf->r5c_cached_partial_stripes);
-	}
-
-	if (test_and_clear_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
-		BUG_ON(atomic_read(&conf->r5c_cached_full_stripes) == 0);
-		atomic_dec(&conf->r5c_cached_full_stripes);
-	}
 }
 
 static void r5c_handle_data_cached(struct stripe_head *sh)
@@ -2303,6 +2345,10 @@ int r5c_try_caching_write(struct r5conf *conf,
 	int i;
 	struct r5dev *dev;
 	int to_cache = 0;
+	void **pslot;
+	sector_t tree_index;
+	int ret;
+	uintptr_t refcount;
 
 	BUG_ON(!r5c_is_writeback(log));
 
@@ -2337,6 +2383,43 @@ int r5c_try_caching_write(struct r5conf *conf,
 		}
 	}
 
+	/* if the stripe is not counted in big_stripe_tree, add it now */
+	if (!test_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state) &&
+	    !test_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
+		tree_index = r5c_tree_index(conf, sh->sector);
+		spin_lock(&log->tree_lock);
+		pslot = radix_tree_lookup_slot(&log->big_stripe_tree,
+					       tree_index);
+		if (pslot) {
+			refcount = (uintptr_t)radix_tree_deref_slot(pslot) >>
+				R5C_RADIX_COUNT_SHIFT;
+			radix_tree_replace_slot(
+				&log->big_stripe_tree, pslot,
+				(void *)((refcount + 1) << R5C_RADIX_COUNT_SHIFT));
+		} else {
+			/*
+			 * this radix_tree_insert can fail safely, so no
+			 * need to call radix_tree_preload()
+			 */
+			ret = radix_tree_insert(
+				&log->big_stripe_tree, tree_index,
+				(void *)(1 << R5C_RADIX_COUNT_SHIFT));
+			if (ret) {
+				spin_unlock(&log->tree_lock);
+				r5c_make_stripe_write_out(sh);
+				return -EAGAIN;
+			}
+		}
+		spin_unlock(&log->tree_lock);
+
+		/*
+		 * set STRIPE_R5C_PARTIAL_STRIPE, this shows the stripe is
+		 * counted in the radix tree
+		 */
+		set_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state);
+		atomic_dec(&conf->r5c_cached_partial_stripes);
+	}
+
 	for (i = disks; i--; ) {
 		dev = &sh->dev[i];
 		if (dev->towrite) {
@@ -2411,17 +2494,20 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 				 struct stripe_head *sh,
 				 struct stripe_head_state *s)
 {
+	struct r5l_log *log = conf->log;
 	int i;
 	int do_wakeup = 0;
+	sector_t tree_index;
+	void **pslot;
+	uintptr_t refcount;
 
-	if (!conf->log ||
-	    !test_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags))
+	if (!log || !test_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags))
 		return;
 
 	WARN_ON(test_bit(STRIPE_R5C_CACHING, &sh->state));
 	clear_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags);
 
-	if (conf->log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
+	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
 		return;
 
 	for (i = sh->disks; i--; ) {
@@ -2443,12 +2529,42 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 	if (do_wakeup)
 		wake_up(&conf->wait_for_overlap);
 
-	spin_lock_irq(&conf->log->stripe_in_journal_lock);
+	spin_lock_irq(&log->stripe_in_journal_lock);
 	list_del_init(&sh->r5c);
-	spin_unlock_irq(&conf->log->stripe_in_journal_lock);
+	spin_unlock_irq(&log->stripe_in_journal_lock);
 	sh->log_start = MaxSector;
-	atomic_dec(&conf->log->stripe_in_journal_count);
-	r5c_update_log_state(conf->log);
+
+	atomic_dec(&log->stripe_in_journal_count);
+	r5c_update_log_state(log);
+
+	/* stop counting this stripe in big_stripe_tree */
+	if (test_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state) ||
+	    test_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
+		tree_index = r5c_tree_index(conf, sh->sector);
+		spin_lock(&log->tree_lock);
+		pslot = radix_tree_lookup_slot(&log->big_stripe_tree,
+					       tree_index);
+		BUG_ON(pslot == NULL);
+		refcount = (uintptr_t)radix_tree_deref_slot(pslot) >>
+			R5C_RADIX_COUNT_SHIFT;
+		if (refcount == 1)
+			radix_tree_delete(&log->big_stripe_tree, tree_index);
+		else
+			radix_tree_replace_slot(
+				&log->big_stripe_tree, pslot,
+				(void *)((refcount - 1) << R5C_RADIX_COUNT_SHIFT));
+		spin_unlock(&log->tree_lock);
+	}
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
 }
 
 int
@@ -2508,6 +2624,22 @@ r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 	return 0;
 }
 
+/* check whether this big stripe is in write back cache. */
+bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect)
+{
+	struct r5l_log *log = conf->log;
+	sector_t tree_index;
+	void *slot;
+
+	if (!log)
+		return false;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	tree_index = r5c_tree_index(conf, sect);
+	slot = radix_tree_lookup(&log->big_stripe_tree, tree_index);
+	return slot != NULL;
+}
+
 static int r5l_load_log(struct r5l_log *log)
 {
 	struct md_rdev *rdev = log->rdev;
@@ -2641,6 +2773,9 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (!log->meta_pool)
 		goto out_mempool;
 
+	spin_lock_init(&log->tree_lock);
+	INIT_RADIX_TREE(&log->big_stripe_tree, GFP_NOWAIT | __GFP_NOWARN);
+
 	log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
 						 log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5a42f4b..87ef96f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -287,13 +287,13 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 						atomic_dec(&conf->r5c_cached_partial_stripes);
 					list_add_tail(&sh->lru, &conf->r5c_full_stripe_list);
 					r5c_check_cached_full_stripe(conf);
-				} else {
-					/* partial stripe */
-					if (!test_and_set_bit(STRIPE_R5C_PARTIAL_STRIPE,
-							      &sh->state))
-						atomic_inc(&conf->r5c_cached_partial_stripes);
+				} else
+					/*
+					 * STRIPE_R5C_PARTIAL_STRIPE is set in
+					 * r5c_try_caching_write(). No need to
+					 * set it again.
+					 */
 					list_add_tail(&sh->lru, &conf->r5c_partial_stripe_list);
-				}
 			}
 		}
 	}
@@ -5059,6 +5059,13 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 		      rdev->recovery_offset >= end_sector)))
 			rdev = NULL;
 	}
+
+	if (r5c_big_stripe_cached(conf, align_bi->bi_iter.bi_sector)) {
+		rcu_read_unlock();
+		bio_put(align_bi);
+		return 0;
+	}
+
 	if (rdev) {
 		sector_t first_bad;
 		int bad_sectors;
@@ -5415,7 +5422,6 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	 * data on failed drives.
 	 */
 	if (rw == READ && mddev->degraded == 0 &&
-	    !r5c_is_writeback(conf->log) &&
 	    mddev->reshape_position == MaxSector) {
 		bi = chunk_aligned_read(mddev, bi);
 		if (!bi)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 876c75f..06b240e 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -795,4 +795,5 @@ extern void r5c_flush_cache(struct r5conf *conf, int num);
 extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
 extern void r5c_check_cached_full_stripe(struct r5conf *conf);
 extern struct md_sysfs_entry r5c_journal_mode;
+extern bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect);
 #endif
-- 
2.9.3

