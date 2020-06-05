From: jeffm@suse.com
Subject: [PATCH] mdraid: fix read/write bytes accounting
Date: Fri,  5 Jun 2020 16:19:53 -0400
Message-ID: <20200605201953.11098-1-jeffm@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, song@kernel.org
Cc: nfbrown@suse.com, colyli@suse.com, Jeff Mahoney <jeffm@suse.com>
List-Id: linux-raid.ids

From: Jeff Mahoney <jeffm@suse.com>

The i/o accounting published in /proc/diskstats for mdraid is currently
broken.  md_make_request does the accounting for every bio passed but
when a bio needs to be split, all the split bios are also submitted
through md_make_request, resulting in multiple accounting.

As a result, a quick test on a RAID6 volume displayed the following
behavior:

131072+0 records in
131072+0 records out
67108864 bytes (67 MB, 64 MiB) copied, 13.9227 s, 4.8 MB/s

... shows 131072 sectors read -- 64 MiB.  Correct.

512+0 records in
512+0 records out
67108864 bytes (67 MB, 64 MiB) copied, 0.287365 s, 234 MB/s

... shows 196608 sectors read -- 96 MiB.  With a 64k stripe size, we're
seeing some splitting.

512+0 records in
512+0 records out
536870912 bytes (537 MB, 512 MiB) copied, 0.705004 s, 762 MB/s

... shows 4718624 sectors read -- 2.25 GiB transferred.  Lots of splitting
and a stats explosion.

The fix is to push the accounting into the personality make_request
callbacks so that only the bios actually submitted for I/O will be
accounted.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/md/md-faulty.c    |  1 +
 drivers/md/md-linear.c    |  1 +
 drivers/md/md-multipath.c |  1 +
 drivers/md/md.c           | 21 +++++++++++++++------
 drivers/md/md.h           |  1 +
 drivers/md/raid0.c        |  1 +
 drivers/md/raid1.c        |  3 +++
 drivers/md/raid10.c       |  3 +++
 drivers/md/raid5.c        |  3 +++
 9 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-faulty.c b/drivers/md/md-faulty.c
index 50ad4ba86f0e..25e2c72ef920 100644
--- a/drivers/md/md-faulty.c
+++ b/drivers/md/md-faulty.c
@@ -214,6 +214,7 @@ static bool faulty_make_request(struct mddev *mddev, struct bio *bio)
 	} else
 		bio_set_dev(bio, conf->rdev->bdev);
 
+	md_io_acct(mddev, bio_op(bio), bio_sectors(bio));
 	generic_make_request(bio);
 	return true;
 }
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 26c75c0199fa..ec0dbc0f1d76 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -271,6 +271,7 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 		bio = split;
 	}
 
+	md_io_acct(mddev, bio_op(bio), bio_sectors(bio));
 	bio_set_dev(bio, tmp_dev->rdev->bdev);
 	bio->bi_iter.bi_sector = bio->bi_iter.bi_sector -
 		start_sector + data_offset;
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 152f9e65a226..c3afe3f62a88 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -131,6 +131,7 @@ static bool multipath_make_request(struct mddev *mddev, struct bio * bio)
 	mp_bh->bio.bi_private = mp_bh;
 	mddev_check_writesame(mddev, &mp_bh->bio);
 	mddev_check_write_zeroes(mddev, &mp_bh->bio);
+	md_io_acct(mddev, bio_op(bio), bio_sectors(bio));
 	generic_make_request(&mp_bh->bio);
 	return true;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f567f536b529..e8078a16419b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -463,10 +463,24 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_handle_request);
 
+/*
+ * This is generic_start_io_acct without the inflight tracking.  Since
+ * we can't reliably call generic_end_io_acct, the inflight counter
+ * would also be unreliable and it's better to keep it at 0.
+ */
+void md_io_acct(struct mddev *mddev, int sgrp, unsigned int sectors)
+{
+	part_stat_lock();
+	part_stat_inc(&mddev->gendisk->part0, ios[sgrp]);
+	part_stat_add(&mddev->gendisk->part0, sectors[sgrp], sectors);
+	part_stat_unlock();
+
+}
+EXPORT_SYMBOL_GPL(md_io_acct);
+
 static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
-	const int sgrp = op_stat_group(bio_op(bio));
 	struct mddev *mddev = bio->bi_disk->private_data;
 	unsigned int sectors;
 
@@ -498,11 +512,6 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 
 	md_handle_request(mddev, bio);
 
-	part_stat_lock();
-	part_stat_inc(&mddev->gendisk->part0, ios[sgrp]);
-	part_stat_add(&mddev->gendisk->part0, sectors[sgrp], sectors);
-	part_stat_unlock();
-
 	return BLK_QC_T_NONE;
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 612814d07d35..5834427f7557 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -741,6 +741,7 @@ extern void mddev_suspend(struct mddev *mddev);
 extern void mddev_resume(struct mddev *mddev);
 extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 				   struct mddev *mddev);
+extern void md_io_acct(struct mddev *mddev, int sgrp, unsigned int sectors);
 
 extern void md_reload_sb(struct mddev *mddev, int raid_disk);
 extern void md_update_sb(struct mddev *mddev, int force);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 322386ff5d22..ac1109d1d48d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -633,6 +633,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 				disk_devt(mddev->gendisk), bio_sector);
 	mddev_check_writesame(mddev, bio);
 	mddev_check_write_zeroes(mddev, bio);
+	md_io_acct(mddev, bio_op(bio), bio_sectors(bio));
 	generic_make_request(bio);
 	return true;
 }
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index dcd27f3da84e..f0d620e2b90f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1318,6 +1318,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		r1_bio->sectors = max_sectors;
 	}
 
+	md_io_acct(mddev, bio_op(bio), bio_sectors(bio));
 	r1_bio->read_disk = rdisk;
 
 	read_bio = bio_clone_fast(bio, gfp, &mddev->bio_set);
@@ -1489,6 +1490,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		r1_bio->sectors = max_sectors;
 	}
 
+	md_io_acct(mddev, bio_op(bio), bio_sectors(bio));
+
 	atomic_set(&r1_bio->remaining, 1);
 	atomic_set(&r1_bio->behind_remaining, 0);
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ec136e44aef7..b8e8d7f67f65 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1202,6 +1202,8 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	slot = r10_bio->read_slot;
 
+	md_io_acct(mddev, bio_op(bio), bio_sectors(bio));
+
 	read_bio = bio_clone_fast(bio, gfp, &mddev->bio_set);
 
 	r10_bio->devs[slot].bio = read_bio;
@@ -1485,6 +1487,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		r10_bio->master_bio = bio;
 	}
 
+	md_io_acct(mddev, bio_op(bio), bio_sectors(bio));
 	atomic_set(&r10_bio->remaining, 1);
 	md_bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors, 0);
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ab8067f9ce8c..e57109e39fcd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5316,6 +5316,7 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 	if (!raid5_read_one_chunk(mddev, raid_bio))
 		return raid_bio;
 
+	md_io_acct(mddev, bio_op(raid_bio), bio_sectors(raid_bio));
 	return NULL;
 }
 
@@ -5634,6 +5635,8 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	last_sector = bio_end_sector(bi);
 	bi->bi_next = NULL;
 
+	md_io_acct(mddev, bio_op(bi), bio_sectors(bi));
+
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		int previous;
-- 
2.16.4
