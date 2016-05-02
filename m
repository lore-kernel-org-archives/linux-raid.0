From: Guoqing Jiang <gqjiang@suse.com>
Subject: [V2 PATCH 09/13] md-cluster: sync bitmap when node received RESYNCING msg
Date: Mon,  2 May 2016 11:50:12 -0400
Message-ID: <1462204216-2269-2-git-send-email-gqjiang@suse.com>
References: <1462203200-1375-1-git-send-email-gqjiang@suse.com>
 <1462204216-2269-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1462204216-2269-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

If the node received RESYNCING message which means
another node will perform resync with the area, then
we don't want to do it again in another node.

Let's set RESYNC_MASK and clear NEEDED_MASK for the
region from old-low to new-low which has finished
syncing, and the region from old-hi to new-hi is about
to syncing, bitmap_sync_with_cluste is introduced for
the purpose.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/bitmap.c     | 21 +++++++++++++++++++++
 drivers/md/bitmap.h     |  3 +++
 drivers/md/md-cluster.c | 27 +++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 431da21..ac93d87 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1597,6 +1597,27 @@ void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
 }
 EXPORT_SYMBOL(bitmap_cond_end_sync);
 
+void bitmap_sync_with_cluster(struct mddev *mddev,
+			      sector_t old_lo, sector_t old_hi,
+			      sector_t new_lo, sector_t new_hi)
+{
+	struct bitmap *bitmap = mddev->bitmap;
+	sector_t sector, blocks = 0;
+
+	for (sector = old_lo; sector < new_lo; ) {
+		bitmap_end_sync(bitmap, sector, &blocks, 0);
+		sector += blocks;
+	}
+	WARN((blocks > new_lo) && old_lo, "alignment is not correct for lo\n");
+
+	for (sector = old_hi; sector < new_hi; ) {
+		bitmap_start_sync(bitmap, sector, &blocks, 0);
+		sector += blocks;
+	}
+	WARN((blocks > new_hi) && old_hi, "alignment is not correct for hi\n");
+}
+EXPORT_SYMBOL(bitmap_sync_with_cluster);
+
 static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed)
 {
 	/* For each chunk covered by any of these sectors, set the
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 5e3fcd6..5b6dd63 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -258,6 +258,9 @@ int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks,
 void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted);
 void bitmap_close_sync(struct bitmap *bitmap);
 void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
+void bitmap_sync_with_cluster(struct mddev *mddev,
+			      sector_t old_lo, sector_t old_hi,
+			      sector_t new_lo, sector_t new_hi);
 
 void bitmap_unplug(struct bitmap *bitmap);
 void bitmap_daemon_work(struct mddev *mddev);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 30f1160..a55b5f4 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -85,6 +85,9 @@ struct md_cluster_info {
 	struct completion newdisk_completion;
 	wait_queue_head_t wait;
 	unsigned long state;
+	/* record the region in RESYNCING message */
+	sector_t sync_low;
+	sector_t sync_hi;
 };
 
 enum msg_type {
@@ -411,6 +414,30 @@ static void process_suspend_info(struct mddev *mddev,
 		md_wakeup_thread(mddev->thread);
 		return;
 	}
+
+	/*
+	 * The bitmaps are not same for different nodes
+	 * if RESYNCING is happening in one node, then
+	 * the node which received the RESYNCING message
+	 * probably will perform resync with the region
+	 * [lo, hi] again, so we could reduce resync time
+	 * a lot if we can ensure that the bitmaps among
+	 * different nodes are match up well.
+	 *
+	 * sync_low/hi is used to record the region which
+	 * arrived in the previous RESYNCING message,
+	 *
+	 * Call bitmap_sync_with_cluster to clear
+	 * NEEDED_MASK and set RESYNC_MASK since
+	 * resync thread is running in another node,
+	 * so we don't need to do the resync again
+	 * with the same section */
+	bitmap_sync_with_cluster(mddev, cinfo->sync_low,
+					cinfo->sync_hi,
+					lo, hi);
+	cinfo->sync_low = lo;
+	cinfo->sync_hi = hi;
+
 	s = kzalloc(sizeof(struct suspend_info), GFP_KERNEL);
 	if (!s)
 		return;
-- 
2.6.6

