From: NeilBrown <neilb@suse.de>
Subject: [PATCH md] Allow faulty devices to be removed from a readonly array.
Date: Tue,  5 Aug 2008 16:17:33 +1000
Message-ID: <1217917054-1725-6-git-send-email-neilb@suse.de>
References: <1217917054-1725-1-git-send-email-neilb@suse.de>
 <1217917054-1725-2-git-send-email-neilb@suse.de>
 <1217917054-1725-3-git-send-email-neilb@suse.de>
 <1217917054-1725-4-git-send-email-neilb@suse.de>
 <1217917054-1725-5-git-send-email-neilb@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1217917054-1725-5-git-send-email-neilb@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Removing faulty devices from an array is a two stage process.
First the device is moved from being a part of the active array
to being similar to a spare device.  Then it can be removed
by a request from user space.

The first step is currently not performed for read-only arrays,
so the second step can never succeed.

So allow readonly arrays to remove failed devices (which aren't
blocked).

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6eb9545..25b893e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6003,7 +6003,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 			}
 		}
 
-	if (mddev->degraded) {
+	if (mddev->degraded && ! mddev->ro) {
 		rdev_for_each(rdev, rtmp, mddev) {
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(In_sync, &rdev->flags) &&
@@ -6077,6 +6077,8 @@ void md_check_recovery(mddev_t *mddev)
 		flush_signals(current);
 	}
 
+	if (mddev->ro && !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
+		return;
 	if ( ! (
 		(mddev->flags && !mddev->external) ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
@@ -6090,6 +6092,15 @@ void md_check_recovery(mddev_t *mddev)
 	if (mddev_trylock(mddev)) {
 		int spares = 0;
 
+		if (mddev->ro) {
+			/* Only thing we do on a ro array is remove
+			 * failed devices.
+			 */
+			remove_and_add_spares(mddev);
+			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			goto unlock;
+		}
+
 		if (!mddev->external) {
 			int did_change = 0;
 			spin_lock_irq(&mddev->write_lock);
-- 
1.5.6.3

