From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 2 - Provide a 'safe-mode' for soft raid.
Date: Tue, 11 Feb 2003 15:41:28 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18iSEa-0008I5-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

When a raid1 or raid5 array is in 'safe-mode', then the array
is marked clean whenever there are no outstanding write requests,
and is marked dirty again before allowing any write request to
proceed.

This means than an unclean shutdown while no write activity is happening
will NOT cause a resync to be required.  However it does mean extra
updates to the superblock.

Currently safe-mode is turned on by sending SIGKILL to the raid thread
as would happen at a normal shutdown.  This should mean that the
reboot notifier is no longer needed.

I would like to make safemode be on all the time, but first I would need to
introduce at least a small delay between the last write finishing and the
superblocks being flushed. Otherwise some situations such as ext3 journal
write (which writes, waits for completion, then writes commit block) could
loose badly.

I will almost certainly make it on when RAID5 is degraded
as an unclean shutdown of a degraded RAID5 means data loss.

This code was provided by  Angus Sawyer <angus.sawyer@dsl.pipex.com>



 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   59 ++++++++++++++++++++++++++++++++++++++++++--
 ./drivers/md/raid1.c        |   12 ++++++--
 ./drivers/md/raid5.c        |    9 ++++++
 ./include/linux/raid/md.h   |    3 ++
 ./include/linux/raid/md_k.h |    5 ++-
 5 files changed, 82 insertions(+), 6 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-02-11 14:25:50.000000000 +1100
+++ ./drivers/md/md.c	2003-02-11 14:25:50.000000000 +1100
@@ -209,6 +209,11 @@ static inline int mddev_lock(mddev_t * m
 	return down_interruptible(&mddev->reconfig_sem);
 }
 
+static inline void mddev_lock_uninterruptible(mddev_t * mddev)
+{
+	down(&mddev->reconfig_sem);
+}
+
 static inline int mddev_trylock(mddev_t * mddev)
 {
 	return down_trylock(&mddev->reconfig_sem);
@@ -1050,8 +1055,8 @@ repeat:
 	if (!mddev->persistent)
 		return;
 
-	printk(KERN_INFO "md: updating md%d RAID superblock on device\n",
-					mdidx(mddev));
+	printk(KERN_INFO "md: updating md%d RAID superblock on device (in sync %d)\n",
+					mdidx(mddev),mddev->in_sync);
 
 	err = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
@@ -1490,6 +1495,8 @@ static int do_md_run(mddev_t * mddev)
 		mddev->pers = NULL;
 		return -EINVAL;
 	}
+ 	atomic_set(&mddev->writes_pending,0);
+	mddev->safemode = 0;
 	if (mddev->pers->sync_request)
 		mddev->in_sync = 0;
 	else
@@ -1521,6 +1528,7 @@ static int restart_array(mddev_t *mddev)
 		if (!mddev->ro)
 			goto out;
 
+		mddev->safemode = 0;
 		mddev->in_sync = 0;
 		md_update_sb(mddev);
 		mddev->ro = 0;
@@ -2798,6 +2806,48 @@ void md_done_sync(mddev_t *mddev, int bl
 }
 
 
+void md_write_start(mddev_t *mddev)
+{
+	if (mddev->safemode && !atomic_read(&mddev->writes_pending)) {
+		mddev_lock_uninterruptible(mddev);
+		atomic_inc(&mddev->writes_pending);
+		if (mddev->in_sync) {
+			mddev->in_sync = 0;
+			md_update_sb(mddev);
+		}
+		mddev_unlock(mddev);
+	} else
+		atomic_inc(&mddev->writes_pending);
+}
+
+void md_write_end(mddev_t *mddev, mdk_thread_t *thread)
+{
+	if (atomic_dec_and_test(&mddev->writes_pending) && mddev->safemode)
+		md_wakeup_thread(thread);
+}
+static inline void md_enter_safemode(mddev_t *mddev)
+{
+
+	mddev_lock_uninterruptible(mddev);
+	if (mddev->safemode && !atomic_read(&mddev->writes_pending) && !mddev->in_sync && !mddev->recovery_running) {
+		mddev->in_sync = 1;
+		md_update_sb(mddev);
+	}
+	mddev_unlock(mddev);
+}
+
+void md_handle_safemode(mddev_t *mddev)
+{
+	if (signal_pending(current)) {
+		printk(KERN_INFO "md: md%d in safe mode\n",mdidx(mddev));
+		mddev->safemode= 1;
+		flush_curr_signals();
+	}
+	if (mddev->safemode)
+		md_enter_safemode(mddev);
+}
+
+
 DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 
 #define SYNC_MARKS	10
@@ -2975,6 +3025,8 @@ static void md_do_sync(void *data)
 		mddev->recovery_running = 0;
 	if (mddev->recovery_running == 0)
 		mddev->recovery_cp = MaxSector;
+	if (mddev->safemode)
+		md_enter_safemode(mddev);
 	md_recover_arrays();
 }
 
@@ -3250,6 +3302,9 @@ EXPORT_SYMBOL(unregister_md_personality)
 EXPORT_SYMBOL(md_error);
 EXPORT_SYMBOL(md_sync_acct);
 EXPORT_SYMBOL(md_done_sync);
+EXPORT_SYMBOL(md_write_start);
+EXPORT_SYMBOL(md_write_end);
+EXPORT_SYMBOL(md_handle_safemode);
 EXPORT_SYMBOL(md_register_thread);
 EXPORT_SYMBOL(md_unregister_thread);
 EXPORT_SYMBOL(md_wakeup_thread);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-02-11 14:25:46.000000000 +1100
+++ ./drivers/md/raid1.c	2003-02-11 14:25:50.000000000 +1100
@@ -319,8 +319,10 @@ static int end_request(struct bio *bio, 
 		 * Let's see if all mirrored write operations have finished
 		 * already.
 		 */
-		if (atomic_dec_and_test(&r1_bio->remaining))
+		if (atomic_dec_and_test(&r1_bio->remaining)) {
+			md_write_end(r1_bio->mddev,conf->thread);
 			raid_end_bio_io(r1_bio, uptodate);
+		}	
 	}
 	atomic_dec(&conf->mirrors[mirror].rdev->nr_pending);
 	return 0;
@@ -540,6 +542,7 @@ static int make_request(request_queue_t 
 		 * If all mirrors are non-operational
 		 * then return an IO error:
 		 */
+		md_write_end(mddev,conf->thread);
 		raid_end_bio_io(r1_bio, 0);
 		return 0;
 	}
@@ -555,6 +558,8 @@ static int make_request(request_queue_t 
 	 * do end_request by hand if all requests finish until we had a
 	 * chance to set up the semaphore correctly ... lots of races).
 	 */
+
+	md_write_start(mddev);
 	for (i=disks; i--; ) {
 		struct bio *mbio;
 		mbio = r1_bio->write_bios[i];
@@ -902,10 +907,11 @@ static void raid1d(void *data)
 	struct bio *bio;
 	unsigned long flags;
 	mddev_t *mddev;
-	conf_t *conf;
+	conf_t *conf = data;
 	mdk_rdev_t *rdev;
 
-
+	md_handle_safemode(conf->mddev);
+	
 	for (;;) {
 		spin_lock_irqsave(&retry_list_lock, flags);
 		if (list_empty(head))

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-02-11 14:25:46.000000000 +1100
+++ ./drivers/md/raid5.c	2003-02-11 14:25:50.000000000 +1100
@@ -913,6 +913,7 @@ static void handle_stripe(struct stripe_
 				struct bio *nextbi = bi->bi_next;
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
 				if (--bi->bi_phys_segments == 0) {
+					md_write_end(conf->mddev, conf->thread);
 					bi->bi_next = return_bi;
 					return_bi = bi;
 				}
@@ -963,16 +964,19 @@ static void handle_stripe(struct stripe_
 			/* We can return any write requests */
 			    struct bio *wbi, *wbi2;
 			    PRINTK("Return write for disc %d\n", i);
+			    spin_lock_irq(&conf->device_lock);
 			    wbi = dev->written;
 			    dev->written = NULL;
 			    while (wbi && wbi->bi_sector < dev->sector + STRIPE_SECTORS) {
 				    wbi2 = wbi->bi_next;
 				    if (--wbi->bi_phys_segments == 0) {
+					    md_write_end(conf->mddev, conf->thread);
 					    wbi->bi_next = return_bi;
 					    return_bi = wbi;
 				    }
 				    wbi = wbi2;
 			    }
+			    spin_unlock_irq(&conf->device_lock);
 		    }
 		}
 	}
@@ -1275,6 +1279,8 @@ static int make_request (request_queue_t
 
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
+	if ( bio_data_dir(bi) == WRITE )
+		md_write_start(mddev);
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		
 		new_sector = raid5_compute_sector(logical_sector,
@@ -1297,6 +1303,8 @@ static int make_request (request_queue_t
 	if (--bi->bi_phys_segments == 0) {
 		int bytes = bi->bi_size;
 
+		if ( bio_data_dir(bi) == WRITE )
+			md_write_end(mddev,conf->thread);
 		bi->bi_size = 0;
 		bi->bi_end_io(bi, bytes, 0);
 	}
@@ -1357,6 +1365,7 @@ static void raid5d (void *data)
 
 	PRINTK("+++ raid5d active\n");
 
+	md_handle_safemode(mddev);
 	handled = 0;
 	spin_lock_irq(&conf->device_lock);
 	while (1) {

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2003-02-11 14:25:50.000000000 +1100
+++ ./include/linux/raid/md.h	2003-02-11 14:25:50.000000000 +1100
@@ -73,6 +73,9 @@ extern mdk_thread_t * md_register_thread
 extern void md_unregister_thread (mdk_thread_t *thread);
 extern void md_wakeup_thread(mdk_thread_t *thread);
 extern void md_interrupt_thread (mdk_thread_t *thread);
+extern void md_write_start(mddev_t *mddev);
+extern void md_write_end(mddev_t *mddev, mdk_thread_t *thread);
+extern void md_handle_safemode(mddev_t *mddev);
 extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
 extern void md_sync_acct(mdk_rdev_t *rdev, unsigned long nr_sectors);
 extern void md_error (mddev_t *mddev, mdk_rdev_t *rdev);

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2003-02-11 14:25:46.000000000 +1100
+++ ./include/linux/raid/md_k.h	2003-02-11 14:25:50.000000000 +1100
@@ -230,7 +230,10 @@ struct mddev_s
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 	sector_t			recovery_cp;
-
+	int				safemode;	/* if set, update "clean" superblock
+							 * when no writes pending.
+							 */ 
+	atomic_t			writes_pending; 
 	request_queue_t			queue;	/* for plugging ... */
 
 	struct list_head		all_mddevs;
