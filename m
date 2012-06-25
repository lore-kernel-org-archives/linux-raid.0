From: Shaohua Li <shli@kernel.org>
Subject: [patch 05/10 v3] raid5: remove some device_lock locking places
Date: Mon, 25 Jun 2012 15:24:52 +0800
Message-ID: <20120625072633.975429683@kernel.org>
References: <20120625072447.268095276@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-remove-some-lock.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

With per-stripe lock and bi_phys_segments lockless, we can safely remove some
locking places of device_lock.

stripe ->read, ->toread ... are protected by per-stripe lock. Accessing bio
list of the stripe is always serialized by this lock. If bio in ->read,
->toread ... list are shared by multiple stripes, there are two protections:
1. bi_phys_segments acts as a reference count
2. traverse the list uses r5_next_bio, which makes traverse never access bio
not belonging to the stripe

Let's have an example:
|  stripe1 |  stripe2    |  stripe3  |
...bio1......|bio2|bio3|....bio4.....

stripe2 has 4 bios, when it's finished, it will decrement bi_phys_segments for
all bios, but only end_bio for bio2 and bio3. bio1->bi_next still points to
bio2, but this doesn't matter. When stripe1 is finished, it will not touch bio2
because of r5_next_bio check. Next time stripe1 will end_bio for bio1 and
stripe3 will end_bio bio4.

before add_stripe_bio() addes a bio to a stripe, we already increament the bio
bi_phys_segments, so don't worry other stripes release the bio.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   60 ++++++++++++++++++++---------------------------------
 1 file changed, 23 insertions(+), 37 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-25 14:37:18.743841116 +0800
+++ linux/drivers/md/raid5.c	2012-06-25 14:37:21.423789830 +0800
@@ -749,15 +749,13 @@ static void ops_complete_biofill(void *s
 {
 	struct stripe_head *sh = stripe_head_ref;
 	struct bio *return_bi = NULL;
-	struct r5conf *conf = sh->raid_conf;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	/* clear completed biofills */
-	spin_lock_irq(&conf->device_lock);
-	spin_lock(&sh->stripe_lock);
+	spin_lock_irq(&sh->stripe_lock);
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 
@@ -783,8 +781,7 @@ static void ops_complete_biofill(void *s
 			}
 		}
 	}
-	spin_unlock(&sh->stripe_lock);
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&sh->stripe_lock);
 	clear_bit(STRIPE_BIOFILL_RUN, &sh->state);
 
 	return_io(return_bi);
@@ -796,7 +793,6 @@ static void ops_complete_biofill(void *s
 static void ops_run_biofill(struct stripe_head *sh)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
-	struct r5conf *conf = sh->raid_conf;
 	struct async_submit_ctl submit;
 	int i;
 
@@ -807,12 +803,10 @@ static void ops_run_biofill(struct strip
 		struct r5dev *dev = &sh->dev[i];
 		if (test_bit(R5_Wantfill, &dev->flags)) {
 			struct bio *rbi;
-			spin_lock_irq(&conf->device_lock);
-			spin_lock(&sh->stripe_lock);
+			spin_lock_irq(&sh->stripe_lock);
 			dev->read = rbi = dev->toread;
 			dev->toread = NULL;
-			spin_unlock(&sh->stripe_lock);
-			spin_unlock_irq(&conf->device_lock);
+			spin_unlock_irq(&sh->stripe_lock);
 			while (rbi && rbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, dev->page,
@@ -1148,14 +1142,12 @@ ops_run_biodrain(struct stripe_head *sh,
 		if (test_and_clear_bit(R5_Wantdrain, &dev->flags)) {
 			struct bio *wbi;
 
-			spin_lock_irq(&sh->raid_conf->device_lock);
-			spin_lock(&sh->stripe_lock);
+			spin_lock_irq(&sh->stripe_lock);
 			chosen = dev->towrite;
 			dev->towrite = NULL;
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
-			spin_unlock(&sh->stripe_lock);
-			spin_unlock_irq(&sh->raid_conf->device_lock);
+			spin_unlock_irq(&sh->stripe_lock);
 
 			while (wbi && wbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
@@ -2341,9 +2333,15 @@ static int add_stripe_bio(struct stripe_
 		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sh->sector);
 
-
-	spin_lock_irq(&conf->device_lock);
-	spin_lock(&sh->stripe_lock);
+	/*
+	 * If several bio share a stripe. The bio bi_phys_segments acts as a
+	 * reference count to avoid race. The reference count should already be
+	 * increased before this function is called (for example, in
+	 * make_request()), so other bio sharing this stripe will not free the
+	 * stripe. If a stripe is owned by one stripe, the stripe lock will
+	 * protect it.
+	 */
+	spin_lock_irq(&sh->stripe_lock);
 	if (forwrite) {
 		bip = &sh->dev[dd_idx].towrite;
 		if (*bip == NULL && sh->dev[dd_idx].written == NULL)
@@ -2377,8 +2375,7 @@ static int add_stripe_bio(struct stripe_
 		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
-	spin_unlock(&sh->stripe_lock);
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&sh->stripe_lock);
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)(*bip)->bi_sector,
@@ -2394,8 +2391,7 @@ static int add_stripe_bio(struct stripe_
 
  overlap:
 	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
-	spin_unlock(&sh->stripe_lock);
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&sh->stripe_lock);
 	return 0;
 }
 
@@ -2445,8 +2441,7 @@ handle_failed_stripe(struct r5conf *conf
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 		}
-		spin_lock_irq(&conf->device_lock);
-		spin_lock(&sh->stripe_lock);
+		spin_lock_irq(&sh->stripe_lock);
 		/* fail all writes first */
 		bi = sh->dev[i].towrite;
 		sh->dev[i].towrite = NULL;
@@ -2508,8 +2503,7 @@ handle_failed_stripe(struct r5conf *conf
 				bi = nextbi;
 			}
 		}
-		spin_unlock(&sh->stripe_lock);
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&sh->stripe_lock);
 		if (bitmap_end)
 			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
 					STRIPE_SECTORS, 0, 0);
@@ -2715,8 +2709,7 @@ static void handle_stripe_clean_event(st
 				struct bio *wbi, *wbi2;
 				int bitmap_end = 0;
 				pr_debug("Return write for disc %d\n", i);
-				spin_lock_irq(&conf->device_lock);
-				spin_lock(&sh->stripe_lock);
+				spin_lock_irq(&sh->stripe_lock);
 				wbi = dev->written;
 				dev->written = NULL;
 				while (wbi && wbi->bi_sector <
@@ -2731,8 +2724,7 @@ static void handle_stripe_clean_event(st
 				}
 				if (dev->towrite == NULL)
 					bitmap_end = 1;
-				spin_unlock(&sh->stripe_lock);
-				spin_unlock_irq(&conf->device_lock);
+				spin_unlock_irq(&sh->stripe_lock);
 				if (bitmap_end)
 					bitmap_endwrite(conf->mddev->bitmap,
 							sh->sector,
@@ -3190,8 +3182,7 @@ static void analyse_stripe(struct stripe
 
 	/* Now to look around and see what can be done */
 	rcu_read_lock();
-	spin_lock_irq(&conf->device_lock);
-	spin_lock(&sh->stripe_lock);
+	spin_lock_irq(&sh->stripe_lock);
 	for (i=disks; i--; ) {
 		struct md_rdev *rdev;
 		sector_t first_bad;
@@ -3337,8 +3328,7 @@ static void analyse_stripe(struct stripe
 				do_recovery = 1;
 		}
 	}
-	spin_unlock(&sh->stripe_lock);
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&sh->stripe_lock);
 	if (test_bit(STRIPE_SYNCING, &sh->state)) {
 		/* If there is a failed device being replaced,
 		 *     we must be recovering.
@@ -4129,9 +4119,7 @@ static void make_request(struct mddev *m
 	if (!plugged)
 		md_wakeup_thread(mddev->thread);
 
-	spin_lock_irq(&conf->device_lock);
 	remaining = raid5_dec_bi_active_stripes(bi);
-	spin_unlock_irq(&conf->device_lock);
 	if (remaining == 0) {
 
 		if ( rw == WRITE )
@@ -4511,9 +4499,7 @@ static int  retry_aligned_read(struct r5
 		release_stripe(sh);
 		handled++;
 	}
-	spin_lock_irq(&conf->device_lock);
 	remaining = raid5_dec_bi_active_stripes(raid_bio);
-	spin_unlock_irq(&conf->device_lock);
 	if (remaining == 0)
 		bio_endio(raid_bio, 0);
 	if (atomic_dec_and_test(&conf->active_aligned_reads))

