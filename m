From: Shaohua Li <shli@kernel.org>
Subject: [patch 3/3]raid5: remove unnecessary bitmap write optimization
Date: Tue, 3 Jul 2012 15:51:11 +0800
Message-ID: <20120703075111.GC23488@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com
List-Id: linux-raid.ids

Neil pointed out the bitmap write optimization in handle_stripe_clean_event()
is unnecessary, because the chance one stripe gets written twice in the mean
time is rare. We can always do a bitmap_startwrite when a write request is
added to a stripe and bitmap_endwrite after write request is done.  Delete the
optimization. With it, we can delete some cases of stripe_lock.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-07-03 14:58:51.241382361 +0800
+++ linux/drivers/md/raid5.c	2012-07-03 15:04:48.568889733 +0800
@@ -2350,7 +2350,7 @@ static int add_stripe_bio(struct stripe_
 	spin_lock_irq(&sh->stripe_lock);
 	if (forwrite) {
 		bip = &sh->dev[dd_idx].towrite;
-		if (*bip == NULL && sh->dev[dd_idx].written == NULL)
+		if (*bip == NULL)
 			firstwrite = 1;
 	} else
 		bip = &sh->dev[dd_idx].toread;
@@ -2427,7 +2427,6 @@ handle_failed_stripe(struct r5conf *conf
 	int i;
 	for (i = disks; i--; ) {
 		struct bio *bi;
-		int bitmap_end = 0;
 
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			struct md_rdev *rdev;
@@ -2451,10 +2450,9 @@ handle_failed_stripe(struct r5conf *conf
 		/* fail all writes first */
 		bi = sh->dev[i].towrite;
 		sh->dev[i].towrite = NULL;
-		if (bi) {
+		if (bi)
 			s->to_write--;
-			bitmap_end = 1;
-		}
+		spin_unlock_irq(&sh->stripe_lock);
 
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 			wake_up(&conf->wait_for_overlap);
@@ -2473,7 +2471,6 @@ handle_failed_stripe(struct r5conf *conf
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
 		sh->dev[i].written = NULL;
-		if (bi) bitmap_end = 1;
 		while (bi && bi->bi_sector <
 		       sh->dev[i].sector + STRIPE_SECTORS) {
 			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
@@ -2509,10 +2506,8 @@ handle_failed_stripe(struct r5conf *conf
 				bi = nextbi;
 			}
 		}
-		spin_unlock_irq(&sh->stripe_lock);
-		if (bitmap_end)
-			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					STRIPE_SECTORS, 0, 0);
+		bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+				STRIPE_SECTORS, 0, 0);
 		/* If we were in the middle of a write the parity block might
 		 * still be locked - so just clear all R5_LOCKED flags
 		 */
@@ -2713,9 +2708,7 @@ static void handle_stripe_clean_event(st
 				test_bit(R5_UPTODATE, &dev->flags)) {
 				/* We can return any write requests */
 				struct bio *wbi, *wbi2;
-				int bitmap_end = 0;
 				pr_debug("Return write for disc %d\n", i);
-				spin_lock_irq(&sh->stripe_lock);
 				wbi = dev->written;
 				dev->written = NULL;
 				while (wbi && wbi->bi_sector <
@@ -2728,15 +2721,10 @@ static void handle_stripe_clean_event(st
 					}
 					wbi = wbi2;
 				}
-				if (dev->towrite == NULL)
-					bitmap_end = 1;
-				spin_unlock_irq(&sh->stripe_lock);
-				if (bitmap_end)
-					bitmap_endwrite(conf->mddev->bitmap,
-							sh->sector,
-							STRIPE_SECTORS,
+				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+						STRIPE_SECTORS,
 					 !test_bit(STRIPE_DEGRADED, &sh->state),
-							0);
+						0);
 			}
 		}
 
