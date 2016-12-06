From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/2] md/r5cache: flush data only stripes in r5l_recovery_log()
Date: Mon, 5 Dec 2016 17:46:57 -0800
Message-ID: <20161206014657.3592902-2-songliubraving@fb.com>
References: <20161206014657.3592902-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161206014657.3592902-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

When there is data only stripes in the journal, we flush them out in
r5l_recovery_log().

We need conf->log in r5l_load_log(), so we need to set it before calling
r5l_load_log(). If r5l_load_log() fails, we set conf->log back to NULL.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 22 ++++++++++++++++++++--
 drivers/md/raid5.c       |  8 +++++++-
 drivers/md/raid5.h       |  4 ++++
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 93f3310..519a680 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2131,10 +2131,12 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 static int r5l_recovery_log(struct r5l_log *log)
 {
 	struct mddev *mddev = log->rdev->mddev;
+	struct r5conf *conf = mddev->private;
 	struct r5l_recovery_ctx ctx;
 	int ret;
 	sector_t pos;
 	struct stripe_head *sh;
+	unsigned long flags;
 
 	ctx.pos = log->last_checkpoint;
 	ctx.seq = log->last_cp_seq;
@@ -2172,12 +2174,26 @@ static int r5l_recovery_log(struct r5l_log *log)
 			 mdname(mddev), ctx.data_only_stripes,
 			 ctx.data_parity_stripes);
 
-		if (ctx.data_only_stripes > 0)
+		if (ctx.data_only_stripes > 0) {
+			log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_BACK;
 			if (r5c_recovery_rewrite_data_only_stripes(log, &ctx)) {
 				pr_err("md/raid:%s: failed to rewrite stripes to journal\n",
 				       mdname(mddev));
 				return -EIO;
 			}
+
+			set_bit(R5C_PRE_INIT_FLUSH, &conf->cache_state);
+			spin_lock_irqsave(&conf->device_lock, flags);
+			r5c_flush_cache(conf, INT_MAX);
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			md_wakeup_thread(conf->mddev->thread);
+			wait_event(conf->wait_for_r5c_pre_init_flush,
+				   atomic_read(&conf->active_stripes) == 0 &&
+				   atomic_read(&conf->r5c_cached_full_stripes) == 0 &&
+				   atomic_read(&conf->r5c_cached_partial_stripes) == 0);
+			clear_bit(R5C_PRE_INIT_FLUSH, &conf->cache_state);
+			log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
+		}
 	}
 
 	log->log_start = ctx.pos;
@@ -2628,14 +2644,16 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
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
index 6bf3c26..279f213 100644
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
@@ -264,6 +266,9 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			    < IO_THRESHOLD)
 				md_wakeup_thread(conf->mddev->thread);
 		atomic_dec(&conf->active_stripes);
+		if (test_bit(R5C_PRE_INIT_FLUSH, &conf->cache_state))
+		    	wake_up(&sh->raid_conf->wait_for_r5c_pre_init_flush);
+
 		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
 			if (!r5c_is_writeback(conf->log))
 				list_add_tail(&sh->lru, temp_inactive_list);
@@ -6638,6 +6643,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
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

