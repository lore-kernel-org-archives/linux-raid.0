From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 13/16] md/raid5: handle activation of replacement device
 when recovery completes.
Date: Wed, 26 Oct 2011 12:43:01 +1100
Message-ID: <20111026014301.21110.35196.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When recovery completes - as reported by a call to ->spare_active,
we clear In_sync on the original and set it on the replacement.

Then when the original gets removed we move the replacement from
'replacement' to 'rdev'.

This could race with other code that is looking at these pointers,
so we use memory barriers and careful ordering to ensure that
a reader might see one device twice, but never no devices.
Then the readers guard against using both devices, which could
only happen when writing.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 08f388c..6c22f09 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -519,13 +519,21 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			bi->bi_end_io = raid5_end_read_request;
 
 		rcu_read_lock();
-		rdev = rcu_dereference(conf->disks[i].rdev);
 		rrdev = rcu_dereference(conf->disks[i].replacement);
+		smp_mb(); /* Ensure that if rrdev is NULL, rdev won't be */
+		rdev = rcu_dereference(conf->disks[i].rdev);
+		if (!rdev) {
+			rdev = rrdev;
+			rrdev = NULL;
+		}
 		if (rw & WRITE) {
 			if (replace_only)
 				rdev = NULL;
+			if (rdev == rrdev)
+				/* We raced and saw duplicates */
+				rrdev = NULL;
 		} else {
-			if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
+			if (test_bit(R5_ReadRepl, &sh->dev[i].flags) && rrdev)
 				rdev = rrdev;
 			rrdev = NULL;
 		}
@@ -1627,7 +1635,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	char b[BDEVNAME_SIZE];
-	struct md_rdev *rdev;
+	struct md_rdev *rdev = NULL;
 
 
 	for (i=0 ; i<disks; i++)
@@ -1642,8 +1650,13 @@ static void raid5_end_read_request(struct bio * bi, int error)
 		return;
 	}
 	if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
+		/* If replacement finished while this request was outstanding,
+		 * 'replacement' might be NULL already.
+		 * In that case it moved down to 'rdev'.
+		 * rdev is not removed until all requests are finished.
+		 */
 		rdev = conf->disks[i].replacement;
-	else
+	if (!rdev)
 		rdev = conf->disks[i].rdev;
 
 	if (uptodate) {
@@ -1740,7 +1753,13 @@ static void raid5_end_write_request(struct bio *bi, int error)
 		}
 		if (bi == &sh->dev[i].rreq) {
 			rdev = conf->disks[i].replacement;
-			replacement = 1;
+			if (rdev)
+				replacement = 1;
+			else
+				/* rdev was removed and 'replacement'
+				 * replaced it.
+				 */
+				rdev = conf->disks[i].rdev;
 			break;
 		}
 	}
@@ -3515,6 +3534,9 @@ finish:
 			}
 			if (test_and_clear_bit(R5_MadeGoodRepl, &dev->flags)) {
 				rdev = conf->disks[i].replacement;
+				if (!rdev)
+					/* rdev have been moved down */
+					rdev = conf->disks[i].rdev;
 				rdev_clear_badblocks(rdev, sh->sector,
 						     STRIPE_SECTORS);
 				rdev_dec_pending(rdev, conf->mddev);
@@ -5183,7 +5205,25 @@ static int raid5_spare_active(struct mddev *mddev)
 
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->disks + i;
-		if (tmp->rdev
+		if (tmp->replacement
+		    && tmp->replacement->recovery_offset == MaxSector
+		    && !test_bit(Faulty, &tmp->replacement->flags)
+		    && !test_and_set_bit(In_sync, &tmp->replacement->flags)) {
+			/* Replacement has just become active. */
+			if (!tmp->rdev
+			    || !test_and_clear_bit(In_sync, &tmp->rdev->flags))
+				count++;
+			if (tmp->rdev) {
+				/* Replaced device not technically faulty,
+				 * but we need to be sure it gets removed
+				 * and never re-added.
+				 */
+				set_bit(Faulty, &tmp->rdev->flags);
+				sysfs_notify_dirent_safe(
+					tmp->rdev->sysfs_state);
+			}
+			sysfs_notify_dirent_safe(tmp->replacement->sysfs_state);
+		} else if (tmp->rdev
 		    && tmp->rdev->recovery_offset == MaxSector
 		    && !test_bit(Faulty, &tmp->rdev->flags)
 		    && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
@@ -5229,6 +5269,7 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	if (!test_bit(Faulty, &rdev->flags) &&
 	    mddev->recovery_disabled != conf->recovery_disabled &&
 	    !has_failed(conf) &&
+	    (!p->replacement || p->replacement == rdev) &&
 	    number < conf->raid_disks) {
 		err = -EBUSY;
 		goto abort;
@@ -5239,7 +5280,20 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 		/* lost the race, try later */
 		err = -EBUSY;
 		*rdevp = rdev;
-	}
+	} else if (p->replacement) {
+		/* We must have just cleared 'rdev' */
+		p->rdev = p->replacement;
+		clear_bit(Replacement, &p->replacement->flags);
+		smp_mb(); /* Make sure other CPUs may see both as identical
+			   * but will never see neither - if they are careful
+			   */
+		p->replacement = NULL;
+		clear_bit(Replaceable, &rdev->flags);
+	} else
+		/* We might have just removed the Replacement as faulty-
+		 * clear the bit just in case
+		 */
+		clear_bit(Replaceable, &rdev->flags);
 abort:
 
 	print_raid5_conf(conf);


