From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 2/8] md/r5cache: move some code to raid5.h
Date: Thu, 6 Oct 2016 00:14:10 -0700
Message-ID: <20161006071416.3295093-3-songliubraving@fb.com>
References: <20161006071416.3295093-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161006071416.3295093-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Move some define and inline functions to raid5.h, so they can be
used in raid5-cache.c

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5.c | 71 -------------------------------------------------
 drivers/md/raid5.h | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 71 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f94472d..67d4f49 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -70,19 +70,6 @@ module_param(devices_handle_discard_safely, bool, 0644);
 MODULE_PARM_DESC(devices_handle_discard_safely,
 		 "Set to Y if all devices in each array reliably return zeroes on reads from discarded regions");
 static struct workqueue_struct *raid5_wq;
-/*
- * Stripe cache
- */
-
-#define NR_STRIPES		256
-#define STRIPE_SIZE		PAGE_SIZE
-#define STRIPE_SHIFT		(PAGE_SHIFT - 9)
-#define STRIPE_SECTORS		(STRIPE_SIZE>>9)
-#define	IO_THRESHOLD		1
-#define BYPASS_THRESHOLD	1
-#define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
-#define HASH_MASK		(NR_HASH - 1)
-#define MAX_STRIPE_BATCH	8
 
 static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
 {
@@ -126,64 +113,6 @@ static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
 	local_irq_enable();
 }
 
-/* bio's attached to a stripe+device for I/O are linked together in bi_sector
- * order without overlap.  There may be several bio's per stripe+device, and
- * a bio could span several devices.
- * When walking this list for a particular stripe+device, we must never proceed
- * beyond a bio that extends past this device, as the next bio might no longer
- * be valid.
- * This function is used to determine the 'next' bio in the list, given the sector
- * of the current stripe+device
- */
-static inline struct bio *r5_next_bio(struct bio *bio, sector_t sector)
-{
-	int sectors = bio_sectors(bio);
-	if (bio->bi_iter.bi_sector + sectors < sector + STRIPE_SECTORS)
-		return bio->bi_next;
-	else
-		return NULL;
-}
-
-/*
- * We maintain a biased count of active stripes in the bottom 16 bits of
- * bi_phys_segments, and a count of processed stripes in the upper 16 bits
- */
-static inline int raid5_bi_processed_stripes(struct bio *bio)
-{
-	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
-	return (atomic_read(segments) >> 16) & 0xffff;
-}
-
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
-	atomic_set(segments, cnt);
-}
-
 /* Find first data disk in a raid6 stripe */
 static inline int raid6_d0(struct stripe_head *sh)
 {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 517d4b6..46cfe93 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -410,6 +410,83 @@ struct disk_info {
 	struct md_rdev	*rdev, *replacement;
 };
 
+/*
+ * Stripe cache
+ */
+
+#define NR_STRIPES		256
+#define STRIPE_SIZE		PAGE_SIZE
+#define STRIPE_SHIFT		(PAGE_SHIFT - 9)
+#define STRIPE_SECTORS		(STRIPE_SIZE>>9)
+#define	IO_THRESHOLD		1
+#define BYPASS_THRESHOLD	1
+#define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
+#define HASH_MASK		(NR_HASH - 1)
+#define MAX_STRIPE_BATCH	8
+
+/* bio's attached to a stripe+device for I/O are linked together in bi_sector
+ * order without overlap.  There may be several bio's per stripe+device, and
+ * a bio could span several devices.
+ * When walking this list for a particular stripe+device, we must never proceed
+ * beyond a bio that extends past this device, as the next bio might no longer
+ * be valid.
+ * This function is used to determine the 'next' bio in the list, given the
+ * sector of the current stripe+device
+ */
+static inline struct bio *r5_next_bio(struct bio *bio, sector_t sector)
+{
+	int sectors = bio_sectors(bio);
+
+	if (bio->bi_iter.bi_sector + sectors < sector + STRIPE_SECTORS)
+		return bio->bi_next;
+	else
+		return NULL;
+}
+
+/*
+ * We maintain a biased count of active stripes in the bottom 16 bits of
+ * bi_phys_segments, and a count of processed stripes in the upper 16 bits
+ */
+static inline int raid5_bi_processed_stripes(struct bio *bio)
+{
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+
+	return (atomic_read(segments) >> 16) & 0xffff;
+}
+
+static inline int raid5_dec_bi_active_stripes(struct bio *bio)
+{
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+
+	return atomic_sub_return(1, segments) & 0xffff;
+}
+
+static inline void raid5_inc_bi_active_stripes(struct bio *bio)
+{
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+
+	atomic_inc(segments);
+}
+
+static inline void raid5_set_bi_processed_stripes(struct bio *bio,
+	unsigned int cnt)
+{
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	int old, new;
+
+	do {
+		old = atomic_read(segments);
+		new = (old & 0xffff) | (cnt << 16);
+	} while (atomic_cmpxchg(segments, old, new) != old);
+}
+
+static inline void raid5_set_bi_stripes(struct bio *bio, unsigned int cnt)
+{
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+
+	atomic_set(segments, cnt);
+}
+
 /* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
  * This is because we sometimes take all the spinlocks
  * and creating that much locking depth can cause
-- 
2.9.3

