From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/17] md/raid10: Allow replacement device to be replace
 old drive.
Date: Wed, 02 Nov 2011 16:25:44 +1100
Message-ID: <20111102052544.17566.55334.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When recovery finish and spare_active is called, check for a
replace that might have just become fully synced and mark it
as such, marking the original as failed.

Then when the original is removed, move the replacement into
its position.

This means that 'replacement' and spontaneously become NULL in some
situations.  Make sure we check for those.
It also means that 'rdev' and 'replacement' could appear to be
identical - check for that too.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   72 +++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 89de485..fd28f03 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -396,14 +396,17 @@ static void raid10_end_write_request(struct bio *bio, int error)
 	int dec_rdev = 1;
 	struct r10conf *conf = r10_bio->mddev->private;
 	int slot, repl;
-	struct md_rdev *rdev;
+	struct md_rdev *rdev = NULL;
 
 	dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
 
 	if (repl)
 		rdev = conf->mirrors[dev].replacement;
-	else
+	if (!rdev) {
+		smp_rmb();
+		repl = 0;
 		rdev = conf->mirrors[dev].rdev;
+	}
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
@@ -1090,6 +1093,8 @@ retry_write:
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[d].rdev);
 		struct md_rdev *rrdev = rcu_dereference(
 			conf->mirrors[d].replacement);
+		if (rdev == rrdev)
+			rrdev = NULL;
 		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
 			atomic_inc(&rdev->nr_pending);
 			blocked_rdev = rdev;
@@ -1171,9 +1176,15 @@ retry_write:
 				rdev_dec_pending(conf->mirrors[d].rdev, mddev);
 			}
 			if (r10_bio->devs[j].repl_bio) {
+				struct md_rdev *rdev;
 				d = r10_bio->devs[j].devnum;
-				rdev_dec_pending(
-					conf->mirrors[d].replacement, mddev);
+				rdev = conf->mirrors[d].replacement;
+				if (!rdev) {
+					/* Race with remove_disk */
+					smp_mb();
+					rdev = conf->mirrors[d].rdev;
+				}
+				rdev_dec_pending(rdev, mddev);
 			}
 		}
 		allow_barrier(conf);
@@ -1231,6 +1242,10 @@ retry_write:
 			    max_sectors);
 		r10_bio->devs[i].repl_bio = mbio;
 
+		/* We are actively writing to the original device
+		 * so it cannot disappear, so the replacement cannot
+		 * become NULL here
+		 */
 		mbio->bi_sector	= (r10_bio->devs[i].addr+
 				   conf->mirrors[d].replacement->data_offset);
 		mbio->bi_bdev = conf->mirrors[d].replacement->bdev;
@@ -1406,9 +1421,27 @@ static int raid10_spare_active(struct mddev *mddev)
 	 */
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->mirrors + i;
-		if (tmp->rdev
-		    && !test_bit(Faulty, &tmp->rdev->flags)
-		    && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
+		if (tmp->replacement
+		    && tmp->replacement->recovery_offset == MaxSector
+		    && !test_bit(Faulty, &tmp->replacement->flags)
+		    && !test_and_set_bit(In_sync, &tmp->replacement->flags)) {
+			/* Replacement has just become active */
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
+			   && !test_bit(Faulty, &tmp->rdev->flags)
+			   && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
 			count++;
 			sysfs_notify_dirent(tmp->rdev->sysfs_state);
 		}
@@ -1508,6 +1541,7 @@ static int raid10_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	 */
 	if (!test_bit(Faulty, &rdev->flags) &&
 	    mddev->recovery_disabled != p->recovery_disabled &&
+	    (!p->replacement || p->replacement == rdev) &&
 	    enough(conf, -1)) {
 		err = -EBUSY;
 		goto abort;
@@ -1519,7 +1553,21 @@ static int raid10_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 		err = -EBUSY;
 		*rdevp = rdev;
 		goto abort;
-	}
+	} else if (p->replacement) {
+		/* We must have just cleared 'rdev' */
+		p->rdev = p->replacement;
+		clear_bit(Replacement, &p->replacement->flags);
+		smp_mb(); /* Make sure other CPUs may see both as identical
+			   * but will never see neither -- if they are careful.
+			   */
+		p->replacement = NULL;
+		clear_bit(Replaceable, &rdev->flags);
+	} else
+		/* We might have just remove the Replacement as faulty
+		 * Clear the flag just in case
+		 */
+		clear_bit(Replaceable, &rdev->flags);
+
 	err = md_integrity_register(mddev);
 
 abort:
@@ -1597,13 +1645,15 @@ static void end_sync_write(struct bio *bio, int error)
 	int bad_sectors;
 	int slot;
 	int repl;
-	struct md_rdev *rdev;
+	struct md_rdev *rdev = NULL;
 
 	d = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
 	if (repl)
 		rdev = conf->mirrors[d].replacement;
-	else
+	if (!rdev) {
+		smp_mb();
 		rdev = conf->mirrors[d].rdev;
+	}
 
 	if (!uptodate) {
 		if (repl)
@@ -2370,7 +2420,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 			}
 			bio = r10_bio->devs[m].repl_bio;
 			rdev = conf->mirrors[dev].replacement;
-			if (bio == IO_MADE_GOOD) {
+			if (rdev && bio == IO_MADE_GOOD) {
 				rdev_clear_badblocks(
 					rdev,
 					r10_bio->devs[m].addr,


