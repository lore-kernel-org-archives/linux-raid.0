From: Shaohua Li <shli@kernel.org>
Subject: [patch 04/10 v3] raid5: lockless access raid5 overrided bi_phys_segments
Date: Mon, 25 Jun 2012 15:24:51 +0800
Message-ID: <20120625072625.099376476@kernel.org>
References: <20120625072447.268095276@kernel.org>
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
 drivers/md/raid5.c |   58 +++++++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-25 14:37:13.651888057 +0800
+++ linux/drivers/md/raid5.c	2012-06-25 14:37:18.743841116 +0800
@@ -99,34 +99,40 @@ static inline struct bio *r5_next_bio(st
  * We maintain a biased count of active stripes in the bottom 16 bits of
  * bi_phys_segments, and a count of processed stripes in the upper 16 bits
  */
-static inline int raid5_bi_phys_segments(struct bio *bio)
+static inline int raid5_bi_processed_stripes(struct bio *bio)
 {
-	return bio->bi_phys_segments & 0xffff;
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	return (atomic_read(segments) >> 16) & 0xffff;
 }
 
-static inline int raid5_bi_hw_segments(struct bio *bio)
+static inline int raid5_dec_bi_active_stripes(struct bio *bio)
 {
-	return (bio->bi_phys_segments >> 16) & 0xffff;
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	return atomic_sub_return(1, segments) & 0xffff;
 }
 
-static inline int raid5_dec_bi_phys_segments(struct bio *bio)
+static inline void raid5_inc_bi_active_stripes(struct bio *bio)
 {
-	--bio->bi_phys_segments;
-	return raid5_bi_phys_segments(bio);
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	atomic_inc(segments);
 }
 
-static inline int raid5_dec_bi_hw_segments(struct bio *bio)
+static inline void raid5_set_bi_processed_stripes(struct bio *bio,
+	unsigned int cnt)
 {
-	unsigned short val = raid5_bi_hw_segments(bio);
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	int old, new;
 
-	--val;
-	bio->bi_phys_segments = (val << 16) | raid5_bi_phys_segments(bio);
-	return val;
+	do {
+		old = atomic_read(segments);
+		new = (old & 0xffff) | (cnt << 16);
+	} while (atomic_cmpxchg(segments, old, new) != old);
 }
 
-static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigned int cnt)
+static inline void raid5_set_bi_stripes(struct bio *bio, unsigned int cnt)
 {
-	bio->bi_phys_segments = raid5_bi_phys_segments(bio) | (cnt << 16);
+	atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
+	atomic_set(segments, cnt);
 }
 
 /* Find first data disk in a raid6 stripe */
@@ -769,7 +775,7 @@ static void ops_complete_biofill(void *s
 			while (rbi && rbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				rbi2 = r5_next_bio(rbi, dev->sector);
-				if (!raid5_dec_bi_phys_segments(rbi)) {
+				if (!raid5_dec_bi_active_stripes(rbi)) {
 					rbi->bi_next = return_bi;
 					return_bi = rbi;
 				}
@@ -2356,7 +2362,7 @@ static int add_stripe_bio(struct stripe_
 	if (*bip)
 		bi->bi_next = *bip;
 	*bip = bi;
-	bi->bi_phys_segments++;
+	raid5_inc_bi_active_stripes(bi);
 
 	if (forwrite) {
 		/* check if page is covered */
@@ -2456,7 +2462,7 @@ handle_failed_stripe(struct r5conf *conf
 			sh->dev[i].sector + STRIPE_SECTORS) {
 			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
-			if (!raid5_dec_bi_phys_segments(bi)) {
+			if (!raid5_dec_bi_active_stripes(bi)) {
 				md_write_end(conf->mddev);
 				bi->bi_next = *return_bi;
 				*return_bi = bi;
@@ -2471,7 +2477,7 @@ handle_failed_stripe(struct r5conf *conf
 		       sh->dev[i].sector + STRIPE_SECTORS) {
 			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
-			if (!raid5_dec_bi_phys_segments(bi)) {
+			if (!raid5_dec_bi_active_stripes(bi)) {
 				md_write_end(conf->mddev);
 				bi->bi_next = *return_bi;
 				*return_bi = bi;
@@ -2495,7 +2501,7 @@ handle_failed_stripe(struct r5conf *conf
 				struct bio *nextbi =
 					r5_next_bio(bi, sh->dev[i].sector);
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
-				if (!raid5_dec_bi_phys_segments(bi)) {
+				if (!raid5_dec_bi_active_stripes(bi)) {
 					bi->bi_next = *return_bi;
 					*return_bi = bi;
 				}
@@ -2716,7 +2722,7 @@ static void handle_stripe_clean_event(st
 				while (wbi && wbi->bi_sector <
 					dev->sector + STRIPE_SECTORS) {
 					wbi2 = r5_next_bio(wbi, dev->sector);
-					if (!raid5_dec_bi_phys_segments(wbi)) {
+					if (!raid5_dec_bi_active_stripes(wbi)) {
 						md_write_end(conf->mddev);
 						wbi->bi_next = *return_bi;
 						*return_bi = wbi;
@@ -3785,7 +3791,7 @@ static struct bio *remove_bio_from_retry
 		 * this sets the active strip count to 1 and the processed
 		 * strip count to zero (upper 8 bits)
 		 */
-		bi->bi_phys_segments = 1; /* biased count of active stripes */
+		raid5_set_bi_stripes(bi, 1); /* biased count of active stripes */
 	}
 
 	return bi;
@@ -4124,7 +4130,7 @@ static void make_request(struct mddev *m
 		md_wakeup_thread(mddev->thread);
 
 	spin_lock_irq(&conf->device_lock);
-	remaining = raid5_dec_bi_phys_segments(bi);
+	remaining = raid5_dec_bi_active_stripes(bi);
 	spin_unlock_irq(&conf->device_lock);
 	if (remaining == 0) {
 
@@ -4481,7 +4487,7 @@ static int  retry_aligned_read(struct r5
 		     sector += STRIPE_SECTORS,
 		     scnt++) {
 
-		if (scnt < raid5_bi_hw_segments(raid_bio))
+		if (scnt < raid5_bi_processed_stripes(raid_bio))
 			/* already done this stripe */
 			continue;
 
@@ -4489,14 +4495,14 @@ static int  retry_aligned_read(struct r5
 
 		if (!sh) {
 			/* failed to get a stripe - must wait */
-			raid5_set_bi_hw_segments(raid_bio, scnt);
+			raid5_set_bi_processed_stripes(raid_bio, scnt);
 			conf->retry_read_aligned = raid_bio;
 			return handled;
 		}
 
 		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
 			release_stripe(sh);
-			raid5_set_bi_hw_segments(raid_bio, scnt);
+			raid5_set_bi_processed_stripes(raid_bio, scnt);
 			conf->retry_read_aligned = raid_bio;
 			return handled;
 		}
@@ -4506,7 +4512,7 @@ static int  retry_aligned_read(struct r5
 		handled++;
 	}
 	spin_lock_irq(&conf->device_lock);
-	remaining = raid5_dec_bi_phys_segments(raid_bio);
+	remaining = raid5_dec_bi_active_stripes(raid_bio);
 	spin_unlock_irq(&conf->device_lock);
 	if (remaining == 0)
 		bio_endio(raid_bio, 0);

