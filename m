From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 18 of 22 - More mddev tidyup - remove recovery_sem and resync_sem
Date: Wed, 19 Jun 2002 10:54:31 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54855.402027.510203@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



More mddev tidyup - remove recovery_sem and resync_sem

recovery_sem and resync_sem get replaced by careful use
of recovery_running protected by reconfig_sem.

As part of this, the creative:
	down(&mddev->recovery_sem);
	up(&mddev->recovery_sem);

when stopping an array gets replaced by a more obvious

	wait_event(resync_wait, mddev->recovery_running <= 0);




 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   41 ++++++++++-------------------------------
 ./drivers/md/raid1.c        |    8 +++-----
 ./drivers/md/raid5.c        |    9 +++------
 ./include/linux/raid/md_k.h |    8 ++++++--
 4 files changed, 22 insertions(+), 44 deletions(-)

--- ./include/linux/raid/md_k.h	2002/06/18 05:08:46	1.7
+++ ./include/linux/raid/md_k.h	2002/06/18 05:29:05	1.8
@@ -184,10 +184,14 @@
 	unsigned long			curr_resync;	/* blocks scheduled */
 	unsigned long			resync_mark;	/* a recent timestamp */
 	unsigned long			resync_mark_cnt;/* blocks written at resync_mark */
+	/* recovery_running is 0 for no recovery/resync,
+	 * 1 for active recovery
+	 * 2 for active resync
+	 * -error for an error (e.g. -EINTR)
+	 * it can only be set > 0 under reconfig_sem
+	 */
 	int				recovery_running;
 	struct semaphore		reconfig_sem;
-	struct semaphore		recovery_sem;
-	struct semaphore		resync_sem;
 	atomic_t			active;
 
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
--- ./drivers/md/md.c	2002/06/18 05:08:46	1.17
+++ ./drivers/md/md.c	2002/06/18 05:29:05	1.18
@@ -171,8 +171,6 @@
 
 	mddev->__minor = unit;
 	init_MUTEX(&mddev->reconfig_sem);
-	init_MUTEX(&mddev->recovery_sem);
-	init_MUTEX(&mddev->resync_sem);
 	INIT_LIST_HEAD(&mddev->disks);
 	INIT_LIST_HEAD(&mddev->all_mddevs);
 	atomic_set(&mddev->active, 1);
@@ -647,15 +645,6 @@
 	export_array(mddev);
 	md_size[mdidx(mddev)] = 0;
 	md_hd_struct[mdidx(mddev)].nr_sects = 0;
-
-	/*
-	 * Make sure nobody else is using this mddev
-	 * (careful, we rely on the global kernel lock here)
-	 */
-	while (atomic_read(&mddev->resync_sem.count) != 1)
-		schedule();
-	while (atomic_read(&mddev->recovery_sem.count) != 1)
-		schedule();
 }
 
 #undef BAD_CSUM
@@ -1682,6 +1671,8 @@
 #define	STILL_IN_USE \
 "md: md%d still in use.\n"
 
+DECLARE_WAIT_QUEUE_HEAD(resync_wait);
+
 static int do_md_stop(mddev_t * mddev, int ro)
 {
 	int err = 0, resync_interrupted = 0;
@@ -1703,7 +1694,7 @@
 			if (mddev->pers->stop_resync(mddev))
 				resync_interrupted = 1;
 
-		if (mddev->recovery_running)
+		if (mddev->recovery_running==1)
 			md_interrupt_thread(md_recovery_thread);
 
 		/*
@@ -1712,8 +1703,8 @@
 		 * hangs the process if some reconstruction has not
 		 * finished.
 		 */
-		down(&mddev->recovery_sem);
-		up(&mddev->recovery_sem);
+
+		wait_event(resync_wait, mddev->recovery_running <= 0);
 
 		invalidate_device(dev, 1);
 
@@ -2900,7 +2891,7 @@
 	 */
 	if (mddev->pers->stop_resync)
 		mddev->pers->stop_resync(mddev);
-	if (mddev->recovery_running)
+	if (mddev->recovery_running==1)
 		md_interrupt_thread(md_recovery_thread);
 	md_recover_arrays();
 
@@ -2959,7 +2950,7 @@
 			sz += sprintf(page + sz, ".");
 		sz += sprintf(page + sz, "] ");
 	}
-	if (!mddev->recovery_running)
+	if (mddev->recovery_running==2)
 		/*
 		 * true resync
 		 */
@@ -3048,7 +3039,7 @@
 		if (mddev->curr_resync) {
 			sz += status_resync (page+sz, mddev);
 		} else {
-			if (atomic_read(&mddev->resync_sem.count) != 1)
+			if (mddev->recovery_running < 0)
 				sz += sprintf(page + sz, "	resync=DELAYED");
 		}
 		sz += sprintf(page + sz, "\n");
@@ -3153,8 +3144,6 @@
 	return idle;
 }
 
-DECLARE_WAIT_QUEUE_HEAD(resync_wait);
-
 void md_done_sync(mddev_t *mddev, int blocks, int ok)
 {
 	/* another "blocks" (512byte) blocks have been synced */
@@ -3179,10 +3168,6 @@
 	unsigned long last_check;
 
 
-	err = down_interruptible(&mddev->resync_sem);
-	if (err)
-		goto out_nolock;
-
 recheck:
 	serialize = 0;
 	ITERATE_MDDEV(mddev2,tmp) {
@@ -3305,9 +3290,8 @@
 	 */
 out:
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
-	up(&mddev->resync_sem);
-out_nolock:
 	mddev->curr_resync = 0;
+	mddev->recovery_running = err;
 	wake_up(&resync_wait);
 	return err;
 }
@@ -3356,7 +3340,6 @@
 			goto unlock;
 		if (mddev->pers->diskop(mddev, &spare, DISKOP_SPARE_WRITE))
 			goto unlock;
-		down(&mddev->recovery_sem);
 		mddev->recovery_running = 1;
 		mddev_unlock(mddev);
 		err = md_do_sync(mddev, spare);
@@ -3384,12 +3367,7 @@
 			 */
 			mddev->pers->diskop(mddev, &spare,
 							 DISKOP_SPARE_INACTIVE);
-			up(&mddev->recovery_sem);
-			mddev->recovery_running = 0;
 			goto unlock;
-		} else {
-			mddev->recovery_running = 0;
-			up(&mddev->recovery_sem);
 		}
 		if (!disk_faulty(spare)) {
 			/*
@@ -3404,6 +3382,7 @@
 		}
 		mddev->sb_dirty = 1;
 		md_update_sb(mddev);
+		mddev->recovery_running = 0;
 	unlock:
 		mddev_unlock(mddev);
 	}
--- ./drivers/md/raid5.c	2002/06/18 04:18:34	1.6
+++ ./drivers/md/raid5.c	2002/06/18 05:29:05	1.7
@@ -1386,16 +1386,13 @@
 
 	if (!conf->resync_parity)
 		return;
-	if (conf->resync_parity == 2)
+	if (mddev->recovery_running != 2)
 		return;
-	down(&mddev->recovery_sem);
 	if (md_do_sync(mddev,NULL)) {
-		up(&mddev->recovery_sem);
 		printk("raid5: resync aborted!\n");
 		return;
 	}
 	conf->resync_parity = 0;
-	up(&mddev->recovery_sem);
 	printk("raid5: resync finished.\n");
 }
 
@@ -1615,6 +1612,7 @@
 
 		printk("raid5: raid set md%d not clean; reconstructing parity\n", mdidx(mddev));
 		conf->resync_parity = 1;
+		mddev->recovery_running = 2;
 		md_wakeup_thread(conf->resync_thread);
 	}
 
@@ -1646,7 +1644,6 @@
 
 	if (thread) {
 		if (conf->resync_parity) {
-			conf->resync_parity = 2;
 			md_interrupt_thread(thread);
 			printk(KERN_INFO "raid5: parity resync was not fully finished, restarting next time.\n");
 			return 1;
@@ -1666,7 +1663,7 @@
 			return 0;
 		}
 		printk("raid5: waking up raid5resync.\n");
-		conf->resync_parity = 1;
+		mddev->recovery_running = 2;
 		md_wakeup_thread(conf->resync_thread);
 		return 1;
 	} else
--- ./drivers/md/raid1.c	2002/06/18 04:18:35	1.2
+++ ./drivers/md/raid1.c	2002/06/18 05:29:05	1.3
@@ -1125,9 +1125,8 @@
 
 	if (!conf->resync_mirrors)
 		return;
-	if (conf->resync_mirrors == 2)
+	if (mddev->recovery_running != 2)
 		return;
-	down(&mddev->recovery_sem);
 	if (!md_do_sync(mddev, NULL)) {
 		/*
 		 * Only if everything went Ok.
@@ -1137,7 +1136,6 @@
 
 	close_sync(conf);
 
-	up(&mddev->recovery_sem);
 }
 
 static int init_resync(conf_t *conf)
@@ -1477,6 +1475,7 @@
 
 		printk(START_RESYNC, mdidx(mddev));
 		conf->resync_mirrors = 1;
+		mddev->recovery_running = 2;
 		md_wakeup_thread(conf->resync_thread);
 	}
 
@@ -1524,7 +1523,6 @@
 
 	if (conf->resync_thread) {
 		if (conf->resync_mirrors) {
-			conf->resync_mirrors = 2;
 			md_interrupt_thread(conf->resync_thread);
 
 			printk(KERN_INFO "raid1: mirror resync was not fully finished, restarting next time.\n");
@@ -1544,7 +1542,7 @@
 			MD_BUG();
 			return 0;
 		}
-		conf->resync_mirrors = 1;
+		mddev->recovery_running = 2;
 		md_wakeup_thread(conf->resync_thread);
 		return 1;
 	}
