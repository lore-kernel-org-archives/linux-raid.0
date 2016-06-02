From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 12/18] md/raid1: add rcu protection to rdev in
 fix_read_error
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.90244.stgit@noble>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Since remove_and_add_spares() was added to hot_remove_disk() it has
been possible for an rdev to be hot-removed while fix_read_error()
was running, so we need to be more careful, and take a reference to
the rdev while performing IO.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c |   52 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cc53120e4d68..0ee901ccc9c5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2056,29 +2056,30 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			s = PAGE_SIZE >> 9;
 
 		do {
-			/* Note: no rcu protection needed here
-			 * as this is synchronous in the raid1d thread
-			 * which is the thread that might remove
-			 * a device.  If raid1d ever becomes multi-threaded....
-			 */
 			sector_t first_bad;
 			int bad_sectors;
 
-			rdev = conf->mirrors[d].rdev;
+			rcu_read_lock();
+			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (rdev &&
 			    (test_bit(In_sync, &rdev->flags) ||
 			     (!test_bit(Faulty, &rdev->flags) &&
 			      rdev->recovery_offset >= sect + s)) &&
 			    is_badblock(rdev, sect, s,
-					&first_bad, &bad_sectors) == 0 &&
-			    sync_page_io(rdev, sect, s<<9,
-					 conf->tmppage, READ, false))
-				success = 1;
-			else {
-				d++;
-				if (d == conf->raid_disks * 2)
-					d = 0;
-			}
+					&first_bad, &bad_sectors) == 0) {
+				atomic_inc(&rdev->nr_pending);
+				rcu_read_unlock();
+				if (sync_page_io(rdev, sect, s<<9,
+						 conf->tmppage, READ, false))
+					success = 1;
+				rdev_dec_pending(rdev, mddev);
+				if (success)
+					break;
+			} else
+				rcu_read_unlock();
+			d++;
+			if (d == conf->raid_disks * 2)
+				d = 0;
 		} while (!success && d != read_disk);
 
 		if (!success) {
@@ -2094,11 +2095,17 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			if (d==0)
 				d = conf->raid_disks * 2;
 			d--;
-			rdev = conf->mirrors[d].rdev;
+			rcu_read_lock();
+			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (rdev &&
-			    !test_bit(Faulty, &rdev->flags))
+			    !test_bit(Faulty, &rdev->flags)) {
+				atomic_inc(&rdev->nr_pending);
+				rcu_read_unlock();
 				r1_sync_page_io(rdev, sect, s,
 						conf->tmppage, WRITE);
+				rdev_dec_pending(rdev, mddev);
+			} else
+				rcu_read_unlock();
 		}
 		d = start;
 		while (d != read_disk) {
@@ -2106,9 +2113,12 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			if (d==0)
 				d = conf->raid_disks * 2;
 			d--;
-			rdev = conf->mirrors[d].rdev;
+			rcu_read_lock();
+			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (rdev &&
 			    !test_bit(Faulty, &rdev->flags)) {
+				atomic_inc(&rdev->nr_pending);
+				rcu_read_unlock();
 				if (r1_sync_page_io(rdev, sect, s,
 						    conf->tmppage, READ)) {
 					atomic_add(s, &rdev->corrected_errors);
@@ -2117,10 +2127,12 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 					       "(%d sectors at %llu on %s)\n",
 					       mdname(mddev), s,
 					       (unsigned long long)(sect +
-					           rdev->data_offset),
+								    rdev->data_offset),
 					       bdevname(rdev->bdev, b));
 				}
-			}
+				rdev_dec_pending(rdev, mddev);
+			} else
+				rcu_read_unlock();
 		}
 		sectors -= s;
 		sect += s;


