From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/16] md/raid1: improve handling of pages allocated for
 write-behind.
Date: Wed, 11 May 2011 16:30:31 +1000
Message-ID: <20110511063031.21263.12794.stgit@notabene.brown>
References: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511062743.21263.72802.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The current handling and freeing of these pages is a bit fragile.
We only keep the list of allocated pages in each bio, so we need to
still have a valid bio when freeing the pages, which is a bit clumsy.

So simply store the allocated page list in the r1_bio so it can easily
be found and freed when we are finished with the r1_bio.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   55 +++++++++++++++++++++++++---------------------------
 drivers/md/raid1.h |    4 +++-
 2 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b9d6da1..779abbd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -297,23 +297,24 @@ static void raid1_end_read_request(struct bio *bio, int error)
 	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
 }
 
-static void r1_bio_write_done(r1bio_t *r1_bio, int vcnt, struct bio_vec *bv,
-			      int behind)
+static void r1_bio_write_done(r1bio_t *r1_bio)
 {
 	if (atomic_dec_and_test(&r1_bio->remaining))
 	{
 		/* it really is the end of this request */
 		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
 			/* free extra copy of the data pages */
-			int i = vcnt;
+			int i = r1_bio->behind_page_count;
 			while (i--)
-				safe_put_page(bv[i].bv_page);
+				safe_put_page(r1_bio->behind_pages[i]);
+			kfree(r1_bio->behind_pages);
+			r1_bio->behind_pages = NULL;
 		}
 		/* clear the bitmap if all writes complete successfully */
 		bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
 				r1_bio->sectors,
 				!test_bit(R1BIO_Degraded, &r1_bio->state),
-				behind);
+				test_bit(R1BIO_BehindIO, &r1_bio->state));
 		md_write_end(r1_bio->mddev);
 		raid_end_bio_io(r1_bio);
 	}
@@ -386,7 +387,7 @@ static void raid1_end_write_request(struct bio *bio, int error)
 	 * Let's see if all mirrored write operations have finished
 	 * already.
 	 */
-	r1_bio_write_done(r1_bio, bio->bi_vcnt, bio->bi_io_vec, behind);
+	r1_bio_write_done(r1_bio);
 
 	if (to_put)
 		bio_put(to_put);
@@ -660,37 +661,36 @@ static void unfreeze_array(conf_t *conf)
 
 
 /* duplicate the data pages for behind I/O 
- * We return a list of bio_vec rather than just page pointers
- * as it makes freeing easier
  */
-static struct bio_vec *alloc_behind_pages(struct bio *bio)
+static void alloc_behind_pages(struct bio *bio, r1bio_t *r1_bio)
 {
 	int i;
 	struct bio_vec *bvec;
-	struct bio_vec *pages = kzalloc(bio->bi_vcnt * sizeof(struct bio_vec),
+	struct page **pages = kzalloc(bio->bi_vcnt * sizeof(struct page*),
 					GFP_NOIO);
 	if (unlikely(!pages))
-		goto do_sync_io;
+		return;
 
 	bio_for_each_segment(bvec, bio, i) {
-		pages[i].bv_page = alloc_page(GFP_NOIO);
-		if (unlikely(!pages[i].bv_page))
+		pages[i] = alloc_page(GFP_NOIO);
+		if (unlikely(!pages[i]))
 			goto do_sync_io;
-		memcpy(kmap(pages[i].bv_page) + bvec->bv_offset,
+		memcpy(kmap(pages[i]) + bvec->bv_offset,
 			kmap(bvec->bv_page) + bvec->bv_offset, bvec->bv_len);
-		kunmap(pages[i].bv_page);
+		kunmap(pages[i]);
 		kunmap(bvec->bv_page);
 	}
-
-	return pages;
+	r1_bio->behind_pages = pages;
+	r1_bio->behind_page_count = bio->bi_vcnt;
+	set_bit(R1BIO_BehindIO, &r1_bio->state);
+	return;
 
 do_sync_io:
-	if (pages)
-		for (i = 0; i < bio->bi_vcnt && pages[i].bv_page; i++)
-			put_page(pages[i].bv_page);
+	for (i = 0; i < bio->bi_vcnt; i++)
+		if (pages[i])
+			put_page(pages[i]);
 	kfree(pages);
 	PRINTK("%dB behind alloc failed, doing sync I/O\n", bio->bi_size);
-	return NULL;
 }
 
 static int make_request(mddev_t *mddev, struct bio * bio)
@@ -702,7 +702,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	int i, targets = 0, disks;
 	struct bitmap *bitmap;
 	unsigned long flags;
-	struct bio_vec *behind_pages = NULL;
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
@@ -855,9 +854,8 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	if (bitmap &&
 	    (atomic_read(&bitmap->behind_writes)
 	     < mddev->bitmap_info.max_write_behind) &&
-	    !waitqueue_active(&bitmap->behind_wait) &&
-	    (behind_pages = alloc_behind_pages(bio)) != NULL)
-		set_bit(R1BIO_BehindIO, &r1_bio->state);
+	    !waitqueue_active(&bitmap->behind_wait))
+		alloc_behind_pages(bio, r1_bio);
 
 	atomic_set(&r1_bio->remaining, 1);
 	atomic_set(&r1_bio->behind_remaining, 0);
@@ -878,7 +876,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		mbio->bi_rw = WRITE | do_flush_fua | do_sync;
 		mbio->bi_private = r1_bio;
 
-		if (behind_pages) {
+		if (r1_bio->behind_pages) {
 			struct bio_vec *bvec;
 			int j;
 
@@ -890,7 +888,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 			 * them all
 			 */
 			__bio_for_each_segment(bvec, mbio, j, 0)
-				bvec->bv_page = behind_pages[j].bv_page;
+				bvec->bv_page = r1_bio->behind_pages[j];
 			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
 				atomic_inc(&r1_bio->behind_remaining);
 		}
@@ -900,8 +898,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		bio_list_add(&conf->pending_bio_list, mbio);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
-	r1_bio_write_done(r1_bio, bio->bi_vcnt, behind_pages, behind_pages != NULL);
-	kfree(behind_pages); /* the behind pages are attached to the bios now */
+	r1_bio_write_done(r1_bio);
 
 	/* In case raid1d snuck in to freeze_array */
 	wake_up(&conf->wait_barrier);
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index cbfdf1a..5fc4ca1 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -94,7 +94,9 @@ struct r1bio_s {
 	int			read_disk;
 
 	struct list_head	retry_list;
-	struct bitmap_update	*bitmap_update;
+	/* Next two are only valid when R1BIO_BehindIO is set */
+	struct page		**behind_pages;
+	int			behind_page_count;
 	/*
 	 * if the IO is in WRITE direction, then multiple bios are used.
 	 * We choose the number when they are allocated.


