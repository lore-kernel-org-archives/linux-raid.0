From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 7] md: Improve the is_mddev_idle test fix
Date: Mon, 21 May 2007 11:33:27 +1000
Message-ID: <1070521013327.6765@suse.de>
References: <20070521111837.20906.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


Don't use 'unsigned' variable to track sync vs non-sync IO, as
the only thing we want to do with them is a signed comparison,
and fix up the comment which had become quite wrong.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   35 ++++++++++++++++++++++-------------
 ./include/linux/raid/md_k.h |    2 +-
 2 files changed, 23 insertions(+), 14 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-05-21 11:17:57.000000000 +1000
+++ ./drivers/md/md.c	2007-05-21 11:18:00.000000000 +1000
@@ -5092,7 +5092,7 @@ static int is_mddev_idle(mddev_t *mddev)
 	mdk_rdev_t * rdev;
 	struct list_head *tmp;
 	int idle;
-	unsigned long curr_events;
+	long curr_events;
 
 	idle = 1;
 	ITERATE_RDEV(mddev,rdev,tmp) {
@@ -5100,20 +5100,29 @@ static int is_mddev_idle(mddev_t *mddev)
 		curr_events = disk_stat_read(disk, sectors[0]) + 
 				disk_stat_read(disk, sectors[1]) - 
 				atomic_read(&disk->sync_io);
-		/* The difference between curr_events and last_events
-		 * will be affected by any new non-sync IO (making
-		 * curr_events bigger) and any difference in the amount of
-		 * in-flight syncio (making current_events bigger or smaller)
-		 * The amount in-flight is currently limited to
-		 * 32*64K in raid1/10 and 256*PAGE_SIZE in raid5/6
-		 * which is at most 4096 sectors.
-		 * These numbers are fairly fragile and should be made
-		 * more robust, probably by enforcing the
-		 * 'window size' that md_do_sync sort-of uses.
+		/* sync IO will cause sync_io to increase before the disk_stats
+		 * as sync_io is counted when a request starts, and
+		 * disk_stats is counted when it completes.
+		 * So resync activity will cause curr_events to be smaller than
+		 * when there was no such activity.
+		 * non-sync IO will cause disk_stat to increase without
+		 * increasing sync_io so curr_events will (eventually)
+		 * be larger than it was before.  Once it becomes
+		 * substantially larger, the test below will cause
+		 * the array to appear non-idle, and resync will slow
+		 * down.
+		 * If there is a lot of outstanding resync activity when
+		 * we set last_event to curr_events, then all that activity
+		 * completing might cause the array to appear non-idle
+		 * and resync will be slowed down even though there might
+		 * not have been non-resync activity.  This will only
+		 * happen once though.  'last_events' will soon reflect
+		 * the state where there is little or no outstanding
+		 * resync requests, and further resync activity will
+		 * always make curr_events less than last_events.
 		 *
-		 * Note: the following is an unsigned comparison.
 		 */
-		if ((long)curr_events - (long)rdev->last_events > 4096) {
+		if (curr_events - rdev->last_events > 4096) {
 			rdev->last_events = curr_events;
 			idle = 0;
 		}

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2007-05-21 11:17:57.000000000 +1000
+++ ./include/linux/raid/md_k.h	2007-05-21 11:18:00.000000000 +1000
@@ -51,7 +51,7 @@ struct mdk_rdev_s
 
 	sector_t size;			/* Device size (in blocks) */
 	mddev_t *mddev;			/* RAID array if running */
-	unsigned long last_events;	/* IO event timestamp */
+	long last_events;		/* IO event timestamp */
 
 	struct block_device *bdev;	/* block device handle */
 
