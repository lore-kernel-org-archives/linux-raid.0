From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/36] md/raid1: avoid reading from known bad blocks.
Date: Thu, 21 Jul 2011 12:58:48 +1000
Message-ID: <20110721025848.8422.199.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now that we have a bad block list, we should not read from those
blocks.
There are several main parts to this:
  1/ read_balance needs to check for bad blocks, and return not only
     the chosen device, but also how many good blocks are available
     there.
  2/ fix_read_error needs to avoid trying to read from bad blocks.
  3/ read submission must be ready to issue multiple reads to
     different devices as different bad blocks on different devices
     could mean that a single large read cannot be served by any one
     device, but can still be served by the array.
     This requires keeping count of the number of outstanding requests
     per bio.  This count is stored in 'bi_phys_segments'
  4/ retrying a read needs to also be ready to submit a smaller read
     and queue another request for the rest.

This does not yet handle bad blocks when reading to perform resync,
recovery, or check.

'md_trim_bio' will also be used for RAID10, so put it in md.c and
export it.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c    |   49 ++++++++++++
 drivers/md/md.h    |    1 
 drivers/md/raid1.c |  208 +++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid1.h |    4 +
 4 files changed, 233 insertions(+), 29 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 340e2d4..430bc8b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -215,6 +215,55 @@ struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL_GPL(bio_clone_mddev);
 
+void md_trim_bio(struct bio *bio, int offset, int size)
+{
+	/* 'bio' is a cloned bio which we need to trim to match
+	 * the given offset and size.
+	 * This requires adjusting bi_sector, bi_size, and bi_io_vec
+	 */
+	int i;
+	struct bio_vec *bvec;
+	int sofar = 0;
+
+	size <<= 9;
+	if (offset == 0 && size == bio->bi_size)
+		return;
+
+	bio->bi_sector += offset;
+	bio->bi_size = size;
+	offset <<= 9;
+	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
+
+	while (bio->bi_idx < bio->bi_vcnt &&
+	       bio->bi_io_vec[bio->bi_idx].bv_len <= offset) {
+		/* remove this whole bio_vec */
+		offset -= bio->bi_io_vec[bio->bi_idx].bv_len;
+		bio->bi_idx++;
+	}
+	if (bio->bi_idx < bio->bi_vcnt) {
+		bio->bi_io_vec[bio->bi_idx].bv_offset += offset;
+		bio->bi_io_vec[bio->bi_idx].bv_len -= offset;
+	}
+	/* avoid any complications with bi_idx being non-zero*/
+	if (bio->bi_idx) {
+		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_idx,
+			(bio->bi_vcnt - bio->bi_idx) * sizeof(struct bio_vec));
+		bio->bi_vcnt -= bio->bi_idx;
+		bio->bi_idx = 0;
+	}
+	/* Make sure vcnt and last bv are not too big */
+	bio_for_each_segment(bvec, bio, i) {
+		if (sofar + bvec->bv_len > size)
+			bvec->bv_len = size - sofar;
+		if (bvec->bv_len == 0) {
+			bio->bi_vcnt = i;
+			break;
+		}
+		sofar += bvec->bv_len;
+	}
+}
+EXPORT_SYMBOL_GPL(md_trim_bio);
+
 /*
  * We have a system wide 'event count' that is incremented
  * on any 'interesting' event, and readers of /proc/mdstat
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 834e46b..eb11449 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -576,4 +576,5 @@ extern struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 				   mddev_t *mddev);
 extern int mddev_check_plugged(mddev_t *mddev);
+extern void md_trim_bio(struct bio *bio, int offset, int size);
 #endif /* _MD_MD_H */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8db311d..cc3939d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -41,11 +41,7 @@
 #include "bitmap.h"
 
 #define DEBUG 0
-#if DEBUG
-#define PRINTK(x...) printk(x)
-#else
-#define PRINTK(x...)
-#endif
+#define PRINTK(x...) do { if (DEBUG) printk(x); } while (0)
 
 /*
  * Number of guaranteed r1bios in case of extreme VM load:
@@ -177,12 +173,6 @@ static void free_r1bio(r1bio_t *r1_bio)
 {
 	conf_t *conf = r1_bio->mddev->private;
 
-	/*
-	 * Wake up any possible resync thread that waits for the device
-	 * to go idle.
-	 */
-	allow_barrier(conf);
-
 	put_all_bios(conf, r1_bio);
 	mempool_free(r1_bio, conf->r1bio_pool);
 }
@@ -223,6 +213,33 @@ static void reschedule_retry(r1bio_t *r1_bio)
  * operation and are ready to return a success/failure code to the buffer
  * cache layer.
  */
+static void call_bio_endio(r1bio_t *r1_bio)
+{
+	struct bio *bio = r1_bio->master_bio;
+	int done;
+	conf_t *conf = r1_bio->mddev->private;
+
+	if (bio->bi_phys_segments) {
+		unsigned long flags;
+		spin_lock_irqsave(&conf->device_lock, flags);
+		bio->bi_phys_segments--;
+		done = (bio->bi_phys_segments == 0);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+	} else
+		done = 1;
+
+	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	if (done) {
+		bio_endio(bio, 0);
+		/*
+		 * Wake up any possible resync thread that waits for the device
+		 * to go idle.
+		 */
+		allow_barrier(conf);
+	}
+}
+
 static void raid_end_bio_io(r1bio_t *r1_bio)
 {
 	struct bio *bio = r1_bio->master_bio;
@@ -235,8 +252,7 @@ static void raid_end_bio_io(r1bio_t *r1_bio)
 			(unsigned long long) bio->bi_sector +
 				(bio->bi_size >> 9) - 1);
 
-		bio_endio(bio,
-			test_bit(R1BIO_Uptodate, &r1_bio->state) ? 0 : -EIO);
+		call_bio_endio(r1_bio);
 	}
 	free_r1bio(r1_bio);
 }
@@ -295,6 +311,7 @@ static void raid1_end_read_request(struct bio *bio, int error)
 			bdevname(conf->mirrors[mirror].rdev->bdev,
 				 b),
 			(unsigned long long)r1_bio->sector);
+		set_bit(R1BIO_ReadError, &r1_bio->state);
 		reschedule_retry(r1_bio);
 	}
 
@@ -381,7 +398,7 @@ static void raid1_end_write_request(struct bio *bio, int error)
 				       (unsigned long long) mbio->bi_sector,
 				       (unsigned long long) mbio->bi_sector +
 				       (mbio->bi_size >> 9) - 1);
-				bio_endio(mbio, 0);
+				call_bio_endio(r1_bio);
 			}
 		}
 	}
@@ -412,10 +429,11 @@ static void raid1_end_write_request(struct bio *bio, int error)
  *
  * The rdev for the device selected will have nr_pending incremented.
  */
-static int read_balance(conf_t *conf, r1bio_t *r1_bio)
+static int read_balance(conf_t *conf, r1bio_t *r1_bio, int *max_sectors)
 {
 	const sector_t this_sector = r1_bio->sector;
-	const int sectors = r1_bio->sectors;
+	int sectors;
+	int best_good_sectors;
 	int start_disk;
 	int best_disk;
 	int i;
@@ -430,8 +448,11 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 	 * We take the first readable disk when above the resync window.
 	 */
  retry:
+	sectors = r1_bio->sectors;
 	best_disk = -1;
 	best_dist = MaxSector;
+	best_good_sectors = 0;
+
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync)) {
 		choose_first = 1;
@@ -443,6 +464,9 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 
 	for (i = 0 ; i < conf->raid_disks ; i++) {
 		sector_t dist;
+		sector_t first_bad;
+		int bad_sectors;
+
 		int disk = start_disk + i;
 		if (disk >= conf->raid_disks)
 			disk -= conf->raid_disks;
@@ -465,6 +489,35 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 		/* This is a reasonable device to use.  It might
 		 * even be best.
 		 */
+		if (is_badblock(rdev, this_sector, sectors,
+				&first_bad, &bad_sectors)) {
+			if (best_dist < MaxSector)
+				/* already have a better device */
+				continue;
+			if (first_bad <= this_sector) {
+				/* cannot read here. If this is the 'primary'
+				 * device, then we must not read beyond
+				 * bad_sectors from another device..
+				 */
+				bad_sectors -= (this_sector - first_bad);
+				if (choose_first && sectors > bad_sectors)
+					sectors = bad_sectors;
+				if (best_good_sectors > sectors)
+					best_good_sectors = sectors;
+
+			} else {
+				sector_t good_sectors = first_bad - this_sector;
+				if (good_sectors > best_good_sectors) {
+					best_good_sectors = good_sectors;
+					best_disk = disk;
+				}
+				if (choose_first)
+					break;
+			}
+			continue;
+		} else
+			best_good_sectors = sectors;
+
 		dist = abs(this_sector - conf->mirrors[disk].head_position);
 		if (choose_first
 		    /* Don't change to another disk for sequential reads */
@@ -493,10 +546,12 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 			rdev_dec_pending(rdev, conf->mddev);
 			goto retry;
 		}
+		sectors = best_good_sectors;
 		conf->next_seq_sect = this_sector + sectors;
 		conf->last_used = best_disk;
 	}
 	rcu_read_unlock();
+	*max_sectors = sectors;
 
 	return best_disk;
 }
@@ -763,11 +818,25 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	r1_bio->mddev = mddev;
 	r1_bio->sector = bio->bi_sector;
 
+	/* We might need to issue multiple reads to different
+	 * devices if there are bad blocks around, so we keep
+	 * track of the number of reads in bio->bi_phys_segments.
+	 * If this is 0, there is only one r1_bio and no locking
+	 * will be needed when requests complete.  If it is
+	 * non-zero, then it is the number of not-completed requests.
+	 */
+	bio->bi_phys_segments = 0;
+	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
+
 	if (rw == READ) {
 		/*
 		 * read balancing logic:
 		 */
-		int rdisk = read_balance(conf, r1_bio);
+		int max_sectors;
+		int rdisk;
+
+read_again:
+		rdisk = read_balance(conf, r1_bio, &max_sectors);
 
 		if (rdisk < 0) {
 			/* couldn't find anywhere to read from */
@@ -788,6 +857,8 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		r1_bio->read_disk = rdisk;
 
 		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+		md_trim_bio(read_bio, r1_bio->sector - bio->bi_sector,
+			    max_sectors);
 
 		r1_bio->bios[rdisk] = read_bio;
 
@@ -797,7 +868,38 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		read_bio->bi_rw = READ | do_sync;
 		read_bio->bi_private = r1_bio;
 
-		generic_make_request(read_bio);
+		if (max_sectors < r1_bio->sectors) {
+			/* could not read all from this device, so we will
+			 * need another r1_bio.
+			 */
+			int sectors_handled;
+
+			sectors_handled = (r1_bio->sector + max_sectors
+					   - bio->bi_sector);
+			r1_bio->sectors = max_sectors;
+			spin_lock_irq(&conf->device_lock);
+			if (bio->bi_phys_segments == 0)
+				bio->bi_phys_segments = 2;
+			else
+				bio->bi_phys_segments++;
+			spin_unlock_irq(&conf->device_lock);
+			/* Cannot call generic_make_request directly
+			 * as that will be queued in __make_request
+			 * and subsequent mempool_alloc might block waiting
+			 * for it.  So hand bio over to raid1d.
+			 */
+			reschedule_retry(r1_bio);
+
+			r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
+
+			r1_bio->master_bio = bio;
+			r1_bio->sectors = (bio->bi_size >> 9) - sectors_handled;
+			r1_bio->state = 0;
+			r1_bio->mddev = mddev;
+			r1_bio->sector = bio->bi_sector + sectors_handled;
+			goto read_again;
+		} else
+			generic_make_request(read_bio);
 		return 0;
 	}
 
@@ -849,8 +951,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		goto retry_write;
 	}
 
-	BUG_ON(targets == 0); /* we never fail the last device */
-
 	if (targets < conf->raid_disks) {
 		/* array is degraded, we will not clear the bitmap
 		 * on I/O completion (see raid1_end_write_request) */
@@ -1425,7 +1525,7 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
  *
  *	1.	Retries failed read operations on working mirrors.
  *	2.	Updates the raid superblock when problems encounter.
- *	3.	Performs writes following reads for array syncronising.
+ *	3.	Performs writes following reads for array synchronising.
  */
 
 static void fix_read_error(conf_t *conf, int read_disk,
@@ -1448,9 +1548,14 @@ static void fix_read_error(conf_t *conf, int read_disk,
 			 * which is the thread that might remove
 			 * a device.  If raid1d ever becomes multi-threaded....
 			 */
+			sector_t first_bad;
+			int bad_sectors;
+
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags) &&
+			    is_badblock(rdev, sect, s,
+					&first_bad, &bad_sectors) == 0 &&
 			    sync_page_io(rdev, sect, s<<9,
 					 conf->tmppage, READ, false))
 				success = 1;
@@ -1546,9 +1651,11 @@ static void raid1d(mddev_t *mddev)
 		conf = mddev->private;
 		if (test_bit(R1BIO_IsSync, &r1_bio->state))
 			sync_request_write(mddev, r1_bio);
-		else {
+		else if (test_bit(R1BIO_ReadError, &r1_bio->state)) {
 			int disk;
+			int max_sectors;
 
+			clear_bit(R1BIO_ReadError, &r1_bio->state);
 			/* we got a read error. Maybe the drive is bad.  Maybe just
 			 * the block and we can fix it.
 			 * We freeze all other IO, and try reading the block from
@@ -1568,21 +1675,28 @@ static void raid1d(mddev_t *mddev)
 					 conf->mirrors[r1_bio->read_disk].rdev);
 
 			bio = r1_bio->bios[r1_bio->read_disk];
-			if ((disk=read_balance(conf, r1_bio)) == -1) {
+			bdevname(bio->bi_bdev, b);
+read_more:
+			disk = read_balance(conf, r1_bio, &max_sectors);
+			if (disk == -1) {
 				printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O"
 				       " read error for block %llu\n",
-				       mdname(mddev),
-				       bdevname(bio->bi_bdev,b),
+				       mdname(mddev), b,
 				       (unsigned long long)r1_bio->sector);
 				raid_end_bio_io(r1_bio);
 			} else {
 				const unsigned long do_sync = r1_bio->master_bio->bi_rw & REQ_SYNC;
-				r1_bio->bios[r1_bio->read_disk] =
-					mddev->ro ? IO_BLOCKED : NULL;
+				if (bio) {
+					r1_bio->bios[r1_bio->read_disk] =
+						mddev->ro ? IO_BLOCKED : NULL;
+					bio_put(bio);
+				}
 				r1_bio->read_disk = disk;
-				bio_put(bio);
 				bio = bio_clone_mddev(r1_bio->master_bio,
 						      GFP_NOIO, mddev);
+				md_trim_bio(bio,
+					    r1_bio->sector - bio->bi_sector,
+					    max_sectors);
 				r1_bio->bios[r1_bio->read_disk] = bio;
 				rdev = conf->mirrors[disk].rdev;
 				printk_ratelimited(
@@ -1597,8 +1711,44 @@ static void raid1d(mddev_t *mddev)
 				bio->bi_end_io = raid1_end_read_request;
 				bio->bi_rw = READ | do_sync;
 				bio->bi_private = r1_bio;
-				generic_make_request(bio);
+				if (max_sectors < r1_bio->sectors) {
+					/* Drat - have to split this up more */
+					struct bio *mbio = r1_bio->master_bio;
+					int sectors_handled =
+						r1_bio->sector + max_sectors
+						- mbio->bi_sector;
+					r1_bio->sectors = max_sectors;
+					spin_lock_irq(&conf->device_lock);
+					if (mbio->bi_phys_segments == 0)
+						mbio->bi_phys_segments = 2;
+					else
+						mbio->bi_phys_segments++;
+					spin_unlock_irq(&conf->device_lock);
+					generic_make_request(bio);
+					bio = NULL;
+
+					r1_bio = mempool_alloc(conf->r1bio_pool,
+							       GFP_NOIO);
+
+					r1_bio->master_bio = mbio;
+					r1_bio->sectors = (mbio->bi_size >> 9)
+						- sectors_handled;
+					r1_bio->state = 0;
+					set_bit(R1BIO_ReadError,
+						&r1_bio->state);
+					r1_bio->mddev = mddev;
+					r1_bio->sector = mbio->bi_sector
+						+ sectors_handled;
+
+					goto read_more;
+				} else
+					generic_make_request(bio);
 			}
+		} else {
+			/* just a partial read to be scheduled from separate
+			 * context
+			 */
+			generic_make_request(r1_bio->bios[r1_bio->read_disk]);
 		}
 		cond_resched();
 	}
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 3cd18cf..aa6af37 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -123,6 +123,10 @@ struct r1bio_s {
 #define	R1BIO_IsSync	1
 #define	R1BIO_Degraded	2
 #define	R1BIO_BehindIO	3
+/* Set ReadError on bios that experience a readerror so that
+ * raid1d knows what to do with them.
+ */
+#define R1BIO_ReadError 4
 /* For write-behind requests, we call bi_end_io when
  * the last non-write-behind device completes, providing
  * any write was successful.  Otherwise we call when


