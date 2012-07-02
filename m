From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/3 v3] raid1: read balance chooses idlest disk for SSD
Date: Mon, 02 Jul 2012 09:08:42 +0800
Message-ID: <20120702011031.890864816@kernel.org>
References: <20120702010840.197370335@kernel.org>
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

V2: For hard disk and SSD mixed raid, doesn't use distance based algorithm for
random IO too. This makes the algorithm generic for raid with SSD.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-06-28 16:56:20.846401902 +0800
+++ linux/drivers/md/raid1.c	2012-06-29 14:13:23.856781798 +0800
@@ -486,6 +486,7 @@ static int read_balance(struct r1conf *c
 	int best_disk;
 	int i;
 	sector_t best_dist;
+	unsigned int min_pending;
 	struct md_rdev *rdev;
 	int choose_first;
 
@@ -499,6 +500,7 @@ static int read_balance(struct r1conf *c
 	sectors = r1_bio->sectors;
 	best_disk = -1;
 	best_dist = MaxSector;
+	min_pending = -1;
 	best_good_sectors = 0;
 
 	if (conf->mddev->recovery_cp < MaxSector &&
@@ -511,6 +513,8 @@ static int read_balance(struct r1conf *c
 		sector_t dist;
 		sector_t first_bad;
 		int bad_sectors;
+		bool nonrot;
+		unsigned int pending;
 
 		int disk = i;
 		if (disk >= conf->raid_disks)
@@ -573,17 +577,32 @@ static int read_balance(struct r1conf *c
 		} else
 			best_good_sectors = sectors;
 
+		nonrot = blk_queue_nonrot(bdev_get_queue(rdev->bdev));
+		pending = atomic_read(&rdev->nr_pending);
 		dist = abs(this_sector - conf->mirrors[disk].head_position);
 		if (choose_first
 		    /* Don't change to another disk for sequential reads */
 		    || conf->mirrors[disk].next_seq_sect == this_sector
 		    || dist == 0
 		    /* If device is idle, use it */
-		    || atomic_read(&rdev->nr_pending) == 0) {
+		    || pending == 0) {
 			best_disk = disk;
 			break;
 		}
-		if (dist < best_dist) {
+
+		/*
+		 * If all disks are rotational, choose the closest disk. If any
+		 * disk is non-rotational, choose the disk with less pending
+		 * request even the disk is rotational, which might/might not
+		 * be optimal for raids with mixed ratation/non-rotational
+		 * disks depending on workload.
+		 */
+		if (nonrot || min_pending != -1) {
+			if (min_pending > pending) {
+				min_pending = pending;
+				best_disk = disk;
+			}
+		} else if (dist < best_dist) {
 			best_dist = dist;
 			best_disk = disk;
 		}

