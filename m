From: rgoldwyn@suse.de
Subject: [PATCH 13/14] md-cluster: only call kick_rdev_from_array after remove disk successfully
Date: Tue, 13 Oct 2015 09:25:34 -0500
Message-ID: <1444746335-22624-14-git-send-email-rgoldwyn@suse.de>
References: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

For cluster raid, we should not kick it from array if the disk can't be
remove from array successfully.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8a6f67f..d39a72a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2548,13 +2548,16 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			err = -EBUSY;
 		else {
 			struct mddev *mddev = rdev->mddev;
-			if (mddev_is_clustered(mddev))
-				md_cluster_ops->remove_disk(mddev, rdev);
-			md_kick_rdev_from_array(rdev);
-			if (mddev->pers)
-				md_update_sb(mddev, 1);
-			md_new_event(mddev);
 			err = 0;
+			if (mddev_is_clustered(mddev))
+				err = md_cluster_ops->remove_disk(mddev, rdev);
+
+			if (err == 0) {
+				md_kick_rdev_from_array(rdev);
+				if (mddev->pers)
+					md_update_sb(mddev, 1);
+				md_new_event(mddev);
+			}
 		}
 	} else if (cmd_match(buf, "writemostly")) {
 		set_bit(WriteMostly, &rdev->flags);
-- 
1.8.5.6

