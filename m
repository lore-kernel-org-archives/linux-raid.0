From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 17 of 27 - Add "degraded" field to md device
Date: Thu, 18 Jul 2002 23:33:46 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133346.4941@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Add "degraded" field to md device

This is used to determine if a spare should be added
without relying on the superblock.




 ----------- Diffstat output ------------
 ./drivers/md/md.c           |    2 +-
 ./drivers/md/raid1.c        |    8 +++++++-
 ./drivers/md/raid5.c        |    8 +++++---
 ./include/linux/raid/md_k.h |    4 ++++
 4 files changed, 17 insertions(+), 5 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:05:40	1.10
+++ ./drivers/md/md.c	2002/07/18 12:06:02	1.11
@@ -3354,7 +3354,7 @@ void md_do_recovery(void *data)
 			wake_up(&resync_wait);
 		}
 
-		if (sb->active_disks < sb->raid_disks) {
+		if (mddev->degraded) {
 			mddev->spare = get_spare(mddev);
 			if (!mddev->spare)
 				printk(KERN_ERR "md%d: no spare disk to reconstruct array! "
--- ./drivers/md/raid1.c	2002/07/18 12:05:40	1.7
+++ ./drivers/md/raid1.c	2002/07/18 12:06:02	1.8
@@ -581,8 +581,10 @@ static void mark_disk_bad(mddev_t *mddev
 	mark_disk_faulty(sb->disks+mirror->number);
 	mark_disk_nonsync(sb->disks+mirror->number);
 	mark_disk_inactive(sb->disks+mirror->number);
-	if (!mirror->write_only)
+	if (!mirror->write_only) {
 		sb->active_disks--;
+		mddev->degraded++;
+	}
 	sb->working_disks--;
 	sb->failed_disks++;
 	mddev->sb_dirty = 1;
@@ -758,6 +760,7 @@ static int raid1_spare_active(mddev_t *m
 	 */
 
 	conf->working_disks++;
+	mddev->degraded--;
 abort:
 	spin_unlock_irq(&conf->device_lock);
 
@@ -1338,6 +1341,7 @@ static int run(mddev_t *mddev)
 		goto out_free_conf;
 	}
 
+	mddev->degraded = 0;
 	for (i = 0; i < MD_SB_DISKS; i++) {
 
 		descriptor = sb->disks+i;
@@ -1355,6 +1359,8 @@ static int run(mddev_t *mddev)
 			disk->used_slot = 1;
 			disk->head_position = 0;
 		}
+		if (!disk->used_slot && disk_idk < conf->raid_disks)
+			mddev->degraded++;
 	}
 
 	/*
--- ./drivers/md/raid5.c	2002/07/18 12:05:40	1.6
+++ ./drivers/md/raid5.c	2002/07/18 12:06:02	1.7
@@ -460,6 +460,7 @@ static int error(mddev_t *mddev, struct 
 			sb->working_disks--;
 			sb->failed_disks++;
 			mddev->sb_dirty = 1;
+			mddev->degraded++;
 			conf->working_disks--;
 			conf->failed_disks++;
 			printk (KERN_ALERT
@@ -1500,7 +1501,7 @@ static int run (mddev_t *mddev)
 	/*
 	 * 0 for a fully functional array, 1 for a degraded array.
 	 */
-	conf->failed_disks = conf->raid_disks - conf->working_disks;
+	mddev->degraded = conf->failed_disks = conf->raid_disks - conf->working_disks;
 	conf->mddev = mddev;
 	conf->chunk_size = sb->chunk_size;
 	conf->level = sb->level;
@@ -1523,12 +1524,12 @@ static int run (mddev_t *mddev)
 		printk(KERN_ERR "raid5: unsupported parity algorithm %d for md%d\n", conf->algorithm, mdidx(mddev));
 		goto abort;
 	}
-	if (conf->failed_disks > 1) {
+	if (mddev->degraded > 1) {
 		printk(KERN_ERR "raid5: not enough operational devices for md%d (%d/%d failed)\n", mdidx(mddev), conf->failed_disks, conf->raid_disks);
 		goto abort;
 	}
 
-	if (conf->failed_disks == 1 &&
+	if (mddev->degraded == 1 &&
 	    !(sb->state & (1<<MD_SB_CLEAN))) {
 		printk(KERN_ERR "raid5: cannot start dirty degraded array for md%d\n", mdidx(mddev));
 		goto abort;
@@ -1783,6 +1784,7 @@ static int raid5_spare_active(mddev_t *m
 	 * non-operational disk slot in the 'low' area of
 	 * the disk array.
 	 */
+	mddev->degraded--;
 	conf->failed_disks--;
 	conf->working_disks++;
 	conf->spare = NULL;
--- ./include/linux/raid/md_k.h	2002/07/18 12:05:40	1.6
+++ ./include/linux/raid/md_k.h	2002/07/18 12:06:02	1.7
@@ -192,6 +192,10 @@ struct mddev_s
 	atomic_t			active;
 	mdp_disk_t			*spare;
 
+	int				degraded;	/* whether md should consider
+							 * adding a spare
+							 */
+
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 
