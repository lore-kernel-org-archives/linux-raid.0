From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 05/12] bcache: debug: avoid to access .bi_io_vec directly
Date: Fri, 11 Nov 2016 20:05:33 +0800
Message-ID: <1478865957-25252-6-git-send-email-tom.leiming@gmail.com>
References: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Mike Christie <mchristi@redhat.com>, Guoqing Jiang <gqjiang@suse.com>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Instead we use standard iterator way to do that.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/bcache/debug.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 1c9130ae0073..06f55056aaae 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -107,8 +107,8 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 {
 	char name[BDEVNAME_SIZE];
 	struct bio *check;
-	struct bio_vec bv;
-	struct bvec_iter iter;
+	struct bio_vec bv, cbv;
+	struct bvec_iter iter, citer = { 0 };
 
 	check = bio_clone(bio, GFP_NOIO);
 	if (!check)
@@ -120,9 +120,13 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 
 	submit_bio_wait(check);
 
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
@@ -133,6 +137,7 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 				 (uint64_t) bio->bi_iter.bi_sector);
 
 		kunmap_atomic(p1);
+		bio_advance_iter(check, &citer, bv.bv_len);
 	}
 
 	bio_free_pages(check);
-- 
2.7.4
