From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 10/27] bcache: debug: avoid to access .bi_io_vec directly
Date: Tue,  5 Apr 2016 19:56:55 +0800
Message-ID: <1459857443-20611-11-git-send-email-tom.leiming@gmail.com>
References: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
	SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Instead we use standard iterator way to do that.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/bcache/debug.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 8b1f1d5..d1ad49d 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -106,8 +106,8 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 {
 	char name[BDEVNAME_SIZE];
 	struct bio *check;
-	struct bio_vec bv, *bv2;
-	struct bvec_iter iter;
+	struct bio_vec bv, cbv, *bv2;
+	struct bvec_iter iter, citer = { 0 };
 	int i;
 
 	check = bio_clone(bio, GFP_NOIO);
@@ -119,9 +119,13 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 
 	submit_bio_wait(READ_SYNC, check);
 
+	citer.bi_size = UINT_MAX;
 	bio_for_each_segment(bv, bio, iter) {
 		void *p1 = kmap_atomic(bv.bv_page);
-		void *p2 = page_address(check->bi_io_vec[iter.bi_idx].bv_page);
+		void *p2;
+
+		cbv = bio_iter_iovec(check, citer);
+		p2 = page_address(cbv.bv_page);
 
 		cache_set_err_on(memcmp(p1 + bv.bv_offset,
 					p2 + bv.bv_offset,
@@ -132,6 +136,7 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 				 (uint64_t) bio->bi_iter.bi_sector);
 
 		kunmap_atomic(p1);
+		bio_advance_iter(check, &citer, bv.bv_len);
 	}
 
 	bio_for_each_segment_all(bv2, check, i)
-- 
1.9.1
