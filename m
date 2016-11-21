From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 4/5] md/raid5: call bio_endio() directly rather than
 queuing for later.
Date: Mon, 21 Nov 2016 12:19:43 +1100
Message-ID: <147969118362.5434.13577701135211525699.stgit@noble>
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

We gather bios that need to be returned into a bio_list
and call bio_endio() on them all together.
The original reason for this was to avoid making the calls while
holding a spinlock.
Locking has changed a lot since then, and that reason is no longer
valid.

So discard return_io() and various return_bi lists, and just call
bio_endio() directly as needed.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5.c |   36 +++++++++---------------------------
 drivers/md/raid5.h |    1 -
 2 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e53b8f499a4c..6f3154c80fbf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -223,17 +223,6 @@ static int raid6_idx_to_slot(int idx, struct stripe_head *sh,
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
@@ -1178,7 +1167,6 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 static void ops_complete_biofill(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	struct bio_list return_bi = BIO_EMPTY_LIST;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
@@ -1203,15 +1191,13 @@ static void ops_complete_biofill(void *stripe_head_ref)
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
@@ -3075,8 +3061,7 @@ static void stripe_set_idx(sector_t stripe, struct r5conf *conf, int previous,
 
 static void
 handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
-				struct stripe_head_state *s, int disks,
-				struct bio_list *return_bi)
+		     struct stripe_head_state *s, int disks)
 {
 	int i;
 	BUG_ON(sh->batch_head);
@@ -3124,7 +3109,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			bi->bi_error = -EIO;
 			md_write_end(conf->mddev);
 			if (!raid5_dec_bi_active_stripes(bi))
-				bio_list_add(return_bi, bi);
+				bio_endio(bi);
 			bi = nextbi;
 		}
 		if (bitmap_end)
@@ -3147,7 +3132,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			bi->bi_error = -EIO;
 			md_write_end(conf->mddev);
 			if (!raid5_dec_bi_active_stripes(bi))
-				bio_list_add(return_bi, bi);
+				bio_endio(bi);
 			bi = bi2;
 		}
 
@@ -3173,7 +3158,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 
 				bi->bi_error = -EIO;
 				if (!raid5_dec_bi_active_stripes(bi))
-					bio_list_add(return_bi, bi);
+					bio_endio(bi);
 				bi = nextbi;
 			}
 		}
@@ -3457,7 +3442,7 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
  * never LOCKED, so we don't need to test 'failed' directly.
  */
 static void handle_stripe_clean_event(struct r5conf *conf,
-	struct stripe_head *sh, int disks, struct bio_list *return_bi)
+	struct stripe_head *sh, int disks)
 {
 	int i;
 	struct r5dev *dev;
@@ -3491,7 +3476,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					wbi2 = r5_next_bio(wbi, dev->sector);
 					md_write_end(conf->mddev);
 					if (!raid5_dec_bi_active_stripes(wbi))
-						bio_list_add(return_bi, wbi);
+						bio_endio(wbi);
 					wbi = wbi2;
 				}
 				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
@@ -4378,7 +4363,7 @@ static void handle_stripe(struct stripe_head *sh)
 		sh->reconstruct_state = 0;
 		break_stripe_batch_list(sh, 0);
 		if (s.to_read+s.to_write+s.written)
-			handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
+			handle_failed_stripe(conf, sh, &s, disks);
 		if (s.syncing + s.replacing)
 			handle_failed_sync(conf, sh, &s);
 	}
@@ -4443,7 +4428,7 @@ static void handle_stripe(struct stripe_head *sh)
 			     && !test_bit(R5_LOCKED, &qdev->flags)
 			     && (test_bit(R5_UPTODATE, &qdev->flags) ||
 				 test_bit(R5_Discard, &qdev->flags))))))
-		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
+		handle_stripe_clean_event(conf, sh, disks);
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
@@ -4633,9 +4618,6 @@ static void handle_stripe(struct stripe_head *sh)
 			md_wakeup_thread(conf->mddev->thread);
 	}
 
-	if (!bio_list_empty(&s.return_bi))
-		return_io(&s.return_bi);
-
 	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
 }
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index f654f8207a44..799f84b26838 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -269,7 +269,6 @@ struct stripe_head_state {
 	int dec_preread_active;
 	unsigned long ops_request;
 
-	struct bio_list return_bi;
 	struct md_rdev *blocked_rdev;
 	int handle_bad_blocks;
 	int log_failed;


