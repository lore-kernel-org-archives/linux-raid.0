From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 5 of 13 - Keep track of number of pending requests on each component device on an MD array
Date: Thu, 22 Aug 2002 10:34:03 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfvH-00050A-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

This will allow us to know, in the event of a device failure, when the
device is completely unused and so can be disconnected from the
array.  Currently this isn't a problem as drives aren't normally disconnect 
until after a repacement has been rebuilt, which is a LONG TIME, but that
will change shortly...

We always increment the count under a spinlock after checking that
it hasn't been disconnected already (rdev!= NULL).
We disconnect under the same spinlock after checking that the
count is zero.


 ----------- Diffstat output ------------
 ./drivers/md/md.c            |    1 
 ./drivers/md/multipath.c     |   56 ++++++++++++---------
 ./drivers/md/raid1.c         |  114 +++++++++++++++++++++++++++----------------
 ./drivers/md/raid5.c         |   22 ++++++--
 ./include/linux/raid/md_k.h  |    5 +
 ./include/linux/raid/raid1.h |    1 
 6 files changed, 130 insertions(+), 69 deletions(-)

--- ./include/linux/raid/raid1.h	2002/08/21 23:07:28	1.2
+++ ./include/linux/raid/raid1.h	2002/08/21 23:10:24	1.3
@@ -8,7 +8,6 @@ typedef struct mirror_info mirror_info_t
 struct mirror_info {
 	mdk_rdev_t	*rdev;
 	sector_t	head_position;
-	atomic_t	nr_pending;
 
 	/*
 	 * State bits:
--- ./include/linux/raid/md_k.h	2002/08/21 23:08:55	1.2
+++ ./include/linux/raid/md_k.h	2002/08/21 23:10:24	1.3
@@ -160,6 +160,11 @@ struct mdk_rdev_s
 
 	int desc_nr;			/* descriptor index in the superblock */
 	int raid_disk;			/* role of device in array */
+
+	atomic_t	nr_pending;	/* number of pending requests.
+					 * only maintained for arrays that
+					 * support hot removal
+					 */
 };
 
 typedef struct mdk_personality_s mdk_personality_t;
--- ./drivers/md/md.c	2002/08/21 23:08:55	1.6
+++ ./drivers/md/md.c	2002/08/21 23:10:24	1.7
@@ -998,6 +998,7 @@ static mdk_rdev_t *md_import_device(dev_
 	}
 	rdev->desc_nr = -1;
 	rdev->faulty = 0;
+	atomic_set(&rdev->nr_pending, 0);
 
 	size = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
 	if (!size) {
--- ./drivers/md/raid5.c	2002/08/21 23:08:55	1.4
+++ ./drivers/md/raid5.c	2002/08/21 23:10:25	1.5
@@ -374,6 +374,7 @@ static void raid5_end_read_request (stru
 		md_error(conf->mddev, conf->disks[i].rdev);
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 	}
+	atomic_dec(&conf->disks[i].rdev->nr_pending);
 #if 0
 	/* must restore b_page before unlocking buffer... */
 	if (sh->bh_page[i] != bh->b_page) {
@@ -408,6 +409,8 @@ static void raid5_end_write_request (str
 	spin_lock_irqsave(&conf->device_lock, flags);
 	if (!uptodate)
 		md_error(conf->mddev, conf->disks[i].rdev);
+
+	atomic_dec(&conf->disks[i].rdev->nr_pending);
 	
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -1161,18 +1164,26 @@ static void handle_stripe(struct stripe_
 	for (i=disks; i-- ;) 
 		if (action[i]) {
 			struct bio *bi = &sh->dev[i].req;
-			struct disk_info *spare = conf->spare;
 			int skip = 0;
+			mdk_rdev_t *rdev = NULL;
 			if (action[i] == READ+1)
 				bi->bi_end_io = raid5_end_read_request;
 			else
 				bi->bi_end_io = raid5_end_write_request;
+
+			spin_lock_irq(&conf->device_lock);
 			if (conf->disks[i].operational)
-				bi->bi_bdev = conf->disks[i].rdev->bdev;
-			else if (spare && action[i] == WRITE+1)
-				bi->bi_bdev = spare->rdev->bdev;
+				rdev = conf->disks[i].rdev;
+			else if (conf->spare && action[i] == WRITE+1)
+				rdev = conf->spare->rdev;
 			else skip=1;
+			if (rdev)
+				atomic_inc(&rdev->nr_pending);
+			else	skip=1;
+			spin_unlock_irq(&conf->device_lock);
+
 			if (!skip) {
+				bi->bi_bdev = rdev->bdev;
 				PRINTK("for %ld schedule op %d on disc %d\n", sh->sector, action[i]-1, i);
 				atomic_inc(&sh->count);
 				bi->bi_sector = sh->sector;
@@ -1772,7 +1783,8 @@ static int raid5_remove_disk(mddev_t *md
 	spin_lock_irq(&conf->device_lock);
 
 	if (p->used_slot) {
-		if (p->operational) {
+		if (p->operational || 
+		    atomic_read(&p->rdev->nr_pending)) {
 			err = -EBUSY;
 			goto abort;
 		}
--- ./drivers/md/raid1.c	2002/08/21 23:08:55	1.3
+++ ./drivers/md/raid1.c	2002/08/21 23:10:25	1.4
@@ -188,7 +188,7 @@ static inline void put_buf(r1bio_t *r1_b
 	mempool_free(r1_bio, conf->r1buf_pool);
 }
 
-static int map(mddev_t *mddev, struct block_device **bdev)
+static int map(mddev_t *mddev, mdk_rdev_t **rdev)
 {
 	conf_t *conf = mddev_to_conf(mddev);
 	int i, disks = MD_SB_DISKS;
@@ -198,12 +198,17 @@ static int map(mddev_t *mddev, struct bl
 	 * now we use the first available disk.
 	 */
 
+	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < disks; i++) {
-		if (conf->mirrors[i].operational) {
-			*bdev = conf->mirrors[i].rdev->bdev;
+		if (conf->mirrors[i].operational &&
+			conf->mirrors[i].rdev) {
+			*rdev = conf->mirrors[i].rdev;
+			atomic_inc(&(*rdev)->nr_pending);
+			spin_unlock_irq(&conf->device_lock);
 			return 0;
 		}
 	}
+	spin_unlock_irq(&conf->device_lock);
 
 	printk (KERN_ERR "raid1_map(): huh, no more operational devices?\n");
 	return -1;
@@ -244,7 +249,6 @@ static void inline update_head_pos(int d
 
 	conf->mirrors[disk].head_position =
 		r1_bio->sector + (r1_bio->master_bio->bi_size >> 9);
-	atomic_dec(&conf->mirrors[disk].nr_pending);
 }
 
 static void end_request(struct bio *bio)
@@ -285,29 +289,30 @@ static void end_request(struct bio *bio)
 		/*
 		 * we have only one bio on the read side
 		 */
-		if (uptodate) {
+		if (uptodate)
 			raid_end_bio_io(r1_bio, uptodate);
-			return;
+		else {
+			/*
+			 * oops, read error:
+			 */
+			printk(KERN_ERR "raid1: %s: rescheduling sector %lu\n",
+			       bdev_partition_name(conf->mirrors[mirror].rdev->bdev), r1_bio->sector);
+			reschedule_retry(r1_bio);
 		}
+	} else {
+
+		if (r1_bio->read_bio)
+			BUG();
 		/*
-		 * oops, read error:
+		 * WRITE:
+		 *
+		 * Let's see if all mirrored write operations have finished
+		 * already.
 		 */
-		printk(KERN_ERR "raid1: %s: rescheduling sector %lu\n",
-			bdev_partition_name(conf->mirrors[mirror].rdev->bdev), r1_bio->sector);
-		reschedule_retry(r1_bio);
-		return;
+		if (atomic_dec_and_test(&r1_bio->remaining))
+			raid_end_bio_io(r1_bio, uptodate);
 	}
-
-	if (r1_bio->read_bio)
-		BUG();
-	/*
-	 * WRITE:
-	 *
-	 * Let's see if all mirrored write operations have finished
-	 * already.
-	 */
-	if (atomic_dec_and_test(&r1_bio->remaining))
-		raid_end_bio_io(r1_bio, uptodate);
+	atomic_dec(&conf->mirrors[mirror].rdev->nr_pending);
 }
 
 /*
@@ -321,6 +326,8 @@ static void end_request(struct bio *bio)
  *
  * If there are 2 mirrors in the same 2 devices, performance degrades
  * because position is mirror, not device based.
+ *
+ * The rdev for the device selected will have nr_pending incremented.
  */
 static int read_balance(conf_t *conf, struct bio *bio, r1bio_t *r1_bio)
 {
@@ -329,6 +336,7 @@ static int read_balance(conf_t *conf, st
 	const int sectors = bio->bi_size >> 9;
 	sector_t new_distance, current_distance;
 
+	spin_lock_irq(&conf->device_lock);
 	/*
 	 * Check if it if we can balance. We can balance on the whole
 	 * device if no resync is going on, or below the resync window.
@@ -382,7 +390,7 @@ static int read_balance(conf_t *conf, st
 				(!conf->mirrors[disk].operational))
 			continue;
 
-		if (!atomic_read(&conf->mirrors[disk].nr_pending)) {
+		if (!atomic_read(&conf->mirrors[disk].rdev->nr_pending)) {
 			new_disk = disk;
 			break;
 		}
@@ -399,6 +407,10 @@ rb_out:
 
 	conf->last_used = new_disk;
 
+	if (conf->mirrors[new_disk].rdev)
+		atomic_inc(&conf->mirrors[new_disk].rdev->nr_pending);
+	spin_unlock_irq(&conf->device_lock);
+
 	return new_disk;
 }
 
@@ -484,21 +496,32 @@ static int make_request(request_queue_t 
 		read_bio->bi_private = r1_bio;
 
 		generic_make_request(read_bio);
-		atomic_inc(&conf->mirrors[r1_bio->read_disk].nr_pending);
 		return 0;
 	}
 
 	/*
 	 * WRITE:
 	 */
+	/* first select target devices under spinlock and
+	 * inc refcount on their rdev.  Record them by setting
+	 * write_bios[x] to bio
+	 */
+	spin_lock_irq(&conf->device_lock);
+	for (i = 0;  i < disks; i++) {
+		if (conf->mirrors[i].operational &&
+		    conf->mirrors[i].rdev) {
+			atomic_inc(&conf->mirrors[i].rdev->nr_pending);
+			r1_bio->write_bios[i] = bio;
+		} else
+			r1_bio->write_bios[i] = NULL;
+	}
+	spin_unlock_irq(&conf->device_lock);
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio;
-		if (!conf->mirrors[i].operational)
+		if (!r1_bio->write_bios[i])
 			continue;
 
 		mbio = bio_clone(bio, GFP_NOIO);
-		if (r1_bio->write_bios[i])
-			BUG();
 		r1_bio->write_bios[i] = mbio;
 
 		mbio->bi_sector	= r1_bio->sector;
@@ -536,7 +559,6 @@ static int make_request(request_queue_t 
 			continue;
 
 		generic_make_request(mbio);
-		atomic_inc(&conf->mirrors[i].nr_pending);
 	}
 	return 0;
 }
@@ -817,7 +839,8 @@ static int raid1_remove_disk(mddev_t *md
 	print_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 	if (p->used_slot) {
-		if (p->operational) {
+		if (p->operational ||
+			(p->rdev && atomic_read(&p->rdev->nr_pending))) {
 			err = -EBUSY;
 			goto abort;
 		}
@@ -859,6 +882,7 @@ static void end_sync_read(struct bio *bi
 			 conf->mirrors[r1_bio->read_disk].rdev);
 	else
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
+	atomic_dec(&conf->mirrors[r1_bio->read_disk].rdev->nr_pending);
 	reschedule_retry(r1_bio);
 }
 
@@ -885,6 +909,7 @@ static void end_sync_write(struct bio *b
 		resume_device(conf);
 		put_buf(r1_bio);
 	}
+	atomic_dec(&conf->mirrors[mirror].rdev->nr_pending);
 }
 
 static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
@@ -912,7 +937,9 @@ static void sync_request_write(mddev_t *
 		return;
 	}
 
+	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < disks ; i++) {
+		r1_bio->write_bios[i] = NULL;
 		if (!conf->mirrors[i].operational)
 			continue;
 		if (i == conf->last_used)
@@ -925,10 +952,17 @@ static void sync_request_write(mddev_t *
 			 * don't need to write this we are just rebuilding
 			 */
 			continue;
+		if (!conf->mirrors[i].rdev)
+			continue;
+		atomic_inc(&conf->mirrors[i].rdev->nr_pending);
+		r1_bio->write_bios[i] = bio;
+	}
+	spin_unlock_irq(&conf->device_lock);
 
+	for (i = 0; i < disks ; i++) {
+		if (!r1_bio->write_bios[i])
+			continue;
 		mbio = bio_clone(bio, GFP_NOIO);
-		if (r1_bio->write_bios[i])
-			BUG();
 		r1_bio->write_bios[i] = mbio;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_sector = r1_bio->sector;
@@ -961,7 +995,6 @@ static void sync_request_write(mddev_t *
 
 		md_sync_acct(conf->mirrors[i].rdev, mbio->bi_size >> 9);
 		generic_make_request(mbio);
-		atomic_inc(&conf->mirrors[i].nr_pending);
 	}
 }
 
@@ -981,7 +1014,7 @@ static void raid1d(void *data)
 	unsigned long flags;
 	mddev_t *mddev;
 	conf_t *conf;
-	struct block_device *bdev;
+	mdk_rdev_t *rdev;
 
 
 	for (;;) {
@@ -1001,20 +1034,18 @@ static void raid1d(void *data)
 			break;
 		case READ:
 		case READA:
-			bdev = bio->bi_bdev;
-			map(mddev, &bio->bi_bdev);
-			if (bio->bi_bdev == bdev) {
+			if (map(mddev, &rdev) == -1) {
 				printk(IO_ERROR, bdev_partition_name(bio->bi_bdev), r1_bio->sector);
 				raid_end_bio_io(r1_bio, 0);
 				break;
 			}
 			printk(REDIRECT_SECTOR,
-				bdev_partition_name(bio->bi_bdev), r1_bio->sector);
+				bdev_partition_name(rdev->bdev), r1_bio->sector);
+			bio->bi_bdev = rdev->bdev;
 			bio->bi_sector = r1_bio->sector;
 			bio->bi_rw = r1_bio->cmd;
 
 			generic_make_request(bio);
-			atomic_inc(&conf->mirrors[r1_bio->read_disk].nr_pending);
 			break;
 		}
 	}
@@ -1080,7 +1111,9 @@ static int sync_request(mddev_t *mddev, 
 	 */
 	disk = conf->last_used;
 	/* make sure disk is operational */
-	while (!conf->mirrors[disk].operational) {
+	spin_lock_irq(&conf->device_lock);
+	while (!conf->mirrors[disk].operational ||
+		!conf->mirrors[disk].rdev) {
 		if (disk <= 0)
 			disk = conf->raid_disks;
 		disk--;
@@ -1088,6 +1121,8 @@ static int sync_request(mddev_t *mddev, 
 			break;
 	}
 	conf->last_used = disk;
+	atomic_inc(&conf->mirrors[disk].rdev->nr_pending);
+	spin_unlock_irq(&conf->device_lock);
 
 	mirror = conf->mirrors + conf->last_used;
 
@@ -1130,7 +1165,6 @@ static int sync_request(mddev_t *mddev, 
 	md_sync_acct(mirror->rdev, nr_sectors);
 
 	generic_make_request(read_bio);
-	atomic_inc(&conf->mirrors[conf->last_used].nr_pending);
 
 	return nr_sectors;
 }
--- ./drivers/md/multipath.c	2002/08/21 23:08:55	1.3
+++ ./drivers/md/multipath.c	2002/08/21 23:10:25	1.4
@@ -70,7 +70,7 @@ static void mp_pool_free(void *mpb, void
 	kfree(mpb);
 }
 
-static int multipath_map (mddev_t *mddev, struct block_device **bdev)
+static int multipath_map (mddev_t *mddev, mdk_rdev_t **rdev)
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 	int i, disks = MD_SB_DISKS;
@@ -80,12 +80,17 @@ static int multipath_map (mddev_t *mddev
 	 * now we use the first available disk.
 	 */
 
+	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < disks; i++) {
-		if (conf->multipaths[i].operational) {
-			*bdev = conf->multipaths[i].rdev->bdev;
-			return (0);
+		if (conf->multipaths[i].operational &&
+			conf->multipaths[i].rdev) {
+			*rdev = conf->multipaths[i].rdev;
+			atomic_inc(&(*rdev)->nr_pending);
+			spin_unlock_irq(&conf->device_lock);
+			return 0;
 		}
 	}
+	spin_unlock_irq(&conf->device_lock);
 
 	printk (KERN_ERR "multipath_map(): no more operational IO paths?\n");
 	return (-1);
@@ -126,21 +131,21 @@ void multipath_end_request(struct bio *b
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct multipath_bh * mp_bh = (struct multipath_bh *)(bio->bi_private);
-	multipath_conf_t *conf;
-	mdk_rdev_t *rdev;
-	if (uptodate) {
+	multipath_conf_t *conf = mddev_to_conf(mp_bh->mddev);
+	mdk_rdev_t *rdev = conf->multipaths[mp_bh->path].rdev;
+
+	if (uptodate)
 		multipath_end_bh_io(mp_bh, uptodate);
-		return;
+	else {
+		/*
+		 * oops, IO error:
+		 */
+		md_error (mp_bh->mddev, rdev);
+		printk(KERN_ERR "multipath: %s: rescheduling sector %lu\n", 
+		       bdev_partition_name(rdev->bdev), bio->bi_sector);
+		multipath_reschedule_retry(mp_bh);
 	}
-	/*
-	 * oops, IO error:
-	 */
-	conf = mddev_to_conf(mp_bh->mddev);
-	rdev = conf->multipaths[mp_bh->path].rdev;
-	md_error (mp_bh->mddev, rdev);
-	printk(KERN_ERR "multipath: %s: rescheduling sector %lu\n", 
-		 bdev_partition_name(rdev->bdev), bio->bi_sector);
-	multipath_reschedule_retry(mp_bh);
+	atomic_dec(&rdev->nr_pending);
 	return;
 }
 
@@ -154,7 +159,8 @@ static int multipath_read_balance (multi
 	int disk;
 
 	for (disk = 0; disk < MD_SB_DISKS; disk++)	
-		if (conf->multipaths[disk].operational)
+		if (conf->multipaths[disk].operational &&
+			conf->multipaths[disk].rdev)
 			return disk;
 	BUG();
 	return 0;
@@ -175,8 +181,11 @@ static int multipath_make_request (reque
 	/*
 	 * read balancing logic:
 	 */
+	spin_lock_irq(&conf->device_lock);
 	mp_bh->path = multipath_read_balance(conf);
 	multipath = conf->multipaths + mp_bh->path;
+	atomic_inc(&multipath->rdev->nr_pending);
+	spin_unlock_irq(&conf->device_lock);
 
 	mp_bh->bio = *bio;
 	mp_bh->bio.bi_bdev = multipath->rdev->bdev;
@@ -321,7 +330,8 @@ static int multipath_remove_disk(mddev_t
 	spin_lock_irq(&conf->device_lock);
 
 	if (p->used_slot) {
-		if (p->operational) {
+		if (p->operational ||
+		    (p->rdev && atomic_read(&p->rdev->nr_pending))) {
 			printk(KERN_ERR "hot-remove-disk, slot %d is identified but is still operational!\n", number);
 			err = -EBUSY;
 			goto abort;
@@ -359,7 +369,7 @@ static void multipathd (void *data)
 	struct bio *bio;
 	unsigned long flags;
 	mddev_t *mddev;
-	struct block_device *bdev;
+	mdk_rdev_t *rdev;
 
 	for (;;) {
 		spin_lock_irqsave(&retry_list_lock, flags);
@@ -372,16 +382,16 @@ static void multipathd (void *data)
 		mddev = mp_bh->mddev;
 		bio = &mp_bh->bio;
 		bio->bi_sector = mp_bh->master_bio->bi_sector;
-		bdev = bio->bi_bdev;
 		
-		multipath_map (mddev, &bio->bi_bdev);
-		if (bio->bi_bdev == bdev) {
+		rdev = NULL;
+		if (multipath_map (mddev, &rdev)<0) {
 			printk(IO_ERROR,
 				bdev_partition_name(bio->bi_bdev), bio->bi_sector);
 			multipath_end_bh_io(mp_bh, 0);
 		} else {
 			printk(REDIRECT_SECTOR,
 				bdev_partition_name(bio->bi_bdev), bio->bi_sector);
+			bio->bi_bdev = rdev->bdev;
 			generic_make_request(bio);
 		}
 	}
