From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 3/3] md-cluster: Perform a lazy update
Date: Tue, 29 Sep 2015 10:21:29 -0500
Message-ID: <1443540089-5398-4-git-send-email-rgoldwyn@suse.com>
References: <1443540089-5398-1-git-send-email-rgoldwyn@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1443540089-5398-1-git-send-email-rgoldwyn@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

In a clustered environment, a change such as marking a device faulty,
can be recorded by any of the nodes. This is communicated to all the
nodes and re-recording such a change is unnecessary, and quite often
pretty disruptive.

With this patch, just before the update, we detect for the changes
and if the changes are already in superblock, we abort the update
after clearing all the flags

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c | 115 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 66 insertions(+), 49 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fe3ce06..e732d73 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2199,6 +2199,46 @@ static void sync_sbs(struct mddev *mddev, int nospares)
 	}
 }
 
+bool does_sb_need_changing(struct mddev *mddev)
+{
+	struct md_rdev *rdev;
+	struct mdp_superblock_1 *sb;
+	int role;
+
+	/* Find a good rdev */
+	rdev_for_each_rcu(rdev, mddev)
+		if ((rdev->raid_disk >= 0) && !test_bit(Faulty, &rdev->flags))
+			break;
+
+	/* No good device found. */
+	if (!rdev)
+		return false;
+
+	sb = page_address(rdev->sb_page);
+	/* Check if a device has become faulty or a spare become active */
+	rdev_for_each(rdev, mddev) {
+		role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
+		/* Device activated? */
+		if (role == 0xffff && rdev->raid_disk >=0 && !test_bit(Faulty, &rdev->flags))
+			return true;
+		/* Device turned faulty? */
+		if (test_bit(Faulty, &rdev->flags) && (role < 0xfffd))
+			return true;
+	}
+
+	/* Check if any mddev parameters have changed */
+	if ((mddev->dev_sectors != le64_to_cpu(sb->size)) ||
+			(mddev->reshape_position != le64_to_cpu(sb->reshape_position)) ||
+			(mddev->recovery_cp != le64_to_cpu(sb->resync_offset)) ||
+			(mddev->layout != le64_to_cpu(sb->layout)) ||
+			(mddev->raid_disks != le32_to_cpu(sb->raid_disks)) ||
+			(mddev->chunk_sectors != le32_to_cpu(sb->chunksize))
+			 )
+		return true;
+
+	return false;
+}
+
 void md_update_sb(struct mddev *mddev, int force_change)
 {
 	struct md_rdev *rdev;
@@ -2211,6 +2251,27 @@ void md_update_sb(struct mddev *mddev, int force_change)
 			set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		return;
 	}
+
+	if (mddev_is_clustered(mddev)) {
+		int change_devs;
+recheck:
+		change_devs = test_and_clear_bit(MD_CHANGE_DEVS, &mddev->flags);
+		md_cluster_ops->metadata_update_start(mddev);
+		/* Has someone else has updated the sb */
+		if (!does_sb_need_changing(mddev)) {
+			md_cluster_ops->metadata_update_cancel(mddev);
+			/* Check if someone set the bits while we
+			 *  were waiting on lock
+			 */
+			if (test_bit(MD_CHANGE_DEVS, &mddev->flags))
+				goto recheck;
+			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
+			return;
+		}
+
+		if (change_devs)
+			set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	}
 repeat:
 	/* First make sure individual recovery_offsets are correct */
 	rdev_for_each(rdev, mddev) {
@@ -2359,6 +2420,9 @@ repeat:
 		clear_bit(BlockedBadBlocks, &rdev->flags);
 		wake_up(&rdev->blocked_wait);
 	}
+
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->metadata_update_finish(mddev);
 }
 EXPORT_SYMBOL(md_update_sb);
 
@@ -2496,13 +2560,9 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			if (mddev_is_clustered(mddev))
 				md_cluster_ops->remove_disk(mddev, rdev);
 			md_kick_rdev_from_array(rdev);
-			if (mddev_is_clustered(mddev))
-				md_cluster_ops->metadata_update_start(mddev);
 			if (mddev->pers)
 				md_update_sb(mddev, 1);
 			md_new_event(mddev);
-			if (mddev_is_clustered(mddev))
-				md_cluster_ops->metadata_update_finish(mddev);
 			err = 0;
 		}
 	} else if (cmd_match(buf, "writemostly")) {
@@ -4063,12 +4123,8 @@ size_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err)
 		return err;
 	if (mddev->pers) {
-		if (mddev_is_clustered(mddev))
-			md_cluster_ops->metadata_update_start(mddev);
 		err = update_size(mddev, sectors);
 		md_update_sb(mddev, 1);
-		if (mddev_is_clustered(mddev))
-			md_cluster_ops->metadata_update_finish(mddev);
 	} else {
 		if (mddev->dev_sectors == 0 ||
 		    mddev->dev_sectors > sectors)
@@ -5306,8 +5362,6 @@ static void md_clean(struct mddev *mddev)
 
 static void __md_stop_writes(struct mddev *mddev)
 {
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_start(mddev);
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	flush_workqueue(md_misc_wq);
 	if (mddev->sync_thread) {
@@ -5326,8 +5380,6 @@ static void __md_stop_writes(struct mddev *mddev)
 		mddev->in_sync = 1;
 		md_update_sb(mddev, 1);
 	}
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_finish(mddev);
 }
 
 void md_stop_writes(struct mddev *mddev)
@@ -5995,9 +6047,6 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 	if (!rdev)
 		return -ENXIO;
 
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_start(mddev);
-
 	clear_bit(Blocked, &rdev->flags);
 	remove_and_add_spares(mddev, rdev);
 
@@ -6011,13 +6060,8 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 	md_update_sb(mddev, 1);
 	md_new_event(mddev);
 
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_finish(mddev);
-
 	return 0;
 busy:
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_cancel(mddev);
 	printk(KERN_WARNING "md: cannot remove active disk %s from %s ...\n",
 		bdevname(rdev->bdev,b), mdname(mddev));
 	return -EBUSY;
@@ -6068,14 +6112,12 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 		goto abort_export;
 	}
 
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_start(mddev);
 	clear_bit(In_sync, &rdev->flags);
 	rdev->desc_nr = -1;
 	rdev->saved_raid_disk = -1;
 	err = bind_rdev_to_array(rdev, mddev);
 	if (err)
-		goto abort_clustered;
+		goto abort_export;
 
 	/*
 	 * The rest should better be atomic, we can have disk failures
@@ -6085,9 +6127,6 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	rdev->raid_disk = -1;
 
 	md_update_sb(mddev, 1);
-
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_finish(mddev);
 	/*
 	 * Kick recovery, maybe this spare has to be added to the
 	 * array immediately.
@@ -6097,9 +6136,6 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	md_new_event(mddev);
 	return 0;
 
-abort_clustered:
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_cancel(mddev);
 abort_export:
 	export_rdev(rdev);
 	return err;
@@ -6417,8 +6453,6 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 			return rv;
 		}
 	}
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_start(mddev);
 	if (info->size >= 0 && mddev->dev_sectors / 2 != info->size)
 		rv = update_size(mddev, (sector_t)info->size * 2);
 
@@ -6476,12 +6510,8 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 		}
 	}
 	md_update_sb(mddev, 1);
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_finish(mddev);
 	return rv;
 err:
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_cancel(mddev);
 	return rv;
 }
 
@@ -7603,11 +7633,7 @@ int md_allow_write(struct mddev *mddev)
 		    mddev->safemode == 0)
 			mddev->safemode = 1;
 		spin_unlock(&mddev->lock);
-		if (mddev_is_clustered(mddev))
-			md_cluster_ops->metadata_update_start(mddev);
 		md_update_sb(mddev, 0);
-		if (mddev_is_clustered(mddev))
-			md_cluster_ops->metadata_update_finish(mddev);
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	} else
 		spin_unlock(&mddev->lock);
@@ -8186,13 +8212,8 @@ void md_check_recovery(struct mddev *mddev)
 				sysfs_notify_dirent_safe(mddev->sysfs_state);
 		}
 
-		if (mddev->flags & MD_UPDATE_SB_FLAGS) {
-			if (mddev_is_clustered(mddev))
-				md_cluster_ops->metadata_update_start(mddev);
+		if (mddev->flags & MD_UPDATE_SB_FLAGS)
 			md_update_sb(mddev, 0);
-			if (mddev_is_clustered(mddev))
-				md_cluster_ops->metadata_update_finish(mddev);
-		}
 
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
 		    !test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
@@ -8290,8 +8311,6 @@ void md_reap_sync_thread(struct mddev *mddev)
 			set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		}
 	}
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_start(mddev);
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    mddev->pers->finish_reshape)
 		mddev->pers->finish_reshape(mddev);
@@ -8304,8 +8323,6 @@ void md_reap_sync_thread(struct mddev *mddev)
 			rdev->saved_raid_disk = -1;
 
 	md_update_sb(mddev, 1);
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_finish(mddev);
 	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
-- 
1.8.5.6

