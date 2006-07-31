From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 9] md: Factor out part of raid10d into a separate function.
Date: Mon, 31 Jul 2006 17:32:08 +1000
Message-ID: <1060731073208.24470@suse.de>
References: <20060731172842.24323.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


raid10d has toooo many nested block, so take the fix_read_error
functionality out into a separate function.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |  213 ++++++++++++++++++++++++++------------------------
 1 file changed, 115 insertions(+), 98 deletions(-)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2006-07-31 17:23:57.000000000 +1000
+++ ./drivers/md/raid10.c	2006-07-31 17:24:34.000000000 +1000
@@ -1350,9 +1350,119 @@ static void recovery_request_write(mddev
  *
  *	1.	Retries failed read operations on working mirrors.
  *	2.	Updates the raid superblock when problems encounter.
- *	3.	Performs writes following reads for array syncronising.
+ *	3.	Performs writes following reads for array synchronising.
  */
 
+static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
+{
+	int sect = 0; /* Offset from r10_bio->sector */
+	int sectors = r10_bio->sectors;
+	mdk_rdev_t*rdev;
+	while(sectors) {
+		int s = sectors;
+		int sl = r10_bio->read_slot;
+		int success = 0;
+		int start;
+
+		if (s > (PAGE_SIZE>>9))
+			s = PAGE_SIZE >> 9;
+
+		rcu_read_lock();
+		do {
+			int d = r10_bio->devs[sl].devnum;
+			rdev = rcu_dereference(conf->mirrors[d].rdev);
+			if (rdev &&
+			    test_bit(In_sync, &rdev->flags)) {
+				atomic_inc(&rdev->nr_pending);
+				rcu_read_unlock();
+				success = sync_page_io(rdev->bdev,
+						       r10_bio->devs[sl].addr +
+						       sect + rdev->data_offset,
+						       s<<9,
+						       conf->tmppage, READ);
+				rdev_dec_pending(rdev, mddev);
+				rcu_read_lock();
+				if (success)
+					break;
+			}
+			sl++;
+			if (sl == conf->copies)
+				sl = 0;
+		} while (!success && sl != r10_bio->read_slot);
+		rcu_read_unlock();
+
+		if (!success) {
+			/* Cannot read from anywhere -- bye bye array */
+			int dn = r10_bio->devs[r10_bio->read_slot].devnum;
+			md_error(mddev, conf->mirrors[dn].rdev);
+			break;
+		}
+
+		start = sl;
+		/* write it back and re-read */
+		rcu_read_lock();
+		while (sl != r10_bio->read_slot) {
+			int d;
+			if (sl==0)
+				sl = conf->copies;
+			sl--;
+			d = r10_bio->devs[sl].devnum;
+			rdev = rcu_dereference(conf->mirrors[d].rdev);
+			if (rdev &&
+			    test_bit(In_sync, &rdev->flags)) {
+				atomic_inc(&rdev->nr_pending);
+				rcu_read_unlock();
+				atomic_add(s, &rdev->corrected_errors);
+				if (sync_page_io(rdev->bdev,
+						 r10_bio->devs[sl].addr +
+						 sect + rdev->data_offset,
+						 s<<9, conf->tmppage, WRITE)
+				    == 0)
+					/* Well, this device is dead */
+					md_error(mddev, rdev);
+				rdev_dec_pending(rdev, mddev);
+				rcu_read_lock();
+			}
+		}
+		sl = start;
+		while (sl != r10_bio->read_slot) {
+			int d;
+			if (sl==0)
+				sl = conf->copies;
+			sl--;
+			d = r10_bio->devs[sl].devnum;
+			rdev = rcu_dereference(conf->mirrors[d].rdev);
+			if (rdev &&
+			    test_bit(In_sync, &rdev->flags)) {
+				char b[BDEVNAME_SIZE];
+				atomic_inc(&rdev->nr_pending);
+				rcu_read_unlock();
+				if (sync_page_io(rdev->bdev,
+						 r10_bio->devs[sl].addr +
+						 sect + rdev->data_offset,
+						 s<<9, conf->tmppage, READ) == 0)
+					/* Well, this device is dead */
+					md_error(mddev, rdev);
+				else
+					printk(KERN_INFO
+					       "raid10:%s: read error corrected"
+					       " (%d sectors at %llu on %s)\n",
+					       mdname(mddev), s,
+					       (unsigned long long)sect+
+					            rdev->data_offset,
+					       bdevname(rdev->bdev, b));
+
+				rdev_dec_pending(rdev, mddev);
+				rcu_read_lock();
+			}
+		}
+		rcu_read_unlock();
+
+		sectors -= s;
+		sect += s;
+	}
+}
+
 static void raid10d(mddev_t *mddev)
 {
 	r10bio_t *r10_bio;
@@ -1413,105 +1523,12 @@ static void raid10d(mddev_t *mddev)
 			 * This is all done synchronously while the array is
 			 * frozen.
 			 */
-			int sect = 0; /* Offset from r10_bio->sector */
-			int sectors = r10_bio->sectors;
-			freeze_array(conf);
-			if (mddev->ro == 0) while(sectors) {
-				int s = sectors;
-				int sl = r10_bio->read_slot;
-				int success = 0;
-
-				if (s > (PAGE_SIZE>>9))
-					s = PAGE_SIZE >> 9;
-
-				rcu_read_lock();
-				do {
-					int d = r10_bio->devs[sl].devnum;
-					rdev = rcu_dereference(conf->mirrors[d].rdev);
-					if (rdev &&
-					    test_bit(In_sync, &rdev->flags)) {
-						atomic_inc(&rdev->nr_pending);
-						rcu_read_unlock();
-						success = sync_page_io(rdev->bdev,
-								       r10_bio->devs[sl].addr +
-								       sect + rdev->data_offset,
-								       s<<9,
-								       conf->tmppage, READ);
-						rdev_dec_pending(rdev, mddev);
-						rcu_read_lock();
-						if (success)
-							break;
-					}
-					sl++;
-					if (sl == conf->copies)
-						sl = 0;
-				} while (!success && sl != r10_bio->read_slot);
-				rcu_read_unlock();
-
-				if (success) {
-					int start = sl;
-					/* write it back and re-read */
-					rcu_read_lock();
-					while (sl != r10_bio->read_slot) {
-						int d;
-						if (sl==0)
-							sl = conf->copies;
-						sl--;
-						d = r10_bio->devs[sl].devnum;
-						rdev = rcu_dereference(conf->mirrors[d].rdev);
-						if (rdev &&
-						    test_bit(In_sync, &rdev->flags)) {
-							atomic_inc(&rdev->nr_pending);
-							rcu_read_unlock();
-							atomic_add(s, &rdev->corrected_errors);
-							if (sync_page_io(rdev->bdev,
-									 r10_bio->devs[sl].addr +
-									 sect + rdev->data_offset,
-									 s<<9, conf->tmppage, WRITE) == 0)
-								/* Well, this device is dead */
-								md_error(mddev, rdev);
-							rdev_dec_pending(rdev, mddev);
-							rcu_read_lock();
-						}
-					}
-					sl = start;
-					while (sl != r10_bio->read_slot) {
-						int d;
-						if (sl==0)
-							sl = conf->copies;
-						sl--;
-						d = r10_bio->devs[sl].devnum;
-						rdev = rcu_dereference(conf->mirrors[d].rdev);
-						if (rdev &&
-						    test_bit(In_sync, &rdev->flags)) {
-							atomic_inc(&rdev->nr_pending);
-							rcu_read_unlock();
-							if (sync_page_io(rdev->bdev,
-									 r10_bio->devs[sl].addr +
-									 sect + rdev->data_offset,
-									 s<<9, conf->tmppage, READ) == 0)
-								/* Well, this device is dead */
-								md_error(mddev, rdev);
-							else
-								printk(KERN_INFO "raid10:%s: read error corrected (%d sectors at %llu on %s)\n",
-								       mdname(mddev), s, (unsigned long long)(sect+rdev->data_offset), bdevname(rdev->bdev, b));
-
-							rdev_dec_pending(rdev, mddev);
-							rcu_read_lock();
-						}
-					}
-					rcu_read_unlock();
-				} else {
-					/* Cannot read from anywhere -- bye bye array */
-					md_error(mddev, conf->mirrors[r10_bio->devs[r10_bio->read_slot].devnum].rdev);
-					break;
-				}
-				sectors -= s;
-				sect += s;
+			if (mddev->ro == 0) {
+				freeze_array(conf);
+				fix_read_error(conf, mddev, r10_bio);
+				unfreeze_array(conf);
 			}
 
-			unfreeze_array(conf);
-
 			bio = r10_bio->devs[r10_bio->read_slot].bio;
 			r10_bio->devs[r10_bio->read_slot].bio =
 				mddev->ro ? IO_BLOCKED : NULL;
