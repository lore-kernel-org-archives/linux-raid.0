From: Ming Lin <mlin@kernel.org>
Subject: [PATCH v6 07/11] md/raid5: get rid of bio_fits_rdev()
Date: Wed, 12 Aug 2015 00:07:17 -0700
Message-ID: <1439363241-31772-8-git-send-email-mlin@kernel.org>
References: <1439363241-31772-1-git-send-email-mlin@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439363241-31772-1-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Lin <mlin@kernel.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Ming Lin <ming.l@ssi.samsung.com>
List-Id: linux-raid.ids

From: Kent Overstreet <kent.overstreet@gmail.com>

Remove bio_fits_rdev() as sufficient merge_bvec_fn() handling is now
performed by blk_queue_split() in md_make_request().

Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dpark@posteo.net>
Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
---
 drivers/md/raid5.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d572639..7ce3252 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4787,25 +4787,6 @@ static void raid5_align_endio(struct bio *bi, int error)
 	add_bio_to_retry(raid_bi, conf);
 }
 
-static int bio_fits_rdev(struct bio *bi)
-{
-	struct request_queue *q = bdev_get_queue(bi->bi_bdev);
-
-	if (bio_sectors(bi) > queue_max_sectors(q))
-		return 0;
-	blk_recount_segments(q, bi);
-	if (bi->bi_phys_segments > queue_max_segments(q))
-		return 0;
-
-	if (q->merge_bvec_fn)
-		/* it's too hard to apply the merge_bvec_fn at this stage,
-		 * just just give up
-		 */
-		return 0;
-
-	return 1;
-}
-
 static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 {
 	struct r5conf *conf = mddev->private;
@@ -4859,11 +4840,9 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 		align_bi->bi_bdev =  rdev->bdev;
 		__clear_bit(BIO_SEG_VALID, &align_bi->bi_flags);
 
-		if (!bio_fits_rdev(align_bi) ||
-		    is_badblock(rdev, align_bi->bi_iter.bi_sector,
+		if (is_badblock(rdev, align_bi->bi_iter.bi_sector,
 				bio_sectors(align_bi),
 				&first_bad, &bad_sectors)) {
-			/* too big in some way, or has a known bad block */
 			bio_put(align_bi);
 			rdev_dec_pending(rdev, mddev);
 			return 0;
-- 
2.1.4
