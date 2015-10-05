From: rgoldwyn@suse.de
Subject: [PATCH 1/5] remove_and_add_spares() to activate specific rdev
Date: Mon,  5 Oct 2015 10:09:50 -0500
Message-ID: <1444057794-17256-2-git-send-email-rgoldwyn@suse.de>
References: <1444057794-17256-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444057794-17256-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

remove_and_add_spares() checks for all devices to activate spare.
Change it to activate a specific device if a non-null rdev
argument is passed.

remove_and_add_spares() can be used to activate spares in
slot_store() as well.

For hot_remove_disk(), check if rdev->raid_disk == -1 before
calling remove_and_add_spares()

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9798a99..fcdf47b 100644
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
@@ -6001,15 +5995,15 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 	if (!rdev)
 		return -ENXIO;
 
+	if (rdev->raid_disk >= 0)
+		goto busy;
+
 	if (mddev_is_clustered(mddev))
 		md_cluster_ops->metadata_update_start(mddev);
 
 	clear_bit(Blocked, &rdev->flags);
 	remove_and_add_spares(mddev, rdev);
 
-	if (rdev->raid_disk >= 0)
-		goto busy;
-
 	if (mddev_is_clustered(mddev))
 		md_cluster_ops->remove_disk(mddev, rdev);
 
@@ -6022,8 +6016,6 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 
 	return 0;
 busy:
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->metadata_update_cancel(mddev);
 	printk(KERN_WARNING "md: cannot remove active disk %s from %s ...\n",
 		bdevname(rdev->bdev,b), mdname(mddev));
 	return -EBUSY;
@@ -8018,10 +8010,12 @@ static int remove_and_add_spares(struct mddev *mddev,
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

