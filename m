From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 3 - Record location of incomplete resync at shutdown and restart from there.
Date: Mon, 06 Jan 2003 11:42:49 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18VLLt-00036J-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org, Angus Sawyer <angus.sawyer@dsl.pipex.com>
List-Id: linux-raid.ids


### Comments for ChangeSet

Add a new field to the md superblock, in an used area, to record where
resync was up-to on a clean shutdown while resync is active.  Restart from
this point.

The extra field is verified by having a second copy of the event counter.
If the second event counter is wrong, we ignore the extra field.

This patch thanks to  Angus Sawyer <angus.sawyer@dsl.pipex.com>

 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   94 ++++++++++++++++++++++++++++++--------------
 ./drivers/md/raid1.c        |    4 -
 ./drivers/md/raid5.c        |    2 
 ./include/linux/raid/md_k.h |    5 +-
 ./include/linux/raid/md_p.h |    7 ++-
 5 files changed, 79 insertions(+), 33 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-01-06 11:39:27.000000000 +1100
+++ ./drivers/md/md.c	2003-01-06 11:12:35.000000000 +1100
@@ -578,10 +578,19 @@ static int super_90_validate(mddev_t *md
 		mddev->level = sb->level;
 		mddev->layout = sb->layout;
 		mddev->raid_disks = sb->raid_disks;
-		mddev->state = sb->state;
 		mddev->size = sb->size;
 		mddev->events = md_event(sb);
-	
+
+		if (sb->state & (1<<MD_SB_CLEAN))
+			mddev->recovery_cp = MaxSector;
+		else {
+			if (sb->events_hi == sb->cp_events_hi && 
+				sb->events_lo == sb->cp_events_lo) {
+				mddev->recovery_cp = sb->recovery_cp;
+			} else
+				mddev->recovery_cp = 0;
+		}
+
 		memcpy(mddev->uuid+0, &sb->set_uuid0, 4);
 		memcpy(mddev->uuid+4, &sb->set_uuid1, 4);
 		memcpy(mddev->uuid+8, &sb->set_uuid2, 4);
@@ -657,10 +666,22 @@ static void super_90_sync(mddev_t *mddev
 	sb->md_minor = mddev->__minor;
 	sb->not_persistent = !mddev->persistent;
 	sb->utime = mddev->utime;
-	sb->state = mddev->state;
+	sb->state = 0;
 	sb->events_hi = (mddev->events>>32);
 	sb->events_lo = (u32)mddev->events;
 
+	if (mddev->in_sync)
+	{
+		sb->recovery_cp = mddev->recovery_cp;
+		sb->cp_events_hi = (mddev->events>>32);
+		sb->cp_events_lo = (u32)mddev->events;
+		if (mddev->recovery_cp == MaxSector) {
+			printk(KERN_INFO "md: marking sb clean...\n");
+			sb->state = (1<< MD_SB_CLEAN);
+		}
+	} else
+		sb->recovery_cp = 0;
+
 	sb->layout = mddev->layout;
 	sb->chunk_size = mddev->chunk_size;
 
@@ -1198,7 +1219,7 @@ static int analyze_sbs(mddev_t * mddev)
 		goto abort;
 	}
 
-	if ((mddev->state != (1 << MD_SB_CLEAN)) && ((mddev->level == 1) ||
+	if ((mddev->recovery_cp != MaxSector) && ((mddev->level == 1) ||
 			(mddev->level == 4) || (mddev->level == 5)))
 		printk(NOT_CLEAN_IGNORE, mdidx(mddev));
 
@@ -1469,13 +1490,11 @@ static int do_md_run(mddev_t * mddev)
 		mddev->pers = NULL;
 		return -EINVAL;
 	}
-
-	mddev->in_sync = (mddev->state & (1<<MD_SB_CLEAN));
-	/* if personality doesn't have "sync_request", then
-	 * a dirty array doesn't mean anything
-	 */
 	if (mddev->pers->sync_request)
-		mddev->state &= ~(1 << MD_SB_CLEAN);
+		mddev->in_sync = 0;
+	else
+		mddev->in_sync = 1;
+	
 	md_update_sb(mddev);
 	md_recover_arrays();
 	set_capacity(disk, md_size[mdidx(mddev)]<<1);
@@ -1502,6 +1521,8 @@ static int restart_array(mddev_t *mddev)
 		if (!mddev->ro)
 			goto out;
 
+		mddev->in_sync = 0;
+		md_update_sb(mddev);
 		mddev->ro = 0;
 		set_disk_ro(disk, 0);
 
@@ -1541,7 +1562,7 @@ static int do_md_stop(mddev_t * mddev, i
 	if (mddev->pers) {
 		if (mddev->sync_thread) {
 			if (mddev->recovery_running > 0)
-				mddev->recovery_running = -EINTR;
+				mddev->recovery_running = -1;
 			md_unregister_thread(mddev->sync_thread);
 			mddev->sync_thread = NULL;
 		}
@@ -1567,14 +1588,8 @@ static int do_md_stop(mddev_t * mddev, i
 				mddev->ro = 0;
 		}
 		if (mddev->raid_disks) {
-			/*
-			 * mark it clean only if there was no resync
-			 * interrupted.
-			 */
-			if (mddev->in_sync) {
-				printk(KERN_INFO "md: marking sb clean...\n");
-				mddev->state |= 1 << MD_SB_CLEAN;
-			}
+			/* mark array as shutdown cleanly */
+			mddev->in_sync = 1;
 			md_update_sb(mddev);
 		}
 		if (ro)
@@ -1840,7 +1855,9 @@ static int get_array_info(mddev_t * mdde
 	info.not_persistent= !mddev->persistent;
 
 	info.utime         = mddev->utime;
-	info.state         = mddev->state;
+	info.state         = 0;
+	if (mddev->recovery_cp == MaxSector)
+		info.state = (1<<MD_SB_CLEAN);
 	info.active_disks  = active;
 	info.working_disks = working;
 	info.failed_disks  = failed;
@@ -2111,7 +2128,10 @@ static int set_array_info(mddev_t * mdde
 	/* don't set __minor, it is determined by which /dev/md* was
 	 * openned
 	 */
-	mddev->state         = info->state;
+	if (info->state & (1<<MD_SB_CLEAN))
+		mddev->recovery_cp = MaxSector;
+	else
+		mddev->recovery_cp = 0;
 	mddev->persistent    = ! info->not_persistent;
 
 	mddev->layout        = info->layout;
@@ -2770,7 +2790,8 @@ void md_done_sync(mddev_t *mddev, int bl
 	atomic_sub(blocks, &mddev->recovery_active);
 	wake_up(&mddev->recovery_wait);
 	if (!ok) {
-		mddev->recovery_running = -EIO;
+		mddev->recovery_error = -EIO;
+		mddev->recovery_running = -1;
 		md_recover_arrays();
 		// stop recovery, signal do_sync ....
 	}
@@ -2841,7 +2862,7 @@ static void md_do_sync(void *data)
 	is_mddev_idle(mddev); /* this also initializes IO event counters */
 	for (m = 0; m < SYNC_MARKS; m++) {
 		mark[m] = jiffies;
-		mark_cnt[m] = 0;
+		mark_cnt[m] = mddev->recovery_cp;
 	}
 	last_mark = 0;
 	mddev->resync_mark = mark[last_mark];
@@ -2857,7 +2878,13 @@ static void md_do_sync(void *data)
 	atomic_set(&mddev->recovery_active, 0);
 	init_waitqueue_head(&mddev->recovery_wait);
 	last_check = 0;
-	for (j = 0; j < max_sectors;) {
+
+	mddev->recovery_error = 0;
+
+	if (mddev->recovery_cp)
+		printk(KERN_INFO "md: resuming recovery of md%d from checkpoint.\n", mdidx(mddev));
+
+	for (j = mddev->recovery_cp; j < max_sectors;) {
 		int sectors;
 
 		sectors = mddev->pers->sync_request(mddev, j, currspeed < sysctl_speed_limit_min);
@@ -2927,16 +2954,25 @@ static void md_do_sync(void *data)
 	 */
  out:
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
+
+	if (mddev->recovery_running < 0 && 
+		!mddev->recovery_error && mddev->curr_resync > 2)
+	{
+		/* interrupted but no write errors */
+		printk(KERN_INFO "md: checkpointing recovery of md%d.\n", mdidx(mddev));
+		mddev->recovery_cp = mddev->curr_resync;
+	}
+
 	/* tell personality that we are finished */
 	mddev->pers->sync_request(mddev, max_sectors, 1);
  skip:
 	mddev->curr_resync = 0;
 	if (err)
-		mddev->recovery_running = err;
+		mddev->recovery_running = -1;
 	if (mddev->recovery_running > 0)
 		mddev->recovery_running = 0;
 	if (mddev->recovery_running == 0)
-		mddev->in_sync = 1;
+		mddev->recovery_cp = MaxSector;
 	md_recover_arrays();
 }
 
@@ -3017,14 +3053,16 @@ void md_do_recovery(void *data)
 			ITERATE_RDEV(mddev,rdev,rtmp)
 				if (rdev->raid_disk < 0
 				    && !rdev->faulty) {
-					if (mddev->pers->hot_add_disk(mddev,rdev))
+					if (mddev->pers->hot_add_disk(mddev,rdev)) {
 						mddev->spares++;
+						mddev->recovery_cp = 0;
+					}
 					else
 						break;
 				}
 		}
 
-		if (!mddev->spares && mddev->in_sync) {
+		if (!mddev->spares && (mddev->recovery_cp == MaxSector )) {
 			/* nothing we can do ... */
 			goto unlock;
 		}

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-01-06 11:39:27.000000000 +1100
+++ ./drivers/md/raid1.c	2003-01-06 11:12:35.000000000 +1100
@@ -975,7 +975,7 @@ static int sync_request(mddev_t *mddev, 
 	sector_t max_sector, nr_sectors;
 	int disk, partial;
 
-	if (sector_nr == 0)
+	if (!conf->r1buf_pool)
 		if (init_resync(conf))
 			return -ENOMEM;
 
@@ -1149,7 +1149,7 @@ static int run(mddev_t *mddev)
 	conf->mddev = mddev;
 	conf->device_lock = SPIN_LOCK_UNLOCKED;
 	if (conf->working_disks == 1)
-		mddev->state |= (1 << MD_SB_CLEAN);
+		mddev->recovery_cp = MaxSector;
 
 	conf->resync_lock = SPIN_LOCK_UNLOCKED;
 	init_waitqueue_head(&conf->wait_idle);

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-01-06 11:39:27.000000000 +1100
+++ ./drivers/md/raid5.c	2003-01-06 11:12:35.000000000 +1100
@@ -1471,7 +1471,7 @@ static int run (mddev_t *mddev)
 	}
 
 	if (mddev->degraded == 1 &&
-	    !(mddev->state & (1<<MD_SB_CLEAN))) {
+	    mddev->recovery_cp != MaxSector) {
 		printk(KERN_ERR "raid5: cannot start dirty degraded array for md%d\n", mdidx(mddev));
 		goto abort;
 	}

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2003-01-06 11:39:27.000000000 +1100
+++ ./include/linux/raid/md_k.h	2003-01-06 11:12:35.000000000 +1100
@@ -28,6 +28,8 @@
 #define	LEVEL_MULTIPATH		(-4)
 #define	LEVEL_LINEAR		(-1)
 
+#define MaxSector (~(sector_t)0)
+
 static inline int pers_to_level (int pers)
 {
 	switch (pers) {
@@ -198,7 +200,6 @@ struct mddev_s
 	int				level, layout;
 	int				raid_disks;
 	int				max_disks;
-	unsigned long			state;
 	sector_t			size; /* used size of component devices */
 	__u64				events;
 
@@ -215,6 +216,7 @@ struct mddev_s
 	 * it can only be set > 0 under reconfig_sem
 	 */
 	int				recovery_running;
+	int				recovery_error;	/* error from recovery write */
 	int				in_sync;	/* know to not need resync */
 	struct semaphore		reconfig_sem;
 	atomic_t			active;
@@ -226,6 +228,7 @@ struct mddev_s
 
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
+	sector_t			recovery_cp;
 
 	request_queue_t			queue;	/* for plugging ... */
 

diff ./include/linux/raid/md_p.h~current~ ./include/linux/raid/md_p.h
--- ./include/linux/raid/md_p.h~current~	2003-01-06 11:39:27.000000000 +1100
+++ ./include/linux/raid/md_p.h	2003-01-06 11:12:35.000000000 +1100
@@ -131,11 +131,16 @@ typedef struct mdp_superblock_s {
 #ifdef __BIG_ENDIAN
 	__u32 events_hi;	/*  7 high-order of superblock update count   */
 	__u32 events_lo;	/*  8 low-order of superblock update count    */
+	__u32 cp_events_hi;	/*  9 high-order of checkpoint update count   */
+	__u32 cp_events_lo;	/* 10 low-order of checkpoint update count    */
 #else
 	__u32 events_lo;	/*  7 low-order of superblock update count    */
 	__u32 events_hi;	/*  8 high-order of superblock update count   */
+	__u32 cp_events_lo;	/*  9 low-order of checkpoint update count    */
+	__u32 cp_events_hi;	/* 10 high-order of checkpoint update count   */
 #endif
-	__u32 gstate_sreserved[MD_SB_GENERIC_STATE_WORDS - 9];
+	__u32 recovery_cp;	/* 11 recovery checkpoint sector count	      */
+	__u32 gstate_sreserved[MD_SB_GENERIC_STATE_WORDS - 12];
 
 	/*
 	 * Personality information
