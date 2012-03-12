From: Shaohua Li <shli@fusionio.com>
Subject: [patch 3/7] md: raid 0 supports TRIM
Date: Mon, 12 Mar 2012 11:04:15 +0800
Message-ID: <20120312031305.642750220@fusionio.com>
References: <20120312030412.375458948@fusionio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-raid0-discard-support.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

This makes md raid 0 support TRIM.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid0.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux/drivers/md/raid0.c
===================================================================
--- linux.orig/drivers/md/raid0.c	2012-03-09 16:56:41.133790013 +0800
+++ linux/drivers/md/raid0.c	2012-03-12 10:16:18.526610922 +0800
@@ -88,6 +88,7 @@ static int create_strip_zones(struct mdd
 	char b[BDEVNAME_SIZE];
 	char b2[BDEVNAME_SIZE];
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+	bool discard_supported = false;
 
 	if (!conf)
 		return -ENOMEM;
@@ -201,6 +202,9 @@ static int create_strip_zones(struct mdd
 		if (!smallest || (rdev1->sectors < smallest->sectors))
 			smallest = rdev1;
 		cnt++;
+
+		if (blk_queue_discard(bdev_get_queue(rdev1->bdev)))
+			discard_supported = true;
 	}
 	if (cnt != mddev->raid_disks) {
 		printk(KERN_ERR "md/raid0:%s: too few disks (%d of %d) - "
@@ -278,6 +282,11 @@ static int create_strip_zones(struct mdd
 	blk_queue_io_opt(mddev->queue,
 			 (mddev->chunk_sectors << 9) * mddev->raid_disks);
 
+	if (!discard_supported)
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+	else
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+
 	pr_debug("md/raid0:%s: done.\n", mdname(mddev));
 	*private_conf = conf;
 
@@ -348,6 +357,7 @@ static int raid0_run(struct mddev *mddev
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
+	blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
 
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
@@ -512,6 +522,13 @@ static void raid0_make_request(struct md
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
 
