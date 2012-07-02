From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/2]raid5: add a per-stripe lock
Date: Mon, 2 Jul 2012 11:13:58 +0800
Message-ID: <20120702031358.GC29770@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com
List-Id: linux-raid.ids

Add a per-stripe lock to protect stripe specific data, like dev->read,
written, ... The purpose is to reduce lock contention of conf->device_lock.

stripe ->read, ->toread, ->towrite, ->written are protected by per-stripe lock.
Accessing bio list of the stripe is always serialized by this lock. If bio in
->read, ->toread ... list are shared by multiple stripes, there are two
protections:
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
 drivers/md/raid5.c |   43 +++++++++++++++++++++++++------------------
 drivers/md/raid5.h |    1 +
 2 files changed, 26 insertions(+), 18 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-07-02 10:48:07.873922919 +0800
+++ linux/drivers/md/raid5.c	2012-07-02 10:50:20.848266521 +0800
@@ -757,14 +757,13 @@ static void ops_complete_biofill(void *s
 {
 	struct stripe_head *sh = stripe_head_ref;
 	struct bio *return_bi = NULL;
-	struct r5conf *conf = sh->raid_conf;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	/* clear completed biofills */
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&sh->stripe_lock);
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 
@@ -790,7 +789,7 @@ static void ops_complete_biofill(void *s
 			}
 		}
 	}
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&sh->stripe_lock);
 	clear_bit(STRIPE_BIOFILL_RUN, &sh->state);
 
 	return_io(return_bi);
@@ -802,7 +801,6 @@ static void ops_complete_biofill(void *s
 static void ops_run_biofill(struct stripe_head *sh)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
-	struct r5conf *conf = sh->raid_conf;
 	struct async_submit_ctl submit;
 	int i;
 
@@ -813,10 +811,10 @@ static void ops_run_biofill(struct strip
 		struct r5dev *dev = &sh->dev[i];
 		if (test_bit(R5_Wantfill, &dev->flags)) {
 			struct bio *rbi;
-			spin_lock_irq(&conf->device_lock);
+			spin_lock_irq(&sh->stripe_lock);
 			dev->read = rbi = dev->toread;
 			dev->toread = NULL;
-			spin_unlock_irq(&conf->device_lock);
+			spin_unlock_irq(&sh->stripe_lock);
 			while (rbi && rbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, dev->page,
@@ -1152,12 +1150,12 @@ ops_run_biodrain(struct stripe_head *sh,
 		if (test_and_clear_bit(R5_Wantdrain, &dev->flags)) {
 			struct bio *wbi;
 
-			spin_lock_irq(&sh->raid_conf->device_lock);
+			spin_lock_irq(&sh->stripe_lock);
 			chosen = dev->towrite;
 			dev->towrite = NULL;
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
-			spin_unlock_irq(&sh->raid_conf->device_lock);
+			spin_unlock_irq(&sh->stripe_lock);
 
 			while (wbi && wbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
@@ -1462,6 +1460,8 @@ static int grow_one_stripe(struct r5conf
 	init_waitqueue_head(&sh->ops.wait_for_ops);
 	#endif
 
+	spin_lock_init(&sh->stripe_lock);
+
 	if (grow_buffers(sh)) {
 		shrink_buffers(sh);
 		kmem_cache_free(conf->slab_cache, sh);
@@ -2341,8 +2341,15 @@ static int add_stripe_bio(struct stripe_
 		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sh->sector);
 
-
-	spin_lock_irq(&conf->device_lock);
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
@@ -2376,7 +2383,7 @@ static int add_stripe_bio(struct stripe_
 		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&sh->stripe_lock);
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)(*bip)->bi_sector,
@@ -2392,7 +2399,7 @@ static int add_stripe_bio(struct stripe_
 
  overlap:
 	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&sh->stripe_lock);
 	return 0;
 }
 
@@ -2442,7 +2449,7 @@ handle_failed_stripe(struct r5conf *conf
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 		}
-		spin_lock_irq(&conf->device_lock);
+		spin_lock_irq(&sh->stripe_lock);
 		/* fail all writes first */
 		bi = sh->dev[i].towrite;
 		sh->dev[i].towrite = NULL;
@@ -2504,7 +2511,7 @@ handle_failed_stripe(struct r5conf *conf
 				bi = nextbi;
 			}
 		}
-		spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&sh->stripe_lock);
 		if (bitmap_end)
 			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
 					STRIPE_SECTORS, 0, 0);
@@ -2710,7 +2717,7 @@ static void handle_stripe_clean_event(st
 				struct bio *wbi, *wbi2;
 				int bitmap_end = 0;
 				pr_debug("Return write for disc %d\n", i);
-				spin_lock_irq(&conf->device_lock);
+				spin_lock_irq(&sh->stripe_lock);
 				wbi = dev->written;
 				dev->written = NULL;
 				while (wbi && wbi->bi_sector <
@@ -2725,7 +2732,7 @@ static void handle_stripe_clean_event(st
 				}
 				if (dev->towrite == NULL)
 					bitmap_end = 1;
-				spin_unlock_irq(&conf->device_lock);
+				spin_unlock_irq(&sh->stripe_lock);
 				if (bitmap_end)
 					bitmap_endwrite(conf->mddev->bitmap,
 							sh->sector,
@@ -3183,7 +3190,7 @@ static void analyse_stripe(struct stripe
 
 	/* Now to look around and see what can be done */
 	rcu_read_lock();
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&sh->stripe_lock);
 	for (i=disks; i--; ) {
 		struct md_rdev *rdev;
 		sector_t first_bad;
@@ -3329,7 +3336,7 @@ static void analyse_stripe(struct stripe
 				do_recovery = 1;
 		}
 	}
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&sh->stripe_lock);
 	if (test_bit(STRIPE_SYNCING, &sh->state)) {
 		/* If there is a failed device being replaced,
 		 *     we must be recovering.
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2012-07-02 10:46:25.827205823 +0800
+++ linux/drivers/md/raid5.h	2012-07-02 10:48:27.625674608 +0800
@@ -210,6 +210,7 @@ struct stripe_head {
 	int			disks;		/* disks in stripe */
 	enum check_states	check_state;
 	enum reconstruct_states reconstruct_state;
+	spinlock_t		stripe_lock;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
