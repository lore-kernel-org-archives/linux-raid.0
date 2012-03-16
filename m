From: Shaohua Li <shli@fusionio.com>
Subject: [patch v2 1/6] block: makes bio_split support bio without data
Date: Fri, 16 Mar 2012 15:32:14 +0800
Message-ID: <20120316073512.401277270@fusionio.com>
References: <20120316073213.656519005@fusionio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=bio_split-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, vgoyal@redhat.com, martin.petersen@oracle.com, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

discard bio hasn't data attached. We hit a BUG_ON with such bio. This makes
bio_split works for such bio.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 fs/bio.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

Index: linux/fs/bio.c
===================================================================
--- linux.orig/fs/bio.c	2012-03-09 16:56:41.203790008 +0800
+++ linux/fs/bio.c	2012-03-12 10:10:40.696612399 +0800
@@ -1492,7 +1492,7 @@ struct bio_pair *bio_split(struct bio *b
 	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
 				bi->bi_sector + first_sectors);
 
-	BUG_ON(bi->bi_vcnt != 1);
+	BUG_ON(bi->bi_vcnt != 1 && bi->bi_vcnt != 0);
 	BUG_ON(bi->bi_idx != 0);
 	atomic_set(&bp->cnt, 3);
 	bp->error = 0;
@@ -1502,17 +1502,19 @@ struct bio_pair *bio_split(struct bio *b
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
