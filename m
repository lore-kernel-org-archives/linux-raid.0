From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 7 of 12 - Remove md_recoveryd thread for md
Date: Wed, 12 Mar 2003 14:59:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18sxOz-0004q6-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

The md_recoveryd thread is responsible for initiating and cleaning
up resync threads.
This job can be equally well done by the per-array threads
for those arrays which might need it.

So the mdrecoveryd thread is gone and the core code that
it ran is now run by raid5d, raid1d or multipathd.

We add an MD_RECOVERY_NEEDED flag so those daemon don't have
to bother trying to lock the md array unless it is likely
that something needs to be done.

Also modify the names of all threads to have the number of
md device.

 ----------- Diffstat output ------------
 ./drivers/md/md.c                |   84 +++++++++++++++++----------------------
 ./drivers/md/multipath.c         |   15 +++---
 ./drivers/md/raid1.c             |   24 +++++------
 ./drivers/md/raid5.c             |   34 +++++++--------
 ./include/linux/raid/md.h        |    7 +--
 ./include/linux/raid/md_k.h      |    7 ++-
 ./include/linux/raid/multipath.h |    1 
 ./include/linux/raid/raid1.h     |    2 
 ./include/linux/raid/raid5.h     |    2 
 9 files changed, 80 insertions(+), 96 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-12 13:14:58.000000000 +1100
+++ ./drivers/md/md.c	2003-03-12 13:15:04.000000000 +1100
@@ -124,9 +124,6 @@ static ctl_table raid_root_table[] = {
 	{ .ctl_name = 0 }
 };
 
-static void md_recover_arrays(void);
-static mdk_thread_t *md_recovery_thread;
-
 sector_t md_size[MAX_MD_DEVS];
 
 static struct block_device_operations md_fops;
@@ -1527,7 +1524,8 @@ static int do_md_run(mddev_t * mddev)
 		mddev->in_sync = 1;
 	
 	md_update_sb(mddev);
-	md_recover_arrays();
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
 	set_capacity(disk, md_size[mdidx(mddev)]<<1);
 	return (0);
 }
@@ -1563,7 +1561,8 @@ static int restart_array(mddev_t *mddev)
 		/*
 		 * Kick recovery or resync if necessary
 		 */
-		md_recover_arrays();
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
 		err = 0;
 	} else {
 		printk(KERN_ERR "md: md%d has no personality assigned.\n",
@@ -2133,7 +2132,8 @@ static int hot_add_disk(mddev_t * mddev,
 	 * Kick recovery, maybe this spare has to be added to the
 	 * array immediately.
 	 */
-	md_recover_arrays();
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
 
 	return 0;
 
@@ -2482,7 +2482,7 @@ int md_thread(void * arg)
 	 * Detach thread
 	 */
 
-	daemonize(thread->name);
+	daemonize(thread->name, mdidx(thread->mddev));
 
 	current->exit_signal = SIGCHLD;
 	allow_signal(SIGKILL);
@@ -2503,7 +2503,7 @@ int md_thread(void * arg)
 
 	complete(thread->event);
 	while (thread->run) {
-		void (*run)(void *data);
+		void (*run)(mddev_t *);
 
 		wait_event_interruptible(thread->wqueue,
 					 test_bit(THREAD_WAKEUP, &thread->flags));
@@ -2514,7 +2514,7 @@ int md_thread(void * arg)
 
 		run = thread->run;
 		if (run) {
-			run(thread->data);
+			run(thread->mddev);
 			blk_run_queues();
 		}
 		if (signal_pending(current))
@@ -2531,8 +2531,8 @@ void md_wakeup_thread(mdk_thread_t *thre
 	wake_up(&thread->wqueue);
 }
 
-mdk_thread_t *md_register_thread(void (*run) (void *),
-						void *data, const char *name)
+mdk_thread_t *md_register_thread(void (*run) (mddev_t *), mddev_t *mddev,
+				 const char *name)
 {
 	mdk_thread_t *thread;
 	int ret;
@@ -2549,7 +2549,7 @@ mdk_thread_t *md_register_thread(void (*
 	init_completion(&event);
 	thread->event = &event;
 	thread->run = run;
-	thread->data = data;
+	thread->mddev = mddev;
 	thread->name = name;
 	ret = kernel_thread(md_thread, thread, 0);
 	if (ret < 0) {
@@ -2584,16 +2584,6 @@ void md_unregister_thread(mdk_thread_t *
 	kfree(thread);
 }
 
-static void md_recover_arrays(void)
-{
-	if (!md_recovery_thread) {
-		MD_BUG();
-		return;
-	}
-	md_wakeup_thread(md_recovery_thread);
-}
-
-
 void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	dprintk("md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
@@ -2611,7 +2601,8 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 	if (!mddev->pers->error_handler)
 		return;
 	mddev->pers->error_handler(mddev,rdev);
-	md_recover_arrays();
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
 }
 
 /* seq_file implementation /proc/mdstat */
@@ -2897,7 +2888,7 @@ void md_done_sync(mddev_t *mddev, int bl
 	wake_up(&mddev->recovery_wait);
 	if (!ok) {
 		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
-		md_recover_arrays();
+		md_wakeup_thread(mddev->thread);
 		// stop recovery, signal do_sync ....
 	}
 }
@@ -2917,10 +2908,10 @@ void md_write_start(mddev_t *mddev)
 		atomic_inc(&mddev->writes_pending);
 }
 
-void md_write_end(mddev_t *mddev, mdk_thread_t *thread)
+void md_write_end(mddev_t *mddev)
 {
 	if (atomic_dec_and_test(&mddev->writes_pending) && mddev->safemode)
-		md_wakeup_thread(thread);
+		md_wakeup_thread(mddev->thread);
 }
 static inline void md_enter_safemode(mddev_t *mddev)
 {
@@ -2950,9 +2941,8 @@ DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
-static void md_do_sync(void *data)
+static void md_do_sync(mddev_t *mddev)
 {
-	mddev_t *mddev = data;
 	mddev_t *mddev2;
 	unsigned int max_sectors, currspeed = 0,
 		j, window, err;
@@ -3129,13 +3119,16 @@ static void md_do_sync(void *data)
  skip:
 	mddev->curr_resync = 0;
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
-	md_recover_arrays();
+	md_wakeup_thread(mddev->thread);
 }
 
 
 /*
- * This is the kernel thread that watches all md arrays for re-sync and other
- * action that might be needed.
+ * This routine is regularly called by all per-raid-array threads to
+ * deal with generic issues like resync and super-block update.
+ * Raid personalities that don't have a thread (linear/raid0) do not
+ * need this as they never do any recovery or update the superblock.
+ *
  * It does not do any resync itself, but rather "forks" off other threads
  * to do that as needed.
  * When it is determined that resync is needed, we set MD_RECOVERY_RUNNING in
@@ -3152,19 +3145,24 @@ static void md_do_sync(void *data)
  *  5/ If array is degraded, try to add spares devices
  *  6/ If array has spares or is not in-sync, start a resync thread.
  */
-void md_do_recovery(void *data)
+void md_check_recovery(mddev_t *mddev)
 {
-	mddev_t *mddev;
 	mdk_rdev_t *rdev;
-	struct list_head *tmp, *rtmp;
+	struct list_head *rtmp;
 
 
 	dprintk(KERN_INFO "md: recovery thread got woken up ...\n");
 
-	ITERATE_MDDEV(mddev,tmp) if (mddev_lock(mddev)==0) {
+	if (mddev->ro)
+		return;
+	if ( ! (
+		mddev->sb_dirty ||
+		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
+		test_bit(MD_RECOVERY_DONE, &mddev->recovery)
+		))
+		return;
+	if (mddev_trylock(mddev)==0) {
 		int spares =0;
-		if (!mddev->raid_disks || !mddev->pers || mddev->ro)
-			goto unlock;
 		if (mddev->sb_dirty)
 			md_update_sb(mddev);
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
@@ -3226,7 +3224,7 @@ void md_do_recovery(void *data)
 				set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 			mddev->sync_thread = md_register_thread(md_do_sync,
 								mddev,
-								"md_resync");
+								"md%d_resync");
 			if (!mddev->sync_thread) {
 				printk(KERN_ERR "md%d: could not start resync thread...\n", mdidx(mddev));
 				/* leave the spares where they are, it shouldn't hurt */
@@ -3238,8 +3236,6 @@ void md_do_recovery(void *data)
 	unlock:
 		mddev_unlock(mddev);
 	}
-	dprintk(KERN_INFO "md: recovery thread finished ...\n");
-
 }
 
 int md_notify_reboot(struct notifier_block *this,
@@ -3292,7 +3288,6 @@ static void md_geninit(void)
 
 int __init md_init(void)
 {
-	static char * name = "mdrecoveryd";
 	int minor;
 
 	printk(KERN_INFO "md: md driver %d.%d.%d MAX_MD_DEVS=%d, MD_SB_DISKS=%d\n",
@@ -3312,11 +3307,6 @@ int __init md_init(void)
 			       S_IFBLK | S_IRUSR | S_IWUSR, &md_fops, NULL);
 	}
 
-	md_recovery_thread = md_register_thread(md_do_recovery, NULL, name);
-	if (!md_recovery_thread)
-		printk(KERN_ALERT
-		       "md: bug: couldn't allocate md_recovery_thread\n");
-
 	register_reboot_notifier(&md_notifier);
 	raid_table_header = register_sysctl_table(raid_root_table, 1);
 
@@ -3374,7 +3364,6 @@ static __exit void md_exit(void)
 {
 	int i;
 	blk_unregister_region(MKDEV(MAJOR_NR,0), MAX_MD_DEVS);
-	md_unregister_thread(md_recovery_thread);
 	for (i=0; i < MAX_MD_DEVS; i++)
 		devfs_remove("md/%d", i);
 	devfs_remove("md");
@@ -3414,4 +3403,5 @@ EXPORT_SYMBOL(md_unregister_thread);
 EXPORT_SYMBOL(md_wakeup_thread);
 EXPORT_SYMBOL(md_print_devices);
 EXPORT_SYMBOL(md_interrupt_thread);
+EXPORT_SYMBOL(md_check_recovery);
 MODULE_LICENSE("GPL");

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-03-12 13:14:58.000000000 +1100
+++ ./drivers/md/multipath.c	2003-03-12 13:15:04.000000000 +1100
@@ -86,7 +86,6 @@ static void multipath_reschedule_retry (
 {
 	unsigned long flags;
 	mddev_t *mddev = mp_bh->mddev;
-	multipath_conf_t *conf = mddev_to_conf(mddev);
 
 	spin_lock_irqsave(&retry_list_lock, flags);
 	if (multipath_retry_list == NULL)
@@ -95,7 +94,7 @@ static void multipath_reschedule_retry (
 	multipath_retry_tail = &mp_bh->next_mp;
 	mp_bh->next_mp = NULL;
 	spin_unlock_irqrestore(&retry_list_lock, flags);
-	md_wakeup_thread(conf->thread);
+	md_wakeup_thread(mddev->thread);
 }
 
 
@@ -333,14 +332,14 @@ abort:
  *	3.	Performs writes following reads for array syncronising.
  */
 
-static void multipathd (void *data)
+static void multipathd (mddev_t *mddev)
 {
 	struct multipath_bh *mp_bh;
 	struct bio *bio;
 	unsigned long flags;
-	mddev_t *mddev;
 	mdk_rdev_t *rdev;
 
+	md_check_recovery(mddev);
 	for (;;) {
 		spin_lock_irqsave(&retry_list_lock, flags);
 		mp_bh = multipath_retry_list;
@@ -470,10 +469,10 @@ static int multipath_run (mddev_t *mddev
 	}
 
 	{
-		const char * name = "multipathd";
+		const char * name = "md%d_multipath";
 
-		conf->thread = md_register_thread(multipathd, conf, name);
-		if (!conf->thread) {
+		mddev->thread = md_register_thread(multipathd, mddev, name);
+		if (!mddev->thread) {
 			printk(THREAD_ERROR, mdidx(mddev));
 			goto out_free_conf;
 		}
@@ -512,7 +511,7 @@ static int multipath_stop (mddev_t *mdde
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 
-	md_unregister_thread(conf->thread);
+	md_unregister_thread(mddev->thread);
 	mempool_destroy(conf->pool);
 	kfree(conf);
 	mddev->private = NULL;

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-03-12 13:14:58.000000000 +1100
+++ ./drivers/md/raid1.c	2003-03-12 13:15:04.000000000 +1100
@@ -225,13 +225,12 @@ static void reschedule_retry(r1bio_t *r1
 {
 	unsigned long flags;
 	mddev_t *mddev = r1_bio->mddev;
-	conf_t *conf = mddev_to_conf(mddev);
 
 	spin_lock_irqsave(&retry_list_lock, flags);
 	list_add(&r1_bio->retry_list, &retry_list_head);
 	spin_unlock_irqrestore(&retry_list_lock, flags);
 
-	md_wakeup_thread(conf->thread);
+	md_wakeup_thread(mddev->thread);
 }
 
 /*
@@ -320,7 +319,7 @@ static int end_request(struct bio *bio, 
 		 * already.
 		 */
 		if (atomic_dec_and_test(&r1_bio->remaining)) {
-			md_write_end(r1_bio->mddev,conf->thread);
+			md_write_end(r1_bio->mddev);
 			raid_end_bio_io(r1_bio, uptodate);
 		}	
 	}
@@ -542,7 +541,7 @@ static int make_request(request_queue_t 
 		 * If all mirrors are non-operational
 		 * then return an IO error:
 		 */
-		md_write_end(mddev,conf->thread);
+		md_write_end(mddev);
 		raid_end_bio_io(r1_bio, 0);
 		return 0;
 	}
@@ -898,17 +897,17 @@ static void sync_request_write(mddev_t *
  *	3.	Performs writes following reads for array syncronising.
  */
 
-static void raid1d(void *data)
+static void raid1d(mddev_t *mddev)
 {
 	struct list_head *head = &retry_list_head;
 	r1bio_t *r1_bio;
 	struct bio *bio;
 	unsigned long flags;
-	mddev_t *mddev;
-	conf_t *conf = data;
+	conf_t *conf = mddev_to_conf(mddev);
 	mdk_rdev_t *rdev;
 
-	md_handle_safemode(conf->mddev);
+	md_check_recovery(mddev);
+	md_handle_safemode(mddev);
 	
 	for (;;) {
 		spin_lock_irqsave(&retry_list_lock, flags);
@@ -1188,10 +1187,8 @@ static int run(mddev_t *mddev)
 
 
 	{
-		snprintf(conf->thread_name,MD_THREAD_NAME_MAX,"raid1d_md%d",mdidx(mddev));
-
-		conf->thread = md_register_thread(raid1d, conf, conf->thread_name);
-		if (!conf->thread) {
+		mddev->thread = md_register_thread(raid1d, mddev, "md%d_raid1");
+		if (!mddev->thread) {
 			printk(THREAD_ERROR, mdidx(mddev));
 			goto out_free_conf;
 		}
@@ -1217,7 +1214,8 @@ static int stop(mddev_t *mddev)
 {
 	conf_t *conf = mddev_to_conf(mddev);
 
-	md_unregister_thread(conf->thread);
+	md_unregister_thread(mddev->thread);
+	mddev->thread = NULL;
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
 	kfree(conf);

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-03-12 13:14:58.000000000 +1100
+++ ./drivers/md/raid5.c	2003-03-12 13:15:04.000000000 +1100
@@ -71,12 +71,12 @@ static inline void __release_stripe(raid
 				list_add_tail(&sh->lru, &conf->delayed_list);
 			else
 				list_add_tail(&sh->lru, &conf->handle_list);
-			md_wakeup_thread(conf->thread);
+			md_wakeup_thread(conf->mddev->thread);
 		} else {
 			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 				atomic_dec(&conf->preread_active_stripes);
 				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
-					md_wakeup_thread(conf->thread);
+					md_wakeup_thread(conf->mddev->thread);
 			}
 			list_add_tail(&sh->lru, &conf->inactive_list);
 			atomic_dec(&conf->active_stripes);
@@ -912,7 +912,7 @@ static void handle_stripe(struct stripe_
 				struct bio *nextbi = bi->bi_next;
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
 				if (--bi->bi_phys_segments == 0) {
-					md_write_end(conf->mddev, conf->thread);
+					md_write_end(conf->mddev);
 					bi->bi_next = return_bi;
 					return_bi = bi;
 				}
@@ -969,7 +969,7 @@ static void handle_stripe(struct stripe_
 			    while (wbi && wbi->bi_sector < dev->sector + STRIPE_SECTORS) {
 				    wbi2 = wbi->bi_next;
 				    if (--wbi->bi_phys_segments == 0) {
-					    md_write_end(conf->mddev, conf->thread);
+					    md_write_end(conf->mddev);
 					    wbi->bi_next = return_bi;
 					    return_bi = wbi;
 				    }
@@ -1112,7 +1112,7 @@ static void handle_stripe(struct stripe_
 			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 				atomic_dec(&conf->preread_active_stripes);
 				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
-					md_wakeup_thread(conf->thread);
+					md_wakeup_thread(conf->mddev->thread);
 			}
 		}
 	}
@@ -1250,7 +1250,7 @@ static void raid5_unplug_device(void *da
 
 	if (blk_remove_plug(q))
 		raid5_activate_delayed(conf);
-	md_wakeup_thread(conf->thread);
+	md_wakeup_thread(mddev->thread);
 
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 }
@@ -1303,7 +1303,7 @@ static int make_request (request_queue_t
 		int bytes = bi->bi_size;
 
 		if ( bio_data_dir(bi) == WRITE )
-			md_write_end(mddev,conf->thread);
+			md_write_end(mddev);
 		bi->bi_size = 0;
 		bi->bi_end_io(bi, bytes, 0);
 	}
@@ -1355,16 +1355,17 @@ static int sync_request (mddev_t *mddev,
  * During the scan, completed stripes are saved for us by the interrupt
  * handler, so that they will not have to wait for our next wakeup.
  */
-static void raid5d (void *data)
+static void raid5d (mddev_t *mddev)
 {
 	struct stripe_head *sh;
-	raid5_conf_t *conf = data;
-	mddev_t *mddev = conf->mddev;
+	raid5_conf_t *conf = mddev_to_conf(mddev);
 	int handled;
 
 	PRINTK("+++ raid5d active\n");
 
+	md_check_recovery(mddev);
 	md_handle_safemode(mddev);
+
 	handled = 0;
 	spin_lock_irq(&conf->device_lock);
 	while (1) {
@@ -1485,10 +1486,8 @@ static int run (mddev_t *mddev)
 	}
 
 	{
-		snprintf(conf->thread_name,MD_THREAD_NAME_MAX,"raid5d_md%d",mdidx(mddev));
-
-		conf->thread = md_register_thread(raid5d, conf, conf->thread_name);
-		if (!conf->thread) {
+		mddev->thread = md_register_thread(raid5d, mddev, "md%d_raid5");
+		if (!mddev->thread) {
 			printk(KERN_ERR "raid5: couldn't allocate thread for md%d\n", mdidx(mddev));
 			goto abort;
 		}
@@ -1499,7 +1498,7 @@ static int run (mddev_t *mddev)
 	if (grow_stripes(conf, conf->max_nr_stripes)) {
 		printk(KERN_ERR "raid5: couldn't allocate %dkB for buffers\n", memory);
 		shrink_stripes(conf);
-		md_unregister_thread(conf->thread);
+		md_unregister_thread(mddev->thread);
 		goto abort;
 	} else
 		printk(KERN_INFO "raid5: allocated %dkB for md%d\n", memory, mdidx(mddev));
@@ -1535,7 +1534,8 @@ static int stop (mddev_t *mddev)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 
-	md_unregister_thread(conf->thread);
+	md_unregister_thread(mddev->thread);
+	mddev->thread = NULL;
 	shrink_stripes(conf);
 	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
 	kfree(conf);
@@ -1573,8 +1573,6 @@ static void printall (raid5_conf_t *conf
 		}
 	}
 	spin_unlock_irq(&conf->device_lock);
-
-	PRINTK("--- raid5d inactive\n");
 }
 #endif
 

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2003-03-12 13:14:58.000000000 +1100
+++ ./include/linux/raid/md.h	2003-03-12 13:15:04.000000000 +1100
@@ -69,13 +69,14 @@ extern inline char * bdev_partition_name
 }
 extern int register_md_personality (int p_num, mdk_personality_t *p);
 extern int unregister_md_personality (int p_num);
-extern mdk_thread_t * md_register_thread (void (*run) (void *data),
-				void *data, const char *name);
+extern mdk_thread_t * md_register_thread (void (*run) (mddev_t *mddev),
+				mddev_t *mddev, const char *name);
 extern void md_unregister_thread (mdk_thread_t *thread);
 extern void md_wakeup_thread(mdk_thread_t *thread);
+extern void md_check_recovery(mddev_t *mddev);
 extern void md_interrupt_thread (mdk_thread_t *thread);
 extern void md_write_start(mddev_t *mddev);
-extern void md_write_end(mddev_t *mddev, mdk_thread_t *thread);
+extern void md_write_end(mddev_t *mddev);
 extern void md_handle_safemode(mddev_t *mddev);
 extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
 extern void md_sync_acct(mdk_rdev_t *rdev, unsigned long nr_sectors);

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2003-03-12 13:14:58.000000000 +1100
+++ ./include/linux/raid/md_k.h	2003-03-12 13:15:04.000000000 +1100
@@ -206,12 +206,14 @@ struct mddev_s
 
 	char				uuid[16];
 
+	struct mdk_thread_s		*thread;	/* management thread */
 	struct mdk_thread_s		*sync_thread;	/* doing resync or reconstruct */
 	unsigned long			curr_resync;	/* blocks scheduled */
 	unsigned long			resync_mark;	/* a recent timestamp */
 	unsigned long			resync_mark_cnt;/* blocks written at resync_mark */
 
 	/* recovery/resync flags 
+	 * NEEDED:   we might need to start a resync/recover
 	 * RUNNING:  a thread is running, or about to be started
 	 * SYNC:     actually doing a resync, not a recovery
 	 * ERR:      and IO error was detected - abort the resync/recovery
@@ -223,6 +225,7 @@ struct mddev_s
 #define	MD_RECOVERY_ERR		2
 #define	MD_RECOVERY_INTR	3
 #define	MD_RECOVERY_DONE	4
+#define	MD_RECOVERY_NEEDED	5
 	unsigned long			recovery;
 
 	int				in_sync;	/* know to not need resync */
@@ -298,8 +301,8 @@ extern mdk_rdev_t * find_rdev_nr(mddev_t
 	ITERATE_RDEV_GENERIC(pending_raid_disks,rdev,tmp)
 
 typedef struct mdk_thread_s {
-	void			(*run) (void *data);
-	void			*data;
+	void			(*run) (mddev_t *mddev);
+	mddev_t			*mddev;
 	wait_queue_head_t	wqueue;
 	unsigned long           flags;
 	struct completion	*event;

diff ./include/linux/raid/multipath.h~current~ ./include/linux/raid/multipath.h
--- ./include/linux/raid/multipath.h~current~	2003-03-12 13:14:58.000000000 +1100
+++ ./include/linux/raid/multipath.h	2003-03-12 13:15:04.000000000 +1100
@@ -13,7 +13,6 @@ struct multipath_private_data {
 	struct multipath_info	multipaths[MD_SB_DISKS];
 	int			raid_disks;
 	int			working_disks;
-	mdk_thread_t		*thread;
 	spinlock_t		device_lock;
 
 	mempool_t		*pool;

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2003-03-12 13:14:58.000000000 +1100
+++ ./include/linux/raid/raid1.h	2003-03-12 13:15:04.000000000 +1100
@@ -19,7 +19,6 @@ struct r1_private_data_s {
 	int			working_disks;
 	int			last_used;
 	sector_t		next_seq_sect;
-	mdk_thread_t		*thread;
 	spinlock_t		device_lock;
 
 	/* for use when syncing mirrors: */
@@ -34,7 +33,6 @@ struct r1_private_data_s {
 
 	mempool_t *r1bio_pool;
 	mempool_t *r1buf_pool;
-	char thread_name[MD_THREAD_NAME_MAX];
 };
 
 typedef struct r1_private_data_s conf_t;

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2003-03-12 13:14:58.000000000 +1100
+++ ./include/linux/raid/raid5.h	2003-03-12 13:15:04.000000000 +1100
@@ -203,7 +203,6 @@ struct disk_info {
 struct raid5_private_data {
 	struct stripe_head	**stripe_hashtbl;
 	mddev_t			*mddev;
-	mdk_thread_t		*thread;
 	struct disk_info	disks[MD_SB_DISKS];
 	struct disk_info	*spare;
 	int			chunk_size, level, algorithm;
@@ -226,7 +225,6 @@ struct raid5_private_data {
 							 * waiting for 25% to be free
 							 */        
 	spinlock_t		device_lock;
-	char			thread_name[MD_THREAD_NAME_MAX];
 };
 
 typedef struct raid5_private_data raid5_conf_t;
