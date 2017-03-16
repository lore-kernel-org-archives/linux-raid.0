From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] md/raid5:fix typo in comments of resize_stripes
Date: Thu, 16 Mar 2017 22:10:39 +0800
Message-ID: <1489673439-23594-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

raid5.c: fix typo in comment of resize_stripes()
and delete repeated words.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 drivers/md/raid5.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4fb09b3..cb55b3b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2209,7 +2209,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 	 *    pages have been transferred over, and the old kmem_cache is
 	 *    freed when all stripes are done.
 	 * 3/ reallocate conf->disks to be suitable bigger.  If this fails,
-	 *    we simple return a failre status - no need to clean anything up.
+	 *    we simple return a failure status - no need to clean anything up.
 	 * 4/ allocate new pages for the new slots in the new stripe_heads.
 	 *    If this fails, we don't bother trying the shrink the
 	 *    stripe_heads down again, we just leave them as they are.
@@ -3448,7 +3448,7 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 	    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 		/* Pre-reads at not permitted until after short delay
 		 * to gather multiple requests.  However if this
-		 * device is no Insync, the block could only be be computed
+		 * device is no Insync, the block could only be computed
 		 * and there is no need to delay that.
 		 */
 		return 0;
@@ -3467,7 +3467,7 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 
 	/* If we are forced to do a reconstruct-write, either because
 	 * the current RAID6 implementation only supports that, or
-	 * or because parity cannot be trusted and we are currently
+	 * because parity cannot be trusted and we are currently
 	 * recovering it, there is extra need to be careful.
 	 * If one of the devices that we would need to read, because
 	 * it is not being overwritten (and maybe not written at all)
-- 
2.6.6

