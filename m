From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 2/8] md-cluster: use FORCEUNLOCK in lockres_free
Date: Thu, 28 Jul 2016 02:16:46 -0400
Message-ID: <1469686612-16126-2-git-send-email-gqjiang@suse.com>
References: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

For dlm_unlock, we need to pass flag to dlm_unlock as the
third parameter instead of set res->flags.

Also, DLM_LKF_FORCEUNLOCK is more suitable for dlm_unlock
since it works even the lock is on waiting or convert queue.

Acked-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 41573f1..0a0605f 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -194,25 +194,18 @@ out_err:
 
 static void lockres_free(struct dlm_lock_resource *res)
 {
-	int ret;
+	int ret = 0;
 
 	if (!res)
 		return;
 
-	/* cancel a lock request or a conversion request that is blocked */
-	res->flags |= DLM_LKF_CANCEL;
-retry:
-	ret = dlm_unlock(res->ls, res->lksb.sb_lkid, 0, &res->lksb, res);
-	if (unlikely(ret != 0)) {
-		pr_info("%s: failed to unlock %s return %d\n", __func__, res->name, ret);
-
-		/* if a lock conversion is cancelled, then the lock is put
-		 * back to grant queue, need to ensure it is unlocked */
-		if (ret == -DLM_ECANCEL)
-			goto retry;
-	}
-	res->flags &= ~DLM_LKF_CANCEL;
-	wait_for_completion(&res->completion);
+	/* use FORCEUNLOCK flag, so we can unlock even the lock is on the
+	 * waiting or convert queue */
+	ret = dlm_unlock(res->ls, res->lksb.sb_lkid, DLM_LKF_FORCEUNLOCK, &res->lksb, res);
+	if (unlikely(ret != 0))
+		pr_err("failed to unlock %s return %d\n", res->name, ret);
+	else
+		wait_for_completion(&res->completion);
 
 	kfree(res->name);
 	kfree(res->lksb.sb_lvbptr);
-- 
2.6.2

