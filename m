From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 3/4] md/raid10: abort delayed writes when device fails.
Date: Fri, 04 Nov 2016 16:46:03 +1100
Message-ID: <147823836337.6764.17955870514313168348.stgit@noble>
References: <147823807607.6764.8460942745584467311.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147823807607.6764.8460942745584467311.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When writing to an array with a bitmap enabled, the writes are grouped
in batches which are preceded by an update to the bitmap.

It is quite likely if that a drive develops a problem which is not
media related, that the bitmap write will be the first to report an
error and cause the device to be marked faulty (as the bitmap write is
at the start of a batch).

In this case, there is point submiting the subsequent writes to the
failed device - that just wastes times.

So re-check the Faulty state of a device before submitting a
delayed write.

This requires that we keep the 'rdev', rather than the 'bdev' in the
bio, then swap in the bdev just before final submission.

Reported-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index bf6980ad8c00..225d762d61b7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -855,9 +855,14 @@ static void flush_pending_writes(struct r10conf *conf)
 
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
+			struct md_rdev *rdev = (void*)bio->bi_bdev;
 			bio->bi_next = NULL;
-			if (unlikely((bio_op(bio) ==  REQ_OP_DISCARD) &&
-			    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+			bio->bi_bdev = rdev->bdev;
+			if (test_bit(Faulty, &rdev->flags)) {
+				bio->bi_error = -EIO;
+				bio_endio(bio);
+			} else if (unlikely((bio_op(bio) ==  REQ_OP_DISCARD) &&
+					    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 				/* Just ignore it */
 				bio_endio(bio);
 			else
@@ -1033,9 +1038,14 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
+		struct md_rdev *rdev = (void*)bio->bi_bdev;
 		bio->bi_next = NULL;
-		if (unlikely((bio_op(bio) ==  REQ_OP_DISCARD) &&
-		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+		bio->bi_bdev = rdev->bdev;
+		if (test_bit(Faulty, &rdev->flags)) {
+			bio->bi_error = -EIO;
+			bio_endio(bio);
+		} else if (unlikely((bio_op(bio) ==  REQ_OP_DISCARD) &&
+				    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 			/* Just ignore it */
 			bio_endio(bio);
 		else
@@ -1354,7 +1364,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr+
 					   choose_data_offset(r10_bio,
 							      rdev));
-			mbio->bi_bdev = rdev->bdev;
+			mbio->bi_bdev = (void*)rdev;
 			mbio->bi_end_io	= raid10_end_write_request;
 			bio_set_op_attrs(mbio, op, do_sync | do_fua);
 			mbio->bi_private = r10_bio;
@@ -1396,7 +1406,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr +
 					   choose_data_offset(
 						   r10_bio, rdev));
-			mbio->bi_bdev = rdev->bdev;
+			mbio->bi_bdev = (void*)rdev;
 			mbio->bi_end_io	= raid10_end_write_request;
 			bio_set_op_attrs(mbio, op, do_sync | do_fua);
 			mbio->bi_private = r10_bio;


