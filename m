From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 09/14] md/raid10: stop using bi_phys_segments
Date: Thu, 16 Feb 2017 15:39:02 +1100
Message-ID: <148721994257.7521.2502119977276847128.stgit@noble>
References: <148721992248.7521.17160361058957519076.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148721992248.7521.17160361058957519076.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

raid10 currently repurposes bi_phys_segments on each
incoming bio to count how many r10bio was used to encode the
request.

We need to know when the number of attached r10bio reaches
zero to:
1/ call bio_endio() when all IO on the bio is finished
2/ decrement ->nr_pending so that resync IO can proceed.

Now that the bio has its own __bi_remaining counter, that
can be used instead. We can call bio_inc_remaining to
increment the counter and call bio_endio() every time an
r10bio completes, rather than only when bi_phys_segments
reaches zero.

This addresses point 1, but not point 2.  bio_endio()
doesn't (and cannot) report when the last r10bio has
finished, so a different approach is needed.

So: instead of counting bios in ->nr_pending, count r10bios.
i.e. every time we attach a bio, increment nr_pending.
Every time an r10bio completes, decrement nr_pending.

Normally we only increment nr_pending after first checking
that ->barrier is zero, or some other non-trivial tests and
possible waiting.  When attaching multiple r10bios to a bio,
we only need the tests and the waiting once.  After the
first increment, subsequent increments can happen
unconditionally as they are really all part of the one
request.

So introduce inc_pending() which can be used when we know
that nr_pending is already elevated.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |   76 +++++++++++++++++----------------------------------
 1 file changed, 25 insertions(+), 51 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9258cbe233bb..6b4d8643c574 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -301,27 +301,18 @@ static void reschedule_retry(struct r10bio *r10_bio)
 static void raid_end_bio_io(struct r10bio *r10_bio)
 {
 	struct bio *bio = r10_bio->master_bio;
-	int done;
 	struct r10conf *conf = r10_bio->mddev->private;
 
-	if (bio->bi_phys_segments) {
-		unsigned long flags;
-		spin_lock_irqsave(&conf->device_lock, flags);
-		bio->bi_phys_segments--;
-		done = (bio->bi_phys_segments == 0);
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-	} else
-		done = 1;
 	if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
 		bio->bi_error = -EIO;
-	if (done) {
-		bio_endio(bio);
-		/*
-		 * Wake up any possible resync thread that waits for the device
-		 * to go idle.
-		 */
-		allow_barrier(conf);
-	}
+
+	/*
+	 * Wake up any possible resync thread that waits for the device
+	 * to go idle.
+	 */
+	allow_barrier(conf);
+	bio_endio(bio);
+
 	free_r10bio(r10_bio);
 }
 
@@ -984,6 +975,15 @@ static void wait_barrier(struct r10conf *conf)
 	spin_unlock_irq(&conf->resync_lock);
 }
 
+static void inc_pending(struct r10conf *conf)
+{
+	/* The current request requires multiple r10_bio, so
+	 * we need to increment the pending count.
+	 */
+	WARN_ON(!atomic_read(&conf->nr_pending));
+	atomic_inc(&conf->nr_pending);
+}
+
 static void allow_barrier(struct r10conf *conf)
 {
 	if ((atomic_dec_and_test(&conf->nr_pending)) ||
@@ -1161,12 +1161,8 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		sectors_handled = (r10_bio->sector + max_sectors
 				   - bio->bi_iter.bi_sector);
 		r10_bio->sectors = max_sectors;
-		spin_lock_irq(&conf->device_lock);
-		if (bio->bi_phys_segments == 0)
-			bio->bi_phys_segments = 2;
-		else
-			bio->bi_phys_segments++;
-		spin_unlock_irq(&conf->device_lock);
+		inc_pending(conf);
+		bio_inc_remaining(bio);
 		/*
 		 * Cannot call generic_make_request directly as that will be
 		 * queued in __generic_make_request and subsequent
@@ -1261,9 +1257,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	 * on which we have seen a write error, we want to avoid
 	 * writing to those blocks.  This potentially requires several
 	 * writes to write around the bad blocks.  Each set of writes
-	 * gets its own r10_bio with a set of bios attached.  The number
-	 * of r10_bios is recored in bio->bi_phys_segments just as with
-	 * the read case.
+	 * gets its own r10_bio with a set of bios attached.
 	 */
 
 	r10_bio->read_slot = -1; /* make sure repl_bio gets freed */
@@ -1481,15 +1475,9 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	 */
 
 	if (sectors_handled < bio_sectors(bio)) {
-		/* We need another r10_bio and it needs to be counted
-		 * in bio->bi_phys_segments.
-		 */
-		spin_lock_irq(&conf->device_lock);
-		if (bio->bi_phys_segments == 0)
-			bio->bi_phys_segments = 2;
-		else
-			bio->bi_phys_segments++;
-		spin_unlock_irq(&conf->device_lock);
+		/* We need another r10_bio and it needs to be counted */
+		inc_pending(conf);
+		bio_inc_remaining(bio);
 		one_write_done(r10_bio);
 		r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
@@ -1518,16 +1506,6 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
 
-	/*
-	 * We might need to issue multiple reads to different devices if there
-	 * are bad blocks around, so we keep track of the number of reads in
-	 * bio->bi_phys_segments.  If this is 0, there is only one r10_bio and
-	 * no locking will be needed when the request completes.  If it is
-	 * non-zero, then it is the number of not-completed requests.
-	 */
-	bio->bi_phys_segments = 0;
-	bio_clear_flag(bio, BIO_SEG_VALID);
-
 	if (bio_data_dir(bio) == READ)
 		raid10_read_request(mddev, bio, r10_bio);
 	else
@@ -2662,12 +2640,8 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 			r10_bio->sector + max_sectors
 			- mbio->bi_iter.bi_sector;
 		r10_bio->sectors = max_sectors;
-		spin_lock_irq(&conf->device_lock);
-		if (mbio->bi_phys_segments == 0)
-			mbio->bi_phys_segments = 2;
-		else
-			mbio->bi_phys_segments++;
-		spin_unlock_irq(&conf->device_lock);
+		bio_inc_remaining(mbio);
+		inc_pending(conf);
 		generic_make_request(bio);
 
 		r10_bio = mempool_alloc(conf->r10bio_pool,


