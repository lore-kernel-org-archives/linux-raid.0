From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 3/4] md: improve usefulness and accuracy of sysfs file
	md/sync_completed.
Date: Fri, 17 Apr 2009 12:14:54 +1000
Message-ID: <20090417021453.13390.67267.stgit@notabene.brown>
References: <20090417020953.13390.5371.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090417020953.13390.5371.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

The sync_completed file reports how much of a resync (or recovery or
reshape) has been completed.
However due to the possibility of out-of-order completion of writes,
it is not certain to be accurate.

We have an internal value - mddev->curr_resync_completed - which is an
accurate value (though it might not always be quite so uptodate).

So:
 - make curr_resync_completed be uptodate a little more often,
   particularly when raid5 reshape updates status in the metadata
 - report curr_resync_completed in the sysfs file
 - allow poll/select to report all updates to md/sync_completed.

This makes sync_completed completed usable by any external metadata
handler that wants to record this status information in its metadata.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |    1 +
 drivers/md/md.c     |   34 ++++++++++++++++++++++------------
 drivers/md/raid5.c  |    4 ++++
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index f8a9f7a..e4510c9 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1479,6 +1479,7 @@ void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
 		s += blocks;
 	}
 	bitmap->last_end_sync = jiffies;
+	sysfs_notify(&bitmap->mddev->kobj, NULL, "sync_completed");
 }
 
 static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 298731b..7af64f3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2017,6 +2017,8 @@ repeat:
 	clear_bit(MD_CHANGE_PENDING, &mddev->flags);
 	spin_unlock_irq(&mddev->write_lock);
 	wake_up(&mddev->sb_wait);
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 
 }
 
@@ -3486,12 +3488,15 @@ sync_completed_show(mddev_t *mddev, char *page)
 {
 	unsigned long max_sectors, resync;
 
+	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		return sprintf(page, "none\n");
+
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 		max_sectors = mddev->resync_max_sectors;
 	else
 		max_sectors = mddev->dev_sectors;
 
-	resync = (mddev->curr_resync - atomic_read(&mddev->recovery_active));
+	resync = mddev->curr_resync_completed;
 	return sprintf(page, "%lu / %lu\n", resync, max_sectors);
 }
 
@@ -6338,18 +6343,12 @@ void md_do_sync(mddev_t *mddev)
 		sector_t sectors;
 
 		skipped = 0;
-		if (j >= mddev->resync_max) {
-			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
-			wait_event(mddev->recovery_wait,
-				   mddev->resync_max > j
-				   || kthread_should_stop());
-		}
-		if (kthread_should_stop())
-			goto interrupted;
 
-		if (mddev->curr_resync > mddev->curr_resync_completed &&
-		    (mddev->curr_resync - mddev->curr_resync_completed)
-		    > (max_sectors >> 4)) {
+		if ((mddev->curr_resync > mddev->curr_resync_completed &&
+		     (mddev->curr_resync - mddev->curr_resync_completed)
+		    > (max_sectors >> 4)) ||
+		    j >= mddev->resync_max
+			) {
 			/* time to update curr_resync_completed */
 			blk_unplug(mddev->queue);
 			wait_event(mddev->recovery_wait,
@@ -6357,7 +6356,17 @@ void md_do_sync(mddev_t *mddev)
 			mddev->curr_resync_completed =
 				mddev->curr_resync;
 			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 		}
+
+		if (j >= mddev->resync_max)
+			wait_event(mddev->recovery_wait,
+				   mddev->resync_max > j
+				   || kthread_should_stop());
+
+		if (kthread_should_stop())
+			goto interrupted;
+
 		sectors = mddev->pers->sync_request(mddev, j, &skipped,
 						  currspeed < speed_min(mddev));
 		if (sectors == 0) {
@@ -6465,6 +6474,7 @@ void md_do_sync(mddev_t *mddev)
 
  skip:
 	mddev->curr_resync = 0;
+	mddev->curr_resync_completed = 0;
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	sysfs_notify(&mddev->kobj, NULL, "sync_completed");
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3bbc6d6..76892ac 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3845,6 +3845,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		wait_event(conf->wait_for_overlap,
 			   atomic_read(&conf->reshape_stripes)==0);
 		mddev->reshape_position = conf->reshape_progress;
+		mddev->curr_resync_completed = mddev->curr_resync;
 		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		md_wakeup_thread(mddev->thread);
@@ -3854,6 +3855,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		conf->reshape_safe = mddev->reshape_position;
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_for_overlap);
+		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	}
 
 	if (mddev->delta_disks < 0) {
@@ -3943,6 +3945,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		wait_event(conf->wait_for_overlap,
 			   atomic_read(&conf->reshape_stripes) == 0);
 		mddev->reshape_position = conf->reshape_progress;
+		mddev->curr_resync_completed = mddev->curr_resync;
 		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		md_wakeup_thread(mddev->thread);
@@ -3953,6 +3956,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		conf->reshape_safe = mddev->reshape_position;
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_for_overlap);
+		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	}
 	return reshape_sectors;
 }


