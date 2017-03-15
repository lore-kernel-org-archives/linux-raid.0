From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 10/15] md/raid1: stop using bi_phys_segment
Date: Wed, 15 Mar 2017 14:05:14 +1100
Message-ID: <148954711389.18641.6044680366998154084.stgit@noble>
References: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954692173.18641.1294690639716682540.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

Change to use bio->__bi_remaining to count number of r1bio attached
to a bio.
See precious raid10 patch for more details.

Like the raid10.c patch, this fixes a bug as nr_queued and nr_pending
used to measure different things, but were being compared.

This patch fixes another bug in that nr_pending previously did not
could write-behind requests, so behind writes could continue while
resync was happening.  How that nr_pending counts all r1_bio,
the resync cannot commence until the behind writes have completed.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c |   87 +++++++++++++---------------------------------------
 1 file changed, 22 insertions(+), 65 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7e509a894f15..e566407b196f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -246,35 +246,18 @@ static void reschedule_retry(struct r1bio *r1_bio)
 static void call_bio_endio(struct r1bio *r1_bio)
 {
 	struct bio *bio = r1_bio->master_bio;
-	int done;
 	struct r1conf *conf = r1_bio->mddev->private;
 	sector_t bi_sector = bio->bi_iter.bi_sector;
 
-	if (bio->bi_phys_segments) {
-		unsigned long flags;
-		spin_lock_irqsave(&conf->device_lock, flags);
-		bio->bi_phys_segments--;
-		done = (bio->bi_phys_segments == 0);
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-		/*
-		 * make_request() might be waiting for
-		 * bi_phys_segments to decrease
-		 */
-		wake_up(&conf->wait_barrier);
-	} else
-		done = 1;
-
 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
 		bio->bi_error = -EIO;
 
-	if (done) {
-		bio_endio(bio);
-		/*
-		 * Wake up any possible resync thread that waits for the device
-		 * to go idle.
-		 */
-		allow_barrier(conf, bi_sector);
-	}
+	bio_endio(bio);
+	/*
+	 * Wake up any possible resync thread that waits for the device
+	 * to go idle.
+	 */
+	allow_barrier(conf, bi_sector);
 }
 
 static void raid_end_bio_io(struct r1bio *r1_bio)
@@ -977,6 +960,16 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
 	spin_unlock_irq(&conf->resync_lock);
 }
 
+static void inc_pending(struct r1conf *conf, sector_t bi_sector)
+{
+	/* The current request requires multiple r1_bio, so
+	 * we need to increment the pending count, and the corresponding
+	 * window count.
+	 */
+	int idx = sector_to_idx(bi_sector);
+	atomic_inc(&conf->nr_pending[idx]);
+}
+
 static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
 {
 	int idx = sector_to_idx(sector_nr);
@@ -1192,17 +1185,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio)
 	r1_bio = alloc_r1bio(mddev, bio, 0);
 
 	/*
-	 * We might need to issue multiple reads to different
-	 * devices if there are bad blocks around, so we keep
-	 * track of the number of reads in bio->bi_phys_segments.
-	 * If this is 0, there is only one r1_bio and no locking
-	 * will be needed when requests complete.  If it is
-	 * non-zero, then it is the number of not-completed requests.
-	 */
-	bio->bi_phys_segments = 0;
-	bio_clear_flag(bio, BIO_SEG_VALID);
-
-	/*
 	 * make_request() can abort the operation when read-ahead is being
 	 * used and no empty request is available.
 	 */
@@ -1257,12 +1239,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio)
 		sectors_handled = (r1_bio->sector + max_sectors
 				   - bio->bi_iter.bi_sector);
 		r1_bio->sectors = max_sectors;
-		spin_lock_irq(&conf->device_lock);
-		if (bio->bi_phys_segments == 0)
-			bio->bi_phys_segments = 2;
-		else
-			bio->bi_phys_segments++;
-		spin_unlock_irq(&conf->device_lock);
+		bio_inc_remaining(bio);
 
 		/*
 		 * Cannot call generic_make_request directly as that will be
@@ -1329,16 +1306,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 
 	r1_bio = alloc_r1bio(mddev, bio, 0);
 
-	/* We might need to issue multiple writes to different
-	 * devices if there are bad blocks around, so we keep
-	 * track of the number of writes in bio->bi_phys_segments.
-	 * If this is 0, there is only one r1_bio and no locking
-	 * will be needed when requests complete.  If it is
-	 * non-zero, then it is the number of not-completed requests.
-	 */
-	bio->bi_phys_segments = 0;
-	bio_clear_flag(bio, BIO_SEG_VALID);
-
 	if (conf->pending_count >= max_queued_requests) {
 		md_wakeup_thread(mddev->thread);
 		raid1_log(mddev, "wait queued");
@@ -1544,16 +1511,11 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 	 * as it could result in the bio being freed.
 	 */
 	if (sectors_handled < bio_sectors(bio)) {
-		/* We need another r1_bio, which must be accounted
-		 * in bio->bi_phys_segments
-		 */
-		spin_lock_irq(&conf->device_lock);
-		if (bio->bi_phys_segments == 0)
-			bio->bi_phys_segments = 2;
-		else
-			bio->bi_phys_segments++;
-		spin_unlock_irq(&conf->device_lock);
+		/* We need another r1_bio, which must be counted */
+		sector_t sect = bio->bi_iter.bi_sector + sectors_handled;
 
+		inc_pending(conf, sect);
+		bio_inc_remaining(bio);
 		r1_bio_write_done(r1_bio);
 		r1_bio = alloc_r1bio(mddev, bio, sectors_handled);
 		goto retry_write;
@@ -2573,12 +2535,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 			int sectors_handled = (r1_bio->sector + max_sectors
 					       - mbio->bi_iter.bi_sector);
 			r1_bio->sectors = max_sectors;
-			spin_lock_irq(&conf->device_lock);
-			if (mbio->bi_phys_segments == 0)
-				mbio->bi_phys_segments = 2;
-			else
-				mbio->bi_phys_segments++;
-			spin_unlock_irq(&conf->device_lock);
+			bio_inc_remaining(mbio);
 			trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
 					      bio, bio_dev, bio_sector);
 			generic_make_request(bio);


