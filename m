From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 13/36] md/raid1: Handle write errors by updating badblock
 log.
Date: Thu, 21 Jul 2011 12:58:48 +1000
Message-ID: <20110721025848.8422.78654.stgit@notabene.brown>
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

 drivers/md/raid1.c |  168 +++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid1.h |    3 +
 2 files changed, 147 insertions(+), 24 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 42e815d..0ebeec9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -318,25 +318,34 @@ static void raid1_end_read_request(struct bio *bio, int error)
 	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
 }
 
+static void close_write(r1bio_t *r1_bio)
+{
+	/* it really is the end of this request */
+	if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
+		/* free extra copy of the data pages */
+		int i = r1_bio->behind_page_count;
+		while (i--)
+			safe_put_page(r1_bio->behind_bvecs[i].bv_page);
+		kfree(r1_bio->behind_bvecs);
+		r1_bio->behind_bvecs = NULL;
+	}
+	/* clear the bitmap if all writes complete successfully */
+	bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
+			r1_bio->sectors,
+			!test_bit(R1BIO_Degraded, &r1_bio->state),
+			test_bit(R1BIO_BehindIO, &r1_bio->state));
+	md_write_end(r1_bio->mddev);
+}
+
 static void r1_bio_write_done(r1bio_t *r1_bio)
 {
-	if (atomic_dec_and_test(&r1_bio->remaining))
-	{
-		/* it really is the end of this request */
-		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
-			/* free extra copy of the data pages */
-			int i = r1_bio->behind_page_count;
-			while (i--)
-				safe_put_page(r1_bio->behind_bvecs[i].bv_page);
-			kfree(r1_bio->behind_bvecs);
-			r1_bio->behind_bvecs = NULL;
-		}
-		/* clear the bitmap if all writes complete successfully */
-		bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
-				r1_bio->sectors,
-				!test_bit(R1BIO_Degraded, &r1_bio->state),
-				test_bit(R1BIO_BehindIO, &r1_bio->state));
-		md_write_end(r1_bio->mddev);
+	if (!atomic_dec_and_test(&r1_bio->remaining))
+		return;
+
+	if (test_bit(R1BIO_WriteError, &r1_bio->state))
+		reschedule_retry(r1_bio);
+	else {
+		close_write(r1_bio);
 		if (test_bit(R1BIO_MadeGood, &r1_bio->state))
 			reschedule_retry(r1_bio);
 		else
@@ -360,12 +369,10 @@ static void raid1_end_write_request(struct bio *bio, int error)
 	/*
 	 * 'one mirror IO has finished' event handler:
 	 */
-	r1_bio->bios[mirror] = NULL;
-	to_put = bio;
 	if (!uptodate) {
-		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-		/* an I/O failed, we can't clear the bitmap */
-		set_bit(R1BIO_Degraded, &r1_bio->state);
+		set_bit(WriteErrorSeen,
+			&conf->mirrors[mirror].rdev->flags);
+		set_bit(R1BIO_WriteError, &r1_bio->state);
 	} else {
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that we
@@ -380,6 +387,8 @@ static void raid1_end_write_request(struct bio *bio, int error)
 		sector_t first_bad;
 		int bad_sectors;
 
+		r1_bio->bios[mirror] = NULL;
+		to_put = bio;
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 
 		/* Maybe we can clear some bad blocks. */
@@ -1725,6 +1734,101 @@ static void fix_read_error(conf_t *conf, int read_disk,
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
+static int narrow_write_error(r1bio_t *r1_bio, int i)
+{
+	mddev_t *mddev = r1_bio->mddev;
+	conf_t *conf = mddev->private;
+	mdk_rdev_t *rdev = conf->mirrors[i].rdev;
+	int vcnt, idx;
+	struct bio_vec *vec;
+
+	/* bio has the data to be written to device 'i' where
+	 * we just recently had a write error.
+	 * We repeatedly clone the bio and trim down to one block,
+	 * then try the write.  Where the write fails we record
+	 * a bad block.
+	 * It is conceivable that the bio doesn't exactly align with
+	 * blocks.  We must handle this somehow.
+	 *
+	 * We currently own a reference on the rdev.
+	 */
+
+	int block_sectors;
+	sector_t sector;
+	int sectors;
+	int sect_to_write = r1_bio->sectors;
+	int ok = 1;
+
+	if (rdev->badblocks.shift < 0)
+		return 0;
+
+	block_sectors = 1 << rdev->badblocks.shift;
+	sector = r1_bio->sector;
+	sectors = ((sector + block_sectors)
+		   & ~(sector_t)(block_sectors - 1))
+		- sector;
+
+	if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
+		vcnt = r1_bio->behind_page_count;
+		vec = r1_bio->behind_bvecs;
+		idx = 0;
+		while (vec[idx].bv_page == NULL)
+			idx++;
+	} else {
+		vcnt = r1_bio->master_bio->bi_vcnt;
+		vec = r1_bio->master_bio->bi_io_vec;
+		idx = r1_bio->master_bio->bi_idx;
+	}
+	while (sect_to_write) {
+		struct bio *wbio;
+		if (sectors > sect_to_write)
+			sectors = sect_to_write;
+		/* Write at 'sector' for 'sectors'*/
+
+		wbio = bio_alloc_mddev(GFP_NOIO, vcnt, mddev);
+		memcpy(wbio->bi_io_vec, vec, vcnt * sizeof(struct bio_vec));
+		wbio->bi_sector = r1_bio->sector;
+		wbio->bi_rw = WRITE;
+		wbio->bi_vcnt = vcnt;
+		wbio->bi_size = r1_bio->sectors << 9;
+		wbio->bi_idx = idx;
+
+		md_trim_bio(wbio, sector - r1_bio->sector, sectors);
+		wbio->bi_sector += rdev->data_offset;
+		wbio->bi_bdev = rdev->bdev;
+		if (submit_bio_wait(WRITE, wbio) == 0)
+			/* failure! */
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
 static void raid1d(mddev_t *mddev)
 {
 	r1bio_t *r1_bio;
@@ -1776,7 +1880,8 @@ static void raid1d(mddev_t *mddev)
 				md_done_sync(mddev, s, 1);
 			} else
 				sync_request_write(mddev, r1_bio);
-		} else if (test_bit(R1BIO_MadeGood, &r1_bio->state)) {
+		} else if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
+			   test_bit(R1BIO_WriteError, &r1_bio->state)) {
 			int m;
 			for (m = 0; m < conf->raid_disks ; m++)
 				if (r1_bio->bios[m] == IO_MADE_GOOD) {
@@ -1786,7 +1891,24 @@ static void raid1d(mddev_t *mddev)
 						r1_bio->sector,
 						r1_bio->sectors);
 					rdev_dec_pending(rdev, mddev);
+				} else if (r1_bio->bios[m] != NULL) {
+					/* This drive got a write error.  We
+					 * need to narrow down and record
+					 * precise write errors.
+					 */
+					if (!narrow_write_error(r1_bio, m)) {
+						md_error(mddev,
+							 conf->mirrors[m].rdev);
+						/* an I/O failed, we can't clear
+						 * the bitmap */
+						set_bit(R1BIO_Degraded,
+							&r1_bio->state);
+					}
+					rdev_dec_pending(conf->mirrors[m].rdev,
+							 mddev);
 				}
+			if (test_bit(R1BIO_WriteError, &r1_bio->state))
+				close_write(r1_bio);
 			raid_end_bio_io(r1_bio);
 		} else if (test_bit(R1BIO_ReadError, &r1_bio->state)) {
 			int disk;
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index b788547..e0d676b 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -145,7 +145,8 @@ struct r1bio_s {
 /* If a write for this request means we can clear some
  * known-bad-block records, we set this flag
  */
-#define R1BIO_MadeGood 7
+#define	R1BIO_MadeGood 7
+#define	R1BIO_WriteError 8
 
 extern int md_raid1_congested(mddev_t *mddev, int bits);
 


