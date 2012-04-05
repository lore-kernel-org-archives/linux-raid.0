From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md/raid1,raid10:If r1bio->sectors % 8 != 0,then the memcmp  and latermemcpy will omit the last bio_vec.
Date: Thu, 5 Apr 2012 14:48:39 +0800
Message-ID: <201204051448360781921@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From a4e76f125fd277ed5a72bf0e2fffde8b210a9603 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Thu, 5 Apr 2012 14:42:12 +0800
Subject: [PATCH] md/raid1,raid10:If r1bio->sectors % 8 != 0,then the memcmp
 and latermemcpy will omit the last bio_vec.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c  |    3 ++-
 drivers/md/raid10.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d35e4c9..15dd59b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1712,6 +1712,7 @@ static int process_checks(struct r1bio *r1_bio)
 	struct r1conf *conf = mddev->private;
 	int primary;
 	int i;
+	int vcnt;
 
 	for (primary = 0; primary < conf->raid_disks * 2; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
@@ -1721,9 +1722,9 @@ static int process_checks(struct r1bio *r1_bio)
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
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index fff7821..c8dbb84 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1788,6 +1788,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	struct r10conf *conf = mddev->private;
 	int i, first;
 	struct bio *tbio, *fbio;
+	int vcnt;
 
 	atomic_set(&r10_bio->remaining, 1);
 
@@ -1802,10 +1803,10 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	first = i;
 	fbio = r10_bio->devs[i].bio;
 
+	vcnt = (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
 	/* now find blocks with errors */
 	for (i=0 ; i < conf->copies ; i++) {
 		int  j, d;
-		int vcnt = r10_bio->sectors >> (PAGE_SHIFT-9);
 
 		tbio = r10_bio->devs[i].bio;
 
@@ -1871,7 +1872,6 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	 */
 	for (i = 0; i < conf->copies; i++) {
 		int j, d;
-		int vcnt = r10_bio->sectors >> (PAGE_SHIFT-9);
 
 		tbio = r10_bio->devs[i].repl_bio;
 		if (!tbio || !tbio->bi_end_io)
-- 
1.7.5.4

 				
--------------
majianpeng
2012-04-05

