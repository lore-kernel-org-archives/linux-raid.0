From: Shaohua Li <shli@kernel.org>
Subject: [RFC 2/2]raid1: use discard if sync data is 0
Date: Thu, 26 Jul 2012 16:02:55 +0800
Message-ID: <20120726080255.GB21457@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

In raid sync, if disks data isn't match and data of source disk is 0, we can
further optimize write for SSD - discard other disks. This will involve extra
memory compare, but discard can improve garbage collection of SSD. This is
disabled by default too.

Block layer doesn't provide async version API to do discard, so currently we do
synchronization discard.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-07-26 10:39:20.250706326 +0800
+++ linux/drivers/md/raid1.c	2012-07-26 14:59:05.186777126 +0800
@@ -1730,7 +1730,7 @@ static int fix_sync_read_error(struct r1
 	return 1;
 }
 
-static int process_checks(struct r1bio *r1_bio)
+static int process_checks(struct r1bio *r1_bio, int *do_discard)
 {
 	/* We have read all readable devices.  If we haven't
 	 * got the block, then there is no hope left.
@@ -1744,7 +1744,9 @@ static int process_checks(struct r1bio *
 	int primary;
 	int i;
 	int vcnt;
+	int check_do_discard = 0;
 
+	*do_discard = 0;
 	for (primary = 0; primary < conf->raid_disks * 2; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
 		    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
@@ -1761,6 +1763,7 @@ static int process_checks(struct r1bio *
 		struct bio *pbio = r1_bio->bios[primary];
 		struct bio *sbio = r1_bio->bios[i];
 		int size;
+		struct request_queue *queue;
 
 		if (sbio->bi_end_io != end_sync_read &&
 		    !(sbio->bi_end_io == end_sync_write &&
@@ -1788,6 +1791,22 @@ static int process_checks(struct r1bio *
 			rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 			continue;
 		}
+		queue = bdev_get_queue(conf->mirrors[i].rdev->bdev);
+		if (j >= 0 && !check_do_discard && blk_queue_discard(queue) &&
+		    queue_discard_zeroes_data(queue) &&
+		    test_bit(MD_RECOVERY_MODE_DISCARD, &mddev->recovery_mode)) {
+			for (j = vcnt; j-- ; ) {
+				struct page *p;
+				p = pbio->bi_io_vec[j].bv_page;
+				if (memcmp(page_address(p),
+				    page_address(ZERO_PAGE(0)),
+				    pbio->bi_io_vec[j].bv_len))
+					break;
+			}
+			if (j < 0)
+				*do_discard = 1;
+			check_do_discard = 1;
+		}
 		/* fixup the bio for reuse */
 		sbio->bi_vcnt = vcnt;
 		sbio->bi_size = r1_bio->sectors << 9;
@@ -1800,6 +1819,8 @@ static int process_checks(struct r1bio *
 			conf->mirrors[i].rdev->data_offset;
 		sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 
+		if (*do_discard)
+			continue;
 		size = sbio->bi_size;
 		for (j = 0; j < vcnt ; j++) {
 			struct bio_vec *bi;
@@ -1824,6 +1845,7 @@ static void sync_request_write(struct md
 	int i;
 	int disks = conf->raid_disks * 2;
 	struct bio *bio, *wbio;
+	int do_discard = 0;
 
 	bio = r1_bio->bios[r1_bio->read_disk];
 
@@ -1834,7 +1856,7 @@ static void sync_request_write(struct md
 
 	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
 	    test_bit(MD_RECOVERY_MODE_REPAIR, &mddev->recovery_mode))
-		if (process_checks(r1_bio) < 0)
+		if (process_checks(r1_bio, &do_discard) < 0)
 			return;
 	/*
 	 * schedule writes
@@ -1848,6 +1870,13 @@ static void sync_request_write(struct md
 		      !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
 			continue;
 
+		if (do_discard) {
+			md_sync_acct(wbio->bi_bdev, wbio->bi_size >> 9);
+			/* This is a silly synchronization IO */
+			blkdev_issue_discard(wbio->bi_bdev, wbio->bi_sector,
+				r1_bio->sectors, GFP_NOIO, 0);
+			continue;
+		}
 		wbio->bi_rw = WRITE;
 		wbio->bi_end_io = end_sync_write;
 		atomic_inc(&r1_bio->remaining);
