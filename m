From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 3/3 v2] md: unblock array if bad blocks have been acknowledged
Date: Tue, 18 Oct 2016 16:10:24 +0200
Message-ID: <1476799824-6498-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com, maksymilian.kunt@intel.com, mariusz.dabrowski@intel.com, axboe@kernel.dk, dan.j.williams@intel.com, linux-block@vger.kernel.org, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Once external metadata handler acknowledges all bad blocks (by writing
to rdev 'bad_blocks' sysfs file), it requests to unblock the array.
Check if all bad blocks are actually acknowledged as there might be a
race if new bad blocks are notified at the same time. If all bad blocks
are acknowledged, just unblock the array and continue. If not, ignore
the request to unblock (do not fail an array). External metadata handler
is expected to either process remaining bad blocks and try to unblock
again or remove bad block support for a disk (which will cause disk to
fail as in no-support case).

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/md.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cc05236..ce585b7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2612,19 +2612,29 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		set_bit(Blocked, &rdev->flags);
 		err = 0;
 	} else if (cmd_match(buf, "-blocked")) {
-		if (!test_bit(Faulty, &rdev->flags) &&
+		int unblock = 1;
+		int acked = !rdev->badblocks.unacked_exist;
+
+		if ((test_bit(ExternalBbl, &rdev->flags) &&
+		     rdev->badblocks.changed))
+			acked = check_if_badblocks_acked(&rdev->badblocks);
+
+		if (test_bit(ExternalBbl, &rdev->flags) && !acked) {
+			unblock = 0;
+		} else if (!test_bit(Faulty, &rdev->flags) &&
 		    rdev->badblocks.unacked_exist) {
 			/* metadata handler doesn't understand badblocks,
 			 * so we need to fail the device
 			 */
 			md_error(rdev->mddev, rdev);
 		}
-		clear_bit(Blocked, &rdev->flags);
-		clear_bit(BlockedBadBlocks, &rdev->flags);
-		wake_up(&rdev->blocked_wait);
-		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
-		md_wakeup_thread(rdev->mddev->thread);
-
+		if (unblock) {
+			clear_bit(Blocked, &rdev->flags);
+			clear_bit(BlockedBadBlocks, &rdev->flags);
+			wake_up(&rdev->blocked_wait);
+			set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
+			md_wakeup_thread(rdev->mddev->thread);
+		}
 		err = 0;
 	} else if (cmd_match(buf, "insync") && rdev->raid_disk == -1) {
 		set_bit(In_sync, &rdev->flags);
-- 
1.8.3.1

