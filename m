From: Shaohua Li <shli@fusionio.com>
Subject: [patch 1/7 v2] block: makes bio_split support bio without data
Date: Fri, 10 Aug 2012 10:51:14 +0800
Message-ID: <20120810025206.336740696@kernel.org>
References: <20120810025113.050392766@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=bio_split-fix.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, shli@kernel.org
List-Id: linux-raid.ids

discard bio hasn't data attached. We hit a BUG_ON with such bio. This makes
bio_split works for such bio.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 fs/bio.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

Index: linux/fs/bio.c
===================================================================
--- linux.orig/fs/bio.c	2012-06-01 10:10:31.626395215 +0800
+++ linux/fs/bio.c	2012-06-04 16:45:17.175941457 +0800
@@ -1500,7 +1500,7 @@ struct bio_pair *bio_split(struct bio *b
 	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
 				bi->bi_sector + first_sectors);
 
-	BUG_ON(bi->bi_vcnt != 1);
+	BUG_ON(bi->bi_vcnt != 1 && bi->bi_vcnt != 0);
 	BUG_ON(bi->bi_idx != 0);
 	atomic_set(&bp->cnt, 3);
 	bp->error = 0;
@@ -1510,17 +1510,19 @@ struct bio_pair *bio_split(struct bio *b
 	bp->bio2.bi_size -= first_sectors << 9;
 	bp->bio1.bi_size = first_sectors << 9;
 
-	bp->bv1 = bi->bi_io_vec[0];
-	bp->bv2 = bi->bi_io_vec[0];
-	bp->bv2.bv_offset += first_sectors << 9;
-	bp->bv2.bv_len -= first_sectors << 9;
-	bp->bv1.bv_len = first_sectors << 9;
+	if (bi->bi_vcnt != 0) {
+		bp->bv1 = bi->bi_io_vec[0];
+		bp->bv2 = bi->bi_io_vec[0];
+		bp->bv2.bv_offset += first_sectors << 9;
+		bp->bv2.bv_len -= first_sectors << 9;
+		bp->bv1.bv_len = first_sectors << 9;
 
-	bp->bio1.bi_io_vec = &bp->bv1;
-	bp->bio2.bi_io_vec = &bp->bv2;
+		bp->bio1.bi_io_vec = &bp->bv1;
+		bp->bio2.bi_io_vec = &bp->bv2;
 
-	bp->bio1.bi_max_vecs = 1;
-	bp->bio2.bi_max_vecs = 1;
+		bp->bio1.bi_max_vecs = 1;
+		bp->bio2.bi_max_vecs = 1;
+	}
 
 	bp->bio1.bi_end_io = bio_pair_end_1;
 	bp->bio2.bi_end_io = bio_pair_end_2;

