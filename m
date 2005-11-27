From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 016 of 18] Better handling for read error in raid1 during resync
Date: Mon, 28 Nov 2005 10:40:59 +1100
Message-ID: <1051127234059.14925@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


... incomplete

Signed-off-by: Neil Brown <neilb@suse.de>
Fix md raid1 fix-read-error-during-resync


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |   99 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 78 insertions(+), 21 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-11-28 10:13:14.000000000 +1100
+++ ./drivers/md/raid1.c	2005-11-28 10:13:27.000000000 +1100
@@ -1071,9 +1071,7 @@ abort:
 
 static int end_sync_read(struct bio *bio, unsigned int bytes_done, int error)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
-	conf_t *conf = mddev_to_conf(r1_bio->mddev);
 
 	if (bio->bi_size)
 		return 1;
@@ -1086,10 +1084,7 @@ static int end_sync_read(struct bio *bio
 	 * or re-read if the read failed.
 	 * We don't do much here, just schedule handling by raid1d
 	 */
-	if (!uptodate) {
-		md_error(r1_bio->mddev,
-			 conf->mirrors[r1_bio->read_disk].rdev);
-	} else
+	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 	reschedule_retry(r1_bio);
 	return 0;
@@ -1133,27 +1128,89 @@ static void sync_request_write(mddev_t *
 
 	bio = r1_bio->bios[r1_bio->read_disk];
 
-/*
-	if (r1_bio->sector == 0) printk("First sync write startss\n");
-*/
+
 	/*
 	 * schedule writes
 	 */
 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
-		/*
-		 * There is no point trying a read-for-reconstruct as
-		 * reconstruct is about to be aborted
+		/* ouch - failed to read all of that.
+		 * Try some synchronous reads of other devices to get
+		 * good data, much like with normal read errors.  Only
+		 * read into the pages we already have so they we don't
+		 * need to re-issue the read request.
+		 * We don't need to freeze the array, because being in an
+		 * active sync request, there is no normal IO, and
+		 * no overlapping syncs.
 		 */
-		char b[BDEVNAME_SIZE];
-		printk(KERN_ALERT "raid1: %s: unrecoverable I/O read error"
-			" for block %llu\n",
-			bdevname(bio->bi_bdev,b), 
-			(unsigned long long)r1_bio->sector);
-		md_done_sync(mddev, r1_bio->sectors, 0);
-		put_buf(r1_bio);
-		return;
+		sector_t sect = r1_bio->sector;
+		int sectors = r1_bio->sectors;
+		int idx = 0;
+
+		while(sectors) {
+			int s = sectors;
+			int d = r1_bio->read_disk;
+			int success = 0;
+			mdk_rdev_t *rdev;
+
+			if (s > (PAGE_SIZE>>9))
+				s = PAGE_SIZE >> 9;
+			do {
+				if (r1_bio->bios[d]->bi_end_io == end_sync_read) {
+					rdev = conf->mirrors[d].rdev;
+					if (sync_page_io(rdev->bdev,
+							 sect + rdev->data_offset,
+							 s<<9,
+							 bio->bi_io_vec[idx].bv_page,
+							 READ)) {
+						success = 1;
+						break;
+					}
+				}
+				d++;
+				if (d == conf->raid_disks)
+					d = 0;
+			} while (!success && d != r1_bio->read_disk);
+
+			if (success) {
+				/* write it back and re-read */
+				set_bit(R1BIO_Uptodate, &r1_bio->state);
+				while (d != r1_bio->read_disk) {
+					if (d == 0)
+						d = conf->raid_disks;
+					d--;
+					if (r1_bio->bios[d]->bi_end_io != end_sync_read)
+						continue;
+					rdev = conf->mirrors[d].rdev;
+					if (sync_page_io(rdev->bdev,
+							 sect + rdev->data_offset,
+							 s<<9,
+							 bio->bi_io_vec[idx].bv_page,
+							 WRITE) == 0 ||
+					    sync_page_io(rdev->bdev,
+							 sect + rdev->data_offset,
+							 s<<9,
+							 bio->bi_io_vec[idx].bv_page,
+							 READ) == 0) {
+						md_error(mddev, rdev);
+					}
+				}
+			} else {
+				char b[BDEVNAME_SIZE];
+				/* Cannot read from anywhere, array is toast */
+				md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
+				printk(KERN_ALERT "raid1: %s: unrecoverable I/O read error"
+				       " for block %llu\n",
+				       bdevname(bio->bi_bdev,b),
+				       (unsigned long long)r1_bio->sector);
+				md_done_sync(mddev, r1_bio->sectors, 0);
+				put_buf(r1_bio);
+				return;
+			}
+			sectors -= s;
+			sect += s;
+			idx ++;
+		}
 	}
-
 	atomic_set(&r1_bio->remaining, 1);
 	for (i = 0; i < disks ; i++) {
 		wbio = r1_bio->bios[i];
