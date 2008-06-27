From: NeilBrown <neilb@suse.de>
Subject: [PATCH 016 of 29] md: Make sure all changes to md/degraded are notified.
Date: Fri, 27 Jun 2008 16:51:04 +1000
Message-ID: <1080627065104.10562@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


When a device fails, when a spare is activated, when
an array is reshaped, or when an array is started,
the extent to which the array is degraded can change.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |    7 +++++++
 ./drivers/md/md.c      |    6 +++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff .prev/Documentation/md.txt ./Documentation/md.txt
--- .prev/Documentation/md.txt	2008-06-27 16:22:02.000000000 +1000
+++ ./Documentation/md.txt	2008-06-27 16:22:02.000000000 +1000
@@ -392,6 +392,13 @@ also have
       achieved. In that case, the transition to "recover" isn't
       notified, but the transition away is.
 
+   degraded
+      This contains a count of the number of devices by which the
+      arrays is degraded.  So an optimal array with show '0'.  A
+      single failed/missing drive will show '1', etc.
+      This file responds to select/poll, any increase or decrease
+      in the count of missing devices will trigger an event.
+
    mismatch_count
       When performing 'check' and 'repair', and possibly when
       performing 'resync', md will count the number of errors that are

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 16:22:02.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 16:22:02.000000000 +1000
@@ -2969,6 +2969,7 @@ action_store(mddev_t *mddev, const char 
 		err = mddev->pers->start_reshape(mddev);
 		if (err)
 			return err;
+		sysfs_notify(&mddev->kobj, NULL, "degraded");
 	} else {
 		if (cmd_match(page, "check"))
 			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
@@ -3686,6 +3687,7 @@ static int do_md_run(mddev_t * mddev)
 	md_new_event(mddev);
 	sysfs_notify(&mddev->kobj, NULL, "array_state");
 	sysfs_notify(&mddev->kobj, NULL, "sync_action");
+	sysfs_notify(&mddev->kobj, NULL, "degraded");
 	kobject_uevent(&mddev->gendisk->dev.kobj, KOBJ_CHANGE);
 	return 0;
 }
@@ -6049,7 +6051,9 @@ void md_check_recovery(mddev_t *mddev)
 			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 				/* success...*/
 				/* activate any spares */
-				mddev->pers->spare_active(mddev);
+				if (mddev->pers->spare_active(mddev))
+					sysfs_notify(&mddev->kobj, NULL,
+						     "degraded");
 			}
 			md_update_sb(mddev, 1);
 
