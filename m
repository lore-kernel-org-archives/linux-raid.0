From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 5 of 12 - Tidy up recovery_running flags in md
Date: Wed, 12 Mar 2003 14:59:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18sxOz-0004pw-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

Md uses ->recovery_running and ->recovery_err to keep track of the 
status or recovery.  This is rather ad hoc and race prone.

This patch changes it to ->recovery which has bit flags for various
states.

 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   88 ++++++++++++++++++++++----------------------
 ./drivers/md/raid1.c        |    5 +-
 ./drivers/md/raid5.c        |    5 +-
 ./include/linux/raid/md_k.h |   22 +++++++----
 4 files changed, 63 insertions(+), 57 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-12 13:12:22.000000000 +1100
+++ ./drivers/md/md.c	2003-03-12 13:12:34.000000000 +1100
@@ -1593,8 +1593,7 @@ static int do_md_stop(mddev_t * mddev, i
 
 	if (mddev->pers) {
 		if (mddev->sync_thread) {
-			if (mddev->recovery_running > 0)
-				mddev->recovery_running = -1;
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			md_unregister_thread(mddev->sync_thread);
 			mddev->sync_thread = NULL;
 		}
@@ -2663,7 +2662,8 @@ static void status_resync(struct seq_fil
 		seq_printf(seq, "] ");
 	}
 	seq_printf(seq, " %s =%3lu.%lu%% (%lu/%lu)",
-		      (mddev->spares ? "recovery" : "resync"),
+		      (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ?
+		       "resync" : "recovery"),
 		      res/10, res % 10, resync, max_blocks);
 
 	/*
@@ -2896,8 +2896,7 @@ void md_done_sync(mddev_t *mddev, int bl
 	atomic_sub(blocks, &mddev->recovery_active);
 	wake_up(&mddev->recovery_wait);
 	if (!ok) {
-		mddev->recovery_error = -EIO;
-		mddev->recovery_running = -1;
+		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 		md_recover_arrays();
 		// stop recovery, signal do_sync ....
 	}
@@ -2927,7 +2926,8 @@ static inline void md_enter_safemode(mdd
 {
 
 	mddev_lock_uninterruptible(mddev);
-	if (mddev->safemode && !atomic_read(&mddev->writes_pending) && !mddev->in_sync && !mddev->recovery_running) {
+	if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
+	    !mddev->in_sync && mddev->recovery_cp == MaxSector) {
 		mddev->in_sync = 1;
 		md_update_sb(mddev);
 	}
@@ -2963,7 +2963,7 @@ static void md_do_sync(void *data)
 	unsigned long last_check;
 
 	/* just incase thread restarts... */
-	if (mddev->recovery_running <= 0)
+	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
 		return;
 
 	/* we overload curr_resync somewhat here.
@@ -3031,8 +3031,6 @@ static void md_do_sync(void *data)
 	init_waitqueue_head(&mddev->recovery_wait);
 	last_check = 0;
 
-	mddev->recovery_error = 0;
-
 	if (mddev->recovery_cp)
 		printk(KERN_INFO "md: resuming recovery of md%d from checkpoint.\n", mdidx(mddev));
 
@@ -3053,6 +3051,10 @@ static void md_do_sync(void *data)
 
 		last_check = j;
 
+		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery) ||
+		    test_bit(MD_RECOVERY_ERR, &mddev->recovery))
+			break;
+
 		blk_run_queues();
 
 	repeat:
@@ -3107,26 +3109,26 @@ static void md_do_sync(void *data)
  out:
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 
-	if (mddev->recovery_running < 0 && 
-		!mddev->recovery_error && mddev->curr_resync > 2)
-	{
-		/* interrupted but no write errors */
-		printk(KERN_INFO "md: checkpointing recovery of md%d.\n", mdidx(mddev));
-		mddev->recovery_cp = mddev->curr_resync;
-	}
-
 	/* tell personality that we are finished */
 	mddev->pers->sync_request(mddev, max_sectors, 1);
- skip:
-	mddev->curr_resync = 0;
+
 	if (err)
-		mddev->recovery_running = -1;
-	if (mddev->recovery_running > 0)
-		mddev->recovery_running = 0;
-	if (mddev->recovery_running == 0)
-		mddev->recovery_cp = MaxSector;
+		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
+	if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
+	    mddev->curr_resync > 2 &&
+	    mddev->curr_resync > mddev->recovery_cp) {
+		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
+			printk(KERN_INFO "md: checkpointing recovery of md%d.\n", mdidx(mddev));
+			mddev->recovery_cp = mddev->curr_resync;
+		} else
+			mddev->recovery_cp = MaxSector;
+	}
+
 	if (mddev->safemode)
 		md_enter_safemode(mddev);
+ skip:
+	mddev->curr_resync = 0;
+	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	md_recover_arrays();
 }
 
@@ -3136,10 +3138,10 @@ static void md_do_sync(void *data)
  * action that might be needed.
  * It does not do any resync itself, but rather "forks" off other threads
  * to do that as needed.
- * When it is determined that resync is needed, we set "->recovery_running" and
- * create a thread at ->sync_thread.
- * When the thread finishes it clears recovery_running (or sets an error)
- * and wakeup up this thread which will reap the thread and finish up.
+ * When it is determined that resync is needed, we set MD_RECOVERY_RUNNING in
+ * "->recovery" and create a thread at ->sync_thread.
+ * When the thread finishes it sets MD_RECOVERY_DONE (and might set MD_RECOVERY_ERR)
+ * and wakeups up this thread which will reap the thread and finish up.
  * This thread also removes any faulty devices (with nr_pending == 0).
  *
  * The overall approach is:
@@ -3160,31 +3162,32 @@ void md_do_recovery(void *data)
 	dprintk(KERN_INFO "md: recovery thread got woken up ...\n");
 
 	ITERATE_MDDEV(mddev,tmp) if (mddev_lock(mddev)==0) {
+		int spares =0;
 		if (!mddev->raid_disks || !mddev->pers || mddev->ro)
 			goto unlock;
 		if (mddev->sb_dirty)
 			md_update_sb(mddev);
-		if (mddev->recovery_running > 0)
+		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
+		    !test_bit(MD_RECOVERY_DONE, &mddev->recovery))
 			/* resync/recovery still happening */
 			goto unlock;
 		if (mddev->sync_thread) {
 			/* resync has finished, collect result */
 			md_unregister_thread(mddev->sync_thread);
 			mddev->sync_thread = NULL;
-			if (mddev->recovery_running == 0) {
+			if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery)) {
 				/* success...*/
 				/* activate any spares */
 				mddev->pers->spare_active(mddev);
-				mddev->spares = 0;
 			}
 			md_update_sb(mddev);
-			mddev->recovery_running = 0;
+			mddev->recovery = 0;
 			wake_up(&resync_wait);
 			goto unlock;
 		}
-		if (mddev->recovery_running) {
+		if (mddev->recovery) {
 			/* that's odd.. */
-			mddev->recovery_running = 0;
+			mddev->recovery = 0;
 			wake_up(&resync_wait);
 		}
 
@@ -3192,7 +3195,6 @@ void md_do_recovery(void *data)
 		 * remove any failed drives, then
 		 * add spares if possible
 		 */
-		mddev->spares = 0;
 		ITERATE_RDEV(mddev,rdev,rtmp) {
 			if (rdev->raid_disk >= 0 &&
 			    rdev->faulty &&
@@ -3201,35 +3203,35 @@ void md_do_recovery(void *data)
 				rdev->raid_disk = -1;
 			}
 			if (!rdev->faulty && rdev->raid_disk >= 0 && !rdev->in_sync)
-				mddev->spares++;
+				spares++;
 		}
 		if (mddev->degraded) {
 			ITERATE_RDEV(mddev,rdev,rtmp)
 				if (rdev->raid_disk < 0
 				    && !rdev->faulty) {
-					if (mddev->pers->hot_add_disk(mddev,rdev)) {
-						mddev->spares++;
-						mddev->recovery_cp = 0;
-					}
+					if (mddev->pers->hot_add_disk(mddev,rdev))
+						spares++;
 					else
 						break;
 				}
 		}
 
-		if (!mddev->spares && (mddev->recovery_cp == MaxSector )) {
+		if (!spares && (mddev->recovery_cp == MaxSector )) {
 			/* nothing we can do ... */
 			goto unlock;
 		}
 		if (mddev->pers->sync_request) {
+			set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+			if (!spares)
+				set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 			mddev->sync_thread = md_register_thread(md_do_sync,
 								mddev,
 								"md_resync");
 			if (!mddev->sync_thread) {
 				printk(KERN_ERR "md%d: could not start resync thread...\n", mdidx(mddev));
 				/* leave the spares where they are, it shouldn't hurt */
-				mddev->recovery_running = 0;
+				mddev->recovery = 0;
 			} else {
-				mddev->recovery_running = 1;
 				md_wakeup_thread(mddev->sync_thread);
 			}
 		}

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-03-12 13:12:22.000000000 +1100
+++ ./drivers/md/raid1.c	2003-03-12 13:12:18.000000000 +1100
@@ -623,10 +623,9 @@ static void error(mddev_t *mddev, mdk_rd
 		mddev->degraded++;
 		conf->working_disks--;
 		/*
-		 * if recovery was running, stop it now.
+		 * if recovery is running, make sure it aborts.
 		 */
-		if (mddev->recovery_running) 
-			mddev->recovery_running = -EIO;
+		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 	}
 	rdev->in_sync = 0;
 	rdev->faulty = 1;

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-03-12 13:12:22.000000000 +1100
+++ ./drivers/md/raid5.c	2003-03-12 13:12:18.000000000 +1100
@@ -463,10 +463,9 @@ static void error(mddev_t *mddev, mdk_rd
 			conf->failed_disks++;
 			rdev->in_sync = 0;
 			/*
-			 * if recovery was running, stop it now.
+			 * if recovery was running, make sure it aborts.
 			 */
-			if (mddev->recovery_running) 
-				mddev->recovery_running = -EIO;
+			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 		}
 		rdev->faulty = 1;
 		printk (KERN_ALERT

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2003-03-12 13:12:22.000000000 +1100
+++ ./include/linux/raid/md_k.h	2003-03-12 13:12:18.000000000 +1100
@@ -210,18 +210,24 @@ struct mddev_s
 	unsigned long			curr_resync;	/* blocks scheduled */
 	unsigned long			resync_mark;	/* a recent timestamp */
 	unsigned long			resync_mark_cnt;/* blocks written at resync_mark */
-	/* recovery_running is 0 for no recovery/resync,
-	 * 1 for active recovery
-	 * 2 for active resync
-	 * -error for an error (e.g. -EINTR)
-	 * it can only be set > 0 under reconfig_sem
+
+	/* recovery/resync flags 
+	 * RUNNING:  a thread is running, or about to be started
+	 * SYNC:     actually doing a resync, not a recovery
+	 * ERR:      and IO error was detected - abort the resync/recovery
+	 * INTR:     someone requested a (clean) early abort.
+	 * DONE:     thread is done and is waiting to be reaped
 	 */
-	int				recovery_running;
-	int				recovery_error;	/* error from recovery write */
+#define	MD_RECOVERY_RUNNING	0
+#define	MD_RECOVERY_SYNC	1
+#define	MD_RECOVERY_ERR		2
+#define	MD_RECOVERY_INTR	3
+#define	MD_RECOVERY_DONE	4
+	unsigned long			recovery;
+
 	int				in_sync;	/* know to not need resync */
 	struct semaphore		reconfig_sem;
 	atomic_t			active;
-	int				spares;
 
 	int				degraded;	/* whether md should consider
 							 * adding a spare
