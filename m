From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 1/3] remove_and_add_spares() to activate specific rdev
Date: Tue, 29 Sep 2015 10:21:27 -0500
Message-ID: <1443540089-5398-2-git-send-email-rgoldwyn@suse.com>
References: <1443540089-5398-1-git-send-email-rgoldwyn@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1443540089-5398-1-git-send-email-rgoldwyn@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

remove_and_add_spares() checks for all devices to activate spare.
Change it to activate a specific device passed as spare.

So, remove_and_add_spares() can be used to activate spares in
slot_store() as well.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9798a99..883f675 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2691,15 +2691,9 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 			rdev->saved_raid_disk = -1;
 		clear_bit(In_sync, &rdev->flags);
 		clear_bit(Bitmap_sync, &rdev->flags);
-		err = rdev->mddev->pers->
-			hot_add_disk(rdev->mddev, rdev);
-		if (err) {
-			rdev->raid_disk = -1;
-			return err;
-		} else
-			sysfs_notify_dirent_safe(rdev->sysfs_state);
-		if (sysfs_link_rdev(rdev->mddev, rdev))
-			/* failure here is OK */;
+		remove_and_add_spares(rdev->mddev, rdev);
+		if (rdev->raid_disk == -1)
+			return -EBUSY;
 		/* don't wakeup anyone, leave that to userspace. */
 	} else {
 		if (slot >= rdev->mddev->raid_disks &&
@@ -8018,10 +8012,12 @@ static int remove_and_add_spares(struct mddev *mddev,
 	if (removed && mddev->kobj.sd)
 		sysfs_notify(&mddev->kobj, NULL, "degraded");
 
-	if (this)
+	if (this && removed)
 		goto no_add;
 
 	rdev_for_each(rdev, mddev) {
+		if (this && this != rdev)
+			continue;
 		if (rdev->raid_disk >= 0 &&
 		    !test_bit(In_sync, &rdev->flags) &&
 		    !test_bit(Faulty, &rdev->flags))
-- 
1.8.5.6

