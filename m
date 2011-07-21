From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 24/36] md/raid10: avoid reading from known bad blocks -
 part 1
Date: Thu, 21 Jul 2011 12:58:49 +1000
Message-ID: <20110721025849.8422.99158.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch just covers the basic read path:
 1/ read_balance needs to check for badblocks, and return not only
    the chosen slot, but also how many good blocks are available
    there.
 2/ read submission must be ready to issue multiple reads to
    different devices as different bad blocks on different devices
    could mean that a single large read cannot be served by any one
    device, but can still be served by the array.
    This requires keeping count of the number of outstanding requests
    per bio.  This count is stored in 'bi_phys_segments'

On read error we currently just fail the request if another target
cannot handle the whole request.  Next patch refines that a bit.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |  141 +++++++++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid10.h |    4 +
 2 files changed, 129 insertions(+), 16 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f1b749c..872bf94 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -191,12 +191,6 @@ static void free_r10bio(r10bio_t *r10_bio)
 {
 	conf_t *conf = r10_bio->mddev->private;
 
-	/*
-	 * Wake up any possible resync thread that waits for the device
-	 * to go idle.
-	 */
-	allow_barrier(conf);
-
 	put_all_bios(conf, r10_bio);
 	mempool_free(r10_bio, conf->r10bio_pool);
 }
@@ -235,9 +229,27 @@ static void reschedule_retry(r10bio_t *r10_bio)
 static void raid_end_bio_io(r10bio_t *r10_bio)
 {
 	struct bio *bio = r10_bio->master_bio;
+	int done;
+	conf_t *conf = r10_bio->mddev->private;
 
-	bio_endio(bio,
-		test_bit(R10BIO_Uptodate, &r10_bio->state) ? 0 : -EIO);
+	if (bio->bi_phys_segments) {
+		unsigned long flags;
+		spin_lock_irqsave(&conf->device_lock, flags);
+		bio->bi_phys_segments--;
+		done = (bio->bi_phys_segments == 0);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+	} else
+		done = 1;
+	if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	if (done) {
+		bio_endio(bio, 0);
+		/*
+		 * Wake up any possible resync thread that waits for the device
+		 * to go idle.
+		 */
+		allow_barrier(conf);
+	}
 	free_r10bio(r10_bio);
 }
 
@@ -307,6 +319,7 @@ static void raid10_end_read_request(struct bio *bio, int error)
 				   mdname(conf->mddev),
 				   bdevname(conf->mirrors[dev].rdev->bdev, b),
 				   (unsigned long long)r10_bio->sector);
+		set_bit(R10BIO_ReadError, &r10_bio->state);
 		reschedule_retry(r10_bio);
 	}
 }
@@ -505,11 +518,12 @@ static int raid10_mergeable_bvec(struct request_queue *q,
  * FIXME: possibly should rethink readbalancing and do it differently
  * depending on near_copies / far_copies geometry.
  */
-static int read_balance(conf_t *conf, r10bio_t *r10_bio)
+static int read_balance(conf_t *conf, r10bio_t *r10_bio, int *max_sectors)
 {
 	const sector_t this_sector = r10_bio->sector;
 	int disk, slot;
-	const int sectors = r10_bio->sectors;
+	int sectors = r10_bio->sectors;
+	int best_good_sectors;
 	sector_t new_distance, best_dist;
 	mdk_rdev_t *rdev;
 	int do_balance;
@@ -518,8 +532,10 @@ static int read_balance(conf_t *conf, r10bio_t *r10_bio)
 	raid10_find_phys(conf, r10_bio);
 	rcu_read_lock();
 retry:
+	sectors = r10_bio->sectors;
 	best_slot = -1;
 	best_dist = MaxSector;
+	best_good_sectors = 0;
 	do_balance = 1;
 	/*
 	 * Check if we can balance. We can balance on the whole
@@ -532,6 +548,10 @@ retry:
 		do_balance = 0;
 
 	for (slot = 0; slot < conf->copies ; slot++) {
+		sector_t first_bad;
+		int bad_sectors;
+		sector_t dev_sector;
+
 		if (r10_bio->devs[slot].bio == IO_BLOCKED)
 			continue;
 		disk = r10_bio->devs[slot].devnum;
@@ -541,6 +561,37 @@ retry:
 		if (!test_bit(In_sync, &rdev->flags))
 			continue;
 
+		dev_sector = r10_bio->devs[slot].addr;
+		if (is_badblock(rdev, dev_sector, sectors,
+				&first_bad, &bad_sectors)) {
+			if (best_dist < MaxSector)
+				/* Already have a better slot */
+				continue;
+			if (first_bad <= dev_sector) {
+				/* Cannot read here.  If this is the
+				 * 'primary' device, then we must not read
+				 * beyond 'bad_sectors' from another device.
+				 */
+				bad_sectors -= (dev_sector - first_bad);
+				if (!do_balance && sectors > bad_sectors)
+					sectors = bad_sectors;
+				if (best_good_sectors > sectors)
+					best_good_sectors = sectors;
+			} else {
+				sector_t good_sectors =
+					first_bad - dev_sector;
+				if (good_sectors > best_good_sectors) {
+					best_good_sectors = good_sectors;
+					best_slot = slot;
+				}
+				if (!do_balance)
+					/* Must read from here */
+					break;
+			}
+			continue;
+		} else
+			best_good_sectors = sectors;
+
 		if (!do_balance)
 			break;
 
@@ -582,6 +633,7 @@ retry:
 	} else
 		disk = -1;
 	rcu_read_unlock();
+	*max_sectors = best_good_sectors;
 
 	return disk;
 }
@@ -829,12 +881,27 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	r10_bio->sector = bio->bi_sector;
 	r10_bio->state = 0;
 
+	/* We might need to issue multiple reads to different
+	 * devices if there are bad blocks around, so we keep
+	 * track of the number of reads in bio->bi_phys_segments.
+	 * If this is 0, there is only one r10_bio and no locking
+	 * will be needed when the request completes.  If it is
+	 * non-zero, then it is the number of not-completed requests.
+	 */
+	bio->bi_phys_segments = 0;
+	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
+
 	if (rw == READ) {
 		/*
 		 * read balancing logic:
 		 */
-		int disk = read_balance(conf, r10_bio);
-		int slot = r10_bio->read_slot;
+		int max_sectors;
+		int disk;
+		int slot;
+
+read_again:
+		disk = read_balance(conf, r10_bio, &max_sectors);
+		slot = r10_bio->read_slot;
 		if (disk < 0) {
 			raid_end_bio_io(r10_bio);
 			return 0;
@@ -842,6 +909,8 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		mirror = conf->mirrors + disk;
 
 		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+		md_trim_bio(read_bio, r10_bio->sector - bio->bi_sector,
+			    max_sectors);
 
 		r10_bio->devs[slot].bio = read_bio;
 
@@ -852,7 +921,39 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		read_bio->bi_rw = READ | do_sync;
 		read_bio->bi_private = r10_bio;
 
-		generic_make_request(read_bio);
+		if (max_sectors < r10_bio->sectors) {
+			/* Could not read all from this device, so we will
+			 * need another r10_bio.
+			 */
+			int sectors_handled;
+
+			sectors_handled = (r10_bio->sectors + max_sectors
+					   - bio->bi_sector);
+			r10_bio->sectors = max_sectors;
+			spin_lock_irq(&conf->device_lock);
+			if (bio->bi_phys_segments == 0)
+				bio->bi_phys_segments = 2;
+			else
+				bio->bi_phys_segments++;
+			spin_unlock(&conf->device_lock);
+			/* Cannot call generic_make_request directly
+			 * as that will be queued in __generic_make_request
+			 * and subsequent mempool_alloc might block
+			 * waiting for it.  so hand bio over to raid10d.
+			 */
+			reschedule_retry(r10_bio);
+
+			r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
+
+			r10_bio->master_bio = bio;
+			r10_bio->sectors = ((bio->bi_size >> 9)
+					    - sectors_handled);
+			r10_bio->state = 0;
+			r10_bio->mddev = mddev;
+			r10_bio->sector = bio->bi_sector + sectors_handled;
+			goto read_again;
+		} else
+			generic_make_request(read_bio);
 		return 0;
 	}
 
@@ -1627,6 +1728,7 @@ static void handle_read_error(mddev_t *mddev, r10bio_t *r10_bio)
 	mdk_rdev_t *rdev;
 	char b[BDEVNAME_SIZE];
 	unsigned long do_sync;
+	int max_sectors;
 
 	/* we got a read error. Maybe the drive is bad.  Maybe just
 	 * the block and we can fix it.
@@ -1646,8 +1748,8 @@ static void handle_read_error(mddev_t *mddev, r10bio_t *r10_bio)
 	bio = r10_bio->devs[slot].bio;
 	r10_bio->devs[slot].bio =
 		mddev->ro ? IO_BLOCKED : NULL;
-	mirror = read_balance(conf, r10_bio);
-	if (mirror == -1) {
+	mirror = read_balance(conf, r10_bio, &max_sectors);
+	if (mirror == -1 || max_sectors < r10_bio->sectors) {
 		printk(KERN_ALERT "md/raid10:%s: %s: unrecoverable I/O"
 		       " read error for block %llu\n",
 		       mdname(mddev),
@@ -1712,8 +1814,15 @@ static void raid10d(mddev_t *mddev)
 			sync_request_write(mddev, r10_bio);
 		else if (test_bit(R10BIO_IsRecover, &r10_bio->state))
 			recovery_request_write(mddev, r10_bio);
-		else
+		else if (test_bit(R10BIO_ReadError, &r10_bio->state))
 			handle_read_error(mddev, r10_bio);
+		else {
+			/* just a partial read to be scheduled from a
+			 * separate context
+			 */
+			int slot = r10_bio->read_slot;
+			generic_make_request(r10_bio->devs[slot].bio);
+		}
 
 		cond_resched();
 		if (mddev->flags & ~(1<<MD_CHANGE_PENDING))
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index a485914..c646152 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -124,4 +124,8 @@ struct r10bio_s {
 #define	R10BIO_IsSync	1
 #define	R10BIO_IsRecover 2
 #define	R10BIO_Degraded 3
+/* Set ReadError on bios that experience a read error
+ * so that raid10d knows what to do with them.
+ */
+#define	R10BIO_ReadError 4
 #endif


