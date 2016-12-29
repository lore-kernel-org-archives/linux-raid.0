From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/2] md/r5cache: enable chunk_aligned_read with write back cache
Date: Wed, 28 Dec 2016 17:18:02 -0800
Message-ID: <20161229011802.692478-2-songliubraving@fb.com>
References: <20161229011802.692478-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161229011802.692478-1-songliubraving@fb.com>
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

For each big_stripe, struct big_stripe_info tracks how many stripes of
this big_stripe are in the write back cache. These data are tracked
in a radix tree (big_stripe_tree). big_stripe_index() is used to
calculate keys for the radix tree.

chunk_aligned_read() calls r5c_big_stripe_cached() to look up
big_stripe of each chunk in the tree. If this big_stripe is in the
tree, chunk_aligned_read() aborts. This look up is protected by
rcu_read_lock().

It is necessary to remember whether a stripe is counted in
big_stripe_tree. Instead of adding new flag, we reuses existing flags:
STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE. If either of these
two flags are set, the stripe is counted in big_stripe_tree. This
requires moving set_bit(STRIPE_R5C_PARTIAL_STRIPE) to
r5c_try_caching_write().

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 146 ++++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/raid5.c       |  19 +++---
 drivers/md/raid5.h       |   1 +
 3 files changed, 152 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 817b294..268dcd2 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -162,9 +162,60 @@ struct r5l_log {
 
 	/* to submit async io_units, to fulfill ordering of flush */
 	struct work_struct deferred_io_work;
+
+	/* to for chunk_aligned_read in writeback mode, details below */
+	spinlock_t tree_lock;
+	struct radix_tree_root big_stripe_tree;
+	struct kmem_cache *bsi_kc;	/* kmem_cache for big_stripe_info */
+	mempool_t *big_stripe_info_pool;
 };
 
 /*
+ * Enable chunk_aligned_read() with write back cache.
+ *
+ * Each chunk may contain more than one stripe (for example, a 256kB
+ * chunk contains 64 4kB-page, so this chunk contain 64 stripes). For
+ * chunk_aligned_read, these stripes are grouped into one "big_stripe".
+ * For each big_stripe, struct big_stripe_info tracks how many stripes of
+ * this big_stripe are in the write back cache. These data are tracked
+ * in a radix tree (big_stripe_tree). big_stripe_index() is used to
+ * calculate keys for the radix tree.
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
+ * r5c_try_caching_write().
+ */
+struct big_stripe_info {
+	atomic_t count;
+#ifdef CONFIG_DEBUG_VM
+	void *pad;  /* suppress size check error in kmem_cache_sanity_check */
+#endif
+};
+
+/*
+ * calculate key for big_stripe_tree
+ *
+ * sect: align_bi->bi_iter.bi_sector or sh->sector
+ */
+static inline sector_t big_stripe_index(struct r5conf *conf,
+					sector_t sect)
+{
+	sector_t offset;
+
+	offset = sector_div(sect, conf->chunk_sectors *
+			    (conf->raid_disks - conf->max_degraded));
+	return sect;
+}
+
+/*
  * an IO range starts from a meta data block and end at the next meta data
  * block. The io unit's the meta data block tracks data/parity followed it. io
  * unit is written to log disk with normal write, as we always flush log disk
@@ -2293,6 +2344,8 @@ int r5c_try_caching_write(struct r5conf *conf,
 	int i;
 	struct r5dev *dev;
 	int to_cache = 0;
+	struct big_stripe_info *bsinfo;
+	sector_t bs_index;
 
 	BUG_ON(!r5c_is_writeback(log));
 
@@ -2327,6 +2380,37 @@ int r5c_try_caching_write(struct r5conf *conf,
 		}
 	}
 
+	/* if the stripe is not counted in big_stripe_tree, add it now */
+	if (!test_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state) &&
+	    !test_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
+		bs_index = big_stripe_index(conf, sh->sector);
+		spin_lock(&log->tree_lock);
+		bsinfo = radix_tree_lookup(&log->big_stripe_tree, bs_index);
+		if (bsinfo)
+			atomic_inc(&bsinfo->count);
+		else {
+			bsinfo = mempool_alloc(log->big_stripe_info_pool, GFP_ATOMIC);
+			if (bsinfo) {
+				atomic_set(&bsinfo->count, 1);
+				radix_tree_insert(&log->big_stripe_tree, bs_index, bsinfo);
+			}
+		}
+		spin_unlock(&log->tree_lock);
+		if (!bsinfo) {
+			/* in case we cannot allocate memory for the tree, do
+			 * not cache this stripe
+			 */
+			r5c_make_stripe_write_out(sh);
+			return -EAGAIN;
+		}
+
+		/* set STRIPE_R5C_PARTIAL_STRIPE, this shows the stripe is
+		 * counted in the radix tree
+		 */
+		set_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state);
+		atomic_dec(&conf->r5c_cached_partial_stripes);
+	}
+
 	for (i = disks; i--; ) {
 		dev = &sh->dev[i];
 		if (dev->towrite) {
@@ -2401,17 +2485,19 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 				 struct stripe_head *sh,
 				 struct stripe_head_state *s)
 {
+	struct r5l_log *log = conf->log;
 	int i;
 	int do_wakeup = 0;
+	struct big_stripe_info *bsinfo;
+	sector_t bs_index;
 
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
@@ -2433,13 +2519,26 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
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
+	atomic_dec(&log->stripe_in_journal_count);
+	r5c_update_log_state(log);
+
+	/* stop counting this stripe in big_stripe_tree */
+	if (test_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state) ||
+	    test_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
+		bs_index = big_stripe_index(conf, sh->sector);
+		bsinfo = radix_tree_lookup(&log->big_stripe_tree, bs_index);
+
+		if (atomic_dec_and_lock(&bsinfo->count, &log->tree_lock)) {
+			radix_tree_delete(&log->big_stripe_tree, bs_index);
+			spin_unlock(&log->tree_lock);
+			mempool_free(bsinfo, log->big_stripe_info_pool);
+		}
+	}
 
 	if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state)) {
 		BUG_ON(atomic_read(&conf->r5c_cached_partial_stripes) == 0);
@@ -2509,6 +2608,22 @@ r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 	return 0;
 }
 
+/* check whether this big stripe is in write back cache. */
+bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect)
+{
+	struct r5l_log *log = conf->log;
+	sector_t bs_index;
+	struct big_stripe_info *bsinfo;
+
+	if (!log)
+		return false;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	bs_index = big_stripe_index(conf, sect);
+	bsinfo = radix_tree_lookup(&log->big_stripe_tree, bs_index);
+	return bsinfo != NULL;
+}
+
 static int r5l_load_log(struct r5l_log *log)
 {
 	struct md_rdev *rdev = log->rdev;
@@ -2642,6 +2757,17 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (!log->meta_pool)
 		goto out_mempool;
 
+	log->bsi_kc = KMEM_CACHE(big_stripe_info, 0);
+	if (!log->bsi_kc)
+		goto bsi_kc;
+
+	log->big_stripe_info_pool = mempool_create_slab_pool(4, log->bsi_kc);
+	if (!log->big_stripe_info_pool)
+		goto big_stripe_info_pool;
+
+	spin_lock_init(&log->tree_lock);
+	INIT_RADIX_TREE(&log->big_stripe_tree, GFP_ATOMIC);
+
 	log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
 						 log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
@@ -2674,6 +2800,10 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	rcu_assign_pointer(conf->log, NULL);
 	md_unregister_thread(&log->reclaim_thread);
 reclaim_thread:
+	mempool_destroy(log->big_stripe_info_pool);
+big_stripe_info_pool:
+	kmem_cache_destroy(log->bsi_kc);
+bsi_kc:
 	mempool_destroy(log->meta_pool);
 out_mempool:
 	bioset_free(log->bs);
@@ -2689,6 +2819,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 void r5l_exit_log(struct r5l_log *log)
 {
 	md_unregister_thread(&log->reclaim_thread);
+	mempool_destroy(log->big_stripe_info_pool);
+	kmem_cache_destroy(log->bsi_kc);
 	mempool_destroy(log->meta_pool);
 	bioset_free(log->bs);
 	mempool_destroy(log->io_pool);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6d5391f..7608acc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -285,13 +285,12 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 						atomic_dec(&conf->r5c_cached_partial_stripes);
 					list_add_tail(&sh->lru, &conf->r5c_full_stripe_list);
 					r5c_check_cached_full_stripe(conf);
-				} else {
-					/* partial stripe */
-					if (!test_and_set_bit(STRIPE_R5C_PARTIAL_STRIPE,
-							      &sh->state))
-						atomic_inc(&conf->r5c_cached_partial_stripes);
+				} else
+					/* STRIPE_R5C_PARTIAL_STRIPE is set in
+					 * r5c_try_caching_write(). No need to
+					 * set it again.
+					 */
 					list_add_tail(&sh->lru, &conf->r5c_partial_stripe_list);
-				}
 			}
 		}
 	}
@@ -5020,6 +5019,13 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
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
@@ -5376,7 +5382,6 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	 * data on failed drives.
 	 */
 	if (rw == READ && mddev->degraded == 0 &&
-	    !r5c_is_writeback(conf->log) &&
 	    mddev->reshape_position == MaxSector) {
 		bi = chunk_aligned_read(mddev, bi);
 		if (!bi)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 6cc8d4c..efc9922 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -790,4 +790,5 @@ extern void r5c_flush_cache(struct r5conf *conf, int num);
 extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
 extern void r5c_check_cached_full_stripe(struct r5conf *conf);
 extern struct md_sysfs_entry r5c_journal_mode;
+extern bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect);
 #endif
-- 
2.9.3

