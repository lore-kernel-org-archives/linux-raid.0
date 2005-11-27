From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 011 of 18] Write intent bitmap support for raid10
Date: Mon, 28 Nov 2005 10:40:32 +1100
Message-ID: <1051127234032.14865@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c             |   10 +-
 ./drivers/md/raid10.c         |  178 +++++++++++++++++++++++++++++++++++++-----
 ./include/linux/raid/raid10.h |    9 +-
 3 files changed, 171 insertions(+), 26 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-28 10:12:40.000000000 +1100
+++ ./drivers/md/md.c	2005-11-28 10:12:52.000000000 +1100
@@ -714,9 +714,10 @@ static int super_90_validate(mddev_t *md
 
 		if (sb->state & (1<<MD_SB_BITMAP_PRESENT) &&
 		    mddev->bitmap_file == NULL) {
-			if (mddev->level != 1 && mddev->level != 5 && mddev->level != 6) {
+			if (mddev->level != 1 && mddev->level != 5 && mddev->level != 6
+			    && mddev->level != 10) {
 				/* FIXME use a better test */
-				printk(KERN_WARNING "md: bitmaps only support for raid1\n");
+				printk(KERN_WARNING "md: bitmaps not supported for this level.\n");
 				return -EINVAL;
 			}
 			mddev->bitmap_offset = mddev->default_bitmap_offset;
@@ -1037,8 +1038,9 @@ static int super_1_validate(mddev_t *mdd
 
 		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) &&
 		    mddev->bitmap_file == NULL ) {
-			if (mddev->level != 1) {
-				printk(KERN_WARNING "md: bitmaps only supported for raid1\n");
+			if (mddev->level != 1 && mddev->level != 5 && mddev->level != 6
+			    && mddev->level != 10) {
+				printk(KERN_WARNING "md: bitmaps not supported for this level.\n");
 				return -EINVAL;
 			}
 			mddev->bitmap_offset = (__s32)le32_to_cpu(sb->bitmap_offset);

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-11-28 10:12:24.000000000 +1100
+++ ./drivers/md/raid10.c	2005-11-28 10:12:52.000000000 +1100
@@ -18,7 +18,9 @@
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "dm-bio-list.h"
 #include <linux/raid/raid10.h>
+#include <linux/raid/bitmap.h>
 
 /*
  * RAID10 provides a combination of RAID0 and RAID1 functionality.
@@ -306,9 +308,11 @@ static int raid10_end_write_request(stru
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate)
+	if (!uptodate) {
 		md_error(r10_bio->mddev, conf->mirrors[dev].rdev);
-	else
+		/* an I/O failed, we can't clear the bitmap */
+		set_bit(R10BIO_Degraded, &r10_bio->state);
+	} else
 		/*
 		 * Set R10BIO_Uptodate in our master bio, so that
 		 * we will return a good error code for to the higher
@@ -328,6 +332,11 @@ static int raid10_end_write_request(stru
 	 * already.
 	 */
 	if (atomic_dec_and_test(&r10_bio->remaining)) {
+		/* clear the bitmap if all writes complete successfully */
+		bitmap_endwrite(r10_bio->mddev->bitmap, r10_bio->sector,
+				r10_bio->sectors,
+				!test_bit(R10BIO_Degraded, &r10_bio->state),
+				0);
 		md_write_end(r10_bio->mddev);
 		raid_end_bio_io(r10_bio);
 	}
@@ -486,8 +495,9 @@ static int read_balance(conf_t *conf, r1
 	rcu_read_lock();
 	/*
 	 * Check if we can balance. We can balance on the whole
-	 * device if no resync is going on, or below the resync window.
-	 * We take the first readable disk when above the resync window.
+	 * device if no resync is going on (recovery is ok), or below
+	 * the resync window. We take the first readable disk when
+	 * above the resync window.
 	 */
 	if (conf->mddev->recovery_cp < MaxSector
 	    && (this_sector + sectors >= conf->next_resync)) {
@@ -591,7 +601,10 @@ static void unplug_slaves(mddev_t *mddev
 
 static void raid10_unplug(request_queue_t *q)
 {
+	mddev_t *mddev = q->queuedata;
+
 	unplug_slaves(q->queuedata);
+	md_wakeup_thread(mddev->thread);
 }
 
 static int raid10_issue_flush(request_queue_t *q, struct gendisk *disk,
@@ -647,12 +660,13 @@ static int raid10_issue_flush(request_qu
  */
 #define RESYNC_DEPTH 32
 
-static void raise_barrier(conf_t *conf)
+static void raise_barrier(conf_t *conf, int force)
 {
+	BUG_ON(force && !conf->barrier);
 	spin_lock_irq(&conf->resync_lock);
 
-	/* Wait until no block IO is waiting */
-	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting,
+	/* Wait until no block IO is waiting (unless 'force') */
+	wait_event_lock_irq(conf->wait_barrier, force || !conf->nr_waiting,
 			    conf->resync_lock,
 			    raid10_unplug(conf->mddev->queue));
 
@@ -710,6 +724,8 @@ static int make_request(request_queue_t 
 	int i;
 	int chunk_sects = conf->chunk_mask + 1;
 	const int rw = bio_data_dir(bio);
+	struct bio_list bl;
+	unsigned long flags;
 
 	if (unlikely(bio_barrier(bio))) {
 		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
@@ -767,6 +783,7 @@ static int make_request(request_queue_t 
 
 	r10_bio->mddev = mddev;
 	r10_bio->sector = bio->bi_sector;
+	r10_bio->state = 0;
 
 	if (rw == READ) {
 		/*
@@ -811,13 +828,16 @@ static int make_request(request_queue_t 
 		    !test_bit(Faulty, &rdev->flags)) {
 			atomic_inc(&rdev->nr_pending);
 			r10_bio->devs[i].bio = bio;
-		} else
+		} else {
 			r10_bio->devs[i].bio = NULL;
+			set_bit(R10BIO_Degraded, &r10_bio->state);
+		}
 	}
 	rcu_read_unlock();
 
-	atomic_set(&r10_bio->remaining, 1);
+	atomic_set(&r10_bio->remaining, 0);
 
+	bio_list_init(&bl);
 	for (i = 0; i < conf->copies; i++) {
 		struct bio *mbio;
 		int d = r10_bio->devs[i].devnum;
@@ -835,13 +855,14 @@ static int make_request(request_queue_t 
 		mbio->bi_private = r10_bio;
 
 		atomic_inc(&r10_bio->remaining);
-		generic_make_request(mbio);
+		bio_list_add(&bl, mbio);
 	}
 
-	if (atomic_dec_and_test(&r10_bio->remaining)) {
-		md_write_end(mddev);
-		raid_end_bio_io(r10_bio);
-	}
+	bitmap_startwrite(mddev->bitmap, bio->bi_sector, r10_bio->sectors, 0);
+	spin_lock_irqsave(&conf->device_lock, flags);
+	bio_list_merge(&conf->pending_bio_list, &bl);
+	blk_plug_device(mddev->queue);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	return 0;
 }
@@ -999,7 +1020,12 @@ static int raid10_add_disk(mddev_t *mdde
 	if (!enough(conf))
 		return 0;
 
-	for (mirror=0; mirror < mddev->raid_disks; mirror++)
+	if (rdev->saved_raid_disk >= 0 &&
+	    conf->mirrors[rdev->saved_raid_disk].rdev == NULL)
+		mirror = rdev->saved_raid_disk;
+	else
+		mirror = 0;
+	for ( ; mirror < mddev->raid_disks; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
 			blk_queue_stack_limits(mddev->queue,
@@ -1015,6 +1041,8 @@ static int raid10_add_disk(mddev_t *mdde
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
 			found = 1;
+			if (rdev->saved_raid_disk != mirror)
+				conf->fullsync = 1;
 			rcu_assign_pointer(p->rdev, rdev);
 			break;
 		}
@@ -1282,6 +1310,26 @@ static void raid10d(mddev_t *mddev)
 	for (;;) {
 		char b[BDEVNAME_SIZE];
 		spin_lock_irqsave(&conf->device_lock, flags);
+
+		if (conf->pending_bio_list.head) {
+			bio = bio_list_get(&conf->pending_bio_list);
+			blk_remove_plug(mddev->queue);
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			/* flush any pending bitmap writes to disk before proceeding w/ I/O */
+			if (bitmap_unplug(mddev->bitmap) != 0)
+				printk("%s: bitmap file write failed!\n", mdname(mddev));
+
+			while (bio) { /* submit pending writes */
+				struct bio *next = bio->bi_next;
+				bio->bi_next = NULL;
+				generic_make_request(bio);
+				bio = next;
+			}
+			unplug = 1;
+
+			continue;
+		}
+
 		if (list_empty(head))
 			break;
 		r10_bio = list_entry(head->prev, r10bio_t, retry_list);
@@ -1388,6 +1436,8 @@ static sector_t sync_request(mddev_t *md
 	sector_t max_sector, nr_sectors;
 	int disk;
 	int i;
+	int max_sync;
+	int sync_blocks;
 
 	sector_t sectors_skipped = 0;
 	int chunks_skipped = 0;
@@ -1401,6 +1451,29 @@ static sector_t sync_request(mddev_t *md
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 		max_sector = mddev->resync_max_sectors;
 	if (sector_nr >= max_sector) {
+		/* If we aborted, we need to abort the
+		 * sync on the 'current' bitmap chucks (there can
+		 * be several when recovering multiple devices).
+		 * as we may have started syncing it but not finished.
+		 * We can find the current address in
+		 * mddev->curr_resync, but for recovery,
+		 * we need to convert that to several
+		 * virtual addresses.
+		 */
+		if (mddev->curr_resync < max_sector) { /* aborted */
+			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+				bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
+						&sync_blocks, 1);
+			else for (i=0; i<conf->raid_disks; i++) {
+				sector_t sect =
+					raid10_find_virt(conf, mddev->curr_resync, i);
+				bitmap_end_sync(mddev->bitmap, sect,
+						&sync_blocks, 1);
+			}
+		} else /* completed sync */
+			conf->fullsync = 0;
+
+		bitmap_close_sync(mddev->bitmap);
 		close_sync(conf);
 		*skipped = 1;
 		return sectors_skipped;
@@ -1425,8 +1498,6 @@ static sector_t sync_request(mddev_t *md
 	 */
 	if (!go_faster && conf->nr_waiting)
 		msleep_interruptible(1000);
-	raise_barrier(conf);
-	conf->next_resync = sector_nr;
 
 	/* Again, very different code for resync and recovery.
 	 * Both must result in an r10bio with a list of bios that
@@ -1443,6 +1514,7 @@ static sector_t sync_request(mddev_t *md
 	 * end_sync_write if we will want to write.
 	 */
 
+	max_sync = RESYNC_PAGES << (PAGE_SHIFT-9);
 	if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 		/* recovery... the complicated one */
 		int i, j, k;
@@ -1451,13 +1523,29 @@ static sector_t sync_request(mddev_t *md
 		for (i=0 ; i<conf->raid_disks; i++)
 			if (conf->mirrors[i].rdev &&
 			    !test_bit(In_sync, &conf->mirrors[i].rdev->flags)) {
+				int still_degraded = 0;
 				/* want to reconstruct this device */
 				r10bio_t *rb2 = r10_bio;
+				sector_t sect = raid10_find_virt(conf, sector_nr, i);
+				int must_sync;
+				/* Unless we are doing a full sync, we only need
+				 * to recover the block if it is set in the bitmap
+				 */
+				must_sync = bitmap_start_sync(mddev->bitmap, sect,
+							      &sync_blocks, 1);
+				if (sync_blocks < max_sync)
+					max_sync = sync_blocks;
+				if (!must_sync &&
+				    !conf->fullsync) {
+					/* yep, skip the sync_blocks here, but don't assume
+					 * that there will never be anything to do here
+					 */
+					chunks_skipped = -1;
+					continue;
+				}
 
 				r10_bio = mempool_alloc(conf->r10buf_pool, GFP_NOIO);
-				spin_lock_irq(&conf->resync_lock);
-				if (rb2) conf->barrier++;
-				spin_unlock_irq(&conf->resync_lock);
+				raise_barrier(conf, rb2 != NULL);
 				atomic_set(&r10_bio->remaining, 0);
 
 				r10_bio->master_bio = (struct bio*)rb2;
@@ -1465,8 +1553,21 @@ static sector_t sync_request(mddev_t *md
 					atomic_inc(&rb2->remaining);
 				r10_bio->mddev = mddev;
 				set_bit(R10BIO_IsRecover, &r10_bio->state);
-				r10_bio->sector = raid10_find_virt(conf, sector_nr, i);
+				r10_bio->sector = sect;
+
 				raid10_find_phys(conf, r10_bio);
+				/* Need to check if this section will still be
+				 * degraded
+				 */
+				for (j=0; j<conf->copies;j++) {
+					int d = r10_bio->devs[j].devnum;
+					if (conf->mirrors[d].rdev == NULL ||
+					    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
+						still_degraded = 1;
+				}
+				must_sync = bitmap_start_sync(mddev->bitmap, sect,
+							      &sync_blocks, still_degraded);
+
 				for (j=0; j<conf->copies;j++) {
 					int d = r10_bio->devs[j].devnum;
 					if (conf->mirrors[d].rdev &&
@@ -1526,10 +1627,22 @@ static sector_t sync_request(mddev_t *md
 	} else {
 		/* resync. Schedule a read for every block at this virt offset */
 		int count = 0;
+
+		if (!bitmap_start_sync(mddev->bitmap, sector_nr,
+				       &sync_blocks, mddev->degraded) &&
+		    !conf->fullsync && !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+			/* We can skip this block */
+			*skipped = 1;
+			return sync_blocks + sectors_skipped;
+		}
+		if (sync_blocks < max_sync)
+			max_sync = sync_blocks;
 		r10_bio = mempool_alloc(conf->r10buf_pool, GFP_NOIO);
 
 		r10_bio->mddev = mddev;
 		atomic_set(&r10_bio->remaining, 0);
+		raise_barrier(conf, 0);
+		conf->next_resync = sector_nr;
 
 		r10_bio->master_bio = NULL;
 		r10_bio->sector = sector_nr;
@@ -1582,6 +1695,8 @@ static sector_t sync_request(mddev_t *md
 	}
 
 	nr_sectors = 0;
+	if (sector_nr + max_sync < max_sector)
+		max_sector = sector_nr + max_sync;
 	do {
 		struct page *page;
 		int len = PAGE_SIZE;
@@ -1821,6 +1936,26 @@ static int stop(mddev_t *mddev)
 	return 0;
 }
 
+static void raid10_quiesce(mddev_t *mddev, int state)
+{
+	conf_t *conf = mddev_to_conf(mddev);
+
+	switch(state) {
+	case 1:
+		raise_barrier(conf, 0);
+		break;
+	case 0:
+		lower_barrier(conf);
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
 
 static mdk_personality_t raid10_personality =
 {
@@ -1835,6 +1970,7 @@ static mdk_personality_t raid10_personal
 	.hot_remove_disk= raid10_remove_disk,
 	.spare_active	= raid10_spare_active,
 	.sync_request	= sync_request,
+	.quiesce	= raid10_quiesce,
 };
 
 static int __init raid_init(void)

diff ./include/linux/raid/raid10.h~current~ ./include/linux/raid/raid10.h
--- ./include/linux/raid/raid10.h~current~	2005-11-28 10:12:24.000000000 +1100
+++ ./include/linux/raid/raid10.h	2005-11-28 10:12:52.000000000 +1100
@@ -35,13 +35,19 @@ struct r10_private_data_s {
 	sector_t chunk_mask;
 
 	struct list_head	retry_list;
-	/* for use when syncing mirrors: */
+	/* queue pending writes and submit them on unplug */
+	struct bio_list		pending_bio_list;
+
 
 	spinlock_t		resync_lock;
 	int nr_pending;
 	int nr_waiting;
 	int barrier;
 	sector_t		next_resync;
+	int			fullsync;  /* set to 1 if a full sync is needed,
+					    * (fresh device added).
+					    * Cleared when a sync completes.
+					    */
 
 	wait_queue_head_t	wait_barrier;
 
@@ -100,4 +106,5 @@ struct r10bio_s {
 #define	R10BIO_Uptodate	0
 #define	R10BIO_IsSync	1
 #define	R10BIO_IsRecover 2
+#define	R10BIO_Degraded 3
 #endif
