From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm --grow failed
Date: Mon, 19 Feb 2007 11:50:07 +1100
Message-ID: <17880.62527.967571.701889@notabene.brown>
References: <20070217030514.M74974@liquid-nexus.net>
	<17878.49009.771973.884472@notabene.brown>
	<20070218091504.M97223@liquid-nexus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marc Marais on Sunday February 18
Sender: linux-raid-owner@vger.kernel.org
To: Marc Marais <marcm@liquid-nexus.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 18, marcm@liquid-nexus.net wrote:
> 
> I'm not sure how the grow operation is performed but to me it seems that 
> their is no fault tolerance during the operation so any failure will cause a 
> corrupt array. My 2c would be that if any drive fails during a grow 
> operation that the operation is aborted in such a way as to allow a restart 
> later (if possible) - as in my case a retry would've probably worked. 

For what it's worth, the code does exactly what you suggest.  It does
fail gracefully.  The problem is that it doesn't restart quite the
way you would like.

Had you stopped the array and re-assembled it, it would have resume
the reshape process (at least it did in my testing).

The following patch makes it retry a reshape straight away if it was
aborted due to a device failure (of course, if too many devices have
failed, the retry won't get anywhere, but you would expect that).

Thanks for the valuable feedback.

NeilBrown


Restart a (raid5) reshape that has been aborted due to a read/write error.

An error always aborts any resync/recovery/reshape on the understanding
that it will immediately be restarted if that still makes sense.
However a reshape currently doesn't get restarted.  This this patch
it does.
To avoid restarting when it is not possible to do work, we call 
in to the personality to check that a reshape is ok, and strengthen
raid5_check_reshape to fail if there are too many failed devices.

We also break some code out into a separate function: remote_and_add_spares
as the indent level for that code we getting crazy.


### Diffstat output
 ./drivers/md/md.c    |   74 +++++++++++++++++++++++++++++++--------------------
 ./drivers/md/raid5.c |    2 +
 2 files changed, 47 insertions(+), 29 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-02-19 11:44:51.000000000 +1100
+++ ./drivers/md/md.c	2007-02-19 11:44:54.000000000 +1100
@@ -5343,6 +5343,44 @@ void md_do_sync(mddev_t *mddev)
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
@@ -5397,7 +5435,7 @@ void md_check_recovery(mddev_t *mddev)
 		return;
 
 	if (mddev_trylock(mddev)) {
-		int spares =0;
+		int spares = 0;
 
 		spin_lock_irq(&mddev->write_lock);
 		if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
@@ -5460,35 +5498,13 @@ void md_check_recovery(mddev_t *mddev)
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
--- .prev/drivers/md/raid5.c	2007-02-19 11:44:48.000000000 +1100
+++ ./drivers/md/raid5.c	2007-02-19 11:44:54.000000000 +1100
@@ -3814,6 +3814,8 @@ static int raid5_check_reshape(mddev_t *
 	if (err)
 		return err;
 
+	if (mddev->degraded > conf->max_degraded)
+		return -EINVAL;
 	/* looks like we might be able to manage this */
 	return 0;
 }
