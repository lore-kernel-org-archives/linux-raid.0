From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md/raid1:combine code in fix_read_error and  fix_sync_read_error.
Date: Fri, 6 Apr 2012 15:15:38 +0800
Message-ID: <201204061515339217832@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From d8d5044e65ed2bea15e135918699777c49b6f224 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Fri, 6 Apr 2012 15:07:33 +0800
Subject: [PATCH] md/raid1:combine code in fix_read_error and
 fix_sync_read_error.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |   36 ++++++++----------------------------
 1 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d35e4c9..a9a4361 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1603,7 +1603,6 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 		int d = r1_bio->read_disk;
 		int success = 0;
 		struct md_rdev *rdev;
-		int start;
 
 		if (s > (PAGE_SIZE>>9))
 			s = PAGE_SIZE >> 9;
@@ -1661,7 +1660,6 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			continue;
 		}
 
-		start = d;
 		/* write it back and re-read */
 		while (d != r1_bio->read_disk) {
 			if (d == 0)
@@ -1675,21 +1673,12 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 					    WRITE) == 0) {
 				r1_bio->bios[d]->bi_end_io = NULL;
 				rdev_dec_pending(rdev, mddev);
-			}
-		}
-		d = start;
-		while (d != r1_bio->read_disk) {
-			if (d == 0)
-				d = conf->raid_disks * 2;
-			d--;
-			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
-				continue;
-			rdev = conf->mirrors[d].rdev;
-			if (r1_sync_page_io(rdev, sect, s,
-					    bio->bi_io_vec[idx].bv_page,
-					    READ) != 0)
+			} else if (r1_sync_page_io(rdev, sect, s,
+					    bio->bi_io_vec[idx].bv_page, READ))
 				atomic_add(s, &rdev->corrected_errors);
+
 		}
+
 		sectors -= s;
 		sect += s;
 		idx ++;
@@ -1841,7 +1830,6 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		int s = sectors;
 		int d = read_disk;
 		int success = 0;
-		int start;
 		struct md_rdev *rdev;
 
 		if (s > (PAGE_SIZE>>9))
@@ -1878,19 +1866,8 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 				md_error(mddev, rdev);
 			break;
 		}
+
 		/* write it back and re-read */
-		start = d;
-		while (d != read_disk) {
-			if (d==0)
-				d = conf->raid_disks * 2;
-			d--;
-			rdev = conf->mirrors[d].rdev;
-			if (rdev &&
-			    test_bit(In_sync, &rdev->flags))
-				r1_sync_page_io(rdev, sect, s,
-						conf->tmppage, WRITE);
-		}
-		d = start;
 		while (d != read_disk) {
 			char b[BDEVNAME_SIZE];
 			if (d==0)
@@ -1900,6 +1877,9 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags)) {
 				if (r1_sync_page_io(rdev, sect, s,
+						conf->tmppage, WRITE) == 0)
+					continue;
+				else if (r1_sync_page_io(rdev, sect, s,
 						    conf->tmppage, READ)) {
 					atomic_add(s, &rdev->corrected_errors);
 					printk(KERN_INFO
-- 
1.7.5.4

 				
--------------
majianpeng
2012-04-06

