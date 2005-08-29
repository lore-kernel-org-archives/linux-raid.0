From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 003 of 7] Add write-intent-bitmap support to raid5
Date: Mon, 29 Aug 2005 17:33:39 +1000
Message-ID: <E1E9e9D-0003Wf-CJ@notabene.cse.unsw.edu.au>
References: <20050829172936.12848.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Most awkward part of this is delaying write requests until bitmap
updates have been flushed.
To achieve this, we have a sequence number (seq_flush) which is incremented
each time the raid5 is unplugged.
If the raid thread notices that this has changed, it flushes
bitmap changes, and assigned the value of seq_flush to seq_write.
When a write request arrives, it is given the number from seq_write, and
that write request may not complete until seq_flush is larger than the saved
seq number.

We have a new queue for storing stripes which are waiting for a bitmap
flush and an extra flag for stripes to record if the write was 'degraded'
and so should not clear the a bit in the bitmap.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c            |    3 
 ./drivers/md/raid5.c         |  133 +++++++++++++++++++++++++++++++++++++++----
 ./include/linux/raid/raid5.h |   14 ++++
 3 files changed, 137 insertions(+), 13 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-29 16:32:20.000000000 +1000
+++ ./drivers/md/md.c	2005-08-29 16:32:24.000000000 +1000
@@ -645,7 +645,7 @@ static int super_90_validate(mddev_t *md
 
 		if (sb->state & (1<<MD_SB_BITMAP_PRESENT) &&
 		    mddev->bitmap_file == NULL) {
-			if (mddev->level != 1) {
+			if (mddev->level != 1 && mddev->level != 5) {
 				/* FIXME use a better test */
 				printk(KERN_WARNING "md: bitmaps only support for raid1\n");
 				return -EINVAL;
@@ -3517,7 +3517,6 @@ void md_done_sync(mddev_t *mddev, int bl
  */
 void md_write_start(mddev_t *mddev, struct bio *bi)
 {
-	DEFINE_WAIT(w);
 	if (bio_data_dir(bi) != WRITE)
 		return;
 

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-08-29 16:32:20.000000000 +1000
+++ ./drivers/md/raid5.c	2005-08-29 16:32:24.000000000 +1000
@@ -24,6 +24,8 @@
 #include <linux/bitops.h>
 #include <asm/atomic.h>
 
+#include <linux/raid/bitmap.h>
+
 /*
  * Stripe cache
  */
@@ -79,8 +81,13 @@ static inline void __release_stripe(raid
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
@@ -244,6 +251,9 @@ static struct stripe_head *get_active_st
 	spin_lock_irq(&conf->device_lock);
 
 	do {
+		wait_event_lock_irq(conf->wait_for_stripe,
+				    conf->quiesce == 0,
+				    conf->device_lock, /* nothing */);
 		sh = __find_stripe(conf, sector);
 		if (!sh) {
 			if (!conf->inactive_blocked)
@@ -803,6 +813,7 @@ static int add_stripe_bio(struct stripe_
 {
 	struct bio **bip;
 	raid5_conf_t *conf = sh->raid_conf;
+	int firstwrite=0;
 
 	PRINTK("adding bh b#%llu to stripe s#%llu\n",
 		(unsigned long long)bi->bi_sector,
@@ -811,9 +822,11 @@ static int add_stripe_bio(struct stripe_
 
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
@@ -836,6 +849,13 @@ static int add_stripe_bio(struct stripe_
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
@@ -958,12 +978,13 @@ static void handle_stripe(struct stripe_
 	 * need to be failed
 	 */
 	if (failed > 1 && to_read+to_write+written) {
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
@@ -981,6 +1002,7 @@ static void handle_stripe(struct stripe_
 			/* and fail all 'written' */
 			bi = sh->dev[i].written;
 			sh->dev[i].written = NULL;
+			if (bi) bitmap_end = 1;
 			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS) {
 				struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -1009,8 +1031,11 @@ static void handle_stripe(struct stripe_
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
 	if (failed > 1 && syncing) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
@@ -1038,6 +1063,7 @@ static void handle_stripe(struct stripe_
 			 test_bit(R5_UPTODATE, &dev->flags) ) {
 			/* We can return any write requests */
 			    struct bio *wbi, *wbi2;
+			    int bitmap_end = 0;
 			    PRINTK("Return write for disc %d\n", i);
 			    spin_lock_irq(&conf->device_lock);
 			    wbi = dev->written;
@@ -1051,7 +1077,13 @@ static void handle_stripe(struct stripe_
 				    }
 				    wbi = wbi2;
 			    }
+			    if (dev->towrite == NULL)
+				    bitmap_end = 1;
 			    spin_unlock_irq(&conf->device_lock);
+			    if (bitmap_end)
+				    bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+						    STRIPE_SECTORS,
+						    !test_bit(STRIPE_DEGRADED, &sh->state), 0);
 		    }
 		}
 	}
@@ -1175,7 +1207,8 @@ static void handle_stripe(struct stripe_
 				}
 			}
 		/* now if nothing is locked, and if we have enough data, we can start a write request */
-		if (locked == 0 && (rcw == 0 ||rmw == 0)) {
+		if (locked == 0 && (rcw == 0 ||rmw == 0) &&
+		    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
 			PRINTK("Computing parity...\n");
 			compute_parity(sh, rcw==0 ? RECONSTRUCT_WRITE : READ_MODIFY_WRITE);
 			/* now every locked buffer is ready to be written */
@@ -1231,6 +1264,7 @@ static void handle_stripe(struct stripe_
 			dev = &sh->dev[failed_num];
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantwrite, &dev->flags);
+			clear_bit(STRIPE_DEGRADED, &sh->state);
 			locked++;
 			set_bit(STRIPE_INSYNC, &sh->state);
 			set_bit(R5_Syncio, &dev->flags);
@@ -1298,6 +1332,8 @@ static void handle_stripe(struct stripe_
 			bi->bi_next = NULL;
 			generic_make_request(bi);
 		} else {
+			if (rw == 1)
+				set_bit(STRIPE_DEGRADED, &sh->state);
 			PRINTK("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
@@ -1322,6 +1358,20 @@ static inline void raid5_activate_delaye
 	}
 }
 
+static inline void activate_bit_delay(raid5_conf_t *conf)
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
 	raid5_conf_t *conf = mddev_to_conf(mddev);
@@ -1354,8 +1404,10 @@ static void raid5_unplug_device(request_
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 
-	if (blk_remove_plug(q))
+	if (blk_remove_plug(q)) {
+		conf->seq_flush++;
 		raid5_activate_delayed(conf);
+	}
 	md_wakeup_thread(mddev->thread);
 
 	spin_unlock_irqrestore(&conf->device_lock, flags);
@@ -1493,10 +1545,20 @@ static sector_t sync_request(mddev_t *md
 	sector_t first_sector;
 	int raid_disks = conf->raid_disks;
 	int data_disks = raid_disks-1;
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
 	/* if there is 1 or more failed drives and we are trying
@@ -1508,6 +1570,13 @@ static sector_t sync_request(mddev_t *md
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
@@ -1524,6 +1593,7 @@ static sector_t sync_request(mddev_t *md
 		 */
 		schedule_timeout_uninterruptible(1);
 	}
+	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 0);
 	spin_lock(&sh->lock);	
 	set_bit(STRIPE_SYNCING, &sh->state);
 	clear_bit(STRIPE_INSYNC, &sh->state);
@@ -1557,6 +1627,13 @@ static void raid5d (mddev_t *mddev)
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
@@ -1590,7 +1667,7 @@ static void raid5d (mddev_t *mddev)
 	PRINTK("--- raid5d inactive\n");
 }
 
-static int run (mddev_t *mddev)
+static int run(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
 	int raid_disk, memory;
@@ -1620,6 +1697,7 @@ static int run (mddev_t *mddev)
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
+	INIT_LIST_HEAD(&conf->bitmap_list);
 	INIT_LIST_HEAD(&conf->inactive_list);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
@@ -1731,6 +1809,9 @@ memory = conf->max_nr_stripes * (sizeof(
 
 	/* Ok, everything is just fine now */
 
+	if (mddev->bitmap)
+		mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
+
 	mddev->queue->unplug_fn = raid5_unplug_device;
 	mddev->queue->issue_flush_fn = raid5_issue_flush;
 
@@ -1911,6 +1992,8 @@ static int raid5_add_disk(mddev_t *mddev
 			rdev->in_sync = 0;
 			rdev->raid_disk = disk;
 			found = 1;
+			if (rdev->saved_raid_disk != disk)
+				conf->fullsync = 1;
 			p->rdev = rdev;
 			break;
 		}
@@ -1940,6 +2023,35 @@ static int raid5_resize(mddev_t *mddev, 
 	return 0;
 }
 
+static void raid5_quiesce(mddev_t *mddev, int state)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
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
 static mdk_personality_t raid5_personality=
 {
 	.name		= "raid5",
@@ -1954,6 +2066,7 @@ static mdk_personality_t raid5_personali
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+	.quiesce	= raid5_quiesce,
 };
 
 static int __init raid5_init (void)

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2005-08-29 16:32:20.000000000 +1000
+++ ./include/linux/raid/raid5.h	2005-08-29 16:32:24.000000000 +1000
@@ -134,6 +134,7 @@ struct stripe_head {
 	unsigned long		state;			/* state flags */
 	atomic_t		count;			/* nr of active thread/requests */
 	spinlock_t		lock;
+	int			bm_seq;	/* sequence number for bitmap flushes */
 	struct r5dev {
 		struct bio	req;
 		struct bio_vec	vec;
@@ -165,12 +166,13 @@ struct stripe_head {
 /*
  * Stripe state
  */
-#define STRIPE_ERROR		1
 #define STRIPE_HANDLE		2
 #define	STRIPE_SYNCING		3
 #define	STRIPE_INSYNC		4
 #define	STRIPE_PREREAD_ACTIVE	5
 #define	STRIPE_DELAYED		6
+#define	STRIPE_DEGRADED		7
+#define	STRIPE_BIT_DELAY	8
 
 /*
  * Plugging:
@@ -210,10 +212,20 @@ struct raid5_private_data {
 
 	struct list_head	handle_list; /* stripes needing handling */
 	struct list_head	delayed_list; /* stripes that have plugged requests */
+	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
 	atomic_t		preread_active_stripes; /* stripes with scheduled io */
 
 	char			cache_name[20];
 	kmem_cache_t		*slab_cache; /* for allocating stripes */
+
+	int			seq_flush, seq_write;
+	int			quiesce;
+
+	int			fullsync;  /* set to 1 if a full sync is needed,
+					    * (fresh device added).
+					    * Cleared when a sync completes.
+					    */
+
 	/*
 	 * Free stripes pool
 	 */
