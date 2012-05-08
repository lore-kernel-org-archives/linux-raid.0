From: Shaohua Li <shli@kernel.org>
Subject: [patch 3/4] raid1: read balance chooses idlest disk
Date: Tue, 08 May 2012 18:08:56 +0800
Message-ID: <20120508101031.463750137@kernel.org>
References: <20120508100853.412193855@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid1-ssd-read-balance.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

SSD hasn't spindle, distance between requests means nothing. And the original
distance based algorithm sometimes can cause severe performance issue for SSD
raid.

Considering two thread groups, one accesses file A, the other access file B.
The first group will access one disk and the second will access the other disk,
because requests are near from one group and far between groups. In this case,
read balance might keep one disk very busy but the other relative idle.  For
SSD, we should try best to distribute requests to as more disks as possible.
There isn't spindle move penality anyway.

With below patch, I can see more than 50% throughput improvement sometimes
depending on workloads.

The only exception is small requests can be merged to a big request which
typically can drive higher throughput for SSD too. Such small requests are
sequential reads. Unlike hard disk, sequential read which can't be merged (for
example direct IO, or read without readahead) can be ignored for SSD. Again
there is no spindle move penality. readahead dispatches small requests and such
requests can be merged.

Last patch can help detect sequential read well, at least if concurrent read
number isn't greater than raid disk number. In that case, distance based
algorithm doesn't work well too.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/raid1.h |    2 +
 2 files changed, 54 insertions(+), 3 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-05-08 16:36:31.559994400 +0800
+++ linux/drivers/md/raid1.c	2012-05-08 16:36:35.255946817 +0800
@@ -463,6 +463,43 @@ static void raid1_end_write_request(stru
 		bio_put(to_put);
 }
 
+static int read_balance_measure_ssd(struct r1conf *conf, struct r1bio *r1_bio,
+	int disk, int *best_disk, unsigned int *min_pending)
+{
+	const sector_t this_sector = r1_bio->sector;
+	struct md_rdev *rdev;
+	unsigned int pending;
+
+	rdev = rcu_dereference(conf->mirrors[disk].rdev);
+	pending = atomic_read(&rdev->nr_pending);
+
+	/* big request IO helps SSD too, allow sequential IO merge */
+	if (conf->mirrors[disk].next_seq_sect == this_sector) {
+		sector_t dist;
+		dist = abs(this_sector - conf->mirrors[disk].head_position);
+		/*
+		 * head_position is for finished request, such reqeust can't be
+		 * merged with current request, so it means nothing for SSD
+		 */
+		if (dist != 0)
+			goto done;
+	}
+
+	/* If device is idle, use it */
+	if (pending == 0)
+		goto done;
+
+	/* find device with less requests pending */
+	if (*min_pending > pending) {
+		*min_pending = pending;
+		*best_disk = disk;
+	}
+	return 1;
+done:
+	*best_disk = disk;
+	return 0;
+}
+
 static int read_balance_measure_distance(struct r1conf *conf,
 	struct r1bio *r1_bio, int disk, int *best_disk, sector_t *best_dist)
 {
@@ -511,6 +548,7 @@ static int read_balance(struct r1conf *c
 	int best_disk;
 	int i;
 	sector_t best_dist;
+	unsigned int min_pending;
 	struct md_rdev *rdev;
 	int choose_first;
 
@@ -524,6 +562,7 @@ static int read_balance(struct r1conf *c
 	sectors = r1_bio->sectors;
 	best_disk = -1;
 	best_dist = MaxSector;
+	min_pending = -1;
 	best_good_sectors = 0;
 
 	if (conf->mddev->recovery_cp < MaxSector &&
@@ -602,9 +641,15 @@ static int read_balance(struct r1conf *c
 			break;
 		}
 
-		if (!read_balance_measure_distance(conf, r1_bio, disk,
-		    &best_disk, &best_dist))
-			break;
+		if (!conf->nonrotational) {
+			if (!read_balance_measure_distance(conf, r1_bio, disk,
+			    &best_disk, &best_dist))
+				break;
+		} else {
+			if (!read_balance_measure_ssd(conf, r1_bio, disk,
+			    &best_disk, &min_pending))
+				break;
+		}
 	}
 
 	if (best_disk >= 0) {
@@ -2531,6 +2576,7 @@ static struct r1conf *setup_conf(struct
 	struct mirror_info *disk;
 	struct md_rdev *rdev;
 	int err = -ENOMEM;
+	bool nonrotational = true;
 
 	conf = kzalloc(sizeof(struct r1conf), GFP_KERNEL);
 	if (!conf)
@@ -2575,7 +2621,10 @@ static struct r1conf *setup_conf(struct
 		disk->rdev = rdev;
 
 		disk->head_position = 0;
+		if (!blk_queue_nonrot(bdev_get_queue(rdev->bdev)))
+			nonrotational = false;
 	}
+	conf->nonrotational = nonrotational;
 	conf->raid_disks = mddev->raid_disks;
 	conf->mddev = mddev;
 	INIT_LIST_HEAD(&conf->retry_list);
Index: linux/drivers/md/raid1.h
===================================================================
--- linux.orig/drivers/md/raid1.h	2012-05-08 16:36:31.559994400 +0800
+++ linux/drivers/md/raid1.h	2012-05-08 16:36:35.255946817 +0800
@@ -65,6 +65,8 @@ struct r1conf {
 	int			nr_queued;
 	int			barrier;
 
+	int			nonrotational;
+
 	/* Set to 1 if a full sync is needed, (fresh device added).
 	 * Cleared when a sync completes.
 	 */

