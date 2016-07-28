From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 6/8] md-cluster: make resync lock also could be interruptted
Date: Thu, 28 Jul 2016 02:16:50 -0400
Message-ID: <1469686612-16126-6-git-send-email-gqjiang@suse.com>
References: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

When one node is perform resync or recovery, other nodes
can't get resync lock and could block for a while before
it holds the lock, so we can't stop array immediately for
this scenario.

To make array could be stop quickly, we check MD_CLOSING
in dlm_lock_sync_interruptible to make us can interrupt
the lock request.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index f3d584e..0984771 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -157,7 +157,8 @@ static int dlm_lock_sync_interruptible(struct dlm_lock_resource *res, int mode,
 		return ret;
 
 	wait_event(res->completion.wait,
-		   res->completion.done || kthread_should_stop());
+		   res->completion.done || kthread_should_stop()
+					|| test_bit(MD_CLOSING, &mddev->flags));
 	if (!res->completion.done) {
 		/*
 		 * the convert queue contains the lock request when request is
@@ -1026,7 +1027,7 @@ static void metadata_update_cancel(struct mddev *mddev)
 static int resync_start(struct mddev *mddev)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
-	return dlm_lock_sync(cinfo->resync_lockres, DLM_LOCK_EX);
+	return dlm_lock_sync_interruptible(cinfo->resync_lockres, DLM_LOCK_EX, mddev);
 }
 
 static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
-- 
2.6.2

