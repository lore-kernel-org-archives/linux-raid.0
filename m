From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 20/28] md: start to refactor do_md_stop
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.84679.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

do_md_stop is large and clunky, so hard to understand.

This is a first step of refactoring, pulling two simple
sub-functions out.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   98 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 55 insertions(+), 43 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 91333fe..3e9a96e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4567,6 +4567,58 @@ void restore_bitmap_write_access(struct file *file)
 	spin_unlock(&inode->i_lock);
 }
 
+static void md_clean(mddev_t *mddev)
+{
+	mddev->array_sectors = 0;
+	mddev->external_size = 0;
+	mddev->dev_sectors = 0;
+	mddev->raid_disks = 0;
+	mddev->recovery_cp = 0;
+	mddev->resync_min = 0;
+	mddev->resync_max = MaxSector;
+	mddev->reshape_position = MaxSector;
+	mddev->external = 0;
+	mddev->persistent = 0;
+	mddev->level = LEVEL_NONE;
+	mddev->clevel[0] = 0;
+	mddev->flags = 0;
+	mddev->ro = 0;
+	mddev->metadata_type[0] = 0;
+	mddev->chunk_sectors = 0;
+	mddev->ctime = mddev->utime = 0;
+	mddev->layout = 0;
+	mddev->max_disks = 0;
+	mddev->events = 0;
+	mddev->delta_disks = 0;
+	mddev->new_level = LEVEL_NONE;
+	mddev->new_layout = 0;
+	mddev->new_chunk_sectors = 0;
+	mddev->curr_resync = 0;
+	mddev->resync_mismatches = 0;
+	mddev->suspend_lo = mddev->suspend_hi = 0;
+	mddev->sync_speed_min = mddev->sync_speed_max = 0;
+	mddev->recovery = 0;
+	mddev->in_sync = 0;
+	mddev->degraded = 0;
+	mddev->barriers_work = 0;
+	mddev->safemode = 0;
+	mddev->bitmap_info.offset = 0;
+	mddev->bitmap_info.default_offset = 0;
+	mddev->bitmap_info.chunksize = 0;
+	mddev->bitmap_info.daemon_sleep = 0;
+	mddev->bitmap_info.max_write_behind = 0;
+}
+
+static void md_stop(mddev_t *mddev)
+{
+	mddev->pers->stop(mddev);
+	if (mddev->pers->sync_request && mddev->to_remove == NULL)
+		mddev->to_remove = &md_redundancy_group;
+	module_put(mddev->pers->owner);
+	mddev->pers = NULL;
+
+}
+
 /* mode:
  *   0 - completely stop and dis-assemble array
  *   1 - switch to readonly
@@ -4607,14 +4659,11 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 			if (mddev->ro)
 				set_disk_ro(disk, 0);
 
-			mddev->pers->stop(mddev);
+			md_stop(mddev);
 			mddev->queue->merge_bvec_fn = NULL;
 			mddev->queue->unplug_fn = NULL;
 			mddev->queue->backing_dev_info.congested_fn = NULL;
-			module_put(mddev->pers->owner);
-			if (mddev->pers->sync_request && mddev->to_remove == NULL)
-				mddev->to_remove = &md_redundancy_group;
-			mddev->pers = NULL;
+
 			/* tell userspace to handle 'inactive' */
 			sysfs_notify_dirent(mddev->sysfs_state);
 
@@ -4662,44 +4711,7 @@ out:
 
 		export_array(mddev);
 
-		mddev->array_sectors = 0;
-		mddev->external_size = 0;
-		mddev->dev_sectors = 0;
-		mddev->raid_disks = 0;
-		mddev->recovery_cp = 0;
-		mddev->resync_min = 0;
-		mddev->resync_max = MaxSector;
-		mddev->reshape_position = MaxSector;
-		mddev->external = 0;
-		mddev->persistent = 0;
-		mddev->level = LEVEL_NONE;
-		mddev->clevel[0] = 0;
-		mddev->flags = 0;
-		mddev->ro = 0;
-		mddev->metadata_type[0] = 0;
-		mddev->chunk_sectors = 0;
-		mddev->ctime = mddev->utime = 0;
-		mddev->layout = 0;
-		mddev->max_disks = 0;
-		mddev->events = 0;
-		mddev->delta_disks = 0;
-		mddev->new_level = LEVEL_NONE;
-		mddev->new_layout = 0;
-		mddev->new_chunk_sectors = 0;
-		mddev->curr_resync = 0;
-		mddev->resync_mismatches = 0;
-		mddev->suspend_lo = mddev->suspend_hi = 0;
-		mddev->sync_speed_min = mddev->sync_speed_max = 0;
-		mddev->recovery = 0;
-		mddev->in_sync = 0;
-		mddev->degraded = 0;
-		mddev->barriers_work = 0;
-		mddev->safemode = 0;
-		mddev->bitmap_info.offset = 0;
-		mddev->bitmap_info.default_offset = 0;
-		mddev->bitmap_info.chunksize = 0;
-		mddev->bitmap_info.daemon_sleep = 0;
-		mddev->bitmap_info.max_write_behind = 0;
+		md_clean(mddev);
 		kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;


