From: Andrei Warkentin <andreiw@vmware.com>
Subject: [PATCH] MD: Allow restarting an interrupted incremental recovery.
Date: Mon, 17 Oct 2011 19:22:11 -0400
Message-ID: <1318893731-27717-1-git-send-email-andreiw@vmware.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andrei Warkentin <andreiw@vmware.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

If an incremental recovery was interrupted, a subsequent
re-add will result in a full recovery, even though an
incremental should be possible (seen with raid1).

Solve this problem by not updating the superblock on the
recovering device until array is not degraded any longer.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
---
 drivers/md/md.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5404b22..8ebbae4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2444,9 +2444,12 @@ repeat:
 			continue; /* no noise on spare devices */
 		if (test_bit(Faulty, &rdev->flags))
 			dprintk("(skipping faulty ");
+		else if (rdev->saved_raid_disk != -1)
+			dprintk("(skipping incremental s/r ");
 
 		dprintk("%s ", bdevname(rdev->bdev,b));
-		if (!test_bit(Faulty, &rdev->flags)) {
+		if (!test_bit(Faulty, &rdev->flags) &&
+		    rdev->saved_raid_disk == -1) {
 			md_super_write(mddev,rdev,
 				       rdev->sb_start, rdev->sb_size,
 				       rdev->sb_page);
@@ -7353,15 +7356,16 @@ static void reap_sync_thread(mddev_t *mddev)
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    mddev->pers->finish_reshape)
 		mddev->pers->finish_reshape(mddev);
-	md_update_sb(mddev, 1);
 
 	/* if array is no-longer degraded, then any saved_raid_disk
-	 * information must be scrapped
+	 * information must be scrapped, and superblock for
+	 * incrementally recovered device written out.
 	 */
 	if (!mddev->degraded)
 		list_for_each_entry(rdev, &mddev->disks, same_set)
 			rdev->saved_raid_disk = -1;
 
+	md_update_sb(mddev, 1);
 	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-- 
1.7.4.1

