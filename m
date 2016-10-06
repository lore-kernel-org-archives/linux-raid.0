From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/2] RAID10: ignore discard error
Date: Thu, 6 Oct 2016 14:20:26 -0700
Message-ID: <b5d38675aed142807e25fde1dc5b11a5d31dad71.1475788662.git.shli@fb.com>
References: <36b0390e404e6021f2aec98ee87c074eef6dc6bb.1475788662.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <36b0390e404e6021f2aec98ee87c074eef6dc6bb.1475788662.git.shli@fb.com>
Sender: stable-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, sitsofe@gmail.com, "v3.6" <stable@vger.kernel.org>
List-Id: linux-raid.ids

This is the counterpart of raid10 fix. If a write error occurs, raid10
will try to rewrite the bio in small chunk size. If the rewrite fails,
raid10 will record the error in bad block. narrow_write_error will
always use WRITE for the bio, but actually it could be a discard. Since
discard bio hasn't payload, write the bio will cause different issues.
But discard error isn't fatal, we can safely ignore it. This is what
this patch does.

This issue should exist since discard is added, but only exposed with
recent arbitrary bio size feature.

Cc: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: stable@vger.kernel.org (v3.6)
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid10.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index be1a9fc..39fddda 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -447,6 +447,9 @@ static void raid10_end_write_request(struct bio *bio)
 	struct r10conf *conf = r10_bio->mddev->private;
 	int slot, repl;
 	struct md_rdev *rdev = NULL;
+	bool discard_error;
+
+	discard_error = bio->bi_error && bio_op(bio) == REQ_OP_DISCARD;
 
 	dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
 
@@ -460,7 +463,7 @@ static void raid10_end_write_request(struct bio *bio)
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (bio->bi_error) {
+	if (bio->bi_error && !discard_error) {
 		if (repl)
 			/* Never record new bad blocks to replacement,
 			 * just fail it.
@@ -503,7 +506,7 @@ static void raid10_end_write_request(struct bio *bio)
 		if (is_badblock(rdev,
 				r10_bio->devs[slot].addr,
 				r10_bio->sectors,
-				&first_bad, &bad_sectors)) {
+				&first_bad, &bad_sectors) && !discard_error) {
 			bio_put(bio);
 			if (repl)
 				r10_bio->devs[slot].repl_bio = IO_MADE_GOOD;
-- 
2.9.3
