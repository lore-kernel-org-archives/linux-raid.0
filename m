From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 8 of 12 - Fulltime delayed 'safe_mode' for md
Date: Wed, 12 Mar 2003 14:59:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18sxOz-0004qC-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

From: Angus Sawyer <angus.sawyer@dsl.pipex.com>

If there are no writes for 20 milliseconds, write out superblock
to mark array as clean.  Write out superblock with 
dirty flag before allowing any further write to succeed.

If an md thread gets signaled with SIGKILL, reduce the
delay to 0.


Also tidy up some printk's and make sure writing the 
superblock isn't noisy.

 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   64 ++++++++++++++++++++++++++++----------------
 ./include/linux/raid/md_k.h |    4 ++
 2 files changed, 44 insertions(+), 24 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-12 13:42:38.000000000 +1100
+++ ./drivers/md/md.c	2003-03-12 13:46:15.000000000 +1100
@@ -219,6 +219,7 @@ static mddev_t * mddev_find(int unit)
 	init_MUTEX(&new->reconfig_sem);
 	INIT_LIST_HEAD(&new->disks);
 	INIT_LIST_HEAD(&new->all_mddevs);
+	init_timer(&new->safemode_timer);
 	atomic_set(&new->active, 1);
 	blk_queue_make_request(&new->queue, md_fail_request);
 
@@ -701,10 +702,8 @@ static void super_90_sync(mddev_t *mddev
 		sb->recovery_cp = mddev->recovery_cp;
 		sb->cp_events_hi = (mddev->events>>32);
 		sb->cp_events_lo = (u32)mddev->events;
-		if (mddev->recovery_cp == MaxSector) {
-			printk(KERN_INFO "md: marking sb clean...\n");
+		if (mddev->recovery_cp == MaxSector)
 			sb->state = (1<< MD_SB_CLEAN);
-		}
 	} else
 		sb->recovery_cp = 0;
 
@@ -1005,7 +1004,7 @@ static int write_disk_sb(mdk_rdev_t * rd
 
 	sb_offset = calc_dev_sboffset(rdev->bdev);
 	if (rdev->sb_offset != sb_offset) {
-		printk(KERN_INFO "%s's sb offset has changed from %llu to %llu, skipping\n",
+		printk("%s's sb offset has changed from %llu to %llu, skipping\n",
 		       bdev_partition_name(rdev->bdev), 
 		    (unsigned long long)rdev->sb_offset, 
 		    (unsigned long long)sb_offset);
@@ -1025,7 +1024,7 @@ static int write_disk_sb(mdk_rdev_t * rd
 		goto skip;
 	}
 
-	printk(KERN_INFO "(write) %s's sb offset: %llu\n", bdev_partition_name(rdev->bdev), (unsigned long long)sb_offset);
+	dprintk("(write) %s's sb offset: %llu\n", bdev_partition_name(rdev->bdev), (unsigned long long)sb_offset);
 
 	if (!sync_page_io(rdev->bdev, sb_offset<<1, MD_SB_BYTES, rdev->sb_page, WRITE))
 		goto fail;
@@ -1076,20 +1075,20 @@ repeat:
 	if (!mddev->persistent)
 		return;
 
-	printk(KERN_INFO "md: updating md%d RAID superblock on device (in sync %d)\n",
+	dprintk(KERN_INFO "md: updating md%d RAID superblock on device (in sync %d)\n",
 					mdidx(mddev),mddev->in_sync);
 
 	err = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		printk(KERN_INFO "md: ");
+		dprintk(KERN_INFO "md: ");
 		if (rdev->faulty)
-			printk("(skipping faulty ");
+			dprintk("(skipping faulty ");
 
-		printk("%s ", bdev_partition_name(rdev->bdev));
+		dprintk("%s ", bdev_partition_name(rdev->bdev));
 		if (!rdev->faulty) {
 			err += write_disk_sb(rdev);
 		} else
-			printk(")\n");
+			dprintk(")\n");
 		if (!err && mddev->level == LEVEL_MULTIPATH)
 			/* only need to write one superblock... */
 			break;
@@ -1377,6 +1376,16 @@ static struct gendisk *md_probe(dev_t de
 	return NULL;
 }
 
+void md_wakeup_thread(mdk_thread_t *thread);
+
+static void md_safemode_timeout(unsigned long data)
+{
+	mddev_t *mddev = (mddev_t *) data;
+
+	mddev->safemode = 1;
+	md_wakeup_thread(mddev->thread);
+}
+
 #define TOO_BIG_CHUNKSIZE KERN_ERR \
 "too big chunk_size: %d > %d\n"
 
@@ -1518,10 +1527,10 @@ static int do_md_run(mddev_t * mddev)
 	}
  	atomic_set(&mddev->writes_pending,0);
 	mddev->safemode = 0;
-	if (mddev->pers->sync_request)
-		mddev->in_sync = 0;
-	else
-		mddev->in_sync = 1;
+	mddev->safemode_timer.function = md_safemode_timeout;
+	mddev->safemode_timer.data = (unsigned long) mddev;
+	mddev->safemode_delay = (20 * HZ)/1000 +1; /* 20 msec delay */
+	mddev->in_sync = 1;
 	
 	md_update_sb(mddev);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -1551,7 +1560,6 @@ static int restart_array(mddev_t *mddev)
 			goto out;
 
 		mddev->safemode = 0;
-		mddev->in_sync = 0;
 		md_update_sb(mddev);
 		mddev->ro = 0;
 		set_disk_ro(disk, 0);
@@ -1597,6 +1605,8 @@ static int do_md_stop(mddev_t * mddev, i
 			mddev->sync_thread = NULL;
 		}
 
+		del_timer_sync(&mddev->safemode_timer);
+
 		invalidate_device(mk_kdev(disk->major, disk->first_minor), 1);
 
 		if (ro) {
@@ -1886,7 +1896,7 @@ static int get_array_info(mddev_t * mdde
 
 	info.utime         = mddev->utime;
 	info.state         = 0;
-	if (mddev->recovery_cp == MaxSector)
+	if (mddev->in_sync)
 		info.state = (1<<MD_SB_CLEAN);
 	info.active_disks  = active;
 	info.working_disks = working;
@@ -2896,13 +2906,14 @@ void md_done_sync(mddev_t *mddev, int bl
 
 void md_write_start(mddev_t *mddev)
 {
-	if (mddev->safemode && !atomic_read(&mddev->writes_pending)) {
+	if (!atomic_read(&mddev->writes_pending)) {
 		mddev_lock_uninterruptible(mddev);
-		atomic_inc(&mddev->writes_pending);
 		if (mddev->in_sync) {
 			mddev->in_sync = 0;
+ 			del_timer(&mddev->safemode_timer);
 			md_update_sb(mddev);
 		}
+		atomic_inc(&mddev->writes_pending);
 		mddev_unlock(mddev);
 	} else
 		atomic_inc(&mddev->writes_pending);
@@ -2910,12 +2921,16 @@ void md_write_start(mddev_t *mddev)
 
 void md_write_end(mddev_t *mddev)
 {
-	if (atomic_dec_and_test(&mddev->writes_pending) && mddev->safemode)
-		md_wakeup_thread(mddev->thread);
+	if (atomic_dec_and_test(&mddev->writes_pending)) {
+		if (mddev->safemode == 2)
+			md_wakeup_thread(mddev->thread);
+		else
+			mod_timer(&mddev->safemode_timer, jiffies + mddev->safemode_delay);
+	}
 }
+
 static inline void md_enter_safemode(mddev_t *mddev)
 {
-
 	mddev_lock_uninterruptible(mddev);
 	if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
 	    !mddev->in_sync && mddev->recovery_cp == MaxSector) {
@@ -2923,13 +2938,16 @@ static inline void md_enter_safemode(mdd
 		md_update_sb(mddev);
 	}
 	mddev_unlock(mddev);
+
+	if (mddev->safemode == 1)
+		mddev->safemode = 0;
 }
 
 void md_handle_safemode(mddev_t *mddev)
 {
 	if (signal_pending(current)) {
-		printk(KERN_INFO "md: md%d in safe mode\n",mdidx(mddev));
-		mddev->safemode= 1;
+		printk(KERN_INFO "md: md%d in immediate safe mode\n",mdidx(mddev));
+		mddev->safemode = 2;
 		flush_signals(current);
 	}
 	if (mddev->safemode)

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2003-03-12 13:42:38.000000000 +1100
+++ ./include/linux/raid/md_k.h	2003-03-12 13:42:45.000000000 +1100
@@ -239,9 +239,11 @@ struct mddev_s
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 	sector_t			recovery_cp;
-	int				safemode;	/* if set, update "clean" superblock
+	unsigned int			safemode;	/* if set, update "clean" superblock
 							 * when no writes pending.
 							 */ 
+	unsigned int			safemode_delay;
+	struct timer_list		safemode_timer;
 	atomic_t			writes_pending; 
 	request_queue_t			queue;	/* for plugging ... */
 
