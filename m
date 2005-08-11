From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 006 of 6] Add write-behind support for md/raid1
Date: Thu, 11 Aug 2005 17:22:27 +1000
Message-ID: <E1E37OV-0002jU-9q@notabene.cse.unsw.edu.au>
References: <20050811171720.10115.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If a device is flagged 'WriteMostly' and the array has a bitmap,
and the bitmap superblock indicates that write_behind is allowed,
then write_behind is enabled for WriteMostly devices.

Write requests will be acknowledges as complete to the caller
(via b_end_io) when all non-WriteMostly devices have completed the write,
but will not be cleared from the bitmap until all devices complete.

This requires memory allocation to make a local copy of the data
being written.  If there is insufficient memory, then we fall-back
on normal write semantics.

Signed-Off-By: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c         |   26 +++++++-
 ./drivers/md/raid1.c          |  124 +++++++++++++++++++++++++++++++++++++++---
 ./include/linux/raid/bitmap.h |   15 +++--
 ./include/linux/raid/md_k.h   |    3 +
 ./include/linux/raid/raid1.h  |   13 ++++
 5 files changed, 165 insertions(+), 16 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-08-11 16:17:06.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-08-11 16:04:11.000000000 +1000
@@ -437,6 +437,7 @@ void bitmap_print_sb(struct bitmap *bitm
 	printk(KERN_DEBUG "  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
 	printk(KERN_DEBUG "     sync size: %llu KB\n",
 			(unsigned long long)le64_to_cpu(sb->sync_size)/2);
+	printk(KERN_DEBUG "max write behind: %d\n", le32_to_cpu(sb->write_behind));
 	kunmap(bitmap->sb_page);
 }
 
@@ -445,7 +446,7 @@ static int bitmap_read_sb(struct bitmap 
 {
 	char *reason = NULL;
 	bitmap_super_t *sb;
-	unsigned long chunksize, daemon_sleep;
+	unsigned long chunksize, daemon_sleep, write_behind;
 	unsigned long bytes_read;
 	unsigned long long events;
 	int err = -EINVAL;
@@ -474,6 +475,7 @@ static int bitmap_read_sb(struct bitmap 
 
 	chunksize = le32_to_cpu(sb->chunksize);
 	daemon_sleep = le32_to_cpu(sb->daemon_sleep);
+	write_behind = le32_to_cpu(sb->write_behind);
 
 	/* verify that the bitmap-specific fields are valid */
 	if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
@@ -485,7 +487,9 @@ static int bitmap_read_sb(struct bitmap 
 	else if ((1 << ffz(~chunksize)) != chunksize)
 		reason = "bitmap chunksize not a power of 2";
 	else if (daemon_sleep < 1 || daemon_sleep > 15)
-		reason = "daemon sleep period out of range";
+		reason = "daemon sleep period out of range (1-15s)";
+	else if (write_behind > COUNTER_MAX)
+		reason = "write-behind limit out of range (0 - 16383)";
 	if (reason) {
 		printk(KERN_INFO "%s: invalid bitmap file superblock: %s\n",
 			bmname(bitmap), reason);
@@ -518,6 +522,7 @@ success:
 	/* assign fields using values from superblock */
 	bitmap->chunksize = chunksize;
 	bitmap->daemon_sleep = daemon_sleep;
+	bitmap->max_write_behind = write_behind;
 	bitmap->flags |= sb->state;
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
 	if (sb->state & BITMAP_STALE)
@@ -1282,9 +1287,16 @@ static bitmap_counter_t *bitmap_get_coun
 	}
 }
 
-int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors)
+int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors, int behind)
 {
 	if (!bitmap) return 0;
+
+	if (behind) {
+		atomic_inc(&bitmap->behind_writes);
+		PRINTK(KERN_DEBUG "inc write-behind count %d/%d\n",
+		  atomic_read(&bitmap->behind_writes), bitmap->max_write_behind);
+	}
+
 	while (sectors) {
 		int blocks;
 		bitmap_counter_t *bmc;
@@ -1319,9 +1331,15 @@ int bitmap_startwrite(struct bitmap *bit
 }
 
 void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors,
-		     int success)
+		     int success, int behind)
 {
 	if (!bitmap) return;
+	if (behind) {
+		atomic_dec(&bitmap->behind_writes);
+		PRINTK(KERN_DEBUG "dec write-behind count %d/%d\n",
+		  atomic_read(&bitmap->behind_writes), bitmap->max_write_behind);
+	}
+
 	while (sectors) {
 		int blocks;
 		unsigned long flags;

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-08-11 16:17:06.000000000 +1000
+++ ./drivers/md/raid1.c	2005-08-11 16:22:45.000000000 +1000
@@ -222,8 +222,17 @@ static void raid_end_bio_io(r1bio_t *r1_
 {
 	struct bio *bio = r1_bio->master_bio;
 
-	bio_endio(bio, bio->bi_size,
-		test_bit(R1BIO_Uptodate, &r1_bio->state) ? 0 : -EIO);
+	/* if nobody has done the final endio yet, do it now */
+	if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
+		PRINTK(KERN_DEBUG "raid1: sync end %s on sectors %llu-%llu\n",
+			(bio_data_dir(bio) == WRITE) ? "write" : "read",
+			(unsigned long long) bio->bi_sector,
+			(unsigned long long) bio->bi_sector +
+				(bio->bi_size >> 9) - 1);
+	
+		bio_endio(bio, bio->bi_size,
+			test_bit(R1BIO_Uptodate, &r1_bio->state) ? 0 : -EIO);
+	}
 	free_r1bio(r1_bio);
 }
 
@@ -292,7 +301,7 @@ static int raid1_end_write_request(struc
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
-	int mirror;
+	int mirror, behind;
 	conf_t *conf = mddev_to_conf(r1_bio->mddev);
 
 	if (bio->bi_size)
@@ -323,16 +332,46 @@ static int raid1_end_write_request(struc
 
 	update_head_pos(mirror, r1_bio);
 
+	behind = test_bit(R1BIO_BehindIO, &r1_bio->state);
+	if (behind) {
+		if (test_bit(WriteMostly, &conf->mirrors[mirror].rdev->flags))
+			atomic_dec(&r1_bio->behind_remaining);
+
+		/* In behind mode, we ACK the master bio once the I/O has safely
+		 * reached all non-writemostly disks. Setting the Returned bit
+		 * ensures that this gets done only once -- we don't ever want to
+		 * return -EIO here, instead we'll wait */
+
+		if (atomic_read(&r1_bio->behind_remaining) >= (atomic_read(&r1_bio->remaining)-1) &&
+		    test_bit(R1BIO_Uptodate, &r1_bio->state)) {
+			/* Maybe we can return now */
+			if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
+				struct bio *mbio = r1_bio->master_bio;
+				PRINTK(KERN_DEBUG "raid1: behind end write sectors %llu-%llu\n",
+				       (unsigned long long) mbio->bi_sector,
+				       (unsigned long long) mbio->bi_sector +
+				       (mbio->bi_size >> 9) - 1);
+				bio_endio(mbio, mbio->bi_size, 0);
+			}
+		}
+	}
 	/*
 	 *
 	 * Let's see if all mirrored write operations have finished
 	 * already.
 	 */
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
+		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
+			/* free extra copy of the data pages */
+			int i = bio->bi_vcnt;
+			while (i--)
+				__free_page(bio->bi_io_vec[i].bv_page);
+		}
 		/* clear the bitmap if all writes complete successfully */
 		bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
 				r1_bio->sectors,
-				!test_bit(R1BIO_Degraded, &r1_bio->state));
+				!test_bit(R1BIO_Degraded, &r1_bio->state),
+				behind);
 		md_write_end(r1_bio->mddev);
 		raid_end_bio_io(r1_bio);
 	}
@@ -562,6 +601,39 @@ static void device_barrier(conf_t *conf,
 	spin_unlock_irq(&conf->resync_lock);
 }
 
+/* duplicate the data pages for behind I/O */
+static struct page **alloc_behind_pages(struct bio *bio)
+{
+	int i;
+	struct bio_vec *bvec;
+	struct page **pages = kmalloc(bio->bi_vcnt * sizeof(struct page *),
+					GFP_NOIO);
+	if (unlikely(!pages))
+		goto do_sync_io;
+
+	memset(pages, 0, bio->bi_vcnt * sizeof(struct page *));
+
+	bio_for_each_segment(bvec, bio, i) {
+		pages[i] = alloc_page(GFP_NOIO);
+		if (unlikely(!pages[i]))
+			goto do_sync_io;
+		memcpy(kmap(pages[i]) + bvec->bv_offset,
+			kmap(bvec->bv_page) + bvec->bv_offset, bvec->bv_len);
+		kunmap(pages[i]);
+		kunmap(bvec->bv_page);
+	}
+
+	return pages;
+
+do_sync_io:
+	if (pages)
+		for (i = 0; i < bio->bi_vcnt && pages[i]; i++)
+			__free_page(pages[i]);
+	kfree(pages);
+	PRINTK("%dB behind alloc failed, doing sync I/O\n", bio->bi_size);
+	return NULL;
+}
+
 static int make_request(request_queue_t *q, struct bio * bio)
 {
 	mddev_t *mddev = q->queuedata;
@@ -574,6 +646,7 @@ static int make_request(request_queue_t 
 	struct bitmap *bitmap = mddev->bitmap;
 	unsigned long flags;
 	struct bio_list bl;
+	struct page **behind_pages = NULL;
 
 	if (unlikely(bio_barrier(bio))) {
 		bio_endio(bio, bio->bi_size, -EOPNOTSUPP);
@@ -613,8 +686,6 @@ static int make_request(request_queue_t 
 	r1_bio->mddev = mddev;
 	r1_bio->sector = bio->bi_sector;
 
-	r1_bio->state = 0;
-
 	if (bio_data_dir(bio) == READ) {
 		/*
 		 * read balancing logic:
@@ -675,13 +746,22 @@ static int make_request(request_queue_t 
 	}
 	rcu_read_unlock();
 
+	BUG_ON(targets == 0); /* we never fail the last device */
+
 	if (targets < conf->raid_disks) {
 		/* array is degraded, we will not clear the bitmap
 		 * on I/O completion (see raid1_end_write_request) */
 		set_bit(R1BIO_Degraded, &r1_bio->state);
 	}
 
+	/* do behind I/O ? */
+	if (bitmap &&
+	    atomic_read(&bitmap->behind_writes) < bitmap->max_write_behind &&
+	    (behind_pages = alloc_behind_pages(bio)) != NULL)
+		set_bit(R1BIO_BehindIO, &r1_bio->state);
+
 	atomic_set(&r1_bio->remaining, 0);
+	atomic_set(&r1_bio->behind_remaining, 0);
 
 	bio_list_init(&bl);
 	for (i = 0; i < disks; i++) {
@@ -698,12 +778,31 @@ static int make_request(request_queue_t 
 		mbio->bi_rw = WRITE;
 		mbio->bi_private = r1_bio;
 
+		if (behind_pages) {
+			struct bio_vec *bvec;
+			int j;
+
+			/* Yes, I really want the '__' version so that
+			 * we clear any unused pointer in the io_vec, rather
+			 * than leave them unchanged.  This is important
+			 * because when we come to free the pages, we won't
+			 * know the originial bi_idx, so we just free 
+			 * them all
+			 */
+			__bio_for_each_segment(bvec, mbio, j, 0)
+				bvec->bv_page = behind_pages[j];
+			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
+				atomic_inc(&r1_bio->behind_remaining);
+		}
+
 		atomic_inc(&r1_bio->remaining);
 
 		bio_list_add(&bl, mbio);
 	}
+	kfree(behind_pages); /* the behind pages are attached to the bios now */
 
-	bitmap_startwrite(bitmap, bio->bi_sector, r1_bio->sectors);
+	bitmap_startwrite(bitmap, bio->bi_sector, r1_bio->sectors,
+				test_bit(R1BIO_BehindIO, &r1_bio->state));
 	spin_lock_irqsave(&conf->device_lock, flags);
 	bio_list_merge(&conf->pending_bio_list, &bl);
 	bio_list_init(&bl);
@@ -1471,6 +1570,17 @@ out:
 static int stop(mddev_t *mddev)
 {
 	conf_t *conf = mddev_to_conf(mddev);
+	struct bitmap *bitmap = mddev->bitmap;
+	int behind_wait = 0;
+
+	/* wait for behind writes to complete */
+	while (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
+		behind_wait++;
+		printk(KERN_INFO "raid1: behind writes in progress on device %s, waiting to stop (%d)\n", mdname(mddev), behind_wait);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(HZ); /* wait a second */
+		/* need to kick something here to make sure I/O goes? */
+	}
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;

diff ./include/linux/raid/bitmap.h~current~ ./include/linux/raid/bitmap.h
--- ./include/linux/raid/bitmap.h~current~	2005-08-11 16:17:06.000000000 +1000
+++ ./include/linux/raid/bitmap.h	2005-08-11 16:04:11.000000000 +1000
@@ -7,7 +7,7 @@
 #define BITMAP_H 1
 
 #define BITMAP_MAJOR 3
-#define BITMAP_MINOR 38
+#define BITMAP_MINOR 39
 
 /*
  * in-memory bitmap:
@@ -147,8 +147,9 @@ typedef struct bitmap_super_s {
 	__u32 state;        /* 48  bitmap state information */
 	__u32 chunksize;    /* 52  the bitmap chunk size in bytes */
 	__u32 daemon_sleep; /* 56  seconds between disk flushes */
+	__u32 write_behind; /* 60  number of outstanding write-behind writes */
 
-	__u8  pad[256 - 60]; /* set to zero */
+	__u8  pad[256 - 64]; /* set to zero */
 } bitmap_super_t;
 
 /* notes:
@@ -226,6 +227,9 @@ struct bitmap {
 
 	unsigned long flags;
 
+	unsigned long max_write_behind; /* write-behind mode */
+	atomic_t behind_writes;
+
 	/*
 	 * the bitmap daemon - periodically wakes up and sweeps the bitmap
 	 * file, cleaning up bits and flushing out pages to disk as necessary
@@ -260,9 +264,10 @@ int  bitmap_setallbits(struct bitmap *bi
 void bitmap_write_all(struct bitmap *bitmap);
 
 /* these are exported */
-int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors);
-void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors,
-		     int success);
+int bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
+			unsigned long sectors, int behind);
+void bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
+			unsigned long sectors, int success, int behind);
 int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int degraded);
 void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int aborted);
 void bitmap_close_sync(struct bitmap *bitmap);

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-08-11 16:17:06.000000000 +1000
+++ ./include/linux/raid/md_k.h	2005-08-11 16:04:11.000000000 +1000
@@ -275,6 +275,9 @@ struct mddev_s
 	atomic_t			writes_pending; 
 	request_queue_t			*queue;	/* for plugging ... */
 
+	atomic_t                        write_behind; /* outstanding async IO */
+	unsigned int                    max_write_behind; /* 0 = sync */
+
 	struct bitmap                   *bitmap; /* the bitmap for the device */
 	struct file			*bitmap_file; /* the bitmap file */
 	long				bitmap_offset; /* offset from superblock of

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2005-08-11 16:17:06.000000000 +1000
+++ ./include/linux/raid/raid1.h	2005-08-11 16:04:11.000000000 +1000
@@ -80,6 +80,9 @@ struct r1bio_s {
 	atomic_t		remaining; /* 'have we finished' count,
 					    * used from IRQ handlers
 					    */
+	atomic_t		behind_remaining; /* number of write-behind ios remaining
+						 * in this BehindIO request
+						 */
 	sector_t		sector;
 	int			sectors;
 	unsigned long		state;
@@ -107,4 +110,14 @@ struct r1bio_s {
 #define	R1BIO_Uptodate	0
 #define	R1BIO_IsSync	1
 #define	R1BIO_Degraded	2
+#define	R1BIO_BehindIO   3
+/* For write-behind requests, we call bi_end_io when 
+ * the last non-write-behind device completes, providing 
+ * any write was successful.  Otherwise we call when 
+ * any write-behind write succeeds, otherwise we call 
+ * with failure when last write completes (and all failed).
+ * Record that bi_end_io was called with this flag...
+ */
+#define	R1BIO_Returned 4 
+				 
 #endif
