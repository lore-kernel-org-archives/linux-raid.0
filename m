From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 4/4] md-cluster: re-add
Date: Wed, 8 Apr 2015 14:24:14 -0500
Message-ID: <20150408192414.GA9693@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, GQJiang@suse.com
List-Id: linux-raid.ids

This extends the capabilites of re-adding a failed device
to the clustering environment.

A new function gather_bitmaps gathers set bits from bitmaps of
all nodes, sends a message to all nodes to readd the disk
and then initiates the recovery process.

Question: Do you see a race in sending a READD and then performing
the bitmap resync/recovery? Should the initiating node perform the
recovery before sending the READD message? The recovery will send a
METADATA_UPDATE anyways.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/bitmap.c     | 20 +++++++++++---------
 drivers/md/bitmap.h     |  2 +-
 drivers/md/md-cluster.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md-cluster.h |  1 +
 drivers/md/md.c         |  2 ++
 5 files changed, 64 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index eccfa27..3e69583 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1869,7 +1869,7 @@ EXPORT_SYMBOL_GPL(bitmap_load);
  * to our bitmap
  */
 int bitmap_copy_from_slot(struct mddev *mddev, int slot,
-		sector_t *low, sector_t *high)
+		sector_t *low, sector_t *high, bool clear_bits)
 {
 	int rv = 0, i, j;
 	sector_t block, lo = 0, hi = 0;
@@ -1896,14 +1896,16 @@ int bitmap_copy_from_slot(struct mddev *mddev, int slot,
 		}
 	}
 
-	bitmap_update_sb(bitmap);
-	/* Setting this for the ev_page should be enough.
-	 * And we do not require both write_all and PAGE_DIRT either
-	 */
-	for (i = 0; i < bitmap->storage.file_pages; i++)
-		set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
-	bitmap_write_all(bitmap);
-	bitmap_unplug(bitmap);
+	if (clear_bits) {
+		bitmap_update_sb(bitmap);
+		/* Setting this for the ev_page should be enough.
+		 * And we do not require both write_all and PAGE_DIRT either
+		 */
+		for (i = 0; i < bitmap->storage.file_pages; i++)
+			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
+		bitmap_write_all(bitmap);
+		bitmap_unplug(bitmap);
+	}
 	*low = lo;
 	*high = hi;
 err:
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index e838ea7..74bffc7 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -263,7 +263,7 @@ void bitmap_daemon_work(struct mddev *mddev);
 int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		  int chunksize, int init);
 int bitmap_copy_from_slot(struct mddev *mddev, int slot,
-				sector_t *lo, sector_t *hi);
+				sector_t *lo, sector_t *hi, bool clear_bits);
 #endif
 
 #endif
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index d036c83..afffbee 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -50,6 +50,7 @@ struct md_cluster_info {
 	/* dlm lock space and resources for clustered raid. */
 	dlm_lockspace_t *lockspace;
 	int slot_number;
+	int total_slots;
 	struct completion completion;
 	struct dlm_lock_resource *sb_lock;
 	struct mutex sb_mutex;
@@ -73,6 +74,7 @@ enum msg_type {
 	RESYNCING,
 	NEWDISK,
 	REMOVE,
+	READD,
 };
 
 struct cluster_msg {
@@ -267,7 +269,7 @@ void recover_bitmaps(struct md_thread *thread)
 					str, ret);
 			goto clear_bit;
 		}
-		ret = bitmap_copy_from_slot(mddev, slot, &lo, &hi);
+		ret = bitmap_copy_from_slot(mddev, slot, &lo, &hi, true);
 		if (ret) {
 			pr_err("md-cluster: Could not copy data from bitmap %d\n", slot);
 			goto dlm_unlock;
@@ -427,6 +429,17 @@ static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
 		pr_warn("%s: %d Could not find disk with uuid: %s", __func__, __LINE__, pretty_uuid(uuid, msg->uuid));
 }
 
+static void process_readd_disk(struct mddev *mddev, struct cluster_msg *msg)
+{
+	struct md_rdev *rdev = find_rdev_uuid(mddev, msg->uuid);
+	char uuid[32];
+
+	if (rdev)
+		clear_bit(Faulty, &rdev->flags);
+	else
+		pr_warn("%s: %d Could not find disk with uuid: %s", __func__, __LINE__, pretty_uuid(uuid, msg->uuid));
+}
+
 static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 {
 	switch (msg->type) {
@@ -451,6 +464,11 @@ static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 			__func__, __LINE__, msg->slot);
 		process_remove_disk(mddev, msg);
 		break;
+	case READD:
+		pr_info("%s: %d Received READD from %d\n",
+			__func__, __LINE__, msg->slot);
+		process_readd_disk(mddev, msg);
+		break;
 	default:
 		pr_warn("%s:%d Received unknown message from %d\n",
 			__func__, __LINE__, msg->slot);
@@ -653,6 +671,7 @@ static int join(struct mddev *mddev, int nodes)
 		ret = -ERANGE;
 		goto err;
 	}
+	cinfo->total_slots = nodes;
 	cinfo->sb_lock = lockres_init(mddev, "cmd-super",
 					NULL, 0);
 	if (!cinfo->sb_lock) {
@@ -900,6 +919,34 @@ static int remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	return __sendmsg(cinfo, &cmsg);
 }
 
+static int gather_bitmaps(struct md_rdev *rdev)
+{
+	int sn, err;
+	sector_t lo, hi;
+	struct cluster_msg cmsg;
+	struct mddev *mddev = rdev->mddev;
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
+	char *uuid = sb->device_uuid;
+
+	for (sn = 0; sn < cinfo->total_slots; sn++) {
+		if (sn == (cinfo->slot_number - 1))
+			continue;
+		err = bitmap_copy_from_slot(mddev, sn, &lo, &hi, false);
+		if (err) {
+			pr_warn("md-cluster: Could not gather bitmaps from slot %d", sn);
+			goto out;
+		}
+		if ((hi > 0) && (lo < mddev->recovery_cp))
+			mddev->recovery_cp = lo;
+	}
+	cmsg.type = READD;
+	memcpy(cmsg.uuid, uuid, 16);
+	err = sendmsg(cinfo, &cmsg);
+out:
+	return err;
+}
+
 static struct md_cluster_operations cluster_ops = {
 	.join   = join,
 	.leave  = leave,
@@ -915,6 +962,7 @@ static struct md_cluster_operations cluster_ops = {
 	.add_new_disk_finish = add_new_disk_finish,
 	.new_disk_ack = new_disk_ack,
 	.remove_disk = remove_disk,
+	.gather_bitmaps = gather_bitmaps,
 };
 
 static int __init cluster_init(void)
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index 71e5143..6817ee0 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -23,6 +23,7 @@ struct md_cluster_operations {
 	int (*add_new_disk_finish)(struct mddev *mddev);
 	int (*new_disk_ack)(struct mddev *mddev, bool ack);
 	int (*remove_disk)(struct mddev *mddev, struct md_rdev *rdev);
+	int (*gather_bitmaps)(struct md_rdev *rdev);
 };
 
 #endif /* _MD_CLUSTER_H */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 83a8e91..a233c09 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2847,6 +2847,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			err = 0;
 		}
 	} else if (cmd_match(buf, "re-add")) {
+		if (mddev_is_clustered(rdev->mddev))
+			md_cluster_ops->gather_bitmaps(rdev);
 		clear_bit(Faulty, &rdev->flags);
 		err = add_bound_rdev(rdev);
 	}
-- 
2.1.4

