From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 05/14] md/raid5: use bio_inc_remaining() instead of
 repurposing bi_phys_segments as a counter
Date: Thu, 16 Feb 2017 15:39:02 +1100
Message-ID: <148721994186.7521.166749737864172676.stgit@noble>
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

md/raid5 needs to keep track of how many stripe_heads are processing a
bio so that it can delay calling bio_endio() until all stripe_heads
have completed.  It currently uses 16 bits of ->bi_phys_segments for
this purpose.

16 bits is only enough for 256M requests, and it is possible for a
single bio to be larger than this, which causes problems.  Also, the
bio struct contains a larger counter, __bi_remaining, which has a
purpose very similar to the purpose of our counter.  So stop using
->bi_phys_segments, and instead use __bi_remaining.

This means we don't need to initialize the counter, as our caller
initializes it to '1'.  It also means we can call bio_endio() directly
as it tests this counter internally.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5-cache.c |    3 +--
 drivers/md/raid5.c       |   50 +++++++++++-----------------------------------
 drivers/md/raid5.h       |   17 +---------------
 3 files changed, 14 insertions(+), 56 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 1b972a172800..5c282ae71cbd 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -265,8 +265,7 @@ r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev)
 	       dev->sector + STRIPE_SECTORS) {
 		wbi2 = r5_next_bio(wbi, dev->sector);
 		md_write_end(conf->mddev);
-		if (!raid5_dec_bi_active_stripes(wbi))
-			bio_endio(wbi);
+		bio_endio(wbi);
 		wbi = wbi2;
 	}
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2fbf939c1a15..905abf081acf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1187,8 +1187,7 @@ static void ops_complete_biofill(void *stripe_head_ref)
 			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				rbi2 = r5_next_bio(rbi, dev->sector);
-				if (!raid5_dec_bi_active_stripes(rbi))
-					bio_endio(rbi);
+				bio_endio(rbi);
 				rbi = rbi2;
 			}
 		}
@@ -3027,14 +3026,6 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 		(unsigned long long)bi->bi_iter.bi_sector,
 		(unsigned long long)sh->sector);
 
-	/*
-	 * If several bio share a stripe. The bio bi_phys_segments acts as a
-	 * reference count to avoid race. The reference count should already be
-	 * increased before this function is called (for example, in
-	 * raid5_make_request()), so other bio sharing this stripe will not free the
-	 * stripe. If a stripe is owned by one stripe, the stripe lock will
-	 * protect it.
-	 */
 	spin_lock_irq(&sh->stripe_lock);
 	/* Don't allow new IO added to stripes in batch list */
 	if (sh->batch_head)
@@ -3060,7 +3051,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 	if (*bip)
 		bi->bi_next = *bip;
 	*bip = bi;
-	raid5_inc_bi_active_stripes(bi);
+	bio_inc_remaining(bi);
 	md_write_start(conf->mddev, bi);
 
 	if (forwrite) {
@@ -3185,8 +3176,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 
 			bi->bi_error = -EIO;
 			md_write_end(conf->mddev);
-			if (!raid5_dec_bi_active_stripes(bi))
-				bio_endio(bi);
+			bio_endio(bi);
 			bi = nextbi;
 		}
 		if (bitmap_end)
@@ -3208,8 +3198,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 
 			bi->bi_error = -EIO;
 			md_write_end(conf->mddev);
-			if (!raid5_dec_bi_active_stripes(bi))
-				bio_endio(bi);
+			bio_endio(bi);
 			bi = bi2;
 		}
 
@@ -3234,8 +3223,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 					r5_next_bio(bi, sh->dev[i].sector);
 
 				bi->bi_error = -EIO;
-				if (!raid5_dec_bi_active_stripes(bi))
-					bio_endio(bi);
+				bio_endio(bi);
 				bi = nextbi;
 			}
 		}
@@ -3567,8 +3555,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					dev->sector + STRIPE_SECTORS) {
 					wbi2 = r5_next_bio(wbi, dev->sector);
 					md_write_end(conf->mddev);
-					if (!raid5_dec_bi_active_stripes(wbi))
-						bio_endio(wbi);
+					bio_endio(wbi);
 					wbi = wbi2;
 				}
 				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
@@ -4913,7 +4900,7 @@ static struct bio *remove_bio_from_retry(struct r5conf *conf)
 		 * this sets the active strip count to 1 and the processed
 		 * strip count to zero (upper 8 bits)
 		 */
-		raid5_set_bi_stripes(bi, 1); /* biased count of active stripes */
+		raid5_set_bi_processed_stripes(bi, 0);
 	}
 
 	return bi;
@@ -5228,7 +5215,6 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	struct r5conf *conf = mddev->private;
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
-	int remaining;
 	int stripe_sectors;
 
 	if (mddev->reshape_position != MaxSector)
@@ -5239,7 +5225,6 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	last_sector = bi->bi_iter.bi_sector + (bi->bi_iter.bi_size>>9);
 
 	bi->bi_next = NULL;
-	bi->bi_phys_segments = 1; /* over-loaded to count active stripes */
 	md_write_start(mddev, bi);
 
 	stripe_sectors = conf->chunk_sectors *
@@ -5286,7 +5271,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 				continue;
 			sh->dev[d].towrite = bi;
 			set_bit(R5_OVERWRITE, &sh->dev[d].flags);
-			raid5_inc_bi_active_stripes(bi);
+			bio_inc_remaining(bi);
 			md_write_start(mddev, bi);
 			sh->overwrite_disks++;
 		}
@@ -5311,10 +5296,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	}
 
 	md_write_end(mddev);
-	remaining = raid5_dec_bi_active_stripes(bi);
-	if (remaining == 0) {
-		bio_endio(bi);
-	}
+	bio_endio(bi);
 }
 
 static void raid5_make_request(struct mddev *mddev, struct bio * bi)
@@ -5325,7 +5307,6 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 	const int rw = bio_data_dir(bi);
-	int remaining;
 	DEFINE_WAIT(w);
 	bool do_prepare;
 	bool do_flush = false;
@@ -5368,7 +5349,6 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bio_end_sector(bi);
 	bi->bi_next = NULL;
-	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
 	md_write_start(mddev, bi);
 
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
@@ -5506,10 +5486,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 
 	if (rw == WRITE)
 		md_write_end(mddev);
-	remaining = raid5_dec_bi_active_stripes(bi);
-	if (remaining == 0) {
-		bio_endio(bi);
-	}
+	bio_endio(bi);
 }
 
 static sector_t raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks);
@@ -5874,7 +5851,6 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 	int dd_idx;
 	sector_t sector, logical_sector, last_sector;
 	int scnt = 0;
-	int remaining;
 	int handled = 0;
 
 	logical_sector = raid_bio->bi_iter.bi_sector &
@@ -5913,10 +5889,8 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 		raid5_release_stripe(sh);
 		handled++;
 	}
-	remaining = raid5_dec_bi_active_stripes(raid_bio);
-	if (remaining == 0) {
-		bio_endio(raid_bio);
-	}
+	bio_endio(raid_bio);
+
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
 		wake_up(&conf->wait_for_quiescent);
 	return handled;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 9051631cb7f0..3018a33693ab 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -481,8 +481,7 @@ static inline struct bio *r5_next_bio(struct bio *bio, sector_t sector)
 }
 
 /*
- * We maintain a biased count of active stripes in the bottom 16 bits of
- * bi_phys_segments, and a count of processed stripes in the upper 16 bits
+ * We maintain a count of processed stripes in the upper 16 bits
  */
 static inline int raid5_bi_processed_stripes(struct bio *bio)
 {
@@ -491,20 +490,6 @@ static inline int raid5_bi_processed_stripes(struct bio *bio)
 	return (atomic_read(segments) >> 16) & 0xffff;
 }
 
-static inline int raid5_dec_bi_active_stripes(struct bio *bio)
-{
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
-
-	return atomic_sub_return(1, segments) & 0xffff;
-}
-
-static inline void raid5_inc_bi_active_stripes(struct bio *bio)
-{
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
-
-	atomic_inc(segments);
-}
-
 static inline void raid5_set_bi_processed_stripes(struct bio *bio,
 	unsigned int cnt)
 {


