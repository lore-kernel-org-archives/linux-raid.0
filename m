From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 9 of 12 - Fix bad interaction between sync checkpointing and recovery
Date: Wed, 12 Mar 2003 14:59:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18sxOz-0004qG-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

Md devices (raid1/raid5) can resync or recover.
There are similar but importantly different.
resync happens after an unclean shutdown
recovery happens when a failed drive is being replaced by a hot spare.

The sync-checkpoint code confused the two somewhat and this causes
problems.

This patch makes sure "recovery_cp" only relates to resync,
not recovery.
It also fixes a small problem with recording spares in
the superblock.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-12 13:46:15.000000000 +1100
+++ ./drivers/md/md.c	2003-03-12 13:46:25.000000000 +1100
@@ -713,7 +713,7 @@ static void super_90_sync(mddev_t *mddev
 	sb->disks[0].state = (1<<MD_DISK_REMOVED);
 	ITERATE_RDEV(mddev,rdev2,tmp) {
 		mdp_disk_t *d;
-		if (rdev2->raid_disk >= 0)
+		if (rdev2->raid_disk >= 0 && rdev2->in_sync && !rdev2->faulty)
 			rdev2->desc_nr = rdev2->raid_disk;
 		else
 			rdev2->desc_nr = next_spare++;
@@ -722,7 +722,7 @@ static void super_90_sync(mddev_t *mddev
 		d->number = rdev2->desc_nr;
 		d->major = MAJOR(rdev2->bdev->bd_dev);
 		d->minor = MINOR(rdev2->bdev->bd_dev);
-		if (rdev2->raid_disk >= 0)
+		if (rdev2->raid_disk >= 0 && rdev->in_sync && !rdev2->faulty)
 			d->raid_disk = rdev2->raid_disk;
 		else
 			d->raid_disk = rdev2->desc_nr; /* compatibility */
@@ -3020,9 +3020,13 @@ static void md_do_sync(mddev_t *mddev)
 	       sysctl_speed_limit_max);
 
 	is_mddev_idle(mddev); /* this also initializes IO event counters */
+	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+		j = mddev->recovery_cp;
+	else
+		j = 0;
 	for (m = 0; m < SYNC_MARKS; m++) {
 		mark[m] = jiffies;
-		mark_cnt[m] = mddev->recovery_cp;
+		mark_cnt[m] = j;
 	}
 	last_mark = 0;
 	mddev->resync_mark = mark[last_mark];
@@ -3039,10 +3043,10 @@ static void md_do_sync(mddev_t *mddev)
 	init_waitqueue_head(&mddev->recovery_wait);
 	last_check = 0;
 
-	if (mddev->recovery_cp)
+	if (j)
 		printk(KERN_INFO "md: resuming recovery of md%d from checkpoint.\n", mdidx(mddev));
 
-	for (j = mddev->recovery_cp; j < max_sectors;) {
+	while (j < max_sectors) {
 		int sectors;
 
 		sectors = mddev->pers->sync_request(mddev, j, currspeed < sysctl_speed_limit_min);
