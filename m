From: NeilBrown <neilb@suse.de>
Subject: [PATCH 03/18] md: occasionally checkpoint drive recovery to reduce
	duplicate effort after a crash
Date: Thu, 12 Feb 2009 14:10:10 +1100
Message-ID: <20090212031010.23983.74842.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Version 1.x metadata has the ability to record the status of a
partially completed drive recovery.
However we only update that record on a clean shutdown.
It would be nice to update it on unclean shutdowns too, particularly
when using a bitmap that removes much to the 'sync' effort after an
unclean shutdown.

One complication with checkpointing recovery is that we only know
where we are up to in terms of IO requests started, not which ones
have completed.  And we need to know what has completed to record
how much is recovered.  So occasionally pause the recovery until all
submitted requests are completed, then update the record of where
we are up to.

When we have a bitmap, we already do that pause occasionally to keep
the bitmap up-to-date.  So enhance that code to record the recovery
offset and schedule a superblock update.
And when there is no bitmap, just pause 16 times during the resync to
do a checkpoint.
'16' is a fairly arbitrary number.  But we don't really have any good
way to judge how often is acceptable, and it seems like a reasonable
number for now.


Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c       |    2 ++
 drivers/md/md.c           |   26 ++++++++++++++++++++++----
 include/linux/raid/md_k.h |    7 +++++++
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 96a43bd..ff43e4b 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1445,6 +1445,8 @@ void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
 	wait_event(bitmap->mddev->recovery_wait,
 		   atomic_read(&bitmap->mddev->recovery_active) == 0);
 
+	bitmap->mddev->curr_resync_completed = bitmap->mddev->curr_resync;
+	set_bit(MD_CHANGE_CLEAN, &bitmap->mddev->flags);
 	sector &= ~((1ULL << CHUNK_BLOCK_SHIFT(bitmap)) - 1);
 	s = 0;
 	while (s < sector && s < bitmap->mddev->resync_max_sectors) {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4495104..7639c08 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1325,10 +1325,13 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 	}
 
 	if (rdev->raid_disk >= 0 &&
-	    !test_bit(In_sync, &rdev->flags) &&
-	    rdev->recovery_offset > 0) {
-		sb->feature_map |= cpu_to_le32(MD_FEATURE_RECOVERY_OFFSET);
-		sb->recovery_offset = cpu_to_le64(rdev->recovery_offset);
+	    !test_bit(In_sync, &rdev->flags)) {
+		if (mddev->curr_resync_completed > rdev->recovery_offset)
+			rdev->recovery_offset = mddev->curr_resync_completed;
+		if (rdev->recovery_offset > 0) {
+			sb->feature_map |= cpu_to_le32(MD_FEATURE_RECOVERY_OFFSET);
+			sb->recovery_offset = cpu_to_le64(rdev->recovery_offset);
+		}
 	}
 
 	if (mddev->reshape_position != MaxSector) {
@@ -6034,6 +6037,19 @@ void md_do_sync(mddev_t *mddev)
 		}
 		if (kthread_should_stop())
 			goto interrupted;
+
+		if (mddev->curr_resync > mddev->curr_resync_completed &&
+		    (mddev->curr_resync - mddev->curr_resync_completed)
+		    > (max_sectors >> 4)) {
+			/* time to update curr_resync_completed */
+			printk("updating\n");
+			blk_unplug(mddev->queue);
+			wait_event(mddev->recovery_wait,
+				   atomic_read(&mddev->recovery_active) == 0);
+			mddev->curr_resync_completed =
+				mddev->curr_resync;
+			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+		}
 		sectors = mddev->pers->sync_request(mddev, j, &skipped,
 						  currspeed < speed_min(mddev));
 		if (sectors == 0) {
@@ -6167,6 +6183,8 @@ static int remove_and_add_spares(mddev_t *mddev)
 	mdk_rdev_t *rdev;
 	int spares = 0;
 
+	mddev->curr_resync_completed = 0;
+
 	list_for_each_entry(rdev, &mddev->disks, same_set)
 		if (rdev->raid_disk >= 0 &&
 		    !test_bit(Blocked, &rdev->flags) &&
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 9743e4d..92bd993 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -172,6 +172,13 @@ struct mddev_s
 	struct mdk_thread_s		*thread;	/* management thread */
 	struct mdk_thread_s		*sync_thread;	/* doing resync or reconstruct */
 	sector_t			curr_resync;	/* last block scheduled */
+	/* As resync requests can complete out of order, we cannot easily track
+	 * how much resync has been completed.  So we occasionally pause until
+	 * every completes, then set curr_resync_completed to curr_resync.
+	 * As such it may be well behind the real resync mark, but it is a value
+	 * we are certain of.
+	 */
+	sector_t			curr_resync_completed;
 	unsigned long			resync_mark;	/* a recent timestamp */
 	sector_t			resync_mark_cnt;/* blocks written at resync_mark */
 	sector_t			curr_mark_cnt; /* blocks scheduled now */


