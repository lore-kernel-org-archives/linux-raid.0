From: rgoldwyn@suse.de
Subject: [PATCH 14/14] md: check the return value for metadata_update_start
Date: Tue, 13 Oct 2015 09:25:35 -0500
Message-ID: <1444746335-22624-15-git-send-email-rgoldwyn@suse.de>
References: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

We shouldn't run related funs of md_cluster_ops in case
metadata_update_start returned failure.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d39a72a..a71b36f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2245,6 +2245,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	int sync_req;
 	int nospares = 0;
 	int any_badblocks_changed = 0;
+	int ret = -1;
 
 	if (mddev->ro) {
 		if (force_change)
@@ -2255,10 +2256,11 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	if (mddev_is_clustered(mddev)) {
 		if (test_and_clear_bit(MD_CHANGE_DEVS, &mddev->flags))
 			force_change = 1;
-		md_cluster_ops->metadata_update_start(mddev);
+		ret = md_cluster_ops->metadata_update_start(mddev);
 		/* Has someone else has updated the sb */
 		if (!does_sb_need_changing(mddev)) {
-			md_cluster_ops->metadata_update_cancel(mddev);
+			if (ret == 0)
+				md_cluster_ops->metadata_update_cancel(mddev);
 			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
 			return;
 		}
@@ -2412,7 +2414,7 @@ repeat:
 		wake_up(&rdev->blocked_wait);
 	}
 
-	if (mddev_is_clustered(mddev))
+	if (mddev_is_clustered(mddev) && ret == 0)
 		md_cluster_ops->metadata_update_finish(mddev);
 }
 EXPORT_SYMBOL(md_update_sb);
@@ -6031,13 +6033,14 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 {
 	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
+	int ret = -1;
 
 	rdev = find_rdev(mddev, dev);
 	if (!rdev)
 		return -ENXIO;
 
 	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_start(mddev);
+		ret = md_cluster_ops->metadata_update_start(mddev);
 
 	if (rdev->raid_disk < 0)
 		goto kick_rdev;
@@ -6049,7 +6052,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		goto busy;
 
 kick_rdev:
-	if (mddev_is_clustered(mddev))
+	if (mddev_is_clustered(mddev) && ret == 0)
 		md_cluster_ops->remove_disk(mddev, rdev);
 
 	md_kick_rdev_from_array(rdev);
@@ -6058,7 +6061,7 @@ kick_rdev:
 
 	return 0;
 busy:
-	if (mddev_is_clustered(mddev))
+	if (mddev_is_clustered(mddev) && ret == 0)
 		md_cluster_ops->metadata_update_cancel(mddev);
 
 	printk(KERN_WARNING "md: cannot remove active disk %s from %s ...\n",
-- 
1.8.5.6

