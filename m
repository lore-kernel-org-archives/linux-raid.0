From: rgoldwyn@suse.de
Subject: [PATCH 2/6] md-cluster: Avoid the resync ping-pong
Date: Thu,  5 Nov 2015 21:50:15 -0600
Message-ID: <1446781819-25571-2-git-send-email-rgoldwyn@suse.de>
References: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

If a RESYNCING message with (0,0) has been sent before, do not send it
again. This avoids a resync ping pong between the nodes. We read
the bitmap lockresource's LVB to figure out the previous value
of the RESYNCING message.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index a93734e..3daa464 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -898,8 +898,16 @@ static int resync_start(struct mddev *mddev)
 static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
+	struct resync_info ri;
 	struct cluster_msg cmsg = {0};
 
+	/* do not send zero again, if we have sent before */
+	if (hi == 0) {
+		memcpy(&ri, cinfo->bitmap_lockres->lksb.sb_lvbptr, sizeof(struct resync_info));
+		if (le64_to_cpu(ri.hi) == 0)
+			return 0;
+	}
+
 	add_resync_info(mddev, cinfo->bitmap_lockres, lo, hi);
 	/* Re-acquire the lock to refresh LVB */
 	dlm_lock_sync(cinfo->bitmap_lockres, DLM_LOCK_PW);
-- 
1.8.5.6

