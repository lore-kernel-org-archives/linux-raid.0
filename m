From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 10/10] md/raid0: fix up bio splitting.
Date: Wed, 05 Apr 2017 14:05:51 +1000
Message-ID: <149136515150.25893.9512649775088850695.stgit@noble>
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

raid0_make_request() should use a private bio_set rather than the
shared fs_bio_set, which is only meant for filesystems to use.

raid0_make_request() shouldn't loop around using the bio_set
multiple times as that can deadlock.

So use mddev->bio_set and pass the tail to generic_make_request()
instead of looping on it.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid0.c |   73 ++++++++++++++++++++++++++--------------------------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 56f70c3ad37c..e777e48f55f6 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -462,52 +462,53 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct strip_zone *zone;
 	struct md_rdev *tmp_dev;
-	struct bio *split;
+	sector_t bio_sector;
+	sector_t sector;
+	unsigned chunk_sects;
+	unsigned sectors;
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
 	}
 
-	do {
-		sector_t bio_sector = bio->bi_iter.bi_sector;
-		sector_t sector = bio_sector;
-		unsigned chunk_sects = mddev->chunk_sectors;
+	bio_sector = bio->bi_iter.bi_sector;
+	sector = bio_sector;
+	chunk_sects = mddev->chunk_sectors;
 
-		unsigned sectors = chunk_sects -
-			(likely(is_power_of_2(chunk_sects))
-			 ? (sector & (chunk_sects-1))
-			 : sector_div(sector, chunk_sects));
+	sectors = chunk_sects -
+		(likely(is_power_of_2(chunk_sects))
+		 ? (sector & (chunk_sects-1))
+		 : sector_div(sector, chunk_sects));
 
-		/* Restore due to sector_div */
-		sector = bio_sector;
+	/* Restore due to sector_div */
+	sector = bio_sector;
 
-		if (sectors < bio_sectors(bio)) {
-			split = bio_split(bio, sectors, GFP_NOIO, fs_bio_set);
-			bio_chain(split, bio);
-		} else {
-			split = bio;
-		}
+	if (sectors < bio_sectors(bio)) {
+		struct bio *split = bio_split(bio, sectors, GFP_NOIO, mddev->bio_set);
+		bio_chain(split, bio);
+		generic_make_request(bio);
+		bio = split;
+	}
 
-		zone = find_zone(mddev->private, &sector);
-		tmp_dev = map_sector(mddev, zone, sector, &sector);
-		split->bi_bdev = tmp_dev->bdev;
-		split->bi_iter.bi_sector = sector + zone->dev_start +
-			tmp_dev->data_offset;
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
+	zone = find_zone(mddev->private, &sector);
+	tmp_dev = map_sector(mddev, zone, sector, &sector);
+	bio->bi_bdev = tmp_dev->bdev;
+	bio->bi_iter.bi_sector = sector + zone->dev_start +
+		tmp_dev->data_offset;
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
 }
 
 static void raid0_status(struct seq_file *seq, struct mddev *mddev)


