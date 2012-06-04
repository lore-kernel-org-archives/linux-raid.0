From: Shaohua Li <shli@kernel.org>
Subject: [patch 3/8] raid5: remove some device_lock locking places
Date: Mon, 04 Jun 2012 16:01:55 +0800
Message-ID: <20120604080315.342814586@kernel.org>
References: <20120604080152.098975870@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-remove-some-lock.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

With per-stripe lock and bi_phys_segments lockless, we can safely remove some
locking places of device_lock.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   21 ---------------------
 1 file changed, 21 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-05-28 12:12:42.970613636 +0800
+++ linux/drivers/md/raid5.c	2012-05-28 14:29:01.535797473 +0800
@@ -752,14 +752,12 @@ static void ops_complete_biofill(void *s
 {
 	struct stripe_head *sh = stripe_head_ref;
 	struct bio *return_bi = NULL;
-	struct r5conf *conf = sh->raid_conf;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	/* clear completed biofills */
-	spin_lock_irq(&conf->device_lock);
 	spin_lock_irq(&sh->stripe_lock);
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
@@ -787,7 +785,6 @@ static void ops_complete_biofill(void *s
 		}
 	}
 	spin_unlock_irq(&sh->stripe_lock);
-	spin_unlock_irq(&conf->device_lock);
 	clear_bit(STRIPE_BIOFILL_RUN, &sh->state);
 
 	return_io(return_bi);
@@ -799,7 +796,6 @@ static void ops_complete_biofill(void *s
 static void ops_run_biofill(struct stripe_head *sh)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
-	struct r5conf *conf = sh->raid_conf;
 	struct async_submit_ctl submit;
 	int i;
 
@@ -810,12 +806,10 @@ static void ops_run_biofill(struct strip
 		struct r5dev *dev = &sh->dev[i];
 		if (test_bit(R5_Wantfill, &dev->flags)) {
 			struct bio *rbi;
-			spin_lock_irq(&conf->device_lock);
 			spin_lock_irq(&sh->stripe_lock);
 			dev->read = rbi = dev->toread;
 			dev->toread = NULL;
 			spin_unlock_irq(&sh->stripe_lock);
-			spin_unlock_irq(&conf->device_lock);
 			while (rbi && rbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, dev->page,
@@ -1151,14 +1145,12 @@ ops_run_biodrain(struct stripe_head *sh,
 		if (test_and_clear_bit(R5_Wantdrain, &dev->flags)) {
 			struct bio *wbi;
 
-			spin_lock_irq(&sh->raid_conf->device_lock);
 			spin_lock_irq(&sh->stripe_lock);
 			chosen = dev->towrite;
 			dev->towrite = NULL;
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
 			spin_unlock_irq(&sh->stripe_lock);
-			spin_unlock_irq(&sh->raid_conf->device_lock);
 
 			while (wbi && wbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
@@ -2345,7 +2337,6 @@ static int add_stripe_bio(struct stripe_
 		(unsigned long long)sh->sector);
 
 
-	spin_lock_irq(&conf->device_lock);
 	spin_lock_irq(&sh->stripe_lock);
 	if (forwrite) {
 		bip = &sh->dev[dd_idx].towrite;
@@ -2381,7 +2372,6 @@ static int add_stripe_bio(struct stripe_
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
 	spin_unlock_irq(&sh->stripe_lock);
-	spin_unlock_irq(&conf->device_lock);
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)(*bip)->bi_sector,
@@ -2398,7 +2388,6 @@ static int add_stripe_bio(struct stripe_
  overlap:
 	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
 	spin_unlock_irq(&sh->stripe_lock);
-	spin_unlock_irq(&conf->device_lock);
 	return 0;
 }
 
@@ -2448,7 +2437,6 @@ handle_failed_stripe(struct r5conf *conf
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 		}
-		spin_lock_irq(&conf->device_lock);
 		spin_lock_irq(&sh->stripe_lock);
 		/* fail all writes first */
 		bi = sh->dev[i].towrite;
@@ -2512,7 +2500,6 @@ handle_failed_stripe(struct r5conf *conf
 			}
 		}
 		spin_unlock_irq(&sh->stripe_lock);
-		spin_unlock_irq(&conf->device_lock);
 		if (bitmap_end)
 			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
 					STRIPE_SECTORS, 0, 0);
@@ -2718,7 +2705,6 @@ static void handle_stripe_clean_event(st
 				struct bio *wbi, *wbi2;
 				int bitmap_end = 0;
 				pr_debug("Return write for disc %d\n", i);
-				spin_lock_irq(&conf->device_lock);
 				spin_lock_irq(&sh->stripe_lock);
 				wbi = dev->written;
 				dev->written = NULL;
@@ -2735,7 +2721,6 @@ static void handle_stripe_clean_event(st
 				if (dev->towrite == NULL)
 					bitmap_end = 1;
 				spin_unlock_irq(&sh->stripe_lock);
-				spin_unlock_irq(&conf->device_lock);
 				if (bitmap_end)
 					bitmap_endwrite(conf->mddev->bitmap,
 							sh->sector,
@@ -3193,7 +3178,6 @@ static void analyse_stripe(struct stripe
 
 	/* Now to look around and see what can be done */
 	rcu_read_lock();
-	spin_lock_irq(&conf->device_lock);
 	spin_lock_irq(&sh->stripe_lock);
 	for (i=disks; i--; ) {
 		struct md_rdev *rdev;
@@ -3341,7 +3325,6 @@ static void analyse_stripe(struct stripe
 		}
 	}
 	spin_unlock_irq(&sh->stripe_lock);
-	spin_unlock_irq(&conf->device_lock);
 	if (test_bit(STRIPE_SYNCING, &sh->state)) {
 		/* If there is a failed device being replaced,
 		 *     we must be recovering.
@@ -4132,9 +4115,7 @@ static void make_request(struct mddev *m
 	if (!plugged)
 		md_wakeup_thread(mddev->thread);
 
-	spin_lock_irq(&conf->device_lock);
 	remaining = raid5_dec_bi_phys_segments(bi);
-	spin_unlock_irq(&conf->device_lock);
 	if (remaining == 0) {
 
 		if ( rw == WRITE )
@@ -4514,9 +4495,7 @@ static int  retry_aligned_read(struct r5
 		release_stripe(sh);
 		handled++;
 	}
-	spin_lock_irq(&conf->device_lock);
 	remaining = raid5_dec_bi_phys_segments(raid_bio);
-	spin_unlock_irq(&conf->device_lock);
 	if (remaining == 0)
 		bio_endio(raid_bio, 0);
 	if (atomic_dec_and_test(&conf->active_aligned_reads))

