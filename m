From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 5 of 10 - Make sure md recovery happens appropriately.
Date: Fri, 16 Jan 2004 12:19:39 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AhIeB-0002UT-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Currently if there are two failed drives,
and two spares are added, then recovery starts onto
the first spare, but never notices the second spare.
To cope, we set RECOVERY_NEEDED when recovery finishes
so that we re-check.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-16 11:59:46.000000000 +1100
+++ ./drivers/md/md.c	2004-01-16 12:05:40.000000000 +1100
@@ -3372,9 +3372,11 @@ void md_check_recovery(mddev_t *mddev)
 		if (mddev->sb_dirty)
 			md_update_sb(mddev);
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
-		    !test_bit(MD_RECOVERY_DONE, &mddev->recovery))
+		    !test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
 			/* resync/recovery still happening */
+			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			goto unlock;
+		}
 		if (mddev->sync_thread) {
 			/* resync has finished, collect result */
 			md_unregister_thread(mddev->sync_thread);
@@ -3387,11 +3389,13 @@ void md_check_recovery(mddev_t *mddev)
 			}
 			md_update_sb(mddev);
 			mddev->recovery = 0;
+			/* flag recovery needed just to double check */
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			wake_up(&resync_wait);
 			goto unlock;
 		}
 		if (mddev->recovery) {
-			/* that's odd.. */
+			/* probably just the RECOVERY_NEEDED flag */
 			mddev->recovery = 0;
 			wake_up(&resync_wait);
 		}
