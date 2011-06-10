From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH/RFC] md/raid10: spread read for subordinate r10bios during recovery
Date: Fri, 10 Jun 2011 12:31:48 +0900
Message-ID: <1307676708-8977-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In the current scheme, multiple read request could be directed to
the first active disk during recovery if there are several disk
failure at the same time. Spreading those requests on other in-sync
disks might be helpful.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid10.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dea73bdb99b8..d0188e49f881 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1832,6 +1832,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 	if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 		/* recovery... the complicated one */
 		int j, k;
+		int last_read = -1;
 		r10_bio = NULL;
 
 		for (i=0 ; i<conf->raid_disks; i++) {
@@ -1891,7 +1892,9 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 						      &sync_blocks, still_degraded);
 
 			for (j=0; j<conf->copies;j++) {
-				int d = r10_bio->devs[j].devnum;
+				int c = (last_read + j + 1) % conf->copies;
+				int d = r10_bio->devs[c].devnum;
+
 				if (!conf->mirrors[d].rdev ||
 				    !test_bit(In_sync, &conf->mirrors[d].rdev->flags))
 					continue;
@@ -1902,13 +1905,14 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_read;
 				bio->bi_rw = READ;
-				bio->bi_sector = r10_bio->devs[j].addr +
+				bio->bi_sector = r10_bio->devs[c].addr +
 					conf->mirrors[d].rdev->data_offset;
 				bio->bi_bdev = conf->mirrors[d].rdev->bdev;
 				atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 				atomic_inc(&r10_bio->remaining);
-				/* and we write to 'i' */
+				last_read = c;
 
+				/* and we write to 'i' */
 				for (k=0; k<conf->copies; k++)
 					if (r10_bio->devs[k].devnum == i)
 						break;
-- 
1.7.5.2

