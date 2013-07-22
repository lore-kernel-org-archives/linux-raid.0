From: Robin Dong <robin.k.dong@gmail.com>
Subject: [PATCH 2/2 v2] md: set write-intent bit first in sync-bitmap for rwm in non-insync region.
Date: Mon, 22 Jul 2013 14:07:51 +0800
Message-ID: <1374473271-18551-2-git-send-email-robin.k.dong@gmail.com>
References: <1374473271-18551-1-git-send-email-robin.k.dong@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374473271-18551-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

From: Robin Dong <sanbai@taobao.com>

If part of the RAID456 array is not in sync, then a read-modify-write cycle will
update incorrect parity to new incorrect parity.  If you subsequently get a
drive failure, any data on that drive in the not-in-sync region will be lost.

To avoid this, we:
 1. In first bitmap_endwrite to a not-in-sync region, set the write-intent bit and
    wake up resync thread.
 2. When resync finishes, set the sync bit and clear write-intent bit.

Signed-off-by: Robin Dong <sanbai@taobao.com>
Cc: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/bitmap.h |    2 ++
 drivers/md/raid5.c  |   11 +++++++++++
 3 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 0d894af..b4967c4 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1447,6 +1447,24 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 }
 EXPORT_SYMBOL(bitmap_startwrite);
 
+void syncbitmap_endwrite(struct bitmap *bitmap, sector_t offset,
+		bitmap_counter_t *bmc)
+{
+	struct mddev *mddev = bitmap->mddev;
+
+	if (mddev->level >= 4 &&
+	    offset > mddev->curr_resync_completed) {
+		*bmc |= NEEDED_MASK;
+		if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+			md_wakeup_thread(mddev->sync_thread);
+			sysfs_notify_dirent_safe(mddev->sysfs_action);
+		}
+	} else
+		syncbitmap_file_set_bit(bitmap, offset);
+}
+
 void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors,
 		     int success, int behind)
 {
@@ -1479,7 +1497,8 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 			sysfs_notify_dirent_safe(bitmap->sysfs_can_clear);
 		}
 
-		syncbitmap_file_set_bit(bitmap, offset);
+		if (bitmap->mddev->bitmap_info.sync_bitmap)
+			syncbitmap_endwrite(bitmap, offset, bmc);
 
 		if (!success && !NEEDED(*bmc))
 			*bmc |= NEEDED_MASK;
@@ -1502,6 +1521,36 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 }
 EXPORT_SYMBOL(bitmap_endwrite);
 
+void bitmap_in_synced(struct bitmap *bitmap, sector_t offset,
+				unsigned long sectors)
+{
+	while (sectors) {
+		sector_t blocks;
+		unsigned long flags;
+		bitmap_counter_t *bmc;
+
+		spin_lock_irqsave(&bitmap->counts.lock, flags);
+		bmc = bitmap_get_counter(&bitmap->counts, offset, &blocks, 0);
+		if (!bmc) {
+			spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+			return;
+		}
+
+		if (NEEDED(*bmc) || (!NEEDED(*bmc) && RESYNC(*bmc))) {
+			*bmc &= ~NEEDED_MASK;
+			syncbitmap_file_set_bit(bitmap, offset);
+		}
+
+		spin_unlock_irqrestore(&bitmap->counts.lock, flags);
+		offset += blocks;
+		if (sectors > blocks)
+			sectors -= blocks;
+		else
+			sectors = 0;
+	}
+}
+EXPORT_SYMBOL(bitmap_in_synced);
+
 static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks,
 			       int degraded)
 {
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index ddc30da..6d22d8b 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -253,6 +253,8 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
 			unsigned long sectors, int behind);
 void bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			unsigned long sectors, int success, int behind);
+void bitmap_in_synced(struct bitmap *bitmap, sector_t offset,
+			unsigned long sectors);
 int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int degraded);
 void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted);
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2bf094a..bb7de94 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3622,6 +3622,8 @@ static void handle_stripe(struct stripe_head *sh)
 	if ((s.syncing || s.replacing) && s.locked == 0 &&
 	    test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
+		bitmap_in_synced(conf->mddev->bitmap, sh->sector,
+			STRIPE_SECTORS);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags))
 			wake_up(&conf->wait_for_overlap);
@@ -4690,6 +4692,15 @@ static inline sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int
 		return sync_blocks * STRIPE_SECTORS; /* keep things rounded to whole stripes */
 	}
 
+	if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
+	    conf->fullsync &&
+	    !syncbitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks) &&
+	    sync_blocks >= STRIPE_SECTORS) {
+		sync_blocks /= STRIPE_SECTORS;
+		*skipped = 1;
+		return sync_blocks * STRIPE_SECTORS;
+	}
+
 	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
 
 	sh = get_active_stripe(conf, sector_nr, 0, 1, 0);
-- 
1.7.1

