From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v6 11/11] md/r5cache: handle alloc_page failure
Date: Thu, 10 Nov 2016 12:46:23 -0800
Message-ID: <20161110204623.3484694-12-songliubraving@fb.com>
References: <20161110204623.3484694-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161110204623.3484694-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

RMW of r5c write back cache uses an extra page to store old data for
prexor. handle_stripe_dirtying() allocates this page by calling
alloc_page(). However, alloc_page() may fail.

To handle alloc_page() failures, this patch adds a small mempool
in r5l_log. When alloc_page fails, the code tries to allocate a
page from the mempool.

The mempool is small, so it maintains a waiting list so that only
R5C_EXTRA_PAGE_POOL_SIZE (2) stripes are using the mempool at a time.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 124 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c       |  62 ++++++++++++++++++------
 drivers/md/raid5.h       |   7 +++
 3 files changed, 177 insertions(+), 16 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index b83fd94..93c3caa 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -52,6 +52,8 @@
  */
 #define R5L_POOL_SIZE	4
 
+#define R5C_EXTRA_PAGE_POOL_SIZE	2
+
 /*
  * r5c journal modes of the array: write-back or write-through.
  * write-through mode has identical behavior as existing log only
@@ -163,6 +165,17 @@ struct r5l_log {
 
 	/* to submit async io_units, to fulfill ordering of flush */
 	struct work_struct deferred_io_work;
+
+	/* to handle alloc_page failures in handle_stripe_dirtying */
+	/* mempool for up to R5C_EXTRA_PAGE_POOL_SIZE stripes */
+	mempool_t *extra_page_pool;
+	/* stripes using the page pool */
+	struct stripe_head *extra_page_pool_stripes[R5C_EXTRA_PAGE_POOL_SIZE];
+	/* stripes waiting to use the page pool */
+	struct list_head extra_page_pool_waiting_list;
+	/* lock for extra_page_pool_stripes and extra_page_pool_waiting_list */
+	spinlock_t extra_page_pool_lock;
+
 };
 
 /*
@@ -253,6 +266,103 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
 }
 
+/*
+ * Try allocate pages from extra_page_pool
+ * The mempool only supports R5C_EXTRA_PAGE_POOL_SIZE stripes. More stripes
+ * are added to extra_page_pool_waiting_list.
+ *
+ * If allocation succeeded, return pointer to the page;
+ * Otherwise, return NULL
+ */
+struct page *r5c_alloc_page_from_extra_page_pool(struct stripe_head *sh,
+						 struct stripe_head_state *s,
+						 int dd_idx)
+{
+	struct r5conf *conf = sh->raid_conf;
+	struct r5l_log *log = conf->log;
+	int i;
+	bool using_the_pool = false;
+	struct page *p;
+
+	BUG_ON(!r5c_is_writeback(log));
+
+	spin_lock(&log->extra_page_pool_lock);
+	/* check whether sh is already using the mempool */
+	for (i = 0; i < R5C_EXTRA_PAGE_POOL_SIZE; i++)
+		if (log->extra_page_pool_stripes[i] == sh) {
+			using_the_pool = true;
+			break;
+		}
+
+	if (!using_the_pool)
+		/* try add sh to extra_page_pool_stripes */
+		for (i = 0; i < R5C_EXTRA_PAGE_POOL_SIZE; i++)
+			if (log->extra_page_pool_stripes[i] == NULL) {
+				using_the_pool = true;
+				log->extra_page_pool_stripes[i] = sh;
+				break;
+			}
+	spin_unlock(&log->extra_page_pool_lock);
+	if (using_the_pool) {
+		/* this mempool alloc should never fail */
+		p = mempool_alloc(log->extra_page_pool, GFP_ATOMIC);
+		BUG_ON(!p);
+		set_bit(R5_R5CMemPool, &sh->dev[dd_idx].flags);
+		return p;
+	}
+
+	/* add sh to waiting list */
+	atomic_inc(&sh->count);
+	WARN_ON(!list_empty(&sh->log_list));
+	spin_lock(&log->extra_page_pool_lock);
+	list_add_tail(&sh->log_list, &log->extra_page_pool_waiting_list);
+	spin_unlock(&log->extra_page_pool_lock);
+	s->waiting_extra_page = 1;
+	return NULL;
+}
+
+static void r5c_run_extra_page_pool_waiting_list(struct r5l_log *log)
+{
+	struct stripe_head *sh;
+
+	assert_spin_locked(&log->extra_page_pool_lock);
+	while (!list_empty(&log->extra_page_pool_waiting_list)) {
+		sh = list_first_entry(&log->extra_page_pool_waiting_list,
+				      struct stripe_head, log_list);
+		list_del_init(&sh->log_list);
+		set_bit(STRIPE_HANDLE, &sh->state);
+		raid5_release_stripe(sh);
+	}
+}
+
+void r5c_stripe_finish_using_extra_page_pool(struct stripe_head *sh)
+{
+	struct r5conf *conf = sh->raid_conf;
+	struct r5l_log *log = conf->log;
+	int i;
+	struct page *p;
+
+	/* return pages to extra_page_pool */
+	for (i = sh->disks; i--; )
+		if (test_and_clear_bit(R5_R5CMemPool, &sh->dev[i].flags)) {
+			p = sh->dev[i].page;
+			sh->dev[i].page = sh->dev[i].orig_page;
+			mempool_free(p, log->extra_page_pool);
+		}
+
+	/* remove sh from extra_page_pool_stripes */
+	spin_lock(&log->extra_page_pool_lock);
+	for (i = 0; i < R5C_EXTRA_PAGE_POOL_SIZE; i++)
+		if (log->extra_page_pool_stripes[i] == sh) {
+			log->extra_page_pool_stripes[i] = NULL;
+			r5c_run_extra_page_pool_waiting_list(log);
+			spin_unlock(&log->extra_page_pool_lock);
+			return;
+		}
+	/* didn't find sh in extra_page_pool_stripes? it must be a bug */
+	BUG();
+}
+
 static void
 r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev,
 			      struct bio_list *return_bi)
@@ -2457,6 +2567,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 {
 	struct request_queue *q = bdev_get_queue(rdev->bdev);
 	struct r5l_log *log;
+	int i;
 
 	if (PAGE_SIZE != 4096)
 		return -EINVAL;
@@ -2511,6 +2622,16 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (!log->meta_pool)
 		goto out_mempool;
 
+	log->extra_page_pool = mempool_create_page_pool(
+		R5C_EXTRA_PAGE_POOL_SIZE *
+		(conf->raid_disks - conf->max_degraded), 0);
+	if (!log->extra_page_pool)
+		goto extra_page_pool;
+	for (i = 0; i < R5C_EXTRA_PAGE_POOL_SIZE; i++)
+		log->extra_page_pool_stripes[i] = NULL;
+	INIT_LIST_HEAD(&log->extra_page_pool_waiting_list);
+	spin_lock_init(&log->extra_page_pool_lock);
+
 	log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
 						 log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
@@ -2541,6 +2662,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 error:
 	md_unregister_thread(&log->reclaim_thread);
 reclaim_thread:
+	mempool_destroy(log->extra_page_pool);
+extra_page_pool:
 	mempool_destroy(log->meta_pool);
 out_mempool:
 	bioset_free(log->bs);
@@ -2556,6 +2679,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 void r5l_exit_log(struct r5l_log *log)
 {
 	md_unregister_thread(&log->reclaim_thread);
+	mempool_destroy(log->extra_page_pool);
 	mempool_destroy(log->meta_pool);
 	bioset_free(log->bs);
 	mempool_destroy(log->io_pool);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1ed9632..4ff2c96 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -880,6 +880,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	if (test_bit(STRIPE_R5C_WRITE_OUT, &sh->state)) {
 		/* writing out mode */
+		if (s->waiting_extra_page)
+			return;
 		if (r5l_write_stripe(conf->log, sh) == 0)
 			return;
 	} else {
@@ -1533,6 +1535,7 @@ static void ops_complete_prexor(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
 	int i;
+	bool using_extra_page_pool = false;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
@@ -1546,11 +1549,18 @@ static void ops_complete_prexor(void *stripe_head_ref)
 	 */
 	for (i = sh->disks; i--; )
 		if (sh->dev[i].page != sh->dev[i].orig_page) {
-			struct page *p = sh->dev[i].page;
+			struct page *p;
 
-			sh->dev[i].page = sh->dev[i].orig_page;
-			put_page(p);
+			if (test_bit(R5_R5CMemPool, &sh->dev[i].flags))
+				using_extra_page_pool = true;
+			else {
+				p = sh->dev[i].page;
+				sh->dev[i].page = sh->dev[i].orig_page;
+				put_page(p);
+			}
 		}
+	if (using_extra_page_pool)
+		r5c_stripe_finish_using_extra_page_pool(sh);
 }
 
 static struct dma_async_tx_descriptor *
@@ -2012,6 +2022,7 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 		INIT_LIST_HEAD(&sh->batch_list);
 		INIT_LIST_HEAD(&sh->lru);
 		INIT_LIST_HEAD(&sh->r5c);
+		INIT_LIST_HEAD(&sh->log_list);
 		atomic_set(&sh->count, 1);
 		sh->log_start = MaxSector;
 		for (i = 0; i < disks; i++) {
@@ -2878,6 +2889,7 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 	int i, pd_idx = sh->pd_idx, qd_idx = sh->qd_idx, disks = sh->disks;
 	struct r5conf *conf = sh->raid_conf;
 	int level = conf->level;
+	bool using_extra_page_pool = false;
 
 	if (rcw) {
 
@@ -2892,10 +2904,15 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 			 * ops_complete_prexor().
 			 */
 			if (sh->dev[i].page != sh->dev[i].orig_page) {
-				struct page *p = sh->dev[i].page;
+				struct page *p;
 
-				sh->dev[i].page = sh->dev[i].orig_page;
-				put_page(p);
+				if (test_bit(R5_R5CMemPool, &sh->dev[i].flags))
+					using_extra_page_pool = true;
+				else {
+					p = sh->dev[i].page;
+					sh->dev[i].page = sh->dev[i].orig_page;
+					put_page(p);
+				}
 			}
 
 			if (dev->towrite) {
@@ -2909,6 +2926,9 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 				s->locked++;
 			}
 		}
+		if (using_extra_page_pool)
+			r5c_stripe_finish_using_extra_page_pool(sh);
+
 		/* if we are not expanding this is a proper write request, and
 		 * there will be bios with new data to be drained into the
 		 * stripe cache
@@ -3592,16 +3612,16 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 		break_stripe_batch_list(head_sh, STRIPE_EXPAND_SYNC_FLAGS);
 }
 
-static void handle_stripe_dirtying(struct r5conf *conf,
-				   struct stripe_head *sh,
-				   struct stripe_head_state *s,
-				   int disks)
+static int handle_stripe_dirtying(struct r5conf *conf,
+				  struct stripe_head *sh,
+				  struct stripe_head_state *s,
+				  int disks)
 {
 	int rmw = 0, rcw = 0, i;
 	sector_t recovery_cp = conf->mddev->recovery_cp;
 
 	if (r5c_handle_stripe_dirtying(conf, sh, s, disks) == 0)
-		return;
+		return 0;
 
 	/* Check whether resync is now happening or should start.
 	 * If yes, then the array is dirty (after unclean shutdown or
@@ -3662,13 +3682,21 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 			struct r5dev *dev = &sh->dev[i];
 			if (test_bit(R5_InJournal, &dev->flags) &&
 			    dev->page == dev->orig_page) {
-				/* alloc page for prexor */
-				dev->page = alloc_page(GFP_NOIO);
+				struct page *p;
 
-				/* will handle failure in a later patch*/
-				BUG_ON(!dev->page);
+				/* alloc page for prexor */
+				p = alloc_page(GFP_NOIO);
+				if (!p) {
+					p = r5c_alloc_page_from_extra_page_pool(sh, s, i);
+					if (!p)  /* added to waiting list, try again later */
+						return -EAGAIN;
+				}
+				dev->page = p;
 			}
+		}
 
+		for (i = disks; i--; ) {
+			struct r5dev *dev = &sh->dev[i];
 			if ((dev->towrite ||
 			     i == sh->pd_idx || i == sh->qd_idx ||
 			     test_bit(R5_InJournal, &dev->flags)) &&
@@ -3744,6 +3772,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	    (s->locked == 0 && (rcw == 0 || rmw == 0) &&
 	     !test_bit(STRIPE_BIT_DELAY, &sh->state)))
 		schedule_reconstruction(sh, s, rcw == 0, 0);
+	return 0;
 }
 
 static void handle_parity_checks5(struct r5conf *conf, struct stripe_head *sh,
@@ -4535,7 +4564,8 @@ static void handle_stripe(struct stripe_head *sh)
 	 */
 	if ((s.to_write || test_bit(STRIPE_R5C_WRITE_OUT, &sh->state)) &&
 	    !sh->reconstruct_state && !sh->check_state && !sh->log_io)
-		handle_stripe_dirtying(conf, sh, &s, disks);
+		if (handle_stripe_dirtying(conf, sh, &s, disks) == -EAGAIN)
+			goto finish;
 
 	/* maybe we need to check and possibly fix the parity for this stripe
 	 * Any reads will already have been scheduled, so we just see if enough
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 4261c3d..2ff62c1 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -276,6 +276,7 @@ struct stripe_head_state {
 	struct md_rdev *blocked_rdev;
 	int handle_bad_blocks;
 	int log_failed;
+	int waiting_extra_page;
 };
 
 /* Flags for struct r5dev.flags */
@@ -317,6 +318,9 @@ enum r5dev_flags {
 	R5_Discard,	/* Discard the stripe */
 	R5_SkipCopy,	/* Don't copy data from bio to stripe cache */
 	R5_InJournal,	/* data being written is in the journal device */
+	R5_R5CMemPool,	/* because of alloc_page failure, data page of this
+			 * dev is allocated from r5l_log.extra_page_pool
+			 */
 };
 
 /*
@@ -755,5 +759,8 @@ extern void r5c_make_stripe_write_out(struct stripe_head *sh);
 extern void r5c_flush_cache(struct r5conf *conf, int num);
 extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
 extern void r5c_check_cached_full_stripe(struct r5conf *conf);
+extern struct page *r5c_alloc_page_from_extra_page_pool(
+	struct stripe_head *sh, struct stripe_head_state *s, int dd_idx);
+extern void r5c_stripe_finish_using_extra_page_pool(struct stripe_head *sh);
 extern struct md_sysfs_entry r5c_journal_mode;
 #endif
-- 
2.9.3

