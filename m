From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 11/12] md-cluster: Read the disk bitmap sb and check if it needs recovery
Date: Fri, 10 Jul 2015 17:01:22 +0800
Message-ID: <1436518883-12783-8-git-send-email-gqjiang@suse.com>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518883-12783-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In gather_all_resync_info, we need to read the disk bitmap sb and
check if it needs recovery.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 29f65e2..c35a03a 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -625,6 +625,7 @@ static int gather_all_resync_info(struct mddev *mddev, int total_slots)
 	struct dlm_lock_resource *bm_lockres;
 	struct suspend_info *s;
 	char str[64];
+	sector_t lo, hi;
 
 
 	for (i = 0; i < total_slots; i++) {
@@ -659,7 +660,20 @@ static int gather_all_resync_info(struct mddev *mddev, int total_slots)
 			lockres_free(bm_lockres);
 			goto out;
 		}
-		/* TODO: Read the disk bitmap sb and check if it needs recovery */
+
+		/* Read the disk bitmap sb and check if it needs recovery */
+		ret = bitmap_copy_from_slot(mddev, i, &lo, &hi, false);
+		if (ret) {
+			pr_warn("md-cluster: Could not gather bitmaps from slot %d", i);
+			lockres_free(bm_lockres);
+			continue;
+		}
+		if ((hi > 0) && (lo < mddev->recovery_cp)) {
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			mddev->recovery_cp = lo;
+			md_check_recovery(mddev);
+		}
+
 		dlm_unlock_sync(bm_lockres);
 		lockres_free(bm_lockres);
 	}
-- 
1.7.12.4

