From: Shaohua Li <shli@fb.com>
Subject: [PATCH v3 7/8] raid5: guarantee cache release stripes in correct way
Date: Wed, 3 Jun 2015 15:48:42 -0700
Message-ID: <e81e62c1b4e6bdb9e34725a940dd8687e841f267.1433356864.git.shli@fb.com>
References: <cover.1433356864.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1433356864.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

When cache trys to flush data to raid, we must be very careful about
stripe release. The issue is if we release a stripe and the stripe is
handling by raid5d and we add a new bio into the stripe later, the
stripe will enter the raid5 state machine several times, which
r5cache_write_parity can't handle well. This could happen if
get_active_stripe() sleeps in adding bio to several stripes. To solve
this issue, we guarantee stripe release after all bio are added to
corresponding stripes. This is a performance win too if the bug happens.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 28 +++++++++-------
 drivers/md/raid5.c       | 84 +++++++++++++++++++++++++++++++-----------------
 drivers/md/raid5.h       | 11 ++++++-
 3 files changed, 80 insertions(+), 43 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 04b1684..86e7b94 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1670,7 +1670,7 @@ static void r5c_write_bio(struct r5c_cache *cache, struct bio *bio)
 	r5c_enter_error_mode(cache, -ENOMEM);
 	r5c_check_wait_error_mode(cache);
 error_mode:
-	raid5_make_request(cache->mddev, bio);
+	raid5_make_request(cache->mddev, bio, NULL);
 }
 
 static void r5c_read_bio(struct r5c_cache *cache, struct bio *bio)
@@ -1686,7 +1686,7 @@ static void r5c_read_bio(struct r5c_cache *cache, struct bio *bio)
 
 	stripe = r5c_get_stripe(cache, stripe_index);
 	if (!stripe) {
-		raid5_make_request(cache->mddev, bio);
+		raid5_make_request(cache->mddev, bio, NULL);
 		return;
 	}
 
@@ -1725,7 +1725,7 @@ static void r5c_read_bio(struct r5c_cache *cache, struct bio *bio)
 			} else
 				split = bio;
 
-			raid5_make_request(cache->mddev, split);
+			raid5_make_request(cache->mddev, split, NULL);
 
 			start = tmp;
 		}
@@ -1823,7 +1823,7 @@ void r5c_write_end(struct mddev *mddev, struct bio *bi)
 }
 
 static void r5c_flush_one(struct r5c_cache *cache, struct r5c_stripe *stripe,
-	int start, int pages)
+	int start, int pages, struct raid5_plug_context *pc)
 {
 	sector_t base;
 	struct bio *bio;
@@ -1858,7 +1858,7 @@ static void r5c_flush_one(struct r5c_cache *cache, struct r5c_stripe *stripe,
 		atomic64_inc(&cache->out_cache_rq);
 		atomic64_add(bio_sectors(bio), &cache->out_cache_sectors);
 
-		raid5_make_request(cache->mddev, bio);
+		raid5_make_request(cache->mddev, bio, pc);
 	}
 }
 
@@ -1871,7 +1871,8 @@ static void r5c_put_stripe_dirty(struct r5c_cache *cache,
 	}
 }
 
-static void r5c_flush_stripe(struct r5c_cache *cache, struct r5c_stripe *stripe)
+static void r5c_flush_stripe(struct r5c_cache *cache, struct r5c_stripe *stripe,
+	struct raid5_plug_context *pc)
 {
 	unsigned long *stripe_bits;
 	int chunk_stripes;
@@ -1900,7 +1901,7 @@ static void r5c_flush_stripe(struct r5c_cache *cache, struct r5c_stripe *stripe)
 		while (end < cache->stripe_data_pages &&
 		       stripe->data_pages[end])
 			end++;
-		r5c_flush_one(cache, stripe, start, end - start);
+		r5c_flush_one(cache, stripe, start, end - start, pc);
 	}
 	r5c_put_stripe_dirty(cache, stripe);
 }
@@ -2034,11 +2035,14 @@ static void r5c_reclaim_stripe_list(struct r5c_cache *cache,
 	struct r5c_io_range *range;
 	u64 seq;
 	sector_t meta;
-	struct blk_plug plug;
 	size_t size = 0;
+	struct raid5_plug_context pc;
 
 	if (list_empty(stripe_list))
 		return;
+
+	raid5_context_init(&pc);
+
 	list_sort(NULL, stripe_list, r5c_stripe_list_cmp);
 	list_for_each_entry(stripe, stripe_list, lru) {
 		cache->stripe_flush_data[size] =
@@ -2047,11 +2051,11 @@ static void r5c_reclaim_stripe_list(struct r5c_cache *cache,
 	}
 	size *= sizeof(__le64);
 
-	blk_start_plug(&plug);
 	/* step 1: start write to raid */
 	list_for_each_entry(stripe, stripe_list, lru)
-		r5c_flush_stripe(cache, stripe);
-	blk_finish_plug(&plug);
+		r5c_flush_stripe(cache, stripe, &pc);
+
+	raid5_context_unplug(&pc, cache->mddev, false);
 
 	/* step 2: wait parity write to cache */
 	list_for_each_entry_reverse(stripe, stripe_list, lru)
@@ -2158,7 +2162,7 @@ static void r5c_reclaim_thread(struct md_thread *thread)
 		wake_up(&cache->error_wait);
 
 		while ((bio = bio_list_pop(&cache->retry_bio_list)) != NULL)
-			raid5_make_request(cache->mddev, bio);
+			raid5_make_request(cache->mddev, bio, NULL);
 
 		if (++cache->retry_cnt < MAX_RETRY) {
 			cache->next_retry_time = jiffies +
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b1c942c..6cb10af 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4973,26 +4973,26 @@ static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int group)
 	return sh;
 }
 
-struct raid5_plug_cb {
-	struct blk_plug_cb	cb;
-	struct list_head	list;
-	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
-};
+void raid5_context_init(struct raid5_plug_context *context)
+{
+	int i;
+	INIT_LIST_HEAD(&context->list);
+	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+		INIT_LIST_HEAD(context->temp_inactive_list + i);
+}
 
-static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
+void raid5_context_unplug(struct raid5_plug_context *context,
+	struct mddev *mddev, bool from_schedule)
 {
-	struct raid5_plug_cb *cb = container_of(
-		blk_cb, struct raid5_plug_cb, cb);
 	struct stripe_head *sh;
-	struct mddev *mddev = cb->cb.data;
 	struct r5conf *conf = mddev->private;
 	int cnt = 0;
 	int hash;
 
-	if (cb->list.next && !list_empty(&cb->list)) {
+	if (context->list.next && !list_empty(&context->list)) {
 		spin_lock_irq(&conf->device_lock);
-		while (!list_empty(&cb->list)) {
-			sh = list_first_entry(&cb->list, struct stripe_head, lru);
+		while (!list_empty(&context->list)) {
+			sh = list_first_entry(&context->list, struct stripe_head, lru);
 			list_del_init(&sh->lru);
 			/*
 			 * avoid race release_stripe_plug() sees
@@ -5006,15 +5006,38 @@ static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
 			 * case, the count is always > 1 here
 			 */
 			hash = sh->hash_lock_index;
-			__release_stripe(conf, sh, &cb->temp_inactive_list[hash]);
+			__release_stripe(conf, sh, &context->temp_inactive_list[hash]);
 			cnt++;
 		}
 		spin_unlock_irq(&conf->device_lock);
 	}
-	release_inactive_stripe_list(conf, cb->temp_inactive_list,
+	release_inactive_stripe_list(conf, context->temp_inactive_list,
 				     NR_STRIPE_HASH_LOCKS);
 	if (mddev->queue)
 		trace_block_unplug(mddev->queue, cnt, !from_schedule);
+}
+
+static void raid5_context_plug(struct raid5_plug_context *context,
+			       struct stripe_head *sh)
+{
+	if (!test_and_set_bit(STRIPE_ON_UNPLUG_LIST, &sh->state))
+		list_add_tail(&sh->lru, &context->list);
+	else
+		release_stripe(sh);
+}
+
+struct raid5_plug_cb {
+	struct blk_plug_cb	cb;
+	struct raid5_plug_context context;
+};
+
+static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
+{
+	struct raid5_plug_cb *cb = container_of(
+		blk_cb, struct raid5_plug_cb, cb);
+	struct mddev *mddev = cb->cb.data;
+
+	raid5_context_unplug(&cb->context, mddev, from_schedule);
 	kfree(cb);
 }
 
@@ -5033,20 +5056,14 @@ static void release_stripe_plug(struct mddev *mddev,
 
 	cb = container_of(blk_cb, struct raid5_plug_cb, cb);
 
-	if (cb->list.next == NULL) {
-		int i;
-		INIT_LIST_HEAD(&cb->list);
-		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
-			INIT_LIST_HEAD(cb->temp_inactive_list + i);
-	}
+	if (cb->context.list.next == NULL)
+		raid5_context_init(&cb->context);
 
-	if (!test_and_set_bit(STRIPE_ON_UNPLUG_LIST, &sh->state))
-		list_add_tail(&sh->lru, &cb->list);
-	else
-		release_stripe(sh);
+	raid5_context_plug(&cb->context, sh);
 }
 
-static void make_discard_request(struct mddev *mddev, struct bio *bi)
+static void make_discard_request(struct mddev *mddev, struct bio *bi,
+	struct raid5_plug_context *context)
 {
 	struct r5conf *conf = mddev->private;
 	sector_t logical_sector, last_sector;
@@ -5128,7 +5145,10 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		clear_bit(STRIPE_DELAYED, &sh->state);
 		if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 			atomic_inc(&conf->preread_active_stripes);
-		release_stripe_plug(mddev, sh);
+		if (context)
+			raid5_context_plug(context, sh);
+		else
+			release_stripe_plug(mddev, sh);
 	}
 
 	remaining = raid5_dec_bi_active_stripes(bi);
@@ -5138,7 +5158,8 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	}
 }
 
-void raid5_make_request(struct mddev *mddev, struct bio * bi)
+void raid5_make_request(struct mddev *mddev, struct bio * bi,
+	struct raid5_plug_context *context)
 {
 	struct r5conf *conf = mddev->private;
 	int dd_idx;
@@ -5168,7 +5189,7 @@ void raid5_make_request(struct mddev *mddev, struct bio * bi)
 		return;
 
 	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
-		make_discard_request(mddev, bi);
+		make_discard_request(mddev, bi, context);
 		return;
 	}
 
@@ -5296,7 +5317,10 @@ void raid5_make_request(struct mddev *mddev, struct bio * bi)
 			    ((bi->bi_rw & REQ_SYNC) || conf->cache) &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
-			release_stripe_plug(mddev, sh);
+			if (context)
+				raid5_context_plug(context, sh);
+			else
+				release_stripe_plug(mddev, sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -5323,7 +5347,7 @@ static void make_request(struct mddev *mddev, struct bio *bi)
 	if (conf->cache)
 		r5c_handle_bio(conf->cache, bi);
 	else
-		raid5_make_request(mddev, bi);
+		raid5_make_request(mddev, bi, NULL);
 }
 
 static sector_t raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index f117b68..1adb2b8 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -607,8 +607,17 @@ static inline int algorithm_is_DDF(int layout)
 extern void md_raid5_kick_device(struct r5conf *conf);
 extern int raid5_set_cache_size(struct mddev *mddev, int size);
 
+struct raid5_plug_context {
+	struct list_head	list;
+	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
+};
+void raid5_context_init(struct raid5_plug_context *context);
+void raid5_context_unplug(struct raid5_plug_context *context,
+	struct mddev *mddev, bool from_schedule);
+
 void release_stripe(struct stripe_head *sh);
-void raid5_make_request(struct mddev *mddev, struct bio *bi);
+void raid5_make_request(struct mddev *mddev, struct bio *bi,
+	struct raid5_plug_context *context);
 void r5c_handle_bio(struct r5c_cache *cache, struct bio *bi);
 int r5c_write_parity(struct r5c_cache *cache, struct stripe_head *sh);
 void r5c_flush_pending_parity(struct r5c_cache *cache);
-- 
1.8.1

