From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/16] md/raid1: avoid reading from known bad blocks.
Date: Mon, 07 Jun 2010 10:07:55 +1000
Message-ID: <20100607000754.13302.86073.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
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
     per bio.
  4/ retrying a read needs to also be ready to submit a smaller read
     and queue another request for the rest.

This does not yet handle bad blocks when reading to perform resync,
recovery, or check.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |  176 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 167 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fa62c7b..a5a3f01 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -237,14 +237,28 @@ static void raid_end_bio_io(r1bio_t *r1_bio)
 
 	/* if nobody has done the final endio yet, do it now */
 	if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
+		int done;
+
 		PRINTK(KERN_DEBUG "raid1: sync end %s on sectors %llu-%llu\n",
 			(bio_data_dir(bio) == WRITE) ? "write" : "read",
 			(unsigned long long) bio->bi_sector,
 			(unsigned long long) bio->bi_sector +
 				(bio->bi_size >> 9) - 1);
 
-		bio_endio(bio,
-			test_bit(R1BIO_Uptodate, &r1_bio->state) ? 0 : -EIO);
+		if (bio->bi_phys_segments) {
+			unsigned long flags;
+			conf_t *conf = r1_bio->mddev->private;
+			spin_lock_irqsave(&conf->device_lock, flags);
+			bio->bi_phys_segments--;
+			done = (bio->bi_phys_segments == 0);
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+		} else
+			done = 1;
+
+		if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
+			clear_bit(BIO_UPTODATE, &bio->bi_flags);
+		if (done)
+			bio_endio(bio, 0);
 	}
 	free_r1bio(r1_bio);
 }
@@ -417,10 +431,11 @@ static void raid1_end_write_request(struct bio *bio, int error)
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
 	int do_balance;
 	int disk;
 	int start_disk;
@@ -436,9 +451,12 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 	 * We take the first readable disk when above the resync window.
 	 */
  retry:
+	sectors = r1_bio->sectors;
 	disk = -1;
 	best_disk = -1;
 	best_dist = MaxSector;
+	best_good_sectors = 0;
+
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync)) {
 		/* just choose the first */
@@ -451,6 +469,8 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 	}
 	for (i = 0; i < conf->raid_disks; i++) {
 		sector_t dist;
+		sector_t first_bad;
+		int bad_sectors;
 
 		disk = (start_disk + i) % conf->raid_disks;
 		if (r1_bio->bios[disk] == IO_BLOCKED)
@@ -474,6 +494,30 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
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
+				if (!do_balance && sectors > bad_sectors)
+					sectors = bad_sectors;
+			} else {
+				sector_t good_sectors = first_bad - this_sector;
+				if (good_sectors > best_good_sectors) {
+					best_good_sectors = good_sectors;
+					best_disk = disk;
+				}
+			}
+			continue;
+		} else
+			best_good_sectors = sectors;
+
 		if (!do_balance)
 			break;
 
@@ -513,6 +557,7 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 		conf->last_used = disk;
 	}
 	rcu_read_unlock();
+	*max_sectors = sectors;
 
 	return disk;
 }
@@ -751,6 +796,38 @@ do_sync_io:
 	return NULL;
 }
 
+static void trim_bio(struct bio *bio, int offset, int size)
+{
+	/* 'bio' is a cloned bio which we need to trim to match
+	 * the given offset and size.
+	 * This requires adjusting bi_sector, bi_size, and bi_io_vec
+	 */
+	if (offset == 0 && (size << 9) == bio->bi_size)
+		return;
+
+	bio->bi_sector += offset;
+	bio->bi_size = size << 9;
+	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
+
+	while (bio->bi_idx < bio->bi_vcnt &&
+	       bio->bi_io_vec[bio->bi_idx].bv_len < (offset << 9)) {
+		/* remove this whole bio_vec */
+		offset -= bio->bi_io_vec[bio->bi_idx].bv_len >> 9;
+		bio->bi_idx++;
+	}
+	if (bio->bi_idx < bio->bi_vcnt) {
+		bio->bi_io_vec[bio->bi_idx].bv_offset += (offset << 9);
+		bio->bi_io_vec[bio->bi_idx].bv_len -= (offset << 9);
+	}
+	/* avoid any complications with bi_idx being non-zero*/
+	if (bio->bi_idx) {
+		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_idx,
+			(bio->bi_vcnt - bio->bi_idx) * sizeof(struct bio_vec));
+		bio->bi_vcnt -= bio->bi_idx;
+		bio->bi_idx = 0;
+	}
+}
+
 static int make_request(mddev_t *mddev, struct bio * bio)
 {
 	conf_t *conf = mddev->private;
@@ -822,11 +899,26 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	r1_bio->mddev = mddev;
 	r1_bio->sector = bio->bi_sector;
 
+	/* We might need to issue multiple reads to different
+	 * devices if there are bad blocks around, so we keep
+	 * track of the number of reads in bio->bi_phys_segments.
+	 * If this is 0, then is only one r1_bio, and no locking is
+	 * needed to increment it.
+	 * If it is non-zero, that is the number of incomplete
+	 * requests.
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
+	read_again:
+		rdisk = read_balance(conf, r1_bio, &max_sectors);
 
 		if (rdisk < 0) {
 			/* couldn't find anywhere to read from */
@@ -847,6 +939,8 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		r1_bio->read_disk = rdisk;
 
 		read_bio = bio_clone(bio, GFP_NOIO);
+		trim_bio(read_bio, r1_bio->sector - bio->bi_sector,
+			 max_sectors);
 
 		r1_bio->bios[rdisk] = read_bio;
 
@@ -856,7 +950,33 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		read_bio->bi_rw = READ | (do_sync << BIO_RW_SYNCIO);
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
+			generic_make_request(read_bio);
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
 
@@ -1487,7 +1607,7 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
  *
  *	1.	Retries failed read operations on working mirrors.
  *	2.	Updates the raid superblock when problems encounter.
- *	3.	Performs writes following reads for array syncronising.
+ *	3.	Performs writes following reads for array synchronising.
  */
 
 static void fix_read_error(conf_t *conf, int read_disk,
@@ -1510,9 +1630,14 @@ static void fix_read_error(conf_t *conf, int read_disk,
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
 			    sync_page_io(rdev->bdev,
 					 sect + rdev->data_offset,
 					 s<<9,
@@ -1649,6 +1774,7 @@ static void raid1d(mddev_t *mddev)
 				}
 		} else {
 			int disk;
+			int max_sectors;
 
 			/* we got a read error. Maybe the drive is bad.  Maybe just
 			 * the block and we can fix it.
@@ -1669,7 +1795,8 @@ static void raid1d(mddev_t *mddev)
 					 conf->mirrors[r1_bio->read_disk].rdev);
 
 			bio = r1_bio->bios[r1_bio->read_disk];
-			if ((disk=read_balance(conf, r1_bio)) == -1) {
+			disk = read_balance(conf, r1_bio, &max_sectors);
+			if (disk == -1) {
 				printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O"
 				       " read error for block %llu\n",
 				       mdname(mddev),
@@ -1683,6 +1810,8 @@ static void raid1d(mddev_t *mddev)
 				r1_bio->read_disk = disk;
 				bio_put(bio);
 				bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
+				trim_bio(bio, r1_bio->sector - bio->bi_sector,
+					 max_sectors);
 				r1_bio->bios[r1_bio->read_disk] = bio;
 				rdev = conf->mirrors[disk].rdev;
 				if (printk_ratelimit())
@@ -1697,7 +1826,36 @@ static void raid1d(mddev_t *mddev)
 				bio->bi_rw = READ | (do_sync << BIO_RW_SYNCIO);
 				bio->bi_private = r1_bio;
 				unplug = 1;
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
+
+					r1_bio = mempool_alloc(conf->r1bio_pool,
+							       GFP_NOIO);
+
+					r1_bio->master_bio = mbio;
+					r1_bio->sectors = (mbio->bi_size >> 9)
+						- sectors_handled;
+					r1_bio->state = 0;
+					r1_bio->mddev = mddev;
+					r1_bio->sector = mbio->bi_sector
+						+ sectors_handled;
+
+					reschedule_retry(r1_bio);
+
+				} else
+					generic_make_request(bio);
 			}
 		}
 		cond_resched();


