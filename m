From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 19 of 22 - Improve serialisation of md syncing
Date: Wed, 19 Jun 2002 10:54:42 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54866.400022.891889@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



If two md arrays which share real devices (i.e they each own a partition
on some device) need to sync/reconstruct at the same time, it is much
more efficient to have one wait while the other completes.

The current code uses interruptible_sleep_on which isn't SMP safe (without the BKL). 
This patch re-does this code to make it more secure.  Even it two start simultaneously,
one will reliably get priority, and the other wont wait for ever.



 ----------- Diffstat output ------------
 ./drivers/md/md.c |   54 ++++++++++++++++++++++++++++++------------------------
 1 files changed, 30 insertions(+), 24 deletions(-)

--- ./drivers/md/md.c	2002/06/18 05:29:05	1.18
+++ ./drivers/md/md.c	2002/06/18 05:33:38	1.19
@@ -3160,7 +3160,7 @@
 {
 	mddev_t *mddev2;
 	unsigned int max_sectors, currspeed = 0,
-		j, window, err, serialize;
+		j, window, err;
 	unsigned long mark[SYNC_MARKS];
 	unsigned long mark_cnt[SYNC_MARKS];
 	int last_mark,m;
@@ -3168,30 +3168,36 @@
 	unsigned long last_check;
 
 
-recheck:
-	serialize = 0;
-	ITERATE_MDDEV(mddev2,tmp) {
-		if (mddev2 == mddev)
-			continue;
-		if (mddev2->curr_resync && match_mddev_units(mddev,mddev2)) {
-			printk(KERN_INFO "md: delaying resync of md%d until md%d "
-			       "has finished resync (they share one or more physical units)\n",
-			       mdidx(mddev), mdidx(mddev2));
-			serialize = 1;
-			break;
-		}
-	}
-	if (serialize) {
-		interruptible_sleep_on(&resync_wait);
-		if (signal_pending(current)) {
-			flush_curr_signals();
-			err = -EINTR;
-			goto out;
+	/* we overload curr_resync somewhat here.
+	 * 0 == not engaged in resync at all
+	 * 2 == checking that there is no conflict with another sync
+	 * 1 == like 2, but have yielded to allow conflicting resync to
+	 *		commense
+	 * other == active in resync - this many blocks
+	 */
+	do {
+		mddev->curr_resync = 2;
+
+		ITERATE_MDDEV(mddev2,tmp) {
+			if (mddev2 == mddev)
+				continue;
+			if (mddev2->curr_resync && 
+			    match_mddev_units(mddev,mddev2)) {
+				printk(KERN_INFO "md: delaying resync of md%d until md%d "
+				       "has finished resync (they share one or more physical units)\n",
+				       mdidx(mddev), mdidx(mddev2));
+				if (mddev < mddev2) /* arbitrarily yield */
+					mddev->curr_resync = 1;
+				if (wait_event_interruptible(resync_wait,
+							     mddev2->curr_resync < 2)) {
+					flush_curr_signals();
+					err = -EINTR;
+					goto out;
+				}
+			}
 		}
-		goto recheck;
-	}
+	} while (mddev->curr_resync < 2);
 
-	mddev->curr_resync = 1;
 	max_sectors = mddev->sb->size << 1;
 
 	printk(KERN_INFO "md: syncing RAID array md%d\n", mdidx(mddev));
@@ -3229,7 +3235,7 @@
 		}
 		atomic_add(sectors, &mddev->recovery_active);
 		j += sectors;
-		mddev->curr_resync = j;
+		if (j>1) mddev->curr_resync = j;
 
 		if (last_check + window > j)
 			continue;
