From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md/raid1:Fix bug about fixing read errors.
Date: Wed, 11 Apr 2012 20:08:31 +0800
Message-ID: <201204112008265318561@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From b5b091c186efcd32d191206181590be76a393cda Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Wed, 11 Apr 2012 19:57:01 +0800
Subject: [PATCH] md/raid1:Fix bug about fixing read errors.
 Add spare disk  which working when fix read errors.And if it can't read
 corrected data,it should make all disks badsectors.And no
 need to read,because this no disk can read.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d35e4c9..67ec686 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1833,7 +1833,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
  *	3.	Performs writes following reads for array synchronising.
  */
 
-static void fix_read_error(struct r1conf *conf, int read_disk,
+static int  fix_read_error(struct r1conf *conf, int read_disk,
 			   sector_t sect, int sectors)
 {
 	struct mddev *mddev = conf->mddev;
@@ -1858,7 +1858,9 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
-			    test_bit(In_sync, &rdev->flags) &&
+			    (test_bit(In_sync, &rdev->flags) ||
+			     (!test_bit(Faulty, &rdev->flags) &&
+			      (rdev->recovery_offset >= sect + s))) &&
 			    is_badblock(rdev, sect, s,
 					&first_bad, &bad_sectors) == 0 &&
 			    sync_page_io(rdev, sect, s<<9,
@@ -1873,10 +1875,15 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 
 		if (!success) {
 			/* Cannot read from anywhere - mark it bad */
-			struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
-			if (!rdev_set_badblocks(rdev, sect, s, 0))
-				md_error(mddev, rdev);
-			break;
+			struct md_rdev *rdev;
+			for (d = 0; d < conf->raid_disks * 2; d++) {
+				rdev = conf->mirrors[d].rdev;
+				if (!rdev)
+					continue;
+				else if (!rdev_set_badblocks(rdev, sect, s, 0))
+					md_error(mddev, rdev);
+			}
+			return 1;
 		}
 		/* write it back and re-read */
 		start = d;
@@ -1915,6 +1922,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		sectors -= s;
 		sect += s;
 	}
+	return 0;
 }
 
 static void bi_complete(struct bio *bio, int error)
@@ -2072,8 +2080,13 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	struct bio *bio;
 	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
+	int ret;
 
 	clear_bit(R1BIO_ReadError, &r1_bio->state);
+
+	bio = r1_bio->bios[r1_bio->read_disk];
+	bdevname(bio->bi_bdev, b);
+
 	/* we got a read error. Maybe the drive is bad.  Maybe just
 	 * the block and we can fix it.
 	 * We freeze all other IO, and try reading the block from
@@ -2084,14 +2097,21 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 */
 	if (mddev->ro == 0) {
 		freeze_array(conf);
-		fix_read_error(conf, r1_bio->read_disk,
+		ret = fix_read_error(conf, r1_bio->read_disk,
 			       r1_bio->sector, r1_bio->sectors);
 		unfreeze_array(conf);
+		/*no need read more */
+		if (ret) {
+			printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O"
+			      " read error for block %llu\n", mdname(mddev),
+			      b, (unsigned long long)r1_bio->sector);
+			raid_end_bio_io(r1_bio);
+			return;
+
+		}
 	} else
 		md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
 
-	bio = r1_bio->bios[r1_bio->read_disk];
-	bdevname(bio->bi_bdev, b);
 read_more:
 	disk = read_balance(conf, r1_bio, &max_sectors);
 	if (disk == -1) {
-- 
1.7.5.4

