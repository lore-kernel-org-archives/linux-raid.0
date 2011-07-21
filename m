From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 31/36] md/raid10: Handle write errors by updating badblock
 log.
Date: Thu, 21 Jul 2011 12:58:50 +1000
Message-ID: <20110721025850.8422.38988.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When we get a write error (in the data area, not in metadata),
update the badblock log rather than failing the whole device.

As the write may well be many blocks, we trying writing each
block individually and only log the ones which fail.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |  133 ++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid10.h |    1 
 2 files changed, 117 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c809d3d..428db23 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -327,6 +327,16 @@ static void raid10_end_read_request(struct bio *bio, int error)
 	}
 }
 
+static void close_write(r10bio_t *r10_bio)
+{
+	/* clear the bitmap if all writes complete successfully */
+	bitmap_endwrite(r10_bio->mddev->bitmap, r10_bio->sector,
+			r10_bio->sectors,
+			!test_bit(R10BIO_Degraded, &r10_bio->state),
+			0);
+	md_write_end(r10_bio->mddev);
+}
+
 static void raid10_end_write_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -342,9 +352,9 @@ static void raid10_end_write_request(struct bio *bio, int error)
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
 	if (!uptodate) {
-		md_error(r10_bio->mddev, conf->mirrors[dev].rdev);
-		/* an I/O failed, we can't clear the bitmap */
-		set_bit(R10BIO_Degraded, &r10_bio->state);
+		set_bit(WriteErrorSeen,	&conf->mirrors[dev].rdev->flags);
+		set_bit(R10BIO_WriteError, &r10_bio->state);
+		dec_rdev = 0;
 	} else {
 		/*
 		 * Set R10BIO_Uptodate in our master bio, so that
@@ -378,16 +388,15 @@ static void raid10_end_write_request(struct bio *bio, int error)
 	 * already.
 	 */
 	if (atomic_dec_and_test(&r10_bio->remaining)) {
-		/* clear the bitmap if all writes complete successfully */
-		bitmap_endwrite(r10_bio->mddev->bitmap, r10_bio->sector,
-				r10_bio->sectors,
-				!test_bit(R10BIO_Degraded, &r10_bio->state),
-				0);
-		md_write_end(r10_bio->mddev);
-		if (test_bit(R10BIO_MadeGood, &r10_bio->state))
+		if (test_bit(R10BIO_WriteError, &r10_bio->state))
 			reschedule_retry(r10_bio);
-		else
-			raid_end_bio_io(r10_bio);
+		else {
+			close_write(r10_bio);
+			if (test_bit(R10BIO_MadeGood, &r10_bio->state))
+				reschedule_retry(r10_bio);
+			else
+				raid_end_bio_io(r10_bio);
+		}
 	}
 	if (dec_rdev)
 		rdev_dec_pending(conf->mirrors[dev].rdev, conf->mddev);
@@ -1839,6 +1848,82 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 	}
 }
 
+static void bi_complete(struct bio *bio, int error)
+{
+	complete((struct completion *)bio->bi_private);
+}
+
+static int submit_bio_wait(int rw, struct bio *bio)
+{
+	struct completion event;
+	rw |= REQ_SYNC;
+
+	init_completion(&event);
+	bio->bi_private = &event;
+	bio->bi_end_io = bi_complete;
+	submit_bio(rw, bio);
+	wait_for_completion(&event);
+
+	return test_bit(BIO_UPTODATE, &bio->bi_flags);
+}
+
+static int narrow_write_error(r10bio_t *r10_bio, int i)
+{
+	struct bio *bio = r10_bio->master_bio;
+	mddev_t *mddev = r10_bio->mddev;
+	conf_t *conf = mddev->private;
+	mdk_rdev_t *rdev = conf->mirrors[r10_bio->devs[i].devnum].rdev;
+	/* bio has the data to be written to slot 'i' where
+	 * we just recently had a write error.
+	 * We repeatedly clone the bio and trim down to one block,
+	 * then try the write.  Where the write fails we record
+	 * a bad block.
+	 * It is conceivable that the bio doesn't exactly align with
+	 * blocks.  We must handle this.
+	 *
+	 * We currently own a reference to the rdev.
+	 */
+
+	int block_sectors;
+	sector_t sector;
+	int sectors;
+	int sect_to_write = r10_bio->sectors;
+	int ok = 1;
+
+	if (rdev->badblocks.shift < 0)
+		return 0;
+
+	block_sectors = 1 << rdev->badblocks.shift;
+	sector = r10_bio->sector;
+	sectors = ((r10_bio->sector + block_sectors)
+		   & ~(sector_t)(block_sectors - 1))
+		- sector;
+
+	while (sect_to_write) {
+		struct bio *wbio;
+		if (sectors > sect_to_write)
+			sectors = sect_to_write;
+		/* Write at 'sector' for 'sectors' */
+		wbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+		md_trim_bio(wbio, sector - bio->bi_sector, sectors);
+		wbio->bi_sector = (r10_bio->devs[i].addr+
+				   rdev->data_offset+
+				   (sector - r10_bio->sector));
+		wbio->bi_bdev = rdev->bdev;
+		if (submit_bio_wait(WRITE, wbio) == 0)
+			/* Failure! */
+			ok = rdev_set_badblocks(rdev, sector,
+						sectors, 0)
+				&& ok;
+
+		bio_put(wbio);
+		sect_to_write -= sectors;
+		sector += sectors;
+		sectors = block_sectors;
+	}
+	return ok;
+}
+
 static void handle_read_error(mddev_t *mddev, r10bio_t *r10_bio)
 {
 	int slot = r10_bio->read_slot;
@@ -1962,16 +2047,29 @@ static void handle_write_completed(conf_t *conf, r10bio_t *r10_bio)
 			}
 		put_buf(r10_bio);
 	} else {
-		for (m = 0; m < conf->copies; m++)
-			if (r10_bio->devs[m].bio == IO_MADE_GOOD) {
-				int dev = r10_bio->devs[m].devnum;
-				rdev = conf->mirrors[dev].rdev;
+		for (m = 0; m < conf->copies; m++) {
+			int dev = r10_bio->devs[m].devnum;
+			struct bio *bio = r10_bio->devs[m].bio;
+			rdev = conf->mirrors[dev].rdev;
+			if (bio == IO_MADE_GOOD) {
 				rdev_clear_badblocks(
 					rdev,
 					r10_bio->devs[m].addr,
 					r10_bio->sectors);
 				rdev_dec_pending(rdev, conf->mddev);
+			} else if (bio != NULL &&
+				   !test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+				if (!narrow_write_error(r10_bio, m)) {
+					md_error(conf->mddev, rdev);
+					set_bit(R10BIO_Degraded,
+						&r10_bio->state);
+				}
+				rdev_dec_pending(rdev, conf->mddev);
 			}
+		}
+		if (test_bit(R10BIO_WriteError,
+			     &r10_bio->state))
+			close_write(r10_bio);
 		raid_end_bio_io(r10_bio);
 	}
 }
@@ -2003,7 +2101,8 @@ static void raid10d(mddev_t *mddev)
 
 		mddev = r10_bio->mddev;
 		conf = mddev->private;
-		if (test_bit(R10BIO_MadeGood, &r10_bio->state))
+		if (test_bit(R10BIO_MadeGood, &r10_bio->state) ||
+		    test_bit(R10BIO_WriteError, &r10_bio->state))
 			handle_write_completed(conf, r10_bio);
 		else if (test_bit(R10BIO_IsSync, &r10_bio->state))
 			sync_request_write(mddev, r10_bio);
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index d8b7f9a..79cb52a 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -139,4 +139,5 @@ struct r10bio_s {
  * known-bad-block records, we set this flag.
  */
 #define	R10BIO_MadeGood 5
+#define	R10BIO_WriteError 6
 #endif


