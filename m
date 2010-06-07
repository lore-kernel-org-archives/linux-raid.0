From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 16/16] md/raid1: Handle write errors by updating badblock
	log.
Date: Mon, 07 Jun 2010 10:07:56 +1000
Message-ID: <20100607000756.13302.25283.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When we get a write error (in the data area, not in metadata),
update the badblock log rather than failing the whole device.

As the write may well be many blocks, we trying writing each
block individually and only log the ones which fail.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/raid1.h |    3 +-
 2 files changed, 100 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e23ec40..a6cc50c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -342,12 +342,10 @@ static void raid1_end_write_request(struct bio *bio, int error)
 		/*
 		 * this branch is our 'one mirror IO has finished' event handler:
 		 */
-		r1_bio->bios[mirror] = NULL;
-		to_put = bio;
 		if (!uptodate) {
-			md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-			/* an I/O failed, we can't clear the bitmap */
-			set_bit(R1BIO_Degraded, &r1_bio->state);
+			set_bit(WriteErrorSeen,
+				&conf->mirrors[mirror].rdev->flags);
+			set_bit(R1BIO_WriteError, &r1_bio->state);
 		} else {
 			/*
 			 * Set R1BIO_Uptodate in our master bio, so that
@@ -359,6 +357,8 @@ static void raid1_end_write_request(struct bio *bio, int error)
 			 * wait for the 'master' bio.
 			 */
 			set_bit(R1BIO_Uptodate, &r1_bio->state);
+			r1_bio->bios[mirror] = NULL;
+			to_put = bio;
 
 			/* Maybe we can clear some bad blocks. */
 			if (is_badblock(conf->mirrors[mirror].rdev,
@@ -403,7 +403,8 @@ static void raid1_end_write_request(struct bio *bio, int error)
 	 * already.
 	 */
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
-		if (test_bit(R1BIO_BarrierRetry, &r1_bio->state))
+		if (test_bit(R1BIO_BarrierRetry, &r1_bio->state) ||
+		    test_bit(R1BIO_WriteError, &r1_bio->state))
 			reschedule_retry(r1_bio);
 		else {
 			/* it really is the end of this request */
@@ -1800,6 +1801,75 @@ static void fix_read_error(conf_t *conf, int read_disk,
 	}
 }
 
+
+static void bi_complete(struct bio *bio, int error)
+{
+	complete((struct completion *)bio->bi_private);
+}
+
+static int submit_bio_wait(int rw, struct bio *bio)
+{
+	struct completion event;
+	rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
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
+static int narrow_write_error(r1bio_t *r1_bio, int i)
+{
+	struct bio *bio = r1_bio->bios[i];
+	mddev_t *mddev = r1_bio->mddev;
+	conf_t *conf = mddev->private;
+	mdk_rdev_t *rdev = conf->mirrors[i].rdev;
+	/* bio has the data to be written to device 'i' where
+	 * we just recently had a write error.
+	 * We repeatedly clone the bio and trim down to one block,
+	 * when try the write.  Where the write fails we record
+	 * a bad block.
+	 * It is conceivable that the bio doesn't exactly align with
+	 * blocks.  We must handle this somehow.
+	 *
+	 * We currently own a reference on the rdev.
+	 */
+
+	int block_sectors = 1 << rdev->badblocks.shift;
+	sector_t sector = ((r1_bio->sector + block_sectors)
+			   & (block_sectors - 1));
+	int sectors = sector - r1_bio->sector;
+	int sect_to_write = r1_bio->sectors;
+	int ok = 1;
+
+	sector = r1_bio->sector;
+
+	while (sect_to_write) {
+		struct bio *wbio;
+		if (sectors > sect_to_write)
+			sectors = sect_to_write;
+		/* Write at 'sector' for 'sectors'*/
+		wbio = bio_clone(bio, GFP_NOIO);
+		trim_bio(wbio, sector - bio->bi_sector, sectors);
+		wbio->bi_bdev = rdev->bdev;
+		if (submit_bio_wait(1, wbio) == 0)
+			/* failure! */
+			ok = md_set_badblocks(&rdev->badblocks,
+					      sector + rdev->data_offset,
+					      sectors, 0)
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
 static void raid1d(mddev_t *mddev)
 {
 	r1bio_t *r1_bio;
@@ -1894,6 +1964,28 @@ static void raid1d(mddev_t *mddev)
 					r1_bio->bios[i] = bio;
 					generic_make_request(bio);
 				}
+		} else if (test_bit(R1BIO_WriteError, &r1_bio->state)) {
+			/* At least one drive got a write error.  We
+			 * need to narrow down and record precise write
+			 * errors.
+			 */
+			int i;
+			for (i = 0; i < conf->raid_disks; i++) {
+				struct bio *bio = r1_bio->bios[i];
+				if (!bio)
+					continue;
+				BUG_ON(test_bit(BIO_UPTODATE, &bio->bi_flags));
+				if (!narrow_write_error(r1_bio, i)) {
+					md_error(mddev, conf->mirrors[i].rdev);
+					/* an I/O failed, we can't clear
+					 * the bitmap */
+					set_bit(R1BIO_Degraded, &r1_bio->state);
+				}
+				bio_put(bio);
+				r1_bio->bios[i] = NULL;
+				rdev_dec_pending(conf->mirrors[i].rdev, mddev);
+			}
+			raid_end_bio_io(r1_bio);
 		} else {
 			int disk;
 			int max_sectors;
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index c91c736..532fca4 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -137,6 +137,7 @@ struct r1bio_s {
 /* If a write for this request means we can clear some
  * known-bad-block records, we set this flag
  */
-#define R1BIO_MadeGood 7
+#define	R1BIO_MadeGood 7
+#define	R1BIO_WriteError 8
 
 #endif


