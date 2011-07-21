From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 25/34] md: change managed of recovery_disabled.
Date: Thu, 21 Jul 2011 12:32:27 +1000
Message-ID: <20110721023227.6728.61339.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we hit a read error while recovering a mirror, we want to abort the
recovery without necessarily failing the disk - as having a disk this
a read error is better than not having an array at all.

Currently this is managed with a per-array flag "recovery_disabled"
and is only implemented for RAID1.  For RAID10 we will need finer
grained control as we might want to disable recovery for individual
devices separately.

So push more of the decision making into the personality.
'recovery_disabled' is now a 'cookie' which is copied when the
personality want to disable recovery and is changed when a device is
added to the array as this is used as a trigger to 'try recovery
again'.

This will allow RAID10 to get the control that it needs.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c    |    4 ++--
 drivers/md/md.h    |    9 ++++++---
 drivers/md/raid1.c |    7 +++++--
 drivers/md/raid1.h |    6 ++++++
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 77bd8d8..c7d9c6a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1922,7 +1922,7 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 	bd_link_disk_holder(rdev->bdev, mddev->gendisk);
 
 	/* May as well allow recovery to be retried once */
-	mddev->recovery_disabled = 0;
+	mddev->recovery_disabled++;
 
 	return 0;
 
@@ -7070,7 +7070,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 			}
 		}
 
-	if (mddev->degraded && !mddev->recovery_disabled) {
+	if (mddev->degraded) {
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (rdev->raid_disk >= 0 &&
 			    !test_bit(In_sync, &rdev->flags) &&
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6863f72..de5455d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -239,9 +239,12 @@ struct mddev_s
 #define	MD_RECOVERY_FROZEN	9
 
 	unsigned long			recovery;
-	int				recovery_disabled; /* if we detect that recovery
-							    * will always fail, set this
-							    * so we don't loop trying */
+	/* If a RAID personality determines that recovery (of a particular
+	 * device) will fail due to a read error on the source device, it
+	 * takes a copy of this number and does not attempt recovery again
+	 * until this number changes.
+	 */
+	int				recovery_disabled;
 
 	int				in_sync;	/* know to not need resync */
 	/* 'open_mutex' avoids races between 'md_open' and 'do_md_stop', so
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1d79a04..44069b3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -956,7 +956,7 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 		 * However don't try a recovery from this drive as
 		 * it is very likely to fail.
 		 */
-		mddev->recovery_disabled = 1;
+		conf->recovery_disabled = mddev->recovery_disabled;
 		return;
 	}
 	if (test_and_clear_bit(In_sync, &rdev->flags)) {
@@ -1052,6 +1052,9 @@ static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	int first = 0;
 	int last = mddev->raid_disks - 1;
 
+	if (mddev->recovery_disabled == conf->recovery_disabled)
+		return -EBUSY;
+
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
@@ -1107,7 +1110,7 @@ static int raid1_remove_disk(mddev_t *mddev, int number)
 		 * is not possible.
 		 */
 		if (!test_bit(Faulty, &rdev->flags) &&
-		    !mddev->recovery_disabled &&
+		    mddev->recovery_disabled != conf->recovery_disabled &&
 		    mddev->degraded < conf->raid_disks) {
 			err = -EBUSY;
 			goto abort;
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index e743a64..3cd18cf 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -48,6 +48,12 @@ struct r1_private_data_s {
 					    * (fresh device added).
 					    * Cleared when a sync completes.
 					    */
+	int			recovery_disabled; /* when the same as
+						    * mddev->recovery_disabled
+						    * we don't allow recovery
+						    * to be attempted as we
+						    * expect a read error
+						    */
 
 	wait_queue_head_t	wait_barrier;
 


