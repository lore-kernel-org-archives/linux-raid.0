From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 04/15] block: trace completion of all bios.
Date: Wed, 15 Mar 2017 14:05:12 +1100
Message-ID: <148954711268.18641.886158972745590154.stgit@noble>
References: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954692173.18641.1294690639716682540.stgit@noble>
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
index 5eec5e08417f..c89d83b3ca32 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1838,6 +1838,9 @@ void bio_endio(struct bio *bio)
 		goto again;
 	}
 
+	if (bio->bi_bdev)
+		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
+					 bio, bio->bi_error);
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f4ffd1eb8f44..f5f09ace690a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -810,7 +810,6 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio, io_error);
 			bio->bi_error = io_error;
 			bio_endio(bio);
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f07cd105b9f9..7a45045ab358 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5141,8 +5141,6 @@ static void raid5_align_endio(struct bio *bi)
 	rdev_dec_pending(rdev, conf->mddev);
 
 	if (!error) {
-		trace_block_bio_complete(bdev_get_queue(raid_bi->bi_bdev),
-					 raid_bi, 0);
 		bio_endio(raid_bi);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_quiescent);
@@ -5727,10 +5725,6 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
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
@@ -6138,8 +6132,6 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 	}
 	remaining = raid5_dec_bi_active_stripes(raid_bio);
 	if (remaining == 0) {
-		trace_block_bio_complete(bdev_get_queue(raid_bio->bi_bdev),
-					 raid_bio, 0);
 		bio_endio(raid_bio);
 	}
 	if (atomic_dec_and_test(&conf->active_aligned_reads))


