From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/2] md/r5cache: flush data only stripes in r5l_recovery_log()
Date: Wed, 7 Dec 2016 11:36:36 -0800
Message-ID: <20161207193637.3905500-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

When there is data only stripes in the journal, we flush them out in
r5l_recovery_log(). Ths logic is implemented in a new function:
r5c_recovery_flush_data_only_stripes();

We need conf->log in r5l_load_log(), so we need to set it before calling
r5l_load_log(). If r5l_load_log() fails, we set conf->log back to NULL.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 60 +++++++++++++++++++++++++++++++++++-------------
 drivers/md/raid5.c       |  9 +++++++-
 drivers/md/raid5.h       |  4 ++++
 3 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index ae2684a..830bb7f 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2061,7 +2061,7 @@ static int
 r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 				       struct r5l_recovery_ctx *ctx)
 {
-	struct stripe_head *sh, *next;
+	struct stripe_head *sh;
 	struct mddev *mddev = log->rdev->mddev;
 	struct page *page;
 
@@ -2072,7 +2072,7 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 		return -ENOMEM;
 	}
 
-	list_for_each_entry_safe(sh, next, &ctx->cached_list, lru) {
+	list_for_each_entry(sh, &ctx->cached_list, lru) {
 		struct r5l_meta_block *mb;
 		int i;
 		int offset;
@@ -2123,13 +2123,39 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 		ctx->pos = write_pos;
 		ctx->seq += 1;
 		log->next_checkpoint = sh->log_start;
-		list_del_init(&sh->lru);
-		raid5_release_stripe(sh);
 	}
 	__free_page(page);
 	return 0;
 }
 
+static void r5c_recovery_flush_data_only_stripes(struct r5l_log *log,
+						 struct r5l_recovery_ctx *ctx)
+{
+	struct mddev *mddev = log->rdev->mddev;
+	struct r5conf *conf = mddev->private;
+	struct stripe_head *sh, *next;
+
+	if (ctx->data_only_stripes == 0)
+		return;
+
+	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_BACK;
+	set_bit(R5C_PRE_INIT_FLUSH, &conf->cache_state);
+
+	list_for_each_entry_safe(sh, next, &ctx->cached_list, lru) {
+		list_del_init(&sh->lru);
+		raid5_release_stripe(sh);
+	}
+
+	md_wakeup_thread(conf->mddev->thread);
+	wait_event(conf->wait_for_r5c_pre_init_flush,
+		   atomic_read(&conf->active_stripes) == 0 &&
+		   atomic_read(&conf->r5c_cached_full_stripes) == 0 &&
+		   atomic_read(&conf->r5c_cached_partial_stripes) == 0);
+
+	clear_bit(R5C_PRE_INIT_FLUSH, &conf->cache_state);
+	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
+}
+
 static int r5l_recovery_log(struct r5l_log *log)
 {
 	struct mddev *mddev = log->rdev->mddev;
@@ -2156,11 +2182,6 @@ static int r5l_recovery_log(struct r5l_log *log)
 	pos = ctx.pos;
 	ctx.seq += 1000;
 
-	if (ctx.data_only_stripes == 0) {
-		log->next_checkpoint = ctx.pos;
-		r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq++);
-		ctx.pos = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
-	}
 
 	if ((ctx.data_only_stripes == 0) && (ctx.data_parity_stripes == 0))
 		pr_debug("md/raid:%s: starting from clean shutdown\n",
@@ -2169,19 +2190,24 @@ static int r5l_recovery_log(struct r5l_log *log)
 		pr_debug("md/raid:%s: recoverying %d data-only stripes and %d data-parity stripes\n",
 			 mdname(mddev), ctx.data_only_stripes,
 			 ctx.data_parity_stripes);
+	}
 
-		if (ctx.data_only_stripes > 0)
-			if (r5c_recovery_rewrite_data_only_stripes(log, &ctx)) {
-				pr_err("md/raid:%s: failed to rewrite stripes to journal\n",
-				       mdname(mddev));
-				return -EIO;
-			}
+	if (ctx.data_only_stripes == 0) {
+		log->next_checkpoint = ctx.pos;
+		r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq++);
+		ctx.pos = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
+	} else if (r5c_recovery_rewrite_data_only_stripes(log, &ctx)) {
+		pr_err("md/raid:%s: failed to rewrite stripes to journal\n",
+		       mdname(mddev));
+		return -EIO;
 	}
 
 	log->log_start = ctx.pos;
 	log->seq = ctx.seq;
 	log->last_checkpoint = pos;
 	r5l_write_super(log, pos);
+
+	r5c_recovery_flush_data_only_stripes(log, &ctx);
 	return 0;
 }
 
@@ -2626,14 +2652,16 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	spin_lock_init(&log->stripe_in_journal_lock);
 	atomic_set(&log->stripe_in_journal_count, 0);
 
+	rcu_assign_pointer(conf->log, log);
+
 	if (r5l_load_log(log))
 		goto error;
 
-	rcu_assign_pointer(conf->log, log);
 	set_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
 	return 0;
 
 error:
+	rcu_assign_pointer(conf->log, NULL);
 	md_unregister_thread(&log->reclaim_thread);
 reclaim_thread:
 	mempool_destroy(log->meta_pool);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6bf3c26..524b041 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -232,7 +232,9 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 	 * When quiesce in r5c write back, set STRIPE_HANDLE for stripes with
 	 * data in journal, so they are not released to cached lists
 	 */
-	if (conf->quiesce && r5c_is_writeback(conf->log) &&
+	if ((conf->quiesce ||
+	     test_bit(R5C_PRE_INIT_FLUSH, &conf->cache_state)) &&
+	    r5c_is_writeback(conf->log) &&
 	    !test_bit(STRIPE_HANDLE, &sh->state) && injournal != 0) {
 		if (test_bit(STRIPE_R5C_CACHING, &sh->state))
 			r5c_make_stripe_write_out(sh);
@@ -264,6 +266,10 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			    < IO_THRESHOLD)
 				md_wakeup_thread(conf->mddev->thread);
 		atomic_dec(&conf->active_stripes);
+		if (test_bit(R5C_PRE_INIT_FLUSH, &conf->cache_state) &&
+		    atomic_read(&conf->active_stripes) == 0)
+			wake_up(&sh->raid_conf->wait_for_r5c_pre_init_flush);
+
 		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
 			if (!r5c_is_writeback(conf->log))
 				list_add_tail(&sh->lru, temp_inactive_list);
@@ -6638,6 +6644,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	init_waitqueue_head(&conf->wait_for_quiescent);
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
+	init_waitqueue_head(&conf->wait_for_r5c_pre_init_flush);
 	INIT_LIST_HEAD(&conf->handle_list);
 	INIT_LIST_HEAD(&conf->hold_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index ed8e136..b39fe46 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -564,6 +564,9 @@ enum r5_cache_state {
 	R5C_EXTRA_PAGE_IN_USE,	/* a stripe is using disk_info.extra_page
 				 * for prexor
 				 */
+	R5C_PRE_INIT_FLUSH,	/* flushing data only stripes recovered from
+				 * the journal
+				 */
 };
 
 struct r5conf {
@@ -679,6 +682,7 @@ struct r5conf {
 	int			group_cnt;
 	int			worker_cnt_per_group;
 	struct r5l_log		*log;
+	wait_queue_head_t	wait_for_r5c_pre_init_flush;
 };
 
 
-- 
2.9.3

