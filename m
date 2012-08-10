From: Shaohua Li <shli@fusionio.com>
Subject: [patch 5/7 v2] md: raid 10 supports TRIM
Date: Fri, 10 Aug 2012 10:51:18 +0800
Message-ID: <20120810025245.948573105@kernel.org>
References: <20120810025113.050392766@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-raid10-discard-support.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, shli@kernel.org
List-Id: linux-raid.ids

This makes md raid 10 support TRIM.
If one disk supports discard and another not, or one has discard_zero_data and
another not, there could be inconsistent between data from such disks. But this
should not matter, discarded data is useless. This will add extra copy in rebuild
though.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid10.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

Index: linux/drivers/md/raid10.c
===================================================================
--- linux.orig/drivers/md/raid10.c	2012-08-10 06:55:23.902455333 +0800
+++ linux/drivers/md/raid10.c	2012-08-10 07:15:04.759610157 +0800
@@ -907,7 +907,12 @@ static void flush_pending_writes(struct
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
 			bio->bi_next = NULL;
-			generic_make_request(bio);
+			if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+			    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+				/* Just ignore it */
+				bio_endio(bio, 0);
+			else
+				generic_make_request(bio);
 			bio = next;
 		}
 	} else
@@ -1057,6 +1062,7 @@ static void make_request(struct mddev *m
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_fua = (bio->bi_rw & REQ_FUA);
+	const unsigned long do_discard = (bio->bi_rw & (REQ_DISCARD | REQ_SECURE));
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
 	int sectors_handled;
@@ -1077,7 +1083,7 @@ static void make_request(struct mddev *m
 			 || conf->prev.near_copies < conf->prev.raid_disks))) {
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1 ||
+		if ((bio->bi_vcnt != 1 && bio->bi_vcnt !=0) ||
 		    bio->bi_idx != 0)
 			goto bad_map;
 		/* This is a one page bio that upper layers
@@ -1406,7 +1412,7 @@ retry_write:
 						      conf->mirrors[d].rdev));
 		mbio->bi_bdev = conf->mirrors[d].rdev->bdev;
 		mbio->bi_end_io	= raid10_end_write_request;
-		mbio->bi_rw = WRITE | do_sync | do_fua;
+		mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;
 		mbio->bi_private = r10_bio;
 
 		atomic_inc(&r10_bio->remaining);
@@ -1435,7 +1441,7 @@ retry_write:
 					   conf->mirrors[d].replacement));
 		mbio->bi_bdev = conf->mirrors[d].replacement->bdev;
 		mbio->bi_end_io	= raid10_end_write_request;
-		mbio->bi_rw = WRITE | do_sync | do_fua;
+		mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;
 		mbio->bi_private = r10_bio;
 
 		atomic_inc(&r10_bio->remaining);
@@ -1719,6 +1725,9 @@ static int raid10_add_disk(struct mddev
 		clear_bit(Unmerged, &rdev->flags);
 	}
 	md_integrity_add_rdev(rdev, mddev);
+	if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+
 	print_conf(conf);
 	return err;
 }
@@ -3476,6 +3485,7 @@ static int run(struct mddev *mddev)
 	sector_t size;
 	sector_t min_offset_diff = 0;
 	int first = 1;
+	bool discard_supported = false;
 
 	if (mddev->private == NULL) {
 		conf = setup_conf(mddev);
@@ -3490,6 +3500,7 @@ static int run(struct mddev *mddev)
 	mddev->thread = conf->thread;
 	conf->thread = NULL;
 
+	blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
 	chunk_size = mddev->chunk_sectors << 9;
 	if (mddev->queue) {
 		blk_queue_io_min(mddev->queue, chunk_size);
@@ -3537,8 +3548,16 @@ static int run(struct mddev *mddev)
 					  rdev->data_offset << 9);
 
 		disk->head_position = 0;
+
+		if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
+			discard_supported = true;
 	}
 
+	if (discard_supported)
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+	else
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+
 	/* need to check that every block has at least one working mirror */
 	if (!enough(conf, -1)) {
 		printk(KERN_ERR "md/raid10:%s: not enough operational mirrors.\n",

