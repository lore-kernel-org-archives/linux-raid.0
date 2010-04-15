From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 21/28] md: factor md_stop_writes out of do_md_stop.
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.73731.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Further refactoring of do_md_stop.
This one requires some explanation as it takes code from different
places in do_md_stop, so some re-ordering happens.

We only get into this part of do_md_stop if there are no active opens
of the device, so no writes can be happening and the device must have
been flushed.  In md_stop_writes we want to stop any internal sources
of writes - i.e. resync - and flush out the metadata.

The only code that was previously before some of this code is
code to clean up the queue, the mddev, the gendisk, or sysfs, all
of which is probably better after code that makes active changes (i.e.
triggers writes).

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3e9a96e..15f533d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4609,6 +4609,27 @@ static void md_clean(mddev_t *mddev)
 	mddev->bitmap_info.max_write_behind = 0;
 }
 
+static void md_stop_writes(mddev_t *mddev)
+{
+	if (mddev->sync_thread) {
+		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+		md_unregister_thread(mddev->sync_thread);
+		mddev->sync_thread = NULL;
+	}
+
+	del_timer_sync(&mddev->safemode_timer);
+
+	bitmap_flush(mddev);
+	md_super_wait(mddev);
+
+	if (!mddev->in_sync || mddev->flags) {
+		/* mark array as shutdown cleanly */
+		mddev->in_sync = 1;
+		md_update_sb(mddev, 1);
+	}
+}
+
 static void md_stop(mddev_t *mddev)
 {
 	mddev->pers->stop(mddev);
@@ -4636,14 +4657,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		err = -EBUSY;
 	} else if (mddev->pers) {
 
-		if (mddev->sync_thread) {
-			set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_unregister_thread(mddev->sync_thread);
-			mddev->sync_thread = NULL;
-		}
-
-		del_timer_sync(&mddev->safemode_timer);
+		md_stop_writes(mddev);
 
 		switch(mode) {
 		case 1: /* readonly */
@@ -4654,8 +4668,6 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 			break;
 		case 0: /* disassemble */
 		case 2: /* stop */
-			bitmap_flush(mddev);
-			md_super_wait(mddev);
 			if (mddev->ro)
 				set_disk_ro(disk, 0);
 
@@ -4680,11 +4692,6 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 			if (mddev->ro)
 				mddev->ro = 0;
 		}
-		if (!mddev->in_sync || mddev->flags) {
-			/* mark array as shutdown cleanly */
-			mddev->in_sync = 1;
-			md_update_sb(mddev, 1);
-		}
 		if (mode == 1)
 			set_disk_ro(disk, 1);
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);


