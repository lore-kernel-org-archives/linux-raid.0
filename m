From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 5] md: Fixed refcounting/locking when attempting read error correction in raid10
Date: Fri, 28 Apr 2006 12:51:39 +1000
Message-ID: <1060428025139.30758@suse.de>
References: <20060428124313.29510.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


We need to hold a reference to rdevs while reading
and writing to attempt to correct read errors.  This
reference must be taken under an rcu lock.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |   44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2006-04-28 12:13:20.000000000 +1000
+++ ./drivers/md/raid10.c	2006-04-28 12:16:54.000000000 +1000
@@ -1407,36 +1407,45 @@ static void raid10d(mddev_t *mddev)
 				if (s > (PAGE_SIZE>>9))
 					s = PAGE_SIZE >> 9;
 
+				rcu_read_lock();
 				do {
 					int d = r10_bio->devs[sl].devnum;
-					rdev = conf->mirrors[d].rdev;
+					rdev = rcu_dereference(conf->mirrors[d].rdev);
 					if (rdev &&
-					    test_bit(In_sync, &rdev->flags) &&
-					    sync_page_io(rdev->bdev,
-							 r10_bio->devs[sl].addr +
-							 sect + rdev->data_offset,
-							 s<<9,
-							 conf->tmppage, READ))
-						success = 1;
-					else {
-						sl++;
-						if (sl == conf->copies)
-							sl = 0;
+					    test_bit(In_sync, &rdev->flags)) {
+						atomic_inc(&rdev->nr_pending);
+						rcu_read_unlock();
+						success = sync_page_io(rdev->bdev,
+								       r10_bio->devs[sl].addr +
+								       sect + rdev->data_offset,
+								       s<<9,
+								       conf->tmppage, READ);
+						rdev_dec_pending(rdev, mddev);
+						rcu_read_lock();
+						if (success)
+							break;
 					}
+					sl++;
+					if (sl == conf->copies)
+						sl = 0;
 				} while (!success && sl != r10_bio->read_slot);
+				rcu_read_unlock();
 
 				if (success) {
 					int start = sl;
 					/* write it back and re-read */
+					rcu_read_lock();
 					while (sl != r10_bio->read_slot) {
 						int d;
 						if (sl==0)
 							sl = conf->copies;
 						sl--;
 						d = r10_bio->devs[sl].devnum;
-						rdev = conf->mirrors[d].rdev;
+						rdev = rcu_dereference(conf->mirrors[d].rdev);
 						if (rdev &&
 						    test_bit(In_sync, &rdev->flags)) {
+							atomic_inc(&rdev->nr_pending);
+							rcu_read_unlock();
 							atomic_add(s, &rdev->corrected_errors);
 							if (sync_page_io(rdev->bdev,
 									 r10_bio->devs[sl].addr +
@@ -1444,6 +1453,8 @@ static void raid10d(mddev_t *mddev)
 									 s<<9, conf->tmppage, WRITE) == 0)
 								/* Well, this device is dead */
 								md_error(mddev, rdev);
+							rdev_dec_pending(rdev, mddev);
+							rcu_read_lock();
 						}
 					}
 					sl = start;
@@ -1453,17 +1464,22 @@ static void raid10d(mddev_t *mddev)
 							sl = conf->copies;
 						sl--;
 						d = r10_bio->devs[sl].devnum;
-						rdev = conf->mirrors[d].rdev;
+						rdev = rcu_dereference(conf->mirrors[d].rdev);
 						if (rdev &&
 						    test_bit(In_sync, &rdev->flags)) {
+							atomic_inc(&rdev->nr_pending);
+							rcu_read_unlock();
 							if (sync_page_io(rdev->bdev,
 									 r10_bio->devs[sl].addr +
 									 sect + rdev->data_offset,
 									 s<<9, conf->tmppage, READ) == 0)
 								/* Well, this device is dead */
 								md_error(mddev, rdev);
+							rdev_dec_pending(rdev, mddev);
+							rcu_read_lock();
 						}
 					}
+					rcu_read_unlock();
 				} else {
 					/* Cannot read from anywhere -- bye bye array */
 					md_error(mddev, conf->mirrors[r10_bio->devs[r10_bio->read_slot].devnum].rdev);
