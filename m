From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 18/24] metadata_update sends message to other nodes
Date: Thu, 18 Dec 2014 10:18:19 -0600
Message-ID: <20141218161819.GA29650@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

   - request to send a message
   - make changes to superblock
   - send messages telling everyone that the superblock has changed
   - other nodes all read the superblock
   - other nodes all ack the messages
   - updating node release the "I'm sending a message" resource.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 28 ++++++++++++++-
 drivers/md/md-cluster.h |  3 ++
 drivers/md/md.c         | 91 +++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 106 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 1e11a9b..db81ef1 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -620,11 +620,37 @@ static void resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
 	dlm_lock_sync(cinfo->bitmap_lockres, DLM_LOCK_PW);
 }
 
+static int metadata_update_start(struct mddev *mddev)
+{
+	return lock_comm(mddev->cluster_info);
+}
+
+static int metadata_update_finish(struct mddev *mddev)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	struct cluster_msg cmsg;
+	int ret;
+	memset(&cmsg, 0, sizeof(cmsg));
+	cmsg.type = cpu_to_le32(METADATA_UPDATED);
+	ret = __sendmsg(cinfo, &cmsg);
+	unlock_comm(cinfo);
+	return ret;
+}
+
+static int metadata_update_cancel(struct mddev *mddev)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	return dlm_unlock_sync(cinfo->token_lockres);
+}
+
 static struct md_cluster_operations cluster_ops = {
 	.join   = join,
 	.leave  = leave,
 	.slot_number = slot_number,
-	.resync_info_update = resync_info_update
+	.resync_info_update = resync_info_update,
+	.metadata_update_start = metadata_update_start,
+	.metadata_update_finish = metadata_update_finish,
+	.metadata_update_cancel = metadata_update_cancel
 };
 
 static int __init cluster_init(void)
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index 51a24df..658982a 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -12,6 +12,9 @@ struct md_cluster_operations {
 	int (*leave)(struct mddev *mddev);
 	int (*slot_number)(struct mddev *mddev);
 	void (*resync_info_update)(struct mddev *mddev, sector_t lo, sector_t hi);
+	int (*metadata_update_start)(struct mddev *mddev);
+	int (*metadata_update_finish)(struct mddev *mddev);
+	int (*metadata_update_cancel)(struct mddev *mddev);
 };
 
 #endif /* _MD_CLUSTER_H */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6ac6609..2288137 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2639,10 +2639,14 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			err = -EBUSY;
 		else {
 			struct mddev *mddev = rdev->mddev;
+			if (mddev_is_clustered(mddev))
+				md_cluster_ops->metadata_update_start(mddev);
 			kick_rdev_from_array(rdev);
 			if (mddev->pers)
 				md_update_sb(mddev, 1);
 			md_new_event(mddev);
+			if (mddev_is_clustered(mddev))
+				md_cluster_ops->metadata_update_finish(mddev);
 			err = 0;
 		}
 	} else if (cmd_match(buf, "writemostly")) {
@@ -4092,8 +4096,12 @@ size_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err < 0)
 		return err;
 	if (mddev->pers) {
+		if (mddev_is_clustered(mddev))
+			md_cluster_ops->metadata_update_start(mddev);
 		err = update_size(mddev, sectors);
 		md_update_sb(mddev, 1);
+		if (mddev_is_clustered(mddev))
+			md_cluster_ops->metadata_update_finish(mddev);
 	} else {
 		if (mddev->dev_sectors == 0 ||
 		    mddev->dev_sectors > sectors)
@@ -5263,6 +5271,8 @@ static void md_clean(struct mddev *mddev)
 
 static void __md_stop_writes(struct mddev *mddev)
 {
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_start(mddev);
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
@@ -5280,6 +5290,8 @@ static void __md_stop_writes(struct mddev *mddev)
 		mddev->in_sync = 1;
 		md_update_sb(mddev, 1);
 	}
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_finish(mddev);
 }
 
 void md_stop_writes(struct mddev *mddev)
@@ -5901,6 +5913,9 @@ static int hot_remove_disk(struct mddev * mddev, dev_t dev)
 	if (!rdev)
 		return -ENXIO;
 
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_start(mddev);
+
 	clear_bit(Blocked, &rdev->flags);
 	remove_and_add_spares(mddev, rdev);
 
@@ -5911,8 +5926,13 @@ static int hot_remove_disk(struct mddev * mddev, dev_t dev)
 	md_update_sb(mddev, 1);
 	md_new_event(mddev);
 
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_finish(mddev);
+
 	return 0;
 busy:
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_cancel(mddev);
 	printk(KERN_WARNING "md: cannot remove active disk %s from %s ...\n",
 		bdevname(rdev->bdev,b), mdname(mddev));
 	return -EBUSY;
@@ -5962,12 +5982,15 @@ static int hot_add_disk(struct mddev * mddev, dev_t dev)
 		err = -EINVAL;
 		goto abort_export;
 	}
+
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_start(mddev);
 	clear_bit(In_sync, &rdev->flags);
 	rdev->desc_nr = -1;
 	rdev->saved_raid_disk = -1;
 	err = bind_rdev_to_array(rdev, mddev);
 	if (err)
-		goto abort_export;
+		goto abort_clustered;
 
 	/*
 	 * The rest should better be atomic, we can have disk failures
@@ -5978,6 +6001,8 @@ static int hot_add_disk(struct mddev * mddev, dev_t dev)
 
 	md_update_sb(mddev, 1);
 
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_finish(mddev);
 	/*
 	 * Kick recovery, maybe this spare has to be added to the
 	 * array immediately.
@@ -5987,6 +6012,9 @@ static int hot_add_disk(struct mddev * mddev, dev_t dev)
 	md_new_event(mddev);
 	return 0;
 
+abort_clustered:
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_cancel(mddev);
 abort_export:
 	export_rdev(rdev);
 	return err;
@@ -6231,7 +6259,7 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks)
  */
 static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 {
-	int rv = 0;
+	int rv = -EINVAL;
 	int cnt = 0;
 	int state = 0;
 
@@ -6280,6 +6308,8 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 			return rv;
 		}
 	}
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_start(mddev);
 	if (info->size >= 0 && mddev->dev_sectors / 2 != info->size)
 		rv = update_size(mddev, (sector_t)info->size * 2);
 
@@ -6287,17 +6317,25 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 		rv = update_raid_disks(mddev, info->raid_disks);
 
 	if ((state ^ info->state) & (1<<MD_SB_BITMAP_PRESENT)) {
-		if (mddev->pers->quiesce == NULL)
-			return -EINVAL;
-		if (mddev->recovery || mddev->sync_thread)
-			return -EBUSY;
+		if (mddev->pers->quiesce == NULL) {
+			rv = -EINVAL;
+			goto err;
+		}
+		if (mddev->recovery || mddev->sync_thread) {
+			rv = -EBUSY;
+			goto err;
+		}
 		if (info->state & (1<<MD_SB_BITMAP_PRESENT)) {
 			struct bitmap *bitmap;
 			/* add the bitmap */
-			if (mddev->bitmap)
-				return -EEXIST;
-			if (mddev->bitmap_info.default_offset == 0)
-				return -EINVAL;
+			if (mddev->bitmap) {
+				rv = -EEXIST;
+				goto err;
+			}
+			if (mddev->bitmap_info.default_offset == 0) {
+				rv = -EINVAL;
+				goto err;
+			}
 			mddev->bitmap_info.offset =
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
@@ -6313,10 +6351,14 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 			mddev->pers->quiesce(mddev, 0);
 		} else {
 			/* remove the bitmap */
-			if (!mddev->bitmap)
-				return -ENOENT;
-			if (mddev->bitmap->storage.file)
-				return -EINVAL;
+			if (!mddev->bitmap) {
+				rv = -ENOENT;
+				goto err;
+			}
+			if (mddev->bitmap->storage.file) {
+				rv = -EINVAL;
+				goto err;
+			}
 			mddev->pers->quiesce(mddev, 1);
 			bitmap_destroy(mddev);
 			mddev->pers->quiesce(mddev, 0);
@@ -6324,6 +6366,12 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 		}
 	}
 	md_update_sb(mddev, 1);
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_finish(mddev);
+	return rv;
+err:
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_cancel(mddev);
 	return rv;
 }
 
@@ -7425,7 +7473,11 @@ int md_allow_write(struct mddev *mddev)
 		    mddev->safemode == 0)
 			mddev->safemode = 1;
 		spin_unlock_irq(&mddev->write_lock);
+		if (mddev_is_clustered(mddev))
+			md_cluster_ops->metadata_update_start(mddev);
 		md_update_sb(mddev, 0);
+		if (mddev_is_clustered(mddev))
+			md_cluster_ops->metadata_update_finish(mddev);
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	} else
 		spin_unlock_irq(&mddev->write_lock);
@@ -7951,8 +8003,13 @@ void md_check_recovery(struct mddev *mddev)
 				sysfs_notify_dirent_safe(mddev->sysfs_state);
 		}
 
-		if (mddev->flags & MD_UPDATE_SB_FLAGS)
+		if (mddev->flags & MD_UPDATE_SB_FLAGS) {
+			if (mddev_is_clustered(mddev))
+				md_cluster_ops->metadata_update_start(mddev);
 			md_update_sb(mddev, 0);
+			if (mddev_is_clustered(mddev))
+				md_cluster_ops->metadata_update_finish(mddev);
+		}
 
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
 		    !test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
@@ -8061,6 +8118,8 @@ void md_reap_sync_thread(struct mddev *mddev)
 			set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		}
 	}
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_start(mddev);
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    mddev->pers->finish_reshape)
 		mddev->pers->finish_reshape(mddev);
@@ -8073,6 +8132,8 @@ void md_reap_sync_thread(struct mddev *mddev)
 			rdev->saved_raid_disk = -1;
 
 	md_update_sb(mddev, 1);
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_finish(mddev);
 	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-- 
2.1.2

