From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] md/raid1: factor out common bio handling code
Date: Tue,  2 Aug 2011 16:22:52 +0900
Message-ID: <1312269772-7605-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When normal-write and sync-read/write bio completes, we should
find out the disk number the bio belongs to. Factor those common
code out to a separate function.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid1.c |   44 ++++++++++++++++++++++++--------------------
 1 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d7518dc8593b..13109956edb9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -268,6 +268,24 @@ static inline void update_head_pos(int disk, r1bio_t *r1_bio)
 		r1_bio->sector + (r1_bio->sectors);
 }
 
+/*
+ * Find the disk number which triggered given bio
+ */
+static int find_bio_disk(r1bio_t *r1_bio, struct bio *bio)
+{
+	int mirror;
+	int raid_disks = r1_bio->mddev->raid_disks;
+
+	for (mirror = 0; mirror < raid_disks; mirror++)
+		if (r1_bio->bios[mirror] == bio)
+			break;
+
+	BUG_ON(mirror == raid_disks);
+	update_head_pos(mirror, r1_bio);
+
+	return mirror;
+}
+
 static void raid1_end_read_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -361,10 +379,7 @@ static void raid1_end_write_request(struct bio *bio, int error)
 	conf_t *conf = r1_bio->mddev->private;
 	struct bio *to_put = NULL;
 
-
-	for (mirror = 0; mirror < conf->raid_disks; mirror++)
-		if (r1_bio->bios[mirror] == bio)
-			break;
+	mirror = find_bio_disk(r1_bio, bio);
 
 	/*
 	 * 'one mirror IO has finished' event handler:
@@ -400,8 +415,6 @@ static void raid1_end_write_request(struct bio *bio, int error)
 		}
 	}
 
-	update_head_pos(mirror, r1_bio);
-
 	if (behind) {
 		if (test_bit(WriteMostly, &conf->mirrors[mirror].rdev->flags))
 			atomic_dec(&r1_bio->behind_remaining);
@@ -1341,13 +1354,10 @@ abort:
 static void end_sync_read(struct bio *bio, int error)
 {
 	r1bio_t *r1_bio = bio->bi_private;
-	int i;
 
-	for (i=r1_bio->mddev->raid_disks; i--; )
-		if (r1_bio->bios[i] == bio)
-			break;
-	BUG_ON(i < 0);
-	update_head_pos(i, r1_bio);
+	/* this will call update_head_pos() */
+	find_bio_disk(r1_bio, bio);
+
 	/*
 	 * we have read a block, now it needs to be re-written,
 	 * or re-read if the read failed.
@@ -1366,16 +1376,12 @@ static void end_sync_write(struct bio *bio, int error)
 	r1bio_t *r1_bio = bio->bi_private;
 	mddev_t *mddev = r1_bio->mddev;
 	conf_t *conf = mddev->private;
-	int i;
 	int mirror=0;
 	sector_t first_bad;
 	int bad_sectors;
 
-	for (i = 0; i < conf->raid_disks; i++)
-		if (r1_bio->bios[i] == bio) {
-			mirror = i;
-			break;
-		}
+	mirror = find_bio_disk(r1_bio, bio);
+
 	if (!uptodate) {
 		sector_t sync_blocks = 0;
 		sector_t s = r1_bio->sector;
@@ -1401,8 +1407,6 @@ static void end_sync_write(struct bio *bio, int error)
 		)
 		set_bit(R1BIO_MadeGood, &r1_bio->state);
 
-	update_head_pos(mirror, r1_bio);
-
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
 		int s = r1_bio->sectors;
 		if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
-- 
1.7.6

