From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 29/34] md/raid1: move rdev->corrected_errors counting
Date: Thu, 21 Jul 2011 12:32:28 +1000
Message-ID: <20110721023228.6728.69018.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Namhyung Kim <namhyung@gmail.com>
List-Id: linux-raid.ids

From: Namhyung Kim <namhyung@gmail.com>

Read errors are considered to corrected if write-back and re-read
cycle is finished without further problems. Thus moving the rdev->
corrected_errors counting after the re-reading looks more reasonable
IMHO. Also included a couple of whitespace fixes on sync_page_io().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 44069b3..a7e6908 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1224,9 +1224,7 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
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
@@ -1261,16 +1259,13 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
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
@@ -1280,12 +1275,12 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
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


