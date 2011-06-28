From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 1/3] md/raid1: move rdev->corrected_errors counting
Date: Wed, 29 Jun 2011 01:47:24 +0900
Message-ID: <1309279646-4950-2-git-send-email-namhyung@gmail.com>
References: <1309279646-4950-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1309279646-4950-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Read errors are considered to corrected if write-back and re-read
cycle is finished without further problems. Thus moving the rdev->
corrected_errors counting after the re-reading looks more reasonable
IMHO. Also included a couple of whitespace fixes on sync_page_io().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid1.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6b7f5fdb35c0..4ed381488925 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1222,9 +1222,7 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 				 * active, and resync is currently active
 				 */
 				rdev = conf->mirrors[d].rdev;
-				if (sync_page_io(rdev,
-						 sect,
-						 s<<9,
+				if (sync_page_io(rdev, sect, s<<9,
 						 bio->bi_io_vec[idx].bv_page,
 						 READ, false)) {
 					success = 1;
@@ -1259,16 +1257,13 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
 				continue;
 			rdev = conf->mirrors[d].rdev;
-			if (sync_page_io(rdev,
-					 sect,
-					 s<<9,
+			if (sync_page_io(rdev, sect, s<<9,
 					 bio->bi_io_vec[idx].bv_page,
 					 WRITE, false) == 0) {
 				r1_bio->bios[d]->bi_end_io = NULL;
 				rdev_dec_pending(rdev, mddev);
 				md_error(mddev, rdev);
-			} else
-				atomic_add(s, &rdev->corrected_errors);
+			}
 		}
 		d = start;
 		while (d != r1_bio->read_disk) {
@@ -1278,12 +1273,12 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
 				continue;
 			rdev = conf->mirrors[d].rdev;
-			if (sync_page_io(rdev,
-					 sect,
-					 s<<9,
+			if (sync_page_io(rdev, sect, s<<9,
 					 bio->bi_io_vec[idx].bv_page,
 					 READ, false) == 0)
 				md_error(mddev, rdev);
+			else
+				atomic_add(s, &rdev->corrected_errors);
 		}
 		sectors -= s;
 		sect += s;
-- 
1.7.6

