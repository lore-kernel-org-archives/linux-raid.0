From: Shaohua Li <shli@fb.com>
Subject: [PATCH 3/3] md: separate flags for superblock changes
Date: Thu, 8 Dec 2016 15:48:19 -0800
Message-ID: <a836dcdaef1cecec422f492cca1c4e525034d0e6.1481240632.git.shli@fb.com>
References: <cover.1481240632.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1481240632.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

The mddev->flags are used for different purposes. There are a lot of
places we check/change the flags without masking unrelated flags, we
could check/change unrelated flags. These usage are most for superblock
write, so spearate superblock related flags. This should make the code
clearer and also fix real bugs.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/bitmap.c      |   4 +-
 drivers/md/dm-raid.c     |   4 +-
 drivers/md/md.c          | 115 ++++++++++++++++++++++++-----------------------
 drivers/md/md.h          |  16 ++++---
 drivers/md/multipath.c   |   2 +-
 drivers/md/raid1.c       |  12 ++---
 drivers/md/raid10.c      |  22 ++++-----
 drivers/md/raid5-cache.c |   6 +--
 drivers/md/raid5.c       |  26 +++++------
 9 files changed, 106 insertions(+), 101 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index c462157..9fb2cca 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1623,7 +1623,7 @@ void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
 		   atomic_read(&bitmap->mddev->recovery_active) == 0);
 
 	bitmap->mddev->curr_resync_completed = sector;
-	set_bit(MD_CHANGE_CLEAN, &bitmap->mddev->flags);
+	set_bit(MD_SB_CHANGE_CLEAN, &bitmap->mddev->sb_flags);
 	sector &= ~((1ULL << bitmap->counts.chunkshift) - 1);
 	s = 0;
 	while (s < sector && s < bitmap->mddev->resync_max_sectors) {
@@ -2296,7 +2296,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 		/* Ensure new bitmap info is stored in
 		 * metadata promptly.
 		 */
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
 	}
 	rv = 0;
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 6d53810..953159d 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2011,7 +2011,7 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 		sb->compat_features = cpu_to_le32(FEATURE_FLAG_SUPPORTS_V190);
 
 		/* Force writing of superblocks to disk */
-		set_bit(MD_CHANGE_DEVS, &rdev->mddev->flags);
+		set_bit(MD_SB_CHANGE_DEVS, &rdev->mddev->sb_flags);
 
 		/* Any superblock is better than none, choose that if given */
 		return refdev ? 0 : 1;
@@ -3497,7 +3497,7 @@ static void rs_update_sbs(struct raid_set *rs)
 	struct mddev *mddev = &rs->md;
 	int ro = mddev->ro;
 
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	mddev->ro = 0;
 	md_update_sb(mddev, 1);
 	mddev->ro = ro;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5e66648..c15e234 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -729,7 +729,7 @@ static void super_written(struct bio *bio)
 		md_error(mddev, rdev);
 		if (!test_bit(Faulty, &rdev->flags)
 		    && (bio->bi_opf & MD_FAILFAST)) {
-			set_bit(MD_NEED_REWRITE, &mddev->flags);
+			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
 			set_bit(LastDev, &rdev->flags);
 		}
 	} else
@@ -780,7 +780,7 @@ int md_super_wait(struct mddev *mddev)
 {
 	/* wait for all superblock writes that were scheduled to complete */
 	wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
-	if (test_and_clear_bit(MD_NEED_REWRITE, &mddev->flags))
+	if (test_and_clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
 		return -EAGAIN;
 	return 0;
 }
@@ -2322,24 +2322,24 @@ void md_update_sb(struct mddev *mddev, int force_change)
 
 	if (mddev->ro) {
 		if (force_change)
-			set_bit(MD_CHANGE_DEVS, &mddev->flags);
+			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		return;
 	}
 
 repeat:
 	if (mddev_is_clustered(mddev)) {
-		if (test_and_clear_bit(MD_CHANGE_DEVS, &mddev->flags))
+		if (test_and_clear_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags))
 			force_change = 1;
-		if (test_and_clear_bit(MD_CHANGE_CLEAN, &mddev->flags))
+		if (test_and_clear_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags))
 			nospares = 1;
 		ret = md_cluster_ops->metadata_update_start(mddev);
 		/* Has someone else has updated the sb */
 		if (!does_sb_need_changing(mddev)) {
 			if (ret == 0)
 				md_cluster_ops->metadata_update_cancel(mddev);
-			bit_clear_unless(&mddev->flags, BIT(MD_CHANGE_PENDING),
-							 BIT(MD_CHANGE_DEVS) |
-							 BIT(MD_CHANGE_CLEAN));
+			bit_clear_unless(&mddev->sb_flags, BIT(MD_SB_CHANGE_PENDING),
+							 BIT(MD_SB_CHANGE_DEVS) |
+							 BIT(MD_SB_CHANGE_CLEAN));
 			return;
 		}
 	}
@@ -2355,10 +2355,10 @@ void md_update_sb(struct mddev *mddev, int force_change)
 
 	}
 	if (!mddev->persistent) {
-		clear_bit(MD_CHANGE_CLEAN, &mddev->flags);
-		clear_bit(MD_CHANGE_DEVS, &mddev->flags);
+		clear_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
+		clear_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		if (!mddev->external) {
-			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
+			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
 			rdev_for_each(rdev, mddev) {
 				if (rdev->badblocks.changed) {
 					rdev->badblocks.changed = 0;
@@ -2378,9 +2378,9 @@ void md_update_sb(struct mddev *mddev, int force_change)
 
 	mddev->utime = ktime_get_real_seconds();
 
-	if (test_and_clear_bit(MD_CHANGE_DEVS, &mddev->flags))
+	if (test_and_clear_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags))
 		force_change = 1;
-	if (test_and_clear_bit(MD_CHANGE_CLEAN, &mddev->flags))
+	if (test_and_clear_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags))
 		/* just a clean<-> dirty transition, possibly leave spares alone,
 		 * though if events isn't the right even/odd, we will have to do
 		 * spares after all
@@ -2472,14 +2472,14 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	}
 	if (md_super_wait(mddev) < 0)
 		goto rewrite;
-	/* if there was a failure, MD_CHANGE_DEVS was set, and we re-write super */
+	/* if there was a failure, MD_SB_CHANGE_DEVS was set, and we re-write super */
 
 	if (mddev_is_clustered(mddev) && ret == 0)
 		md_cluster_ops->metadata_update_finish(mddev);
 
 	if (mddev->in_sync != sync_req ||
-	    !bit_clear_unless(&mddev->flags, BIT(MD_CHANGE_PENDING),
-			       BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_CLEAN)))
+	    !bit_clear_unless(&mddev->sb_flags, BIT(MD_SB_CHANGE_PENDING),
+			       BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_CLEAN)))
 		/* have to write it out again */
 		goto repeat;
 	wake_up(&mddev->sb_wait);
@@ -2523,7 +2523,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 	}
 	sysfs_notify_dirent_safe(rdev->sysfs_state);
 
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -2640,7 +2640,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			if (err == 0) {
 				md_kick_rdev_from_array(rdev);
 				if (mddev->pers) {
-					set_bit(MD_CHANGE_DEVS, &mddev->flags);
+					set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 					md_wakeup_thread(mddev->thread);
 				}
 				md_new_event(mddev);
@@ -3651,7 +3651,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	blk_set_stacking_limits(&mddev->queue->limits);
 	pers->run(mddev);
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	mddev_resume(mddev);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
@@ -3846,7 +3846,7 @@ resync_start_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!err) {
 		mddev->recovery_cp = n;
 		if (mddev->pers)
-			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
 	}
 	mddev_unlock(mddev);
 	return err ?: len;
@@ -3920,7 +3920,7 @@ array_state_show(struct mddev *mddev, char *page)
 			st = read_auto;
 			break;
 		case 0:
-			if (test_bit(MD_CHANGE_PENDING, &mddev->flags))
+			if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
 				st = write_pending;
 			else if (mddev->in_sync)
 				st = clean;
@@ -3958,7 +3958,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		spin_lock(&mddev->lock);
 		if (st == active) {
 			restart_array(mddev);
-			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
+			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
 			md_wakeup_thread(mddev->thread);
 			wake_up(&mddev->sb_wait);
 			err = 0;
@@ -3969,7 +3969,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 					mddev->in_sync = 1;
 					if (mddev->safemode == 1)
 						mddev->safemode = 0;
-					set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+					set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
 				}
 				err = 0;
 			} else
@@ -4035,7 +4035,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 					mddev->in_sync = 1;
 					if (mddev->safemode == 1)
 						mddev->safemode = 0;
-					set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+					set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
 				}
 				err = 0;
 			} else
@@ -4049,7 +4049,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 			err = restart_array(mddev);
 			if (err)
 				break;
-			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
+			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
 			wake_up(&mddev->sb_wait);
 			err = 0;
 		} else {
@@ -5378,7 +5378,7 @@ int md_run(struct mddev *mddev)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 
-	if (mddev->flags & MD_UPDATE_SB_FLAGS)
+	if (mddev->sb_flags)
 		md_update_sb(mddev, 0);
 
 	md_new_event(mddev);
@@ -5473,6 +5473,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->level = LEVEL_NONE;
 	mddev->clevel[0] = 0;
 	mddev->flags = 0;
+	mddev->sb_flags = 0;
 	mddev->ro = 0;
 	mddev->metadata_type[0] = 0;
 	mddev->chunk_sectors = 0;
@@ -5525,7 +5526,7 @@ static void __md_stop_writes(struct mddev *mddev)
 
 	if (mddev->ro == 0 &&
 	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
-	     (mddev->flags & MD_UPDATE_SB_FLAGS))) {
+	     mddev->sb_flags)) {
 		/* mark array as shutdown cleanly */
 		if (!mddev_is_clustered(mddev))
 			mddev->in_sync = 1;
@@ -5608,13 +5609,13 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 		 * which will now never happen */
 		wake_up_process(mddev->sync_thread->tsk);
 
-	if (mddev->external && test_bit(MD_CHANGE_PENDING, &mddev->flags))
+	if (mddev->external && test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
 		return -EBUSY;
 	mddev_unlock(mddev);
 	wait_event(resync_wait, !test_bit(MD_RECOVERY_RUNNING,
 					  &mddev->recovery));
 	wait_event(mddev->sb_wait,
-		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
+		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 	mddev_lock_nointr(mddev);
 
 	mutex_lock(&mddev->open_mutex);
@@ -6234,7 +6235,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		md_cluster_ops->remove_disk(mddev, rdev);
 
 	md_kick_rdev_from_array(rdev);
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (mddev->thread)
 		md_wakeup_thread(mddev->thread);
 	else
@@ -6303,7 +6304,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 
 	rdev->raid_disk = -1;
 
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
 	/*
@@ -6460,9 +6461,11 @@ static int set_array_info(struct mddev *mddev, mdu_array_info_t *info)
 
 	mddev->max_disks     = MD_SB_DISKS;
 
-	if (mddev->persistent)
+	if (mddev->persistent) {
 		mddev->flags         = 0;
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		mddev->sb_flags         = 0;
+	}
+	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 
 	mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
 	mddev->bitmap_info.default_space = 64*2 - (MD_SB_BYTES >> 9);
@@ -7007,11 +7010,11 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 			/* If a device failed while we were read-only, we
 			 * need to make sure the metadata is updated now.
 			 */
-			if (test_bit(MD_CHANGE_DEVS, &mddev->flags)) {
+			if (test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)) {
 				mddev_unlock(mddev);
 				wait_event(mddev->sb_wait,
-					   !test_bit(MD_CHANGE_DEVS, &mddev->flags) &&
-					   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
+					   !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags) &&
+					   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 				mddev_lock_nointr(mddev);
 			}
 		} else {
@@ -7766,8 +7769,8 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 		spin_lock(&mddev->lock);
 		if (mddev->in_sync) {
 			mddev->in_sync = 0;
-			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
-			set_bit(MD_CHANGE_PENDING, &mddev->flags);
+			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
+			set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
 			md_wakeup_thread(mddev->thread);
 			did_change = 1;
 		}
@@ -7776,7 +7779,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 	if (did_change)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	wait_event(mddev->sb_wait,
-		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
+		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 }
 EXPORT_SYMBOL(md_write_start);
 
@@ -7797,7 +7800,7 @@ EXPORT_SYMBOL(md_write_end);
  * attempting a GFP_KERNEL allocation while holding the mddev lock.
  * Must be called with mddev_lock held.
  *
- * In the ->external case MD_CHANGE_PENDING can not be cleared until mddev->lock
+ * In the ->external case MD_SB_CHANGE_PENDING can not be cleared until mddev->lock
  * is dropped, so return -EAGAIN after notifying userspace.
  */
 int md_allow_write(struct mddev *mddev)
@@ -7812,8 +7815,8 @@ int md_allow_write(struct mddev *mddev)
 	spin_lock(&mddev->lock);
 	if (mddev->in_sync) {
 		mddev->in_sync = 0;
-		set_bit(MD_CHANGE_CLEAN, &mddev->flags);
-		set_bit(MD_CHANGE_PENDING, &mddev->flags);
+		set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
+		set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
 		if (mddev->safemode_delay &&
 		    mddev->safemode == 0)
 			mddev->safemode = 1;
@@ -7823,7 +7826,7 @@ int md_allow_write(struct mddev *mddev)
 	} else
 		spin_unlock(&mddev->lock);
 
-	if (test_bit(MD_CHANGE_PENDING, &mddev->flags))
+	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
 		return -EAGAIN;
 	else
 		return 0;
@@ -8058,7 +8061,7 @@ void md_do_sync(struct md_thread *thread)
 			    j > mddev->recovery_cp)
 				mddev->recovery_cp = j;
 			update_time = jiffies;
-			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
 			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 		}
 
@@ -8206,8 +8209,8 @@ void md_do_sync(struct md_thread *thread)
 	/* set CHANGE_PENDING here since maybe another update is needed,
 	 * so other nodes are informed. It should be harmless for normal
 	 * raid */
-	set_mask_bits(&mddev->flags, 0,
-		      BIT(MD_CHANGE_PENDING) | BIT(MD_CHANGE_DEVS));
+	set_mask_bits(&mddev->sb_flags, 0,
+		      BIT(MD_SB_CHANGE_PENDING) | BIT(MD_SB_CHANGE_DEVS));
 
 	spin_lock(&mddev->lock);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
@@ -8307,12 +8310,12 @@ static int remove_and_add_spares(struct mddev *mddev,
 			if (!test_bit(Journal, &rdev->flags))
 				spares++;
 			md_new_event(mddev);
-			set_bit(MD_CHANGE_DEVS, &mddev->flags);
+			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		}
 	}
 no_add:
 	if (removed)
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	return spares;
 }
 
@@ -8385,7 +8388,7 @@ void md_check_recovery(struct mddev *mddev)
 	if (mddev->ro && !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return;
 	if ( ! (
-		(mddev->flags & MD_UPDATE_SB_FLAGS & ~ (1<<MD_CHANGE_PENDING)) ||
+		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
 		test_bit(MD_RELOAD_SB, &mddev->flags) ||
@@ -8423,7 +8426,7 @@ void md_check_recovery(struct mddev *mddev)
 			md_reap_sync_thread(mddev);
 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
+			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
 			goto unlock;
 		}
 
@@ -8451,7 +8454,7 @@ void md_check_recovery(struct mddev *mddev)
 			    mddev->recovery_cp == MaxSector) {
 				mddev->in_sync = 1;
 				did_change = 1;
-				set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+				set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
 			}
 			if (mddev->safemode == 1)
 				mddev->safemode = 0;
@@ -8460,7 +8463,7 @@ void md_check_recovery(struct mddev *mddev)
 				sysfs_notify_dirent_safe(mddev->sysfs_state);
 		}
 
-		if (mddev->flags & MD_UPDATE_SB_FLAGS)
+		if (mddev->sb_flags)
 			md_update_sb(mddev, 0);
 
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
@@ -8556,7 +8559,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 		if (mddev->pers->spare_active(mddev)) {
 			sysfs_notify(&mddev->kobj, NULL,
 				     "degraded");
-			set_bit(MD_CHANGE_DEVS, &mddev->flags);
+			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		}
 	}
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
@@ -8571,7 +8574,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 			rdev->saved_raid_disk = -1;
 
 	md_update_sb(mddev, 1);
-	/* MD_CHANGE_PENDING should be cleared by md_update_sb, so we can
+	/* MD_SB_CHANGE_PENDING should be cleared by md_update_sb, so we can
 	 * call resync_finish here if MD_CLUSTER_RESYNC_LOCKED is set by
 	 * clustered raid */
 	if (test_and_clear_bit(MD_CLUSTER_RESYNC_LOCKED, &mddev->flags))
@@ -8637,8 +8640,8 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 			sysfs_notify(&rdev->kobj, NULL,
 				     "unacknowledged_bad_blocks");
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
-		set_mask_bits(&mddev->flags, 0,
-			      BIT(MD_CHANGE_CLEAN) | BIT(MD_CHANGE_PENDING));
+		set_mask_bits(&mddev->sb_flags, 0,
+			      BIT(MD_SB_CHANGE_CLEAN) | BIT(MD_SB_CHANGE_PENDING));
 		md_wakeup_thread(rdev->mddev->thread);
 		return 1;
 	} else
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5c08f84..e38936d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -213,9 +213,6 @@ extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 struct md_cluster_info;
 
 enum mddev_flags {
-	MD_CHANGE_DEVS,		/* Some device status has changed */
-	MD_CHANGE_CLEAN,	/* transition to or from 'clean' */
-	MD_CHANGE_PENDING,	/* switch from 'clean' to 'active' in progress */
 	MD_ARRAY_FIRST_USE,	/* First use of array, needs initialization */
 	MD_CLOSING,		/* If set, we are closing the array, do not open
 				 * it then */
@@ -231,11 +228,15 @@ enum mddev_flags {
 				 * supported as calls to md_error() will
 				 * never cause the array to become failed.
 				 */
-	MD_NEED_REWRITE,	/* metadata write needs to be repeated */
 };
-#define MD_UPDATE_SB_FLAGS (BIT(MD_CHANGE_DEVS) | \
-			    BIT(MD_CHANGE_CLEAN) | \
-			    BIT(MD_CHANGE_PENDING))	/* If these are set, md_update_sb needed */
+
+enum mddev_sb_flags {
+	MD_SB_CHANGE_DEVS,		/* Some device status has changed */
+	MD_SB_CHANGE_CLEAN,	/* transition to or from 'clean' */
+	MD_SB_CHANGE_PENDING,	/* switch from 'clean' to 'active' in progress */
+	MD_SB_NEED_REWRITE,	/* metadata write needs to be repeated */
+};
+
 struct mddev {
 	void				*private;
 	struct md_personality		*pers;
@@ -243,6 +244,7 @@ struct mddev {
 	int				md_minor;
 	struct list_head		disks;
 	unsigned long			flags;
+	unsigned long			sb_flags;
 
 	int				suspended;
 	atomic_t			active_io;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 589b807..9fa2d6c 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -208,7 +208,7 @@ static void multipath_error (struct mddev *mddev, struct md_rdev *rdev)
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 	set_bit(Faulty, &rdev->flags);
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	pr_err("multipath: IO failure on %s, disabling IO path.\n"
 	       "multipath: Operation continuing on %d IO paths.\n",
 	       bdevname(rdev->bdev, b),
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index efc2e74..a1f3fbe 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1517,8 +1517,8 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	 * if recovery is running, make sure it aborts.
 	 */
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-	set_mask_bits(&mddev->flags, 0,
-		      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
+	set_mask_bits(&mddev->sb_flags, 0,
+		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 	pr_crit("md/raid1:%s: Disk failure on %s, disabling device.\n"
 		"md/raid1:%s: Operation continuing on %d devices.\n",
 		mdname(mddev), bdevname(rdev->bdev, b),
@@ -2464,10 +2464,10 @@ static void raid1d(struct md_thread *thread)
 	md_check_recovery(mddev);
 
 	if (!list_empty_careful(&conf->bio_end_io_list) &&
-	    !test_bit(MD_CHANGE_PENDING, &mddev->flags)) {
+	    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 		LIST_HEAD(tmp);
 		spin_lock_irqsave(&conf->device_lock, flags);
-		if (!test_bit(MD_CHANGE_PENDING, &mddev->flags)) {
+		if (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 			while (!list_empty(&conf->bio_end_io_list)) {
 				list_move(conf->bio_end_io_list.prev, &tmp);
 				conf->nr_queued--;
@@ -2521,7 +2521,7 @@ static void raid1d(struct md_thread *thread)
 			generic_make_request(r1_bio->bios[r1_bio->read_disk]);
 
 		cond_resched();
-		if (mddev->flags & ~(1<<MD_CHANGE_PENDING))
+		if (mddev->sb_flags & ~(1<<MD_SB_CHANGE_PENDING))
 			md_check_recovery(mddev);
 	}
 	blk_finish_plug(&plug);
@@ -2724,7 +2724,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 							min_bad, 0
 					) && ok;
 			}
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		*skipped = 1;
 		put_buf(r1_bio);
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 525ca99..ab5e862 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1138,12 +1138,12 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 		bio->bi_iter.bi_sector < conf->reshape_progress))) {
 		/* Need to update reshape_position in metadata */
 		mddev->reshape_position = conf->reshape_progress;
-		set_mask_bits(&mddev->flags, 0,
-			      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
+		set_mask_bits(&mddev->sb_flags, 0,
+			      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 		md_wakeup_thread(mddev->thread);
 		raid10_log(conf->mddev, "wait reshape metadata");
 		wait_event(mddev->sb_wait,
-			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
+			   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 
 		conf->reshape_safe = mddev->reshape_position;
 	}
@@ -1652,8 +1652,8 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(Blocked, &rdev->flags);
 	set_bit(Faulty, &rdev->flags);
-	set_mask_bits(&mddev->flags, 0,
-		      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
+	set_mask_bits(&mddev->sb_flags, 0,
+		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	pr_crit("md/raid10:%s: Disk failure on %s, disabling device.\n"
 		"md/raid10:%s: Operation continuing on %d devices.\n",
@@ -2761,10 +2761,10 @@ static void raid10d(struct md_thread *thread)
 	md_check_recovery(mddev);
 
 	if (!list_empty_careful(&conf->bio_end_io_list) &&
-	    !test_bit(MD_CHANGE_PENDING, &mddev->flags)) {
+	    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 		LIST_HEAD(tmp);
 		spin_lock_irqsave(&conf->device_lock, flags);
-		if (!test_bit(MD_CHANGE_PENDING, &mddev->flags)) {
+		if (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 			while (!list_empty(&conf->bio_end_io_list)) {
 				list_move(conf->bio_end_io_list.prev, &tmp);
 				conf->nr_queued--;
@@ -2822,7 +2822,7 @@ static void raid10d(struct md_thread *thread)
 		}
 
 		cond_resched();
-		if (mddev->flags & ~(1<<MD_CHANGE_PENDING))
+		if (mddev->sb_flags & ~(1<<MD_SB_CHANGE_PENDING))
 			md_check_recovery(mddev);
 	}
 	blk_finish_plug(&plug);
@@ -4209,7 +4209,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	spin_unlock_irq(&conf->device_lock);
 	mddev->raid_disks = conf->geo.raid_disks;
 	mddev->reshape_position = conf->reshape_progress;
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
@@ -4404,9 +4404,9 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		else
 			mddev->curr_resync_completed = conf->reshape_progress;
 		conf->reshape_checkpoint = jiffies;
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
-		wait_event(mddev->sb_wait, mddev->flags == 0 ||
+		wait_event(mddev->sb_wait, mddev->sb_flags == 0 ||
 			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 			allow_barrier(conf);
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index de8a4ed..6d1a150 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1206,8 +1206,8 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 	 * there is a deadlock. We workaround this issue with a trylock.
 	 * FIXME: we could miss discard if we can't take reconfig mutex
 	 */
-	set_mask_bits(&mddev->flags, 0,
-		BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
+	set_mask_bits(&mddev->sb_flags, 0,
+		BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 	if (!mddev_trylock(mddev))
 		return;
 	md_update_sb(mddev, 1);
@@ -2197,7 +2197,7 @@ static void r5l_write_super(struct r5l_log *log, sector_t cp)
 	struct mddev *mddev = log->rdev->mddev;
 
 	log->rdev->journal_tail = cp;
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 }
 
 static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3e6a2a0..d40e94d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -961,7 +961,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			if (bad < 0) {
 				set_bit(BlockedBadBlocks, &rdev->flags);
 				if (!conf->mddev->external &&
-				    conf->mddev->flags) {
+				    conf->mddev->sb_flags) {
 					/* It is very unlikely, but we might
 					 * still need to write out the
 					 * bad block log - better give it
@@ -2547,8 +2547,8 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 
 	set_bit(Blocked, &rdev->flags);
 	set_bit(Faulty, &rdev->flags);
-	set_mask_bits(&mddev->flags, 0,
-		      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
+	set_mask_bits(&mddev->sb_flags, 0,
+		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 	pr_crit("md/raid:%s: Disk failure on %s, disabling device.\n"
 		"md/raid:%s: Operation continuing on %d devices.\n",
 		mdname(mddev),
@@ -4761,7 +4761,7 @@ static void handle_stripe(struct stripe_head *sh)
 	}
 
 	if (!bio_list_empty(&s.return_bi)) {
-		if (test_bit(MD_CHANGE_PENDING, &conf->mddev->flags)) {
+		if (test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
 			spin_lock_irq(&conf->device_lock);
 			bio_list_merge(&conf->return_bi, &s.return_bi);
 			spin_unlock_irq(&conf->device_lock);
@@ -5617,9 +5617,9 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		mddev->reshape_position = conf->reshape_progress;
 		mddev->curr_resync_completed = sector_nr;
 		conf->reshape_checkpoint = jiffies;
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
-		wait_event(mddev->sb_wait, mddev->flags == 0 ||
+		wait_event(mddev->sb_wait, mddev->sb_flags == 0 ||
 			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			return 0;
@@ -5715,10 +5715,10 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		mddev->reshape_position = conf->reshape_progress;
 		mddev->curr_resync_completed = sector_nr;
 		conf->reshape_checkpoint = jiffies;
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
 		wait_event(mddev->sb_wait,
-			   !test_bit(MD_CHANGE_DEVS, &mddev->flags)
+			   !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)
 			   || test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			goto ret;
@@ -5993,10 +5993,10 @@ static void raid5d(struct md_thread *thread)
 	md_check_recovery(mddev);
 
 	if (!bio_list_empty(&conf->return_bi) &&
-	    !test_bit(MD_CHANGE_PENDING, &mddev->flags)) {
+	    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 		struct bio_list tmp = BIO_EMPTY_LIST;
 		spin_lock_irq(&conf->device_lock);
-		if (!test_bit(MD_CHANGE_PENDING, &mddev->flags)) {
+		if (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 			bio_list_merge(&tmp, &conf->return_bi);
 			bio_list_init(&conf->return_bi);
 		}
@@ -6043,7 +6043,7 @@ static void raid5d(struct md_thread *thread)
 			break;
 		handled += batch_size;
 
-		if (mddev->flags & ~(1<<MD_CHANGE_PENDING)) {
+		if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
 			spin_unlock_irq(&conf->device_lock);
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
@@ -7640,7 +7640,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 	}
 	mddev->raid_disks = conf->raid_disks;
 	mddev->reshape_position = conf->reshape_progress;
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
@@ -7906,7 +7906,7 @@ static int raid5_check_reshape(struct mddev *mddev)
 			conf->chunk_sectors = new_chunk ;
 			mddev->chunk_sectors = new_chunk;
 		}
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
 	}
 	return check_reshape(mddev);
-- 
2.9.3

