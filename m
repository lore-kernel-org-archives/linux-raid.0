From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 8 of 22 - Discard md_make_request in favour of per-personality make_request functions.
Date: Wed, 19 Jun 2002 10:51:26 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54670.225844.172206@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



As we now have per-device queues, we don't need a common make_request
function that dispatches, we can dispatch directly.

Each *_make_request function is changed to take a request_queue_t
from which it extract the mddev that it needs, and to deduce the
"rw" flag directly from the bio.

 ----------- Diffstat output ------------
 ./drivers/md/linear.c       |   13 +++++++------
 ./drivers/md/md.c           |   14 +-------------
 ./drivers/md/multipath.c    |   16 ++++------------
 ./drivers/md/raid0.c        |    3 ++-
 ./drivers/md/raid1.c        |   15 ++++++---------
 ./drivers/md/raid5.c        |   14 ++++----------
 ./include/linux/raid/md_k.h |    2 +-
 7 files changed, 25 insertions(+), 52 deletions(-)

--- ./drivers/md/md.c	2002/06/18 03:37:06	1.7
+++ ./drivers/md/md.c	2002/06/18 04:18:33	1.8
@@ -169,18 +169,6 @@
 	mddev_map[minor].data = NULL;
 }
 
-static int md_make_request (request_queue_t *q, struct bio *bio)
-{
-	mddev_t *mddev = q->queuedata;
-
-	if (mddev && mddev->pers)
-		return mddev->pers->make_request(mddev, bio_rw(bio), bio);
-	else {
-		bio_io_error(bio);
-		return 0;
-	}
-}
-
 static int md_fail_request (request_queue_t *q, struct bio *bio)
 {
 	bio_io_error(bio);
@@ -1705,7 +1693,7 @@
 	}
 	mddev->pers = pers[pnum];
 
-	blk_queue_make_request(&mddev->queue, md_make_request);
+	blk_queue_make_request(&mddev->queue, mddev->pers->make_request);
 	mddev->queue.queuedata = mddev;
 
 	err = mddev->pers->run(mddev);
--- ./drivers/md/raid5.c	2002/06/18 03:32:06	1.5
+++ ./drivers/md/raid5.c	2002/06/18 04:18:34	1.6
@@ -1248,23 +1248,17 @@
 	spin_unlock_irq(&conf->device_lock);
 }
 
-static int make_request (mddev_t *mddev, int rw, struct bio * bi)
+static int make_request (request_queue_t *q, struct bio * bi)
 {
+	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	const unsigned int raid_disks = conf->raid_disks;
 	const unsigned int data_disks = raid_disks - 1;
 	unsigned int dd_idx, pd_idx;
 	sector_t new_sector;
 	sector_t logical_sector, last_sector;
-	int read_ahead = 0;
-
 	struct stripe_head *sh;
 
-	if (rw == READA) {
-		rw = READ;
-		read_ahead=1;
-	}
-
 	logical_sector = bi->bi_sector & ~(STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
 
@@ -1279,10 +1273,10 @@
 		PRINTK("raid5: make_request, sector %ul logical %ul\n", 
 		       new_sector, logical_sector);
 
-		sh = get_active_stripe(conf, new_sector, pd_idx, read_ahead);
+		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
 		if (sh) {
 
-			add_stripe_bio(sh, bi, dd_idx, rw);
+			add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK));
 
 			raid5_plug_device(conf);
 			handle_stripe(sh);
--- ./drivers/md/linear.c	2002/06/18 03:34:17	1.2
+++ ./drivers/md/linear.c	2002/06/18 04:18:35	1.3
@@ -1,6 +1,6 @@
 /*
    linear.c : Multiple Devices driver for Linux
-              Copyright (C) 1994-96 Marc ZYNGIER
+	      Copyright (C) 1994-96 Marc ZYNGIER
 	      <zyngier@ufr-info-p7.ibp.fr> or
 	      <maz@gloups.fdn.fr>
 
@@ -130,12 +130,13 @@
 	return 0;
 }
 
-static int linear_make_request (mddev_t *mddev, int rw, struct bio *bio)
+static int linear_make_request (request_queue_t *q, struct bio *bio)
 {
-        linear_conf_t *conf = mddev_to_conf(mddev);
-        struct linear_hash *hash;
-        dev_info_t *tmp_dev;
-        long block;
+	mddev_t *mddev = q->queuedata;
+	linear_conf_t *conf = mddev_to_conf(mddev);
+	struct linear_hash *hash;
+	dev_info_t *tmp_dev;
+	long block;
 
 	block = bio->bi_sector >> 1;
 	hash = conf->hash_table + (block / conf->smallest->size);
--- ./drivers/md/raid0.c	2002/06/18 03:34:17	1.2
+++ ./drivers/md/raid0.c	2002/06/18 04:18:35	1.3
@@ -224,8 +224,9 @@
  * Of course, those facts may not be valid anymore (and surely won't...)
  * Hey guys, there's some work out there ;-)
  */
-static int raid0_make_request (mddev_t *mddev, int rw, struct bio *bio)
+static int raid0_make_request (request_queue_t *q, struct bio *bio)
 {
+	mddev_t *mddev = q->queuedata;
 	unsigned int sect_in_chunk, chunksize_bits,  chunk_size;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	struct raid0_hash *hash;
--- ./drivers/md/raid1.c	2002/06/18 04:14:05	1.1
+++ ./drivers/md/raid1.c	2002/06/18 04:18:35	1.2
@@ -433,8 +433,9 @@
 	spin_unlock_irq(&conf->resync_lock);
 }
 
-static int make_request(mddev_t *mddev, int rw, struct bio * bio)
+static int make_request(request_queue_t *q, struct bio * bio)
 {
+	mddev_t *mddev = q->queuedata;
 	conf_t *conf = mddev_to_conf(mddev);
 	mirror_info_t *mirror;
 	r1bio_t *r1_bio;
@@ -455,20 +456,16 @@
 	 * make_request() can abort the operation when READA is being
 	 * used and no empty request is available.
 	 *
-	 * Currently, just replace the command with READ.
 	 */
-	if (rw == READA)
-		rw = READ;
-
 	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 
 	r1_bio->master_bio = bio;
 
 	r1_bio->mddev = mddev;
 	r1_bio->sector = bio->bi_sector;
-	r1_bio->cmd = rw;
+	r1_bio->cmd = bio_data_dir(bio);
 
-	if (rw == READ) {
+	if (r1_bio->cmd == READ) {
 		/*
 		 * read balancing logic:
 		 */
@@ -482,7 +479,7 @@
 		read_bio->bi_sector = r1_bio->sector;
 		read_bio->bi_bdev = mirror->bdev;
 		read_bio->bi_end_io = end_request;
-		read_bio->bi_rw = rw;
+		read_bio->bi_rw = r1_bio->cmd;
 		read_bio->bi_private = r1_bio;
 
 		generic_make_request(read_bio);
@@ -506,7 +503,7 @@
 		mbio->bi_sector	= r1_bio->sector;
 		mbio->bi_bdev = conf->mirrors[i].bdev;
 		mbio->bi_end_io	= end_request;
-		mbio->bi_rw = rw;
+		mbio->bi_rw = r1_bio->cmd;
 		mbio->bi_private = r1_bio;
 
 		sum_bios++;
--- ./drivers/md/multipath.c	2002/06/18 04:14:05	1.1
+++ ./drivers/md/multipath.c	2002/06/18 04:18:35	1.2
@@ -243,27 +243,19 @@
 	return 0;
 }
 
-static int multipath_make_request (mddev_t *mddev, int rw, struct bio * bio)
+static int multipath_make_request (request_queue_t *q, struct bio * bio)
 {
+	mddev_t *mddev = q->queuedata;
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 	struct bio *real_bio;
 	struct multipath_bh * mp_bh;
 	struct multipath_info *multipath;
 
-/*
- * make_request() can abort the operation when READA is being
- * used and no empty request is available.
- *
- * Currently, just replace the command with READ/WRITE.
- */
-	if (rw == READA)
-		rw = READ;
-
 	mp_bh = multipath_alloc_mpbh (conf);
 
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
-	mp_bh->cmd = rw;
+	mp_bh->cmd = bio_data_dir(bio);
 
 	/*
 	 * read balancing logic:
@@ -272,7 +264,7 @@
 
 	real_bio = bio_clone(bio, GFP_NOIO);
 	real_bio->bi_bdev = multipath->bdev;
-	real_bio->bi_rw = rw;
+	real_bio->bi_rw = bio_data_dir(bio);
 	real_bio->bi_end_io = multipath_end_request;
 	real_bio->bi_private = mp_bh;
 	mp_bh->bio = real_bio;
--- ./include/linux/raid/md_k.h	2002/06/18 03:34:18	1.3
+++ ./include/linux/raid/md_k.h	2002/06/18 04:18:35	1.4
@@ -221,7 +221,7 @@
 struct mdk_personality_s
 {
 	char *name;
-	int (*make_request)(mddev_t *mddev, int rw, struct bio *bio);
+	int (*make_request)(request_queue_t *q, struct bio *bio);
 	int (*run)(mddev_t *mddev);
 	int (*stop)(mddev_t *mddev);
 	int (*status)(char *page, mddev_t *mddev);
