From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH 2/3] md bitmap async writes for raid1
Date: Thu, 17 Mar 2005 15:55:17 -0500
Message-ID: <4239EEB5.7020901@steeleye.com>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <4239EDCA.4030502@steeleye.com> <4239EE55.7040804@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040105060509000204040704"
In-Reply-To: <4239EE55.7040804@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040105060509000204040704
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch implements async writes in raid1.

--------------040105060509000204040704
Content-Type: text/plain;
 name="md_async_4_0_raid1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_async_4_0_raid1.diff"


Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

 drivers/md/raid1.c         |  107 ++++++++++++++++++++++++++++++++++++++++++---
 include/linux/raid/raid1.h |    2 
 2 files changed, 102 insertions(+), 7 deletions(-)
diff -purN --exclude core --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug-bitmap-bug-fix/drivers/md/raid1.c linux-2.6.11-rc3-mm2-patch-all-write-mostly-async-write-bitmap-bug-fix/drivers/md/raid1.c
--- linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug-bitmap-bug-fix/drivers/md/raid1.c	Thu Mar 10 10:05:35 2005
+++ linux-2.6.11-rc3-mm2-patch-all-write-mostly-async-write-bitmap-bug-fix/drivers/md/raid1.c	Sat Mar 12 08:38:20 2005
@@ -35,7 +35,7 @@
 #include <linux/raid/raid1.h>
 #include <linux/raid/bitmap.h>
 
-#define DEBUG 0
+#define DEBUG 0
 #if DEBUG
 #define PRINTK(x...) printk(x)
 #else
@@ -222,8 +222,17 @@ static void raid_end_bio_io(r1bio_t *r1_
 {
 	struct bio *bio = r1_bio->master_bio;
 
-	bio_endio(bio, bio->bi_size,
-		test_bit(R1BIO_Uptodate, &r1_bio->state) ? 0 : -EIO);
+	/* if nobody has done the final endio yet, do it now */
+	if (!test_and_set_bit(R1BIO_AsyncPhase, &r1_bio->state)) {
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
+	int mirror, async, wonly = 1; /* assume write only if rdev missing */
 	conf_t *conf = mddev_to_conf(r1_bio->mddev);
 
 	if (bio->bi_size)
@@ -323,16 +332,39 @@ static int raid1_end_write_request(struc
 
 	update_head_pos(mirror, r1_bio);
 
+	async = test_bit(R1BIO_AsyncIO, &r1_bio->state);
+	if (conf->mirrors[mirror].rdev)
+		wonly = test_bit(WriteMostly, &conf->mirrors[mirror].rdev->flags);
+	/* In async mode, we ACK the master bio once the I/O has safely
+	 * reached the non-writeonly disk. Setting the AsyncPhase bit
+	 * ensures that this gets done only once -- we don't ever want to
+	 * return -EIO here, instead we'll wait */
+	if (async && !wonly && test_bit(R1BIO_Uptodate, &r1_bio->state) &&
+	    !test_and_set_bit(R1BIO_AsyncPhase, &r1_bio->state)) {
+		struct bio *mbio = r1_bio->master_bio;
+		PRINTK(KERN_DEBUG "raid1: async end write sectors %llu-%llu\n",
+			(unsigned long long) mbio->bi_sector,
+			(unsigned long long) mbio->bi_sector +
+			(mbio->bi_size >> 9) - 1);
+		bio_endio(mbio, mbio->bi_size, 0);
+	}
 	/*
 	 *
 	 * Let's see if all mirrored write operations have finished
 	 * already.
 	 */
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
+		if (async) {
+			int i = bio->bi_vcnt;
+			/* free extra copy of the data pages */
+			while (i--)
+				__free_page(bio->bi_io_vec[i].bv_page);
+		}
 		/* clear the bitmap if all writes complete successfully */
 		bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
 				r1_bio->sectors,
-				!test_bit(R1BIO_Degraded, &r1_bio->state));
+				!test_bit(R1BIO_Degraded, &r1_bio->state),
+				async);
 		md_write_end(r1_bio->mddev);
 		raid_end_bio_io(r1_bio);
 	}
@@ -553,6 +585,38 @@ static void device_barrier(conf_t *conf,
 	spin_unlock_irq(&conf->resync_lock);
 }
 
+/* duplicate the data pages for async I/O */
+static struct page **alloc_async_pages(struct bio *bio)
+{
+	int i;
+	struct bio_vec *bvec;
+	struct page **pages = kmalloc(bio->bi_vcnt * sizeof(struct page *),
+					GFP_NOIO);
+	if (unlikely(!pages))
+		goto do_sync_io;
+
+	BUG_ON(bio->bi_idx != 0);
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
+	PRINTK("%dB async alloc failed, doing sync I/O\n", bio->bi_size);
+	return NULL;
+}
+
 static int make_request(request_queue_t *q, struct bio * bio)
 {
 	mddev_t *mddev = q->queuedata;
@@ -565,6 +629,7 @@ static int make_request(request_queue_t 
 	struct bitmap *bitmap = mddev->bitmap;
 	unsigned long flags;
 	struct bio_list bl;
+	struct page **async_pages = NULL;
 
 
 	/*
@@ -668,6 +733,12 @@ static int make_request(request_queue_t 
 		set_bit(R1BIO_Degraded, &r1_bio->state);
 	}
 
+	/* do async I/O ? */
+	if (bitmap &&
+	    atomic_read(&bitmap->async_writes) < bitmap->async_max_writes &&
+	    (async_pages = alloc_async_pages(bio)))
+		set_bit(R1BIO_AsyncIO, &r1_bio->state);
+
 	atomic_set(&r1_bio->remaining, 0);
 
 	bio_list_init(&bl);
@@ -685,19 +756,30 @@ static int make_request(request_queue_t 
 		mbio->bi_rw = WRITE;
 		mbio->bi_private = r1_bio;
 
+		if (test_bit(R1BIO_AsyncIO, &r1_bio->state)) {
+			struct bio_vec *bvec;
+			int j;
+
+			BUG_ON(!async_pages);
+			bio_for_each_segment(bvec, mbio, j)
+				bvec->bv_page = async_pages[j];
+		}
+
 		atomic_inc(&r1_bio->remaining);
 
 		bio_list_add(&bl, mbio);
 	}
+	kfree(async_pages); /* the async pages are attached to the bios now */
 
-	bitmap_startwrite(bitmap, bio->bi_sector, r1_bio->sectors);
+	bitmap_startwrite(bitmap, bio->bi_sector, r1_bio->sectors,
+				test_bit(R1BIO_AsyncIO, &r1_bio->state));
 	spin_lock_irqsave(&conf->device_lock, flags);
 	bio_list_merge(&conf->pending_bio_list, &bl);
 	bio_list_init(&bl);
 
 	blk_plug_device(mddev->queue);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
-	
+
 #if 0
 	while ((bio = bio_list_pop(&bl)) != NULL) 
 		generic_make_request(bio);
@@ -1458,6 +1540,17 @@ out:
 static int stop(mddev_t *mddev)
 {
 	conf_t *conf = mddev_to_conf(mddev);
+	struct bitmap *bitmap = mddev->bitmap;
+	int async_wait = 0;
+
+	/* wait for async writes to complete */
+	while (bitmap && atomic_read(&bitmap->async_writes) > 0) {
+		async_wait++;
+		printk(KERN_INFO "raid1: async writes in progress on device %s, waiting to stop (%d)\n", mdname(mddev), async_wait);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(HZ); /* wait a second */
+		/* need to kick something here to make sure I/O goes? */
+	}
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
diff -purN --exclude core --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug-bitmap-bug-fix/include/linux/raid/raid1.h linux-2.6.11-rc3-mm2-patch-all-write-mostly-async-write-bitmap-bug-fix/include/linux/raid/raid1.h
--- linux-2.6.11-rc3-mm2-patch-all-write-mostly-max-dev-bug-bitmap-bug-fix/include/linux/raid/raid1.h	Fri Feb 18 14:45:25 2005
+++ linux-2.6.11-rc3-mm2-patch-all-write-mostly-async-write-bitmap-bug-fix/include/linux/raid/raid1.h	Mon Feb 21 16:48:38 2005
@@ -107,4 +107,6 @@ struct r1bio_s {
 #define	R1BIO_Uptodate	0
 #define	R1BIO_IsSync	1
 #define	R1BIO_Degraded	2
+#define R1BIO_AsyncPhase 3
+#define R1BIO_AsyncIO   4
 #endif

--------------040105060509000204040704--
