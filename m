From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 5/5] md/raid5: use bio_inc_remaining() instead of
 repurposing bi_phys_segments as a counter
Date: Mon, 21 Nov 2016 12:19:43 +1100
Message-ID: <147969118374.5434.16171178480587828937.stgit@noble>
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
 drivers/md/raid5.c |   68 +++++++++++-----------------------------------------
 1 file changed, 14 insertions(+), 54 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6f3154c80fbf..7169420bfde5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -154,18 +154,6 @@ static inline int raid5_bi_processed_stripes(struct bio *bio)
 	return (atomic_read(segments) >> 16) & 0xffff;
 }
 
-static inline int raid5_dec_bi_active_stripes(struct bio *bio)
-{
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
-	return atomic_sub_return(1, segments) & 0xffff;
-}
-
-static inline void raid5_inc_bi_active_stripes(struct bio *bio)
-{
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
-	atomic_inc(segments);
-}
-
 static inline void raid5_set_bi_processed_stripes(struct bio *bio,
 	unsigned int cnt)
 {
@@ -178,12 +166,6 @@ static inline void raid5_set_bi_processed_stripes(struct bio *bio,
 	} while (atomic_cmpxchg(segments, old, new) != old);
 }
 
-static inline void raid5_set_bi_stripes(struct bio *bio, unsigned int cnt)
-{
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
-	atomic_set(segments, cnt);
-}
-
 /* Find first data disk in a raid6 stripe */
 static inline int raid6_d0(struct stripe_head *sh)
 {
@@ -1190,8 +1172,7 @@ static void ops_complete_biofill(void *stripe_head_ref)
 			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				rbi2 = r5_next_bio(rbi, dev->sector);
-				if (!raid5_dec_bi_active_stripes(rbi))
-					bio_endio(rbi);
+				bio_endio(rbi);
 				rbi = rbi2;
 			}
 		}
@@ -2983,7 +2964,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 	if (*bip)
 		bi->bi_next = *bip;
 	*bip = bi;
-	raid5_inc_bi_active_stripes(bi);
+	bio_inc_remaining(bi);
 	md_write_start(conf->mddev, bi);
 
 	if (forwrite) {
@@ -3108,8 +3089,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 
 			bi->bi_error = -EIO;
 			md_write_end(conf->mddev);
-			if (!raid5_dec_bi_active_stripes(bi))
-				bio_endio(bi);
+			bio_endio(bi);
 			bi = nextbi;
 		}
 		if (bitmap_end)
@@ -3131,8 +3111,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 
 			bi->bi_error = -EIO;
 			md_write_end(conf->mddev);
-			if (!raid5_dec_bi_active_stripes(bi))
-				bio_endio(bi);
+			bio_endio(bi);
 			bi = bi2;
 		}
 
@@ -3157,8 +3136,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 					r5_next_bio(bi, sh->dev[i].sector);
 
 				bi->bi_error = -EIO;
-				if (!raid5_dec_bi_active_stripes(bi))
-					bio_endio(bi);
+				bio_endio(bi);
 				bi = nextbi;
 			}
 		}
@@ -3475,8 +3453,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					dev->sector + STRIPE_SECTORS) {
 					wbi2 = r5_next_bio(wbi, dev->sector);
 					md_write_end(conf->mddev);
-					if (!raid5_dec_bi_active_stripes(wbi))
-						bio_endio(wbi);
+					bio_endio(wbi);
 					wbi = wbi2;
 				}
 				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
@@ -4719,7 +4696,7 @@ static struct bio *remove_bio_from_retry(struct r5conf *conf)
 		 * this sets the active strip count to 1 and the processed
 		 * strip count to zero (upper 8 bits)
 		 */
-		raid5_set_bi_stripes(bi, 1); /* biased count of active stripes */
+		raid5_set_bi_processed_stripes(bi, 0);
 	}
 
 	return bi;
@@ -5036,7 +5013,6 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	struct r5conf *conf = mddev->private;
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
-	int remaining;
 	int stripe_sectors;
 
 	if (mddev->reshape_position != MaxSector)
@@ -5047,7 +5023,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	last_sector = bi->bi_iter.bi_sector + (bi->bi_iter.bi_size>>9);
 
 	bi->bi_next = NULL;
-	bi->bi_phys_segments = 1; /* over-loaded to count active stripes */
+	bi->bi_phys_segments = 0;
 
 	stripe_sectors = conf->chunk_sectors *
 		(conf->raid_disks - conf->max_degraded);
@@ -5093,7 +5069,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 				continue;
 			sh->dev[d].towrite = bi;
 			set_bit(R5_OVERWRITE, &sh->dev[d].flags);
-			raid5_inc_bi_active_stripes(bi);
+			bio_inc_remaining(bi);
 			sh->overwrite_disks++;
 		}
 		spin_unlock_irq(&sh->stripe_lock);
@@ -5117,10 +5093,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	}
 
 	md_write_end(mddev);
-	remaining = raid5_dec_bi_active_stripes(bi);
-	if (remaining == 0) {
-		bio_endio(bi);
-	}
+	bio_endio(bi);
 }
 
 static void raid5_make_request(struct mddev *mddev, struct bio * bi)
@@ -5131,7 +5104,6 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 	const int rw = bio_data_dir(bi);
-	int remaining;
 	DEFINE_WAIT(w);
 	bool do_prepare;
 
@@ -5167,7 +5139,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bio_end_sector(bi);
 	bi->bi_next = NULL;
-	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
+	bi->bi_phys_segments = 0;
 	md_write_start(mddev, bi);
 
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
@@ -5299,14 +5271,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 
 	if (rw == WRITE)
 		md_write_end(mddev);
-	remaining = raid5_dec_bi_active_stripes(bi);
-	if (remaining == 0) {
-
-
-		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
-					 bi, 0);
-		bio_endio(bi);
-	}
+	bio_endio(bi);
 }
 
 static sector_t raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks);
@@ -5671,7 +5636,6 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 	int dd_idx;
 	sector_t sector, logical_sector, last_sector;
 	int scnt = 0;
-	int remaining;
 	int handled = 0;
 
 	logical_sector = raid_bio->bi_iter.bi_sector &
@@ -5710,12 +5674,8 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 		raid5_release_stripe(sh);
 		handled++;
 	}
-	remaining = raid5_dec_bi_active_stripes(raid_bio);
-	if (remaining == 0) {
-		trace_block_bio_complete(bdev_get_queue(raid_bio->bi_bdev),
-					 raid_bio, 0);
-		bio_endio(raid_bio);
-	}
+	bio_endio(raid_bio);
+
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
 		wake_up(&conf->wait_for_quiescent);
 	return handled;


