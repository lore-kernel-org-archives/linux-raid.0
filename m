From: "majianpeng" <majianpeng@gmail.com>
Subject: md/raid1:If r1bio->sectors % 8 != 0,then the memcmp and  later memcpy will omit the last bio_vec.
Date: Sat, 31 Mar 2012 15:44:14 +0800
Message-ID: <201203311544085318429@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 72e5ad9da511689f7efe330ce5093a3df2c92738 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Sat, 31 Mar 2012 15:36:01 +0800
Subject: [PATCH] md/raid1:If r1bio->sectors % 8 != 0,then the memcmp and
 later memcpy will omit the last bio_vec.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a40a20..11a28ca 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1711,7 +1711,7 @@ static int process_checks(struct r1bio *r1_bio)
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
 	int primary;
-	int i;
+	int i, vcnt;
 
 	for (primary = 0; primary < conf->raid_disks * 2; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
@@ -1721,9 +1721,9 @@ static int process_checks(struct r1bio *r1_bio)
 			break;
 		}
 	r1_bio->read_disk = primary;
+	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		int j;
-		int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
 		struct bio *pbio = r1_bio->bios[primary];
 		struct bio *sbio = r1_bio->bios[i];
 		int size;
@@ -1736,9 +1736,16 @@ static int process_checks(struct r1bio *r1_bio)
 				struct page *p, *s;
 				p = pbio->bi_io_vec[j].bv_page;
 				s = sbio->bi_io_vec[j].bv_page;
+				if ((j == vcnt - 1) &&
+					(r1_bio->sectors &
+					 (PAGE_SIZE / 512 - 1)))
+					size = (r1_bio->sectors << 9)
+						- (PAGE_SIZE * j);
+				else
+					size = PAGE_SIZE;
 				if (memcmp(page_address(p),
 					   page_address(s),
-					   PAGE_SIZE))
+					   size))
 					break;
 			}
 		} else
@@ -2480,7 +2487,6 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 	} while (r1_bio->bios[disk]->bi_vcnt < RESYNC_PAGES);
  bio_full:
 	r1_bio->sectors = nr_sectors;
-
 	/* For a user-requested sync, we read all readable devices and do a
 	 * compare
 	 */
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-31

