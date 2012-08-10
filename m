From: Shaohua Li <shli@fusionio.com>
Subject: [patch 4/7 v2] md: raid 1 supports TRIM
Date: Fri, 10 Aug 2012 10:51:17 +0800
Message-ID: <20120810025236.404488152@kernel.org>
References: <20120810025113.050392766@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-raid1-discard-support.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, shli@kernel.org
List-Id: linux-raid.ids

This makes md raid 1 support TRIM.
If one disk supports discard and another not, or one has discard_zero_data and
another not, there could be inconsistent between data from such disks. But this
should not matter, discarded data is useless. This will add extra copy in rebuild
though.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-08-10 06:55:23.914455183 +0800
+++ linux/drivers/md/raid1.c	2012-08-10 07:10:53.810764795 +0800
@@ -781,7 +781,12 @@ static void flush_pending_writes(struct
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
@@ -994,6 +999,7 @@ static void make_request(struct mddev *m
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
+	const unsigned long do_discard = (bio->bi_rw & (REQ_DISCARD | REQ_SECURE));
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
 	struct raid1_plug_cb *plug = NULL;
@@ -1295,7 +1301,7 @@ read_again:
 				   conf->mirrors[i].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | do_flush_fua | do_sync;
+		mbio->bi_rw = WRITE | do_flush_fua | do_sync | do_discard;
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
@@ -1549,6 +1555,8 @@ static int raid1_add_disk(struct mddev *
 		clear_bit(Unmerged, &rdev->flags);
 	}
 	md_integrity_add_rdev(rdev, mddev);
+	if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
 	print_conf(conf);
 	return err;
 }
@@ -2783,6 +2791,7 @@ static int run(struct mddev *mddev)
 	int i;
 	struct md_rdev *rdev;
 	int ret;
+	bool discard_supported = false;
 
 	if (mddev->level != 1) {
 		printk(KERN_ERR "md/raid1:%s: raid level not set to mirroring (%d)\n",
@@ -2812,6 +2821,8 @@ static int run(struct mddev *mddev)
 			continue;
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
+		if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
+			discard_supported = true;
 	}
 
 	mddev->degraded = 0;
@@ -2846,6 +2857,11 @@ static int run(struct mddev *mddev)
 		mddev->queue->backing_dev_info.congested_fn = raid1_congested;
 		mddev->queue->backing_dev_info.congested_data = mddev;
 		blk_queue_merge_bvec(mddev->queue, raid1_mergeable_bvec);
+
+		if (discard_supported)
+			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+		else
+			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
 	}
 
 	ret =  md_integrity_register(mddev);

