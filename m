From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 15/16] md/raid1: clear bad-block record when write succeeds.
Date: Mon, 07 Jun 2010 10:07:56 +1000
Message-ID: <20100607000756.13302.33760.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we succeed in writing to a block that was recorded as
being bad, we clear the bad-block record.

This requires some delayed handling as the bad-block-list update has
to happen in process-context.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid1.h |   13 +++++++++++-
 2 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d240d58..e23ec40 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -175,7 +175,7 @@ static void put_all_bios(conf_t *conf, r1bio_t *r1_bio)
 
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct bio **bio = r1_bio->bios + i;
-		if (*bio && *bio != IO_BLOCKED)
+		if (!BIO_SPECIAL(*bio))
 			bio_put(*bio);
 		*bio = NULL;
 	}
@@ -348,7 +348,7 @@ static void raid1_end_write_request(struct bio *bio, int error)
 			md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
 			/* an I/O failed, we can't clear the bitmap */
 			set_bit(R1BIO_Degraded, &r1_bio->state);
-		} else
+		} else {
 			/*
 			 * Set R1BIO_Uptodate in our master bio, so that
 			 * we will return a good error code for to the higher
@@ -360,6 +360,15 @@ static void raid1_end_write_request(struct bio *bio, int error)
 			 */
 			set_bit(R1BIO_Uptodate, &r1_bio->state);
 
+			/* Maybe we can clear some bad blocks. */
+			if (is_badblock(conf->mirrors[mirror].rdev,
+					r1_bio->sector, r1_bio->sectors,
+					NULL, NULL)) {
+				r1_bio->bios[mirror] = IO_MADE_GOOD;
+				set_bit(R1BIO_MadeGood, &r1_bio->state);
+			}
+		}
+
 		update_head_pos(mirror, r1_bio);
 
 		if (behind) {
@@ -384,7 +393,9 @@ static void raid1_end_write_request(struct bio *bio, int error)
 				}
 			}
 		}
-		rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
+		if (r1_bio->bios[mirror] == NULL)
+			rdev_dec_pending(conf->mirrors[mirror].rdev,
+					 conf->mddev);
 	}
 	/*
 	 *
@@ -408,7 +419,10 @@ static void raid1_end_write_request(struct bio *bio, int error)
 					!test_bit(R1BIO_Degraded, &r1_bio->state),
 					behind);
 			md_write_end(r1_bio->mddev);
-			raid_end_bio_io(r1_bio);
+			if (test_bit(R1BIO_MadeGood, &r1_bio->state))
+				reschedule_retry(r1_bio);
+			else
+				raid_end_bio_io(r1_bio);
 		}
 	}
 
@@ -1451,7 +1465,11 @@ static void end_sync_write(struct bio *bio, int error)
 			sectors_to_go -= sync_blocks;
 		} while (sectors_to_go > 0);
 		md_error(mddev, conf->mirrors[mirror].rdev);
-	}
+	} else if (is_badblock(conf->mirrors[mirror].rdev,
+			       r1_bio->sector,
+			       r1_bio->sectors,
+			       NULL, NULL))
+		set_bit(R1BIO_MadeGood, &r1_bio->state);
 
 	update_head_pos(mirror, r1_bio);
 
@@ -1812,8 +1830,34 @@ static void raid1d(mddev_t *mddev)
 		mddev = r1_bio->mddev;
 		conf = mddev->private;
 		if (test_bit(R1BIO_IsSync, &r1_bio->state)) {
-			sync_request_write(mddev, r1_bio);
-			unplug = 1;
+			if (test_bit(R1BIO_MadeGood, &r1_bio->state)) {
+				int m;
+				for (m = 0; m < conf->raid_disks ; m++)
+					if (!BIO_SPECIAL(r1_bio->bios[m]) &&
+					    test_bit(BIO_UPTODATE,
+						     &r1_bio->bios[m]->bi_flags)) {
+						md_clear_badblocks(
+							&conf->mirrors[m].rdev->badblocks,
+							r1_bio->sector,
+							r1_bio->sectors);
+					}
+				put_buf(r1_bio);
+			} else {
+				sync_request_write(mddev, r1_bio);
+				unplug = 1;
+			}
+		} else if (test_bit(R1BIO_MadeGood, &r1_bio->state)) {
+			int m;
+			for (m = 0; m < conf->raid_disks ; m++)
+				if (r1_bio->bios[m] == IO_MADE_GOOD) {
+					md_clear_badblocks(
+						&conf->mirrors[m].rdev->badblocks,
+						r1_bio->sector,
+						r1_bio->sectors);
+					rdev_dec_pending(conf->mirrors[m].rdev,
+							 mddev);
+				}
+			raid_end_bio_io(r1_bio);
 		} else if (test_bit(R1BIO_BarrierRetry, &r1_bio->state)) {
 			/* some requests in the r1bio were BIO_RW_BARRIER
 			 * requests which failed with -EOPNOTSUPP.  Hohumm..
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 5f2d443..c91c736 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -110,7 +110,14 @@ struct r1bio_s {
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
@@ -127,5 +134,9 @@ struct r1bio_s {
  * Record that bi_end_io was called with this flag...
  */
 #define	R1BIO_Returned 6
+/* If a write for this request means we can clear some
+ * known-bad-block records, we set this flag
+ */
+#define R1BIO_MadeGood 7
 
 #endif


