From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/4] raid1: make sequential read detection per disk based
Date: Tue, 08 May 2012 18:08:55 +0800
Message-ID: <20120508101022.687760012@kernel.org>
References: <20120508100853.412193855@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid1-seq-detection.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

Currently the sequential read detection is global wide. It's natural to make it
per disk based, which can improve the detection for concurrent multiple
sequential reads. And next patch will make SSD read balance not use distance
based algorithm, where this change help detect truly sequential read for SSD.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c |   29 ++++++-----------------------
 drivers/md/raid1.h |   11 +++++------
 2 files changed, 11 insertions(+), 29 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-05-08 16:36:14.476209200 +0800
+++ linux/drivers/md/raid1.c	2012-05-08 16:36:31.559994400 +0800
@@ -474,7 +474,7 @@ static int read_balance_measure_distance
 
 	dist = abs(this_sector - conf->mirrors[disk].head_position);
 	/* Don't change to another disk for sequential reads */
-	if (conf->next_seq_sect == this_sector
+	if (conf->mirrors[disk].next_seq_sect == this_sector
 	    || dist == 0
 	    /* If device is idle, use it */
 	    || atomic_read(&rdev->nr_pending) == 0) {
@@ -508,7 +508,6 @@ static int read_balance(struct r1conf *c
 	const sector_t this_sector = r1_bio->sector;
 	int sectors;
 	int best_good_sectors;
-	int start_disk;
 	int best_disk;
 	int i;
 	sector_t best_dist;
@@ -528,19 +527,16 @@ static int read_balance(struct r1conf *c
 	best_good_sectors = 0;
 
 	if (conf->mddev->recovery_cp < MaxSector &&
-	    (this_sector + sectors >= conf->next_resync)) {
+	    (this_sector + sectors >= conf->next_resync))
 		choose_first = 1;
-		start_disk = 0;
-	} else {
+	else
 		choose_first = 0;
-		start_disk = conf->last_used;
-	}
 
 	for (i = 0 ; i < conf->raid_disks * 2 ; i++) {
 		sector_t first_bad;
 		int bad_sectors;
 
-		int disk = start_disk + i;
+		int disk = i;
 		if (disk >= conf->raid_disks)
 			disk -= conf->raid_disks;
 
@@ -624,8 +620,7 @@ static int read_balance(struct r1conf *c
 			goto retry;
 		}
 		sectors = best_good_sectors;
-		conf->next_seq_sect = this_sector + sectors;
-		conf->last_used = best_disk;
+		conf->mirrors[best_disk].next_seq_sect = this_sector + sectors;
 	}
 	rcu_read_unlock();
 	*max_sectors = sectors;
@@ -2593,7 +2588,6 @@ static struct r1conf *setup_conf(struct
 	conf->recovery_disabled = mddev->recovery_disabled - 1;
 
 	err = -EIO;
-	conf->last_used = -1;
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 
 		disk = conf->mirrors + i;
@@ -2618,19 +2612,9 @@ static struct r1conf *setup_conf(struct
 			disk->head_position = 0;
 			if (disk->rdev)
 				conf->fullsync = 1;
-		} else if (conf->last_used < 0)
-			/*
-			 * The first working device is used as a
-			 * starting point to read balancing.
-			 */
-			conf->last_used = i;
+		}
 	}
 
-	if (conf->last_used < 0) {
-		printk(KERN_ERR "md/raid1:%s: no operational mirrors\n",
-		       mdname(mddev));
-		goto abort;
-	}
 	err = -ENOMEM;
 	conf->thread = md_register_thread(raid1d, mddev, NULL);
 	if (!conf->thread) {
@@ -2880,7 +2864,6 @@ static int raid1_reshape(struct mddev *m
 	conf->raid_disks = mddev->raid_disks = raid_disks;
 	mddev->delta_disks = 0;
 
-	conf->last_used = 0; /* just make sure it is in-range */
 	lower_barrier(conf);
 
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
Index: linux/drivers/md/raid1.h
===================================================================
--- linux.orig/drivers/md/raid1.h	2012-05-08 16:36:12.560233279 +0800
+++ linux/drivers/md/raid1.h	2012-05-08 16:36:31.559994400 +0800
@@ -4,6 +4,11 @@
 struct mirror_info {
 	struct md_rdev	*rdev;
 	sector_t	head_position;
+
+	/* When choose the best device for a read (read_balance())
+	 * we try to keep sequential reads one the same device
+	 */
+	sector_t	next_seq_sect;
 };
 
 /*
@@ -29,12 +34,6 @@ struct r1conf {
 						 */
 	int			raid_disks;
 
-	/* When choose the best device for a read (read_balance())
-	 * we try to keep sequential reads one the same device
-	 * using 'last_used' and 'next_seq_sect'
-	 */
-	int			last_used;
-	sector_t		next_seq_sect;
 	/* During resync, read_balancing is only allowed on the part
 	 * of the array that has been resynced.  'next_resync' tells us
 	 * where that is.

