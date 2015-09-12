From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/12] raid5-cache: use bio chaining
Date: Sat, 12 Sep 2015 08:17:18 +0200
Message-ID: <1442038638-6947-13-git-send-email-hch@lst.de>
References: <1442038638-6947-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1442038638-6947-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Simplify the bio completion handler by using bio chaining and submitting
bios as soon as they are full.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 858bfcf..50ffc9b 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -98,8 +98,6 @@ struct r5l_io_unit {
 	struct page *meta_page; /* store meta block */
 	int meta_offset; /* current offset in meta_page */
 
-	struct bio_list bios;
-	atomic_t pending_io; /* pending bios not written to log yet */
 	struct bio *current_bio; /* current_bio accepting new data */
 
 	atomic_t pending_stripe; /* how many stripes not flushed to raid */
@@ -110,6 +108,7 @@ struct r5l_io_unit {
 	struct list_head stripe_list; /* stripes added to the io_unit */
 
 	int state;
+	bool need_split_bio;
 };
 
 /* r5l_io_unit state */
@@ -213,9 +212,6 @@ static void r5l_log_endio(struct bio *bio)
 
 	bio_put(bio);
 
-	if (!atomic_dec_and_test(&io->pending_io))
-		return;
-
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
 	if (log->use_fua)
@@ -233,7 +229,6 @@ static void r5l_submit_current_io(struct r5l_log *log)
 {
 	struct r5l_io_unit *io = log->current_io;
 	struct r5l_meta_block *block;
-	struct bio *bio;
 	unsigned long flags;
 	u32 crc;
 
@@ -250,22 +245,17 @@ static void r5l_submit_current_io(struct r5l_log *log)
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_START);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 
-	while ((bio = bio_list_pop(&io->bios)))
-		submit_bio(WRITE | (log->use_fua ? REQ_FUA : 0), bio);
+	submit_bio(WRITE | (log->use_fua ? REQ_FUA : 0), io->current_bio);
 }
 
-static struct bio *r5l_bio_alloc(struct r5l_log *log, struct r5l_io_unit *io)
+static struct bio *r5l_bio_alloc(struct r5l_log *log)
 {
 	struct bio *bio = bio_kmalloc(GFP_NOIO | __GFP_NOFAIL, BIO_MAX_PAGES);
 
 	bio->bi_rw = WRITE;
 	bio->bi_bdev = log->rdev->bdev;
 	bio->bi_iter.bi_sector = log->rdev->data_offset + log->log_start;
-	bio->bi_end_io = r5l_log_endio;
-	bio->bi_private = io;
 
-	bio_list_add(&io->bios, bio);
-	atomic_inc(&io->pending_io);
 	return bio;
 }
 
@@ -281,7 +271,7 @@ static void r5_reserve_log_entry(struct r5l_log *log, struct r5l_io_unit *io)
 	 * of BLOCK_SECTORS.
 	 */
 	if (log->log_start == 0)
-		io->current_bio = NULL;
+		io->need_split_bio = true;
 
 	io->log_end = log->log_start;
 }
@@ -294,7 +284,6 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	/* We can't handle memory allocate failure so far */
 	io = kmem_cache_zalloc(log->io_kc, GFP_NOIO | __GFP_NOFAIL);
 	io->log = log;
-	bio_list_init(&io->bios);
 	INIT_LIST_HEAD(&io->log_sibling);
 	INIT_LIST_HEAD(&io->stripe_list);
 	io->state = IO_UNIT_RUNNING;
@@ -310,7 +299,9 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	io->meta_offset = sizeof(struct r5l_meta_block);
 	io->seq = log->seq++;
 
-	io->current_bio = r5l_bio_alloc(log, io);
+	io->current_bio = r5l_bio_alloc(log);
+	io->current_bio->bi_end_io = r5l_log_endio;
+	io->current_bio->bi_private = io;
 	bio_add_page(io->current_bio, io->meta_page, PAGE_SIZE, 0);
 
 	r5_reserve_log_entry(log, io);
@@ -358,15 +349,18 @@ static void r5l_append_payload_page(struct r5l_log *log, struct page *page)
 {
 	struct r5l_io_unit *io = log->current_io;
 
-alloc_bio:
-	if (!io->current_bio) 
-		io->current_bio = r5l_bio_alloc(log, io);
+	if (io->need_split_bio) {
+		struct bio *prev = io->current_bio;
 
-	if (!bio_add_page(io->current_bio, page, PAGE_SIZE, 0)) {
-		io->current_bio = NULL;
-		goto alloc_bio;
+		io->current_bio = r5l_bio_alloc(log);
+		bio_chain(io->current_bio, prev);
+
+		submit_bio(WRITE | (log->use_fua ? REQ_FUA : 0), prev);
 	}
 
+	if (!bio_add_page(io->current_bio, page, PAGE_SIZE, 0))
+		BUG();
+
 	r5_reserve_log_entry(log, io);
 }
 
-- 
1.9.1

