From: rgoldwyn@suse.de
Subject: [PATCH] md-cluster: Call update_raid_disks() if another node --grow's raid_disks
Date: Thu, 22 Oct 2015 08:31:09 -0500
Message-ID: <1445520669-4406-2-git-send-email-rgoldwyn@suse.de>
References: <1445520669-4406-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1445520669-4406-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

To incorporate --grow feature executed on one node, other nodes need to
acknowledge the change in number of disks. Call update_raid_disks()
to update internal data structures.

This leads to call check_reshape() -> md_allow_write() -> md_update_sb(),
this results in a deadlock. This is done so it can safely allocate memory
(which might trigger writeback which might write to raid1). This is
not required for md with a bitmap.

In the clustered case, we don't perform md_update_sb() in md_allow_write(),
but in do_md_run(). Also we disable safemode for clustered mode.

mddev->recovery_cp need not be set in check_sb_changes() because this
is required only when a node reads another node's bitmap. mddev->recovery_cp
(which is read from sb->resync_offset), is set only if mddev is in_sync.
Since we disabled safemode, in_sync is set to zero.
In a clustered environment, the MD may not be in sync because another
node could be writing to it. So make sure that in_sync is not set in
case of clustered node in __md_stop_writes().

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c    | 22 ++++++++++++++++------
 drivers/md/raid1.c |  8 +++++---
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a71b36f..0c70856 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2230,7 +2230,6 @@ static bool does_sb_need_changing(struct mddev *mddev)
 	/* Check if any mddev parameters have changed */
 	if ((mddev->dev_sectors != le64_to_cpu(sb->size)) ||
 	    (mddev->reshape_position != le64_to_cpu(sb->reshape_position)) ||
-	    (mddev->recovery_cp != le64_to_cpu(sb->resync_offset)) ||
 	    (mddev->layout != le64_to_cpu(sb->layout)) ||
 	    (mddev->raid_disks != le32_to_cpu(sb->raid_disks)) ||
 	    (mddev->chunk_sectors != le32_to_cpu(sb->chunksize)))
@@ -3314,6 +3313,11 @@ safe_delay_store(struct mddev *mddev, const char *cbuf, size_t len)
 {
 	unsigned long msec;
 
+	if (mddev_is_clustered(mddev)) {
+		pr_info("md: Safemode is disabled for clustered mode\n");
+		return -EINVAL;
+	}
+
 	if (strict_strtoul_scaled(cbuf, &msec, 3) < 0)
 		return -EINVAL;
 	if (msec == 0)
@@ -5224,7 +5228,10 @@ int md_run(struct mddev *mddev)
 	atomic_set(&mddev->max_corr_read_errors,
 		   MD_DEFAULT_MAX_CORRECTED_READ_ERRORS);
 	mddev->safemode = 0;
-	mddev->safemode_delay = (200 * HZ)/1000 +1; /* 200 msec delay */
+	if (mddev_is_clustered(mddev))
+		mddev->safemode_delay = 0;
+	else
+		mddev->safemode_delay = (200 * HZ)/1000 +1; /* 200 msec delay */
 	mddev->in_sync = 1;
 	smp_wmb();
 	spin_lock(&mddev->lock);
@@ -5267,6 +5274,9 @@ static int do_md_run(struct mddev *mddev)
 		goto out;
 	}
 
+	if (mddev_is_clustered(mddev))
+		md_allow_write(mddev);
+
 	md_wakeup_thread(mddev->thread);
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
@@ -5363,7 +5373,8 @@ static void __md_stop_writes(struct mddev *mddev)
 	md_super_wait(mddev);
 
 	if (mddev->ro == 0 &&
-	    (!mddev->in_sync || (mddev->flags & MD_UPDATE_SB_FLAGS))) {
+	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
+	     (mddev->flags & MD_UPDATE_SB_FLAGS))) {
 		/* mark array as shutdown cleanly */
 		mddev->in_sync = 1;
 		md_update_sb(mddev, 1);
@@ -9007,9 +9018,8 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 		}
 	}
 
-	/* recovery_cp changed */
-	if (le64_to_cpu(sb->resync_offset) != mddev->recovery_cp)
-		mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
+	if (mddev->raid_disks != le32_to_cpu(sb->raid_disks))
+		update_raid_disks(mddev, le32_to_cpu(sb->raid_disks));
 
 	/* Finally set the event to be up to date */
 	mddev->events = le64_to_cpu(sb->events);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a2d813c..5f38430 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3044,9 +3044,11 @@ static int raid1_reshape(struct mddev *mddev)
 		return -EINVAL;
 	}
 
-	err = md_allow_write(mddev);
-	if (err)
-		return err;
+	if (!mddev_is_clustered(mddev)) {
+		err = md_allow_write(mddev);
+		if (err)
+			return err;
+	}
 
 	raid_disks = mddev->raid_disks + mddev->delta_disks;
 
-- 
1.8.5.6

