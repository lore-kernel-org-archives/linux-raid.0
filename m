From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v3 10/14] md: raid1: improve write behind
Date: Fri, 17 Mar 2017 00:12:31 +0800
Message-ID: <20170316161235.27110-11-tom.leiming@gmail.com>
References: <20170316161235.27110-1-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170316161235.27110-1-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

This patch improve handling of write behind in the following ways:

- introduce behind master bio to hold all write behind pages
- fast clone bios from behind master bio
- avoid to change bvec table directly
- use bio_copy_data() and make code more clean

Suggested-by: Shaohua Li <shli@fb.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c | 118 ++++++++++++++++++++++++-----------------------------
 drivers/md/raid1.h |  10 +++--
 2 files changed, 61 insertions(+), 67 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2f3622c695ce..3c13286190c1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -405,12 +405,9 @@ static void close_write(struct r1bio *r1_bio)
 {
 	/* it really is the end of this request */
 	if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
-		/* free extra copy of the data pages */
-		int i = r1_bio->behind_page_count;
-		while (i--)
-			safe_put_page(r1_bio->behind_bvecs[i].bv_page);
-		kfree(r1_bio->behind_bvecs);
-		r1_bio->behind_bvecs = NULL;
+		bio_free_pages(r1_bio->behind_master_bio);
+		bio_put(r1_bio->behind_master_bio);
+		r1_bio->behind_master_bio = NULL;
 	}
 	/* clear the bitmap if all writes complete successfully */
 	bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
@@ -512,6 +509,10 @@ static void raid1_end_write_request(struct bio *bio)
 	}
 
 	if (behind) {
+		/* we release behind master bio when all write are done */
+		if (r1_bio->behind_master_bio == bio)
+			to_put = NULL;
+
 		if (test_bit(WriteMostly, &rdev->flags))
 			atomic_dec(&r1_bio->behind_remaining);
 
@@ -1096,39 +1097,46 @@ static void unfreeze_array(struct r1conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
-/* duplicate the data pages for behind I/O
- */
-static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
+static struct bio *alloc_behind_master_bio(struct r1bio *r1_bio,
+					   struct bio *bio,
+					   int offset, int size)
 {
-	int i;
-	struct bio_vec *bvec;
-	struct bio_vec *bvecs = kzalloc(bio->bi_vcnt * sizeof(struct bio_vec),
-					GFP_NOIO);
-	if (unlikely(!bvecs))
-		return;
+	unsigned vcnt = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	int i = 0;
+	struct bio *behind_bio = NULL;
+
+	behind_bio = bio_alloc_mddev(GFP_NOIO, vcnt, r1_bio->mddev);
+	if (!behind_bio)
+		goto fail;
+
+	while (i < vcnt && size) {
+		struct page *page;
+		int len = min_t(int, PAGE_SIZE, size);
+
+		page = alloc_page(GFP_NOIO);
+		if (unlikely(!page))
+			goto free_pages;
+
+		bio_add_page(behind_bio, page, len, 0);
+
+		size -= len;
+		i++;
+	}
 
-	bio_for_each_segment_all(bvec, bio, i) {
-		bvecs[i] = *bvec;
-		bvecs[i].bv_page = alloc_page(GFP_NOIO);
-		if (unlikely(!bvecs[i].bv_page))
-			goto do_sync_io;
-		memcpy(kmap(bvecs[i].bv_page) + bvec->bv_offset,
-		       kmap(bvec->bv_page) + bvec->bv_offset, bvec->bv_len);
-		kunmap(bvecs[i].bv_page);
-		kunmap(bvec->bv_page);
-	}
-	r1_bio->behind_bvecs = bvecs;
-	r1_bio->behind_page_count = bio->bi_vcnt;
+	bio_copy_data_partial(behind_bio, bio, offset,
+			      behind_bio->bi_iter.bi_size);
+
+	r1_bio->behind_master_bio = behind_bio;;
 	set_bit(R1BIO_BehindIO, &r1_bio->state);
-	return;
 
-do_sync_io:
-	for (i = 0; i < bio->bi_vcnt; i++)
-		if (bvecs[i].bv_page)
-			put_page(bvecs[i].bv_page);
-	kfree(bvecs);
+	return behind_bio;
+
+ free_pages:
 	pr_debug("%dB behind alloc failed, doing sync I/O\n",
 		 bio->bi_iter.bi_size);
+	bio_free_pages(behind_bio);
+ fail:
+	return behind_bio;
 }
 
 struct raid1_plug_cb {
@@ -1499,11 +1507,9 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 			    (atomic_read(&bitmap->behind_writes)
 			     < mddev->bitmap_info.max_write_behind) &&
 			    !waitqueue_active(&bitmap->behind_wait)) {
-				mbio = bio_clone_bioset_partial(bio, GFP_NOIO,
-								mddev->bio_set,
-								offset << 9,
-								max_sectors << 9);
-				alloc_behind_pages(mbio, r1_bio);
+				mbio = alloc_behind_master_bio(r1_bio, bio,
+							       offset << 9,
+							       max_sectors << 9);
 			}
 
 			bitmap_startwrite(bitmap, r1_bio->sector,
@@ -1514,26 +1520,17 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 		}
 
 		if (!mbio) {
-			if (r1_bio->behind_bvecs)
-				mbio = bio_clone_bioset_partial(bio, GFP_NOIO,
-								mddev->bio_set,
-								offset << 9,
-								max_sectors << 9);
+			if (r1_bio->behind_master_bio)
+				mbio = bio_clone_fast(r1_bio->behind_master_bio,
+						      GFP_NOIO,
+						      mddev->bio_set);
 			else {
 				mbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
 				bio_trim(mbio, offset, max_sectors);
 			}
 		}
 
-		if (r1_bio->behind_bvecs) {
-			struct bio_vec *bvec;
-			int j;
-
-			/*
-			 * We trimmed the bio, so _all is legit
-			 */
-			bio_for_each_segment_all(bvec, mbio, j)
-				bvec->bv_page = r1_bio->behind_bvecs[j].bv_page;
+		if (r1_bio->behind_master_bio) {
 			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
 				atomic_inc(&r1_bio->behind_remaining);
 		}
@@ -2405,18 +2402,11 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 		/* Write at 'sector' for 'sectors'*/
 
 		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
-			unsigned vcnt = r1_bio->behind_page_count;
-			struct bio_vec *vec = r1_bio->behind_bvecs;
-
-			while (!vec->bv_page) {
-				vec++;
-				vcnt--;
-			}
-
-			wbio = bio_alloc_mddev(GFP_NOIO, vcnt, mddev);
-			memcpy(wbio->bi_io_vec, vec, vcnt * sizeof(struct bio_vec));
-
-			wbio->bi_vcnt = vcnt;
+			wbio = bio_clone_fast(r1_bio->behind_master_bio,
+					      GFP_NOIO,
+					      mddev->bio_set);
+			/* We really need a _all clone */
+			wbio->bi_iter = (struct bvec_iter){ 0 };
 		} else {
 			wbio = bio_clone_fast(r1_bio->master_bio, GFP_NOIO,
 					      mddev->bio_set);
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index dd22a37d0d83..4271cd7ac2de 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -153,9 +153,13 @@ struct r1bio {
 	int			read_disk;
 
 	struct list_head	retry_list;
-	/* Next two are only valid when R1BIO_BehindIO is set */
-	struct bio_vec		*behind_bvecs;
-	int			behind_page_count;
+
+	/*
+	 * When R1BIO_BehindIO is set, we store pages for write behind
+	 * in behind_master_bio.
+	 */
+	struct bio		*behind_master_bio;
+
 	/*
 	 * if the IO is in WRITE direction, then multiple bios are used.
 	 * We choose the number when they are allocated.
-- 
2.9.3

