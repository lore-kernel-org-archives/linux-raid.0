From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 18/36] md/raid5: use bad-block log to improve handling of
 uncorrectable read errors.
Date: Thu, 21 Jul 2011 12:58:49 +1000
Message-ID: <20110721025849.8422.90879.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we get an uncorrectable read error - record a bad block rather than
failing the device.
And if these errors (which may be due to known bad blocks) cause
recovery to be impossible, record a bad block on the recovering
devices, or abort the recovery.

As we might abort a recovery without failing a device we need to teach
RAID5 about recovery_disabled handling.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid5.h |    2 +-
 2 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 52bedc6..c34c97d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2232,9 +2232,18 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 			rcu_read_lock();
 			rdev = rcu_dereference(conf->disks[i].rdev);
 			if (rdev && test_bit(In_sync, &rdev->flags))
-				/* multiple read failures in one stripe */
-				md_error(conf->mddev, rdev);
+				atomic_inc(&rdev->nr_pending);
+			else
+				rdev = NULL;
 			rcu_read_unlock();
+			if (rdev) {
+				if (!rdev_set_badblocks(
+					    rdev,
+					    sh->sector,
+					    STRIPE_SECTORS, 0))
+					md_error(conf->mddev, rdev);
+				rdev_dec_pending(rdev, conf->mddev);
+			}
 		}
 		spin_lock_irq(&conf->device_lock);
 		/* fail all writes first */
@@ -2313,6 +2322,41 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 			md_wakeup_thread(conf->mddev->thread);
 }
 
+static void
+handle_failed_sync(raid5_conf_t *conf, struct stripe_head *sh,
+		   struct stripe_head_state *s)
+{
+	int abort = 0;
+	int i;
+
+	md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
+	clear_bit(STRIPE_SYNCING, &sh->state);
+	s->syncing = 0;
+	/* There is nothing more to do for sync/check/repair.
+	 * For recover we need to record a bad block on all
+	 * non-sync devices, or abort the recovery
+	 */
+	if (!test_bit(MD_RECOVERY_RECOVER, &conf->mddev->recovery))
+		return;
+	/* During recovery devices cannot be removed, so locking and
+	 * refcounting of rdevs is not needed
+	 */
+	for (i = 0; i < conf->raid_disks; i++) {
+		mdk_rdev_t *rdev = conf->disks[i].rdev;
+		if (!rdev
+		    || test_bit(Faulty, &rdev->flags)
+		    || test_bit(In_sync, &rdev->flags))
+			continue;
+		if (!rdev_set_badblocks(rdev, sh->sector,
+					STRIPE_SECTORS, 0))
+			abort = 1;
+	}
+	if (abort) {
+		conf->recovery_disabled = conf->mddev->recovery_disabled;
+		set_bit(MD_RECOVERY_INTR, &conf->mddev->recovery);
+	}
+}
+
 /* fetch_block - checks the given member device to see if its data needs
  * to be read or computed to satisfy a request.
  *
@@ -3067,11 +3111,8 @@ static void handle_stripe(struct stripe_head *sh)
 	 */
 	if (s.failed > conf->max_degraded && s.to_read+s.to_write+s.written)
 		handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
-	if (s.failed > conf->max_degraded && s.syncing) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
-		clear_bit(STRIPE_SYNCING, &sh->state);
-		s.syncing = 0;
-	}
+	if (s.failed > conf->max_degraded && s.syncing)
+		handle_failed_sync(conf, sh, &s);
 
 	/*
 	 * might be able to return some write requests if the parity blocks
@@ -4976,6 +5017,7 @@ static int raid5_remove_disk(mddev_t *mddev, int number)
 		 * isn't possible.
 		 */
 		if (!test_bit(Faulty, &rdev->flags) &&
+		    mddev->recovery_disabled != conf->recovery_disabled &&
 		    !has_failed(conf) &&
 		    number < conf->raid_disks) {
 			err = -EBUSY;
@@ -5004,6 +5046,9 @@ static int raid5_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	int first = 0;
 	int last = conf->raid_disks - 1;
 
+	if (mddev->recovery_disabled == conf->recovery_disabled)
+		return -EBUSY;
+
 	if (has_failed(conf))
 		/* no point adding a device */
 		return -EINVAL;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 9ceb574..719fc86 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -402,7 +402,7 @@ struct raid5_private_data {
 					    * (fresh device added).
 					    * Cleared when a sync completes.
 					    */
-
+	int			recovery_disabled;
 	/* per cpu variables */
 	struct raid5_percpu {
 		struct page	*spare_page; /* Used when checking P/Q in raid6 */


