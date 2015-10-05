From: rgoldwyn@suse.de
Subject: [PATCH 4/5] Perform resync/recovery under a DLM lock
Date: Mon,  5 Oct 2015 10:09:53 -0500
Message-ID: <1444057794-17256-5-git-send-email-rgoldwyn@suse.de>
References: <1444057794-17256-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444057794-17256-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Resync or recovery must be performed by only one node at a time.
A DLM lock resource, resync_lockres provides the mutual exclusion
so that only one node performs the recovery/resync at a time.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 29 +++++++++++++++++++++++++++++
 drivers/md/md-cluster.h |  1 +
 drivers/md/md.c         | 17 ++++++++++++++---
 3 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 4645a93..17f24bf 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -46,6 +46,7 @@ struct resync_info {
 #define		MD_CLUSTER_WAITING_FOR_NEWDISK		1
 #define		MD_CLUSTER_SUSPEND_READ_BALANCING	2
 #define		MD_CLUSTER_BEGIN_JOIN_CLUSTER		3
+#define		MD_CLUSTER_RECOVERY_NEEDED		4
 
 
 struct md_cluster_info {
@@ -55,6 +56,7 @@ struct md_cluster_info {
 	struct completion completion;
 	struct mutex sb_mutex;
 	struct dlm_lock_resource *bitmap_lockres;
+	struct dlm_lock_resource *resync_lockres;
 	struct list_head suspend_list;
 	spinlock_t suspend_lock;
 	struct md_thread *recovery_thread;
@@ -382,6 +384,8 @@ static void process_suspend_info(struct mddev *mddev,
 
 	if (!hi) {
 		remove_suspend_info(cinfo, slot);
+		if (test_and_clear_bit(MD_CLUSTER_RECOVERY_NEEDED, &cinfo->state))
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		return;
 	}
 	s = kzalloc(sizeof(struct suspend_info), GFP_KERNEL);
@@ -755,6 +759,10 @@ static int join(struct mddev *mddev, int nodes)
 		goto err;
 	}
 
+	cinfo->resync_lockres = lockres_init(mddev, "resync", NULL, 0);
+	if (!cinfo->resync_lockres)
+		goto err;
+
 	ret = gather_all_resync_info(mddev, nodes);
 	if (ret)
 		goto err;
@@ -765,6 +773,7 @@ err:
 	lockres_free(cinfo->token_lockres);
 	lockres_free(cinfo->ack_lockres);
 	lockres_free(cinfo->no_new_dev_lockres);
+	lockres_free(cinfo->resync_lockres);
 	lockres_free(cinfo->bitmap_lockres);
 	if (cinfo->lockspace)
 		dlm_release_lockspace(cinfo->lockspace, 2);
@@ -838,6 +847,21 @@ static int metadata_update_cancel(struct mddev *mddev)
 	return dlm_unlock_sync(cinfo->token_lockres);
 }
 
+static int resync_start(struct mddev *mddev)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	int ret = 0;
+	cinfo->resync_lockres->flags |= DLM_LKF_NOQUEUE;
+	ret = dlm_lock_sync(cinfo->resync_lockres, DLM_LOCK_EX);
+	if (ret) {
+		if (!test_bit(MD_CLUSTER_RECOVERY_NEEDED, &cinfo->state))
+			pr_info("md-cluster: Postponing recovery until other nodes finish recovery\n");
+		set_bit(MD_CLUSTER_RECOVERY_NEEDED, &cinfo->state);
+	} else
+		clear_bit(MD_CLUSTER_RECOVERY_NEEDED, &cinfo->state);
+	return ret;
+}
+
 static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
@@ -854,6 +878,10 @@ static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
 	cmsg.slot = cpu_to_le32(slot);
 	cmsg.low = cpu_to_le64(lo);
 	cmsg.high = cpu_to_le64(hi);
+
+	/* Resync is finished */
+	if (hi == 0)
+		dlm_unlock_sync(cinfo->resync_lockres);
 	return sendmsg(cinfo, &cmsg);
 }
 
@@ -972,6 +1000,7 @@ static struct md_cluster_operations cluster_ops = {
 	.join   = join,
 	.leave  = leave,
 	.slot_number = slot_number,
+	.resync_start = resync_start,
 	.resync_info_update = resync_info_update,
 	.metadata_update_start = metadata_update_start,
 	.metadata_update_finish = metadata_update_finish,
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index f5bdc0c..7061020 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -16,6 +16,7 @@ struct md_cluster_operations {
 	int (*metadata_update_start)(struct mddev *mddev);
 	int (*metadata_update_finish)(struct mddev *mddev);
 	int (*metadata_update_cancel)(struct mddev *mddev);
+	int (*resync_start)(struct mddev *mddev);
 	int (*area_resyncing)(struct mddev *mddev, int direction, sector_t lo, sector_t hi);
 	int (*add_new_disk_start)(struct mddev *mddev, struct md_rdev *rdev);
 	int (*add_new_disk_finish)(struct mddev *mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9abd070..75d14e3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8071,14 +8071,25 @@ no_add:
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
+		if (!mddev_is_clustered(mddev))
+			printk(KERN_ERR "%s: could not start resync"
+			       " thread...\n",
+			       mdname(mddev));
 		/* leave the spares where they are, it shouldn't hurt */
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-- 
1.8.5.6

