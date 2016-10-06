From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/2] RAID1: ignore discard error
Date: Thu, 6 Oct 2016 14:20:25 -0700
Message-ID: <36b0390e404e6021f2aec98ee87c074eef6dc6bb.1475788662.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, sitsofe@gmail.com, "v3.6" <stable@vger.kernel.org>
List-Id: linux-raid.ids

Sitsofe,
could you try if this patch fixes the issue too please?

Thanks,
Shaohua


If a write error occurs, raid1 will try to rewrite the bio in small
chunk size. If the rewrite fails, raid1 will record the error in bad
block. narrow_write_error will always use WRITE for the bio, but
actually it could be a discard. Since discard bio hasn't payload, write
the bio will cause different issues. But discard error isn't fatal, we
can safely ignore it. This is what this patch does.

This issue should exist since discard is added, but only exposed with
recent arbitrary bio size feature.

Reported-by: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: stable@vger.kernel.org (v3.6)
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid1.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 21dc00e..95bf4cd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -407,11 +407,14 @@ static void raid1_end_write_request(struct bio *bio)
 	struct bio *to_put = NULL;
 	int mirror = find_bio_disk(r1_bio, bio);
 	struct md_rdev *rdev = conf->mirrors[mirror].rdev;
+	bool discard_error;
+
+	discard_error = bio->bi_error && bio_op(bio) == REQ_OP_DISCARD;
 
 	/*
 	 * 'one mirror IO has finished' event handler:
 	 */
-	if (bio->bi_error) {
+	if (bio->bi_error && !discard_error) {
 		set_bit(WriteErrorSeen,	&rdev->flags);
 		if (!test_and_set_bit(WantReplacement, &rdev->flags))
 			set_bit(MD_RECOVERY_NEEDED, &
@@ -448,7 +451,7 @@ static void raid1_end_write_request(struct bio *bio)
 
 		/* Maybe we can clear some bad blocks. */
 		if (is_badblock(rdev, r1_bio->sector, r1_bio->sectors,
-				&first_bad, &bad_sectors)) {
+				&first_bad, &bad_sectors) && !discard_error) {
 			r1_bio->bios[mirror] = IO_MADE_GOOD;
 			set_bit(R1BIO_MadeGood, &r1_bio->state);
 		}
-- 
2.9.3

