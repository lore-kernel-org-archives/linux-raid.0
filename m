From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 33/36] md/raid10: record bad blocks due to write errors
 during resync/recovery.
Date: Thu, 21 Jul 2011 12:58:50 +1000
Message-ID: <20110721025850.8422.16841.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we get a write error during resync/recovery don't fail the device
but instead record a bad block.  If that fails we can then fail the
device.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   33 +++++++++++++++++++++++----------
 1 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dfea30e..0f120ac 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1452,9 +1452,10 @@ static void end_sync_write(struct bio *bio, int error)
 
 	d = find_bio_disk(conf, r10_bio, bio, &slot);
 
-	if (!uptodate)
-		md_error(mddev, conf->mirrors[d].rdev);
-	else if (is_badblock(conf->mirrors[d].rdev,
+	if (!uptodate) {
+		set_bit(WriteErrorSeen, &conf->mirrors[d].rdev->flags);
+		set_bit(R10BIO_WriteError, &r10_bio->state);
+	} else if (is_badblock(conf->mirrors[d].rdev,
 			     r10_bio->devs[slot].addr,
 			     r10_bio->sectors,
 			     &first_bad, &bad_sectors))
@@ -1465,7 +1466,8 @@ static void end_sync_write(struct bio *bio, int error)
 		if (r10_bio->master_bio == NULL) {
 			/* the primary of several recovery bios */
 			sector_t s = r10_bio->sectors;
-			if (test_bit(R10BIO_MadeGood, &r10_bio->state))
+			if (test_bit(R10BIO_MadeGood, &r10_bio->state) ||
+			    test_bit(R10BIO_WriteError, &r10_bio->state))
 				reschedule_retry(r10_bio);
 			else
 				put_buf(r10_bio);
@@ -1473,7 +1475,8 @@ static void end_sync_write(struct bio *bio, int error)
 			break;
 		} else {
 			r10bio_t *r10_bio2 = (r10bio_t *)r10_bio->master_bio;
-			if (test_bit(R10BIO_MadeGood, &r10_bio->state))
+			if (test_bit(R10BIO_MadeGood, &r10_bio->state) ||
+			    test_bit(R10BIO_WriteError, &r10_bio->state))
 				reschedule_retry(r10_bio);
 			else
 				put_buf(r10_bio);
@@ -2029,23 +2032,33 @@ static void handle_write_completed(conf_t *conf, r10bio_t *r10_bio)
 	/* Some sort of write request has finished and it
 	 * succeeded in writing where we thought there was a
 	 * bad block.  So forget the bad block.
+	 * Or possibly if failed and we need to record
+	 * a bad block.
 	 */
 	int m;
 	mdk_rdev_t *rdev;
 
 	if (test_bit(R10BIO_IsSync, &r10_bio->state) ||
 	    test_bit(R10BIO_IsRecover, &r10_bio->state)) {
-		for (m = 0; m < conf->copies; m++)
-			if (r10_bio->devs[m].bio &&
-			    test_bit(BIO_UPTODATE,
+		for (m = 0; m < conf->copies; m++) {
+			int dev = r10_bio->devs[m].devnum;
+			rdev = conf->mirrors[dev].rdev;
+			if (r10_bio->devs[m].bio == NULL)
+				continue;
+			if (test_bit(BIO_UPTODATE,
 				     &r10_bio->devs[m].bio->bi_flags)) {
-				int dev = r10_bio->devs[m].devnum;
-				rdev = conf->mirrors[dev].rdev;
 				rdev_clear_badblocks(
 					rdev,
 					r10_bio->devs[m].addr,
 					r10_bio->sectors);
+			} else {
+				if (!rdev_set_badblocks(
+					    rdev,
+					    r10_bio->devs[m].addr,
+					    r10_bio->sectors, 0))
+					md_error(conf->mddev, rdev);
 			}
+		}
 		put_buf(r10_bio);
 	} else {
 		for (m = 0; m < conf->copies; m++) {


