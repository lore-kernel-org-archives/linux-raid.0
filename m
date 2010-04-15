From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 04/28] md: discard StateChanged device flag.
Date: Thu, 15 Apr 2010 16:21:07 +1000
Message-ID: <20100415062107.5126.23159.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This was needed when sysfs files could only be 'notified'
from process context.  Now that we have sys_notify_direct,
we can call it directly from an interrupt.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |    7 +------
 drivers/md/md.h |    3 ---
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a20a71e..509a5e4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5899,7 +5899,7 @@ void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 	mddev->pers->error_handler(mddev,rdev);
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
-	set_bit(StateChanged, &rdev->flags);
+	sysfs_notify_dirent(rdev->sysfs_state);
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
@@ -6891,11 +6891,6 @@ void md_check_recovery(mddev_t *mddev)
 		if (mddev->flags)
 			md_update_sb(mddev, 0);
 
-		list_for_each_entry(rdev, &mddev->disks, same_set)
-			if (test_and_clear_bit(StateChanged, &rdev->flags))
-				sysfs_notify_dirent(rdev->sysfs_state);
-
-
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
 		    !test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
 			/* resync/recovery still happening */
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4dc6252..b9dc3ea 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -74,9 +74,6 @@ struct mdk_rdev_s
 #define Blocked		8		/* An error occured on an externally
 					 * managed array, don't allow writes
 					 * until it is cleared */
-#define StateChanged	9		/* Faulty or Blocked has changed during
-					 * interrupt, so it needs to be
-					 * notified by the thread */
 	wait_queue_head_t blocked_wait;
 
 	int desc_nr;			/* descriptor index in the superblock */


