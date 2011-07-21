From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 14/36] md/raid1: record badblocks found during resync etc.
Date: Thu, 21 Jul 2011 12:58:48 +1000
Message-ID: <20110721025848.8422.35737.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we find a bad block while writing as part of resync/recovery we
need to report that back to raid1d which must record the bad block,
or fail the device.

Similarly when fixing a read error, a further error should just
record a bad block if possible rather than failing the device.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   81 +++++++++++++++++++++++++++++++++-------------------
 1 files changed, 51 insertions(+), 30 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0ebeec9..83c918e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1387,7 +1387,9 @@ static void end_sync_write(struct bio *bio, int error)
 			s += sync_blocks;
 			sectors_to_go -= sync_blocks;
 		} while (sectors_to_go > 0);
-		md_error(mddev, conf->mirrors[mirror].rdev);
+		set_bit(WriteErrorSeen,
+			&conf->mirrors[mirror].rdev->flags);
+		set_bit(R1BIO_WriteError, &r1_bio->state);
 	} else if (is_badblock(conf->mirrors[mirror].rdev,
 			       r1_bio->sector,
 			       r1_bio->sectors,
@@ -1398,7 +1400,8 @@ static void end_sync_write(struct bio *bio, int error)
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
 		int s = r1_bio->sectors;
-		if (test_bit(R1BIO_MadeGood, &r1_bio->state))
+		if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
+		    test_bit(R1BIO_WriteError, &r1_bio->state))
 			reschedule_retry(r1_bio);
 		else {
 			put_buf(r1_bio);
@@ -1407,6 +1410,20 @@ static void end_sync_write(struct bio *bio, int error)
 	}
 }
 
+static int r1_sync_page_io(mdk_rdev_t *rdev, sector_t sector,
+			    int sectors, struct page *page, int rw)
+{
+	if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
+		/* success */
+		return 1;
+	if (rw == WRITE)
+		set_bit(WriteErrorSeen, &rdev->flags);
+	/* need to record an error - either for the block or the device */
+	if (!rdev_set_badblocks(rdev, sector, sectors, 0))
+		md_error(rdev->mddev, rdev);
+	return 0;
+}
+
 static int fix_sync_read_error(r1bio_t *r1_bio)
 {
 	/* Try some synchronous reads of other devices to get
@@ -1478,12 +1495,11 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
 				continue;
 			rdev = conf->mirrors[d].rdev;
-			if (sync_page_io(rdev, sect, s<<9,
-					 bio->bi_io_vec[idx].bv_page,
-					 WRITE, false) == 0) {
+			if (r1_sync_page_io(rdev, sect, s,
+					    bio->bi_io_vec[idx].bv_page,
+					    WRITE) == 0) {
 				r1_bio->bios[d]->bi_end_io = NULL;
 				rdev_dec_pending(rdev, mddev);
-				md_error(mddev, rdev);
 			}
 		}
 		d = start;
@@ -1494,11 +1510,9 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
 				continue;
 			rdev = conf->mirrors[d].rdev;
-			if (sync_page_io(rdev, sect, s<<9,
-					 bio->bi_io_vec[idx].bv_page,
-					 READ, false) == 0)
-				md_error(mddev, rdev);
-			else
+			if (r1_sync_page_io(rdev, sect, s,
+					    bio->bi_io_vec[idx].bv_page,
+					    READ) != 0)
 				atomic_add(s, &rdev->corrected_errors);
 		}
 		sectors -= s;
@@ -1683,8 +1697,10 @@ static void fix_read_error(conf_t *conf, int read_disk,
 		} while (!success && d != read_disk);
 
 		if (!success) {
-			/* Cannot read from anywhere -- bye bye array */
-			md_error(mddev, conf->mirrors[read_disk].rdev);
+			/* Cannot read from anywhere - mark it bad */
+			mdk_rdev_t *rdev = conf->mirrors[read_disk].rdev;
+			if (!rdev_set_badblocks(rdev, sect, s, 0))
+				md_error(mddev, rdev);
 			break;
 		}
 		/* write it back and re-read */
@@ -1695,13 +1711,9 @@ static void fix_read_error(conf_t *conf, int read_disk,
 			d--;
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
-			    test_bit(In_sync, &rdev->flags)) {
-				if (sync_page_io(rdev, sect, s<<9,
-						 conf->tmppage, WRITE, false)
-				    == 0)
-					/* Well, this device is dead */
-					md_error(mddev, rdev);
-			}
+			    test_bit(In_sync, &rdev->flags))
+				r1_sync_page_io(rdev, sect, s,
+						conf->tmppage, WRITE);
 		}
 		d = start;
 		while (d != read_disk) {
@@ -1712,12 +1724,8 @@ static void fix_read_error(conf_t *conf, int read_disk,
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags)) {
-				if (sync_page_io(rdev, sect, s<<9,
-						 conf->tmppage, READ, false)
-				    == 0)
-					/* Well, this device is dead */
-					md_error(mddev, rdev);
-				else {
+				if (r1_sync_page_io(rdev, sect, s,
+						    conf->tmppage, READ)) {
 					atomic_add(s, &rdev->corrected_errors);
 					printk(KERN_INFO
 					       "md/raid1:%s: read error corrected "
@@ -1861,20 +1869,33 @@ static void raid1d(mddev_t *mddev)
 		mddev = r1_bio->mddev;
 		conf = mddev->private;
 		if (test_bit(R1BIO_IsSync, &r1_bio->state)) {
-			if (test_bit(R1BIO_MadeGood, &r1_bio->state)) {
+			if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
+			    test_bit(R1BIO_WriteError, &r1_bio->state)) {
 				int m;
 				int s = r1_bio->sectors;
 				for (m = 0; m < conf->raid_disks ; m++) {
+					mdk_rdev_t *rdev
+						= conf->mirrors[m].rdev;
 					struct bio *bio = r1_bio->bios[m];
-					if (bio->bi_end_io != NULL &&
-					    test_bit(BIO_UPTODATE,
+					if (bio->bi_end_io == NULL)
+						continue;
+					if (test_bit(BIO_UPTODATE,
 						     &bio->bi_flags)) {
-						rdev = conf->mirrors[m].rdev;
 						rdev_clear_badblocks(
 							rdev,
 							r1_bio->sector,
 							r1_bio->sectors);
 					}
+					if (!test_bit(BIO_UPTODATE,
+						      &bio->bi_flags) &&
+					    test_bit(R1BIO_WriteError,
+						     &r1_bio->state)) {
+						if (!rdev_set_badblocks(
+							    rdev,
+							    r1_bio->sector,
+							    r1_bio->sectors, 0))
+							md_error(mddev, rdev);
+					}
 				}
 				put_buf(r1_bio);
 				md_done_sync(mddev, s, 1);


