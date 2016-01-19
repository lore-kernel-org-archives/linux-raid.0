From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Abort pending request for RAID10
Date: Tue, 19 Jan 2016 09:55:26 +0100
Message-ID: <1453193726-4617-1-git-send-email-hare@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-raid.ids

RAID10 delays the write until the bitmap has been updated.
So it really should check if the device is still working
before sending requests, otherwise it'll happily sending
I/O to a known faulty device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/raid10.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d4efed7..74369c2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -902,12 +902,29 @@ static void flush_pending_writes(struct r10conf *conf)
 
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
+			struct r10bio *r10_bio = bio->bi_private;
+			struct md_rdev *rdev = NULL;
+			int dev, slot, repl;
 			bio->bi_next = NULL;
+			dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
+			if (repl)
+				rdev = conf->mirrors[dev].replacement;
+			if (!rdev) {
+				smp_rmb();
+				repl = 0;
+				rdev = conf->mirrors[dev].rdev;
+			}
 			if (unlikely((bio->bi_rw & REQ_DISCARD) &&
 			    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 				/* Just ignore it */
 				bio_endio(bio);
-			else
+			else if (test_bit(Faulty, &rdev->flags)) {
+				if (test_bit(Timeout, &rdev->flags))
+					bio->bi_error = -ETIMEDOUT;
+				else
+					bio->bi_error = -EIO;
+				bio_endio(bio);
+			} else
 				generic_make_request(bio);
 			bio = next;
 		}
@@ -1079,12 +1096,29 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
+		struct r10bio *r10_bio = bio->bi_private;
+		struct md_rdev *rdev = NULL;
+		int dev, slot, repl;
 		bio->bi_next = NULL;
+		dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
+		if (repl)
+			rdev = conf->mirrors[dev].replacement;
+		if (!rdev) {
+			smp_rmb();
+			repl = 0;
+			rdev = conf->mirrors[dev].rdev;
+		}
 		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
 		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 			/* Just ignore it */
 			bio_endio(bio);
-		else
+		else if (test_bit(Faulty, &rdev->flags)) {
+			if (test_bit(Timeout, &rdev->flags))
+				bio->bi_error = -ETIMEDOUT;
+			else
+				bio->bi_error = -EIO;
+			bio_endio(bio);
+		} else
 			generic_make_request(bio);
 		bio = next;
 	}
-- 
1.8.5.6

