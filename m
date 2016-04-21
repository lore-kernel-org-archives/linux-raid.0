From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 03/13] md-cluster: wake up thread to continue recovery
Date: Thu, 21 Apr 2016 13:58:04 +0800
Message-ID: <1461218294-4960-4-git-send-email-gqjiang@suse.com>
References: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

In recovery case, we need to set MD_RECOVERY_NEEDED
and wake up thread only if recover is not finished.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 12fbfec..0d4ddf8 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -284,11 +284,14 @@ static void recover_bitmaps(struct md_thread *thread)
 			goto dlm_unlock;
 		}
 		if (hi > 0) {
-			/* TODO:Wait for current resync to get over */
-			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			if (lo < mddev->recovery_cp)
 				mddev->recovery_cp = lo;
-			md_check_recovery(mddev);
+			/* wake up thread to continue resync in case resync
+			 * is not finished */
+			if (mddev->recovery_cp != MaxSector) {
+			    set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			    md_wakeup_thread(mddev->thread);
+			}
 		}
 dlm_unlock:
 		dlm_unlock_sync(bm_lockres);
-- 
2.6.6

