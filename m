From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 6/6] md/raid10: add failfast handling for writes.
Date: Fri, 18 Nov 2016 16:16:12 +1100
Message-ID: <147944617232.3302.5972602394915577151.stgit@noble>
References: <147944614789.3302.1959091446949640579.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147944614789.3302.1959091446949640579.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-raid.ids

When writing to a fastfail device, we use MD_FASTFAIL unless
it is the only device being written to.  For
resync/recovery, assume there was a working device to read
from so always use MD_FASTFAIL.

If a write for resync/recovery fails, we just fail the
device - there is not much else to do.

If a normal write fails, but the device cannot be marked
Faulty (must be only one left), we queue for write error
handling which calls narrow_write_error() to write the block
synchronously without any failfast flags.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 99fa1b980371..c191d00055d0 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -100,6 +100,7 @@ static int max_queued_requests = 1024;
 static void allow_barrier(struct r10conf *conf);
 static void lower_barrier(struct r10conf *conf);
 static int _enough(struct r10conf *conf, int previous, int ignore);
+static int enough(struct r10conf *conf, int ignore);
 static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 				int *skipped);
 static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio);
@@ -451,6 +452,7 @@ static void raid10_end_write_request(struct bio *bio)
 	struct r10conf *conf = r10_bio->mddev->private;
 	int slot, repl;
 	struct md_rdev *rdev = NULL;
+	struct bio *to_put = NULL;
 	bool discard_error;
 
 	discard_error = bio->bi_error && bio_op(bio) == REQ_OP_DISCARD;
@@ -478,8 +480,24 @@ static void raid10_end_write_request(struct bio *bio)
 			if (!test_and_set_bit(WantReplacement, &rdev->flags))
 				set_bit(MD_RECOVERY_NEEDED,
 					&rdev->mddev->recovery);
-			set_bit(R10BIO_WriteError, &r10_bio->state);
+
 			dec_rdev = 0;
+			if (test_bit(FailFast, &rdev->flags) &&
+			    (bio->bi_opf & MD_FAILFAST)) {
+				md_error(rdev->mddev, rdev);
+				if (!test_bit(Faulty, &rdev->flags))
+					/* This is the only remaining device,
+					 * We need to retry the write without
+					 * FailFast
+					 */
+					set_bit(R10BIO_WriteError, &r10_bio->state);
+				else {
+					r10_bio->devs[slot].bio = NULL;
+					to_put = bio;
+					dec_rdev = 1;
+				}
+			} else
+				set_bit(R10BIO_WriteError, &r10_bio->state);
 		}
 	} else {
 		/*
@@ -529,6 +547,8 @@ static void raid10_end_write_request(struct bio *bio)
 	one_write_done(r10_bio);
 	if (dec_rdev)
 		rdev_dec_pending(rdev, conf->mddev);
+	if (to_put)
+		bio_put(to_put);
 }
 
 /*
@@ -1391,6 +1411,9 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
 			bio_set_op_attrs(mbio, op, do_sync | do_fua);
+			if (test_bit(FailFast, &conf->mirrors[d].rdev->flags) &&
+			    enough(conf, d))
+				mbio->bi_opf |= MD_FAILFAST;
 			mbio->bi_private = r10_bio;
 
 			if (conf->mddev->gendisk)
@@ -2051,6 +2074,8 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		atomic_inc(&r10_bio->remaining);
 		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(tbio));
 
+		if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
+			tbio->bi_opf |= MD_FAILFAST;
 		tbio->bi_iter.bi_sector += conf->mirrors[d].rdev->data_offset;
 		tbio->bi_bdev = conf->mirrors[d].rdev->bdev;
 		generic_make_request(tbio);
@@ -3340,6 +3365,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_write;
 			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+			if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
+				bio->bi_opf |= MD_FAILFAST;
 			bio->bi_iter.bi_sector = sector + rdev->data_offset;
 			bio->bi_bdev = rdev->bdev;
 			count++;


