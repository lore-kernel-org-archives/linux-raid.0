From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 4 of 9] Merge md_enter_safemode into md_check_recovery
Date: Fri, 18 Feb 2005 11:40:44 +1100
Message-ID: <E1D1wCK-0000X9-B8@notabene.cse.unsw.edu.au>
References: <20050218111131.790.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


md_enter_safemode checks if it is time to mark the
md superblock as 'clean'. i.e. if all writes have completed
and a suitable delay has passed.

This is currently called from md_handle_safemode which in-turn
is called (almost) every time md_check_recovery is called,
and from the end of md_do_sync which causes the mddev->thread 
to run, which will always call md_check_recovery as well.

So it doesn't need to be a separate function and fits quite
well into md_check_recovery.

The "almost" is because multipathd calls md_check_recovery but
not md_handle_safemode.  This is OK because the code from 
md_enter_safemode is a no-op if mddev->safemode == 0, which it 
always is for a multipathd (providing we don't allow it to be set to 
2 on a signal...)


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c        |   58 +++++++++++++++++++----------------------------
 ./drivers/md/raid1.c     |    1 
 ./drivers/md/raid10.c    |    1 
 ./drivers/md/raid5.c     |    1 
 ./drivers/md/raid6main.c |    1 
 5 files changed, 24 insertions(+), 38 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-02-18 11:11:17.000000000 +1100
+++ ./drivers/md/md.c	2005-02-18 11:11:25.000000000 +1100
@@ -3323,37 +3323,6 @@ void md_write_end(mddev_t *mddev)
 	}
 }
 
-static inline void md_enter_safemode(mddev_t *mddev)
-{
-	if (!mddev->safemode) return;
-	if (mddev->safemode == 2 &&
-	    (atomic_read(&mddev->writes_pending) || mddev->in_sync ||
-		    mddev->recovery_cp != MaxSector))
-		return; /* avoid the lock */
-	mddev_lock_uninterruptible(mddev);
-	if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
-	    !mddev->in_sync && mddev->recovery_cp == MaxSector) {
-		mddev->in_sync = 1;
-		md_update_sb(mddev);
-	}
-	mddev_unlock(mddev);
-
-	if (mddev->safemode == 1)
-		mddev->safemode = 0;
-}
-
-void md_handle_safemode(mddev_t *mddev)
-{
-	if (signal_pending(current)) {
-		printk(KERN_INFO "md: %s in immediate safe mode\n",
-			mdname(mddev));
-		mddev->safemode = 2;
-		flush_signals(current);
-	}
-	md_enter_safemode(mddev);
-}
-
-
 DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 
 #define SYNC_MARKS	10
@@ -3574,7 +3543,6 @@ static void md_do_sync(mddev_t *mddev)
 			mddev->recovery_cp = MaxSector;
 	}
 
-	md_enter_safemode(mddev);
  skip:
 	mddev->curr_resync = 0;
 	wake_up(&resync_wait);
@@ -3615,14 +3583,37 @@ void md_check_recovery(mddev_t *mddev)
 
 	if (mddev->ro)
 		return;
+
+	if (signal_pending(current)) {
+		if (mddev->pers->sync_request) {
+			printk(KERN_INFO "md: %s in immediate safe mode\n",
+			       mdname(mddev));
+			mddev->safemode = 2;
+		}
+		flush_signals(current);
+	}
+
 	if ( ! (
 		mddev->sb_dirty ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
-		test_bit(MD_RECOVERY_DONE, &mddev->recovery)
+		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
+		(mddev->safemode == 1) ||
+		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
+		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
 		))
 		return;
+
 	if (mddev_trylock(mddev)==0) {
 		int spares =0;
+
+		if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
+		    !mddev->in_sync && mddev->recovery_cp == MaxSector) {
+			mddev->in_sync = 1;
+			mddev->sb_dirty = 1;
+		}
+		if (mddev->safemode == 1)
+			mddev->safemode = 0;
+
 		if (mddev->sb_dirty)
 			md_update_sb(mddev);
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
@@ -3869,7 +3860,6 @@ EXPORT_SYMBOL(md_error);
 EXPORT_SYMBOL(md_done_sync);
 EXPORT_SYMBOL(md_write_start);
 EXPORT_SYMBOL(md_write_end);
-EXPORT_SYMBOL(md_handle_safemode);
 EXPORT_SYMBOL(md_register_thread);
 EXPORT_SYMBOL(md_unregister_thread);
 EXPORT_SYMBOL(md_wakeup_thread);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-02-18 11:11:11.000000000 +1100
+++ ./drivers/md/raid1.c	2005-02-18 11:11:25.000000000 +1100
@@ -931,7 +931,6 @@ static void raid1d(mddev_t *mddev)
 	mdk_rdev_t *rdev;
 
 	md_check_recovery(mddev);
-	md_handle_safemode(mddev);
 	
 	for (;;) {
 		char b[BDEVNAME_SIZE];

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-02-18 11:08:39.000000000 +1100
+++ ./drivers/md/raid10.c	2005-02-18 11:11:25.000000000 +1100
@@ -1216,7 +1216,6 @@ static void raid10d(mddev_t *mddev)
 	mdk_rdev_t *rdev;
 
 	md_check_recovery(mddev);
-	md_handle_safemode(mddev);
 
 	for (;;) {
 		char b[BDEVNAME_SIZE];

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-02-18 11:11:11.000000000 +1100
+++ ./drivers/md/raid5.c	2005-02-18 11:11:25.000000000 +1100
@@ -1544,7 +1544,6 @@ static void raid5d (mddev_t *mddev)
 	PRINTK("+++ raid5d active\n");
 
 	md_check_recovery(mddev);
-	md_handle_safemode(mddev);
 
 	handled = 0;
 	spin_lock_irq(&conf->device_lock);

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-02-18 11:11:11.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-02-18 11:11:25.000000000 +1100
@@ -1703,7 +1703,6 @@ static void raid6d (mddev_t *mddev)
 	PRINTK("+++ raid6d active\n");
 
 	md_check_recovery(mddev);
-	md_handle_safemode(mddev);
 
 	handled = 0;
 	spin_lock_irq(&conf->device_lock);
