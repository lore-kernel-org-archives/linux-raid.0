From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 35/36] md/raid10: Handle read errors during recovery better.
Date: Thu, 21 Jul 2011 12:58:51 +1000
Message-ID: <20110721025850.8422.98840.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Currently when we get a read error during recovery, we simply abort
the recovery.

Instead, repeat the read in page-sized blocks.
On successful reads, write to the target.
On read errors, record a bad block on the destination,
and only if that fails do we abort the recovery.

As we now retry reads we need to know where we read from.  This was in
bi_sector but that can be changed during a read attempt.
So store the correct from_addr and to_addr in the r10_bio for later
access.


Signed-off-by: NeilBrown<neilb@suse.de>
---

 drivers/md/raid10.c |  154 ++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 121 insertions(+), 33 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f87c8d9..b02e384 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1141,7 +1141,7 @@ retry_write:
 	wake_up(&conf->wait_barrier);
 
 	if (sectors_handled < (bio->bi_size >> 9)) {
-		/* We need another r1_bio.  It has already been counted
+		/* We need another r10_bio.  It has already been counted
 		 * in bio->bi_phys_segments.
 		 */
 		r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
@@ -1438,29 +1438,10 @@ static void end_sync_read(struct bio *bio, int error)
 	}
 }
 
-static void end_sync_write(struct bio *bio, int error)
+static void end_sync_request(r10bio_t *r10_bio)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r10bio_t *r10_bio = bio->bi_private;
 	mddev_t *mddev = r10_bio->mddev;
-	conf_t *conf = mddev->private;
-	int d;
-	sector_t first_bad;
-	int bad_sectors;
-	int slot;
-
-	d = find_bio_disk(conf, r10_bio, bio, &slot);
-
-	if (!uptodate) {
-		set_bit(WriteErrorSeen, &conf->mirrors[d].rdev->flags);
-		set_bit(R10BIO_WriteError, &r10_bio->state);
-	} else if (is_badblock(conf->mirrors[d].rdev,
-			     r10_bio->devs[slot].addr,
-			     r10_bio->sectors,
-			     &first_bad, &bad_sectors))
-		set_bit(R10BIO_MadeGood, &r10_bio->state);
 
-	rdev_dec_pending(conf->mirrors[d].rdev, mddev);
 	while (atomic_dec_and_test(&r10_bio->remaining)) {
 		if (r10_bio->master_bio == NULL) {
 			/* the primary of several recovery bios */
@@ -1484,6 +1465,33 @@ static void end_sync_write(struct bio *bio, int error)
 	}
 }
 
+static void end_sync_write(struct bio *bio, int error)
+{
+	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	r10bio_t *r10_bio = bio->bi_private;
+	mddev_t *mddev = r10_bio->mddev;
+	conf_t *conf = mddev->private;
+	int d;
+	sector_t first_bad;
+	int bad_sectors;
+	int slot;
+
+	d = find_bio_disk(conf, r10_bio, bio, &slot);
+
+	if (!uptodate) {
+		set_bit(WriteErrorSeen, &conf->mirrors[d].rdev->flags);
+		set_bit(R10BIO_WriteError, &r10_bio->state);
+	} else if (is_badblock(conf->mirrors[d].rdev,
+			     r10_bio->devs[slot].addr,
+			     r10_bio->sectors,
+			     &first_bad, &bad_sectors))
+		set_bit(R10BIO_MadeGood, &r10_bio->state);
+
+	rdev_dec_pending(conf->mirrors[d].rdev, mddev);
+
+	end_sync_request(r10_bio);
+}
+
 /*
  * Note: sync and recover and handled very differently for raid10
  * This code is for resync.
@@ -1600,6 +1608,84 @@ done:
  * The second for writing.
  *
  */
+static void fix_recovery_read_error(r10bio_t *r10_bio)
+{
+	/* We got a read error during recovery.
+	 * We repeat the read in smaller page-sized sections.
+	 * If a read succeeds, write it to the new device or record
+	 * a bad block if we cannot.
+	 * If a read fails, record a bad block on both old and
+	 * new devices.
+	 */
+	mddev_t *mddev = r10_bio->mddev;
+	conf_t *conf = mddev->private;
+	struct bio *bio = r10_bio->devs[0].bio;
+	sector_t sect = 0;
+	int sectors = r10_bio->sectors;
+	int idx = 0;
+	int dr = r10_bio->devs[0].devnum;
+	int dw = r10_bio->devs[1].devnum;
+
+	while (sectors) {
+		int s = sectors;
+		mdk_rdev_t *rdev;
+		sector_t addr;
+		int ok;
+
+		if (s > (PAGE_SIZE>>9))
+			s = PAGE_SIZE >> 9;
+
+		rdev = conf->mirrors[dr].rdev;
+		addr = r10_bio->devs[0].addr + sect,
+		ok = sync_page_io(rdev,
+				  addr,
+				  s << 9,
+				  bio->bi_io_vec[idx].bv_page,
+				  READ, false);
+		if (ok) {
+			rdev = conf->mirrors[dw].rdev;
+			addr = r10_bio->devs[1].addr + sect;
+			ok = sync_page_io(rdev,
+					  addr,
+					  s << 9,
+					  bio->bi_io_vec[idx].bv_page,
+					  WRITE, false);
+			if (!ok)
+				set_bit(WriteErrorSeen, &rdev->flags);
+		}
+		if (!ok) {
+			/* We don't worry if we cannot set a bad block -
+			 * it really is bad so there is no loss in not
+			 * recording it yet
+			 */
+			rdev_set_badblocks(rdev, addr, s, 0);
+
+			if (rdev != conf->mirrors[dw].rdev) {
+				/* need bad block on destination too */
+				mdk_rdev_t *rdev2 = conf->mirrors[dw].rdev;
+				addr = r10_bio->devs[1].addr + sect;
+				ok = rdev_set_badblocks(rdev2, addr, s, 0);
+				if (!ok) {
+					/* just abort the recovery */
+					printk(KERN_NOTICE
+					       "md/raid10:%s: recovery aborted"
+					       " due to read error\n",
+					       mdname(mddev));
+
+					conf->mirrors[dw].recovery_disabled
+						= mddev->recovery_disabled;
+					set_bit(MD_RECOVERY_INTR,
+						&mddev->recovery);
+					break;
+				}
+			}
+		}
+
+		sectors -= s;
+		sect += s;
+		idx++;
+	}
+}
 
 static void recovery_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 {
@@ -1607,6 +1693,12 @@ static void recovery_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 	int d;
 	struct bio *wbio;
 
+	if (!test_bit(R10BIO_Uptodate, &r10_bio->state)) {
+		fix_recovery_read_error(r10_bio);
+		end_sync_request(r10_bio);
+		return;
+	}
+
 	/*
 	 * share the pages with the first bio
 	 * and submit the write request
@@ -1616,16 +1708,7 @@ static void recovery_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 
 	atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 	md_sync_acct(conf->mirrors[d].rdev->bdev, wbio->bi_size >> 9);
-	if (test_bit(R10BIO_Uptodate, &r10_bio->state))
-		generic_make_request(wbio);
-	else {
-		printk(KERN_NOTICE
-		       "md/raid10:%s: recovery aborted due to read error\n",
-		       mdname(mddev));
-		conf->mirrors[d].recovery_disabled = mddev->recovery_disabled;
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		bio_endio(wbio, 0);
-	}
+	generic_make_request(wbio);
 }
 
 
@@ -2339,6 +2422,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 			for (j=0; j<conf->copies;j++) {
 				int k;
 				int d = r10_bio->devs[j].devnum;
+				sector_t from_addr, to_addr;
 				mdk_rdev_t *rdev;
 				sector_t sector, first_bad;
 				int bad_sectors;
@@ -2368,7 +2452,8 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_read;
 				bio->bi_rw = READ;
-				bio->bi_sector = r10_bio->devs[j].addr +
+				from_addr = r10_bio->devs[j].addr;
+				bio->bi_sector = from_addr +
 					conf->mirrors[d].rdev->data_offset;
 				bio->bi_bdev = conf->mirrors[d].rdev->bdev;
 				atomic_inc(&conf->mirrors[d].rdev->nr_pending);
@@ -2385,12 +2470,15 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_write;
 				bio->bi_rw = WRITE;
-				bio->bi_sector = r10_bio->devs[k].addr +
+				to_addr = r10_bio->devs[k].addr;
+				bio->bi_sector = to_addr +
 					conf->mirrors[i].rdev->data_offset;
 				bio->bi_bdev = conf->mirrors[i].rdev->bdev;
 
 				r10_bio->devs[0].devnum = d;
+				r10_bio->devs[0].addr = from_addr;
 				r10_bio->devs[1].devnum = i;
+				r10_bio->devs[1].addr = to_addr;
 
 				break;
 			}


