From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 4 - Fix assorted raid1 problems.
Date: Thu, 07 Nov 2002 11:56:05 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E189axp-0008JJ-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

From: Angus Sawyer <angus.sawyer@dsl.pipex.com>


1. Null pointer dereference in end_sync_read

r1_bio->read_disk is not initialised correctly in sync_request .

this is used in end_sync_read to reference the structure
conf->mirror[read_disk].rdev which with one disk missing is NULL.


2. Null pointer dereference in mempool_free()

This is a race between close_sync() conf->r1_bufpool =3D NULL and put_buf()
mempool_free().

bio completion -> resume_device -> put_buf -> mempool_free(r1_bufpool)
				|
			[ wakeup]
				|
			close_sync()	-> r1_bufpool = NULL;

The patch attached  reorders the mempool_free before the  barrier is released
and merges resume_device() into put_buf(), (they are only used together).
Otherwise I have kept the locking and wakeups identical to the existing code.
(maybe this could be streamlined)

3.  BUG() at close_sync() if (waitqueue_active(&conf->wait_resume).

This occurs with and without the patch for (2).

I think this is a false BUG().  From what I understand of the device barrier
code, there is nothing wrong with make_request() waiting on wait_resume when
this test is made.  Therefore I have removed it (the wait_idle test is still
correct).

4. raid1 tries to start a resync if there is only one working drive,
   which is pretty pointless, and noisy.  We notice that special case and
   avoid the resync.






 ----------- Diffstat output ------------
 ./drivers/md/raid1.c |   39 +++++++++++++++++----------------------
 1 files changed, 17 insertions(+), 22 deletions(-)

--- ./drivers/md/raid1.c	2002/11/06 22:59:16	1.1
+++ ./drivers/md/raid1.c	2002/11/06 23:02:38	1.2
@@ -173,12 +173,6 @@ static inline void put_buf(r1bio_t *r1_b
 	struct bio *bio = r1_bio->master_bio;
 	unsigned long flags;
 
-	spin_lock_irqsave(&conf->resync_lock, flags);
-	if (!--conf->nr_pending) {
-		wake_up(&conf->wait_idle);
-		wake_up(&conf->wait_resume);
-	}
-	spin_unlock_irqrestore(&conf->resync_lock, flags);
 	/*
 	 * undo any possible partial request fixup magic:
 	 */
@@ -186,6 +180,19 @@ static inline void put_buf(r1bio_t *r1_b
 		bio->bi_io_vec[bio->bi_vcnt-1].bv_len = PAGE_SIZE;
 	put_all_bios(conf, r1_bio);
 	mempool_free(r1_bio, conf->r1buf_pool);
+
+	spin_lock_irqsave(&conf->resync_lock, flags);
+	if (!conf->barrier)
+		BUG();
+	--conf->barrier;
+	wake_up(&conf->wait_resume);
+	wake_up(&conf->wait_idle);
+
+	if (!--conf->nr_pending) {
+		wake_up(&conf->wait_idle);
+		wake_up(&conf->wait_resume);
+	}
+	spin_unlock_irqrestore(&conf->resync_lock, flags);
 }
 
 static int map(mddev_t *mddev, mdk_rdev_t **rdevp)
@@ -442,17 +449,6 @@ static void device_barrier(conf_t *conf,
 	spin_unlock_irq(&conf->resync_lock);
 }
 
-static void resume_device(conf_t *conf)
-{
-	spin_lock_irq(&conf->resync_lock);
-	if (!conf->barrier)
-		BUG();
-	--conf->barrier;
-	wake_up(&conf->wait_resume);
-	wake_up(&conf->wait_idle);
-	spin_unlock_irq(&conf->resync_lock);
-}
-
 static int make_request(request_queue_t *q, struct bio * bio)
 {
 	mddev_t *mddev = q->queuedata;
@@ -664,7 +660,6 @@ static void close_sync(conf_t *conf)
 
 	if (conf->barrier) BUG();
 	if (waitqueue_active(&conf->wait_idle)) BUG();
-	if (waitqueue_active(&conf->wait_resume)) BUG();
 
 	mempool_destroy(conf->r1buf_pool);
 	conf->r1buf_pool = NULL;
@@ -802,7 +797,6 @@ static int end_sync_write(struct bio *bi
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
 		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, uptodate);
-		resume_device(conf);
 		put_buf(r1_bio);
 	}
 	atomic_dec(&conf->mirrors[mirror].rdev->nr_pending);
@@ -829,7 +823,6 @@ static void sync_request_write(mddev_t *
 		 */
 		printk(IO_ERROR, bdev_partition_name(bio->bi_bdev), (unsigned long long)r1_bio->sector);
 		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, 0);
-		resume_device(conf);
 		put_buf(r1_bio);
 		return;
 	}
@@ -881,7 +874,6 @@ static void sync_request_write(mddev_t *
 		printk(KERN_ALERT "raid1: sync aborting as there is nowhere to write sector %llu\n", 
 			(unsigned long long)r1_bio->sector);
 		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, 0);
-		resume_device(conf);
 		put_buf(r1_bio);
 		return;
 	}
@@ -1021,7 +1013,7 @@ static int sync_request(mddev_t *mddev, 
 	atomic_inc(&conf->mirrors[disk].rdev->nr_pending);
 	spin_unlock_irq(&conf->device_lock);
 
-	mirror = conf->mirrors + conf->last_used;
+	mirror = conf->mirrors + disk;
 
 	r1_bio = mempool_alloc(conf->r1buf_pool, GFP_NOIO);
 
@@ -1032,6 +1024,7 @@ static int sync_request(mddev_t *mddev, 
 	r1_bio->mddev = mddev;
 	r1_bio->sector = sector_nr;
 	r1_bio->cmd = SPECIAL;
+	r1_bio->read_disk = disk;
 
 	bio = r1_bio->master_bio;
 	nr_sectors = RESYNC_BLOCK_SIZE >> 9;
@@ -1155,6 +1148,8 @@ static int run(mddev_t *mddev)
 	conf->raid_disks = mddev->raid_disks;
 	conf->mddev = mddev;
 	conf->device_lock = SPIN_LOCK_UNLOCKED;
+	if (conf->working_disks == 1)
+		mddev->state |= (1 << MD_SB_CLEAN);
 
 	conf->resync_lock = SPIN_LOCK_UNLOCKED;
 	init_waitqueue_head(&conf->wait_idle);
