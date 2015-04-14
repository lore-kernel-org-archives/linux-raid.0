From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 6/6] md-cluster: re-add capabilities
Date: Tue, 14 Apr 2015 10:45:42 -0500
Message-ID: <20150414154541.GA4138@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: GQJiang@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When "re-add" is writted to /sys/block/mdXX/md/dev-YYY/state,
the clustered md:

1. Sends RE_ADD message with the desc_nr. Nodes receiving the message
   clear the Faulty bit in their respective rdev->flags.
2. The node initiating re-add, gathers the bitmaps of all nodes
   and copies them into the local bitmap. It does not clear the bitmap
   from which it is copying.
3. Initiating node schedules a md recovery to sync the devices.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/bitmap.c     | 20 +++++++++++---------
 drivers/md/bitmap.h     |  2 +-
 drivers/md/md-cluster.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md-cluster.h |  1 +
 drivers/md/md.c         | 12 ++++++++++++
 5 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5ff67c3..956cfb9 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1852,7 +1852,7 @@ EXPORT_SYMBOL_GPL(bitmap_load);
  * to our bitmap
  */
 int bitmap_copy_from_slot(struct mddev *mddev, int slot,
-		sector_t *low, sector_t *high)
+		sector_t *low, sector_t *high, bool clear_bits)
 {
 	int rv = 0, i, j;
 	sector_t block, lo = 0, hi = 0;
@@ -1879,14 +1879,16 @@ int bitmap_copy_from_slot(struct mddev *mddev, int slot,
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
index 4aabc74..f1f4dd0 100644
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
index 82f1b7b..ad2b5b7 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -73,6 +73,7 @@ enum msg_type {
 	RESYNCING,
 	NEWDISK,
 	REMOVE,
+	RE_ADD,
 };
 
 struct cluster_msg {
@@ -253,7 +254,7 @@ void recover_bitmaps(struct md_thread *thread)
 					str, ret);
 			goto clear_bit;
 		}
-		ret = bitmap_copy_from_slot(mddev, slot, &lo, &hi);
+		ret = bitmap_copy_from_slot(mddev, slot, &lo, &hi, true);
 		if (ret) {
 			pr_err("md-cluster: Could not copy data from bitmap %d\n", slot);
 			goto dlm_unlock;
@@ -412,6 +413,16 @@ static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
 		pr_warn("%s: %d Could not find disk(%d) to REMOVE\n", __func__, __LINE__, msg->raid_slot);
 }
 
+static void process_readd_disk(struct mddev *mddev, struct cluster_msg *msg)
+{
+	struct md_rdev *rdev = md_find_rdev_nr_rcu(mddev, msg->raid_slot);
+
+	if (rdev && test_bit(Faulty, &rdev->flags))
+		clear_bit(Faulty, &rdev->flags);
+	else
+		pr_warn("%s: %d Could not find disk(%d) which is faulty", __func__, __LINE__, msg->raid_slot);
+}
+
 static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 {
 	switch (msg->type) {
@@ -436,6 +447,11 @@ static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 			__func__, __LINE__, msg->slot);
 		process_remove_disk(mddev, msg);
 		break;
+	case RE_ADD:
+		pr_info("%s: %d Received RE_ADD from %d\n",
+			__func__, __LINE__, msg->slot);
+		process_readd_disk(mddev, msg);
+		break;
 	default:
 		pr_warn("%s:%d Received unknown message from %d\n",
 			__func__, __LINE__, msg->slot);
@@ -883,6 +899,35 @@ static int remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	return __sendmsg(cinfo, &cmsg);
 }
 
+static int gather_bitmaps(struct md_rdev *rdev)
+{
+	int sn, err;
+	sector_t lo, hi;
+	struct cluster_msg cmsg;
+	struct mddev *mddev = rdev->mddev;
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+
+	cmsg.type = RE_ADD;
+	cmsg.raid_slot = rdev->desc_nr;
+	err = sendmsg(cinfo, &cmsg);
+	if (err)
+		goto out;
+
+	for (sn = 0; sn < mddev->bitmap_info.nodes; sn++) {
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
+out:
+	return err;
+}
+
 static struct md_cluster_operations cluster_ops = {
 	.join   = join,
 	.leave  = leave,
@@ -898,6 +943,7 @@ static struct md_cluster_operations cluster_ops = {
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
index ba01605..8c37bbf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2599,11 +2599,23 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			err = 0;
 		}
 	} else if (cmd_match(buf, "re-add") && (test_bit(Faulty, &rdev->flags) || (rdev->raid_disk == -1))) {
+			/* clear_bit is performed _after_ all the devices
+			 * have their local Faulty bit cleared. If any writes
+			 * happen in the meantime in the local node, they
+			 * will land in the local bitmap, which will be synced
+			 * by this node eventually
+			 */
+			if (mddev_is_clustered(rdev->mddev)) {
+				err = md_cluster_ops->gather_bitmaps(rdev);
+				if (err)
+					goto out;
+			}
 			clear_bit(Faulty, &rdev->flags);
 			err = add_bound_rdev(rdev);
 		}
 	if (!err)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
+out:
 	return err ? err : len;
 }
 static struct rdev_sysfs_entry rdev_state =
-- 
2.1.4

