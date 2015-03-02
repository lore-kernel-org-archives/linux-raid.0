From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH] Fix stray --cluster-confrim crash
Date: Mon, 2 Mar 2015 10:55:49 -0600
Message-ID: <20150302165549.GA27519@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

This fix is againt the md/for-next.

A --cluster-confirm without an --add (by another node) can
crash the kernel.

Fix it by guarding it using a state.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
--- 
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 03e521a..96679b2 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -42,6 +42,10 @@ struct resync_info {
 	__le64 hi;
 };
 
+/* md_cluster_info flags */
+#define		MD_CLUSTER_WAITING_FOR_NEWDISK		1
+
+
 struct md_cluster_info {
 	/* dlm lock space and resources for clustered raid. */
 	dlm_lockspace_t *lockspace;
@@ -61,6 +65,7 @@ struct md_cluster_info {
 	struct dlm_lock_resource *no_new_dev_lockres;
 	struct md_thread *recv_thread;
 	struct completion newdisk_completion;
+	unsigned long state;
 };
 
 enum msg_type {
@@ -380,9 +385,11 @@ static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
 	snprintf(raid_slot, 16, "RAID_DISK=%d", cmsg->raid_slot);
 	pr_info("%s:%d Sending kobject change with %s and %s\n", __func__, __LINE__, disk_uuid, raid_slot);
 	init_completion(&cinfo->newdisk_completion);
+	set_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
 	kobject_uevent_env(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE, envp);
 	wait_for_completion_timeout(&cinfo->newdisk_completion,
 			NEW_DEV_TIMEOUT);
+	clear_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
 }
 
 
@@ -832,13 +839,19 @@ static int add_new_disk_finish(struct mddev *mddev)
 	return ret;
 }
 
-static void new_disk_ack(struct mddev *mddev, bool ack)
+static int new_disk_ack(struct mddev *mddev, bool ack)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 
+	if (!test_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state)) {
+		pr_warn("md-cluster(%s): Spurious cluster confirmation\n", mdname(mddev));
+		return -EINVAL;
+	}
+
 	if (ack)
 		dlm_unlock_sync(cinfo->no_new_dev_lockres);
 	complete(&cinfo->newdisk_completion);
+	return 0;
 }
 
 static struct md_cluster_operations cluster_ops = {
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index 60d7e58..7417133 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -21,7 +21,7 @@ struct md_cluster_operations {
 	int (*area_resyncing)(struct mddev *mddev, sector_t lo, sector_t hi);
 	int (*add_new_disk_start)(struct mddev *mddev, struct md_rdev *rdev);
 	int (*add_new_disk_finish)(struct mddev *mddev);
-	void (*new_disk_ack)(struct mddev *mddev, bool ack);
+	int (*new_disk_ack)(struct mddev *mddev, bool ack);
 };
 
 #endif /* _MD_CLUSTER_H */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 23784988..461024d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5757,7 +5755,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 
 	if (mddev_is_clustered(mddev) &&
 		!(info->state & ((1 << MD_DISK_CLUSTER_ADD) | (1 << MD_DISK_CANDIDATE)))) {
-		pr_err("%s: Cannot add to clustered mddev. Try --cluster-add\n",
+		pr_err("%s: Cannot add to clustered mddev.\n",
 			       mdname(mddev));
 		return -EINVAL;
 	}
@@ -5855,7 +5853,11 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 			if (info->state & (1 << MD_DISK_CANDIDATE)) {
 				/* Through --cluster-confirm */
 				set_bit(Candidate, &rdev->flags);
-				md_cluster_ops->new_disk_ack(mddev, true);
+				err = md_cluster_ops->new_disk_ack(mddev, true);
+				if (err) {
+					export_rdev(rdev);
+					return err;
+				}
 			} else if (info->state & (1 << MD_DISK_CLUSTER_ADD)) {
 				/* --add initiated by this node */
 				err = md_cluster_ops->add_new_disk_start(mddev, rdev);
