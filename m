From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 2/5] md/raid5: use md_write_start to count stripes,
 not bios
Date: Mon, 21 Nov 2016 12:19:43 +1100
Message-ID: <147969118330.5434.9548726247224162889.stgit@noble>
References: <147969099621.5434.12384452255155063186.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147969099621.5434.12384452255155063186.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We use md_write_start() to increase the count of pending writes, and
md_write_end() to decrement the count.  We currently count bios
submitted to md/raid5.  Change it count stripe_heads that a WRITE bio
has been attached to.

So raid5_make_request() call md_write_start() and then md_write_end().
add_stripe_bio() calls md_write_start() for each stripe_head, and the
completion routines always call md_write_end(), instead of only
calling when raid5_dec_bi_active_stripes() returns 0.

This reduces our dependence on keeping a per-bio count of active
stripes in bi_phys_segments.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index df88656d8798..d07d2dce6856 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2998,6 +2998,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 		bi->bi_next = *bip;
 	*bip = bi;
 	raid5_inc_bi_active_stripes(bi);
+	md_write_start(conf->mddev, bi);
 
 	if (forwrite) {
 		/* check if page is covered */
@@ -3121,10 +3122,9 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
 
 			bi->bi_error = -EIO;
-			if (!raid5_dec_bi_active_stripes(bi)) {
-				md_write_end(conf->mddev);
+			md_write_end(conf->mddev);
+			if (!raid5_dec_bi_active_stripes(bi))
 				bio_list_add(return_bi, bi);
-			}
 			bi = nextbi;
 		}
 		if (bitmap_end)
@@ -3145,10 +3145,9 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
 
 			bi->bi_error = -EIO;
-			if (!raid5_dec_bi_active_stripes(bi)) {
-				md_write_end(conf->mddev);
+			md_write_end(conf->mddev);
+			if (!raid5_dec_bi_active_stripes(bi))
 				bio_list_add(return_bi, bi);
-			}
 			bi = bi2;
 		}
 
@@ -3490,10 +3489,9 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 				while (wbi && wbi->bi_iter.bi_sector <
 					dev->sector + STRIPE_SECTORS) {
 					wbi2 = r5_next_bio(wbi, dev->sector);
-					if (!raid5_dec_bi_active_stripes(wbi)) {
-						md_write_end(conf->mddev);
+					md_write_end(conf->mddev);
+					if (!raid5_dec_bi_active_stripes(wbi))
 						bio_list_add(return_bi, wbi);
-					}
 					wbi = wbi2;
 				}
 				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
@@ -5142,9 +5140,9 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		release_stripe_plug(mddev, sh);
 	}
 
+	md_write_end(mddev);
 	remaining = raid5_dec_bi_active_stripes(bi);
 	if (remaining == 0) {
-		md_write_end(mddev);
 		bio_endio(bi);
 	}
 }
@@ -5173,8 +5171,6 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 		/* ret == -EAGAIN, fallback */
 	}
 
-	md_write_start(mddev, bi);
-
 	/*
 	 * If array is degraded, better not do chunk aligned read because
 	 * later we might have to read it again in order to reconstruct
@@ -5196,6 +5192,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	last_sector = bio_end_sector(bi);
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
+	md_write_start(mddev, bi);
 
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
@@ -5324,11 +5321,11 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	}
 	finish_wait(&conf->wait_for_overlap, &w);
 
+	if (rw == WRITE)
+		md_write_end(mddev);
 	remaining = raid5_dec_bi_active_stripes(bi);
 	if (remaining == 0) {
 
-		if ( rw == WRITE )
-			md_write_end(mddev);
 
 		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
 					 bi, 0);


