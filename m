From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 30/36] md/raid10: clear bad-block record when write
 succeeds.
Date: Thu, 21 Jul 2011 12:58:50 +1000
Message-ID: <20110721025850.8422.77943.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we succeed in writing to a block that was recorded as
being bad, we clear the bad-block record.

This requires some delayed handling as the bad-block-list update has
to happen in process-context.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |  101 +++++++++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid10.h |   11 ++++++
 2 files changed, 100 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7dcd318..c809d3d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -181,7 +181,7 @@ static void put_all_bios(conf_t *conf, r10bio_t *r10_bio)
 
 	for (i = 0; i < conf->copies; i++) {
 		struct bio **bio = & r10_bio->devs[i].bio;
-		if (*bio && *bio != IO_BLOCKED)
+		if (!BIO_SPECIAL(*bio))
 			bio_put(*bio);
 		*bio = NULL;
 	}
@@ -267,7 +267,8 @@ static inline void update_head_pos(int slot, r10bio_t *r10_bio)
 /*
  * Find the disk number which triggered given bio
  */
-static int find_bio_disk(conf_t *conf, r10bio_t *r10_bio, struct bio *bio)
+static int find_bio_disk(conf_t *conf, r10bio_t *r10_bio,
+			 struct bio *bio, int *slotp)
 {
 	int slot;
 
@@ -278,6 +279,8 @@ static int find_bio_disk(conf_t *conf, r10bio_t *r10_bio, struct bio *bio)
 	BUG_ON(slot == conf->copies);
 	update_head_pos(slot, r10_bio);
 
+	if (slotp)
+		*slotp = slot;
 	return r10_bio->devs[slot].devnum;
 }
 
@@ -329,9 +332,11 @@ static void raid10_end_write_request(struct bio *bio, int error)
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r10bio_t *r10_bio = bio->bi_private;
 	int dev;
+	int dec_rdev = 1;
 	conf_t *conf = r10_bio->mddev->private;
+	int slot;
 
-	dev = find_bio_disk(conf, r10_bio, bio);
+	dev = find_bio_disk(conf, r10_bio, bio, &slot);
 
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
@@ -340,7 +345,7 @@ static void raid10_end_write_request(struct bio *bio, int error)
 		md_error(r10_bio->mddev, conf->mirrors[dev].rdev);
 		/* an I/O failed, we can't clear the bitmap */
 		set_bit(R10BIO_Degraded, &r10_bio->state);
-	} else
+	} else {
 		/*
 		 * Set R10BIO_Uptodate in our master bio, so that
 		 * we will return a good error code for to the higher
@@ -350,8 +355,23 @@ static void raid10_end_write_request(struct bio *bio, int error)
 		 * user-side. So if something waits for IO, then it will
 		 * wait for the 'master' bio.
 		 */
+		sector_t first_bad;
+		int bad_sectors;
+
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
 
+		/* Maybe we can clear some bad blocks. */
+		if (is_badblock(conf->mirrors[dev].rdev,
+				r10_bio->devs[slot].addr,
+				r10_bio->sectors,
+				&first_bad, &bad_sectors)) {
+			bio_put(bio);
+			r10_bio->devs[slot].bio = IO_MADE_GOOD;
+			dec_rdev = 0;
+			set_bit(R10BIO_MadeGood, &r10_bio->state);
+		}
+	}
+
 	/*
 	 *
 	 * Let's see if all mirrored write operations have finished
@@ -364,10 +384,13 @@ static void raid10_end_write_request(struct bio *bio, int error)
 				!test_bit(R10BIO_Degraded, &r10_bio->state),
 				0);
 		md_write_end(r10_bio->mddev);
-		raid_end_bio_io(r10_bio);
+		if (test_bit(R10BIO_MadeGood, &r10_bio->state))
+			reschedule_retry(r10_bio);
+		else
+			raid_end_bio_io(r10_bio);
 	}
-
-	rdev_dec_pending(conf->mirrors[dev].rdev, conf->mddev);
+	if (dec_rdev)
+		rdev_dec_pending(conf->mirrors[dev].rdev, conf->mddev);
 }
 
 
@@ -1382,7 +1405,7 @@ static void end_sync_read(struct bio *bio, int error)
 	conf_t *conf = r10_bio->mddev->private;
 	int d;
 
-	d = find_bio_disk(conf, r10_bio, bio);
+	d = find_bio_disk(conf, r10_bio, bio, NULL);
 
 	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
@@ -1414,23 +1437,37 @@ static void end_sync_write(struct bio *bio, int error)
 	mddev_t *mddev = r10_bio->mddev;
 	conf_t *conf = mddev->private;
 	int d;
+	sector_t first_bad;
+	int bad_sectors;
+	int slot;
 
-	d = find_bio_disk(conf, r10_bio, bio);
+	d = find_bio_disk(conf, r10_bio, bio, &slot);
 
 	if (!uptodate)
 		md_error(mddev, conf->mirrors[d].rdev);
+	else if (is_badblock(conf->mirrors[d].rdev,
+			     r10_bio->devs[slot].addr,
+			     r10_bio->sectors,
+			     &first_bad, &bad_sectors))
+		set_bit(R10BIO_MadeGood, &r10_bio->state);
 
 	rdev_dec_pending(conf->mirrors[d].rdev, mddev);
 	while (atomic_dec_and_test(&r10_bio->remaining)) {
 		if (r10_bio->master_bio == NULL) {
 			/* the primary of several recovery bios */
 			sector_t s = r10_bio->sectors;
-			put_buf(r10_bio);
+			if (test_bit(R10BIO_MadeGood, &r10_bio->state))
+				reschedule_retry(r10_bio);
+			else
+				put_buf(r10_bio);
 			md_done_sync(mddev, s, 1);
 			break;
 		} else {
 			r10bio_t *r10_bio2 = (r10bio_t *)r10_bio->master_bio;
-			put_buf(r10_bio);
+			if (test_bit(R10BIO_MadeGood, &r10_bio->state))
+				reschedule_retry(r10_bio);
+			else
+				put_buf(r10_bio);
 			r10_bio = r10_bio2;
 		}
 	}
@@ -1901,6 +1938,44 @@ read_more:
 		generic_make_request(bio);
 }
 
+static void handle_write_completed(conf_t *conf, r10bio_t *r10_bio)
+{
+	/* Some sort of write request has finished and it
+	 * succeeded in writing where we thought there was a
+	 * bad block.  So forget the bad block.
+	 */
+	int m;
+	mdk_rdev_t *rdev;
+
+	if (test_bit(R10BIO_IsSync, &r10_bio->state) ||
+	    test_bit(R10BIO_IsRecover, &r10_bio->state)) {
+		for (m = 0; m < conf->copies; m++)
+			if (r10_bio->devs[m].bio &&
+			    test_bit(BIO_UPTODATE,
+				     &r10_bio->devs[m].bio->bi_flags)) {
+				int dev = r10_bio->devs[m].devnum;
+				rdev = conf->mirrors[dev].rdev;
+				rdev_clear_badblocks(
+					rdev,
+					r10_bio->devs[m].addr,
+					r10_bio->sectors);
+			}
+		put_buf(r10_bio);
+	} else {
+		for (m = 0; m < conf->copies; m++)
+			if (r10_bio->devs[m].bio == IO_MADE_GOOD) {
+				int dev = r10_bio->devs[m].devnum;
+				rdev = conf->mirrors[dev].rdev;
+				rdev_clear_badblocks(
+					rdev,
+					r10_bio->devs[m].addr,
+					r10_bio->sectors);
+				rdev_dec_pending(rdev, conf->mddev);
+			}
+		raid_end_bio_io(r10_bio);
+	}
+}
+
 static void raid10d(mddev_t *mddev)
 {
 	r10bio_t *r10_bio;
@@ -1928,7 +2003,9 @@ static void raid10d(mddev_t *mddev)
 
 		mddev = r10_bio->mddev;
 		conf = mddev->private;
-		if (test_bit(R10BIO_IsSync, &r10_bio->state))
+		if (test_bit(R10BIO_MadeGood, &r10_bio->state))
+			handle_write_completed(conf, r10_bio);
+		else if (test_bit(R10BIO_IsSync, &r10_bio->state))
 			sync_request_write(mddev, r10_bio);
 		else if (test_bit(R10BIO_IsRecover, &r10_bio->state))
 			recovery_request_write(mddev, r10_bio);
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index c646152..d8b7f9a 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -118,6 +118,13 @@ struct r10bio_s {
  * level, we store IO_BLOCKED in the appropriate 'bios' pointer
  */
 #define IO_BLOCKED ((struct bio*)1)
+/* When we successfully write to a known bad-block, we need to remove the
+ * bad-block marking which must be done from process context.  So we record
+ * the success by setting devs[n].bio to IO_MADE_GOOD
+ */
+#define IO_MADE_GOOD ((struct bio *)2)
+
+#define BIO_SPECIAL(bio) ((unsigned long)bio <= 2)
 
 /* bits for r10bio.state */
 #define	R10BIO_Uptodate	0
@@ -128,4 +135,8 @@ struct r10bio_s {
  * so that raid10d knows what to do with them.
  */
 #define	R10BIO_ReadError 4
+/* If a write for this request means we can clear some
+ * known-bad-block records, we set this flag.
+ */
+#define	R10BIO_MadeGood 5
 #endif


