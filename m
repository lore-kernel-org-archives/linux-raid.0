From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: [PATCH]  Fix a few MD bugs.
Date: Thu, 20 Mar 2003 12:22:18 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15993.6090.470728.638804@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



1/ set new MD_RECOVERY_INTR flag instead of old 'err = -EINTR'
   when a resync thread is signaled - get rid of 'err' altogether in
   md_do_sync
2/ raid1 determines if resync is needed based on recovery_cp
   rather than mddev->in_sync (which now has a very different meaning)
3/ Don't update superblock when switching to writable mode.  The 
   first write will update the superblock instead.

 ----------- Diffstat output ------------
 ./drivers/md/md.c    |   12 +++---------
 ./drivers/md/raid1.c |    3 ++-
 2 files changed, 5 insertions(+), 10 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-20 11:55:26.000000000 +1100
+++ ./drivers/md/md.c	2003-03-20 11:56:30.000000000 +1100
@@ -1735,7 +1735,6 @@ static int do_md_run(mddev_t * mddev)
 	mddev->safemode_delay = (20 * HZ)/1000 +1; /* 20 msec delay */
 	mddev->in_sync = 1;
 	
-	md_update_sb(mddev);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 	set_capacity(disk, md_size[mdidx(mddev)]<<1);
@@ -1763,7 +1762,6 @@ static int restart_array(mddev_t *mddev)
 			goto out;
 
 		mddev->safemode = 0;
-		md_update_sb(mddev);
 		mddev->ro = 0;
 		set_disk_ro(disk, 0);
 
@@ -3247,7 +3245,7 @@ static void md_do_sync(mddev_t *mddev)
 {
 	mddev_t *mddev2;
 	unsigned int max_sectors, currspeed = 0,
-		j, window, err;
+		j, window;
 	unsigned long mark[SYNC_MARKS];
 	unsigned long mark_cnt[SYNC_MARKS];
 	int last_mark,m;
@@ -3283,7 +3281,6 @@ static void md_do_sync(mddev_t *mddev)
 				if (wait_event_interruptible(resync_wait,
 							     mddev2->curr_resync < mddev->curr_resync)) {
 					flush_signals(current);
-					err = -EINTR;
 					mddev_put(mddev2);
 					goto skip;
 				}
@@ -3335,7 +3332,7 @@ static void md_do_sync(mddev_t *mddev)
 
 		sectors = mddev->pers->sync_request(mddev, j, currspeed < sysctl_speed_limit_min);
 		if (sectors < 0) {
-			err = sectors;
+			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 			goto out;
 		}
 		atomic_add(sectors, &mddev->recovery_active);
@@ -3372,7 +3369,7 @@ static void md_do_sync(mddev_t *mddev)
 			 */
 			printk(KERN_INFO "md: md_do_sync() got signal ... exiting\n");
 			flush_signals(current);
-			err = -EINTR;
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			goto out;
 		}
 
@@ -3398,7 +3395,6 @@ static void md_do_sync(mddev_t *mddev)
 		}
 	}
 	printk(KERN_INFO "md: md%d: sync done.\n",mdidx(mddev));
-	err = 0;
 	/*
 	 * this also signals 'finished resyncing' to md_stop
 	 */
@@ -3408,8 +3404,6 @@ static void md_do_sync(mddev_t *mddev)
 	/* tell personality that we are finished */
 	mddev->pers->sync_request(mddev, max_sectors, 1);
 
-	if (err)
-		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 	if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
 	    mddev->curr_resync > 2 &&
 	    mddev->curr_resync > mddev->recovery_cp) {

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-03-20 11:55:26.000000000 +1100
+++ ./drivers/md/raid1.c	2003-03-20 10:43:16.000000000 +1100
@@ -840,7 +840,8 @@ static void sync_request_write(mddev_t *
 			 * we read from here, no need to write
 			 */
 			continue;
-		if (conf->mirrors[i].rdev->in_sync && mddev->in_sync)
+		if (conf->mirrors[i].rdev->in_sync && 
+			r1_bio->sector + (bio->bi_size>>9) <= mddev->recovery_cp)
 			/*
 			 * don't need to write this we are just rebuilding
 			 */
