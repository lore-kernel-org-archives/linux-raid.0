From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/16] md/raid10: some tidying up in fix_read_error
Date: Wed, 11 May 2011 16:30:31 +1000
Message-ID: <20110511063031.21263.43480.stgit@notabene.brown>
References: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511062743.21263.72802.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Currently the rdev on which a read error happened could be removed
before we perform the fix_error handling.  This requires extra tests
for NULL.

So delay the rdev_dec_pending call until after the call to
fix_read_error so that we can be sure that the rdev still exists.

This allows an 'if' clause to be removed so the body gets re-indented
back one level.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   74 +++++++++++++++++++++++----------------------------
 1 files changed, 34 insertions(+), 40 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8ea0aca..8e4f469 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -271,9 +271,10 @@ static void raid10_end_read_request(struct bio *bio, int error)
 		 */
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
 		raid_end_bio_io(r10_bio);
+		rdev_dec_pending(conf->mirrors[dev].rdev, conf->mddev);
 	} else {
 		/*
-		 * oops, read error:
+		 * oops, read error - keep the refcount on the rdev
 		 */
 		char b[BDEVNAME_SIZE];
 		if (printk_ratelimit())
@@ -282,8 +283,6 @@ static void raid10_end_read_request(struct bio *bio, int error)
 			       bdevname(conf->mirrors[dev].rdev->bdev,b), (unsigned long long)r10_bio->sector);
 		reschedule_retry(r10_bio);
 	}
-
-	rdev_dec_pending(conf->mirrors[dev].rdev, conf->mddev);
 }
 
 static void raid10_end_write_request(struct bio *bio, int error)
@@ -1438,40 +1437,33 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 	int max_read_errors = atomic_read(&mddev->max_corr_read_errors);
 	int d = r10_bio->devs[r10_bio->read_slot].devnum;
 
-	rcu_read_lock();
-	rdev = rcu_dereference(conf->mirrors[d].rdev);
-	if (rdev) { /* If rdev is not NULL */
-		char b[BDEVNAME_SIZE];
-		int cur_read_error_count = 0;
+	/* still own a reference to this rdev, so it cannot
+	 * have been cleared recently.
+	 */
+	rdev = conf->mirrors[d].rdev;
 
-		bdevname(rdev->bdev, b);
+	if (test_bit(Faulty, &rdev->flags))
+		/* drive has already been failed, just ignore any
+		   more fix_read_error() attempts */
+		return;
 
-		if (test_bit(Faulty, &rdev->flags)) {
-			rcu_read_unlock();
-			/* drive has already been failed, just ignore any
-			   more fix_read_error() attempts */
-			return;
-		}
+	check_decay_read_errors(mddev, rdev);
+	atomic_inc(&rdev->read_errors);
+	if (atomic_read(&rdev->read_errors) > max_read_errors) {
+		char b[BDEVNAME_SIZE];
+		bdevname(rdev->bdev, b);
 
-		check_decay_read_errors(mddev, rdev);
-		atomic_inc(&rdev->read_errors);
-		cur_read_error_count = atomic_read(&rdev->read_errors);
-		if (cur_read_error_count > max_read_errors) {
-			rcu_read_unlock();
-			printk(KERN_NOTICE
-			       "md/raid10:%s: %s: Raid device exceeded "
-			       "read_error threshold "
-			       "[cur %d:max %d]\n",
-			       mdname(mddev),
-			       b, cur_read_error_count, max_read_errors);
-			printk(KERN_NOTICE
-			       "md/raid10:%s: %s: Failing raid "
-			       "device\n", mdname(mddev), b);
-			md_error(mddev, conf->mirrors[d].rdev);
-			return;
-		}
+		printk(KERN_NOTICE
+		       "md/raid10:%s: %s: Raid device exceeded "
+		       "read_error threshold [cur %d:max %d]\n",
+		       mdname(mddev), b,
+		       atomic_read(&rdev->read_errors), max_read_errors);
+		printk(KERN_NOTICE
+		       "md/raid10:%s: %s: Failing raid device\n",
+		       mdname(mddev), b);
+		md_error(mddev, conf->mirrors[d].rdev);
+		return;
 	}
-	rcu_read_unlock();
 
 	while(sectors) {
 		int s = sectors;
@@ -1540,8 +1532,8 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 					       "write failed"
 					       " (%d sectors at %llu on %s)\n",
 					       mdname(mddev), s,
-					       (unsigned long long)(sect+
-					       rdev->data_offset),
+					       (unsigned long long)(
+						       sect + rdev->data_offset),
 					       bdevname(rdev->bdev, b));
 					printk(KERN_NOTICE "md/raid10:%s: %s: failing "
 					       "drive\n",
@@ -1577,8 +1569,8 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 					       "corrected sectors"
 					       " (%d sectors at %llu on %s)\n",
 					       mdname(mddev), s,
-					       (unsigned long long)(sect+
-						    rdev->data_offset),
+					       (unsigned long long)(
+						       sect + rdev->data_offset),
 					       bdevname(rdev->bdev, b));
 					printk(KERN_NOTICE "md/raid10:%s: %s: failing drive\n",
 					       mdname(mddev),
@@ -1590,8 +1582,8 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 					       "md/raid10:%s: read error corrected"
 					       " (%d sectors at %llu on %s)\n",
 					       mdname(mddev), s,
-					       (unsigned long long)(sect+
-					            rdev->data_offset),
+					       (unsigned long long)(
+						       sect + rdev->data_offset),
 					       bdevname(rdev->bdev, b));
 				}
 
@@ -1641,7 +1633,8 @@ static void raid10d(mddev_t *mddev)
 		else if (test_bit(R10BIO_IsRecover, &r10_bio->state))
 			recovery_request_write(mddev, r10_bio);
 		else {
-			int mirror;
+			int slot = r10_bio->read_slot;
+			int mirror = r10_bio->devs[slot].devnum;
 			/* we got a read error. Maybe the drive is bad.  Maybe just
 			 * the block and we can fix it.
 			 * We freeze all other IO, and try reading the block from
@@ -1655,6 +1648,7 @@ static void raid10d(mddev_t *mddev)
 				fix_read_error(conf, mddev, r10_bio);
 				unfreeze_array(conf);
 			}
+			rdev_dec_pending(conf->mirrors[mirror].rdev, mddev);
 
 			bio = r10_bio->devs[r10_bio->read_slot].bio;
 			r10_bio->devs[r10_bio->read_slot].bio =


