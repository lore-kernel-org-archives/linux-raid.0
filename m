From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 4] md: Factor out part of raid1d into a separate function
Date: Mon, 28 Aug 2006 09:49:22 +1000
Message-ID: <1060827234922.32479@suse.de>
References: <20060828092849.21292.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

From: NeilBrown <neilb@suse.de>

raid1d has toooo many nested block, so take the fix_read_error functionality
out into a separate function.

Signed-off-by: Neil Brown <neilb@suse.de>
---

 drivers/md/raid1.c |  161 +++++++++++++++++++++++--------------------
 1 file changed, 89 insertions(+), 72 deletions(-)

Index: mm-quilt/drivers/md/raid1.c
===================================================================
--- mm-quilt.orig/drivers/md/raid1.c	2006-08-28 09:06:32.000000000 +1000
+++ mm-quilt/drivers/md/raid1.c	2006-08-28 09:42:51.000000000 +1000
@@ -1368,6 +1368,95 @@ static void sync_request_write(mddev_t *
  *	3.	Performs writes following reads for array syncronising.
  */
 
+static void fix_read_error(conf_t *conf, int read_disk,
+			   sector_t sect, int sectors)
+{
+	mddev_t *mddev = conf->mddev;
+	while(sectors) {
+		int s = sectors;
+		int d = read_disk;
+		int success = 0;
+		int start;
+		mdk_rdev_t *rdev;
+
+		if (s > (PAGE_SIZE>>9))
+			s = PAGE_SIZE >> 9;
+
+		do {
+			/* Note: no rcu protection needed here
+			 * as this is synchronous in the raid1d thread
+			 * which is the thread that might remove
+			 * a device.  If raid1d ever becomes multi-threaded....
+			 */
+			rdev = conf->mirrors[d].rdev;
+			if (rdev &&
+			    test_bit(In_sync, &rdev->flags) &&
+			    sync_page_io(rdev->bdev,
+					 sect + rdev->data_offset,
+					 s<<9,
+					 conf->tmppage, READ))
+				success = 1;
+			else {
+				d++;
+				if (d == conf->raid_disks)
+					d = 0;
+			}
+		} while (!success && d != read_disk);
+
+		if (!success) {
+			/* Cannot read from anywhere -- bye bye array */
+			md_error(mddev, conf->mirrors[read_disk].rdev);
+			break;
+		}
+		/* write it back and re-read */
+		start = d;
+		while (d != read_disk) {
+			if (d==0)
+				d = conf->raid_disks;
+			d--;
+			rdev = conf->mirrors[d].rdev;
+			if (rdev &&
+			    test_bit(In_sync, &rdev->flags)) {
+				if (sync_page_io(rdev->bdev,
+						 sect + rdev->data_offset,
+						 s<<9, conf->tmppage, WRITE)
+				    == 0)
+					/* Well, this device is dead */
+					md_error(mddev, rdev);
+			}
+		}
+		d = start;
+		while (d != read_disk) {
+			char b[BDEVNAME_SIZE];
+			if (d==0)
+				d = conf->raid_disks;
+			d--;
+			rdev = conf->mirrors[d].rdev;
+			if (rdev &&
+			    test_bit(In_sync, &rdev->flags)) {
+				if (sync_page_io(rdev->bdev,
+						 sect + rdev->data_offset,
+						 s<<9, conf->tmppage, READ)
+				    == 0)
+					/* Well, this device is dead */
+					md_error(mddev, rdev);
+				else {
+					atomic_add(s, &rdev->corrected_errors);
+					printk(KERN_INFO
+					       "raid1:%s: read error corrected "
+					       "(%d sectors at %llu on %s)\n",
+					       mdname(mddev), s,
+					       (unsigned long long)sect +
+					           rdev->data_offset,
+					       bdevname(rdev->bdev, b));
+				}
+			}
+		}
+		sectors -= s;
+		sect += s;
+	}
+}
+
 static void raid1d(mddev_t *mddev)
 {
 	r1bio_t *r1_bio;
@@ -1460,86 +1549,14 @@ static void raid1d(mddev_t *mddev)
 			 * This is all done synchronously while the array is
 			 * frozen
 			 */
-			sector_t sect = r1_bio->sector;
-			int sectors = r1_bio->sectors;
-			freeze_array(conf);
-			if (mddev->ro == 0) while(sectors) {
-				int s = sectors;
-				int d = r1_bio->read_disk;
-				int success = 0;
-
-				if (s > (PAGE_SIZE>>9))
-					s = PAGE_SIZE >> 9;
-
-				do {
-					/* Note: no rcu protection needed here
-					 * as this is synchronous in the raid1d thread
-					 * which is the thread that might remove
-					 * a device.  If raid1d ever becomes multi-threaded....
-					 */
-					rdev = conf->mirrors[d].rdev;
-					if (rdev &&
-					    test_bit(In_sync, &rdev->flags) &&
-					    sync_page_io(rdev->bdev,
-							 sect + rdev->data_offset,
-							 s<<9,
-							 conf->tmppage, READ))
-						success = 1;
-					else {
-						d++;
-						if (d == conf->raid_disks)
-							d = 0;
-					}
-				} while (!success && d != r1_bio->read_disk);
-
-				if (success) {
-					/* write it back and re-read */
-					int start = d;
-					while (d != r1_bio->read_disk) {
-						if (d==0)
-							d = conf->raid_disks;
-						d--;
-						rdev = conf->mirrors[d].rdev;
-						if (rdev &&
-						    test_bit(In_sync, &rdev->flags)) {
-							if (sync_page_io(rdev->bdev,
-									 sect + rdev->data_offset,
-									 s<<9, conf->tmppage, WRITE) == 0)
-								/* Well, this device is dead */
-								md_error(mddev, rdev);
-						}
-					}
-					d = start;
-					while (d != r1_bio->read_disk) {
-						if (d==0)
-							d = conf->raid_disks;
-						d--;
-						rdev = conf->mirrors[d].rdev;
-						if (rdev &&
-						    test_bit(In_sync, &rdev->flags)) {
-							if (sync_page_io(rdev->bdev,
-									 sect + rdev->data_offset,
-									 s<<9, conf->tmppage, READ) == 0)
-								/* Well, this device is dead */
-								md_error(mddev, rdev);
-							else {
-								atomic_add(s, &rdev->corrected_errors);
-								printk(KERN_INFO "raid1:%s: read error corrected (%d sectors at %llu on %s)\n",
-								       mdname(mddev), s, (unsigned long long)(sect + rdev->data_offset), bdevname(rdev->bdev, b));
-							}
-						}
-					}
-				} else {
-					/* Cannot read from anywhere -- bye bye array */
-					md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
-					break;
-				}
-				sectors -= s;
-				sect += s;
+			if (mddev->ro == 0) {
+				freeze_array(conf);
+				fix_read_error(conf, r1_bio->read_disk,
+					       r1_bio->sector,
+					       r1_bio->sectors);
+				unfreeze_array(conf);
 			}
 
-			unfreeze_array(conf);
-
 			bio = r1_bio->bios[r1_bio->read_disk];
 			if ((disk=read_balance(conf, r1_bio)) == -1) {
 				printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
