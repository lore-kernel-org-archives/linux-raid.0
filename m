From: rgoldwyn@suse.de
Subject: [PATCH 06/14] md-cluster: Fix adding of new disk with new reload code
Date: Tue, 13 Oct 2015 09:25:27 -0500
Message-ID: <1444746335-22624-7-git-send-email-rgoldwyn@suse.de>
References: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Adding the disk worked incorrectly with the new reload code. Fix it:

 - No operation should be performed on rdev marked as Candidate
 - After a metadata update operation, kick disk if role is 0xfffe
   else clear Candidate bit and continue with the regular change check.
 - Saving the mode of the lock resource to check if token lock is already
   locked, because it can be called twice while adding a disk. However,
   unlock_comm() must be called only once.
 - add_new_disk() is called by the node initiating the --add operation.
   If it needs to be canceled, call add_new_disk_cancel(). The operation
   is completed by md_update_sb() which will write and unlock the
   communication.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 35 +++++++++++++++++++++++----------
 drivers/md/md-cluster.h |  6 +++---
 drivers/md/md.c         | 52 ++++++++++++++++++++++++++++---------------------
 3 files changed, 58 insertions(+), 35 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index e1ce9c9..28494e9 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -28,6 +28,7 @@ struct dlm_lock_resource {
 	struct completion completion; /* completion for synchronized locking */
 	void (*bast)(void *arg, int mode); /* blocking AST function pointer*/
 	struct mddev *mddev; /* pointing back to mddev. */
+	int mode;
 };
 
 struct suspend_info {
@@ -107,6 +108,8 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
 	if (ret)
 		return ret;
 	wait_for_completion(&res->completion);
+	if (res->lksb.sb_status == 0)
+		res->mode = mode;
 	return res->lksb.sb_status;
 }
 
@@ -128,6 +131,7 @@ static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 	init_completion(&res->completion);
 	res->ls = cinfo->lockspace;
 	res->mddev = mddev;
+	res->mode = DLM_LOCK_IV;
 	namelen = strlen(name);
 	res->name = kzalloc(namelen + 1, GFP_KERNEL);
 	if (!res->name) {
@@ -536,11 +540,17 @@ static void recv_daemon(struct md_thread *thread)
 /* lock_comm()
  * Takes the lock on the TOKEN lock resource so no other
  * node can communicate while the operation is underway.
+ * If called again, and the TOKEN lock is alread in EX mode
+ * return success. However, care must be taken that unlock_comm()
+ * is called only once.
  */
 static int lock_comm(struct md_cluster_info *cinfo)
 {
 	int error;
 
+	if (cinfo->token_lockres->mode == DLM_LOCK_EX)
+		return 0;
+
 	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
 	if (error)
 		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
@@ -550,6 +560,7 @@ static int lock_comm(struct md_cluster_info *cinfo)
 
 static void unlock_comm(struct md_cluster_info *cinfo)
 {
+	WARN_ON(cinfo->token_lockres->mode != DLM_LOCK_EX);
 	dlm_unlock_sync(cinfo->token_lockres);
 }
 
@@ -862,11 +873,10 @@ static int metadata_update_finish(struct mddev *mddev)
 	return ret;
 }
 
-static int metadata_update_cancel(struct mddev *mddev)
+static void metadata_update_cancel(struct mddev *mddev)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
-
-	return dlm_unlock_sync(cinfo->token_lockres);
+	unlock_comm(cinfo);
 }
 
 static int resync_start(struct mddev *mddev)
@@ -925,7 +935,11 @@ out:
 	return ret;
 }
 
-static int add_new_disk_start(struct mddev *mddev, struct md_rdev *rdev)
+/* add_new_disk() - initiates a disk add
+ * However, if this fails before writing md_update_sb(),
+ * add_new_disk_cancel() must be called to release token lock
+ */
+static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 	struct cluster_msg cmsg;
@@ -947,16 +961,17 @@ static int add_new_disk_start(struct mddev *mddev, struct md_rdev *rdev)
 	/* Some node does not "see" the device */
 	if (ret == -EAGAIN)
 		ret = -ENOENT;
+	if (ret)
+		unlock_comm(cinfo);
 	else
 		dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
 	return ret;
 }
 
-static int add_new_disk_finish(struct mddev *mddev)
+static void add_new_disk_cancel(struct mddev *mddev)
 {
-	/* Write sb and inform others */
-	md_update_sb(mddev, 1);
-	return metadata_update_finish(mddev);
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	unlock_comm(cinfo);
 }
 
 static int new_disk_ack(struct mddev *mddev, bool ack)
@@ -1023,8 +1038,8 @@ static struct md_cluster_operations cluster_ops = {
 	.metadata_update_finish = metadata_update_finish,
 	.metadata_update_cancel = metadata_update_cancel,
 	.area_resyncing = area_resyncing,
-	.add_new_disk_start = add_new_disk_start,
-	.add_new_disk_finish = add_new_disk_finish,
+	.add_new_disk = add_new_disk,
+	.add_new_disk_cancel = add_new_disk_cancel,
 	.new_disk_ack = new_disk_ack,
 	.remove_disk = remove_disk,
 	.gather_bitmaps = gather_bitmaps,
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index c941726..e75ea26 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -15,12 +15,12 @@ struct md_cluster_operations {
 	int (*resync_info_update)(struct mddev *mddev, sector_t lo, sector_t hi);
 	int (*metadata_update_start)(struct mddev *mddev);
 	int (*metadata_update_finish)(struct mddev *mddev);
-	int (*metadata_update_cancel)(struct mddev *mddev);
+	void (*metadata_update_cancel)(struct mddev *mddev);
 	int (*resync_start)(struct mddev *mddev);
 	int (*resync_finish)(struct mddev *mddev);
 	int (*area_resyncing)(struct mddev *mddev, int direction, sector_t lo, sector_t hi);
-	int (*add_new_disk_start)(struct mddev *mddev, struct md_rdev *rdev);
-	int (*add_new_disk_finish)(struct mddev *mddev);
+	int (*add_new_disk)(struct mddev *mddev, struct md_rdev *rdev);
+	void (*add_new_disk_cancel)(struct mddev *mddev);
 	int (*new_disk_ack)(struct mddev *mddev, bool ack);
 	int (*remove_disk)(struct mddev *mddev, struct md_rdev *rdev);
 	int (*gather_bitmaps)(struct md_rdev *rdev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 61e897de..8a6f67f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3246,14 +3246,6 @@ static void analyze_sbs(struct mddev *mddev)
 				md_kick_rdev_from_array(rdev);
 				continue;
 			}
-			/* No device should have a Candidate flag
-			 * when reading devices
-			 */
-			if (test_bit(Candidate, &rdev->flags)) {
-				pr_info("md: kicking Cluster Candidate %s from array!\n",
-					bdevname(rdev->bdev, b));
-				md_kick_rdev_from_array(rdev);
-			}
 		}
 		if (mddev->level == LEVEL_MULTIPATH) {
 			rdev->desc_nr = i++;
@@ -5950,19 +5942,12 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 		 * check whether the device shows up in other nodes
 		 */
 		if (mddev_is_clustered(mddev)) {
-			if (info->state & (1 << MD_DISK_CANDIDATE)) {
-				/* Through --cluster-confirm */
+			if (info->state & (1 << MD_DISK_CANDIDATE))
 				set_bit(Candidate, &rdev->flags);
-				err = md_cluster_ops->new_disk_ack(mddev, true);
-				if (err) {
-					export_rdev(rdev);
-					return err;
-				}
-			} else if (info->state & (1 << MD_DISK_CLUSTER_ADD)) {
+			else if (info->state & (1 << MD_DISK_CLUSTER_ADD)) {
 				/* --add initiated by this node */
-				err = md_cluster_ops->add_new_disk_start(mddev, rdev);
+				err = md_cluster_ops->add_new_disk(mddev, rdev);
 				if (err) {
-					md_cluster_ops->add_new_disk_finish(mddev);
 					export_rdev(rdev);
 					return err;
 				}
@@ -5971,13 +5956,23 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 
 		rdev->raid_disk = -1;
 		err = bind_rdev_to_array(rdev, mddev);
+
 		if (err)
 			export_rdev(rdev);
-		else
+
+		if (mddev_is_clustered(mddev)) {
+			if (info->state & (1 << MD_DISK_CANDIDATE))
+				md_cluster_ops->new_disk_ack(mddev, (err == 0));
+			else {
+				if (err)
+					md_cluster_ops->add_new_disk_cancel(mddev);
+				else
+					err = add_bound_rdev(rdev);
+			}
+
+		} else if (!err)
 			err = add_bound_rdev(rdev);
-		if (mddev_is_clustered(mddev) &&
-				(info->state & (1 << MD_DISK_CLUSTER_ADD)))
-			md_cluster_ops->add_new_disk_finish(mddev);
+
 		return err;
 	}
 
@@ -8055,6 +8050,8 @@ static int remove_and_add_spares(struct mddev *mddev,
 	rdev_for_each(rdev, mddev) {
 		if (this && this != rdev)
 			continue;
+		if (test_bit(Candidate, &rdev->flags))
+			continue;
 		if (rdev->raid_disk >= 0 &&
 		    !test_bit(In_sync, &rdev->flags) &&
 		    !test_bit(Faulty, &rdev->flags))
@@ -8972,6 +8969,17 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 
 		/* Check if the roles changed */
 		role = le16_to_cpu(sb->dev_roles[rdev2->desc_nr]);
+
+		if (test_bit(Candidate, &rdev2->flags)) {
+			if (role == 0xfffe) {
+				pr_info("md: Removing Candidate device %s because add failed\n", bdevname(rdev2->bdev,b));
+				md_kick_rdev_from_array(rdev2);
+				continue;
+			}
+			else
+				clear_bit(Candidate, &rdev2->flags);
+		}
+
 		if (role != rdev2->raid_disk) {
 			/* got activated */
 			if (rdev2->raid_disk == -1 && role != 0xffff) {
-- 
1.8.5.6

