From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/36] md/raid1: clear bad-block record when write succeeds.
Date: Thu, 21 Jul 2011 12:58:48 +1000
Message-ID: <20110721025848.8422.11955.stgit@notabene.brown>
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

 drivers/md/raid1.c |   79 +++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid1.h |   13 ++++++++-
 2 files changed, 80 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 44277dc..6e605b2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -163,7 +163,7 @@ static void put_all_bios(conf_t *conf, r1bio_t *r1_bio)
 
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct bio **bio = r1_bio->bios + i;
-		if (*bio && *bio != IO_BLOCKED)
+		if (!BIO_SPECIAL(*bio))
 			bio_put(*bio);
 		*bio = NULL;
 	}
@@ -337,7 +337,10 @@ static void r1_bio_write_done(r1bio_t *r1_bio)
 				!test_bit(R1BIO_Degraded, &r1_bio->state),
 				test_bit(R1BIO_BehindIO, &r1_bio->state));
 		md_write_end(r1_bio->mddev);
-		raid_end_bio_io(r1_bio);
+		if (test_bit(R1BIO_MadeGood, &r1_bio->state))
+			reschedule_retry(r1_bio);
+		else
+			raid_end_bio_io(r1_bio);
 	}
 }
 
@@ -363,7 +366,7 @@ static void raid1_end_write_request(struct bio *bio, int error)
 		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
 		/* an I/O failed, we can't clear the bitmap */
 		set_bit(R1BIO_Degraded, &r1_bio->state);
-	} else
+	} else {
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that we
 		 * will return a good error code for to the higher
@@ -374,8 +377,20 @@ static void raid1_end_write_request(struct bio *bio, int error)
 		 * to user-side. So if something waits for IO, then it
 		 * will wait for the 'master' bio.
 		 */
+		sector_t first_bad;
+		int bad_sectors;
+
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 
+		/* Maybe we can clear some bad blocks. */
+		if (is_badblock(conf->mirrors[mirror].rdev,
+				r1_bio->sector, r1_bio->sectors,
+				&first_bad, &bad_sectors)) {
+			r1_bio->bios[mirror] = IO_MADE_GOOD;
+			set_bit(R1BIO_MadeGood, &r1_bio->state);
+		}
+	}
+
 	update_head_pos(mirror, r1_bio);
 
 	if (behind) {
@@ -402,7 +417,9 @@ static void raid1_end_write_request(struct bio *bio, int error)
 			}
 		}
 	}
-	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
+	if (r1_bio->bios[mirror] == NULL)
+		rdev_dec_pending(conf->mirrors[mirror].rdev,
+				 conf->mddev);
 
 	/*
 	 * Let's see if all mirrored write operations have finished
@@ -1341,6 +1358,8 @@ static void end_sync_write(struct bio *bio, int error)
 	conf_t *conf = mddev->private;
 	int i;
 	int mirror=0;
+	sector_t first_bad;
+	int bad_sectors;
 
 	for (i = 0; i < conf->raid_disks; i++)
 		if (r1_bio->bios[i] == bio) {
@@ -1359,14 +1378,22 @@ static void end_sync_write(struct bio *bio, int error)
 			sectors_to_go -= sync_blocks;
 		} while (sectors_to_go > 0);
 		md_error(mddev, conf->mirrors[mirror].rdev);
-	}
+	} else if (is_badblock(conf->mirrors[mirror].rdev,
+			       r1_bio->sector,
+			       r1_bio->sectors,
+			       &first_bad, &bad_sectors))
+		set_bit(R1BIO_MadeGood, &r1_bio->state);
 
 	update_head_pos(mirror, r1_bio);
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
-		sector_t s = r1_bio->sectors;
-		put_buf(r1_bio);
-		md_done_sync(mddev, s, uptodate);
+		int s = r1_bio->sectors;
+		if (test_bit(R1BIO_MadeGood, &r1_bio->state))
+			reschedule_retry(r1_bio);
+		else {
+			put_buf(r1_bio);
+			md_done_sync(mddev, s, uptodate);
+		}
 	}
 }
 
@@ -1728,9 +1755,39 @@ static void raid1d(mddev_t *mddev)
 
 		mddev = r1_bio->mddev;
 		conf = mddev->private;
-		if (test_bit(R1BIO_IsSync, &r1_bio->state))
-			sync_request_write(mddev, r1_bio);
-		else if (test_bit(R1BIO_ReadError, &r1_bio->state)) {
+		if (test_bit(R1BIO_IsSync, &r1_bio->state)) {
+			if (test_bit(R1BIO_MadeGood, &r1_bio->state)) {
+				int m;
+				int s = r1_bio->sectors;
+				for (m = 0; m < conf->raid_disks ; m++) {
+					struct bio *bio = r1_bio->bios[m];
+					if (bio->bi_end_io != NULL &&
+					    test_bit(BIO_UPTODATE,
+						     &bio->bi_flags)) {
+						rdev = conf->mirrors[m].rdev;
+						rdev_clear_badblocks(
+							rdev,
+							r1_bio->sector,
+							r1_bio->sectors);
+					}
+				}
+				put_buf(r1_bio);
+				md_done_sync(mddev, s, 1);
+			} else
+				sync_request_write(mddev, r1_bio);
+		} else if (test_bit(R1BIO_MadeGood, &r1_bio->state)) {
+			int m;
+			for (m = 0; m < conf->raid_disks ; m++)
+				if (r1_bio->bios[m] == IO_MADE_GOOD) {
+					rdev = conf->mirrors[m].rdev;
+					rdev_clear_badblocks(
+						rdev,
+						r1_bio->sector,
+						r1_bio->sectors);
+					rdev_dec_pending(rdev, mddev);
+				}
+			raid_end_bio_io(r1_bio);
+		} else if (test_bit(R1BIO_ReadError, &r1_bio->state)) {
 			int disk;
 			int max_sectors;
 
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index aa6af37..f81360d 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -116,7 +116,14 @@ struct r1bio_s {
  * correct the read error.  To keep track of bad blocks on a per-bio
  * level, we store IO_BLOCKED in the appropriate 'bios' pointer
  */
-#define IO_BLOCKED ((struct bio*)1)
+#define IO_BLOCKED ((struct bio *)1)
+/* When we successfully write to a known bad-block, we need to remove the
+ * bad-block marking which must be done from process context.  So we record
+ * the success by setting bios[n] to IO_MADE_GOOD
+ */
+#define IO_MADE_GOOD ((struct bio *)2)
+
+#define BIO_SPECIAL(bio) ((unsigned long)bio <= 2)
 
 /* bits for r1bio.state */
 #define	R1BIO_Uptodate	0
@@ -135,6 +142,10 @@ struct r1bio_s {
  * Record that bi_end_io was called with this flag...
  */
 #define	R1BIO_Returned 6
+/* If a write for this request means we can clear some
+ * known-bad-block records, we set this flag
+ */
+#define R1BIO_MadeGood 7
 
 extern int md_raid1_congested(mddev_t *mddev, int bits);
 


