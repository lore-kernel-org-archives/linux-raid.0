From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 4/5] md/raid5: use r5_for_each_bio()
Date: Wed, 22 Jun 2011 13:50:29 +0900
Message-ID: <1308718230-2536-5-git-send-email-namhyung@gmail.com>
References: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There are common bio loop which could be factored out in a usual
for_each_xxx way. Add and use r5_for_each_bio() for those.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |   67 ++++++++++++++++++++++++---------------------------
 1 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 12f3b939e56d..6b92e8549e9b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -81,6 +81,18 @@
  * of the current stripe+device
  */
 #define r5_next_bio(bio, sect) ( ( (bio)->bi_sector + ((bio)->bi_size>>9) < sect + STRIPE_SECTORS) ? (bio)->bi_next : NULL)
+
+/*
+ * Iterates through all attached bio's to the current stripe+device.
+ * The given bio must be initialized before using this macro.
+ */
+#define r5_for_each_bio(bio, nbio, dev)						\
+	for ( ;									\
+	     ({ if (bio)  nbio = r5_next_bio(bio, (dev)->sector);		\
+		(bio && (bio)->bi_sector < (dev)->sector + STRIPE_SECTORS);});	\
+	     bio = nbio								\
+	    )
+
 /*
  * The following can be used to debug the driver
  */
@@ -647,15 +659,12 @@ static void ops_complete_biofill(void *stripe_head_ref)
 			BUG_ON(!dev->read);
 			rbi = dev->read;
 			dev->read = NULL;
-			while (rbi && rbi->bi_sector <
-				dev->sector + STRIPE_SECTORS) {
-				rbi2 = r5_next_bio(rbi, dev->sector);
+
+			r5_for_each_bio(rbi, rbi2, dev)
 				if (!raid5_dec_bi_phys_segments(rbi)) {
 					rbi->bi_next = return_bi;
 					return_bi = rbi;
 				}
-				rbi = rbi2;
-			}
 		}
 	}
 	spin_unlock_irq(&conf->device_lock);
@@ -680,17 +689,15 @@ static void ops_run_biofill(struct stripe_head *sh)
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		if (test_bit(R5_Wantfill, &dev->flags)) {
-			struct bio *rbi;
+			struct bio *rbi, *rbi2;
 			spin_lock_irq(&conf->device_lock);
 			dev->read = rbi = dev->toread;
 			dev->toread = NULL;
 			spin_unlock_irq(&conf->device_lock);
-			while (rbi && rbi->bi_sector <
-				dev->sector + STRIPE_SECTORS) {
+
+			r5_for_each_bio(rbi, rbi2, dev)
 				tx = async_copy_data(0, rbi, dev->page,
 					dev->sector, tx);
-				rbi = r5_next_bio(rbi, dev->sector);
-			}
 		}
 	}
 
@@ -1018,7 +1025,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 		struct bio *chosen;
 
 		if (test_and_clear_bit(R5_Wantdrain, &dev->flags)) {
-			struct bio *wbi;
+			struct bio *wbi, *wbi2;
 
 			spin_lock(&sh->lock);
 			chosen = dev->towrite;
@@ -1027,13 +1034,11 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 			wbi = dev->written = chosen;
 			spin_unlock(&sh->lock);
 
-			while (wbi && wbi->bi_sector <
-				dev->sector + STRIPE_SECTORS) {
+			r5_for_each_bio(wbi, wbi2, dev) {
 				if (wbi->bi_rw & REQ_FUA)
 					set_bit(R5_WantFUA, &dev->flags);
 				tx = async_copy_data(1, wbi, dev->page,
 					dev->sector, tx);
-				wbi = r5_next_bio(wbi, dev->sector);
 			}
 		}
 	}
@@ -2228,7 +2233,7 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 {
 	int i;
 	for (i = disks; i--; ) {
-		struct bio *bi;
+		struct bio *bi, *bi2;
 		int bitmap_end = 0;
 
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
@@ -2252,31 +2257,27 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 			wake_up(&conf->wait_for_overlap);
 
-		while (bi && bi->bi_sector <
-			sh->dev[i].sector + STRIPE_SECTORS) {
-			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
+		r5_for_each_bio(bi, bi2, &sh->dev[i]) {
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (!raid5_dec_bi_phys_segments(bi)) {
 				md_write_end(conf->mddev);
 				bi->bi_next = *return_bi;
 				*return_bi = bi;
 			}
-			bi = nextbi;
 		}
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
 		sh->dev[i].written = NULL;
-		if (bi) bitmap_end = 1;
-		while (bi && bi->bi_sector <
-		       sh->dev[i].sector + STRIPE_SECTORS) {
-			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
+		if (bi)
+			bitmap_end = 1;
+
+		r5_for_each_bio(bi, bi2, &sh->dev[i]) {
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (!raid5_dec_bi_phys_segments(bi)) {
 				md_write_end(conf->mddev);
 				bi->bi_next = *return_bi;
 				*return_bi = bi;
 			}
-			bi = bi2;
 		}
 
 		/* fail any reads if this device is non-operational and
@@ -2289,17 +2290,15 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 			sh->dev[i].toread = NULL;
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
-			if (bi) s->to_read--;
-			while (bi && bi->bi_sector <
-			       sh->dev[i].sector + STRIPE_SECTORS) {
-				struct bio *nextbi =
-					r5_next_bio(bi, sh->dev[i].sector);
+			if (bi)
+				s->to_read--;
+
+			r5_for_each_bio(bi, bi2, &sh->dev[i]) {
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
 				if (!raid5_dec_bi_phys_segments(bi)) {
 					bi->bi_next = *return_bi;
 					*return_bi = bi;
 				}
-				bi = nextbi;
 			}
 		}
 		spin_unlock_irq(&conf->device_lock);
@@ -2515,16 +2514,14 @@ static void handle_stripe_clean_event(raid5_conf_t *conf,
 				spin_lock_irq(&conf->device_lock);
 				wbi = dev->written;
 				dev->written = NULL;
-				while (wbi && wbi->bi_sector <
-					dev->sector + STRIPE_SECTORS) {
-					wbi2 = r5_next_bio(wbi, dev->sector);
+
+				r5_for_each_bio(wbi, wbi2, dev)
 					if (!raid5_dec_bi_phys_segments(wbi)) {
 						md_write_end(conf->mddev);
 						wbi->bi_next = *return_bi;
 						*return_bi = wbi;
 					}
-					wbi = wbi2;
-				}
+
 				if (dev->towrite == NULL)
 					bitmap_end = 1;
 				spin_unlock_irq(&conf->device_lock);
-- 
1.7.5.2

