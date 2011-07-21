From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/36] md/raid1: store behind-write pages in bi_vecs.
Date: Thu, 21 Jul 2011 12:58:48 +1000
Message-ID: <20110721025848.8422.51169.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When performing write-behind we allocate pages to store the data
during write.
Previously we just keep a list of pages.  Now we keep a list of
bi_vec which includes offset and size.
This means that the r1bio has complete information to create a new
bio which will be needed for retrying after write errors.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   33 +++++++++++++++++----------------
 drivers/md/raid1.h |    2 +-
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6e605b2..42e815d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -327,9 +327,9 @@ static void r1_bio_write_done(r1bio_t *r1_bio)
 			/* free extra copy of the data pages */
 			int i = r1_bio->behind_page_count;
 			while (i--)
-				safe_put_page(r1_bio->behind_pages[i]);
-			kfree(r1_bio->behind_pages);
-			r1_bio->behind_pages = NULL;
+				safe_put_page(r1_bio->behind_bvecs[i].bv_page);
+			kfree(r1_bio->behind_bvecs);
+			r1_bio->behind_bvecs = NULL;
 		}
 		/* clear the bitmap if all writes complete successfully */
 		bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
@@ -748,30 +748,31 @@ static void alloc_behind_pages(struct bio *bio, r1bio_t *r1_bio)
 {
 	int i;
 	struct bio_vec *bvec;
-	struct page **pages = kzalloc(bio->bi_vcnt * sizeof(struct page*),
+	struct bio_vec *bvecs = kzalloc(bio->bi_vcnt * sizeof(struct bio_vec),
 					GFP_NOIO);
-	if (unlikely(!pages))
+	if (unlikely(!bvecs))
 		return;
 
 	bio_for_each_segment(bvec, bio, i) {
-		pages[i] = alloc_page(GFP_NOIO);
-		if (unlikely(!pages[i]))
+		bvecs[i] = *bvec;
+		bvecs[i].bv_page = alloc_page(GFP_NOIO);
+		if (unlikely(!bvecs[i].bv_page))
 			goto do_sync_io;
-		memcpy(kmap(pages[i]) + bvec->bv_offset,
-			kmap(bvec->bv_page) + bvec->bv_offset, bvec->bv_len);
-		kunmap(pages[i]);
+		memcpy(kmap(bvecs[i].bv_page) + bvec->bv_offset,
+		       kmap(bvec->bv_page) + bvec->bv_offset, bvec->bv_len);
+		kunmap(bvecs[i].bv_page);
 		kunmap(bvec->bv_page);
 	}
-	r1_bio->behind_pages = pages;
+	r1_bio->behind_bvecs = bvecs;
 	r1_bio->behind_page_count = bio->bi_vcnt;
 	set_bit(R1BIO_BehindIO, &r1_bio->state);
 	return;
 
 do_sync_io:
 	for (i = 0; i < bio->bi_vcnt; i++)
-		if (pages[i])
-			put_page(pages[i]);
-	kfree(pages);
+		if (bvecs[i].bv_page)
+			put_page(bvecs[i].bv_page);
+	kfree(bvecs);
 	PRINTK("%dB behind alloc failed, doing sync I/O\n", bio->bi_size);
 }
 
@@ -1059,7 +1060,7 @@ read_again:
 						   &r1_bio->state));
 			first_clone = 0;
 		}
-		if (r1_bio->behind_pages) {
+		if (r1_bio->behind_bvecs) {
 			struct bio_vec *bvec;
 			int j;
 
@@ -1071,7 +1072,7 @@ read_again:
 			 * them all
 			 */
 			__bio_for_each_segment(bvec, mbio, j, 0)
-				bvec->bv_page = r1_bio->behind_pages[j];
+				bvec->bv_page = r1_bio->behind_bvecs[j].bv_page;
 			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
 				atomic_inc(&r1_bio->behind_remaining);
 		}
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index f81360d..b788547 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -101,7 +101,7 @@ struct r1bio_s {
 
 	struct list_head	retry_list;
 	/* Next two are only valid when R1BIO_BehindIO is set */
-	struct page		**behind_pages;
+	struct bio_vec		*behind_bvecs;
 	int			behind_page_count;
 	/*
 	 * if the IO is in WRITE direction, then multiple bios are used.


