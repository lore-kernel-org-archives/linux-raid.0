From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/10] raid5-cache: port to 4.3-rc
Date: Mon,  7 Sep 2015 07:20:41 +0200
Message-ID: <1441603250-5119-2-git-send-email-hch@lst.de>
References: <1441603250-5119-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1441603250-5119-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Port for changes in the block layer:  bio endio callers don't get passed
a separate error, and bio_get_nr_vecs is gone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 785749b1..c345479 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -222,7 +222,8 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
 }
 
-static inline void r5l_log_endio(struct bio *bio, int error)
+/* XXX: totally ignores I/O errors */
+static void r5l_log_endio(struct bio *bio)
 {
 	struct r5l_io_unit *io = bio->bi_private;
 	struct r5l_log *log = io->log;
@@ -288,8 +289,7 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	io->meta_offset = sizeof(struct r5l_meta_block);
 	io->seq = log->seq;
 
-	bio = bio_kmalloc(GFP_NOIO | __GFP_NOFAIL,
-		bio_get_nr_vecs(log->rdev->bdev));
+	bio = bio_kmalloc(GFP_NOIO | __GFP_NOFAIL, BIO_MAX_PAGES);
 	io->current_bio = bio;
 	bio->bi_rw = WRITE;
 	bio->bi_bdev = log->rdev->bdev;
@@ -358,8 +358,7 @@ static void r5l_append_payload_page(struct r5l_log *log, struct page *page)
 alloc_bio:
 	if (!io->current_bio) {
 		struct bio *bio;
-		bio = bio_kmalloc(GFP_NOIO | __GFP_NOFAIL,
-			bio_get_nr_vecs(log->rdev->bdev));
+		bio = bio_kmalloc(GFP_NOIO | __GFP_NOFAIL, BIO_MAX_PAGES);
 		bio->bi_rw = WRITE;
 		bio->bi_bdev = log->rdev->bdev;
 		bio->bi_iter.bi_sector = log->log_start;
@@ -518,7 +517,7 @@ int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
 	 * don't need to flush again
 	 * */
 	if (bio->bi_iter.bi_size == 0) {
-		bio_endio(bio, 0);
+		bio_endio(bio);
 		return 0;
 	}
 	bio->bi_rw &= ~REQ_FLUSH;
@@ -581,7 +580,7 @@ void r5l_stripe_write_finished(struct stripe_head *sh)
 		__r5l_stripe_write_finished(io);
 }
 
-static void r5l_log_flush_endio(struct bio *bio, int error)
+static void r5l_log_flush_endio(struct bio *bio)
 {
 	struct r5l_log *log = container_of(bio, struct r5l_log,
 		flush_bio);
-- 
1.9.1

