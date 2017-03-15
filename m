From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 03/15] md/raid5: call bio_endio() directly rather than
 queueing for later.
Date: Wed, 15 Mar 2017 14:05:12 +1100
Message-ID: <148954711248.18641.15143601385940046479.stgit@noble>
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

We currently gather bios that need to be returned into a bio_list
and call bio_endio() on them all together.
The original reason for this was to avoid making the calls while
holding a spinlock.
Locking has changed a lot since then, and that reason is no longer
valid.

So discard return_io() and various return_bi lists, and just call
bio_endio() directly as needed.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5-cache.c |   13 +++++--------
 drivers/md/raid5-log.h   |    2 +-
 drivers/md/raid5.c       |   38 ++++++++++----------------------------
 drivers/md/raid5.h       |    1 -
 4 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index f5034ecb4e94..5be8dbc5d91b 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -308,8 +308,7 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 }
 
 static void
-r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev,
-			      struct bio_list *return_bi)
+r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev)
 {
 	struct bio *wbi, *wbi2;
 
@@ -319,23 +318,21 @@ r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev,
 	       dev->sector + STRIPE_SECTORS) {
 		wbi2 = r5_next_bio(wbi, dev->sector);
 		md_write_end(conf->mddev);
-		if (!raid5_dec_bi_active_stripes(wbi)) {
-			bio_list_add(return_bi, wbi);
-		}
+		if (!raid5_dec_bi_active_stripes(wbi))
+			bio_endio(wbi);
 		wbi = wbi2;
 	}
 }
 
 void r5c_handle_cached_data_endio(struct r5conf *conf,
-	  struct stripe_head *sh, int disks, struct bio_list *return_bi)
+				  struct stripe_head *sh, int disks)
 {
 	int i;
 
 	for (i = sh->disks; i--; ) {
 		if (sh->dev[i].written) {
 			set_bit(R5_UPTODATE, &sh->dev[i].flags);
-			r5c_return_dev_pending_writes(conf, &sh->dev[i],
-						      return_bi);
+			r5c_return_dev_pending_writes(conf, &sh->dev[i]);
 			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
 					STRIPE_SECTORS,
 					!test_bit(STRIPE_DEGRADED, &sh->state),
diff --git a/drivers/md/raid5-log.h b/drivers/md/raid5-log.h
index 4f5a0f4e0b1f..738930ff5d17 100644
--- a/drivers/md/raid5-log.h
+++ b/drivers/md/raid5-log.h
@@ -21,7 +21,7 @@ extern void r5c_release_extra_page(struct stripe_head *sh);
 extern void r5c_use_extra_page(struct stripe_head *sh);
 extern void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
 extern void r5c_handle_cached_data_endio(struct r5conf *conf,
-	struct stripe_head *sh, int disks, struct bio_list *return_bi);
+	struct stripe_head *sh, int disks);
 extern int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh);
 extern void r5c_make_stripe_write_out(struct stripe_head *sh);
 extern void r5c_flush_cache(struct r5conf *conf, int num);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f990f74901d2..f07cd105b9f9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -158,17 +158,6 @@ static int raid6_idx_to_slot(int idx, struct stripe_head *sh,
 	return slot;
 }
 
-static void return_io(struct bio_list *return_bi)
-{
-	struct bio *bi;
-	while ((bi = bio_list_pop(return_bi)) != NULL) {
-		bi->bi_iter.bi_size = 0;
-		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
-					 bi, 0);
-		bio_endio(bi);
-	}
-}
-
 static void print_raid5_conf (struct r5conf *conf);
 
 static int stripe_operations_active(struct stripe_head *sh)
@@ -1310,7 +1299,6 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 static void ops_complete_biofill(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	struct bio_list return_bi = BIO_EMPTY_LIST;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
@@ -1335,15 +1323,13 @@ static void ops_complete_biofill(void *stripe_head_ref)
 				dev->sector + STRIPE_SECTORS) {
 				rbi2 = r5_next_bio(rbi, dev->sector);
 				if (!raid5_dec_bi_active_stripes(rbi))
-					bio_list_add(&return_bi, rbi);
+					bio_endio(rbi);
 				rbi = rbi2;
 			}
 		}
 	}
 	clear_bit(STRIPE_BIOFILL_RUN, &sh->state);
 
-	return_io(&return_bi);
-
 	set_bit(STRIPE_HANDLE, &sh->state);
 	raid5_release_stripe(sh);
 }
@@ -3350,8 +3336,7 @@ static void stripe_set_idx(sector_t stripe, struct r5conf *conf, int previous,
 
 static void
 handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
-				struct stripe_head_state *s, int disks,
-				struct bio_list *return_bi)
+		     struct stripe_head_state *s, int disks)
 {
 	int i;
 	BUG_ON(sh->batch_head);
@@ -3399,7 +3384,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			bi->bi_error = -EIO;
 			md_write_end(conf->mddev);
 			if (!raid5_dec_bi_active_stripes(bi))
-				bio_list_add(return_bi, bi);
+				bio_endio(bi);
 			bi = nextbi;
 		}
 		if (bitmap_end)
@@ -3422,7 +3407,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			bi->bi_error = -EIO;
 			md_write_end(conf->mddev);
 			if (!raid5_dec_bi_active_stripes(bi))
-				bio_list_add(return_bi, bi);
+				bio_endio(bi);
 			bi = bi2;
 		}
 
@@ -3448,7 +3433,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 
 				bi->bi_error = -EIO;
 				if (!raid5_dec_bi_active_stripes(bi))
-					bio_list_add(return_bi, bi);
+					bio_endio(bi);
 				bi = nextbi;
 			}
 		}
@@ -3747,7 +3732,7 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
  * never LOCKED, so we don't need to test 'failed' directly.
  */
 static void handle_stripe_clean_event(struct r5conf *conf,
-	struct stripe_head *sh, int disks, struct bio_list *return_bi)
+	struct stripe_head *sh, int disks)
 {
 	int i;
 	struct r5dev *dev;
@@ -3781,7 +3766,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					wbi2 = r5_next_bio(wbi, dev->sector);
 					md_write_end(conf->mddev);
 					if (!raid5_dec_bi_active_stripes(wbi))
-						bio_list_add(return_bi, wbi);
+						bio_endio(wbi);
 					wbi = wbi2;
 				}
 				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
@@ -4724,7 +4709,7 @@ static void handle_stripe(struct stripe_head *sh)
 		sh->reconstruct_state = 0;
 		break_stripe_batch_list(sh, 0);
 		if (s.to_read+s.to_write+s.written)
-			handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
+			handle_failed_stripe(conf, sh, &s, disks);
 		if (s.syncing + s.replacing)
 			handle_failed_sync(conf, sh, &s);
 	}
@@ -4790,10 +4775,10 @@ static void handle_stripe(struct stripe_head *sh)
 			     && !test_bit(R5_LOCKED, &qdev->flags)
 			     && (test_bit(R5_UPTODATE, &qdev->flags) ||
 				 test_bit(R5_Discard, &qdev->flags))))))
-		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
+		handle_stripe_clean_event(conf, sh, disks);
 
 	if (s.just_cached)
-		r5c_handle_cached_data_endio(conf, sh, disks, &s.return_bi);
+		r5c_handle_cached_data_endio(conf, sh, disks);
 	log_stripe_write_finished(sh);
 
 	/* Now we might consider reading some blocks, either to check/generate
@@ -5021,9 +5006,6 @@ static void handle_stripe(struct stripe_head *sh)
 			md_wakeup_thread(conf->mddev->thread);
 	}
 
-	if (!bio_list_empty(&s.return_bi))
-		return_io(&s.return_bi);
-
 	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
 }
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 13800dc9dd88..fd5c21cde77f 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -278,7 +278,6 @@ struct stripe_head_state {
 	int dec_preread_active;
 	unsigned long ops_request;
 
-	struct bio_list return_bi;
 	struct md_rdev *blocked_rdev;
 	int handle_bad_blocks;
 	int log_failed;


