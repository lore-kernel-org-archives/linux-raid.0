From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 014 of 14] Fix possible problem in raid1/raid10 error overwriting.
Date: Thu, 1 Dec 2005 14:24:02 +1100
Message-ID: <1051201032402.29735@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The code to overwrite/reread for addressing read errors
in raid1/raid10 currently assumes that the read will
not alter the buffer which could be used to write to
the next device.  This is not a safe assumption to make.

So we split the loops into a overwrite loop and a separate re-read
loop, so that the writing is complete before reading is attempted.

Cc: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c  |   38 ++++++++++++++++++++++++++++++--------
 ./drivers/md/raid10.c |   22 ++++++++++++++++++----
 2 files changed, 48 insertions(+), 12 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-12-01 14:03:25.000000000 +1100
+++ ./drivers/md/raid1.c	2005-12-01 14:03:40.000000000 +1100
@@ -1252,6 +1252,7 @@ static void sync_request_write(mddev_t *
 			} while (!success && d != r1_bio->read_disk);
 
 			if (success) {
+				int start = d;
 				/* write it back and re-read */
 				set_bit(R1BIO_Uptodate, &r1_bio->state);
 				while (d != r1_bio->read_disk) {
@@ -1265,14 +1266,23 @@ static void sync_request_write(mddev_t *
 							 sect + rdev->data_offset,
 							 s<<9,
 							 bio->bi_io_vec[idx].bv_page,
-							 WRITE) == 0 ||
-					    sync_page_io(rdev->bdev,
+							 WRITE) == 0)
+						md_error(mddev, rdev);
+				}
+				d = start;
+				while (d != r1_bio->read_disk) {
+					if (d == 0)
+						d = conf->raid_disks;
+					d--;
+					if (r1_bio->bios[d]->bi_end_io != end_sync_read)
+						continue;
+					rdev = conf->mirrors[d].rdev;
+					if (sync_page_io(rdev->bdev,
 							 sect + rdev->data_offset,
 							 s<<9,
 							 bio->bi_io_vec[idx].bv_page,
-							 READ) == 0) {
+							 READ) == 0)
 						md_error(mddev, rdev);
-					}
 				}
 			} else {
 				char b[BDEVNAME_SIZE];
@@ -1444,6 +1454,7 @@ static void raid1d(mddev_t *mddev)
 
 				if (success) {
 					/* write it back and re-read */
+					int start = d;
 					while (d != r1_bio->read_disk) {
 						if (d==0)
 							d = conf->raid_disks;
@@ -1453,13 +1464,24 @@ static void raid1d(mddev_t *mddev)
 						    test_bit(In_sync, &rdev->flags)) {
 							if (sync_page_io(rdev->bdev,
 									 sect + rdev->data_offset,
-									 s<<9, conf->tmppage, WRITE) == 0 ||
-							    sync_page_io(rdev->bdev,
+									 s<<9, conf->tmppage, WRITE) == 0)
+								/* Well, this device is dead */
+								md_error(mddev, rdev);
+						}
+					}
+					d = start;
+					while (d != r1_bio->read_disk) {
+						if (d==0)
+							d = conf->raid_disks;
+						d--;
+						rdev = conf->mirrors[d].rdev;
+						if (rdev &&
+						    test_bit(In_sync, &rdev->flags)) {
+							if (sync_page_io(rdev->bdev,
 									 sect + rdev->data_offset,
-									 s<<9, conf->tmppage, READ) == 0) {
+									 s<<9, conf->tmppage, READ) == 0)
 								/* Well, this device is dead */
 								md_error(mddev, rdev);
-							}
 						}
 					}
 				} else {

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-12-01 14:03:25.000000000 +1100
+++ ./drivers/md/raid10.c	2005-12-01 14:03:41.000000000 +1100
@@ -1421,6 +1421,7 @@ static void raid10d(mddev_t *mddev)
 				} while (!success && sl != r10_bio->read_slot);
 
 				if (success) {
+					int start = sl;
 					/* write it back and re-read */
 					while (sl != r10_bio->read_slot) {
 						int d;
@@ -1434,14 +1435,27 @@ static void raid10d(mddev_t *mddev)
 							if (sync_page_io(rdev->bdev,
 									 r10_bio->devs[sl].addr +
 									 sect + rdev->data_offset,
-									 s<<9, conf->tmppage, WRITE) == 0 ||
-							    sync_page_io(rdev->bdev,
+									 s<<9, conf->tmppage, WRITE) == 0)
+								/* Well, this device is dead */
+								md_error(mddev, rdev);
+						}
+					}
+					sl = start;
+					while (sl != r10_bio->read_slot) {
+						int d;
+						if (sl==0)
+							sl = conf->copies;
+						sl--;
+						d = r10_bio->devs[sl].devnum;
+						rdev = conf->mirrors[d].rdev;
+						if (rdev &&
+						    test_bit(In_sync, &rdev->flags)) {
+							if (sync_page_io(rdev->bdev,
 									 r10_bio->devs[sl].addr +
 									 sect + rdev->data_offset,
-									 s<<9, conf->tmppage, READ) == 0) {
+									 s<<9, conf->tmppage, READ) == 0)
 								/* Well, this device is dead */
 								md_error(mddev, rdev);
-							}
 						}
 					}
 				} else {
