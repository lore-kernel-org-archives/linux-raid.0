From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 7 of 10 - Small fixes for timely writing of md superblocks.
Date: Fri, 16 Jan 2004 12:19:39 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AhIeB-0002Ul-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Currently a raid0 superblock is only written when
the array is stopped, so a crash between creation and
stop can lose your data.

This patch marks a superblock 'dirty' at creation and
forces a dirty superblock to be written when the 
array is started.

Previously we would prod the per-array thread at this point,
but as it avoids certain chores when the array is locked, and
the array is locked at this point, that isn't guaranteed
to do the right thing.  Instead we prod the thread whenever
the array is unlocked.

Finally, only write the superblock at array stop if it is needed
to mark the array as 'clean'.  raid0 which is never dirty, doesn't
need this.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-16 12:06:25.000000000 +1100
+++ ./drivers/md/md.c	2004-01-16 12:06:43.000000000 +1100
@@ -245,6 +245,9 @@ static inline int mddev_trylock(mddev_t 
 static inline void mddev_unlock(mddev_t * mddev)
 {
 	up(&mddev->reconfig_sem);
+
+	if (mddev->thread)
+		md_wakeup_thread(mddev->thread);
 }
 
 mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr)
@@ -1624,7 +1627,10 @@ static int do_md_run(mddev_t * mddev)
 	mddev->in_sync = 1;
 	
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_wakeup_thread(mddev->thread);
+	
+	if (mddev->sb_dirty)
+		md_update_sb(mddev);
+
 	set_capacity(disk, mddev->array_size<<1);
 
 	/* If we call blk_queue_make_request here, it will
@@ -1715,7 +1721,7 @@ static int do_md_stop(mddev_t * mddev, i
 			if (mddev->ro)
 				mddev->ro = 0;
 		}
-		if (mddev->raid_disks) {
+		if (!mddev->in_sync) {
 			/* mark array as shutdown cleanly */
 			mddev->in_sync = 1;
 			md_update_sb(mddev);
@@ -2286,7 +2292,7 @@ abort_export:
 /*
  * set_array_info is used two different ways
  * The original usage is when creating a new array.
- * In this usage, raid_disks is > = and it together with
+ * In this usage, raid_disks is > 0 and it together with
  *  level, size, not_persistent,layout,chunksize determine the
  *  shape of the array.
  *  This will always create an array with a type-0.90.0 superblock.
@@ -2337,6 +2343,7 @@ static int set_array_info(mddev_t * mdde
 
 	mddev->max_disks     = MD_SB_DISKS;
 
+	mddev->sb_dirty      = 1;
 
 	/*
 	 * Generate a 128 bit UUID
@@ -3098,6 +3105,10 @@ void md_write_end(mddev_t *mddev)
 
 static inline void md_enter_safemode(mddev_t *mddev)
 {
+	if (!mddev->safemode) return;
+	if (mddev->safemode == 2 &&
+	    (atomic_read(&mddev->writes_pending) || mddev->in_sync))
+		return; /* avoid the lock */
 	mddev_lock_uninterruptible(mddev);
 	if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
 	    !mddev->in_sync && mddev->recovery_cp == MaxSector) {
@@ -3118,8 +3129,7 @@ void md_handle_safemode(mddev_t *mddev)
 		mddev->safemode = 2;
 		flush_signals(current);
 	}
-	if (mddev->safemode)
-		md_enter_safemode(mddev);
+	md_enter_safemode(mddev);
 }
 
 
@@ -3307,8 +3317,7 @@ static void md_do_sync(mddev_t *mddev)
 			mddev->recovery_cp = MaxSector;
 	}
 
-	if (mddev->safemode)
-		md_enter_safemode(mddev);
+	md_enter_safemode(mddev);
  skip:
 	mddev->curr_resync = 0;
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
