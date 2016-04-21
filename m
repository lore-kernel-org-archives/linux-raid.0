From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 02/13] md-cluser: make resync_finish only called after pers->sync_request
Date: Thu, 21 Apr 2016 13:58:03 +0800
Message-ID: <1461218294-4960-3-git-send-email-gqjiang@suse.com>
References: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

It is not reasonable that cluster raid to release resync
lock before the last pers->sync_request has finished.

As the metadata will be changed when node performs resync,
we need to inform other nodes to update metadata, so the
MD_CHANGE_PENDING flag is set before finish resync.

Then metadata_update_finish is move ahead to ensure that
METADATA_UPDATED msg is sent before finish resync, and
metadata_update_start need to be run after "repeat:" label
accordingly.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 113e71c..0639c01 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2286,6 +2286,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 		return;
 	}
 
+repeat:
 	if (mddev_is_clustered(mddev)) {
 		if (test_and_clear_bit(MD_CHANGE_DEVS, &mddev->flags))
 			force_change = 1;
@@ -2298,7 +2299,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 			return;
 		}
 	}
-repeat:
+
 	/* First make sure individual recovery_offsets are correct */
 	rdev_for_each(rdev, mddev) {
 		if (rdev->raid_disk >= 0 &&
@@ -2425,6 +2426,9 @@ repeat:
 	md_super_wait(mddev);
 	/* if there was a failure, MD_CHANGE_DEVS was set, and we re-write super */
 
+	if (mddev_is_clustered(mddev) && ret == 0)
+		md_cluster_ops->metadata_update_finish(mddev);
+
 	spin_lock(&mddev->lock);
 	if (mddev->in_sync != sync_req ||
 	    test_bit(MD_CHANGE_DEVS, &mddev->flags)) {
@@ -2447,9 +2451,6 @@ repeat:
 		clear_bit(BlockedBadBlocks, &rdev->flags);
 		wake_up(&rdev->blocked_wait);
 	}
-
-	if (mddev_is_clustered(mddev) && ret == 0)
-		md_cluster_ops->metadata_update_finish(mddev);
 }
 EXPORT_SYMBOL(md_update_sb);
 
@@ -7780,7 +7781,6 @@ void md_do_sync(struct md_thread *thread)
 	struct md_rdev *rdev;
 	char *desc, *action = NULL;
 	struct blk_plug plug;
-	bool cluster_resync_finished = false;
 	int ret;
 
 	/* just incase thread restarts... */
@@ -8098,11 +8098,6 @@ void md_do_sync(struct md_thread *thread)
 		mddev->curr_resync_completed = mddev->curr_resync;
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	}
-	/* tell personality and other nodes that we are finished */
-	if (mddev_is_clustered(mddev)) {
-		md_cluster_ops->resync_finish(mddev);
-		cluster_resync_finished = true;
-	}
 	mddev->pers->sync_request(mddev, max_sectors, &skipped);
 
 	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
@@ -8142,9 +8137,15 @@ void md_do_sync(struct md_thread *thread)
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
 	if (mddev_is_clustered(mddev) &&
-	    test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
-	    !cluster_resync_finished)
+	    ret == 0) {
+		/* set CHANGE_PENDING here since maybe another
+		 * update is needed, so other nodes are informed */
+		set_bit(MD_CHANGE_PENDING, &mddev->flags);
+		md_wakeup_thread(mddev->thread);
+		wait_event(mddev->sb_wait,
+			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 		md_cluster_ops->resync_finish(mddev);
+	}
 
 	spin_lock(&mddev->lock);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
-- 
2.6.6

