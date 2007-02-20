From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 6] md: Restart a (raid5) reshape that has been aborted due to a read/write error.
Date: Tue, 20 Feb 2007 17:35:10 +1100
Message-ID: <1070220063510.16193@suse.de>
References: <20070220172544.15678.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932867AbXBTGgl@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


An error always aborts any resync/recovery/reshape on the understanding
that it will immediately be restarted if that still makes sense.
However a reshape currently doesn't get restarted.  With this patch
it does.
To avoid restarting when it is not possible to do work, we call 
into the personality to check that a reshape is ok, and strengthen
raid5_check_reshape to fail if there are too many failed devices.

We also break some code out into a separate function: remove_and_add_spares
as the indent level for that code was getting crazy.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c    |   74 +++++++++++++++++++++++++++++++--------------------
 ./drivers/md/raid5.c |    2 +
 2 files changed, 47 insertions(+), 29 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-02-20 17:13:08.000000000 +1100
+++ ./drivers/md/md.c	2007-02-20 17:14:35.000000000 +1100
@@ -5357,6 +5357,44 @@ void md_do_sync(mddev_t *mddev)
 EXPORT_SYMBOL_GPL(md_do_sync);
 
 
+static int remove_and_add_spares(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+	struct list_head *rtmp;
+	int spares = 0;
+
+	ITERATE_RDEV(mddev,rdev,rtmp)
+		if (rdev->raid_disk >= 0 &&
+		    (test_bit(Faulty, &rdev->flags) ||
+		     ! test_bit(In_sync, &rdev->flags)) &&
+		    atomic_read(&rdev->nr_pending)==0) {
+			if (mddev->pers->hot_remove_disk(
+				    mddev, rdev->raid_disk)==0) {
+				char nm[20];
+				sprintf(nm,"rd%d", rdev->raid_disk);
+				sysfs_remove_link(&mddev->kobj, nm);
+				rdev->raid_disk = -1;
+			}
+		}
+
+	if (mddev->degraded) {
+		ITERATE_RDEV(mddev,rdev,rtmp)
+			if (rdev->raid_disk < 0
+			    && !test_bit(Faulty, &rdev->flags)) {
+				rdev->recovery_offset = 0;
+				if (mddev->pers->hot_add_disk(mddev,rdev)) {
+					char nm[20];
+					sprintf(nm, "rd%d", rdev->raid_disk);
+					sysfs_create_link(&mddev->kobj,
+							  &rdev->kobj, nm);
+					spares++;
+					md_new_event(mddev);
+				} else
+					break;
+			}
+	}
+	return spares;
+}
 /*
  * This routine is regularly called by all per-raid-array threads to
  * deal with generic issues like resync and super-block update.
@@ -5411,7 +5449,7 @@ void md_check_recovery(mddev_t *mddev)
 		return;
 
 	if (mddev_trylock(mddev)) {
-		int spares =0;
+		int spares = 0;
 
 		spin_lock_irq(&mddev->write_lock);
 		if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
@@ -5474,35 +5512,13 @@ void md_check_recovery(mddev_t *mddev)
 		 * Spare are also removed and re-added, to allow
 		 * the personality to fail the re-add.
 		 */
-		ITERATE_RDEV(mddev,rdev,rtmp)
-			if (rdev->raid_disk >= 0 &&
-			    (test_bit(Faulty, &rdev->flags) || ! test_bit(In_sync, &rdev->flags)) &&
-			    atomic_read(&rdev->nr_pending)==0) {
-				if (mddev->pers->hot_remove_disk(mddev, rdev->raid_disk)==0) {
-					char nm[20];
-					sprintf(nm,"rd%d", rdev->raid_disk);
-					sysfs_remove_link(&mddev->kobj, nm);
-					rdev->raid_disk = -1;
-				}
-			}
-
-		if (mddev->degraded) {
-			ITERATE_RDEV(mddev,rdev,rtmp)
-				if (rdev->raid_disk < 0
-				    && !test_bit(Faulty, &rdev->flags)) {
-					rdev->recovery_offset = 0;
-					if (mddev->pers->hot_add_disk(mddev,rdev)) {
-						char nm[20];
-						sprintf(nm, "rd%d", rdev->raid_disk);
-						sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
-						spares++;
-						md_new_event(mddev);
-					} else
-						break;
-				}
-		}
 
-		if (spares) {
+		if (mddev->reshape_position != MaxSector) {
+			if (mddev->pers->check_reshape(mddev) != 0)
+				/* Cannot proceed */
+				goto unlock;
+			set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
+		} else if ((spares = remove_and_add_spares(mddev))) {
 			clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 			clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		} else if (mddev->recovery_cp < MaxSector) {

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-02-20 17:10:06.000000000 +1100
+++ ./drivers/md/raid5.c	2007-02-20 17:14:35.000000000 +1100
@@ -3814,6 +3814,8 @@ static int raid5_check_reshape(mddev_t *
 	if (err)
 		return err;
 
+	if (mddev->degraded > conf->max_degraded)
+		return -EINVAL;
 	/* looks like we might be able to manage this */
 	return 0;
 }
