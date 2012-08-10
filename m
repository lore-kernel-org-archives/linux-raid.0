From: Shaohua Li <shli@fusionio.com>
Subject: [patch 3/7 v2] md: raid 0 supports TRIM
Date: Fri, 10 Aug 2012 10:51:16 +0800
Message-ID: <20120810025225.753559090@kernel.org>
References: <20120810025113.050392766@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-raid0-discard-support.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, shli@kernel.org
List-Id: linux-raid.ids

This makes md raid 0 support TRIM.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid0.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Index: linux/drivers/md/raid0.c
===================================================================
--- linux.orig/drivers/md/raid0.c	2012-06-06 09:35:56.446256044 +0800
+++ linux/drivers/md/raid0.c	2012-08-10 07:09:02.504164114 +0800
@@ -88,6 +88,7 @@ static int create_strip_zones(struct mdd
 	char b[BDEVNAME_SIZE];
 	char b2[BDEVNAME_SIZE];
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+	bool discard_supported = false;
 
 	if (!conf)
 		return -ENOMEM;
@@ -195,6 +196,9 @@ static int create_strip_zones(struct mdd
 		if (!smallest || (rdev1->sectors < smallest->sectors))
 			smallest = rdev1;
 		cnt++;
+
+		if (blk_queue_discard(bdev_get_queue(rdev1->bdev)))
+			discard_supported = true;
 	}
 	if (cnt != mddev->raid_disks) {
 		printk(KERN_ERR "md/raid0:%s: too few disks (%d of %d) - "
@@ -272,6 +276,11 @@ static int create_strip_zones(struct mdd
 	blk_queue_io_opt(mddev->queue,
 			 (mddev->chunk_sectors << 9) * mddev->raid_disks);
 
+	if (!discard_supported)
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+	else
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+
 	pr_debug("md/raid0:%s: done.\n", mdname(mddev));
 	*private_conf = conf;
 
@@ -422,6 +431,7 @@ static int raid0_run(struct mddev *mddev
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
+	blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
 
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
@@ -509,7 +519,7 @@ static void raid0_make_request(struct md
 		sector_t sector = bio->bi_sector;
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1 ||
+		if ((bio->bi_vcnt != 1 && bio->bi_vcnt != 0) ||
 		    bio->bi_idx != 0)
 			goto bad_map;
 		/* This is a one page bio that upper layers
@@ -535,6 +545,13 @@ static void raid0_make_request(struct md
 	bio->bi_sector = sector_offset + zone->dev_start +
 		tmp_dev->data_offset;
 
+	if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		!blk_queue_discard(bdev_get_queue(bio->bi_bdev)))) {
+		/* Just ignore it */
+		bio_endio(bio, 0);
+		return;
+	}
+
 	generic_make_request(bio);
 	return;
 

