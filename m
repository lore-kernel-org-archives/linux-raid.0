From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 10 - Make sure an interrupted resync doesn't seem to have completed.
Date: Fri, 16 Jan 2004 12:19:38 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AhIeA-0002UB-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If the raid1 or raid5 thread gets to run md_check_recovery
after the recovery thread has been interupted, but before 
do_md_stop completes, a spare drive can be incorporated into
an array befure it is up-to-date.

This patch corrects the relevant test.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-16 11:59:05.000000000 +1100
+++ ./drivers/md/md.c	2004-01-16 11:59:46.000000000 +1100
@@ -3379,7 +3379,8 @@ void md_check_recovery(mddev_t *mddev)
 			/* resync has finished, collect result */
 			md_unregister_thread(mddev->sync_thread);
 			mddev->sync_thread = NULL;
-			if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery)) {
+			if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
+			    !test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 				/* success...*/
 				/* activate any spares */
 				mddev->pers->spare_active(mddev);
