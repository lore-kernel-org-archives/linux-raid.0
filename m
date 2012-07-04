From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/3 v2]raid5: remove unnecessary bitmap write optimization
Date: Wed, 4 Jul 2012 13:21:43 +0800
Message-ID: <20120704052143.GB9145@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Neil pointed out the bitmap write optimization in handle_stripe_clean_event()
is unnecessary, because the chance one stripe gets written twice in the mean
time is rare. We can always do a bitmap_startwrite when a write request is
added to a stripe and bitmap_endwrite after write request is done.  Delete the
optimization. With it, we can delete some cases of device_lock.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-07-04 12:15:38.000000000 +0800
+++ linux/drivers/md/raid5.c	2012-07-04 13:01:03.126943920 +0800
@@ -2350,7 +2350,7 @@ static int add_stripe_bio(struct stripe_
 	spin_lock_irq(&conf->device_lock);
 	if (forwrite) {
 		bip = &sh->dev[dd_idx].towrite;
-		if (*bip == NULL && sh->dev[dd_idx].written == NULL)
+		if (*bip == NULL)
 			firstwrite = 1;
 	} else
 		bip = &sh->dev[dd_idx].toread;
@@ -2455,6 +2455,7 @@ handle_failed_stripe(struct r5conf *conf
 			s->to_write--;
 			bitmap_end = 1;
 		}
+		spin_unlock_irq(&conf->device_lock);
 
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 			wake_up(&conf->wait_for_overlap);
@@ -2470,6 +2471,10 @@ handle_failed_stripe(struct r5conf *conf
 			}
 			bi = nextbi;
 		}
+		if (bitmap_end)
+			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+				STRIPE_SECTORS, 0, 0);
+		bitmap_end = 0;
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
 		sh->dev[i].written = NULL;
@@ -2509,7 +2514,6 @@ handle_failed_stripe(struct r5conf *conf
 				bi = nextbi;
 			}
 		}
-		spin_unlock_irq(&conf->device_lock);
 		if (bitmap_end)
 			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
 					STRIPE_SECTORS, 0, 0);
@@ -2713,9 +2717,7 @@ static void handle_stripe_clean_event(st
 				test_bit(R5_UPTODATE, &dev->flags)) {
 				/* We can return any write requests */
 				struct bio *wbi, *wbi2;
-				int bitmap_end = 0;
 				pr_debug("Return write for disc %d\n", i);
-				spin_lock_irq(&conf->device_lock);
 				wbi = dev->written;
 				dev->written = NULL;
 				while (wbi && wbi->bi_sector <
@@ -2728,15 +2730,10 @@ static void handle_stripe_clean_event(st
 					}
 					wbi = wbi2;
 				}
-				if (dev->towrite == NULL)
-					bitmap_end = 1;
-				spin_unlock_irq(&conf->device_lock);
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
 
