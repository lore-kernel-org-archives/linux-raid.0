From: NeilBrown <neilb@suse.de>
Subject: [PATCH 010 of 10] md: Restart recovery cleanly after device failure.
Date: Mon, 19 May 2008 11:11:11 +1000
Message-ID: <1080519011111.7786@suse.de>
References: <20080519110910.7473.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Eivind Sarto <ivan@kasenna.com>
List-Id: linux-raid.ids


When we get any IO error during a recovery (rebuilding a spare), we
abort the recovery and restart it.

For RAID6 (and multi-drive RAID1) it may not be best to restart at the
beginning: when multiple failures can be tolerated, the recovery may
be able to continue and re-doing all that has already been done doesn't
make sense.

We already have the infrastructure to record where a recovery is up to
and restart from there, but it is not being used properly.
This is because:
  - We sometimes abort with MD_RECOVERY_ERR rather than just MD_RECOVERY_INTR,
    which causes the recovery not be be checkpointed.
  - We remove spares and then re-added them which loses important state
    information.

The distinction between MD_RECOVERY_ERR and MD_RECOVERY_INTR really
isn't needed.  If there is an error, the relevant drive will be marked
as Faulty, and that is enough to ensure correct handling of the error.
So we first remove MD_RECOVERY_ERR, changing some of the uses of it to
MD_RECOVERY_INTR.

Then we cause the attempt to remove a non-faulty device from an array
to fail (unless recovery is impossible as the array is too degraded).
Then when remove_and_add_spares attempts to remove the devices on which
recovery can continue, it will fail, they will remain in place, and recovery
will continue on them as desired.

Issue:  If we are halfway through rebuilding a spare and another drive
fails, and a new spare is immediately available,  do we want to:
 1/ complete the current rebuild, then go back and rebuild the new spare or
 2/ restart the rebuild from the start and rebuild both devices in
    parallel.

Both options can be argued for.  The code currently takes option 2 as
  a/ this requires least code change
  b/ this results in a minimally-degraded array in minimal time.

Cc:  "Eivind Sarto" <ivan@kasenna.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   22 +++++++++++-----------
 ./drivers/md/multipath.c    |    3 ++-
 ./drivers/md/raid1.c        |   10 +++++++++-
 ./drivers/md/raid10.c       |   14 ++++++++++++--
 ./drivers/md/raid5.c        |   10 +++++++++-
 ./include/linux/raid/md_k.h |    4 +---
 6 files changed, 44 insertions(+), 19 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-05-19 11:04:07.000000000 +1000
+++ ./drivers/md/md.c	2008-05-19 11:04:11.000000000 +1000
@@ -5434,7 +5434,7 @@ void md_done_sync(mddev_t *mddev, int bl
 	atomic_sub(blocks, &mddev->recovery_active);
 	wake_up(&mddev->recovery_wait);
 	if (!ok) {
-		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
 		// stop recovery, signal do_sync ....
 	}
@@ -5690,7 +5690,7 @@ void md_do_sync(mddev_t *mddev)
 		sectors = mddev->pers->sync_request(mddev, j, &skipped,
 						  currspeed < speed_min(mddev));
 		if (sectors == 0) {
-			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			goto out;
 		}
 
@@ -5713,8 +5713,7 @@ void md_do_sync(mddev_t *mddev)
 
 		last_check = io_sectors;
 
-		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery) ||
-		    test_bit(MD_RECOVERY_ERR, &mddev->recovery))
+		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			break;
 
 	repeat:
@@ -5768,8 +5767,7 @@ void md_do_sync(mddev_t *mddev)
 	/* tell personality that we are finished */
 	mddev->pers->sync_request(mddev, max_sectors, &skipped, 1);
 
-	if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
-	    !test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
+	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
 	    mddev->curr_resync > 2) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
@@ -5838,7 +5836,10 @@ static int remove_and_add_spares(mddev_t
 		}
 
 	if (mddev->degraded) {
-		rdev_for_each(rdev, rtmp, mddev)
+		rdev_for_each(rdev, rtmp, mddev) {
+			if (rdev->raid_disk >= 0 &&
+			    !test_bit(In_sync, &rdev->flags))
+				spares++;
 			if (rdev->raid_disk < 0
 			    && !test_bit(Faulty, &rdev->flags)) {
 				rdev->recovery_offset = 0;
@@ -5856,6 +5857,7 @@ static int remove_and_add_spares(mddev_t
 				} else
 					break;
 			}
+		}
 	}
 	return spares;
 }
@@ -5869,7 +5871,7 @@ static int remove_and_add_spares(mddev_t
  * to do that as needed.
  * When it is determined that resync is needed, we set MD_RECOVERY_RUNNING in
  * "->recovery" and create a thread at ->sync_thread.
- * When the thread finishes it sets MD_RECOVERY_DONE (and might set MD_RECOVERY_ERR)
+ * When the thread finishes it sets MD_RECOVERY_DONE
  * and wakeups up this thread which will reap the thread and finish up.
  * This thread also removes any faulty devices (with nr_pending == 0).
  *
@@ -5944,8 +5946,7 @@ void md_check_recovery(mddev_t *mddev)
 			/* resync has finished, collect result */
 			md_unregister_thread(mddev->sync_thread);
 			mddev->sync_thread = NULL;
-			if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
-			    !test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
+			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 				/* success...*/
 				/* activate any spares */
 				mddev->pers->spare_active(mddev);
@@ -5969,7 +5970,6 @@ void md_check_recovery(mddev_t *mddev)
 		 * might be left set
 		 */
 		clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-		clear_bit(MD_RECOVERY_ERR, &mddev->recovery);
 		clear_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 

diff .prev/drivers/md/multipath.c ./drivers/md/multipath.c
--- .prev/drivers/md/multipath.c	2008-05-19 11:02:01.000000000 +1000
+++ ./drivers/md/multipath.c	2008-05-19 11:04:11.000000000 +1000
@@ -327,7 +327,8 @@ static int multipath_remove_disk(mddev_t
 	if (rdev) {
 		if (test_bit(In_sync, &rdev->flags) ||
 		    atomic_read(&rdev->nr_pending)) {
-			printk(KERN_ERR "hot-remove-disk, slot %d is identified"				" but is still operational!\n", number);
+			printk(KERN_ERR "hot-remove-disk, slot %d is identified"
+			       " but is still operational!\n", number);
 			err = -EBUSY;
 			goto abort;
 		}

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2008-05-19 11:02:01.000000000 +1000
+++ ./drivers/md/raid10.c	2008-05-19 11:04:11.000000000 +1000
@@ -1020,7 +1020,7 @@ static void error(mddev_t *mddev, mdk_rd
 		/*
 		 * if recovery is running, make sure it aborts.
 		 */
-		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	}
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
@@ -1171,6 +1171,14 @@ static int raid10_remove_disk(mddev_t *m
 			err = -EBUSY;
 			goto abort;
 		}
+		/* Only remove faulty devices in recovery
+		 * is not possible.
+		 */
+		if (!test_bit(Faulty, &rdev->flags) &&
+		    enough(conf)) {
+			err = -EBUSY;
+			goto abort;
+		}
 		p->rdev = NULL;
 		synchronize_rcu();
 		if (atomic_read(&rdev->nr_pending)) {
@@ -1237,6 +1245,7 @@ static void end_sync_write(struct bio *b
 
 	if (!uptodate)
 		md_error(mddev, conf->mirrors[d].rdev);
+
 	update_head_pos(i, r10_bio);
 
 	while (atomic_dec_and_test(&r10_bio->remaining)) {
@@ -1844,7 +1853,8 @@ static sector_t sync_request(mddev_t *md
 					if (rb2)
 						atomic_dec(&rb2->remaining);
 					r10_bio = rb2;
-					if (!test_and_set_bit(MD_RECOVERY_ERR, &mddev->recovery))
+					if (!test_and_set_bit(MD_RECOVERY_INTR,
+							      &mddev->recovery))
 						printk(KERN_INFO "raid10: %s: insufficient working devices for recovery.\n",
 						       mdname(mddev));
 					break;

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2008-05-19 11:02:55.000000000 +1000
+++ ./drivers/md/raid1.c	2008-05-19 11:04:11.000000000 +1000
@@ -1027,7 +1027,7 @@ static void error(mddev_t *mddev, mdk_rd
 		/*
 		 * if recovery is running, make sure it aborts.
 		 */
-		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	} else
 		set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
@@ -1148,6 +1148,14 @@ static int raid1_remove_disk(mddev_t *md
 			err = -EBUSY;
 			goto abort;
 		}
+		/* Only remove non-faulty devices is recovery
+		 * is not possible.
+		 */
+		if (!test_bit(Faulty, &rdev->flags) &&
+		    mddev->degraded < conf->raid_disks) {
+			err = -EBUSY;
+			goto abort;
+		}
 		p->rdev = NULL;
 		synchronize_rcu();
 		if (atomic_read(&rdev->nr_pending)) {

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-05-19 11:02:44.000000000 +1000
+++ ./drivers/md/raid5.c	2008-05-19 11:04:11.000000000 +1000
@@ -1268,7 +1268,7 @@ static void error(mddev_t *mddev, mdk_rd
 			/*
 			 * if recovery was running, make sure it aborts.
 			 */
-			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		}
 		set_bit(Faulty, &rdev->flags);
 		printk (KERN_ALERT
@@ -4574,6 +4574,14 @@ static int raid5_remove_disk(mddev_t *md
 			err = -EBUSY;
 			goto abort;
 		}
+		/* Only remove non-faulty devices if recovery
+		 * isn't possible.
+		 */
+		if (!test_bit(Faulty, &rdev->flags) &&
+		    mddev->degraded <= conf->max_degraded) {
+			err = -EBUSY;
+			goto abort;
+		}
 		p->rdev = NULL;
 		synchronize_rcu();
 		if (atomic_read(&rdev->nr_pending)) {

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2008-05-19 11:04:07.000000000 +1000
+++ ./include/linux/raid/md_k.h	2008-05-19 11:04:11.000000000 +1000
@@ -188,8 +188,7 @@ struct mddev_s
 	 * NEEDED:   we might need to start a resync/recover
 	 * RUNNING:  a thread is running, or about to be started
 	 * SYNC:     actually doing a resync, not a recovery
-	 * ERR:      and IO error was detected - abort the resync/recovery
-	 * INTR:     someone requested a (clean) early abort.
+	 * INTR:     resync needs to be aborted for some reason
 	 * DONE:     thread is done and is waiting to be reaped
 	 * REQUEST:  user-space has requested a sync (used with SYNC)
 	 * CHECK:    user-space request for for check-only, no repair
@@ -199,7 +198,6 @@ struct mddev_s
 	 */
 #define	MD_RECOVERY_RUNNING	0
 #define	MD_RECOVERY_SYNC	1
-#define	MD_RECOVERY_ERR		2
 #define	MD_RECOVERY_INTR	3
 #define	MD_RECOVERY_DONE	4
 #define	MD_RECOVERY_NEEDED	5
