From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/3 v4]raid1: read balance chooses idlest disk for SSD
Date: Thu, 5 Jul 2012 17:20:57 +0800
Message-ID: <20120705092057.GB27956@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
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
 drivers/md/raid1.c |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-07-04 15:25:11.817869519 +0800
+++ linux/drivers/md/raid1.c	2012-07-04 15:42:30.280816275 +0800
@@ -483,9 +483,11 @@ static int read_balance(struct r1conf *c
 	const sector_t this_sector = r1_bio->sector;
 	int sectors;
 	int best_good_sectors;
-	int best_disk;
+	int best_disk, best_dist_disk, best_pending_disk;
+	int has_nonrot_disk;
 	int i;
 	sector_t best_dist;
+	unsigned int min_pending;
 	struct md_rdev *rdev;
 	int choose_first;
 
@@ -498,8 +500,12 @@ static int read_balance(struct r1conf *c
  retry:
 	sectors = r1_bio->sectors;
 	best_disk = -1;
+	best_dist_disk = -1;
 	best_dist = MaxSector;
+	best_pending_disk = -1;
+	min_pending = UINT_MAX;
 	best_good_sectors = 0;
+	has_nonrot_disk = 0;
 
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync))
@@ -511,6 +517,7 @@ static int read_balance(struct r1conf *c
 		sector_t dist;
 		sector_t first_bad;
 		int bad_sectors;
+		unsigned int pending;
 
 		int disk = i;
 		if (disk >= conf->raid_disks * 2)
@@ -573,22 +580,43 @@ static int read_balance(struct r1conf *c
 		} else
 			best_good_sectors = sectors;
 
+		has_nonrot_disk |= blk_queue_nonrot(bdev_get_queue(rdev->bdev));
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
+
+		if (min_pending > pending) {
+			min_pending = pending;
+			best_pending_disk = disk;
+		}
+
 		if (dist < best_dist) {
 			best_dist = dist;
-			best_disk = disk;
+			best_dist_disk = disk;
 		}
 	}
 
+	/*
+	 * If all disks are rotational, choose the closest disk. If any disk is
+	 * non-rotational, choose the disk with less pending request even the
+	 * disk is rotational, which might/might not be optimal for raids with
+	 * mixed ratation/non-rotational disks depending on workload.
+	 */
+	if (best_disk == -1) {
+		if (has_nonrot_disk)
+			best_disk = best_pending_disk;
+		else
+			best_disk = best_dist_disk;
+	}
+
 	if (best_disk >= 0) {
 		rdev = rcu_dereference(conf->mirrors[best_disk].rdev);
 		if (!rdev)
