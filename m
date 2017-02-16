From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 06/14] md/raid5: remove over-loading of
 ->bi_phys_segments.
Date: Thu, 16 Feb 2017 15:39:02 +1100
Message-ID: <148721994202.7521.13464645140160274861.stgit@noble>
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

When a read request, which bypassed the cache, fails, we need to retry
it through the cache.
This involves attaching it to a sequence of stripe_heads, and it may not
be possible to get all the stripe_heads we need at once.
We do what we can, and record how far we got in ->bi_phys_segments so
we can pick up again later.

There is only ever one bio which may have a non-zero offset stored in
->bi_phys_segments, the one that is either active in the single thread
which calls retry_aligned_read(), or is in conf->retry_read_aligned
waiting for retry_aligned_read() to be called again.

So we only need to store one offset value.  This can be in a local
variable passed between remove_bio_from_retry() and
retry_aligned_read(), or in the r5conf structure next to the
->retry_read_aligned pointer.

Storing it there allows the last usage of ->bi_phys_segments to be
removed from md/raid5.c.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5.c |   24 ++++++++++++------------
 drivers/md/raid5.h |   30 +-----------------------------
 2 files changed, 13 insertions(+), 41 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 905abf081acf..f93e8fddbb23 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4883,12 +4883,14 @@ static void add_bio_to_retry(struct bio *bi,struct r5conf *conf)
 	md_wakeup_thread(conf->mddev->thread);
 }
 
-static struct bio *remove_bio_from_retry(struct r5conf *conf)
+static struct bio *remove_bio_from_retry(struct r5conf *conf,
+					 unsigned int *offset)
 {
 	struct bio *bi;
 
 	bi = conf->retry_read_aligned;
 	if (bi) {
+		*offset = conf->retry_read_offset;
 		conf->retry_read_aligned = NULL;
 		return bi;
 	}
@@ -4896,11 +4898,7 @@ static struct bio *remove_bio_from_retry(struct r5conf *conf)
 	if(bi) {
 		conf->retry_read_aligned_list = bi->bi_next;
 		bi->bi_next = NULL;
-		/*
-		 * this sets the active strip count to 1 and the processed
-		 * strip count to zero (upper 8 bits)
-		 */
-		raid5_set_bi_processed_stripes(bi, 0);
+		*offset = 0;
 	}
 
 	return bi;
@@ -5835,7 +5833,8 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 	return STRIPE_SECTORS;
 }
 
-static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
+static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio,
+			       unsigned int offset)
 {
 	/* We may not be able to submit a whole bio at once as there
 	 * may not be enough stripe_heads available.
@@ -5864,7 +5863,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 		     sector += STRIPE_SECTORS,
 		     scnt++) {
 
-		if (scnt < raid5_bi_processed_stripes(raid_bio))
+		if (scnt < offset)
 			/* already done this stripe */
 			continue;
 
@@ -5872,15 +5871,15 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 
 		if (!sh) {
 			/* failed to get a stripe - must wait */
-			raid5_set_bi_processed_stripes(raid_bio, scnt);
 			conf->retry_read_aligned = raid_bio;
+			conf->retry_read_offset = scnt;
 			return handled;
 		}
 
 		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0, 0)) {
 			raid5_release_stripe(sh);
-			raid5_set_bi_processed_stripes(raid_bio, scnt);
 			conf->retry_read_aligned = raid_bio;
+			conf->retry_read_offset = scnt;
 			return handled;
 		}
 
@@ -6003,6 +6002,7 @@ static void raid5d(struct md_thread *thread)
 	while (1) {
 		struct bio *bio;
 		int batch_size, released;
+		unsigned int offset;
 
 		released = release_stripe_list(conf, conf->temp_inactive_list);
 		if (released)
@@ -6020,10 +6020,10 @@ static void raid5d(struct md_thread *thread)
 		}
 		raid5_activate_delayed(conf);
 
-		while ((bio = remove_bio_from_retry(conf))) {
+		while ((bio = remove_bio_from_retry(conf, &offset))) {
 			int ok;
 			spin_unlock_irq(&conf->device_lock);
-			ok = retry_aligned_read(conf, bio);
+			ok = retry_aligned_read(conf, bio, offset);
 			spin_lock_irq(&conf->device_lock);
 			if (!ok)
 				break;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 3018a33693ab..a4ef02176afb 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -480,35 +480,6 @@ static inline struct bio *r5_next_bio(struct bio *bio, sector_t sector)
 		return NULL;
 }
 
-/*
- * We maintain a count of processed stripes in the upper 16 bits
- */
-static inline int raid5_bi_processed_stripes(struct bio *bio)
-{
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
-
-	return (atomic_read(segments) >> 16) & 0xffff;
-}
-
-static inline void raid5_set_bi_processed_stripes(struct bio *bio,
-	unsigned int cnt)
-{
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
-	int old, new;
-
-	do {
-		old = atomic_read(segments);
-		new = (old & 0xffff) | (cnt << 16);
-	} while (atomic_cmpxchg(segments, old, new) != old);
-}
-
-static inline void raid5_set_bi_stripes(struct bio *bio, unsigned int cnt)
-{
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
-
-	atomic_set(segments, cnt);
-}
-
 /* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
  * This is because we sometimes take all the spinlocks
  * and creating that much locking depth can cause
@@ -596,6 +567,7 @@ struct r5conf {
 	struct list_head	delayed_list; /* stripes that have plugged requests */
 	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
 	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
+	unsigned int		retry_read_offset; /* sector offset into retry_read_aligned */
 	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
 	atomic_t		preread_active_stripes; /* stripes with scheduled io */
 	atomic_t		active_aligned_reads;


