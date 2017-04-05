From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 09/10] md/linear: improve bio splitting.
Date: Wed, 05 Apr 2017 14:05:51 +1000
Message-ID: <149136515137.25893.12381990673581871748.stgit@noble>
References: <149136485390.25893.1797855041954158826.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149136485390.25893.1797855041954158826.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

linear_make_request() uses fs_bio_set, which is meant for filesystems
to use, and loops, possible allocating  from the same bio set multiple
times.
These behaviors can theoretically cause deadlocks, though as
linear requests are hardly ever split, it is unlikely in practice.

Change to use mddev->bio_set - otherwise unused for linear, and submit
the tail of a split request to generic_make_request() for it to
handle.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/linear.c |   75 ++++++++++++++++++++++++---------------------------
 1 file changed, 36 insertions(+), 39 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 3e38e0207a3e..d67105a15a39 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -249,53 +249,50 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 {
 	char b[BDEVNAME_SIZE];
 	struct dev_info *tmp_dev;
-	struct bio *split;
 	sector_t start_sector, end_sector, data_offset;
+	sector_t bio_sector = bio->bi_iter.bi_sector;
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
 	}
 
-	do {
-		sector_t bio_sector = bio->bi_iter.bi_sector;
-		tmp_dev = which_dev(mddev, bio_sector);
-		start_sector = tmp_dev->end_sector - tmp_dev->rdev->sectors;
-		end_sector = tmp_dev->end_sector;
-		data_offset = tmp_dev->rdev->data_offset;
-		bio->bi_bdev = tmp_dev->rdev->bdev;
-
-		if (unlikely(bio_sector >= end_sector ||
-			     bio_sector < start_sector))
-			goto out_of_bounds;
-
-		if (unlikely(bio_end_sector(bio) > end_sector)) {
-			/* This bio crosses a device boundary, so we have to
-			 * split it.
-			 */
-			split = bio_split(bio, end_sector - bio_sector,
-					  GFP_NOIO, fs_bio_set);
-			bio_chain(split, bio);
-		} else {
-			split = bio;
-		}
+	tmp_dev = which_dev(mddev, bio_sector);
+	start_sector = tmp_dev->end_sector - tmp_dev->rdev->sectors;
+	end_sector = tmp_dev->end_sector;
+	data_offset = tmp_dev->rdev->data_offset;
+
+	if (unlikely(bio_sector >= end_sector ||
+		     bio_sector < start_sector))
+		goto out_of_bounds;
+
+	if (unlikely(bio_end_sector(bio) > end_sector)) {
+		/* This bio crosses a device boundary, so we have to
+		 * split it.
+		 */
+		struct bio *split = bio_split(bio, end_sector - bio_sector,
+					      GFP_NOIO, mddev->bio_set);
+		bio_chain(split, bio);
+		generic_make_request(bio);
+		bio = split;
+	}
 
-		split->bi_iter.bi_sector = split->bi_iter.bi_sector -
-			start_sector + data_offset;
-
-		if (unlikely((bio_op(split) == REQ_OP_DISCARD) &&
-			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
-			/* Just ignore it */
-			bio_endio(split);
-		} else {
-			if (mddev->gendisk)
-				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
-						      split, disk_devt(mddev->gendisk),
-						      bio_sector);
-			mddev_check_writesame(mddev, split);
-			generic_make_request(split);
-		}
-	} while (split != bio);
+	bio->bi_bdev = tmp_dev->rdev->bdev;
+	bio->bi_iter.bi_sector = bio->bi_iter.bi_sector -
+		start_sector + data_offset;
+
+	if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
+		     !blk_queue_discard(bdev_get_queue(bio->bi_bdev)))) {
+		/* Just ignore it */
+		bio_endio(bio);
+	} else {
+		if (mddev->gendisk)
+			trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
+					      bio, disk_devt(mddev->gendisk),
+					      bio_sector);
+		mddev_check_writesame(mddev, bio);
+		generic_make_request(bio);
+	}
 	return;
 
 out_of_bounds:


