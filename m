From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/5] md/raid5: don't abuse bio->bi_phys_segments
Date: Tue, 7 Feb 2017 08:55:59 -0800
Message-ID: <c520acdc3408674479117d83cb95f712d9e9b3b4.1486485935.git.shli@fb.com>
References: <cover.1486485935.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1486485935.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: khlebnikov@yandex-team.ru, hch@lst.de, neilb@suse.com
List-Id: linux-raid.ids

Allocates extra data for activate_stripes and processed_stripes
accounting. Don't need to abuse bio->bi_phys_segments.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 12 ++++++++----
 drivers/md/raid5.h | 37 +++++++++++++++++++------------------
 2 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b0d1345..fd3e5ce 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3103,7 +3103,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 		(unsigned long long)sh->sector);
 
 	/*
-	 * If several bio share a stripe. The bio bi_phys_segments acts as a
+	 * If several bio share a stripe. The raid5_bio_data has a
 	 * reference count to avoid race. The reference count should already be
 	 * increased before this function is called (for example, in
 	 * raid5_make_request()), so other bio sharing this stripe will not free the
@@ -5146,6 +5146,7 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 		if (sectors < bio_sectors(raid_bio)) {
 			split = bio_split(raid_bio, sectors, GFP_NOIO, fs_bio_set);
 			bio_chain(split, raid_bio);
+			md_bio_attach_data(mddev, split);
 		} else
 			split = raid_bio;
 
@@ -5335,7 +5336,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	last_sector = bi->bi_iter.bi_sector + (bi->bi_iter.bi_size>>9);
 
 	bi->bi_next = NULL;
-	bi->bi_phys_segments = 1; /* over-loaded to count active stripes */
+	raid5_set_bi_stripes(bi, 1);
 
 	stripe_sectors = conf->chunk_sectors *
 		(conf->raid_disks - conf->max_degraded);
@@ -5463,7 +5464,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bio_end_sector(bi);
 	bi->bi_next = NULL;
-	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
+	raid5_set_bi_stripes(bi, 1);
 
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
@@ -5963,7 +5964,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 	 * We cannot pre-allocate enough stripe_heads as we may need
 	 * more than exist in the cache (if we allow ever large chunks).
 	 * So we do one stripe head at a time and record in
-	 * ->bi_hw_segments how many have been done.
+	 * ->raid5_bio_data.processed_stripes how many have been done.
 	 *
 	 * We *know* that this entire raid_bio is in one chunk, so
 	 * it will be only one 'dd_idx' and only need one call to raid5_compute_sector.
@@ -8188,6 +8189,7 @@ static struct md_personality raid6_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid6_takeover,
 	.congested	= raid5_congested,
+	.per_bio_data_size = sizeof(struct raid5_bio_data),
 };
 static struct md_personality raid5_personality =
 {
@@ -8211,6 +8213,7 @@ static struct md_personality raid5_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid5_takeover,
 	.congested	= raid5_congested,
+	.per_bio_data_size = sizeof(struct raid5_bio_data),
 };
 
 static struct md_personality raid4_personality =
@@ -8235,6 +8238,7 @@ static struct md_personality raid4_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid4_takeover,
 	.congested	= raid5_congested,
+	.per_bio_data_size = sizeof(struct raid5_bio_data),
 };
 
 static int __init raid5_init(void)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index c0687df..9232463 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -481,48 +481,49 @@ static inline struct bio *r5_next_bio(struct bio *bio, sector_t sector)
 		return NULL;
 }
 
-/*
- * We maintain a biased count of active stripes in the bottom 16 bits of
- * bi_phys_segments, and a count of processed stripes in the upper 16 bits
- */
+struct raid5_bio_data {
+	atomic_t active_stripes;
+	atomic_t processed_stripes;
+};
+
+#define raid5_get_bio_data(bio) \
+	((struct raid5_bio_data *)md_get_per_bio_data(bio))
+
 static inline int raid5_bi_processed_stripes(struct bio *bio)
 {
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	struct raid5_bio_data *data= raid5_get_bio_data(bio);
 
-	return (atomic_read(segments) >> 16) & 0xffff;
+	return atomic_read(&data->processed_stripes);
 }
 
 static inline int raid5_dec_bi_active_stripes(struct bio *bio)
 {
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	struct raid5_bio_data *data= raid5_get_bio_data(bio);
 
-	return atomic_sub_return(1, segments) & 0xffff;
+	return atomic_sub_return(1, &data->active_stripes);
 }
 
 static inline void raid5_inc_bi_active_stripes(struct bio *bio)
 {
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	struct raid5_bio_data *data= raid5_get_bio_data(bio);
 
-	atomic_inc(segments);
+	atomic_inc(&data->active_stripes);
 }
 
 static inline void raid5_set_bi_processed_stripes(struct bio *bio,
 	unsigned int cnt)
 {
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
-	int old, new;
+	struct raid5_bio_data *data= raid5_get_bio_data(bio);
 
-	do {
-		old = atomic_read(segments);
-		new = (old & 0xffff) | (cnt << 16);
-	} while (atomic_cmpxchg(segments, old, new) != old);
+	atomic_set(&data->processed_stripes, cnt);
 }
 
 static inline void raid5_set_bi_stripes(struct bio *bio, unsigned int cnt)
 {
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	struct raid5_bio_data *data= raid5_get_bio_data(bio);
 
-	atomic_set(segments, cnt);
+	atomic_set(&data->active_stripes, cnt);
+	atomic_set(&data->processed_stripes, 0);
 }
 
 /* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
-- 
2.9.3

