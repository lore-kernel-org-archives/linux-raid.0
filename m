From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 3/6] md/raid1: add failfast handling for reads.
Date: Fri, 18 Nov 2016 16:16:12 +1100
Message-ID: <147944617189.3302.1561958089968622672.stgit@noble>
References: <147944614789.3302.1959091446949640579.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147944614789.3302.1959091446949640579.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-raid.ids

If a device is marked FailFast and it is not the only device
we can read from, we mark the bio with REQ_FAILFAST_* flags.

If this does fail, we don't try read repair but just allow
failure.  If it was the last device it doesn't fail of
course, so the retry happens on the same device - this time
without FAILFAST.  A subsequent failure will not retry but
will just pass up the error.

During resync we may use FAILFAST requests and on a failure
we will simply use the other device(s).

During recovery we will only use FAILFAST in the unusual
case were there are multiple places to read from - i.e. if
there are > 2 devices.  If we get a failure we will fail the
device and complete the resync/recovery with remaining
devices.

The new R1BIO_FailFast flag is set on read reqest to suggest
the a FAILFAST request might be acceptable.  The rdev needs
to have FailFast set as well for the read to actually use
REQ_FAILFAST_*.

We need to know there are at least two working devices
before we can set R1BIO_FailFast, so we mustn't stop looking
at the first device we find.  So the "min_pending == 0"
handling to not exit early, but too always choose the
best_pending_disk if min_pending == 0.

The spinlocked region in raid1_error() in enlarged to ensure
that if two bios, reading from two different devices, fail
at the same time, then there is no risk that both devices
will be marked faulty, leaving zero "In_sync" devices.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c |   52 ++++++++++++++++++++++++++++++++++++++++++----------
 drivers/md/raid1.h |    1 +
 2 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cfd73730e6af..44f93297698d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -330,6 +330,11 @@ static void raid1_end_read_request(struct bio *bio)
 
 	if (uptodate)
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
+	else if (test_bit(FailFast, &rdev->flags) &&
+		 test_bit(R1BIO_FailFast, &r1_bio->state))
+		/* This was a fail-fast read so we definitely
+		 * want to retry */
+		;
 	else {
 		/* If all other devices have failed, we want to return
 		 * the error upwards rather than fail the last device.
@@ -536,6 +541,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 	best_good_sectors = 0;
 	has_nonrot_disk = 0;
 	choose_next_idle = 0;
+	clear_bit(R1BIO_FailFast, &r1_bio->state);
 
 	if ((conf->mddev->recovery_cp < this_sector + sectors) ||
 	    (mddev_is_clustered(conf->mddev) &&
@@ -609,6 +615,10 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 		} else
 			best_good_sectors = sectors;
 
+		if (best_disk >= 0)
+			/* At least two disks to choose from so failfast is OK */
+			set_bit(R1BIO_FailFast, &r1_bio->state);
+
 		nonrot = blk_queue_nonrot(bdev_get_queue(rdev->bdev));
 		has_nonrot_disk |= nonrot;
 		pending = atomic_read(&rdev->nr_pending);
@@ -647,11 +657,6 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 			}
 			break;
 		}
-		/* If device is idle, use it */
-		if (pending == 0) {
-			best_disk = disk;
-			break;
-		}
 
 		if (choose_next_idle)
 			continue;
@@ -674,7 +679,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 	 * mixed ratation/non-rotational disks depending on workload.
 	 */
 	if (best_disk == -1) {
-		if (has_nonrot_disk)
+		if (has_nonrot_disk || min_pending == 0)
 			best_disk = best_pending_disk;
 		else
 			best_disk = best_dist_disk;
@@ -1168,6 +1173,9 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
 		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = raid1_end_read_request;
 		bio_set_op_attrs(read_bio, op, do_sync);
+		if (test_bit(FailFast, &mirror->rdev->flags) &&
+		    test_bit(R1BIO_FailFast, &r1_bio->state))
+			read_bio->bi_opf |= MD_FAILFAST;
 		read_bio->bi_private = r1_bio;
 
 		if (mddev->gendisk)
@@ -1465,6 +1473,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	 * next level up know.
 	 * else mark the drive as failed
 	 */
+	spin_lock_irqsave(&conf->device_lock, flags);
 	if (test_bit(In_sync, &rdev->flags)
 	    && (conf->raid_disks - mddev->degraded) == 1) {
 		/*
@@ -1474,10 +1483,10 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 		 * it is very likely to fail.
 		 */
 		conf->recovery_disabled = mddev->recovery_disabled;
+		spin_unlock_irqrestore(&conf->device_lock, flags);
 		return;
 	}
 	set_bit(Blocked, &rdev->flags);
-	spin_lock_irqsave(&conf->device_lock, flags);
 	if (test_and_clear_bit(In_sync, &rdev->flags)) {
 		mddev->degraded++;
 		set_bit(Faulty, &rdev->flags);
@@ -1816,12 +1825,24 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 	sector_t sect = r1_bio->sector;
 	int sectors = r1_bio->sectors;
 	int idx = 0;
+	struct md_rdev *rdev;
+
+	rdev = conf->mirrors[r1_bio->read_disk].rdev;
+	if (test_bit(FailFast, &rdev->flags)) {
+		/* Don't try recovering from here - just fail it
+		 * ... unless it is the last working device of course */
+		md_error(mddev, rdev);
+		if (test_bit(Faulty, &rdev->flags))
+			/* Don't try to read from here, but make sure
+			 * put_buf does it's thing
+			 */
+			bio->bi_end_io = end_sync_write;
+	}
 
 	while(sectors) {
 		int s = sectors;
 		int d = r1_bio->read_disk;
 		int success = 0;
-		struct md_rdev *rdev;
 		int start;
 
 		if (s > (PAGE_SIZE>>9))
@@ -2332,7 +2353,9 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	bio_put(bio);
 	r1_bio->bios[r1_bio->read_disk] = NULL;
 
-	if (mddev->ro == 0) {
+	rdev = conf->mirrors[r1_bio->read_disk].rdev;
+	if (mddev->ro == 0
+	    && !test_bit(FailFast, &rdev->flags)) {
 		freeze_array(conf, 1);
 		fix_read_error(conf, r1_bio->read_disk,
 			       r1_bio->sector, r1_bio->sectors);
@@ -2341,7 +2364,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
 	}
 
-	rdev_dec_pending(conf->mirrors[r1_bio->read_disk].rdev, conf->mddev);
+	rdev_dec_pending(rdev, conf->mddev);
 
 read_more:
 	disk = read_balance(conf, r1_bio, &max_sectors);
@@ -2366,6 +2389,9 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 		bio->bi_bdev = rdev->bdev;
 		bio->bi_end_io = raid1_end_read_request;
 		bio_set_op_attrs(bio, REQ_OP_READ, do_sync);
+		if (test_bit(FailFast, &rdev->flags) &&
+		    test_bit(R1BIO_FailFast, &r1_bio->state))
+			bio->bi_opf |= MD_FAILFAST;
 		bio->bi_private = r1_bio;
 		if (max_sectors < r1_bio->sectors) {
 			/* Drat - have to split this up more */
@@ -2654,6 +2680,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_iter.bi_sector = sector_nr + rdev->data_offset;
 			bio->bi_bdev = rdev->bdev;
 			bio->bi_private = r1_bio;
+			if (test_bit(FailFast, &rdev->flags))
+				bio->bi_opf |= MD_FAILFAST;
 		}
 	}
 	rcu_read_unlock();
@@ -2784,6 +2812,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (bio->bi_end_io == end_sync_read) {
 				read_targets--;
 				md_sync_acct(bio->bi_bdev, nr_sectors);
+				if (read_targets == 1)
+					bio->bi_opf &= ~MD_FAILFAST;
 				generic_make_request(bio);
 			}
 		}
@@ -2791,6 +2821,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		atomic_set(&r1_bio->remaining, 1);
 		bio = r1_bio->bios[r1_bio->read_disk];
 		md_sync_acct(bio->bi_bdev, nr_sectors);
+		if (read_targets == 1)
+			bio->bi_opf &= ~MD_FAILFAST;
 		generic_make_request(bio);
 
 	}
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 5ec19449779d..c52ef424a24b 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -183,5 +183,6 @@ enum r1bio_state {
  */
 	R1BIO_MadeGood,
 	R1BIO_WriteError,
+	R1BIO_FailFast,
 };
 #endif


