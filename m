From: Shaohua Li <shli@fb.com>
Subject: [PATCH 4/4] raid5-cache: handle batch stripe for journal hotadd
Date: Tue, 5 Jan 2016 13:26:04 -0800
Message-ID: <688e327b5e6b7ebafc3d8744ef2fa515787d1cd5.1452028077.git.shli@fb.com>
References: <cover.1452028077.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1452028077.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, neilb@suse.de
List-Id: linux-raid.ids

Journal doesn't support batch stripe. If journal is hotadded, there
might be pending requests which are already batched. When journal is
enabled, such requests should be skipped.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index fcda2d2..560de57 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -453,7 +453,7 @@ int r5l_write_stripe(struct r5conf *conf, struct stripe_head *sh)
 		return -EAGAIN;
 	/* Don't support stripe batch */
 	if (sh->log_io || !test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags) ||
-	    test_bit(STRIPE_SYNCING, &sh->state)) {
+	    test_bit(STRIPE_SYNCING, &sh->state) || sh->batch_head) {
 		/* the stripe is written to log, we start writing it to raid */
 		clear_bit(STRIPE_LOG_TRAPPED, &sh->state);
 		return -EAGAIN;
-- 
2.4.6

