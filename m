From: JackieLiu <liuyun01@kylinos.cn>
Subject: [PATCH 1/4] md/raid5-cache: remove unnecessary function parameters
Date: Mon, 28 Nov 2016 16:19:18 +0800
Message-ID: <20161128081921.5641-1-liuyun01@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com
Cc: liuzhengyuan@kylinos.cn, linux-raid@vger.kernel.org, JackieLiu <liuyun01@kylinos.cn>
List-Id: linux-raid.ids

The function parameter 'recovery_list' is not used in
body, we can delete it

Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
---
 drivers/md/raid5-cache.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 5f817bd..576c88d 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -67,7 +67,7 @@ static char *r5c_journal_mode_str[] = {"write-through",
 /*
  * raid5 cache state machine
  *
- * With rhe RAID cache, each stripe works in two phases:
+ * With the RAID cache, each stripe works in two phases:
  *	- caching phase
  *	- writing-out phase
  *
@@ -1674,7 +1674,6 @@ r5l_recovery_replay_one_stripe(struct r5conf *conf,
 
 static struct stripe_head *
 r5c_recovery_alloc_stripe(struct r5conf *conf,
-			  struct list_head *recovery_list,
 			  sector_t stripe_sect,
 			  sector_t log_start)
 {
@@ -1855,8 +1854,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 						stripe_sect);
 
 		if (!sh) {
-			sh = r5c_recovery_alloc_stripe(conf, cached_stripe_list,
-						       stripe_sect, ctx->pos);
+			sh = r5c_recovery_alloc_stripe(conf, stripe_sect, ctx->pos);
 			/*
 			 * cannot get stripe from raid5_get_active_stripe
 			 * try replay some stripes
@@ -1865,8 +1863,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 				r5c_recovery_replay_stripes(
 					cached_stripe_list, ctx);
 				sh = r5c_recovery_alloc_stripe(
-					conf, cached_stripe_list,
-					stripe_sect, ctx->pos);
+					conf, stripe_sect, ctx->pos);
 			}
 			if (!sh) {
 				pr_debug("md/raid:%s: Increasing stripe cache size to %d to recovery data on journal.\n",
@@ -1875,8 +1872,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 				raid5_set_cache_size(mddev,
 						     conf->min_nr_stripes * 2);
 				sh = r5c_recovery_alloc_stripe(
-					conf, cached_stripe_list, stripe_sect,
-					ctx->pos);
+					conf, stripe_sect, ctx->pos);
 			}
 			if (!sh) {
 				pr_err("md/raid:%s: Cannot get enough stripes due to memory pressure. Recovery failed.\n",
-- 
2.7.4



