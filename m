From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 15/36] md/raid1: improve handling of read failure during
 recovery.
Date: Thu, 21 Jul 2011 12:58:49 +1000
Message-ID: <20110721025848.8422.18207.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we cannot read a block from anywhere during recovery, there is
now a better approach than just giving up.
We can record a bad block on each device and keep going - being
careful not to clear the bad block when a write succeeds as it might -
it will be a write of incorrect data.

We have now reached the state where - for raid1 - we only call
md_error if md_set_badblocks has failed.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 83c918e..08ff21a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1393,7 +1393,12 @@ static void end_sync_write(struct bio *bio, int error)
 	} else if (is_badblock(conf->mirrors[mirror].rdev,
 			       r1_bio->sector,
 			       r1_bio->sectors,
-			       &first_bad, &bad_sectors))
+			       &first_bad, &bad_sectors) &&
+		   !is_badblock(conf->mirrors[r1_bio->read_disk].rdev,
+				r1_bio->sector,
+				r1_bio->sectors,
+				&first_bad, &bad_sectors)
+		)
 		set_bit(R1BIO_MadeGood, &r1_bio->state);
 
 	update_head_pos(mirror, r1_bio);
@@ -1474,16 +1479,36 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 
 		if (!success) {
 			char b[BDEVNAME_SIZE];
-			/* Cannot read from anywhere, array is toast */
-			md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
+			int abort = 0;
+			/* Cannot read from anywhere, this block is lost.
+			 * Record a bad block on each device.  If that doesn't
+			 * work just disable and interrupt the recovery.
+			 * Don't fail devices as that won't really help.
+			 */
 			printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O read error"
 			       " for block %llu\n",
 			       mdname(mddev),
 			       bdevname(bio->bi_bdev, b),
 			       (unsigned long long)r1_bio->sector);
-			md_done_sync(mddev, r1_bio->sectors, 0);
-			put_buf(r1_bio);
-			return 0;
+			for (d = 0; d < conf->raid_disks; d++) {
+				rdev = conf->mirrors[d].rdev;
+				if (!rdev || test_bit(Faulty, &rdev->flags))
+					continue;
+				if (!rdev_set_badblocks(rdev, sect, s, 0))
+					abort = 1;
+			}
+			if (abort) {
+				mddev->recovery_disabled = 1;
+				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+				md_done_sync(mddev, r1_bio->sectors, 0);
+				put_buf(r1_bio);
+				return 0;
+			}
+			/* Try next page */
+			sectors -= s;
+			sect += s;
+			idx++;
+			continue;
 		}
 
 		start = d;
@@ -1880,7 +1905,9 @@ static void raid1d(mddev_t *mddev)
 					if (bio->bi_end_io == NULL)
 						continue;
 					if (test_bit(BIO_UPTODATE,
-						     &bio->bi_flags)) {
+						     &bio->bi_flags) &&
+					    test_bit(R1BIO_MadeGood,
+						     &r1_bio->state)) {
 						rdev_clear_badblocks(
 							rdev,
 							r1_bio->sector,


