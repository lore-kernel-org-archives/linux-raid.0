From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 22 of 22 - Generalise md sync threads
Date: Wed, 19 Jun 2002 11:02:27 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.55331.871841.691390@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Previously each raid personality (Well, 1 and 5) started their
own thread to do resync, but md.c had a single common thread to do
reconstruct.  Apart from being untidy, this means that you cannot
have two arrays reconstructing at the same time, though you can have
to array resyncing at the same time..

This patch changes the personalities so they don't start the resync,
but just leave a flag to say that it is needed.
The common thread (mdrecoveryd) now just monitors things and starts a
separate per-array thread whenever resync or recovery (or both) is
needed.
When the recovery finishes, mdrecoveryd will be woken up to re-lock
the device and activate the spares or whatever.

raid1 needs to know when resync/recovery starts and ends so it can
allocate and release resources.
It allocated when a resync request for stripe 0 is received.
Previously it deallocated for resync in it's own thread, and
deallocated for recovery when the spare is made active or inactive
(depending on success).

As raid1 doesn't own a thread anymore this needed to change.  So to
match the "alloc on 0", the md_do_resync now calls sync_request one
last time asking to sync one block past the end.  This is a signal to
release any resources.


 ----------- Diffstat output ------------
 ./drivers/md/md.c            |  245 +++++++++++++++++++++----------------------
 ./drivers/md/raid1.c         |  109 ++-----------------
 ./drivers/md/raid5.c         |   92 +---------------
 ./fs/block_dev.c             |    6 -
 ./include/linux/raid/md.h    |    4 
 ./include/linux/raid/md_k.h  |    7 -
 ./include/linux/raid/raid1.h |    3 
 ./include/linux/raid/raid5.h |    3 
 8 files changed, 156 insertions(+), 313 deletions(-)

--- ./drivers/md/md.c	2002/06/18 06:08:03	1.21
+++ ./drivers/md/md.c	2002/06/19 00:31:33	1.22
@@ -106,6 +106,7 @@
  * subsystems want to have a pre-defined structure
  */
 struct hd_struct md_hd_struct[MAX_MD_DEVS];
+static void md_recover_arrays(void);
 static mdk_thread_t *md_recovery_thread;
 
 int md_size[MAX_MD_DEVS];
@@ -1657,9 +1658,15 @@
 		return -EINVAL;
 	}
 
-	mddev->sb->state &= ~(1 << MD_SB_CLEAN);
+	mddev->in_sync = (mddev->sb->state & (1<<MD_SB_CLEAN));
+	/* if personality doesn't have "sync_request", then
+	 * a dirty array doesn't mean anything
+	 */
+	if (mddev->pers->sync_request)
+		mddev->sb->state &= ~(1 << MD_SB_CLEAN);
 	__md_update_sb(mddev);
 
+	md_recover_arrays();
 	/*
 	 * md_size has units of 1K blocks, which are
 	 * twice as large as sectors.
@@ -1699,8 +1706,6 @@
 		 * Kick recovery or resync if necessary
 		 */
 		md_recover_arrays();
-		if (mddev->pers->restart_resync)
-			mddev->pers->restart_resync(mddev);
 		err = 0;
 	} else {
 		printk(KERN_ERR "md: md%d has no personality assigned.\n",
@@ -1717,11 +1722,9 @@
 #define	STILL_IN_USE \
 "md: md%d still in use.\n"
 
-DECLARE_WAIT_QUEUE_HEAD(resync_wait);
-
 static int do_md_stop(mddev_t * mddev, int ro)
 {
-	int err = 0, resync_interrupted = 0;
+	int err = 0;
 	kdev_t dev = mddev_to_kdev(mddev);
 
 	if (atomic_read(&mddev->active)>1) {
@@ -1731,26 +1734,17 @@
 	}
 
 	if (mddev->pers) {
-		/*
-		 * It is safe to call stop here, it only frees private
-		 * data. Also, it tells us if a device is unstoppable
-		 * (eg. resyncing is in progress)
-		 */
-		if (mddev->pers->stop_resync)
-			if (mddev->pers->stop_resync(mddev))
-				resync_interrupted = 1;
-
-		if (mddev->recovery_running==1)
-			md_interrupt_thread(md_recovery_thread);
-
-		/*
-		 * This synchronizes with signal delivery to the
-		 * resync or reconstruction thread. It also nicely
-		 * hangs the process if some reconstruction has not
-		 * finished.
-		 */
-
-		wait_event(resync_wait, mddev->recovery_running <= 0);
+		if (mddev->sync_thread) {
+			if (mddev->recovery_running > 0)
+				mddev->recovery_running = -EINTR;
+			md_unregister_thread(mddev->sync_thread);
+			mddev->sync_thread = NULL;
+			if (mddev->spare) {
+				mddev->pers->diskop(mddev, &mddev->spare,
+						    DISKOP_SPARE_INACTIVE);
+				mddev->spare = NULL;
+			}
+		}
 
 		invalidate_device(dev, 1);
 
@@ -1776,7 +1770,7 @@
 			 * mark it clean only if there was no resync
 			 * interrupted.
 			 */
-			if (!mddev->recovery_running && !resync_interrupted) {
+			if (mddev->in_sync) {
 				printk(KERN_INFO "md: marking sb clean...\n");
 				mddev->sb->state |= 1 << MD_SB_CLEAN;
 			}
@@ -2795,6 +2789,7 @@
 	 */
 
 	daemonize();
+	reparent_to_init();
 
 	sprintf(current->comm, thread->name);
 	current->exit_signal = SIGCHLD;
@@ -2896,7 +2891,7 @@
 	kfree(thread);
 }
 
-void md_recover_arrays(void)
+static void md_recover_arrays(void)
 {
 	if (!md_recovery_thread) {
 		MD_BUG();
@@ -2931,10 +2926,8 @@
 	/*
 	 * if recovery was running, stop it now.
 	 */
-	if (mddev->pers->stop_resync)
-		mddev->pers->stop_resync(mddev);
-	if (mddev->recovery_running==1)
-		md_interrupt_thread(md_recovery_thread);
+	if (mddev->recovery_running) 
+		mddev->recovery_running = -EIO;
 	md_recover_arrays();
 
 	return 0;
@@ -2992,18 +2985,9 @@
 			sz += sprintf(page + sz, ".");
 		sz += sprintf(page + sz, "] ");
 	}
-	if (mddev->recovery_running==2)
-		/*
-		 * true resync
-		 */
-		sz += sprintf(page + sz, " resync =%3lu.%lu%% (%lu/%lu)",
-				res/10, res % 10, resync, max_blocks);
-	else
-		/*
-		 * recovery ...
-		 */
-		sz += sprintf(page + sz, " recovery =%3lu.%lu%% (%lu/%lu)",
-				res/10, res % 10, resync, max_blocks);
+	sz += sprintf(page + sz, " %s =%3lu.%lu%% (%lu/%lu)",
+		      (mddev->spare ? "recovery" : "resync"),
+		      res/10, res % 10, resync, max_blocks);
 
 	/*
 	 * We do not want to overflow, so the order of operands and
@@ -3078,12 +3062,11 @@
 		sz += mddev->pers->status (page+sz, mddev);
 
 		sz += sprintf(page+sz, "\n      ");
-		if (mddev->curr_resync) {
+		if (mddev->curr_resync > 1)
 			sz += status_resync (page+sz, mddev);
-		} else {
-			if (mddev->recovery_running < 0)
+		else if (mddev->curr_resync == 1)
 				sz += sprintf(page + sz, "	resync=DELAYED");
-		}
+
 		sz += sprintf(page + sz, "\n");
 		mddev_unlock(mddev);
 	}
@@ -3192,14 +3175,20 @@
 	atomic_sub(blocks, &mddev->recovery_active);
 	wake_up(&mddev->recovery_wait);
 	if (!ok) {
+		mddev->recovery_running = -EIO;
+		md_recover_arrays();
 		// stop recovery, signal do_sync ....
 	}
 }
 
+
+DECLARE_WAIT_QUEUE_HEAD(resync_wait);
+
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
-int md_do_sync(mddev_t *mddev, mdp_disk_t *spare)
+static void md_do_sync(void *data)
 {
+	mddev_t *mddev = data;
 	mddev_t *mddev2;
 	unsigned int max_sectors, currspeed = 0,
 		j, window, err;
@@ -3209,6 +3198,9 @@
 	struct list_head *tmp;
 	unsigned long last_check;
 
+	/* just incase thread restarts... */
+	if (mddev->recovery_running <= 0)
+		return;
 
 	/* we overload curr_resync somewhat here.
 	 * 0 == not engaged in resync at all
@@ -3304,7 +3296,6 @@
 			/*
 			 * got a signal, exit.
 			 */
-			mddev->curr_resync = 0;
 			printk(KERN_INFO "md: md_do_sync() got signal ... exiting\n");
 			flush_curr_signals();
 			err = -EINTR;
@@ -3339,98 +3330,112 @@
 	 */
 out:
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
+	/* tell personality that we are finished */
+	mddev->pers->sync_request(mddev, max_sectors, 1);
+
 	mddev->curr_resync = 0;
-	mddev->recovery_running = err;
-	wake_up(&resync_wait);
-	return err;
+	if (err)
+		mddev->recovery_running = err;
+	if (mddev->recovery_running > 0)
+		mddev->recovery_running = 0;
+	if (mddev->recovery_running == 0)
+		mddev->in_sync = 1;
+	md_recover_arrays();
 }
 
 
 /*
- * This is a kernel thread which syncs a spare disk with the active array
- *
- * the amount of foolproofing might seem to be a tad excessive, but an
- * early (not so error-safe) version of raid1syncd synced the first 0.5 gigs
- * of my root partition with the first 0.5 gigs of my /home partition ... so
- * i'm a bit nervous ;)
+ * This is the kernel thread that watches all md arrays for re-sync action
+ * that might be needed.
+ * It does not do any resync itself, but rather "forks" off other threads
+ * to do that as needed.
+ * When it is determined that resync is needed, we set "->recovery_running" and
+ * create a thread at ->sync_thread.
+ * When the thread finishes is clears recovery_running (or set and error)
+ * and wakeup up this thread which will reap the thread and finish up.
  */
 void md_do_recovery(void *data)
 {
-	int err;
 	mddev_t *mddev;
 	mdp_super_t *sb;
-	mdp_disk_t *spare;
 	struct list_head *tmp;
 
 	dprintk(KERN_INFO "md: recovery thread got woken up ...\n");
 
 	ITERATE_MDDEV(mddev,tmp) if (mddev_lock(mddev)==0) {
 		sb = mddev->sb;
-		if (!sb)
+		if (!sb || !mddev->pers || !mddev->pers->diskop || mddev->ro)
 			goto unlock;
-		if (mddev->recovery_running)
+		if (mddev->recovery_running > 0)
+			/* resync/recovery still happening */
 			goto unlock;
-		if (sb->active_disks == sb->raid_disks)
-			goto unlock;
-		if (!sb->spare_disks) {
-			printk(KERN_ERR "md%d: no spare disk to reconstruct array! "
-			       "-- continuing in degraded mode\n", mdidx(mddev));
+		if (mddev->sync_thread) {
+			/* resync has finished, collect result */
+			md_unregister_thread(mddev->sync_thread);
+			mddev->sync_thread = NULL;
+			if (mddev->recovery_running < 0) {
+				/* some sort of failure.
+				 * If we were doing a reconstruction,
+				 * we need to retrieve the spare
+				 */
+				if (mddev->spare) {
+					mddev->pers->diskop(mddev, &mddev->spare,
+							    DISKOP_SPARE_INACTIVE);
+					mddev->spare = NULL;
+				}
+			} else {
+				/* success...*/
+				if (mddev->spare) {
+					mddev->pers->diskop(mddev, &mddev->spare,
+							    DISKOP_SPARE_ACTIVE);
+					mark_disk_sync(mddev->spare);
+					mark_disk_active(mddev->spare);
+					sb->active_disks++;
+					sb->spare_disks--;
+					mddev->spare = NULL;
+				}
+			}
+			__md_update_sb(mddev);
+			mddev->recovery_running = 0;
+			wake_up(&resync_wait);
 			goto unlock;
 		}
-		/*
-		 * now here we get the spare and resync it.
-		 */
-		spare = get_spare(mddev);
-		if (!spare)
-			goto unlock;
-		printk(KERN_INFO "md%d: resyncing spare disk %s to replace failed disk\n",
-		       mdidx(mddev), partition_name(mk_kdev(spare->major,spare->minor)));
-		if (!mddev->pers->diskop)
-			goto unlock;
-		if (mddev->pers->diskop(mddev, &spare, DISKOP_SPARE_WRITE))
-			goto unlock;
-		mddev->recovery_running = 1;
-		mddev_unlock(mddev);
-		err = md_do_sync(mddev, spare);
-		mddev_lock(mddev); /* FIXME this can fail or deadlock with do_md_close */
-		if (err == -EIO) {
-			printk(KERN_INFO "md%d: spare disk %s failed, skipping to next spare.\n",
-			       mdidx(mddev), partition_name(mk_kdev(spare->major,spare->minor)));
-			if (!disk_faulty(spare)) {
-				mddev->pers->diskop(mddev,&spare,DISKOP_SPARE_INACTIVE);
-				mark_disk_faulty(spare);
-				mark_disk_nonsync(spare);
-				mark_disk_inactive(spare);
-				sb->spare_disks--;
-				sb->working_disks--;
-				sb->failed_disks++;
-			}
-		} else
-			if (disk_faulty(spare))
-				mddev->pers->diskop(mddev, &spare,
-						DISKOP_SPARE_INACTIVE);
-		if (err == -EINTR || err == -ENOMEM) {
-			/*
-			 * Recovery got interrupted, or ran out of mem ...
-			 * signal back that we have finished using the array.
-			 */
-			mddev->pers->diskop(mddev, &spare,
-							 DISKOP_SPARE_INACTIVE);
+		if (mddev->recovery_running) {
+			/* that's odd.. */
+			mddev->recovery_running = 0;
+			wake_up(&resync_wait);
+		}
+
+		if (sb->active_disks < sb->raid_disks) {
+			mddev->spare = get_spare(mddev);
+			if (!mddev->spare)
+				printk(KERN_ERR "md%d: no spare disk to reconstruct array! "
+				       "-- continuing in degraded mode\n", mdidx(mddev));
+			else
+				printk(KERN_INFO "md%d: resyncing spare disk %s to replace failed disk\n",
+				       mdidx(mddev), partition_name(mk_kdev(mddev->spare->major,mddev->spare->minor)));
+		}
+		if (!mddev->spare && mddev->in_sync) {
+			/* nothing we can do ... */
 			goto unlock;
 		}
-		if (!disk_faulty(spare)) {
-			/*
-			 * the SPARE_ACTIVE diskop possibly changes the
-			 * pointer too
-			 */
-			mddev->pers->diskop(mddev, &spare, DISKOP_SPARE_ACTIVE);
-			mark_disk_sync(spare);
-			mark_disk_active(spare);
-			sb->active_disks++;
-			sb->spare_disks--;
+		if (mddev->pers->sync_request) {
+			mddev->sync_thread = md_register_thread(md_do_sync,
+								mddev,
+								"md_resync");
+			if (!mddev->sync_thread) {
+				printk(KERN_ERR "md%d: could not start resync thread...\n", mdidx(mddev));
+				if (mddev->spare)
+					mddev->pers->diskop(mddev, &mddev->spare, DISKOP_SPARE_INACTIVE);
+				mddev->spare = NULL;
+				mddev->recovery_running = 0;
+			} else {
+				if (mddev->spare)
+					mddev->pers->diskop(mddev, &mddev->spare, DISKOP_SPARE_WRITE);
+				mddev->recovery_running = 1;
+				md_wakeup_thread(mddev->sync_thread);
+			}
 		}
-		__md_update_sb(mddev);
-		mddev->recovery_running = 0;
 	unlock:
 		mddev_unlock(mddev);
 	}
@@ -3900,10 +3905,8 @@
 EXPORT_SYMBOL(unregister_md_personality);
 EXPORT_SYMBOL(partition_name);
 EXPORT_SYMBOL(md_error);
-EXPORT_SYMBOL(md_do_sync);
 EXPORT_SYMBOL(md_sync_acct);
 EXPORT_SYMBOL(md_done_sync);
-EXPORT_SYMBOL(md_recover_arrays);
 EXPORT_SYMBOL(md_register_thread);
 EXPORT_SYMBOL(md_unregister_thread);
 EXPORT_SYMBOL(md_update_sb);
--- ./drivers/md/raid5.c	2002/06/18 06:08:03	1.8
+++ ./drivers/md/raid5.c	2002/06/19 00:31:33	1.9
@@ -1037,7 +1037,7 @@
 				    ) &&
 			    !test_bit(R5_UPTODATE, &dev->flags)) {
 				if (conf->disks[i].operational 
-/*				    && !(conf->resync_parity && i == sh->pd_idx) */
+/*				    && !(!mddev->insync && i == sh->pd_idx) */
 					)
 					rmw++;
 				else rmw += 2*disks;  /* cannot read it */
@@ -1303,6 +1303,10 @@
 	int raid_disks = conf->raid_disks;
 	int data_disks = raid_disks-1;
 
+	if (sector_nr >= mddev->sb->size <<1)
+		/* just being told to finish up .. nothing to do */
+		return 0;
+
 	first_sector = raid5_compute_sector(stripe*data_disks*sectors_per_chunk
 		+ chunk_offset, raid_disks, data_disks, &dd_idx, &pd_idx, conf);
 	sh = get_active_stripe(conf, sector_nr, pd_idx, 0);
@@ -1372,28 +1376,6 @@
 	PRINTK("--- raid5d inactive\n");
 }
 
-/*
- * Private kernel thread for parity reconstruction after an unclean
- * shutdown. Reconstruction on spare drives in case of a failed drive
- * is done by the generic mdsyncd.
- */
-static void raid5syncd (void *data)
-{
-	raid5_conf_t *conf = data;
-	mddev_t *mddev = conf->mddev;
-
-	if (!conf->resync_parity)
-		return;
-	if (mddev->recovery_running != 2)
-		return;
-	if (md_do_sync(mddev,NULL)) {
-		printk("raid5: resync aborted!\n");
-		return;
-	}
-	conf->resync_parity = 0;
-	printk("raid5: resync finished.\n");
-}
-
 static int run (mddev_t *mddev)
 {
 	raid5_conf_t *conf;
@@ -1403,7 +1385,6 @@
 	mdk_rdev_t *rdev;
 	struct disk_info *disk;
 	struct list_head *tmp;
-	int start_recovery = 0;
 
 	MOD_INC_USE_COUNT;
 
@@ -1555,9 +1536,10 @@
 		goto abort;
 	}
 
-	if (conf->working_disks != sb->raid_disks) {
-		printk(KERN_ALERT "raid5: md%d, not all disks are operational -- trying to recover array\n", mdidx(mddev));
-		start_recovery = 1;
+	if (conf->failed_disks == 1 &&
+	    !(sb->state & (1<<MD_SB_CLEAN))) {
+		printk(KERN_ERR "raid5: cannot start dirty degraded array for md%d\n", mdidx(mddev));
+		goto abort;
 	}
 
 	{
@@ -1575,6 +1557,7 @@
 	if (grow_stripes(conf, conf->max_nr_stripes)) {
 		printk(KERN_ERR "raid5: couldn't allocate %dkB for buffers\n", memory);
 		shrink_stripes(conf);
+		md_unregister_thread(conf->thread);
 		goto abort;
 	} else
 		printk(KERN_INFO "raid5: allocated %dkB for md%d\n", memory, mdidx(mddev));
@@ -1599,24 +1582,6 @@
 	else
 		printk(KERN_ALERT "raid5: raid level %d set md%d active with %d out of %d devices, algorithm %d\n", conf->level, mdidx(mddev), sb->active_disks, sb->raid_disks, conf->algorithm);
 
-	if (!start_recovery && !(sb->state & (1 << MD_SB_CLEAN))) {
-		const char * name = "raid5syncd";
-
-		conf->resync_thread = md_register_thread(raid5syncd, conf,name);
-		if (!conf->resync_thread) {
-			printk(KERN_ERR "raid5: couldn't allocate thread for md%d\n", mdidx(mddev));
-			goto abort;
-		}
-
-		printk("raid5: raid set md%d not clean; reconstructing parity\n", mdidx(mddev));
-		conf->resync_parity = 1;
-		mddev->recovery_running = 2;
-		md_wakeup_thread(conf->resync_thread);
-	}
-
-	print_raid5_conf(conf);
-	if (start_recovery)
-		md_recover_arrays();
 	print_raid5_conf(conf);
 
 	/* Ok, everything is just fine now */
@@ -1635,47 +1600,12 @@
 	return -EIO;
 }
 
-static int stop_resync (mddev_t *mddev)
-{
-	raid5_conf_t *conf = mddev_to_conf(mddev);
-	mdk_thread_t *thread = conf->resync_thread;
-
-	if (thread) {
-		if (conf->resync_parity) {
-			md_interrupt_thread(thread);
-			printk(KERN_INFO "raid5: parity resync was not fully finished, restarting next time.\n");
-			return 1;
-		}
-		return 0;
-	}
-	return 0;
-}
-
-static int restart_resync (mddev_t *mddev)
-{
-	raid5_conf_t *conf = mddev_to_conf(mddev);
-
-	if (conf->resync_parity) {
-		if (!conf->resync_thread) {
-			MD_BUG();
-			return 0;
-		}
-		printk("raid5: waking up raid5resync.\n");
-		mddev->recovery_running = 2;
-		md_wakeup_thread(conf->resync_thread);
-		return 1;
-	} else
-		printk("raid5: no restart-resync needed.\n");
-	return 0;
-}
 
 
 static int stop (mddev_t *mddev)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 
-	if (conf->resync_thread)
-		md_unregister_thread(conf->resync_thread);
 	md_unregister_thread(conf->thread);
 	shrink_stripes(conf);
 	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
@@ -2050,8 +1980,6 @@
 	status:		status,
 	error_handler:	error,
 	diskop:		diskop,
-	stop_resync:	stop_resync,
-	restart_resync:	restart_resync,
 	sync_request:	sync_request
 };
 
--- ./drivers/md/raid1.c	2002/06/18 06:08:03	1.4
+++ ./drivers/md/raid1.c	2002/06/19 00:31:33	1.5
@@ -333,7 +333,7 @@
 	 * device if no resync is going on, or below the resync window.
 	 * We take the first readable disk when above the resync window.
 	 */
-	if (conf->resync_mirrors && (this_sector + sectors >= conf->next_resync)) {
+	if (!conf->mddev->in_sync && (this_sector + sectors >= conf->next_resync)) {
 		/* make sure that disk is operational */
 		new_disk = 0;
 		while (!conf->mirrors[new_disk].operational || conf->mirrors[new_disk].write_only) {
@@ -652,6 +652,9 @@
 	if (conf->barrier) BUG();
 	if (waitqueue_active(&conf->wait_idle)) BUG();
 	if (waitqueue_active(&conf->wait_resume)) BUG();
+
+	mempool_destroy(conf->r1buf_pool);
+	conf->r1buf_pool = NULL;
 }
 
 static int diskop(mddev_t *mddev, mdp_disk_t **d, int state)
@@ -768,7 +771,6 @@
 	 * Deactivate a spare disk:
 	 */
 	case DISKOP_SPARE_INACTIVE:
-		close_sync(conf);
 		sdisk = conf->mirrors + spare_disk;
 		sdisk->operational = 0;
 		sdisk->write_only = 0;
@@ -781,7 +783,6 @@
 	 * property)
 	 */
 	case DISKOP_SPARE_ACTIVE:
-		close_sync(conf);
 		sdisk = conf->mirrors + spare_disk;
 		fdisk = conf->mirrors + failed_disk;
 
@@ -915,10 +916,6 @@
 	}
 abort:
 	spin_unlock_irq(&conf->device_lock);
-	if (state == DISKOP_SPARE_ACTIVE || state == DISKOP_SPARE_INACTIVE) {
-		mempool_destroy(conf->r1buf_pool);
-		conf->r1buf_pool = NULL;
-	}
 
 	print_conf(conf);
 	return err;
@@ -1008,7 +1005,7 @@
 			 * we read from here, no need to write
 			 */
 			continue;
-		if (i < conf->raid_disks && !conf->resync_mirrors)
+		if (i < conf->raid_disks && mddev->in_sync)
 			/*
 			 * don't need to write this we are just rebuilding
 			 */
@@ -1113,29 +1110,6 @@
 	spin_unlock_irqrestore(&retry_list_lock, flags);
 }
 
-/*
- * Private kernel thread to reconstruct mirrors after an unclean
- * shutdown.
- */
-static void raid1syncd(void *data)
-{
-	conf_t *conf = data;
-	mddev_t *mddev = conf->mddev;
-
-	if (!conf->resync_mirrors)
-		return;
-	if (mddev->recovery_running != 2)
-		return;
-	if (!md_do_sync(mddev, NULL)) {
-		/*
-		 * Only if everything went Ok.
-		 */
-		conf->resync_mirrors = 0;
-	}
-
-	close_sync(conf);
-
-}
 
 static int init_resync(conf_t *conf)
 {
@@ -1170,9 +1144,16 @@
 	sector_t max_sector, nr_sectors;
 	int disk, partial;
 
-	if (!sector_nr)
+	if (sector_nr == 0)
 		if (init_resync(conf))
 			return -ENOMEM;
+
+	max_sector = mddev->sb->size << 1;
+	if (sector_nr >= max_sector) {
+		close_sync(conf);
+		return 0;
+	}
+
 	/*
 	 * If there is non-resync activity waiting for us then
 	 * put in a delay to throttle resync.
@@ -1209,10 +1190,6 @@
 	r1_bio->sector = sector_nr;
 	r1_bio->cmd = SPECIAL;
 
-	max_sector = mddev->sb->size << 1;
-	if (sector_nr >= max_sector)
-		BUG();
-
 	bio = r1_bio->master_bio;
 	nr_sectors = RESYNC_BLOCK_SIZE >> 9;
 	if (max_sector - sector_nr < nr_sectors)
@@ -1295,7 +1272,6 @@
 	mdp_disk_t *descriptor;
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
-	int start_recovery = 0;
 
 	MOD_INC_USE_COUNT;
 
@@ -1447,10 +1423,6 @@
 	conf->last_used = j;
 
 
-	if (conf->working_disks != sb->raid_disks) {
-		printk(KERN_ALERT "raid1: md%d, not all disks are operational -- trying to recover array\n", mdidx(mddev));
-		start_recovery = 1;
-	}
 
 	{
 		const char * name = "raid1d";
@@ -1462,21 +1434,6 @@
 		}
 	}
 
-	if (!start_recovery && !(sb->state & (1 << MD_SB_CLEAN)) &&
-						(conf->working_disks > 1)) {
-		const char * name = "raid1syncd";
-
-		conf->resync_thread = md_register_thread(raid1syncd, conf, name);
-		if (!conf->resync_thread) {
-			printk(THREAD_ERROR, mdidx(mddev));
-			goto out_free_conf;
-		}
-
-		printk(START_RESYNC, mdidx(mddev));
-		conf->resync_mirrors = 1;
-		mddev->recovery_running = 2;
-		md_wakeup_thread(conf->resync_thread);
-	}
 
 	/*
 	 * Regenerate the "device is in sync with the raid set" bit for
@@ -1493,10 +1450,6 @@
 	}
 	sb->active_disks = conf->working_disks;
 
-	if (start_recovery)
-		md_recover_arrays();
-
-
 	printk(ARRAY_IS_ACTIVE, mdidx(mddev), sb->active_disks, sb->raid_disks);
 	/*
 	 * Ok, everything is just fine now
@@ -1516,46 +1469,12 @@
 	return -EIO;
 }
 
-static int stop_resync(mddev_t *mddev)
-{
-	conf_t *conf = mddev_to_conf(mddev);
-
-	if (conf->resync_thread) {
-		if (conf->resync_mirrors) {
-			md_interrupt_thread(conf->resync_thread);
-
-			printk(KERN_INFO "raid1: mirror resync was not fully finished, restarting next time.\n");
-			return 1;
-		}
-		return 0;
-	}
-	return 0;
-}
-
-static int restart_resync(mddev_t *mddev)
-{
-	conf_t *conf = mddev_to_conf(mddev);
-
-	if (conf->resync_mirrors) {
-		if (!conf->resync_thread) {
-			MD_BUG();
-			return 0;
-		}
-		mddev->recovery_running = 2;
-		md_wakeup_thread(conf->resync_thread);
-		return 1;
-	}
-	return 0;
-}
-
 static int stop(mddev_t *mddev)
 {
 	conf_t *conf = mddev_to_conf(mddev);
 	int i;
 
 	md_unregister_thread(conf->thread);
-	if (conf->resync_thread)
-		md_unregister_thread(conf->resync_thread);
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
 	for (i = 0; i < MD_SB_DISKS; i++)
@@ -1576,8 +1495,6 @@
 	status:		status,
 	error_handler:	error,
 	diskop:		diskop,
-	stop_resync:	stop_resync,
-	restart_resync:	restart_resync,
 	sync_request:	sync_request
 };
 
--- ./include/linux/raid/md_k.h	2002/06/18 06:05:22	1.9
+++ ./include/linux/raid/md_k.h	2002/06/19 00:31:33	1.10
@@ -181,6 +181,8 @@
 	struct list_head 		disks;
 	int				sb_dirty;
 	int				ro;
+
+	struct mdk_thread_s		*sync_thread;	/* doing resync or reconstruct */
 	unsigned long			curr_resync;	/* blocks scheduled */
 	unsigned long			resync_mark;	/* a recent timestamp */
 	unsigned long			resync_mark_cnt;/* blocks written at resync_mark */
@@ -191,8 +193,10 @@
 	 * it can only be set > 0 under reconfig_sem
 	 */
 	int				recovery_running;
+	int				in_sync;	/* know to not need resync */
 	struct semaphore		reconfig_sem;
 	atomic_t			active;
+	mdp_disk_t			*spare;
 
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
@@ -222,9 +226,6 @@
  * SPARE_ACTIVE expects such a change)
  */
 	int (*diskop) (mddev_t *mddev, mdp_disk_t **descriptor, int state);
-
-	int (*stop_resync)(mddev_t *mddev);
-	int (*restart_resync)(mddev_t *mddev);
 	int (*sync_request)(mddev_t *mddev, sector_t sector_nr, int go_faster);
 };
 
--- ./include/linux/raid/raid5.h	2002/06/18 03:26:36	1.2
+++ ./include/linux/raid/raid5.h	2002/06/19 00:31:33	1.3
@@ -204,12 +204,11 @@
 struct raid5_private_data {
 	struct stripe_head	**stripe_hashtbl;
 	mddev_t			*mddev;
-	mdk_thread_t		*thread, *resync_thread;
+	mdk_thread_t		*thread;
 	struct disk_info	disks[MD_SB_DISKS];
 	struct disk_info	*spare;
 	int			chunk_size, level, algorithm;
 	int			raid_disks, working_disks, failed_disks;
-	int			resync_parity;
 	int			max_nr_stripes;
 
 	struct list_head	handle_list; /* stripes needing handling */
--- ./include/linux/raid/md.h	2002/06/18 06:08:03	1.4
+++ ./include/linux/raid/md.h	2002/06/19 00:31:33	1.5
@@ -76,12 +76,8 @@
 extern void md_wakeup_thread(mdk_thread_t *thread);
 extern void md_interrupt_thread (mdk_thread_t *thread);
 extern void md_update_sb (mddev_t *mddev);
-extern int md_do_sync(mddev_t *mddev, mdp_disk_t *spare);
 extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
 extern void md_sync_acct(kdev_t dev, unsigned long nr_sectors);
-extern void md_recover_arrays (void);
-extern int md_notify_reboot(struct notifier_block *this,
-					unsigned long code, void *x);
 extern int md_error (mddev_t *mddev, struct block_device *bdev);
 extern int md_run_setup(void);
 
--- ./include/linux/raid/raid1.h	2002/06/18 06:08:33	1.1
+++ ./include/linux/raid/raid1.h	2002/06/19 00:31:33	1.2
@@ -33,8 +33,7 @@
 	int			working_disks;
 	int			last_used;
 	sector_t		next_seq_sect;
-	mdk_thread_t		*thread, *resync_thread;
-	int			resync_mirrors;
+	mdk_thread_t		*thread;
 	mirror_info_t		*spare;
 	spinlock_t		device_lock;
 
--- ./fs/block_dev.c	2002/06/18 04:13:08	1.2
+++ ./fs/block_dev.c	2002/06/19 00:31:33	1.3
@@ -389,9 +389,9 @@
 	else if (bdev->bd_contains == bdev)
 		res = 0;
 
-	else if (bdev->bd_contains->bd_holders == bd_claim)
-		res = 0
-	else if (bdev->bd_contains->bd_holders != NULL)
+	else if (bdev->bd_contains->bd_holder == bd_claim)
+		res = 0;
+	else if (bdev->bd_contains->bd_holder != NULL)
 		res = -EBUSY;
 	else
 		res = 0;
