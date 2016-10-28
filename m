From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] raid1: handle read error also in readonly mode
Date: Fri, 28 Oct 2016 14:45:58 +0200
Message-ID: <1477658758-22637-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

If write is the first operation on a disk and it happens not to be
aligned to page size, block layer sends read request first. If read
operation fails, the disk is set as failed as no attempt to fix the
error is made because array is in auto-readonly mode. Similarily, the
disk is set as failed for read-only array.

Take the same approach as in raid10. Don't fail the disk if array is in
readonly or auto-readonly mode. Try to redirect the request first and if
unsuccessful, return a read error.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 drivers/md/raid1.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index db536a6..29e2df5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2297,17 +2297,23 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 * This is all done synchronously while the array is
 	 * frozen
 	 */
+
+	bio = r1_bio->bios[r1_bio->read_disk];
+	bdevname(bio->bi_bdev, b);
+	bio_put(bio);
+	r1_bio->bios[r1_bio->read_disk] = NULL;
+
 	if (mddev->ro == 0) {
 		freeze_array(conf, 1);
 		fix_read_error(conf, r1_bio->read_disk,
 			       r1_bio->sector, r1_bio->sectors);
 		unfreeze_array(conf);
-	} else
-		md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
+	} else {
+		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
+	}
+
 	rdev_dec_pending(conf->mirrors[r1_bio->read_disk].rdev, conf->mddev);
 
-	bio = r1_bio->bios[r1_bio->read_disk];
-	bdevname(bio->bi_bdev, b);
 read_more:
 	disk = read_balance(conf, r1_bio, &max_sectors);
 	if (disk == -1) {
@@ -2318,11 +2324,6 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	} else {
 		const unsigned long do_sync
 			= r1_bio->master_bio->bi_opf & REQ_SYNC;
-		if (bio) {
-			r1_bio->bios[r1_bio->read_disk] =
-				mddev->ro ? IO_BLOCKED : NULL;
-			bio_put(bio);
-		}
 		r1_bio->read_disk = disk;
 		bio = bio_clone_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
 		bio_trim(bio, r1_bio->sector - bio->bi_iter.bi_sector,
-- 
1.8.3.1

