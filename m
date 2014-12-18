From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 08/24] Add node recovery callbacks
Date: Thu, 18 Dec 2014 10:16:48 -0600
Message-ID: <20141218161647.GA29605@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

DLM offers callbacks when a node fails and the lock remastery
is performed:

1. recover_prep: called when DLM discovers a node is down
2. recover_slot: called when DLM identifies the node and recovery
		can start
3. recover_done: called when all nodes have completed recover_slot

recover_slot() and recover_done() are also called when the node joins
initially in order to inform the node with its slot number. These slot
numbers start from one, so we deduct one to make it start with zero
which the cluster-md code uses.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/bitmap.c     |  1 +
 drivers/md/bitmap.h     |  4 ++--
 drivers/md/md-cluster.c | 60 ++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/md-cluster.h |  4 +++-
 drivers/md/md.c         |  2 +-
 drivers/md/md.h         |  3 ++-
 6 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 33374de..f4df37c 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -624,6 +624,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
 		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
+	strlcpy(bitmap->mddev->bitmap_info.cluster_name, sb->cluster_name, 64);
 	err = 0;
 out:
 	kunmap_atomic(sb);
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 6872945..49163b6 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -131,8 +131,8 @@ typedef struct bitmap_super_s {
 	__le32 nodes;        /* 64 the maximum number of nodes in cluster. */
 	__le32 sectors_reserved; /* 68 number of 512-byte sectors that are
 				  * reserved for the bitmap. */
-
-	__u8  pad[256 - 72]; /* set to zero */
+	__u8 cluster_name[64]; /* 72 cluster name to which this md belongs */
+	__u8  pad[256 - 136]; /* set to zero */
 } bitmap_super_t;
 
 /* notes:
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index fa28aed..98e45e1 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -33,6 +33,8 @@ struct dlm_lock_resource {
 struct md_cluster_info {
 	/* dlm lock space and resources for clustered raid. */
 	dlm_lockspace_t *lockspace;
+	int slot_number;
+	struct completion completion;
 	struct dlm_lock_resource *sb_lock;
 	struct mutex sb_mutex;
 };
@@ -140,10 +142,41 @@ static char *pretty_uuid(char *dest, char *src)
 	return dest;
 }
 
+static void recover_prep(void *arg)
+{
+}
+
+static void recover_slot(void *arg, struct dlm_slot *slot)
+{
+	struct mddev *mddev = arg;
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	pr_info("md-cluster: %s Node %d/%d down. My slot: %d. "
+			"Initiating recovery.\n",
+			mddev->bitmap_info.cluster_name,
+			slot->nodeid, slot->slot,
+			cinfo->slot_number);
+}
+
+static void recover_done(void *arg, struct dlm_slot *slots,
+		int num_slots, int our_slot,
+		uint32_t generation)
+{
+	struct mddev *mddev = arg;
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	cinfo->slot_number = our_slot;
+	complete(&cinfo->completion);
+}
+
+static const struct dlm_lockspace_ops md_ls_ops = {
+	.recover_prep = recover_prep,
+	.recover_slot = recover_slot,
+	.recover_done = recover_done,
+};
+
 static int join(struct mddev *mddev, int nodes)
 {
 	struct md_cluster_info *cinfo;
-	int ret;
+	int ret, ops_rv;
 	char str[64];
 
 	if (!try_module_get(THIS_MODULE))
@@ -153,24 +186,30 @@ static int join(struct mddev *mddev, int nodes)
 	if (!cinfo)
 		return -ENOMEM;
 
+	init_completion(&cinfo->completion);
+
+	mutex_init(&cinfo->sb_mutex);
+	mddev->cluster_info = cinfo;
+
 	memset(str, 0, 64);
 	pretty_uuid(str, mddev->uuid);
-	ret = dlm_new_lockspace(str, NULL, DLM_LSFL_FS, LVB_SIZE,
-				NULL, NULL, NULL, &cinfo->lockspace);
+	ret = dlm_new_lockspace(str, mddev->bitmap_info.cluster_name,
+				DLM_LSFL_FS, LVB_SIZE,
+				&md_ls_ops, mddev, &ops_rv, &cinfo->lockspace);
 	if (ret)
 		goto err;
+	wait_for_completion(&cinfo->completion);
 	cinfo->sb_lock = lockres_init(mddev, "cmd-super",
 					NULL, 0);
 	if (!cinfo->sb_lock) {
 		ret = -ENOMEM;
 		goto err;
 	}
-	mutex_init(&cinfo->sb_mutex);
-	mddev->cluster_info = cinfo;
 	return 0;
 err:
 	if (cinfo->lockspace)
 		dlm_release_lockspace(cinfo->lockspace, 2);
+	mddev->cluster_info = NULL;
 	kfree(cinfo);
 	module_put(THIS_MODULE);
 	return ret;
@@ -186,9 +225,20 @@ static int leave(struct mddev *mddev)
 	return 0;
 }
 
+/* slot_number(): Returns the MD slot number to use
+ * DLM starts the slot numbers from 1, wheras cluster-md
+ * wants the number to be from zero, so we deduct one
+ */
+static int slot_number(struct mddev *mddev)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	return cinfo->slot_number - 1;
+}
+
 static struct md_cluster_operations cluster_ops = {
 	.join   = join,
 	.leave  = leave,
+	.slot_number = slot_number
 };
 
 static int __init cluster_init(void)
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index aa9f07b..d9a1d88 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -8,8 +8,10 @@
 struct mddev;
 
 struct md_cluster_operations {
-	int (*join)(struct mddev *mddev);
+	int (*join)(struct mddev *mddev, int nodes);
 	int (*leave)(struct mddev *mddev);
+	int (*slot_number)(struct mddev *mddev);
+
 };
 
 #endif /* _MD_CLUSTER_H */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5f45951..db28f21 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7273,7 +7273,7 @@ int md_setup_cluster(struct mddev *mddev, int nodes)
 	}
 	spin_unlock(&pers_lock);
 
-	return md_cluster_ops->join(mddev);
+	return md_cluster_ops->join(mddev, nodes);
 }
 
 void md_cluster_stop(struct mddev *mddev)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8017e18..6c6e992 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -422,7 +422,8 @@ struct mddev {
 		unsigned long		daemon_sleep; /* how many jiffies between updates? */
 		unsigned long		max_write_behind; /* write-behind mode */
 		int			external;
-		int			nodes;
+		int			nodes; /* Maximum unmber of nodes in the cluster */
+		char                    cluster_name[64]; /* Name of the cluster */
 	} bitmap_info;
 
 	atomic_t 			max_corr_read_errors; /* max read retries */
-- 
2.1.2

