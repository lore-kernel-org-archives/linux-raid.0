From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 008 of 8] Support BIO_RW_BARRIER for md/raid1.
Date: Fri, 14 Oct 2005 12:26:35 +1000
Message-ID: <1051014022635.11862@suse.de>
References: <20051014122335.11602.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


We can only accept BARRIER requests if all slaves handle
barriers, and that can, of course, change with time....

So we keep track of whether the whole array seems safe for barriers,
and also whether each individual rdev handles barriers.

We initially assumes barriers are OK.

When writing the superblock we try a barrier, and if that fails, we flag
things for no-barriers.  This will usually clear the flags fairly quickly.

If writing the superblock finds that BIO_RW_BARRIER is -ENOTSUPP, we need to
resubmit, so introduce function "md_super_wait" which waits for requests
to finish, and retries ENOTSUPP requests without the barrier flag.

When writing the real raid1, write requests which were BIO_RW_BARRIER but
which aresn't supported need to be retried.  So raid1d is enhanced to do this,
and when any bio write completes (i.e. no retry needed) we remove it from
the r1bio, so that devices needing retry are easy to find.

We should hardly ever get -ENOTSUPP errors when writing data to the raid.
It should only happen if:
  1/ the device used to support BARRIER, but now doesn't.  Few devices 
     change like this, though raid1 can!
or
  2/ the array has no persistent superblock, so there was no opportunity to 
     pre-test for barriers when writing the superblock.
  

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c        |    5 -
 ./drivers/md/md.c            |   99 +++++++++++++++++++++++++++-----
 ./drivers/md/raid1.c         |  130 +++++++++++++++++++++++++++++--------------
 ./include/linux/raid/md.h    |    1 
 ./include/linux/raid/md_k.h  |    8 ++
 ./include/linux/raid/raid1.h |    4 -
 6 files changed, 187 insertions(+), 60 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-10-14 12:18:21.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-10-14 12:19:23.000000000 +1000
@@ -302,7 +302,7 @@ static int write_sb_page(mddev_t *mddev,
 				       page);
 
 	if (wait)
-		wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
+		md_super_wait(mddev);
 	return 0;
 }
 
@@ -829,8 +829,7 @@ int bitmap_unplug(struct bitmap *bitmap)
 					    wake_up_process(bitmap->writeback_daemon->tsk));
 			spin_unlock_irq(&bitmap->write_lock);
 		} else
-			wait_event(bitmap->mddev->sb_wait,
-				   atomic_read(&bitmap->mddev->pending_writes)==0);
+			md_super_wait(bitmap->mddev);
 	}
 	return 0;
 }

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-14 12:18:21.000000000 +1000
+++ ./drivers/md/md.c	2005-10-14 12:19:23.000000000 +1000
@@ -330,18 +330,46 @@ static void free_disk_sb(mdk_rdev_t * rd
 static int super_written(struct bio *bio, unsigned int bytes_done, int error)
 {
 	mdk_rdev_t *rdev = bio->bi_private;
+	mddev_t *mddev = rdev->mddev;
 	if (bio->bi_size)
 		return 1;
 
 	if (error || !test_bit(BIO_UPTODATE, &bio->bi_flags))
-		md_error(rdev->mddev, rdev);
+		md_error(mddev, rdev);
 
-	if (atomic_dec_and_test(&rdev->mddev->pending_writes))
-		wake_up(&rdev->mddev->sb_wait);
+	if (atomic_dec_and_test(&mddev->pending_writes))
+		wake_up(&mddev->sb_wait);
 	bio_put(bio);
 	return 0;
 }
 
+static int super_written_barrier(struct bio *bio, unsigned int bytes_done, int error)
+{
+	struct bio *bio2 = bio->bi_private;
+	mdk_rdev_t *rdev = bio2->bi_private;
+	mddev_t *mddev = rdev->mddev;
+	if (bio->bi_size)
+		return 1;
+
+	if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
+	    error == -EOPNOTSUPP) {
+		unsigned long flags;
+		/* barriers don't appear to be supported :-( */
+		set_bit(BarriersNotsupp, &rdev->flags);
+		mddev->barriers_work = 0;
+		spin_lock_irqsave(&mddev->write_lock, flags);
+		bio2->bi_next = mddev->biolist;
+		mddev->biolist = bio2;
+		spin_unlock_irqrestore(&mddev->write_lock, flags);
+		wake_up(&mddev->sb_wait);
+		bio_put(bio);
+		return 0;
+	}
+	bio_put(bio2);
+	bio->bi_private = rdev;
+	return super_written(bio, bytes_done, error);
+}
+
 void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 		   sector_t sector, int size, struct page *page)
 {
@@ -350,16 +378,54 @@ void md_super_write(mddev_t *mddev, mdk_
 	 * and decrement it on completion, waking up sb_wait
 	 * if zero is reached.
 	 * If an error occurred, call md_error
+	 *
+	 * As we might need to resubmit the request if BIO_RW_BARRIER
+	 * causes ENOTSUPP, we allocate a spare bio...
 	 */
 	struct bio *bio = bio_alloc(GFP_NOIO, 1);
+	int rw = (1<<BIO_RW) | (1<<BIO_RW_SYNC);
 
 	bio->bi_bdev = rdev->bdev;
 	bio->bi_sector = sector;
 	bio_add_page(bio, page, size, 0);
 	bio->bi_private = rdev;
 	bio->bi_end_io = super_written;
+	bio->bi_rw = rw;
+
 	atomic_inc(&mddev->pending_writes);
-	submit_bio((1<<BIO_RW)|(1<<BIO_RW_SYNC), bio);
+	if (!test_bit(BarriersNotsupp, &rdev->flags)) {
+		struct bio *rbio;
+		rw |= (1<<BIO_RW_BARRIER);
+		rbio = bio_clone(bio, GFP_NOIO);
+		rbio->bi_private = bio;
+		rbio->bi_end_io = super_written_barrier;
+		submit_bio(rw, rbio);
+	} else
+		submit_bio(rw, bio);
+}
+
+void md_super_wait(mddev_t *mddev)
+{
+	/* wait for all superblock writes that were scheduled to complete.
+	 * if any had to be retried (due to BARRIER problems), retry them
+	 */
+	DEFINE_WAIT(wq);
+	for(;;) {
+		prepare_to_wait(&mddev->sb_wait, &wq, TASK_UNINTERRUPTIBLE);
+		if (atomic_read(&mddev->pending_writes)==0)
+			break;
+		while (mddev->biolist) {
+			struct bio *bio;
+			spin_lock_irq(&mddev->write_lock);
+			bio = mddev->biolist;
+			mddev->biolist = bio->bi_next ;
+			bio->bi_next = NULL;
+			spin_unlock_irq(&mddev->write_lock);
+			submit_bio(bio->bi_rw, bio);
+		}
+		schedule();
+	}
+	finish_wait(&mddev->sb_wait, &wq);
 }
 
 static int bi_complete(struct bio *bio, unsigned int bytes_done, int error)
@@ -1382,7 +1448,7 @@ static void md_update_sb(mddev_t * mddev
 	int sync_req;
 
 repeat:
-	spin_lock(&mddev->write_lock);
+	spin_lock_irq(&mddev->write_lock);
 	sync_req = mddev->in_sync;
 	mddev->utime = get_seconds();
 	mddev->events ++;
@@ -1405,11 +1471,11 @@ repeat:
 	 */
 	if (!mddev->persistent) {
 		mddev->sb_dirty = 0;
-		spin_unlock(&mddev->write_lock);
+		spin_unlock_irq(&mddev->write_lock);
 		wake_up(&mddev->sb_wait);
 		return;
 	}
-	spin_unlock(&mddev->write_lock);
+	spin_unlock_irq(&mddev->write_lock);
 
 	dprintk(KERN_INFO 
 		"md: updating %s RAID superblock on device (in sync %d)\n",
@@ -1437,17 +1503,17 @@ repeat:
 			/* only need to write one superblock... */
 			break;
 	}
-	wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
+	md_super_wait(mddev);
 	/* if there was a failure, sb_dirty was set to 1, and we re-write super */
 
-	spin_lock(&mddev->write_lock);
+	spin_lock_irq(&mddev->write_lock);
 	if (mddev->in_sync != sync_req|| mddev->sb_dirty == 1) {
 		/* have to write it out again */
-		spin_unlock(&mddev->write_lock);
+		spin_unlock_irq(&mddev->write_lock);
 		goto repeat;
 	}
 	mddev->sb_dirty = 0;
-	spin_unlock(&mddev->write_lock);
+	spin_unlock_irq(&mddev->write_lock);
 	wake_up(&mddev->sb_wait);
 
 }
@@ -1989,6 +2055,7 @@ static int do_md_run(mddev_t * mddev)
 
 	mddev->recovery = 0;
 	mddev->resync_max_sectors = mddev->size << 1; /* may be over-ridden by personality */
+	mddev->barriers_work = 1;
 
 	/* before we start the array running, initialise the bitmap */
 	err = bitmap_create(mddev);
@@ -2107,7 +2174,7 @@ static int do_md_stop(mddev_t * mddev, i
 			mddev->ro = 1;
 		} else {
 			bitmap_flush(mddev);
-			wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
+			md_super_wait(mddev);
 			if (mddev->ro)
 				set_disk_ro(disk, 0);
 			blk_queue_make_request(mddev->queue, md_fail_request);
@@ -3795,13 +3862,13 @@ void md_write_start(mddev_t *mddev, stru
 
 	atomic_inc(&mddev->writes_pending);
 	if (mddev->in_sync) {
-		spin_lock(&mddev->write_lock);
+		spin_lock_irq(&mddev->write_lock);
 		if (mddev->in_sync) {
 			mddev->in_sync = 0;
 			mddev->sb_dirty = 1;
 			md_wakeup_thread(mddev->thread);
 		}
-		spin_unlock(&mddev->write_lock);
+		spin_unlock_irq(&mddev->write_lock);
 	}
 	wait_event(mddev->sb_wait, mddev->sb_dirty==0);
 }
@@ -4108,7 +4175,7 @@ void md_check_recovery(mddev_t *mddev)
 	if (mddev_trylock(mddev)==0) {
 		int spares =0;
 
-		spin_lock(&mddev->write_lock);
+		spin_lock_irq(&mddev->write_lock);
 		if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
 		    !mddev->in_sync && mddev->recovery_cp == MaxSector) {
 			mddev->in_sync = 1;
@@ -4116,7 +4183,7 @@ void md_check_recovery(mddev_t *mddev)
 		}
 		if (mddev->safemode == 1)
 			mddev->safemode = 0;
-		spin_unlock(&mddev->write_lock);
+		spin_unlock_irq(&mddev->write_lock);
 
 		if (mddev->sb_dirty)
 			md_update_sb(mddev);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-10-14 12:18:10.000000000 +1000
+++ ./drivers/md/raid1.c	2005-10-14 12:19:23.000000000 +1000
@@ -301,7 +301,7 @@ static int raid1_end_write_request(struc
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
-	int mirror, behind;
+	int mirror, behind = test_bit(R1BIO_BehindIO, &r1_bio->state);
 	conf_t *conf = mddev_to_conf(r1_bio->mddev);
 
 	if (bio->bi_size)
@@ -311,47 +311,54 @@ static int raid1_end_write_request(struc
 		if (r1_bio->bios[mirror] == bio)
 			break;
 
-	/*
-	 * this branch is our 'one mirror IO has finished' event handler:
-	 */
-	if (!uptodate) {
-		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-		/* an I/O failed, we can't clear the bitmap */
-		set_bit(R1BIO_Degraded, &r1_bio->state);
-	} else
+	if (error == -ENOTSUPP && test_bit(R1BIO_Barrier, &r1_bio->state)) {
+		set_bit(BarriersNotsupp, &conf->mirrors[mirror].rdev->flags);
+		set_bit(R1BIO_BarrierRetry, &r1_bio->state);
+		r1_bio->mddev->barriers_work = 0;
+	} else {
 		/*
-		 * Set R1BIO_Uptodate in our master bio, so that
-		 * we will return a good error code for to the higher
-		 * levels even if IO on some other mirrored buffer fails.
-		 *
-		 * The 'master' represents the composite IO operation to
-		 * user-side. So if something waits for IO, then it will
-		 * wait for the 'master' bio.
+		 * this branch is our 'one mirror IO has finished' event handler:
 		 */
-		set_bit(R1BIO_Uptodate, &r1_bio->state);
+		r1_bio->bios[mirror] = NULL;
+		bio_put(bio);
+		if (!uptodate) {
+			md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
+			/* an I/O failed, we can't clear the bitmap */
+			set_bit(R1BIO_Degraded, &r1_bio->state);
+		} else
+			/*
+			 * Set R1BIO_Uptodate in our master bio, so that
+			 * we will return a good error code for to the higher
+			 * levels even if IO on some other mirrored buffer fails.
+			 *
+			 * The 'master' represents the composite IO operation to
+			 * user-side. So if something waits for IO, then it will
+			 * wait for the 'master' bio.
+			 */
+			set_bit(R1BIO_Uptodate, &r1_bio->state);
 
-	update_head_pos(mirror, r1_bio);
+		update_head_pos(mirror, r1_bio);
 
-	behind = test_bit(R1BIO_BehindIO, &r1_bio->state);
-	if (behind) {
-		if (test_bit(WriteMostly, &conf->mirrors[mirror].rdev->flags))
-			atomic_dec(&r1_bio->behind_remaining);
-
-		/* In behind mode, we ACK the master bio once the I/O has safely
-		 * reached all non-writemostly disks. Setting the Returned bit
-		 * ensures that this gets done only once -- we don't ever want to
-		 * return -EIO here, instead we'll wait */
-
-		if (atomic_read(&r1_bio->behind_remaining) >= (atomic_read(&r1_bio->remaining)-1) &&
-		    test_bit(R1BIO_Uptodate, &r1_bio->state)) {
-			/* Maybe we can return now */
-			if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
-				struct bio *mbio = r1_bio->master_bio;
-				PRINTK(KERN_DEBUG "raid1: behind end write sectors %llu-%llu\n",
-				       (unsigned long long) mbio->bi_sector,
-				       (unsigned long long) mbio->bi_sector +
-				       (mbio->bi_size >> 9) - 1);
-				bio_endio(mbio, mbio->bi_size, 0);
+		if (behind) {
+			if (test_bit(WriteMostly, &conf->mirrors[mirror].rdev->flags))
+				atomic_dec(&r1_bio->behind_remaining);
+
+			/* In behind mode, we ACK the master bio once the I/O has safely
+			 * reached all non-writemostly disks. Setting the Returned bit
+			 * ensures that this gets done only once -- we don't ever want to
+			 * return -EIO here, instead we'll wait */
+
+			if (atomic_read(&r1_bio->behind_remaining) >= (atomic_read(&r1_bio->remaining)-1) &&
+			    test_bit(R1BIO_Uptodate, &r1_bio->state)) {
+				/* Maybe we can return now */
+				if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
+					struct bio *mbio = r1_bio->master_bio;
+					PRINTK(KERN_DEBUG "raid1: behind end write sectors %llu-%llu\n",
+					       (unsigned long long) mbio->bi_sector,
+					       (unsigned long long) mbio->bi_sector +
+					       (mbio->bi_size >> 9) - 1);
+					bio_endio(mbio, mbio->bi_size, 0);
+				}
 			}
 		}
 	}
@@ -361,8 +368,16 @@ static int raid1_end_write_request(struc
 	 * already.
 	 */
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
+		if (test_bit(R1BIO_BarrierRetry, &r1_bio->state)) {
+			reschedule_retry(r1_bio);
+			/* Don't dec_pending yet, we want to hold
+			 * the reference over the retry
+			 */
+			return 0;
+		}
 		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
 			/* free extra copy of the data pages */
+/* FIXME bio has been freed!!! */
 			int i = bio->bi_vcnt;
 			while (i--)
 				__free_page(bio->bi_io_vec[i].bv_page);
@@ -647,8 +662,9 @@ static int make_request(request_queue_t 
 	unsigned long flags;
 	struct bio_list bl;
 	struct page **behind_pages = NULL;
+	int do_barriers;
 
-	if (unlikely(bio_barrier(bio))) {
+	if (unlikely(!mddev->barriers_work && bio_barrier(bio))) {
 		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
 		return 0;
 	}
@@ -763,6 +779,10 @@ static int make_request(request_queue_t 
 	atomic_set(&r1_bio->remaining, 0);
 	atomic_set(&r1_bio->behind_remaining, 0);
 
+	do_barriers = bio->bi_rw & BIO_RW_BARRIER;
+	if (do_barriers)
+		set_bit(R1BIO_Barrier, &r1_bio->state);
+
 	bio_list_init(&bl);
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio;
@@ -775,7 +795,7 @@ static int make_request(request_queue_t 
 		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE;
+		mbio->bi_rw = WRITE | do_barriers;
 		mbio->bi_private = r1_bio;
 
 		if (behind_pages) {
@@ -1157,6 +1177,36 @@ static void raid1d(mddev_t *mddev)
 		if (test_bit(R1BIO_IsSync, &r1_bio->state)) {
 			sync_request_write(mddev, r1_bio);
 			unplug = 1;
+		} else if (test_bit(R1BIO_BarrierRetry, &r1_bio->state)) {
+			/* some requests in the r1bio were BIO_RW_BARRIER
+			 * requests which failed with -ENOTSUPP.  Hohumm..
+			 * Better resubmit without the barrier.
+			 * We know which devices to resubmit for, because
+			 * all others have had their bios[] entry cleared.
+			 */
+			int i;
+			clear_bit(R1BIO_BarrierRetry, &r1_bio->state);
+			clear_bit(R1BIO_Barrier, &r1_bio->state);
+			for (i=0; i < conf->raid_disks; i++)
+				if (r1_bio->bios[i]) {
+					struct bio_vec *bvec;
+					int j;
+
+					bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
+					/* copy pages from the failed bio, as
+					 * this might be a write-behind device */
+					__bio_for_each_segment(bvec, bio, j, 0)
+						bvec->bv_page = bio_iovec_idx(r1_bio->bios[i], j)->bv_page;
+					bio_put(r1_bio->bios[i]);
+					bio->bi_sector = r1_bio->sector +
+						conf->mirrors[i].rdev->data_offset;
+					bio->bi_bdev = conf->mirrors[i].rdev->bdev;
+					bio->bi_end_io = raid1_end_write_request;
+					bio->bi_rw = WRITE;
+					bio->bi_private = r1_bio;
+					r1_bio->bios[i] = bio;
+					generic_make_request(bio);
+				}
 		} else {
 			int disk;
 			bio = r1_bio->bios[r1_bio->read_disk];

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2005-10-14 12:18:21.000000000 +1000
+++ ./include/linux/raid/md.h	2005-10-14 12:19:23.000000000 +1000
@@ -89,6 +89,7 @@ extern void md_print_devices (void);
 
 extern void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 			   sector_t sector, int size, struct page *page);
+extern void md_super_wait(mddev_t *mddev);
 extern int sync_page_io(struct block_device *bdev, sector_t sector, int size,
 			struct page *page, int rw);
 

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-10-14 12:18:10.000000000 +1000
+++ ./include/linux/raid/md_k.h	2005-10-14 12:19:23.000000000 +1000
@@ -122,6 +122,7 @@ struct mdk_rdev_s
 #define	Faulty		1		/* device is known to have a fault */
 #define	In_sync		2		/* device is in_sync with rest of array */
 #define	WriteMostly	4		/* Avoid reading if at all possible */
+#define	BarriersNotsupp	5		/* BIO_RW_BARRIER is not supported */
 
 	int desc_nr;			/* descriptor index in the superblock */
 	int raid_disk;			/* role of device in array */
@@ -210,6 +211,13 @@ struct mddev_s
 	int				degraded;	/* whether md should consider
 							 * adding a spare
 							 */
+	int				barriers_work;	/* initialised to true, cleared as soon
+							 * as a barrier request to slave
+							 * fails.  Only supported
+							 */
+	struct bio			*biolist; 	/* bios that need to be retried
+							 * because BIO_RW_BARRIER is not supported
+							 */
 
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2005-10-14 12:01:38.000000000 +1000
+++ ./include/linux/raid/raid1.h	2005-10-14 12:19:23.000000000 +1000
@@ -110,7 +110,9 @@ struct r1bio_s {
 #define	R1BIO_Uptodate	0
 #define	R1BIO_IsSync	1
 #define	R1BIO_Degraded	2
-#define	R1BIO_BehindIO   3
+#define	R1BIO_BehindIO	3
+#define	R1BIO_Barrier	4
+#define R1BIO_BarrierRetry 5
 /* For write-behind requests, we call bi_end_io when
  * the last non-write-behind device completes, providing
  * any write was successful.  Otherwise we call when
