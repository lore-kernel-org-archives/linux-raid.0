From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 10/18] md/raid1: small cleanup in
 raid1_end_read/write_request
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.51668.stgit@noble>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Both functions use conf->mirrors[mirror].rdev several times, so
improve readability by storing this in a local variable.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c |   35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a54edbe741ff..9585a6b62123 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -319,14 +319,13 @@ static void raid1_end_read_request(struct bio *bio)
 {
 	int uptodate = !bio->bi_error;
 	struct r1bio *r1_bio = bio->bi_private;
-	int mirror;
 	struct r1conf *conf = r1_bio->mddev->private;
+	struct md_rdev *rdev = conf->mirrors[r1_bio->read_disk].rdev;
 
-	mirror = r1_bio->read_disk;
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	update_head_pos(mirror, r1_bio);
+	update_head_pos(r1_bio->read_disk, r1_bio);
 
 	if (uptodate)
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
@@ -339,14 +338,14 @@ static void raid1_end_read_request(struct bio *bio)
 		spin_lock_irqsave(&conf->device_lock, flags);
 		if (r1_bio->mddev->degraded == conf->raid_disks ||
 		    (r1_bio->mddev->degraded == conf->raid_disks-1 &&
-		     test_bit(In_sync, &conf->mirrors[mirror].rdev->flags)))
+		     test_bit(In_sync, &rdev->flags)))
 			uptodate = 1;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 
 	if (uptodate) {
 		raid_end_bio_io(r1_bio);
-		rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
+		rdev_dec_pending(rdev, conf->mddev);
 	} else {
 		/*
 		 * oops, read error:
@@ -356,7 +355,7 @@ static void raid1_end_read_request(struct bio *bio)
 			KERN_ERR "md/raid1:%s: %s: "
 			"rescheduling sector %llu\n",
 			mdname(conf->mddev),
-			bdevname(conf->mirrors[mirror].rdev->bdev,
+			bdevname(rdev->bdev,
 				 b),
 			(unsigned long long)r1_bio->sector);
 		set_bit(R1BIO_ReadError, &r1_bio->state);
@@ -403,20 +402,18 @@ static void r1_bio_write_done(struct r1bio *r1_bio)
 static void raid1_end_write_request(struct bio *bio)
 {
 	struct r1bio *r1_bio = bio->bi_private;
-	int mirror, behind = test_bit(R1BIO_BehindIO, &r1_bio->state);
+	int behind = test_bit(R1BIO_BehindIO, &r1_bio->state);
 	struct r1conf *conf = r1_bio->mddev->private;
 	struct bio *to_put = NULL;
-
-	mirror = find_bio_disk(r1_bio, bio);
+	int mirror = find_bio_disk(r1_bio, bio);
+	struct md_rdev *rdev = conf->mirrors[mirror].rdev;
 
 	/*
 	 * 'one mirror IO has finished' event handler:
 	 */
 	if (bio->bi_error) {
-		set_bit(WriteErrorSeen,
-			&conf->mirrors[mirror].rdev->flags);
-		if (!test_and_set_bit(WantReplacement,
-				      &conf->mirrors[mirror].rdev->flags))
+		set_bit(WriteErrorSeen,	&rdev->flags);
+		if (!test_and_set_bit(WantReplacement, &rdev->flags))
 			set_bit(MD_RECOVERY_NEEDED, &
 				conf->mddev->recovery);
 
@@ -445,13 +442,12 @@ static void raid1_end_write_request(struct bio *bio)
 		 * before rdev->recovery_offset, but for simplicity we don't
 		 * check this here.
 		 */
-		if (test_bit(In_sync, &conf->mirrors[mirror].rdev->flags) &&
-		    !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags))
+		if (test_bit(In_sync, &rdev->flags) &&
+		    !test_bit(Faulty, &rdev->flags))
 			set_bit(R1BIO_Uptodate, &r1_bio->state);
 
 		/* Maybe we can clear some bad blocks. */
-		if (is_badblock(conf->mirrors[mirror].rdev,
-				r1_bio->sector, r1_bio->sectors,
+		if (is_badblock(rdev, r1_bio->sector, r1_bio->sectors,
 				&first_bad, &bad_sectors)) {
 			r1_bio->bios[mirror] = IO_MADE_GOOD;
 			set_bit(R1BIO_MadeGood, &r1_bio->state);
@@ -459,7 +455,7 @@ static void raid1_end_write_request(struct bio *bio)
 	}
 
 	if (behind) {
-		if (test_bit(WriteMostly, &conf->mirrors[mirror].rdev->flags))
+		if (test_bit(WriteMostly, &rdev->flags))
 			atomic_dec(&r1_bio->behind_remaining);
 
 		/*
@@ -483,8 +479,7 @@ static void raid1_end_write_request(struct bio *bio)
 		}
 	}
 	if (r1_bio->bios[mirror] == NULL)
-		rdev_dec_pending(conf->mirrors[mirror].rdev,
-				 conf->mddev);
+		rdev_dec_pending(rdev, conf->mddev);
 
 	/*
 	 * Let's see if all mirrored write operations have finished


