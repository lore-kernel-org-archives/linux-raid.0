From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2 03/10] md-cluster: remove some unnecessary dlm_unlock_sync
Date: Fri, 12 Aug 2016 13:42:36 +0800
Message-ID: <1470980563-26062-4-git-send-email-gqjiang@suse.com>
References: <1470980563-26062-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1470980563-26062-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Since DLM_LKF_FORCEUNLOCK is used in lockres_free,
we don't need to call dlm_unlock_sync before free
lock resource.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 0a0605f..ea2699e 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -281,7 +281,7 @@ static void recover_bitmaps(struct md_thread *thread)
 		ret = bitmap_copy_from_slot(mddev, slot, &lo, &hi, true);
 		if (ret) {
 			pr_err("md-cluster: Could not copy data from bitmap %d\n", slot);
-			goto dlm_unlock;
+			goto clear_bit;
 		}
 		if (hi > 0) {
 			if (lo < mddev->recovery_cp)
@@ -293,8 +293,6 @@ static void recover_bitmaps(struct md_thread *thread)
 			    md_wakeup_thread(mddev->thread);
 			}
 		}
-dlm_unlock:
-		dlm_unlock_sync(bm_lockres);
 clear_bit:
 		lockres_free(bm_lockres);
 		clear_bit(slot, &cinfo->recovery_map);
@@ -763,7 +761,6 @@ static int gather_all_resync_info(struct mddev *mddev, int total_slots)
 			md_check_recovery(mddev);
 		}
 
-		dlm_unlock_sync(bm_lockres);
 		lockres_free(bm_lockres);
 	}
 out:
@@ -1173,7 +1170,6 @@ static void unlock_all_bitmaps(struct mddev *mddev)
 	if (cinfo->other_bitmap_lockres) {
 		for (i = 0; i < mddev->bitmap_info.nodes - 1; i++) {
 			if (cinfo->other_bitmap_lockres[i]) {
-				dlm_unlock_sync(cinfo->other_bitmap_lockres[i]);
 				lockres_free(cinfo->other_bitmap_lockres[i]);
 			}
 		}
-- 
2.6.2

