From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 18/28] md: remove ->changed and related code.
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.41872.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We set ->changed to 1 and call check_disk_change at the end
of md_open so that bd_invalidated would be set and thus
partition rescan would happen appropriately.

Now that we call revalidate_disk directly, which sets bd_invalidates,
that indirection is no longer needed and can be removed.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c    |   22 +---------------------
 drivers/md/md.h    |    1 -
 drivers/md/raid1.c |    1 -
 drivers/md/raid5.c |    2 --
 4 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 56a2c12..06100d9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4500,7 +4500,6 @@ static int do_md_run(mddev_t * mddev)
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
 	revalidate_disk(mddev->gendisk);
-	mddev->changed = 1;
 	md_new_event(mddev);
 	sysfs_notify_dirent(mddev->sysfs_state);
 	if (mddev->sysfs_action)
@@ -4619,7 +4618,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 				}
 
 			set_capacity(disk, 0);
-			mddev->changed = 1;
+			revalidate_disk(disk);
 
 			if (mddev->ro)
 				mddev->ro = 0;
@@ -4685,7 +4684,6 @@ out:
 		mddev->sync_speed_min = mddev->sync_speed_max = 0;
 		mddev->recovery = 0;
 		mddev->in_sync = 0;
-		mddev->changed = 0;
 		mddev->degraded = 0;
 		mddev->barriers_work = 0;
 		mddev->safemode = 0;
@@ -5820,7 +5818,6 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	atomic_inc(&mddev->openers);
 	mutex_unlock(&mddev->open_mutex);
 
-	check_disk_change(bdev);
  out:
 	return err;
 }
@@ -5835,21 +5832,6 @@ static int md_release(struct gendisk *disk, fmode_t mode)
 
 	return 0;
 }
-
-static int md_media_changed(struct gendisk *disk)
-{
-	mddev_t *mddev = disk->private_data;
-
-	return mddev->changed;
-}
-
-static int md_revalidate(struct gendisk *disk)
-{
-	mddev_t *mddev = disk->private_data;
-
-	mddev->changed = 0;
-	return 0;
-}
 static const struct block_device_operations md_fops =
 {
 	.owner		= THIS_MODULE,
@@ -5860,8 +5842,6 @@ static const struct block_device_operations md_fops =
 	.compat_ioctl	= md_compat_ioctl,
 #endif
 	.getgeo		= md_getgeo,
-	.media_changed	= md_media_changed,
-	.revalidate_disk= md_revalidate,
 };
 
 static int md_thread(void * arg)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index e4836c6..3225e25 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -237,7 +237,6 @@ struct mddev_s
 	atomic_t			active;		/* general refcount */
 	atomic_t			openers;	/* number of active opens */
 
-	int				changed;	/* true if we might need to reread partition info */
 	int				degraded;	/* whether md should consider
 							 * adding a spare
 							 */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d63f3ee..d751a5a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2183,7 +2183,6 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	if (mddev->array_sectors > raid1_size(mddev, sectors, 0))
 		return -EINVAL;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
-	mddev->changed = 1;
 	revalidate_disk(mddev->gendisk);
 	if (sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp == MaxSector) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c6ae7c1..231afda 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5335,7 +5335,6 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	    raid5_size(mddev, sectors, mddev->raid_disks))
 		return -EINVAL;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
-	mddev->changed = 1;
 	revalidate_disk(mddev->gendisk);
 	if (sectors > mddev->dev_sectors && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->dev_sectors;
@@ -5549,7 +5548,6 @@ static void raid5_finish_reshape(mddev_t *mddev)
 		if (mddev->delta_disks > 0) {
 			md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 			set_capacity(mddev->gendisk, mddev->array_sectors);
-			mddev->changed = 1;
 			revalidate_disk(mddev->gendisk);
 		} else {
 			int d;


