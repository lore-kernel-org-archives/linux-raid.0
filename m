From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 15/24] Perform resync for cluster node failure
Date: Thu, 18 Dec 2014 10:17:51 -0600
Message-ID: <20141218161751.GA29638@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If bitmap_copy_slot returns hi>0, we need to perform resync.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 4f1ea5f..617ffee 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -226,9 +226,19 @@ void recover_bitmaps(struct md_thread *thread)
 			goto clear_bit;
 		}
 		ret = bitmap_copy_from_slot(mddev, slot, &lo, &hi);
-		if (ret)
+		if (ret) {
 			pr_err("md-cluster: Could not copy data "
 					"from bitmap %d\n", slot);
+			goto dlm_unlock;
+		}
+		if (hi > 0) {
+			/* TODO:Wait for current resync to get over */
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			if (lo < mddev->recovery_cp)
+				mddev->recovery_cp = lo;
+			md_check_recovery(mddev);
+		}
+dlm_unlock:
 		dlm_unlock_sync(bm_lockres);
 clear_bit:
 		clear_bit(slot, &cinfo->recovery_map);
-- 
2.1.2

