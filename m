From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 004 of 7] write-intent bitmap support for raid6
Date: Mon, 29 Aug 2005 17:33:39 +1000
Message-ID: <E1E9e9D-0003Wj-Ed@notabene.cse.unsw.edu.au>
References: <20050829172936.12848.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a direct port of the raid5 patch.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c        |    2 
 ./drivers/md/raid6main.c |  133 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 124 insertions(+), 11 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-29 16:32:24.000000000 +1000
+++ ./drivers/md/md.c	2005-08-29 16:37:35.000000000 +1000
@@ -645,7 +645,7 @@ static int super_90_validate(mddev_t *md
 
 		if (sb->state & (1<<MD_SB_BITMAP_PRESENT) &&
 		    mddev->bitmap_file == NULL) {
-			if (mddev->level != 1 && mddev->level != 5) {
+			if (mddev->level != 1 && mddev->level != 5 && mddev->level != 6) {
 				/* FIXME use a better test */
 				printk(KERN_WARNING "md: bitmaps only support for raid1\n");
 				return -EINVAL;

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-08-29 16:32:20.000000000 +1000
+++ ./drivers/md/raid6main.c	2005-08-29 16:37:35.000000000 +1000
@@ -29,6 +29,8 @@
 #include <asm/atomic.h>
 #include "raid6.h"
 
+#include <linux/raid/bitmap.h>
+
 /*
  * Stripe cache
  */
@@ -98,8 +100,13 @@ static inline void __release_stripe(raid
 		if (test_bit(STRIPE_HANDLE, &sh->state)) {
 			if (test_bit(STRIPE_DELAYED, &sh->state))
 				list_add_tail(&sh->lru, &conf->delayed_list);
-			else
+			else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
+				 conf->seq_write == sh->bm_seq)
+				list_add_tail(&sh->lru, &conf->bitmap_list);
+			else {
+				clear_bit(STRIPE_BIT_DELAY, &sh->state);
 				list_add_tail(&sh->lru, &conf->handle_list);
+			}
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
 			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
@@ -262,6 +269,9 @@ static struct stripe_head *get_active_st
 	spin_lock_irq(&conf->device_lock);
 
 	do {
+		wait_event_lock_irq(conf->wait_for_stripe,
+				    conf->quiesce == 0,
+				    conf->device_lock, /* nothing */);
 		sh = __find_stripe(conf, sector);
 		if (!sh) {
 			if (!conf->inactive_blocked)
@@ -906,6 +916,7 @@ static int add_stripe_bio(struct stripe_
 {
 	struct bio **bip;
 	raid6_conf_t *conf = sh->raid_conf;
+	int firstwrite=0;
 
 	PRINTK("adding bh b#%llu to stripe s#%llu\n",
 		(unsigned long long)bi->bi_sector,
@@ -914,9 +925,11 @@ static int add_stripe_bio(struct stripe_
 
 	spin_lock(&sh->lock);
 	spin_lock_irq(&conf->device_lock);
-	if (forwrite)
+	if (forwrite) {
 		bip = &sh->dev[dd_idx].towrite;
-	else
+		if (*bip == NULL && sh->dev[dd_idx].written == NULL)
+			firstwrite = 1;
+	} else
 		bip = &sh->dev[dd_idx].toread;
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
 		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
@@ -939,6 +952,13 @@ static int add_stripe_bio(struct stripe_
 		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sh->sector, dd_idx);
 
+	if (conf->mddev->bitmap && firstwrite) {
+		sh->bm_seq = conf->seq_write;
+		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
+				  STRIPE_SECTORS, 0);
+		set_bit(STRIPE_BIT_DELAY, &sh->state);
+	}
+
 	if (forwrite) {
 		/* check if page is covered */
 		sector_t sector = sh->dev[dd_idx].sector;
@@ -1066,12 +1086,13 @@ static void handle_stripe(struct stripe_
 	 * need to be failed
 	 */
 	if (failed > 2 && to_read+to_write+written) {
-		spin_lock_irq(&conf->device_lock);
 		for (i=disks; i--; ) {
+			int bitmap_end = 0;
+			spin_lock_irq(&conf->device_lock);
 			/* fail all writes first */
 			bi = sh->dev[i].towrite;
 			sh->dev[i].towrite = NULL;
-			if (bi) to_write--;
+			if (bi) { to_write--; bitmap_end = 1; }
 
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
@@ -1089,6 +1110,7 @@ static void handle_stripe(struct stripe_
 			/* and fail all 'written' */
 			bi = sh->dev[i].written;
 			sh->dev[i].written = NULL;
+			if (bi) bitmap_end = 1;
 			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS) {
 				struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -1117,8 +1139,11 @@ static void handle_stripe(struct stripe_
 					bi = nextbi;
 				}
 			}
+			spin_unlock_irq(&conf->device_lock);
+			if (bitmap_end)
+				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+						STRIPE_SECTORS, 0, 0);
 		}
-		spin_unlock_irq(&conf->device_lock);
 	}
 	if (failed > 2 && syncing) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
@@ -1155,6 +1180,7 @@ static void handle_stripe(struct stripe_
 				if (!test_bit(R5_LOCKED, &dev->flags) &&
 				    test_bit(R5_UPTODATE, &dev->flags) ) {
 					/* We can return any write requests */
+					int bitmap_end = 0;
 					struct bio *wbi, *wbi2;
 					PRINTK("Return write for stripe %llu disc %d\n",
 					       (unsigned long long)sh->sector, i);
@@ -1170,7 +1196,13 @@ static void handle_stripe(struct stripe_
 						}
 						wbi = wbi2;
 					}
+					if (dev->towrite == NULL)
+						bitmap_end = 1;
 					spin_unlock_irq(&conf->device_lock);
+					if (bitmap_end)
+						bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+								STRIPE_SECTORS,
+								!test_bit(STRIPE_DEGRADED, &sh->state), 0);
 				}
 			}
 	}
@@ -1285,7 +1317,8 @@ static void handle_stripe(struct stripe_
 				}
 			}
 		/* now if nothing is locked, and if we have enough data, we can start a write request */
-		if (locked == 0 && rcw == 0) {
+		if (locked == 0 && rcw == 0 &&
+		    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
 			if ( must_compute > 0 ) {
 				/* We have failed blocks and need to compute them */
 				switch ( failed ) {
@@ -1388,6 +1421,7 @@ static void handle_stripe(struct stripe_
 			bdev = &sh->dev[failed_num[1]];
 			locked += !test_bit(R5_LOCKED, &bdev->flags);
 			set_bit(R5_LOCKED, &bdev->flags);
+			clear_bit(STRIPE_DEGRADED, &sh->state);
 			set_bit(R5_Wantwrite, &bdev->flags);
 
 			set_bit(STRIPE_INSYNC, &sh->state);
@@ -1457,6 +1491,8 @@ static void handle_stripe(struct stripe_
 			bi->bi_next = NULL;
 			generic_make_request(bi);
 		} else {
+			if (rw == 1)
+				set_bit(STRIPE_DEGRADED, &sh->state);
 			PRINTK("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
@@ -1481,6 +1517,20 @@ static inline void raid6_activate_delaye
 	}
 }
 
+static inline void activate_bit_delay(raid6_conf_t *conf)
+{
+	/* device_lock is held */
+	struct list_head head;
+	list_add(&head, &conf->bitmap_list);
+	list_del_init(&conf->bitmap_list);
+	while (!list_empty(&head)) {
+		struct stripe_head *sh = list_entry(head.next, struct stripe_head, lru);
+		list_del_init(&sh->lru);
+		atomic_inc(&sh->count);
+		__release_stripe(conf, sh);
+	}
+}
+
 static void unplug_slaves(mddev_t *mddev)
 {
 	raid6_conf_t *conf = mddev_to_conf(mddev);
@@ -1513,8 +1563,10 @@ static void raid6_unplug_device(request_
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 
-	if (blk_remove_plug(q))
+	if (blk_remove_plug(q)) {
+		conf->seq_flush++;
 		raid6_activate_delayed(conf);
+	}
 	md_wakeup_thread(mddev->thread);
 
 	spin_unlock_irqrestore(&conf->device_lock, flags);
@@ -1652,10 +1704,20 @@ static sector_t sync_request(mddev_t *md
 	sector_t first_sector;
 	int raid_disks = conf->raid_disks;
 	int data_disks = raid_disks - 2;
+	sector_t max_sector = mddev->size << 1;
+	int sync_blocks;
 
-	if (sector_nr >= mddev->size <<1) {
+	if (sector_nr >= max_sector) {
 		/* just being told to finish up .. nothing much to do */
 		unplug_slaves(mddev);
+
+		if (mddev->curr_resync < max_sector) /* aborted */
+			bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
+					&sync_blocks, 1);
+		else /* compelted sync */
+			conf->fullsync = 0;
+		bitmap_close_sync(mddev->bitmap);
+
 		return 0;
 	}
 	/* if there are 2 or more failed drives and we are trying
@@ -1667,6 +1729,13 @@ static sector_t sync_request(mddev_t *md
 		*skipped = 1;
 		return rv;
 	}
+	if (!bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
+	    !conf->fullsync && sync_blocks >= STRIPE_SECTORS) {
+		/* we can skip this block, and probably more */
+		sync_blocks /= STRIPE_SECTORS;
+		*skipped = 1;
+		return sync_blocks * STRIPE_SECTORS; /* keep things rounded to whole stripes */
+	}
 
 	x = sector_nr;
 	chunk_offset = sector_div(x, sectors_per_chunk);
@@ -1683,6 +1752,7 @@ static sector_t sync_request(mddev_t *md
 		 */
 		schedule_timeout_uninterruptible(1);
 	}
+	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 0);
 	spin_lock(&sh->lock);
 	set_bit(STRIPE_SYNCING, &sh->state);
 	clear_bit(STRIPE_INSYNC, &sh->state);
@@ -1716,6 +1786,13 @@ static void raid6d (mddev_t *mddev)
 	while (1) {
 		struct list_head *first;
 
+		if (conf->seq_flush - conf->seq_write > 0) {
+			int seq = conf->seq_flush;
+			bitmap_unplug(mddev->bitmap);
+			conf->seq_write = seq;
+			activate_bit_delay(conf);
+		}
+
 		if (list_empty(&conf->handle_list) &&
 		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
 		    !blk_queue_plugged(mddev->queue) &&
@@ -1749,7 +1826,7 @@ static void raid6d (mddev_t *mddev)
 	PRINTK("--- raid6d inactive\n");
 }
 
-static int run (mddev_t *mddev)
+static int run(mddev_t *mddev)
 {
 	raid6_conf_t *conf;
 	int raid_disk, memory;
@@ -1779,6 +1856,7 @@ static int run (mddev_t *mddev)
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
+	INIT_LIST_HEAD(&conf->bitmap_list);
 	INIT_LIST_HEAD(&conf->inactive_list);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
@@ -1898,6 +1976,9 @@ static int run (mddev_t *mddev)
 	/* Ok, everything is just fine now */
 	mddev->array_size =  mddev->size * (mddev->raid_disks - 2);
 
+	if (mddev->bitmap)
+		mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
+
 	mddev->queue->unplug_fn = raid6_unplug_device;
 	mddev->queue->issue_flush_fn = raid6_issue_flush;
 	return 0;
@@ -2075,6 +2156,8 @@ static int raid6_add_disk(mddev_t *mddev
 			rdev->in_sync = 0;
 			rdev->raid_disk = disk;
 			found = 1;
+			if (rdev->saved_raid_disk != disk)
+				conf->fullsync = 1;
 			p->rdev = rdev;
 			break;
 		}
@@ -2104,6 +2187,35 @@ static int raid6_resize(mddev_t *mddev, 
 	return 0;
 }
 
+static void raid6_quiesce(mddev_t *mddev, int state)
+{
+	raid6_conf_t *conf = mddev_to_conf(mddev);
+
+	switch(state) {
+	case 1: /* stop all writes */
+		spin_lock_irq(&conf->device_lock);
+		conf->quiesce = 1;
+		wait_event_lock_irq(conf->wait_for_stripe,
+				    atomic_read(&conf->active_stripes) == 0,
+				    conf->device_lock, /* nothing */);
+		spin_unlock_irq(&conf->device_lock);
+		break;
+
+	case 0: /* re-enable writes */
+		spin_lock_irq(&conf->device_lock);
+		conf->quiesce = 0;
+		wake_up(&conf->wait_for_stripe);
+		spin_unlock_irq(&conf->device_lock);
+		break;
+	}
+	if (mddev->thread) {
+		if (mddev->bitmap)
+			mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
+		else
+			mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
+		md_wakeup_thread(mddev->thread);
+	}
+}
 static mdk_personality_t raid6_personality=
 {
 	.name		= "raid6",
@@ -2118,6 +2230,7 @@ static mdk_personality_t raid6_personali
 	.spare_active	= raid6_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid6_resize,
+	.quiesce	= raid6_quiesce,
 };
 
 static int __init raid6_init (void)
