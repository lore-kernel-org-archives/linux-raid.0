From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/16] md/raid1: split out two sub-functions from
 sync_request_write
Date: Wed, 11 May 2011 16:30:31 +1000
Message-ID: <20110511063031.21263.30829.stgit@notabene.brown>
References: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511062743.21263.72802.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

sync_request_write is too big and too deep.
So split out two self-contains bits of functionality into separate
function.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |  365 +++++++++++++++++++++++++++-------------------------
 1 files changed, 192 insertions(+), 173 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f0b0c79..7fd7a4d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1181,194 +1181,213 @@ static void end_sync_write(struct bio *bio, int error)
 	}
 }
 
-static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
+static int fix_sync_read_error(r1bio_t *r1_bio)
 {
+	/* Try some synchronous reads of other devices to get
+	 * good data, much like with normal read errors.  Only
+	 * read into the pages we already have so we don't
+	 * need to re-issue the read request.
+	 * We don't need to freeze the array, because being in an
+	 * active sync request, there is no normal IO, and
+	 * no overlapping syncs.
+	 */
+	mddev_t *mddev = r1_bio->mddev;
 	conf_t *conf = mddev->private;
-	int i;
-	int disks = conf->raid_disks;
-	struct bio *bio, *wbio;
+	struct bio *bio = r1_bio->bios[r1_bio->read_disk];
+	sector_t sect = r1_bio->sector;
+	int sectors = r1_bio->sectors;
+	int idx = 0;
 
-	bio = r1_bio->bios[r1_bio->read_disk];
-
-
-	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
-		/* We have read all readable devices.  If we haven't
-		 * got the block, then there is no hope left.
-		 * If we have, then we want to do a comparison
-		 * and skip the write if everything is the same.
-		 * If any blocks failed to read, then we need to
-		 * attempt an over-write
-		 */
-		int primary;
-		if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
-			for (i=0; i<mddev->raid_disks; i++)
-				if (r1_bio->bios[i]->bi_end_io == end_sync_read)
-					md_error(mddev, conf->mirrors[i].rdev);
+	while(sectors) {
+		int s = sectors;
+		int d = r1_bio->read_disk;
+		int success = 0;
+		mdk_rdev_t *rdev;
 
-			md_done_sync(mddev, r1_bio->sectors, 1);
+		if (s > (PAGE_SIZE>>9))
+			s = PAGE_SIZE >> 9;
+		do {
+			if (r1_bio->bios[d]->bi_end_io == end_sync_read) {
+				/* No rcu protection needed here devices
+				 * can only be removed when no resync is
+				 * active, and resync is currently active
+				 */
+				rdev = conf->mirrors[d].rdev;
+				if (sync_page_io(rdev,
+						 sect,
+						 s<<9,
+						 bio->bi_io_vec[idx].bv_page,
+						 READ, false)) {
+					success = 1;
+					break;
+				}
+			}
+			d++;
+			if (d == conf->raid_disks)
+				d = 0;
+		} while (!success && d != r1_bio->read_disk);
+
+		if (success) {
+			int start = d;
+			/* write it back and re-read */
+			set_bit(R1BIO_Uptodate, &r1_bio->state);
+			while (d != r1_bio->read_disk) {
+				if (d == 0)
+					d = conf->raid_disks;
+				d--;
+				if (r1_bio->bios[d]->bi_end_io != end_sync_read)
+					continue;
+				rdev = conf->mirrors[d].rdev;
+				atomic_add(s, &rdev->corrected_errors);
+				if (sync_page_io(rdev,
+						 sect,
+						 s<<9,
+						 bio->bi_io_vec[idx].bv_page,
+						 WRITE, false) == 0)
+					md_error(mddev, rdev);
+			}
+			d = start;
+			while (d != r1_bio->read_disk) {
+				if (d == 0)
+					d = conf->raid_disks;
+				d--;
+				if (r1_bio->bios[d]->bi_end_io != end_sync_read)
+					continue;
+				rdev = conf->mirrors[d].rdev;
+				if (sync_page_io(rdev,
+						 sect,
+						 s<<9,
+						 bio->bi_io_vec[idx].bv_page,
+						 READ, false) == 0)
+					md_error(mddev, rdev);
+			}
+		} else {
+			char b[BDEVNAME_SIZE];
+			/* Cannot read from anywhere, array is toast */
+			md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
+			printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O read error"
+			       " for block %llu\n",
+			       mdname(mddev),
+			       bdevname(bio->bi_bdev, b),
+			       (unsigned long long)r1_bio->sector);
+			md_done_sync(mddev, r1_bio->sectors, 0);
 			put_buf(r1_bio);
-			return;
+			return 0;
 		}
-		for (primary=0; primary<mddev->raid_disks; primary++)
-			if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
-			    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
-				r1_bio->bios[primary]->bi_end_io = NULL;
-				rdev_dec_pending(conf->mirrors[primary].rdev, mddev);
-				break;
-			}
-		r1_bio->read_disk = primary;
+		sectors -= s;
+		sect += s;
+		idx ++;
+	}
+	return 1;
+}
+
+static int process_checks(r1bio_t *r1_bio)
+{
+	/* We have read all readable devices.  If we haven't
+	 * got the block, then there is no hope left.
+	 * If we have, then we want to do a comparison
+	 * and skip the write if everything is the same.
+	 * If any blocks failed to read, then we need to
+	 * attempt an over-write
+	 */
+	mddev_t *mddev = r1_bio->mddev;
+	conf_t *conf = mddev->private;
+	int primary;
+	int i;
+
+	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
 		for (i=0; i<mddev->raid_disks; i++)
-			if (r1_bio->bios[i]->bi_end_io == end_sync_read) {
-				int j;
-				int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
-				struct bio *pbio = r1_bio->bios[primary];
-				struct bio *sbio = r1_bio->bios[i];
-
-				if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
-					for (j = vcnt; j-- ; ) {
-						struct page *p, *s;
-						p = pbio->bi_io_vec[j].bv_page;
-						s = sbio->bi_io_vec[j].bv_page;
-						if (memcmp(page_address(p),
-							   page_address(s),
-							   PAGE_SIZE))
-							break;
-					}
-				} else
-					j = 0;
-				if (j >= 0)
-					mddev->resync_mismatches += r1_bio->sectors;
-				if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
-					      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
-					sbio->bi_end_io = NULL;
-					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
-				} else {
-					/* fixup the bio for reuse */
-					int size;
-					sbio->bi_vcnt = vcnt;
-					sbio->bi_size = r1_bio->sectors << 9;
-					sbio->bi_idx = 0;
-					sbio->bi_phys_segments = 0;
-					sbio->bi_flags &= ~(BIO_POOL_MASK - 1);
-					sbio->bi_flags |= 1 << BIO_UPTODATE;
-					sbio->bi_next = NULL;
-					sbio->bi_sector = r1_bio->sector +
-						conf->mirrors[i].rdev->data_offset;
-					sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-					size = sbio->bi_size;
-					for (j = 0; j < vcnt ; j++) {
-						struct bio_vec *bi;
-						bi = &sbio->bi_io_vec[j];
-						bi->bv_offset = 0;
-						if (size > PAGE_SIZE)
-							bi->bv_len = PAGE_SIZE;
-						else
-							bi->bv_len = size;
-						size -= PAGE_SIZE;
-						memcpy(page_address(bi->bv_page),
-						       page_address(pbio->bi_io_vec[j].bv_page),
-						       PAGE_SIZE);
-					}
+			if (r1_bio->bios[i]->bi_end_io == end_sync_read)
+				md_error(mddev, conf->mirrors[i].rdev);
 
-				}
-			}
+		md_done_sync(mddev, r1_bio->sectors, 1);
+		put_buf(r1_bio);
+		return -1;
 	}
-	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
-		/* ouch - failed to read all of that.
-		 * Try some synchronous reads of other devices to get
-		 * good data, much like with normal read errors.  Only
-		 * read into the pages we already have so we don't
-		 * need to re-issue the read request.
-		 * We don't need to freeze the array, because being in an
-		 * active sync request, there is no normal IO, and
-		 * no overlapping syncs.
-		 */
-		sector_t sect = r1_bio->sector;
-		int sectors = r1_bio->sectors;
-		int idx = 0;
-
-		while(sectors) {
-			int s = sectors;
-			int d = r1_bio->read_disk;
-			int success = 0;
-			mdk_rdev_t *rdev;
-
-			if (s > (PAGE_SIZE>>9))
-				s = PAGE_SIZE >> 9;
-			do {
-				if (r1_bio->bios[d]->bi_end_io == end_sync_read) {
-					/* No rcu protection needed here devices
-					 * can only be removed when no resync is
-					 * active, and resync is currently active
-					 */
-					rdev = conf->mirrors[d].rdev;
-					if (sync_page_io(rdev,
-							 sect,
-							 s<<9,
-							 bio->bi_io_vec[idx].bv_page,
-							 READ, false)) {
-						success = 1;
+	for (primary=0; primary<mddev->raid_disks; primary++)
+		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
+		    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
+			r1_bio->bios[primary]->bi_end_io = NULL;
+			rdev_dec_pending(conf->mirrors[primary].rdev, mddev);
+			break;
+		}
+	r1_bio->read_disk = primary;
+	for (i=0; i<mddev->raid_disks; i++)
+		if (r1_bio->bios[i]->bi_end_io == end_sync_read) {
+			int j;
+			int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
+			struct bio *pbio = r1_bio->bios[primary];
+			struct bio *sbio = r1_bio->bios[i];
+
+			if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
+				for (j = vcnt; j-- ; ) {
+					struct page *p, *s;
+					p = pbio->bi_io_vec[j].bv_page;
+					s = sbio->bi_io_vec[j].bv_page;
+					if (memcmp(page_address(p),
+						   page_address(s),
+						   PAGE_SIZE))
 						break;
-					}
-				}
-				d++;
-				if (d == conf->raid_disks)
-					d = 0;
-			} while (!success && d != r1_bio->read_disk);
-
-			if (success) {
-				int start = d;
-				/* write it back and re-read */
-				set_bit(R1BIO_Uptodate, &r1_bio->state);
-				while (d != r1_bio->read_disk) {
-					if (d == 0)
-						d = conf->raid_disks;
-					d--;
-					if (r1_bio->bios[d]->bi_end_io != end_sync_read)
-						continue;
-					rdev = conf->mirrors[d].rdev;
-					atomic_add(s, &rdev->corrected_errors);
-					if (sync_page_io(rdev,
-							 sect,
-							 s<<9,
-							 bio->bi_io_vec[idx].bv_page,
-							 WRITE, false) == 0)
-						md_error(mddev, rdev);
-				}
-				d = start;
-				while (d != r1_bio->read_disk) {
-					if (d == 0)
-						d = conf->raid_disks;
-					d--;
-					if (r1_bio->bios[d]->bi_end_io != end_sync_read)
-						continue;
-					rdev = conf->mirrors[d].rdev;
-					if (sync_page_io(rdev,
-							 sect,
-							 s<<9,
-							 bio->bi_io_vec[idx].bv_page,
-							 READ, false) == 0)
-						md_error(mddev, rdev);
 				}
+			} else
+				j = 0;
+			if (j >= 0)
+				mddev->resync_mismatches += r1_bio->sectors;
+			if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
+				      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
+				sbio->bi_end_io = NULL;
+				rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 			} else {
-				char b[BDEVNAME_SIZE];
-				/* Cannot read from anywhere, array is toast */
-				md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
-				printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O read error"
-				       " for block %llu\n",
-				       mdname(mddev),
-				       bdevname(bio->bi_bdev, b),
-				       (unsigned long long)r1_bio->sector);
-				md_done_sync(mddev, r1_bio->sectors, 0);
-				put_buf(r1_bio);
-				return;
+				/* fixup the bio for reuse */
+				int size;
+				sbio->bi_vcnt = vcnt;
+				sbio->bi_size = r1_bio->sectors << 9;
+				sbio->bi_idx = 0;
+				sbio->bi_phys_segments = 0;
+				sbio->bi_flags &= ~(BIO_POOL_MASK - 1);
+				sbio->bi_flags |= 1 << BIO_UPTODATE;
+				sbio->bi_next = NULL;
+				sbio->bi_sector = r1_bio->sector +
+					conf->mirrors[i].rdev->data_offset;
+				sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+				size = sbio->bi_size;
+				for (j = 0; j < vcnt ; j++) {
+					struct bio_vec *bi;
+					bi = &sbio->bi_io_vec[j];
+					bi->bv_offset = 0;
+					if (size > PAGE_SIZE)
+						bi->bv_len = PAGE_SIZE;
+					else
+						bi->bv_len = size;
+					size -= PAGE_SIZE;
+					memcpy(page_address(bi->bv_page),
+					       page_address(pbio->bi_io_vec[j].bv_page),
+					       PAGE_SIZE);
+				}
+
 			}
-			sectors -= s;
-			sect += s;
-			idx ++;
 		}
-	}
+	return 0;
+}
+
+static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
+{
+	conf_t *conf = mddev->private;
+	int i;
+	int disks = conf->raid_disks;
+	struct bio *bio, *wbio;
+
+	bio = r1_bio->bios[r1_bio->read_disk];
+
 
+	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		if (process_checks(r1_bio) < 0)
+			return;
+
+	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
+		/* ouch - failed to read all of that. */
+		if (!fix_sync_read_error(r1_bio))
+			return;
 	/*
 	 * schedule writes
 	 */


