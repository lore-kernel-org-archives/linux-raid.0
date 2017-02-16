From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 04/14] block: trace completion of all bios.
Date: Thu, 16 Feb 2017 15:39:01 +1100
Message-ID: <148721994168.7521.13890328144247885071.stgit@noble>
References: <148721992248.7521.17160361058957519076.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148721992248.7521.17160361058957519076.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

Currently only dm and raid5 bios trigger trace_block_bio_complete.
Rather than sprinkling trace calls around all drivers that might
want them, add the trace call to bio_endio() so that all
drivers benefit.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 block/bio.c        |    3 +++
 drivers/md/dm.c    |    1 -
 drivers/md/raid5.c |    8 --------
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 2b375020fc49..984c0afa935a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1813,6 +1813,9 @@ void bio_endio(struct bio *bio)
 		goto again;
 	}
 
+	if (bio->bi_bdev)
+		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
+					 bio, bio->bi_error);
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3086da5664f3..e151aefa0917 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -807,7 +807,6 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio, io_error);
 			bio->bi_error = io_error;
 			bio_endio(bio);
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a6edca65b561..2fbf939c1a15 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4943,8 +4943,6 @@ static void raid5_align_endio(struct bio *bi)
 	rdev_dec_pending(rdev, conf->mddev);
 
 	if (!error) {
-		trace_block_bio_complete(bdev_get_queue(raid_bi->bi_bdev),
-					 raid_bi, 0);
 		bio_endio(raid_bi);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_quiescent);
@@ -5510,10 +5508,6 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 		md_write_end(mddev);
 	remaining = raid5_dec_bi_active_stripes(bi);
 	if (remaining == 0) {
-
-
-		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
-					 bi, 0);
 		bio_endio(bi);
 	}
 }
@@ -5921,8 +5915,6 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 	}
 	remaining = raid5_dec_bi_active_stripes(raid_bio);
 	if (remaining == 0) {
-		trace_block_bio_complete(bdev_get_queue(raid_bio->bi_bdev),
-					 raid_bio, 0);
 		bio_endio(raid_bio);
 	}
 	if (atomic_dec_and_test(&conf->active_aligned_reads))


