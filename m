From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 01/13] md-cluster: change resync lock from asynchronous to synchronous
Date: Thu, 21 Apr 2016 13:58:02 +0800
Message-ID: <1461218294-4960-2-git-send-email-gqjiang@suse.com>
References: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

If multiple nodes choose to attempt do resync at the same time
they need to be serialized so they don't duplicate effort. This
serialization is done by locking the 'resync' DLM lock.

Currently if a node cannot get the lock immediately it doesn't
request notification when the lock becomes available (i.e.
DLM_LKF_NOQUEUE is set), so it may not reliably find out when it
is safe to try again.

Rather than trying to arrange an async wake-up when the lock
becomes available, switch to using synchronous locking - this is
a lot easier to think about.  As it is not permitted to block in
the 'raid1d' thread, move the locking to the resync thread.  So
the rsync thread is forked immediately, but it blocks until the
resync lock is available. Once the lock is locked it checks again
if any resync action is needed.

A particular symptom of the current problem is that a node can
get stuck with "resync=pending" indefinitely.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c |  2 --
 drivers/md/md.c         | 22 ++++++++++++++--------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index dd97d42..12fbfec 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -937,7 +937,6 @@ static void metadata_update_cancel(struct mddev *mddev)
 static int resync_start(struct mddev *mddev)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
-	cinfo->resync_lockres->flags |= DLM_LKF_NOQUEUE;
 	return dlm_lock_sync(cinfo->resync_lockres, DLM_LOCK_EX);
 }
 
@@ -967,7 +966,6 @@ static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
 static int resync_finish(struct mddev *mddev)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
-	cinfo->resync_lockres->flags &= ~DLM_LKF_NOQUEUE;
 	dlm_unlock_sync(cinfo->resync_lockres);
 	return resync_info_update(mddev, 0, 0);
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c068f17..113e71c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7781,6 +7781,7 @@ void md_do_sync(struct md_thread *thread)
 	char *desc, *action = NULL;
 	struct blk_plug plug;
 	bool cluster_resync_finished = false;
+	int ret;
 
 	/* just incase thread restarts... */
 	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
@@ -7790,6 +7791,19 @@ void md_do_sync(struct md_thread *thread)
 		return;
 	}
 
+	if (mddev_is_clustered(mddev)) {
+		ret = md_cluster_ops->resync_start(mddev);
+		if (ret)
+			goto skip;
+
+		if (!(test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
+			test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ||
+			test_bit(MD_RECOVERY_RECOVER, &mddev->recovery))
+		     && ((unsigned long long)mddev->curr_resync_completed
+			 < (unsigned long long)mddev->resync_max_sectors))
+			goto skip;
+	}
+
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
 			desc = "data-check";
@@ -8221,14 +8235,6 @@ static void md_start_sync(struct work_struct *ws)
 	struct mddev *mddev = container_of(ws, struct mddev, del_work);
 	int ret = 0;
 
-	if (mddev_is_clustered(mddev)) {
-		ret = md_cluster_ops->resync_start(mddev);
-		if (ret) {
-			mddev->sync_thread = NULL;
-			goto out;
-		}
-	}
-
 	mddev->sync_thread = md_register_thread(md_do_sync,
 						mddev,
 						"resync");
-- 
2.6.6

