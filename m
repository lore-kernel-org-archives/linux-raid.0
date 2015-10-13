From: rgoldwyn@suse.de
Subject: [PATCH 09/14] md-cluster: remove unnecessary setting for slot
Date: Tue, 13 Oct 2015 09:25:30 -0500
Message-ID: <1444746335-22624-10-git-send-email-rgoldwyn@suse.de>
References: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

Since slot will be set within _sendmsg, we can remove
the redundant code in resync_info_update.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 3c18185..ba80df9 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -880,13 +880,11 @@ static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 	struct cluster_msg cmsg;
-	int slot = cinfo->slot_number - 1;
 
 	add_resync_info(mddev, cinfo->bitmap_lockres, lo, hi);
 	/* Re-acquire the lock to refresh LVB */
 	dlm_lock_sync(cinfo->bitmap_lockres, DLM_LOCK_PW);
 	cmsg.type = cpu_to_le32(RESYNCING);
-	cmsg.slot = cpu_to_le32(slot);
 	cmsg.low = cpu_to_le64(lo);
 	cmsg.high = cpu_to_le64(hi);
 
-- 
1.8.5.6

