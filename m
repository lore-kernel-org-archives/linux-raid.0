From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 3 of 5] Don't hold lock on md devices while waiting for them to finish resync.
Date: Wed, 20 Oct 2004 13:26:21 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1CK77F-0008IS-9H@notabene.cse.unsw.edu.au>
References: <20041020132354.31830.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If one md array is waiting for another to finish resyncing, then it holds
a reference to the array, so the array cannot be stopped.
With this patch, we drop the reference before waiting.



Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |   53 ++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 36 insertions(+), 17 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-10-20 13:21:25.000000000 +1000
+++ ./drivers/md/md.c	2004-10-20 13:21:26.000000000 +1000
@@ -3378,33 +3378,54 @@ static void md_do_sync(mddev_t *mddev)
 	 * 1 == like 2, but have yielded to allow conflicting resync to
 	 *		commense
 	 * other == active in resync - this many blocks
+	 *
+	 * Before starting a resync we must have set curr_resync to
+	 * 2, and then checked that every "conflicting" array has curr_resync
+	 * less than ours.  When we find one that is the same or higher
+	 * we wait on resync_wait.  To avoid deadlock, we reduce curr_resync
+	 * to 1 if we choose to yield (based arbitrarily on address of mddev structure). 
+	 * This will mean we have to start checking from the beginning again.
+	 * 
 	 */
+
 	do {
 		mddev->curr_resync = 2;
 
+	try_again:
+		if (signal_pending(current)) {
+			flush_signals(current);
+			goto skip;
+		}
 		ITERATE_MDDEV(mddev2,tmp) {
+			printk(".");
 			if (mddev2 == mddev)
 				continue;
 			if (mddev2->curr_resync && 
 			    match_mddev_units(mddev,mddev2)) {
-				printk(KERN_INFO "md: delaying resync of %s"
-					" until %s has finished resync (they"
-				       	" share one or more physical units)\n",
-				       mdname(mddev), mdname(mddev2));
-				if (mddev < mddev2) {/* arbitrarily yield */
+				DEFINE_WAIT(wq);
+				if (mddev < mddev2 && mddev->curr_resync == 2) {
+					/* arbitrarily yield */
 					mddev->curr_resync = 1;
 					wake_up(&resync_wait);
 				}
-				if (wait_event_interruptible(resync_wait,
-							     mddev2->curr_resync < mddev->curr_resync)) {
-					flush_signals(current);
+				if (mddev > mddev2 && mddev->curr_resync == 1)
+					/* no need to wait here, we can wait the next
+					 * time 'round when curr_resync == 2 
+					 */
+					continue;
+				prepare_to_wait(&resync_wait, &wq, TASK_INTERRUPTIBLE);
+				if (!signal_pending(current)  
+				    && mddev2->curr_resync >= mddev->curr_resync) {
+					printk(KERN_INFO "md: delaying resync of %s"
+					       " until %s has finished resync (they"
+					       " share one or more physical units)\n",
+					       mdname(mddev), mdname(mddev2));
 					mddev_put(mddev2);
-					goto skip;
+					schedule();
+					finish_wait(&resync_wait, &wq);
+					goto try_again;
 				}
-			}
-			if (mddev->curr_resync == 1) {
-				mddev_put(mddev2);
-				break;
+				finish_wait(&resync_wait, &wq);
 			}
 		}
 	} while (mddev->curr_resync < 2);
@@ -3552,6 +3573,7 @@ static void md_do_sync(mddev_t *mddev)
 	md_enter_safemode(mddev);
  skip:
 	mddev->curr_resync = 0;
+	wake_up(&resync_wait);
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 }
@@ -3619,15 +3641,12 @@ void md_check_recovery(mddev_t *mddev)
 			mddev->recovery = 0;
 			/* flag recovery needed just to double check */
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-			wake_up(&resync_wait);
 			md_new_event();
 			goto unlock;
 		}
-		if (mddev->recovery) {
+		if (mddev->recovery)
 			/* probably just the RECOVERY_NEEDED flag */
 			mddev->recovery = 0;
-			wake_up(&resync_wait);
-		}
 
 		/* no recovery is running.
 		 * remove any failed drives, then
