From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] md/r5cache: handle alloc_page failure
Date: Fri, 18 Nov 2016 23:20:57 -0800
Message-ID: <20161119072057.1302854-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

RMW of r5c write back cache uses an extra page to store old data for
prexor. handle_stripe_dirtying() allocates this page by calling
alloc_page(). However, alloc_page() may fail.

To handle alloc_page() failures, this patch adds a small mempool
in r5l_log. When alloc_page fails, the stripe is added to a waiting
list. Then, these stripes get pages from the mempool (from work queue).

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 100 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid5.c       |  34 +++++++++++-----
 drivers/md/raid5.h       |   6 +++
 3 files changed, 130 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 8cb79fc..ce7f114 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -51,6 +51,8 @@
  */
 #define R5L_POOL_SIZE	4
 
+#define R5C_EXTRA_PAGE_POOL_SIZE	2
+
 /*
  * r5c journal modes of the array: write-back or write-through.
  * write-through mode has identical behavior as existing log only
@@ -162,6 +164,16 @@ struct r5l_log {
 
 	/* to submit async io_units, to fulfill ordering of flush */
 	struct work_struct deferred_io_work;
+
+	/* to handle alloc_page failures in handle_stripe_dirtying() */
+	/* mempool for up to R5C_EXTRA_PAGE_POOL_SIZE stripes */
+	mempool_t *extra_page_pool;
+	/* list of stripes waiting to use the page pool */
+	struct list_head extra_page_pool_list;
+	/* lock for extra_page_pool_list */
+	spinlock_t extra_page_pool_lock;
+	/* work that allocates pages from extra_page_pool */
+	struct work_struct extra_page_pool_work;
 };
 
 /*
@@ -252,6 +264,69 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
 }
 
+void r5c_add_to_extra_page_pool_list(struct stripe_head *sh,
+				     struct stripe_head_state *s)
+{
+	struct r5conf *conf = sh->raid_conf;
+	struct r5l_log *log = conf->log;
+	int i;
+	struct page *p;
+
+	BUG_ON(!log);
+
+	/* free any extra orig_page from alloc_page() */
+	for (i = sh->disks; i--; )
+		if (sh->dev[i].page != sh->dev[i].orig_page) {
+			p = sh->dev[i].orig_page;
+			sh->dev[i].orig_page = sh->dev[i].page;
+			put_page(p);
+		}
+
+	WARN_ON(!list_empty(&sh->log_list));
+
+	atomic_inc(&sh->count);
+	set_bit(STRIPE_R5C_EXTRA_PAGE, &sh->state);
+
+	spin_lock(&log->extra_page_pool_lock);
+	list_add_tail(&sh->log_list, &log->extra_page_pool_list);
+	spin_unlock(&log->extra_page_pool_lock);
+
+	s->waiting_extra_page = 1;
+	schedule_work(&log->extra_page_pool_work);
+}
+
+static void r5c_run_extra_page_pool_list(struct work_struct *work)
+{
+	struct r5l_log *log = container_of(work, struct r5l_log,
+					   extra_page_pool_work);
+	struct stripe_head *sh;
+	struct r5dev *dev;
+	int i;
+
+	while (1) {
+		spin_lock(&log->extra_page_pool_lock);
+		if (list_empty(&log->extra_page_pool_list)) {
+			spin_unlock(&log->extra_page_pool_lock);
+			break;
+		}
+		sh = list_first_entry(&log->extra_page_pool_list,
+				      struct stripe_head, log_list);
+		list_del_init(&sh->log_list);
+		spin_unlock(&log->extra_page_pool_lock);
+
+		for (i = sh->disks; i--; ) {
+			dev = &sh->dev[i];
+			BUG_ON(dev->page != dev->orig_page);
+
+			if (test_bit(R5_InJournal, &dev->flags))
+				dev->orig_page = mempool_alloc(
+					log->extra_page_pool, GFP_NOIO);
+		}
+		set_bit(STRIPE_HANDLE, &sh->state);
+		raid5_release_stripe(sh);
+	}
+}
+
 static void
 r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev,
 			      struct bio_list *return_bi)
@@ -2334,14 +2409,25 @@ int r5c_try_caching_write(struct r5conf *conf,
  */
 void r5c_release_extra_page(struct stripe_head *sh)
 {
+	struct r5conf *conf = sh->raid_conf;
+	struct r5l_log *log = conf->log;
 	int i;
+	bool using_extra_page_pool;;
+
+	BUG_ON(!log);
+
+	using_extra_page_pool = test_and_clear_bit(
+		STRIPE_R5C_EXTRA_PAGE, &sh->state);
 
 	for (i = sh->disks; i--; )
 		if (sh->dev[i].page != sh->dev[i].orig_page) {
 			struct page *p = sh->dev[i].orig_page;
 
 			sh->dev[i].orig_page = sh->dev[i].page;
-			put_page(p);
+			if (using_extra_page_pool)
+				mempool_free(p, log->extra_page_pool);
+			else
+				put_page(p);
 		}
 }
 
@@ -2581,6 +2667,15 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (!log->meta_pool)
 		goto out_mempool;
 
+	log->extra_page_pool = mempool_create_page_pool(
+		R5C_EXTRA_PAGE_POOL_SIZE *
+		(conf->raid_disks - conf->max_degraded), 0);
+	if (!log->extra_page_pool)
+		goto extra_page_pool;
+	INIT_LIST_HEAD(&log->extra_page_pool_list);
+	spin_lock_init(&log->extra_page_pool_lock);
+	INIT_WORK(&log->extra_page_pool_work, r5c_run_extra_page_pool_list);
+
 	log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
 						 log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
@@ -2611,6 +2706,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 error:
 	md_unregister_thread(&log->reclaim_thread);
 reclaim_thread:
+	mempool_destroy(log->extra_page_pool);
+extra_page_pool:
 	mempool_destroy(log->meta_pool);
 out_mempool:
 	bioset_free(log->bs);
@@ -2626,6 +2723,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 void r5l_exit_log(struct r5l_log *log)
 {
 	md_unregister_thread(&log->reclaim_thread);
+	mempool_destroy(log->extra_page_pool);
 	mempool_destroy(log->meta_pool);
 	bioset_free(log->bs);
 	mempool_destroy(log->io_pool);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dbab8c7..5870ca9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -876,6 +876,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	if (!test_bit(STRIPE_R5C_CACHING, &sh->state)) {
 		/* writing out phase */
+		if (s->waiting_extra_page)
+			return;
 		if (r5l_write_stripe(conf->log, sh) == 0)
 			return;
 	} else {  /* caching phase */
@@ -2007,6 +2009,7 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 		INIT_LIST_HEAD(&sh->batch_list);
 		INIT_LIST_HEAD(&sh->lru);
 		INIT_LIST_HEAD(&sh->r5c);
+		INIT_LIST_HEAD(&sh->log_list);
 		atomic_set(&sh->count, 1);
 		sh->log_start = MaxSector;
 		for (i = 0; i < disks; i++) {
@@ -2897,6 +2900,7 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 				s->locked++;
 			}
 		}
+
 		/* if we are not expanding this is a proper write request, and
 		 * there will be bios with new data to be drained into the
 		 * stripe cache
@@ -3580,10 +3584,10 @@ static void handle_stripe_clean_event(struct r5conf *conf,
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
@@ -3649,12 +3653,19 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 			    dev->page == dev->orig_page &&
 			    !test_bit(R5_LOCKED, &sh->dev[sh->pd_idx].flags)) {
 				/* alloc page for prexor */
-				dev->orig_page = alloc_page(GFP_NOIO);
+				struct page *p;
 
-				/* will handle failure in a later patch*/
-				BUG_ON(!dev->orig_page);
+				p = alloc_page(GFP_NOIO);
+				if (!p) {
+					r5c_add_to_extra_page_pool_list(sh, s);
+					return -EAGAIN;
+				}
+				dev->orig_page = p;
 			}
+		}
 
+		for (i = disks; i--; ) {
+			struct r5dev *dev = &sh->dev[i];
 			if ((dev->towrite ||
 			     i == sh->pd_idx || i == sh->qd_idx ||
 			     test_bit(R5_InJournal, &dev->flags)) &&
@@ -3730,6 +3741,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	    (s->locked == 0 && (rcw == 0 || rmw == 0) &&
 	     !test_bit(STRIPE_BIT_DELAY, &sh->state)))
 		schedule_reconstruction(sh, s, rcw == 0, 0);
+	return 0;
 }
 
 static void handle_parity_checks5(struct r5conf *conf, struct stripe_head *sh,
@@ -4545,8 +4557,12 @@ static void handle_stripe(struct stripe_head *sh)
 			if (ret == -EAGAIN ||
 			    /* stripe under reclaim: !caching && injournal */
 			    (!test_bit(STRIPE_R5C_CACHING, &sh->state) &&
-			     s.injournal > 0))
-				handle_stripe_dirtying(conf, sh, &s, disks);
+			     s.injournal > 0)) {
+				ret = handle_stripe_dirtying(conf, sh, &s,
+							     disks);
+				if (ret == -EAGAIN)
+					goto finish;
+			}
 		}
 	}
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index d13fe45..e0efd46 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -276,6 +276,7 @@ struct stripe_head_state {
 	struct md_rdev *blocked_rdev;
 	int handle_bad_blocks;
 	int log_failed;
+	int waiting_extra_page;
 };
 
 /* Flags for struct r5dev.flags */
@@ -377,6 +378,9 @@ enum {
 				 * in conf->r5c_full_stripe_list)
 				 */
 	STRIPE_R5C_PREFLUSH,	/* need to flush journal device */
+	STRIPE_R5C_EXTRA_PAGE,	/* extra orig_page of this stripe is allocated
+				 * from r5l_log->extra_page_pool
+				 */
 };
 
 #define STRIPE_EXPAND_SYNC_FLAGS \
@@ -774,5 +778,7 @@ extern void r5c_make_stripe_write_out(struct stripe_head *sh);
 extern void r5c_flush_cache(struct r5conf *conf, int num);
 extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
 extern void r5c_check_cached_full_stripe(struct r5conf *conf);
+extern void r5c_add_to_extra_page_pool_list(struct stripe_head *sh,
+					    struct stripe_head_state *s);
 extern struct md_sysfs_entry r5c_journal_mode;
 #endif
-- 
2.9.3

