From: rgoldwyn@suse.de
Subject: [PATCH] Fix remove_and_add_spares removes drive added as spare in slot_store
Date: Thu, 17 Dec 2015 07:45:05 -0600
Message-ID: <1450359905-8042-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.com
Cc: pawel.baldysiak@intel.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Commit 2910ff17d154baa5eb50e362a91104e831eb2bb6
introduced a regression which would remove a recently added spare via
slot_store. Revert part of the patch which touches slot_store() and add
the disk directly using pers->hot_add_disk()

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 drivers/md/md.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a71b36f..0444afa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2726,6 +2726,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		/* Activating a spare .. or possibly reactivating
 		 * if we ever get bitmaps working here.
 		 */
+		int err;
 
 		if (rdev->raid_disk != -1)
 			return -EBUSY;
@@ -2747,9 +2748,15 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 			rdev->saved_raid_disk = -1;
 		clear_bit(In_sync, &rdev->flags);
 		clear_bit(Bitmap_sync, &rdev->flags);
-		remove_and_add_spares(rdev->mddev, rdev);
-		if (rdev->raid_disk == -1)
-			return -EBUSY;
+		err = rdev->mddev->pers->
+			hot_add_disk(rdev->mddev, rdev);
+		if (err) {
+			rdev->raid_disk = -1;
+			return err;
+		} else
+			sysfs_notify_dirent_safe(rdev->sysfs_state);
+		if (sysfs_link_rdev(rdev->mddev, rdev))
+			/* failure here is OK */;
 		/* don't wakeup anyone, leave that to userspace. */
 	} else {
 		if (slot >= rdev->mddev->raid_disks &&
-- 
2.6.2

