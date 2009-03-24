From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 3/6] md: add explicit method to signal the end of a reshape.
Date: Tue, 24 Mar 2009 19:53:32 +1100
Message-ID: <20090324085332.15383.25619.stgit@notabene.brown>
References: <20090324084629.15383.10271.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090324084629.15383.10271.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Currently raid5 (the only module that supports restriping)
notices that the reshape has finished be sync_request being
given a large value, and handles any cleanup them.

This patch changes it so md_check_recovery calls into an
explicit finish_reshape method instead.

The key difference is that this method is called with the
device lock held so finish_reshape is free to make config changes.
This means we can remove the slightly-ugly
md_set_array_sectors_locked, and it means that when raid5 finishes
a reshape that reduces the number of devices, it is free to
remove devices from the array (which requires a lock).

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c    |   11 +++--------
 drivers/md/md.h    |    2 +-
 drivers/md/raid5.c |   32 +++++++++++++++-----------------
 3 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 923d125..c509313 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5073,14 +5073,6 @@ void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors)
 }
 EXPORT_SYMBOL(md_set_array_sectors);
 
-void md_set_array_sectors_lock(mddev_t *mddev, sector_t array_sectors)
-{
-	mddev_lock(mddev);
-	md_set_array_sectors(mddev, array_sectors);
-	mddev_unlock(mddev);
-}
-EXPORT_SYMBOL(md_set_array_sectors_lock);
-
 static int update_size(mddev_t *mddev, sector_t num_sectors)
 {
 	mdk_rdev_t *rdev;
@@ -6641,6 +6633,9 @@ void md_check_recovery(mddev_t *mddev)
 					sysfs_notify(&mddev->kobj, NULL,
 						     "degraded");
 			}
+			if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+			    mddev->pers->finish_reshape)
+				mddev->pers->finish_reshape(mddev);
 			md_update_sb(mddev, 1);
 
 			/* if array is no-longer degraded, then any saved_raid_disk
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 614329d..50b7fc3 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -316,6 +316,7 @@ struct mdk_personality
 	sector_t (*size) (mddev_t *mddev, sector_t sectors, int raid_disks);
 	int (*check_reshape) (mddev_t *mddev);
 	int (*start_reshape) (mddev_t *mddev);
+	void (*finish_reshape) (mddev_t *mddev);
 	int (*reconfig) (mddev_t *mddev, int layout, int chunk_size);
 	/* quiesce moves between quiescence states
 	 * 0 - fully active
@@ -432,4 +433,3 @@ extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
-extern void md_set_array_sectors_lock(mddev_t *mddev, sector_t array_sectors);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 74e89c1..163e5fc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1979,8 +1979,6 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	return 0;
 }
 
-static void end_reshape(raid5_conf_t *conf);
-
 static int page_is_zero(struct page *p)
 {
 	char *a = page_address(p);
@@ -3850,10 +3848,6 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 	if (sector_nr >= max_sector) {
 		/* just being told to finish up .. nothing much to do */
 		unplug_slaves(mddev);
-		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
-			end_reshape(conf);
-			return 0;
-		}
 
 		if (mddev->curr_resync < max_sector) /* aborted */
 			bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
@@ -4833,30 +4827,30 @@ static int raid5_start_reshape(mddev_t *mddev)
 }
 #endif
 
-static void end_reshape(raid5_conf_t *conf)
+static void raid5_finish_reshape(mddev_t *mddev)
 {
 	struct block_device *bdev;
+	raid5_conf_t *conf = mddev_to_conf(mddev);
 
-	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
-		mddev_t *mddev = conf->mddev;
+	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 
-		md_set_array_sectors_lock(mddev, raid5_size(mddev, 0, conf->raid_disks));
+		conf->previous_raid_disks = conf->raid_disks;
+		md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 		set_capacity(mddev->gendisk, mddev->array_sectors);
 		mddev->changed = 1;
-		conf->previous_raid_disks = conf->raid_disks;
 
-		bdev = bdget_disk(conf->mddev->gendisk, 0);
+		bdev = bdget_disk(mddev->gendisk, 0);
 		if (bdev) {
 			mutex_lock(&bdev->bd_inode->i_mutex);
 			i_size_write(bdev->bd_inode,
-				     (loff_t)conf->mddev->array_sectors << 9);
+				     (loff_t)mddev->array_sectors << 9);
 			mutex_unlock(&bdev->bd_inode->i_mutex);
 			bdput(bdev);
 		}
 		spin_lock_irq(&conf->device_lock);
 		conf->expand_progress = MaxSector;
 		spin_unlock_irq(&conf->device_lock);
-		conf->mddev->reshape_position = MaxSector;
+		mddev->reshape_position = MaxSector;
 
 		/* read-ahead size must cover two whole stripes, which is
 		 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices
@@ -4864,9 +4858,10 @@ static void end_reshape(raid5_conf_t *conf)
 		{
 			int data_disks = conf->previous_raid_disks - conf->max_degraded;
 			int stripe = data_disks *
-				(conf->mddev->chunk_size / PAGE_SIZE);
-			if (conf->mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
-				conf->mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
+				(mddev->chunk_size / PAGE_SIZE);
+			if (mddev->queue->backing_dev_info.ra_pages < 2*stripe)
+				mddev->queue->backing_dev_info.ra_pages
+					= 2 * stripe;
 		}
 	}
 }
@@ -5096,6 +5091,7 @@ static struct mdk_personality raid6_personality =
 #ifdef CONFIG_MD_RAID5_RESHAPE
 	.check_reshape	= raid5_check_reshape,
 	.start_reshape  = raid5_start_reshape,
+	.finish_reshape = raid5_finish_reshape,
 #endif
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid6_takeover,
@@ -5119,6 +5115,7 @@ static struct mdk_personality raid5_personality =
 #ifdef CONFIG_MD_RAID5_RESHAPE
 	.check_reshape	= raid5_check_reshape,
 	.start_reshape  = raid5_start_reshape,
+	.finish_reshape = raid5_finish_reshape,
 #endif
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid5_takeover,
@@ -5144,6 +5141,7 @@ static struct mdk_personality raid4_personality =
 #ifdef CONFIG_MD_RAID5_RESHAPE
 	.check_reshape	= raid5_check_reshape,
 	.start_reshape  = raid5_start_reshape,
+	.finish_reshape = raid5_finish_reshape,
 #endif
 	.quiesce	= raid5_quiesce,
 };


