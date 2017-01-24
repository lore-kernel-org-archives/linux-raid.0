From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 1/3] md/r5cache: flush data only stripes in r5l_recovery_log()
Date: Mon, 23 Jan 2017 17:12:57 -0800
Message-ID: <20170124011259.3351506-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

For safer operation, all arrays start in write-through mode.
However, if recovery found data-only stripes before the shutdown
(from previous write-back mode), it is not safe to run the array
in write-through mode. To solve this problem, we flush all data-only
stripes in r5l_recovery_log(). This logic is implemented in
r5c_recovery_flush_data_only_stripes():

1. enable write back cache
2. flush all stripes
3. wake up conf->mddev->thread
4. wait for all stripes get flushed (reuse wait_for_quiescent)
5. disable write back cache

The wait in 4 will be waked up in release_inactive_stripe_list()
when conf->active_stripes reaches 0.

It is safe to wake up mddev->thread here because all the resource
required for the thread has been initialized.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/md.c          |  5 +++++
 drivers/md/raid5-cache.c | 56 ++++++++++++++++++++++++++++++++++--------------
 2 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0abb147..85ac984 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5333,6 +5333,11 @@ int md_run(struct mddev *mddev)
 	if (start_readonly && mddev->ro == 0)
 		mddev->ro = 2; /* read-only, but switch on first write */
 
+	/*
+	 * NOTE: some pers->run(), for example r5l_recovery_log(), wakes
+	 * up mddev->thread. It is important to initialize critical
+	 * resources for mddev->thread BEFORE calling pers->run().
+	 */
 	err = pers->run(mddev);
 	if (err)
 		pr_warn("md: pers->run() failed ...\n");
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 3da5e2a..00d2838 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2102,7 +2102,7 @@ static int
 r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 				       struct r5l_recovery_ctx *ctx)
 {
-	struct stripe_head *sh, *next;
+	struct stripe_head *sh;
 	struct mddev *mddev = log->rdev->mddev;
 	struct page *page;
 	sector_t next_checkpoint = MaxSector;
@@ -2116,7 +2116,7 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 
 	WARN_ON(list_empty(&ctx->cached_list));
 
-	list_for_each_entry_safe(sh, next, &ctx->cached_list, lru) {
+	list_for_each_entry(sh, &ctx->cached_list, lru) {
 		struct r5l_meta_block *mb;
 		int i;
 		int offset;
@@ -2166,14 +2166,39 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 		ctx->pos = write_pos;
 		ctx->seq += 1;
 		next_checkpoint = sh->log_start;
-		list_del_init(&sh->lru);
-		raid5_release_stripe(sh);
 	}
 	log->next_checkpoint = next_checkpoint;
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
+
+	list_for_each_entry_safe(sh, next, &ctx->cached_list, lru) {
+		r5c_make_stripe_write_out(sh);
+		set_bit(STRIPE_HANDLE, &sh->state);
+		list_del_init(&sh->lru);
+		raid5_release_stripe(sh);
+	}
+
+	md_wakeup_thread(conf->mddev->thread);
+	/* reuse conf->wait_for_quiescent in recovery */
+	wait_event(conf->wait_for_quiescent,
+		   atomic_read(&conf->active_stripes) == 0);
+
+	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
+}
+
 static int r5l_recovery_log(struct r5l_log *log)
 {
 	struct mddev *mddev = log->rdev->mddev;
@@ -2200,32 +2225,31 @@ static int r5l_recovery_log(struct r5l_log *log)
 	pos = ctx.pos;
 	ctx.seq += 10000;
 
-	if (ctx.data_only_stripes == 0) {
-		log->next_checkpoint = ctx.pos;
-		r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq++);
-		ctx.pos = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
-	}
 
 	if ((ctx.data_only_stripes == 0) && (ctx.data_parity_stripes == 0))
 		pr_debug("md/raid:%s: starting from clean shutdown\n",
 			 mdname(mddev));
-	else {
+	else
 		pr_debug("md/raid:%s: recovering %d data-only stripes and %d data-parity stripes\n",
 			 mdname(mddev), ctx.data_only_stripes,
 			 ctx.data_parity_stripes);
 
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
 
-- 
2.9.3

