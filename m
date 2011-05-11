From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/16] md/raid1: tidy up new functions: process_checks and
 fix_sync_read_error.
Date: Wed, 11 May 2011 16:30:31 +1000
Message-ID: <20110511063031.21263.50682.stgit@notabene.brown>
References: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511062743.21263.72802.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

These changes are mostly cosmetic:

1/ change mddev->raid_disks to conf->raid_disks because the later is
   technically safer, though in current practice it doesn't matter in
   this particular context.
2/ Rearrange two for / if loops to have an early 'continue' so the
   body of the 'if' doesn't need to be indented so much.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |  184 +++++++++++++++++++++++++++-------------------------
 1 files changed, 95 insertions(+), 89 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7fd7a4d..2b9e86c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1203,6 +1203,7 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 		int d = r1_bio->read_disk;
 		int success = 0;
 		mdk_rdev_t *rdev;
+		int start;
 
 		if (s > (PAGE_SIZE>>9))
 			s = PAGE_SIZE >> 9;
@@ -1227,41 +1228,7 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 				d = 0;
 		} while (!success && d != r1_bio->read_disk);
 
-		if (success) {
-			int start = d;
-			/* write it back and re-read */
-			set_bit(R1BIO_Uptodate, &r1_bio->state);
-			while (d != r1_bio->read_disk) {
-				if (d == 0)
-					d = conf->raid_disks;
-				d--;
-				if (r1_bio->bios[d]->bi_end_io != end_sync_read)
-					continue;
-				rdev = conf->mirrors[d].rdev;
-				atomic_add(s, &rdev->corrected_errors);
-				if (sync_page_io(rdev,
-						 sect,
-						 s<<9,
-						 bio->bi_io_vec[idx].bv_page,
-						 WRITE, false) == 0)
-					md_error(mddev, rdev);
-			}
-			d = start;
-			while (d != r1_bio->read_disk) {
-				if (d == 0)
-					d = conf->raid_disks;
-				d--;
-				if (r1_bio->bios[d]->bi_end_io != end_sync_read)
-					continue;
-				rdev = conf->mirrors[d].rdev;
-				if (sync_page_io(rdev,
-						 sect,
-						 s<<9,
-						 bio->bi_io_vec[idx].bv_page,
-						 READ, false) == 0)
-					md_error(mddev, rdev);
-			}
-		} else {
+		if (!success) {
 			char b[BDEVNAME_SIZE];
 			/* Cannot read from anywhere, array is toast */
 			md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
@@ -1274,10 +1241,47 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 			put_buf(r1_bio);
 			return 0;
 		}
+
+		start = d;
+		/* write it back and re-read */
+		while (d != r1_bio->read_disk) {
+			if (d == 0)
+				d = conf->raid_disks;
+			d--;
+			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
+				continue;
+			rdev = conf->mirrors[d].rdev;
+			if (sync_page_io(rdev,
+					 sect,
+					 s<<9,
+					 bio->bi_io_vec[idx].bv_page,
+					 WRITE, false) == 0) {
+				r1_bio->bios[d]->bi_end_io = NULL;
+				rdev_dec_pending(rdev, mddev);
+				md_error(mddev, rdev);
+			} else
+				atomic_add(s, &rdev->corrected_errors);
+		}
+		d = start;
+		while (d != r1_bio->read_disk) {
+			if (d == 0)
+				d = conf->raid_disks;
+			d--;
+			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
+				continue;
+			rdev = conf->mirrors[d].rdev;
+			if (sync_page_io(rdev,
+					 sect,
+					 s<<9,
+					 bio->bi_io_vec[idx].bv_page,
+					 READ, false) == 0)
+				md_error(mddev, rdev);
+		}
 		sectors -= s;
 		sect += s;
 		idx ++;
 	}
+	set_bit(R1BIO_Uptodate, &r1_bio->state);
 	return 1;
 }
 
@@ -1296,7 +1300,7 @@ static int process_checks(r1bio_t *r1_bio)
 	int i;
 
 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
-		for (i=0; i<mddev->raid_disks; i++)
+		for (i=0; i < conf->raid_disks; i++)
 			if (r1_bio->bios[i]->bi_end_io == end_sync_read)
 				md_error(mddev, conf->mirrors[i].rdev);
 
@@ -1304,7 +1308,7 @@ static int process_checks(r1bio_t *r1_bio)
 		put_buf(r1_bio);
 		return -1;
 	}
-	for (primary=0; primary<mddev->raid_disks; primary++)
+	for (primary = 0; primary < conf->raid_disks; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
 		    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
 			r1_bio->bios[primary]->bi_end_io = NULL;
@@ -1312,61 +1316,63 @@ static int process_checks(r1bio_t *r1_bio)
 			break;
 		}
 	r1_bio->read_disk = primary;
-	for (i=0; i<mddev->raid_disks; i++)
-		if (r1_bio->bios[i]->bi_end_io == end_sync_read) {
-			int j;
-			int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
-			struct bio *pbio = r1_bio->bios[primary];
-			struct bio *sbio = r1_bio->bios[i];
-
-			if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
-				for (j = vcnt; j-- ; ) {
-					struct page *p, *s;
-					p = pbio->bi_io_vec[j].bv_page;
-					s = sbio->bi_io_vec[j].bv_page;
-					if (memcmp(page_address(p),
-						   page_address(s),
-						   PAGE_SIZE))
-						break;
-				}
-			} else
-				j = 0;
-			if (j >= 0)
-				mddev->resync_mismatches += r1_bio->sectors;
-			if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
-				      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
-				sbio->bi_end_io = NULL;
-				rdev_dec_pending(conf->mirrors[i].rdev, mddev);
-			} else {
-				/* fixup the bio for reuse */
-				int size;
-				sbio->bi_vcnt = vcnt;
-				sbio->bi_size = r1_bio->sectors << 9;
-				sbio->bi_idx = 0;
-				sbio->bi_phys_segments = 0;
-				sbio->bi_flags &= ~(BIO_POOL_MASK - 1);
-				sbio->bi_flags |= 1 << BIO_UPTODATE;
-				sbio->bi_next = NULL;
-				sbio->bi_sector = r1_bio->sector +
-					conf->mirrors[i].rdev->data_offset;
-				sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-				size = sbio->bi_size;
-				for (j = 0; j < vcnt ; j++) {
-					struct bio_vec *bi;
-					bi = &sbio->bi_io_vec[j];
-					bi->bv_offset = 0;
-					if (size > PAGE_SIZE)
-						bi->bv_len = PAGE_SIZE;
-					else
-						bi->bv_len = size;
-					size -= PAGE_SIZE;
-					memcpy(page_address(bi->bv_page),
-					       page_address(pbio->bi_io_vec[j].bv_page),
-					       PAGE_SIZE);
-				}
+	for (i = 0; i < conf->raid_disks; i++) {
+		int j;
+		int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
+		struct bio *pbio = r1_bio->bios[primary];
+		struct bio *sbio = r1_bio->bios[i];
+		int size;
+
+		if (r1_bio->bios[i]->bi_end_io != end_sync_read)
+			continue;
 
+		if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
+			for (j = vcnt; j-- ; ) {
+				struct page *p, *s;
+				p = pbio->bi_io_vec[j].bv_page;
+				s = sbio->bi_io_vec[j].bv_page;
+				if (memcmp(page_address(p),
+					   page_address(s),
+					   PAGE_SIZE))
+					break;
 			}
+		} else
+			j = 0;
+		if (j >= 0)
+			mddev->resync_mismatches += r1_bio->sectors;
+		if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
+			      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
+			/* No need to write to this device. */
+			sbio->bi_end_io = NULL;
+			rdev_dec_pending(conf->mirrors[i].rdev, mddev);
+			continue;
 		}
+		/* fixup the bio for reuse */
+		sbio->bi_vcnt = vcnt;
+		sbio->bi_size = r1_bio->sectors << 9;
+		sbio->bi_idx = 0;
+		sbio->bi_phys_segments = 0;
+		sbio->bi_flags &= ~(BIO_POOL_MASK - 1);
+		sbio->bi_flags |= 1 << BIO_UPTODATE;
+		sbio->bi_next = NULL;
+		sbio->bi_sector = r1_bio->sector +
+			conf->mirrors[i].rdev->data_offset;
+		sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+		size = sbio->bi_size;
+		for (j = 0; j < vcnt ; j++) {
+			struct bio_vec *bi;
+			bi = &sbio->bi_io_vec[j];
+			bi->bv_offset = 0;
+			if (size > PAGE_SIZE)
+				bi->bv_len = PAGE_SIZE;
+			else
+				bi->bv_len = size;
+			size -= PAGE_SIZE;
+			memcpy(page_address(bi->bv_page),
+			       page_address(pbio->bi_io_vec[j].bv_page),
+			       PAGE_SIZE);
+		}
+	}
 	return 0;
 }
 


