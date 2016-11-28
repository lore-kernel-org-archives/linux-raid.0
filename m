From: JackieLiu <liuyun01@kylinos.cn>
Subject: [PATCH 3/4] md/raid5-cache: release the stripe_head at the appropriate location
Date: Mon, 28 Nov 2016 16:19:20 +0800
Message-ID: <20161128081921.5641-3-liuyun01@kylinos.cn>
References: <20161128081921.5641-1-liuyun01@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161128081921.5641-1-liuyun01@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com
Cc: liuzhengyuan@kylinos.cn, linux-raid@vger.kernel.org, JackieLiu <liuyun01@kylinos.cn>
List-Id: linux-raid.ids

If we released the 'stripe_head' in r5c_recovery_flush_log,
ctx->cached_list will both release the data-parity stripes and
data-only stripes, which will become empty.
And we also need to use the data-only stripes in
r5c_recovery_rewrite_data_only_stripes, so we should wait util rewrite
data-only stripes is done before releasing them.

Reviewed-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
---
 drivers/md/raid5-cache.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 6d2b1da..9e72180 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1950,7 +1950,7 @@ static void r5c_recovery_load_one_stripe(struct r5l_log *log,
 static int r5c_recovery_flush_log(struct r5l_log *log,
 				  struct r5l_recovery_ctx *ctx)
 {
-	struct stripe_head *sh, *next;
+	struct stripe_head *sh;
 	int ret = 0;
 
 	/* scan through the log */
@@ -1979,11 +1979,9 @@ static int r5c_recovery_flush_log(struct r5l_log *log,
 	r5c_recovery_replay_stripes(&ctx->cached_list, ctx);
 
 	/* load data-only stripes to stripe cache */
-	list_for_each_entry_safe(sh, next, &ctx->cached_list, lru) {
+	list_for_each_entry(sh, &ctx->cached_list, lru) {
 		WARN_ON(!test_bit(STRIPE_R5C_CACHING, &sh->state));
 		r5c_recovery_load_one_stripe(log, sh);
-		list_del_init(&sh->lru);
-		raid5_release_stripe(sh);
 		ctx->data_only_stripes++;
 	}
 
@@ -2063,7 +2061,7 @@ static int
 r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 				       struct r5l_recovery_ctx *ctx)
 {
-	struct stripe_head *sh;
+	struct stripe_head *sh, *next;
 	struct mddev *mddev = log->rdev->mddev;
 	struct page *page;
 
@@ -2075,7 +2073,7 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 	}
 
 	ctx->seq += 10;
-	list_for_each_entry(sh, &ctx->cached_list, lru) {
+	list_for_each_entry_safe(sh, next, &ctx->cached_list, lru) {
 		struct r5l_meta_block *mb;
 		int i;
 		int offset;
@@ -2121,6 +2119,9 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 		sh->log_start = ctx->pos;
 		ctx->pos = write_pos;
 		ctx->seq += 1;
+
+		list_del_init(&sh->lru);
+		raid5_release_stripe(sh);
 	}
 	__free_page(page);
 	return 0;
-- 
2.7.4



