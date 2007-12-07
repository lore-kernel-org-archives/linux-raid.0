From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 3] md: Update md bitmap during resync.
Date: Fri, 7 Dec 2007 16:42:00 +1100
Message-ID: <1071207054200.7907@suse.de>
References: <20071207163806.7539.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Currently and md array with a write-intent bitmap does not updated
that bitmap to reflect successful partial resync.  Rather the entire
bitmap is updated when the resync completes.

This is because there is no guarentee that resync requests will
complete in order, and tracking each request individually is
unnecessarily burdensome.

However there is value in regularly updating the bitmap, so add code
to periodically pause while all pending sync requests complete, then
update the bitmap.  Doing this only every few seconds (the same as the
bitmap update time) does not notciably affect resync performance.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c         |   34 +++++++++++++++++++++++++++++-----
 ./drivers/md/raid1.c          |    1 +
 ./drivers/md/raid10.c         |    2 ++
 ./drivers/md/raid5.c          |    3 +++
 ./include/linux/raid/bitmap.h |    3 +++
 5 files changed, 38 insertions(+), 5 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2007-12-03 14:58:48.000000000 +1100
+++ ./drivers/md/bitmap.c	2007-12-03 14:59:00.000000000 +1100
@@ -1342,14 +1342,38 @@ void bitmap_close_sync(struct bitmap *bi
 	 */
 	sector_t sector = 0;
 	int blocks;
-	if (!bitmap) return;
+	if (!bitmap)
+		return;
 	while (sector < bitmap->mddev->resync_max_sectors) {
 		bitmap_end_sync(bitmap, sector, &blocks, 0);
-/*
-		if (sector < 500) printk("bitmap_close_sync: sec %llu blks %d\n",
-					 (unsigned long long)sector, blocks);
-*/		sector += blocks;
+		sector += blocks;
+	}
+}
+
+void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
+{
+	sector_t s = 0;
+	int blocks;
+
+	if (!bitmap)
+		return;
+	if (sector == 0) {
+		bitmap->last_end_sync = jiffies;
+		return;
+	}
+	if (time_before(jiffies, (bitmap->last_end_sync
+				  + bitmap->daemon_sleep * HZ)))
+		return;
+	wait_event(bitmap->mddev->recovery_wait,
+		   atomic_read(&bitmap->mddev->recovery_active) == 0);
+
+	sector &= ~((1ULL << CHUNK_BLOCK_SHIFT(bitmap)) - 1);
+	s = 0;
+	while (s < sector && s < bitmap->mddev->resync_max_sectors) {
+		bitmap_end_sync(bitmap, s, &blocks, 0);
+		s += blocks;
 	}
+	bitmap->last_end_sync = jiffies;
 }
 
 static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-12-03 14:58:48.000000000 +1100
+++ ./drivers/md/raid10.c	2007-12-03 14:58:10.000000000 +1100
@@ -1670,6 +1670,8 @@ static sector_t sync_request(mddev_t *md
 	if (!go_faster && conf->nr_waiting)
 		msleep_interruptible(1000);
 
+	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
+
 	/* Again, very different code for resync and recovery.
 	 * Both must result in an r10bio with a list of bios that
 	 * have bi_end_io, bi_sector, bi_bdev set,

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-12-03 14:58:48.000000000 +1100
+++ ./drivers/md/raid1.c	2007-12-03 14:58:10.000000000 +1100
@@ -1684,6 +1684,7 @@ static sector_t sync_request(mddev_t *md
 	if (!go_faster && conf->nr_waiting)
 		msleep_interruptible(1000);
 
+	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
 	raise_barrier(conf);
 
 	conf->next_resync = sector_nr;

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-12-03 14:58:48.000000000 +1100
+++ ./drivers/md/raid5.c	2007-12-03 14:58:10.000000000 +1100
@@ -4333,6 +4333,9 @@ static inline sector_t sync_request(mdde
 		return sync_blocks * STRIPE_SECTORS; /* keep things rounded to whole stripes */
 	}
 
+
+	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
+
 	pd_idx = stripe_to_pdidx(sector_nr, conf, raid_disks);
 
 	sh = wait_for_inactive_cache(conf, sector_nr, raid_disks, pd_idx);

diff .prev/include/linux/raid/bitmap.h ./include/linux/raid/bitmap.h
--- .prev/include/linux/raid/bitmap.h	2007-12-03 14:58:48.000000000 +1100
+++ ./include/linux/raid/bitmap.h	2007-12-03 14:58:10.000000000 +1100
@@ -244,6 +244,8 @@ struct bitmap {
 	 */
 	unsigned long daemon_lastrun; /* jiffies of last run */
 	unsigned long daemon_sleep; /* how many seconds between updates? */
+	unsigned long last_end_sync; /* when we lasted called end_sync to
+				      * update bitmap with resync progress */
 
 	atomic_t pending_writes; /* pending writes to the bitmap file */
 	wait_queue_head_t write_wait;
@@ -275,6 +277,7 @@ void bitmap_endwrite(struct bitmap *bitm
 int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int degraded);
 void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int aborted);
 void bitmap_close_sync(struct bitmap *bitmap);
+void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector);
 
 void bitmap_unplug(struct bitmap *bitmap);
 void bitmap_daemon_work(struct bitmap *bitmap);
