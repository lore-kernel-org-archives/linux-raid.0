From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 10/13] md: raid10: refactor code of read reshape's .bi_end_io
Date: Tue, 28 Feb 2017 23:41:40 +0800
Message-ID: <1488296503-4987-11-git-send-email-tom.leiming@gmail.com>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

reshape read request is a bit special and requires one extra
bio which isn't allocated from r10buf_pool.

Refactor the .bi_end_io for read reshape, so that we can use
raid10's resync page mangement approach easily in the following
patches.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid10.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c5f1a117494b..a9ddd4f14008 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1907,17 +1907,9 @@ static int raid10_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	return err;
 }
 
-static void end_sync_read(struct bio *bio)
+static void __end_sync_read(struct r10bio *r10_bio, struct bio *bio, int d)
 {
-	struct r10bio *r10_bio = bio->bi_private;
 	struct r10conf *conf = r10_bio->mddev->private;
-	int d;
-
-	if (bio == r10_bio->master_bio) {
-		/* this is a reshape read */
-		d = r10_bio->read_slot; /* really the read dev */
-	} else
-		d = find_bio_disk(conf, r10_bio, bio, NULL, NULL);
 
 	if (!bio->bi_error)
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
@@ -1941,6 +1933,22 @@ static void end_sync_read(struct bio *bio)
 	}
 }
 
+static void end_sync_read(struct bio *bio)
+{
+	struct r10bio *r10_bio = bio->bi_private;
+	struct r10conf *conf = r10_bio->mddev->private;
+	int d = find_bio_disk(conf, r10_bio, bio, NULL, NULL);
+
+	__end_sync_read(r10_bio, bio, d);
+}
+
+static void end_reshape_read(struct bio *bio)
+{
+	struct r10bio *r10_bio = bio->bi_private;
+
+	__end_sync_read(r10_bio, bio, r10_bio->read_slot);
+}
+
 static void end_sync_request(struct r10bio *r10_bio)
 {
 	struct mddev *mddev = r10_bio->mddev;
@@ -4464,7 +4472,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	read_bio->bi_iter.bi_sector = (r10_bio->devs[r10_bio->read_slot].addr
 			       + rdev->data_offset);
 	read_bio->bi_private = r10_bio;
-	read_bio->bi_end_io = end_sync_read;
+	read_bio->bi_end_io = end_reshape_read;
 	bio_set_op_attrs(read_bio, REQ_OP_READ, 0);
 	read_bio->bi_flags &= (~0UL << BIO_RESET_BITS);
 	read_bio->bi_error = 0;
-- 
2.7.4

