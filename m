From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/10] raid5-cache: refactor bio allocation
Date: Mon,  7 Sep 2015 07:20:45 +0200
Message-ID: <1441603250-5119-6-git-send-email-hch@lst.de>
References: <1441603250-5119-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1441603250-5119-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Split out a helper to allocate a bio for log writes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 10ccda3..d0ad798 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -245,11 +245,25 @@ static void r5l_submit_current_io(struct r5l_log *log)
 	}
 }
 
+static struct bio *r5l_bio_alloc(struct r5l_log *log, struct r5l_io_unit *io)
+{
+	struct bio *bio = bio_kmalloc(GFP_NOIO | __GFP_NOFAIL, BIO_MAX_PAGES);
+
+	bio->bi_rw = WRITE;
+	bio->bi_bdev = log->rdev->bdev;
+	bio->bi_iter.bi_sector = log->log_start;
+	bio->bi_end_io = r5l_log_endio;
+	bio->bi_private = io;
+
+	bio_list_add(&io->bios, bio);
+	atomic_inc(&io->pending_io);
+	return bio;
+}
+
 static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 {
 	struct r5l_io_unit *io;
 	struct r5l_meta_block *block;
-	struct bio *bio;
 
 	io = r5l_alloc_io_unit(log);
 
@@ -263,17 +277,8 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	io->meta_offset = sizeof(struct r5l_meta_block);
 	io->seq = log->seq;
 
-	bio = bio_kmalloc(GFP_NOIO | __GFP_NOFAIL, BIO_MAX_PAGES);
-	io->current_bio = bio;
-	bio->bi_rw = WRITE;
-	bio->bi_bdev = log->rdev->bdev;
-	bio->bi_iter.bi_sector = log->log_start;
-	bio_add_page(bio, io->meta_page, PAGE_SIZE, 0);
-	bio->bi_end_io = r5l_log_endio;
-	bio->bi_private = io;
-
-	bio_list_add(&io->bios, bio);
-	atomic_inc(&io->pending_io);
+	io->current_bio = r5l_bio_alloc(log, io);
+	bio_add_page(io->current_bio, io->meta_page, PAGE_SIZE, 0);
 
 	log->seq++;
 	log->log_start = r5l_ring_add(log, log->log_start, BLOCK_SECTORS);
@@ -326,18 +331,9 @@ static void r5l_append_payload_page(struct r5l_log *log, struct page *page)
 	struct r5l_io_unit *io = log->current_io;
 
 alloc_bio:
-	if (!io->current_bio) {
-		struct bio *bio;
-		bio = bio_kmalloc(GFP_NOIO | __GFP_NOFAIL, BIO_MAX_PAGES);
-		bio->bi_rw = WRITE;
-		bio->bi_bdev = log->rdev->bdev;
-		bio->bi_iter.bi_sector = log->log_start;
-		bio->bi_end_io = r5l_log_endio;
-		bio->bi_private = io;
-		bio_list_add(&io->bios, bio);
-		atomic_inc(&io->pending_io);
-		io->current_bio = bio;
-	}
+	if (!io->current_bio) 
+		io->current_bio = r5l_bio_alloc(log, io);
+
 	if (!bio_add_page(io->current_bio, page, PAGE_SIZE, 0)) {
 		io->current_bio = NULL;
 		goto alloc_bio;
-- 
1.9.1

