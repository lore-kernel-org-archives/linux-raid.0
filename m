From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 03/14] md/raid5: call bio_endio() directly rather than
 queueing for later.
Date: Thu, 16 Feb 2017 15:39:01 +1100
Message-ID: <148721994151.7521.9782959078427528817.stgit@noble>
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
 drivers/md/raid5.c       |   38 ++++++++++----------------------------
 drivers/md/raid5.h       |    3 +--
 3 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 4b211f914d17..1b972a172800 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -255,8 +255,7 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 }
 
 static void
-r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev,
-			      struct bio_list *return_bi)
+r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev)
 {
 	struct bio *wbi, *wbi2;
 
@@ -266,23 +265,21 @@ r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev,
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
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 154593e0afbe..a6edca65b561 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -154,17 +154,6 @@ static int raid6_idx_to_slot(int idx, struct stripe_head *sh,
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
@@ -1175,7 +1164,6 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 static void ops_complete_biofill(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	struct bio_list return_bi = BIO_EMPTY_LIST;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
@@ -1200,15 +1188,13 @@ static void ops_complete_biofill(void *stripe_head_ref)
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
@@ -3152,8 +3138,7 @@ static void stripe_set_idx(sector_t stripe, struct r5conf *conf, int previous,
 
 static void
 handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
-				struct stripe_head_state *s, int disks,
-				struct bio_list *return_bi)
+		     struct stripe_head_state *s, int disks)
 {
 	int i;
 	BUG_ON(sh->batch_head);
@@ -3201,7 +3186,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			bi->bi_error = -EIO;
 			md_write_end(conf->mddev);
 			if (!raid5_dec_bi_active_stripes(bi))
-				bio_list_add(return_bi, bi);
+				bio_endio(bi);
 			bi = nextbi;
 		}
 		if (bitmap_end)
@@ -3224,7 +3209,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			bi->bi_error = -EIO;
 			md_write_end(conf->mddev);
 			if (!raid5_dec_bi_active_stripes(bi))
-				bio_list_add(return_bi, bi);
+				bio_endio(bi);
 			bi = bi2;
 		}
 
@@ -3250,7 +3235,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 
 				bi->bi_error = -EIO;
 				if (!raid5_dec_bi_active_stripes(bi))
-					bio_list_add(return_bi, bi);
+					bio_endio(bi);
 				bi = nextbi;
 			}
 		}
@@ -3549,7 +3534,7 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
  * never LOCKED, so we don't need to test 'failed' directly.
  */
 static void handle_stripe_clean_event(struct r5conf *conf,
-	struct stripe_head *sh, int disks, struct bio_list *return_bi)
+	struct stripe_head *sh, int disks)
 {
 	int i;
 	struct r5dev *dev;
@@ -3583,7 +3568,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					wbi2 = r5_next_bio(wbi, dev->sector);
 					md_write_end(conf->mddev);
 					if (!raid5_dec_bi_active_stripes(wbi))
-						bio_list_add(return_bi, wbi);
+						bio_endio(wbi);
 					wbi = wbi2;
 				}
 				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
@@ -4526,7 +4511,7 @@ static void handle_stripe(struct stripe_head *sh)
 		sh->reconstruct_state = 0;
 		break_stripe_batch_list(sh, 0);
 		if (s.to_read+s.to_write+s.written)
-			handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
+			handle_failed_stripe(conf, sh, &s, disks);
 		if (s.syncing + s.replacing)
 			handle_failed_sync(conf, sh, &s);
 	}
@@ -4592,10 +4577,10 @@ static void handle_stripe(struct stripe_head *sh)
 			     && !test_bit(R5_LOCKED, &qdev->flags)
 			     && (test_bit(R5_UPTODATE, &qdev->flags) ||
 				 test_bit(R5_Discard, &qdev->flags))))))
-		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
+		handle_stripe_clean_event(conf, sh, disks);
 
 	if (s.just_cached)
-		r5c_handle_cached_data_endio(conf, sh, disks, &s.return_bi);
+		r5c_handle_cached_data_endio(conf, sh, disks);
 	r5l_stripe_write_finished(sh);
 
 	/* Now we might consider reading some blocks, either to check/generate
@@ -4823,9 +4808,6 @@ static void handle_stripe(struct stripe_head *sh)
 			md_wakeup_thread(conf->mddev->thread);
 	}
 
-	if (!bio_list_empty(&s.return_bi))
-		return_io(&s.return_bi);
-
 	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
 }
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 1ef71273b9b2..9051631cb7f0 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -272,7 +272,6 @@ struct stripe_head_state {
 	int dec_preread_active;
 	unsigned long ops_request;
 
-	struct bio_list return_bi;
 	struct md_rdev *blocked_rdev;
 	int handle_bad_blocks;
 	int log_failed;
@@ -776,7 +775,7 @@ extern void r5c_release_extra_page(struct stripe_head *sh);
 extern void r5c_use_extra_page(struct stripe_head *sh);
 extern void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
 extern void r5c_handle_cached_data_endio(struct r5conf *conf,
-	struct stripe_head *sh, int disks, struct bio_list *return_bi);
+	struct stripe_head *sh, int disks);
 extern int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 			  struct stripe_head_state *s);
 extern void r5c_make_stripe_write_out(struct stripe_head *sh);


