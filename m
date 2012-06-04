From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/8] raid5: lockless access raid5 overrided bi_phys_segments
Date: Mon, 04 Jun 2012 16:01:54 +0800
Message-ID: <20120604080307.401236650@kernel.org>
References: <20120604080152.098975870@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-atomic-segment-accounting.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

Raid5 overrides bio->bi_phys_segments, accessing it is with device_lock hold,
which is unnecessary, We can make it lockless actually.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-01 13:43:05.594056130 +0800
+++ linux/drivers/md/raid5.c	2012-06-01 13:50:39.852349690 +0800
@@ -101,32 +101,43 @@ static inline struct bio *r5_next_bio(st
  */
 static inline int raid5_bi_phys_segments(struct bio *bio)
 {
-	return bio->bi_phys_segments & 0xffff;
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	return atomic_read(segments) & 0xffff;
 }
 
 static inline int raid5_bi_hw_segments(struct bio *bio)
 {
-	return (bio->bi_phys_segments >> 16) & 0xffff;
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	return (atomic_read(segments) >> 16) & 0xffff;
 }
 
 static inline int raid5_dec_bi_phys_segments(struct bio *bio)
 {
-	--bio->bi_phys_segments;
-	return raid5_bi_phys_segments(bio);
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	return atomic_sub_return(1, segments) & 0xffff;
 }
 
-static inline int raid5_dec_bi_hw_segments(struct bio *bio)
+static inline void raid5_inc_bi_phys_segments(struct bio *bio)
 {
-	unsigned short val = raid5_bi_hw_segments(bio);
-
-	--val;
-	bio->bi_phys_segments = (val << 16) | raid5_bi_phys_segments(bio);
-	return val;
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	atomic_inc(segments);
 }
 
 static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigned int cnt)
 {
-	bio->bi_phys_segments = raid5_bi_phys_segments(bio) | (cnt << 16);
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	int old, new;
+
+	do {
+		old = atomic_read(segments);
+		new = (old & 0xffff) | (cnt << 16);
+	} while (atomic_cmpxchg(segments, old, new) != old);
+}
+
+static inline void raid5_set_bi_segments(struct bio *bio, unsigned int cnt)
+{
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	atomic_set(segments, cnt);
 }
 
 /* Find first data disk in a raid6 stripe */
@@ -2354,7 +2365,7 @@ static int add_stripe_bio(struct stripe_
 	if (*bip)
 		bi->bi_next = *bip;
 	*bip = bi;
-	bi->bi_phys_segments++;
+	raid5_inc_bi_phys_segments(bi);
 
 	if (forwrite) {
 		/* check if page is covered */
@@ -3783,7 +3794,7 @@ static struct bio *remove_bio_from_retry
 		 * this sets the active strip count to 1 and the processed
 		 * strip count to zero (upper 8 bits)
 		 */
-		bi->bi_phys_segments = 1; /* biased count of active stripes */
+		raid5_set_bi_segments(bi, 1); /* biased count of active stripes */
 	}
 
 	return bi;

