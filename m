From: rgoldwyn@suse.de
Subject: [PATCH 05/14] md-cluster: Perform resync/recovery under a DLM lock
Date: Tue, 13 Oct 2015 09:25:26 -0500
Message-ID: <1444746335-22624-6-git-send-email-rgoldwyn@suse.de>
References: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Resync or recovery must be performed by only one node at a time.
A DLM lock resource, resync_lockres provides the mutual exclusion
so that only one node performs the recovery/resync at a time.

If a node is unable to get the resync_lockres, because recovery is
being performed by another node, it set MD_RECOVER_NEEDED so as
to schedule recovery in the future.

Remove the debug message in resync_info_update()
used during development.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 29 ++++++++++++++++++++++++++---
 drivers/md/md-cluster.h |  2 ++
 drivers/md/md.c         | 29 +++++++++++++++++++++++++----
 drivers/md/raid1.c      |  2 --
 4 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 2eb3a50..e1ce9c9 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -55,6 +55,7 @@ struct md_cluster_info {
 	struct completion completion;
 	struct mutex sb_mutex;
 	struct dlm_lock_resource *bitmap_lockres;
+	struct dlm_lock_resource *resync_lockres;
 	struct list_head suspend_list;
 	spinlock_t suspend_lock;
 	struct md_thread *recovery_thread;
@@ -384,6 +385,8 @@ static void process_suspend_info(struct mddev *mddev,
 
 	if (!hi) {
 		remove_suspend_info(mddev, slot);
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
 		return;
 	}
 	s = kzalloc(sizeof(struct suspend_info), GFP_KERNEL);
@@ -758,6 +761,10 @@ static int join(struct mddev *mddev, int nodes)
 		goto err;
 	}
 
+	cinfo->resync_lockres = lockres_init(mddev, "resync", NULL, 0);
+	if (!cinfo->resync_lockres)
+		goto err;
+
 	ret = gather_all_resync_info(mddev, nodes);
 	if (ret)
 		goto err;
@@ -768,6 +775,7 @@ err:
 	lockres_free(cinfo->token_lockres);
 	lockres_free(cinfo->ack_lockres);
 	lockres_free(cinfo->no_new_dev_lockres);
+	lockres_free(cinfo->resync_lockres);
 	lockres_free(cinfo->bitmap_lockres);
 	if (cinfo->lockspace)
 		dlm_release_lockspace(cinfo->lockspace, 2);
@@ -861,6 +869,13 @@ static int metadata_update_cancel(struct mddev *mddev)
 	return dlm_unlock_sync(cinfo->token_lockres);
 }
 
+static int resync_start(struct mddev *mddev)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	cinfo->resync_lockres->flags |= DLM_LKF_NOQUEUE;
+	return dlm_lock_sync(cinfo->resync_lockres, DLM_LOCK_EX);
+}
+
 static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
@@ -870,16 +885,22 @@ static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
 	add_resync_info(mddev, cinfo->bitmap_lockres, lo, hi);
 	/* Re-acquire the lock to refresh LVB */
 	dlm_lock_sync(cinfo->bitmap_lockres, DLM_LOCK_PW);
-	pr_info("%s:%d lo: %llu hi: %llu\n", __func__, __LINE__,
-			(unsigned long long)lo,
-			(unsigned long long)hi);
 	cmsg.type = cpu_to_le32(RESYNCING);
 	cmsg.slot = cpu_to_le32(slot);
 	cmsg.low = cpu_to_le64(lo);
 	cmsg.high = cpu_to_le64(hi);
+
 	return sendmsg(cinfo, &cmsg);
 }
 
+static int resync_finish(struct mddev *mddev)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	cinfo->resync_lockres->flags &= ~DLM_LKF_NOQUEUE;
+	dlm_unlock_sync(cinfo->resync_lockres);
+	return resync_info_update(mddev, 0, 0);
+}
+
 static int area_resyncing(struct mddev *mddev, int direction,
 		sector_t lo, sector_t hi)
 {
@@ -995,6 +1016,8 @@ static struct md_cluster_operations cluster_ops = {
 	.join   = join,
 	.leave  = leave,
 	.slot_number = slot_number,
+	.resync_start = resync_start,
+	.resync_finish = resync_finish,
 	.resync_info_update = resync_info_update,
 	.metadata_update_start = metadata_update_start,
 	.metadata_update_finish = metadata_update_finish,
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index f5bdc0c..c941726 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -16,6 +16,8 @@ struct md_cluster_operations {
 	int (*metadata_update_start)(struct mddev *mddev);
 	int (*metadata_update_finish)(struct mddev *mddev);
 	int (*metadata_update_cancel)(struct mddev *mddev);
+	int (*resync_start)(struct mddev *mddev);
+	int (*resync_finish)(struct mddev *mddev);
 	int (*area_resyncing)(struct mddev *mddev, int direction, sector_t lo, sector_t hi);
 	int (*add_new_disk_start)(struct mddev *mddev, struct md_rdev *rdev);
 	int (*add_new_disk_finish)(struct mddev *mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5f09678..61e897de 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7657,6 +7657,7 @@ void md_do_sync(struct md_thread *thread)
 	struct md_rdev *rdev;
 	char *desc, *action = NULL;
 	struct blk_plug plug;
+	bool cluster_resync_finished = false;
 
 	/* just incase thread restarts... */
 	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
@@ -7959,7 +7960,11 @@ void md_do_sync(struct md_thread *thread)
 		mddev->curr_resync_completed = mddev->curr_resync;
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	}
-	/* tell personality that we are finished */
+	/* tell personality and other nodes that we are finished */
+	if (mddev_is_clustered(mddev)) {
+		md_cluster_ops->resync_finish(mddev);
+		cluster_resync_finished = true;
+	}
 	mddev->pers->sync_request(mddev, max_sectors, &skipped);
 
 	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
@@ -7997,6 +8002,11 @@ void md_do_sync(struct md_thread *thread)
  skip:
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
+	if (mddev_is_clustered(mddev) &&
+	    test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
+	    !cluster_resync_finished)
+		md_cluster_ops->resync_finish(mddev);
+
 	spin_lock(&mddev->lock);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 		/* We completed so min/max setting can be forgotten if used. */
@@ -8078,14 +8088,25 @@ no_add:
 static void md_start_sync(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, del_work);
+	int ret = 0;
+
+	if (mddev_is_clustered(mddev)) {
+		ret = md_cluster_ops->resync_start(mddev);
+		if (ret) {
+			mddev->sync_thread = NULL;
+			goto out;
+		}
+	}
 
 	mddev->sync_thread = md_register_thread(md_do_sync,
 						mddev,
 						"resync");
+out:
 	if (!mddev->sync_thread) {
-		printk(KERN_ERR "%s: could not start resync"
-		       " thread...\n",
-		       mdname(mddev));
+		if (!(mddev_is_clustered(mddev) && ret == -EAGAIN))
+			printk(KERN_ERR "%s: could not start resync"
+			       " thread...\n",
+			       mdname(mddev));
 		/* leave the spares where they are, it shouldn't hurt */
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b54fefc..a2d813c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2503,8 +2503,6 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 		if (mddev_is_clustered(mddev)) {
 			conf->cluster_sync_low = 0;
 			conf->cluster_sync_high = 0;
-			/* Send zeros to mark end of resync */
-			md_cluster_ops->resync_info_update(mddev, 0, 0);
 		}
 		return 0;
 	}
-- 
1.8.5.6

