From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 2/4] md/raid1: abort delayed writes when device fails.
Date: Fri, 04 Nov 2016 16:46:03 +1100
Message-ID: <147823836318.6764.11299201570249221246.stgit@noble>
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

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 86ecf57ec612..9a73634a99a7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -739,9 +739,14 @@ static void flush_pending_writes(struct r1conf *conf)
 
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
+			struct md_rdev *rdev = (void*)bio->bi_bdev;
 			bio->bi_next = NULL;
-			if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
-			    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+			bio->bi_bdev = rdev->bdev;
+			if (test_bit(Faulty, &rdev->flags)) {
+				bio->bi_error = -EIO;
+				bio_endio(bio);
+			} else if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
+					    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 				/* Just ignore it */
 				bio_endio(bio);
 			else
@@ -1013,9 +1018,14 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
+		struct md_rdev *rdev = (void*)bio->bi_bdev;
 		bio->bi_next = NULL;
-		if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
-		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+		bio->bi_bdev = rdev->bdev;
+		if (test_bit(Faulty, &rdev->flags)) {
+			bio->bi_error = -EIO;
+			bio_endio(bio);
+		} else if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
+				    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 			/* Just ignore it */
 			bio_endio(bio);
 		else
@@ -1354,7 +1364,7 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
 
 		mbio->bi_iter.bi_sector	= (r1_bio->sector +
 				   conf->mirrors[i].rdev->data_offset);
-		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+		mbio->bi_bdev = (void*)conf->mirrors[i].rdev;
 		mbio->bi_end_io	= raid1_end_write_request;
 		bio_set_op_attrs(mbio, op, do_flush_fua | do_sync);
 		mbio->bi_private = r1_bio;


