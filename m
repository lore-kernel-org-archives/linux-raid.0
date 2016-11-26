From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH 1/2] raid5-cache: add another check conditon before replaying one stripe
Date: Sat, 26 Nov 2016 10:57:13 +0800
Message-ID: <1480129034-14700-1-git-send-email-liuzhengyuan@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com, songliubraving@fb.com
Cc: neilb@suse.com, linux-raid@vger.kernel.org, liuyun01@kylinos.cn
List-Id: linux-raid.ids

New stripe that was just allocated has no STRIPE_R5C_CACHING state too,
add this check condition could avoid unnecessary replaying for empty stripe.

r5l_recovery_replay_one_stripe would reset stripe for any case, delete it
to make code more clean.

Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
---
 drivers/md/raid5-cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 5f817bd..9911164 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1887,9 +1887,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 		}
 
 		if (payload->header.type == R5LOG_PAYLOAD_DATA) {
-			if (!test_bit(STRIPE_R5C_CACHING, &sh->state)) {
+			if (!test_bit(STRIPE_R5C_CACHING, &sh->state) &&
+			    test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags)) {
 				r5l_recovery_replay_one_stripe(conf, sh, ctx);
-				r5l_recovery_reset_stripe(sh);
 				sh->log_start = ctx->pos;
 				list_move_tail(&sh->lru, cached_stripe_list);
 			}
-- 
2.7.4



