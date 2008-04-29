From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 9] md: Fix 'safemode' handling for external metadata.
Date: Tue, 29 Apr 2008 13:35:06 +1000
Message-ID: <1080429033506.20349@suse.de>
References: <20080429133104.20146.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


'safemode' relates to marking an array as 'clean' if there has been
no write traffic for a while (a couple of seconds), to reduce the chance
of the array being found dirty on reboot.

->safemode is set to '1' when there have been no write for a while, and
it gets set to '0' when the superblock is updates with the 'clean' flag set.

This requires a few fixes for 'external' metadata:
 - When an array is set to 'clean' via sysfs, 'safemode' must be cleared.
 - when we write to an array that has 'safemode' set (there must have been
        some delay in updating the metadata), we need to clear safemode.
 - Don't try to update external metadata in md_check_recovery for safemode
        transitions - it won't work.

Also, don't try to support "immediate safe mode" (safemode==2) for external
metadata, it cannot really work (the safemode timeout can be set very low
if this is really needed).

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-04-29 12:27:56.000000000 +1000
+++ ./drivers/md/md.c	2008-04-29 12:27:56.000000000 +1000
@@ -2614,6 +2614,8 @@ array_state_store(mddev_t *mddev, const 
 			if (atomic_read(&mddev->writes_pending) == 0) {
 				if (mddev->in_sync == 0) {
 					mddev->in_sync = 1;
+					if (mddev->safemode == 1)
+						mddev->safemode = 0;
 					if (mddev->persistent)
 						set_bit(MD_CHANGE_CLEAN,
 							&mddev->flags);
@@ -5391,6 +5393,8 @@ void md_write_start(mddev_t *mddev, stru
 		md_wakeup_thread(mddev->sync_thread);
 	}
 	atomic_inc(&mddev->writes_pending);
+	if (mddev->safemode == 1)
+		mddev->safemode = 0;
 	if (mddev->in_sync) {
 		spin_lock_irq(&mddev->write_lock);
 		if (mddev->in_sync) {
@@ -5815,7 +5819,7 @@ void md_check_recovery(mddev_t *mddev)
 		return;
 
 	if (signal_pending(current)) {
-		if (mddev->pers->sync_request) {
+		if (mddev->pers->sync_request && !mddev->external) {
 			printk(KERN_INFO "md: %s in immediate safe mode\n",
 			       mdname(mddev));
 			mddev->safemode = 2;
@@ -5827,7 +5831,7 @@ void md_check_recovery(mddev_t *mddev)
 		(mddev->flags && !mddev->external) ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
-		(mddev->safemode == 1) ||
+		(mddev->external == 0 && mddev->safemode == 1) ||
 		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
 		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
 		))
@@ -5836,16 +5840,20 @@ void md_check_recovery(mddev_t *mddev)
 	if (mddev_trylock(mddev)) {
 		int spares = 0;
 
-		spin_lock_irq(&mddev->write_lock);
-		if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
-		    !mddev->in_sync && mddev->recovery_cp == MaxSector) {
-			mddev->in_sync = 1;
-			if (mddev->persistent)
-				set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+		if (!mddev->external) {
+			spin_lock_irq(&mddev->write_lock);
+			if (mddev->safemode &&
+			    !atomic_read(&mddev->writes_pending) &&
+			    !mddev->in_sync &&
+			    mddev->recovery_cp == MaxSector) {
+				mddev->in_sync = 1;
+				if (mddev->persistent)
+					set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+			}
+			if (mddev->safemode == 1)
+				mddev->safemode = 0;
+			spin_unlock_irq(&mddev->write_lock);
 		}
-		if (mddev->safemode == 1)
-			mddev->safemode = 0;
-		spin_unlock_irq(&mddev->write_lock);
 
 		if (mddev->flags)
 			md_update_sb(mddev, 0);
