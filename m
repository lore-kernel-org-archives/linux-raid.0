From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 4/6] md-cluster: remove capabilities
Date: Tue, 14 Apr 2015 10:44:44 -0500
Message-ID: <20150414154444.GA4098@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: GQJiang@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This adds "remove" capabilities for the clustered environment.
When a user initiates removal of a device from the array, a
REMOVE message with disk number in the array is sent to all
the nodes which kick the respective device in their own array.

This facilitates the removal of failed devices.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 30 ++++++++++++++++++++++++++++++
 drivers/md/md-cluster.h |  1 +
 drivers/md/md.c         |  7 ++++++-
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 6bdc45e..82f1b7b 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -72,6 +72,7 @@ enum msg_type {
 	METADATA_UPDATED = 0,
 	RESYNCING,
 	NEWDISK,
+	REMOVE,
 };
 
 struct cluster_msg {
@@ -401,6 +402,16 @@ static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg
 	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
 }
 
+static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
+{
+	struct md_rdev *rdev = md_find_rdev_nr_rcu(mddev, msg->raid_slot);
+
+	if (rdev)
+		md_kick_rdev_from_array(rdev);
+	else
+		pr_warn("%s: %d Could not find disk(%d) to REMOVE\n", __func__, __LINE__, msg->raid_slot);
+}
+
 static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 {
 	switch (msg->type) {
@@ -419,6 +430,15 @@ static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 		pr_info("%s: %d Received message: NEWDISK from %d\n",
 			__func__, __LINE__, msg->slot);
 		process_add_new_disk(mddev, msg);
+		break;
+	case REMOVE:
+		pr_info("%s: %d Received REMOVE from %d\n",
+			__func__, __LINE__, msg->slot);
+		process_remove_disk(mddev, msg);
+		break;
+	default:
+		pr_warn("%s:%d Received unknown message from %d\n",
+			__func__, __LINE__, msg->slot);
 	};
 }
 
@@ -854,6 +874,15 @@ static int new_disk_ack(struct mddev *mddev, bool ack)
 	return 0;
 }
 
+static int remove_disk(struct mddev *mddev, struct md_rdev *rdev)
+{
+	struct cluster_msg cmsg;
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	cmsg.type = REMOVE;
+	cmsg.raid_slot = rdev->desc_nr;
+	return __sendmsg(cinfo, &cmsg);
+}
+
 static struct md_cluster_operations cluster_ops = {
 	.join   = join,
 	.leave  = leave,
@@ -868,6 +897,7 @@ static struct md_cluster_operations cluster_ops = {
 	.add_new_disk_start = add_new_disk_start,
 	.add_new_disk_finish = add_new_disk_finish,
 	.new_disk_ack = new_disk_ack,
+	.remove_disk = remove_disk,
 };
 
 static int __init cluster_init(void)
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index 7417133..71e5143 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -22,6 +22,7 @@ struct md_cluster_operations {
 	int (*add_new_disk_start)(struct mddev *mddev, struct md_rdev *rdev);
 	int (*add_new_disk_finish)(struct mddev *mddev);
 	int (*new_disk_ack)(struct mddev *mddev, bool ack);
+	int (*remove_disk)(struct mddev *mddev, struct md_rdev *rdev);
 };
 
 #endif /* _MD_CLUSTER_H */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9d253c2..9127d11 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2481,8 +2481,10 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		else {
 			struct mddev *mddev = rdev->mddev;
 			if (mddev_is_clustered(mddev))
-				md_cluster_ops->metadata_update_start(mddev);
+				md_cluster_ops->remove_disk(mddev, rdev);
 			md_kick_rdev_from_array(rdev);
+			if (mddev_is_clustered(mddev))
+				md_cluster_ops->metadata_update_start(mddev);
 			if (mddev->pers)
 				md_update_sb(mddev, 1);
 			md_new_event(mddev);
@@ -5975,6 +5977,9 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 	if (rdev->raid_disk >= 0)
 		goto busy;
 
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->remove_disk(mddev, rdev);
+
 	md_kick_rdev_from_array(rdev);
 	md_update_sb(mddev, 1);
 	md_new_event(mddev);
-- 
2.1.4

