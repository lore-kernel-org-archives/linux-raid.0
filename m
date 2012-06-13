From: Shaohua Li <shli@kernel.org>
Subject: [patch 1/4 v2] raid1: move distance based read balance to a separate function
Date: Wed, 13 Jun 2012 17:09:23 +0800
Message-ID: <20120613091021.730491348@kernel.org>
References: <20120613090922.971820942@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid1-consolidate-read-balance.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

Move distance based read balance algorithm to a separate function. No
functional change.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c |   42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-05-08 16:36:12.624232473 +0800
+++ linux/drivers/md/raid1.c	2012-05-08 16:36:14.476209200 +0800
@@ -463,6 +463,31 @@ static void raid1_end_write_request(stru
 		bio_put(to_put);
 }
 
+static int read_balance_measure_distance(struct r1conf *conf,
+	struct r1bio *r1_bio, int disk, int *best_disk, sector_t *best_dist)
+{
+	const sector_t this_sector = r1_bio->sector;
+	struct md_rdev *rdev;
+	sector_t dist;
+
+	rdev = rcu_dereference(conf->mirrors[disk].rdev);
+
+	dist = abs(this_sector - conf->mirrors[disk].head_position);
+	/* Don't change to another disk for sequential reads */
+	if (conf->next_seq_sect == this_sector
+	    || dist == 0
+	    /* If device is idle, use it */
+	    || atomic_read(&rdev->nr_pending) == 0) {
+		*best_disk = disk;
+		return 0;
+	}
+
+	if (dist < *best_dist) {
+		*best_dist = dist;
+		*best_disk = disk;
+	}
+	return 1;
+}
 
 /*
  * This routine returns the disk from which the requested read should
@@ -512,7 +537,6 @@ static int read_balance(struct r1conf *c
 	}
 
 	for (i = 0 ; i < conf->raid_disks * 2 ; i++) {
-		sector_t dist;
 		sector_t first_bad;
 		int bad_sectors;
 
@@ -577,20 +601,14 @@ static int read_balance(struct r1conf *c
 		} else
 			best_good_sectors = sectors;
 
-		dist = abs(this_sector - conf->mirrors[disk].head_position);
-		if (choose_first
-		    /* Don't change to another disk for sequential reads */
-		    || conf->next_seq_sect == this_sector
-		    || dist == 0
-		    /* If device is idle, use it */
-		    || atomic_read(&rdev->nr_pending) == 0) {
+		if (choose_first) {
 			best_disk = disk;
 			break;
 		}
-		if (dist < best_dist) {
-			best_dist = dist;
-			best_disk = disk;
-		}
+
+		if (!read_balance_measure_distance(conf, r1_bio, disk,
+		    &best_disk, &best_dist))
+			break;
 	}
 
 	if (best_disk >= 0) {

