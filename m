From: "Vladimir B. Savkin" <master@sectorb.msk.ru>
Subject: [PATCH] fix write-mostly logic
Date: Tue, 25 Mar 2014 19:02:20 +0400
Message-ID: <20140325150219.GA12840@tentacle.sectorb.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline

Hi, RAID developers!

I noticed that write-mostly logic in current kernel is broken.
It seems that read_balance() always chooses write-mostly disk when one exists,
unless other normal disk happens to have zero outstanding requests.


This patch fixes it - tested on 3.13.7 but should apply cleanly to git trunk.
BTW good_sectors logic looks broken too, but I couldn't figure out 
what that code is supposed to do, so no fix for that.

I think that the following commit broke it:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/md/raid1.c?id=9dedf60313fa4dddfd5b9b226a0ef12a512bf9dc

"best" logic was split to "best_dist" and "best_pending" but no change
was made for write-mostly branch and for good_sectors too.

~
:wq
                                        With best regards, 
                                           Vladimir Savkin. 


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="raid1wm.patch"

--- linux-3.10.33/drivers/md/raid1.c.orig	2014-03-16 01:11:43.000000000 +0400
+++ linux-3.10.33/drivers/md/raid1.c	2014-03-16 01:23:31.000000000 +0400
@@ -498,6 +498,8 @@
 	int sectors;
 	int best_good_sectors;
 	int best_disk, best_dist_disk, best_pending_disk;
+	int writemostly_disk;
+	int writemostly_good_sectors;
 	int has_nonrot_disk;
 	int disk;
 	sector_t best_dist;
@@ -519,7 +521,9 @@
 	best_dist = MaxSector;
 	best_pending_disk = -1;
 	min_pending = UINT_MAX;
+	writemostly_disk = -1;
 	best_good_sectors = 0;
+	writemostly_good_sectors = 0;
 	has_nonrot_disk = 0;
 	choose_next_idle = 0;
 
@@ -548,16 +552,16 @@
 		if (test_bit(WriteMostly, &rdev->flags)) {
 			/* Don't balance among write-mostly, just
 			 * use the first as a last resort */
-			if (best_disk < 0) {
+			if (writemostly_disk < 0) {
 				if (is_badblock(rdev, this_sector, sectors,
 						&first_bad, &bad_sectors)) {
 					if (first_bad < this_sector)
 						/* Cannot use this */
 						continue;
-					best_good_sectors = first_bad - this_sector;
+					writemostly_good_sectors = first_bad - this_sector;
 				} else
-					best_good_sectors = sectors;
-				best_disk = disk;
+					writemostly_good_sectors = sectors;
+				writemostly_disk = disk;
 			}
 			continue;
 		}
@@ -664,6 +668,14 @@
 			best_disk = best_dist_disk;
 	}
 
+        /* 
+         * If there is still no good disk, try write-mostly.
+	 */
+	if ( (best_disk == -1) && (writemostly_disk >= 0) ) {
+		best_disk = writemostly_disk;
+		best_good_sectors = writemostly_good_sectors;
+	}
+	
 	if (best_disk >= 0) {
 		rdev = rcu_dereference(conf->mirrors[best_disk].rdev);
 		if (!rdev)

--PNTmBPCT7hxwcZjr--
