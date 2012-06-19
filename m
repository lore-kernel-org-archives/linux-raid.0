From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/9 v2] raid5: add a per-stripe lock
Date: Tue, 19 Jun 2012 09:59:43 +0800
Message-ID: <20120619020059.549708119@kernel.org>
References: <20120619015941.891400722@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-add-perstripe-lock.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

Add a per-stripe lock to protect stripe specific data, like dev->read,
written, ... The purpose is to reduce lock contention of conf->device_lock.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   17 +++++++++++++++++
 drivers/md/raid5.h |    1 +
 2 files changed, 18 insertions(+)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-06 09:35:56.338257401 +0800
+++ linux/drivers/md/raid5.c	2012-06-13 08:37:43.005641057 +0800
@@ -749,6 +749,7 @@ static void ops_complete_biofill(void *s
 
 	/* clear completed biofills */
 	spin_lock_irq(&conf->device_lock);
+	spin_lock(&sh->stripe_lock);
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 
@@ -774,6 +775,7 @@ static void ops_complete_biofill(void *s
 			}
 		}
 	}
+	spin_unlock(&sh->stripe_lock);
 	spin_unlock_irq(&conf->device_lock);
 	clear_bit(STRIPE_BIOFILL_RUN, &sh->state);
 
@@ -798,8 +800,10 @@ static void ops_run_biofill(struct strip
 		if (test_bit(R5_Wantfill, &dev->flags)) {
 			struct bio *rbi;
 			spin_lock_irq(&conf->device_lock);
+			spin_lock(&sh->stripe_lock);
 			dev->read = rbi = dev->toread;
 			dev->toread = NULL;
+			spin_unlock(&sh->stripe_lock);
 			spin_unlock_irq(&conf->device_lock);
 			while (rbi && rbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
@@ -1137,10 +1141,12 @@ ops_run_biodrain(struct stripe_head *sh,
 			struct bio *wbi;
 
 			spin_lock_irq(&sh->raid_conf->device_lock);
+			spin_lock(&sh->stripe_lock);
 			chosen = dev->towrite;
 			dev->towrite = NULL;
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
+			spin_unlock(&sh->stripe_lock);
 			spin_unlock_irq(&sh->raid_conf->device_lock);
 
 			while (wbi && wbi->bi_sector <
@@ -1446,6 +1452,8 @@ static int grow_one_stripe(struct r5conf
 	init_waitqueue_head(&sh->ops.wait_for_ops);
 	#endif
 
+	spin_lock_init(&sh->stripe_lock);
+
 	if (grow_buffers(sh)) {
 		shrink_buffers(sh);
 		kmem_cache_free(conf->slab_cache, sh);
@@ -2327,6 +2335,7 @@ static int add_stripe_bio(struct stripe_
 
 
 	spin_lock_irq(&conf->device_lock);
+	spin_lock(&sh->stripe_lock);
 	if (forwrite) {
 		bip = &sh->dev[dd_idx].towrite;
 		if (*bip == NULL && sh->dev[dd_idx].written == NULL)
@@ -2360,6 +2369,7 @@ static int add_stripe_bio(struct stripe_
 		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
+	spin_unlock(&sh->stripe_lock);
 	spin_unlock_irq(&conf->device_lock);
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
@@ -2376,6 +2386,7 @@ static int add_stripe_bio(struct stripe_
 
  overlap:
 	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
+	spin_unlock(&sh->stripe_lock);
 	spin_unlock_irq(&conf->device_lock);
 	return 0;
 }
@@ -2427,6 +2438,7 @@ handle_failed_stripe(struct r5conf *conf
 			}
 		}
 		spin_lock_irq(&conf->device_lock);
+		spin_lock(&sh->stripe_lock);
 		/* fail all writes first */
 		bi = sh->dev[i].towrite;
 		sh->dev[i].towrite = NULL;
@@ -2488,6 +2500,7 @@ handle_failed_stripe(struct r5conf *conf
 				bi = nextbi;
 			}
 		}
+		spin_unlock(&sh->stripe_lock);
 		spin_unlock_irq(&conf->device_lock);
 		if (bitmap_end)
 			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
@@ -2695,6 +2708,7 @@ static void handle_stripe_clean_event(st
 				int bitmap_end = 0;
 				pr_debug("Return write for disc %d\n", i);
 				spin_lock_irq(&conf->device_lock);
+				spin_lock(&sh->stripe_lock);
 				wbi = dev->written;
 				dev->written = NULL;
 				while (wbi && wbi->bi_sector <
@@ -2709,6 +2723,7 @@ static void handle_stripe_clean_event(st
 				}
 				if (dev->towrite == NULL)
 					bitmap_end = 1;
+				spin_unlock(&sh->stripe_lock);
 				spin_unlock_irq(&conf->device_lock);
 				if (bitmap_end)
 					bitmap_endwrite(conf->mddev->bitmap,
@@ -3168,6 +3183,7 @@ static void analyse_stripe(struct stripe
 	/* Now to look around and see what can be done */
 	rcu_read_lock();
 	spin_lock_irq(&conf->device_lock);
+	spin_lock(&sh->stripe_lock);
 	for (i=disks; i--; ) {
 		struct md_rdev *rdev;
 		sector_t first_bad;
@@ -3313,6 +3329,7 @@ static void analyse_stripe(struct stripe
 				do_recovery = 1;
 		}
 	}
+	spin_unlock(&sh->stripe_lock);
 	spin_unlock_irq(&conf->device_lock);
 	if (test_bit(STRIPE_SYNCING, &sh->state)) {
 		/* If there is a failed device being replaced,
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2012-06-06 09:35:56.350257250 +0800
+++ linux/drivers/md/raid5.h	2012-06-13 08:34:13.660272415 +0800
@@ -210,6 +210,7 @@ struct stripe_head {
 	int			disks;		/* disks in stripe */
 	enum check_states	check_state;
 	enum reconstruct_states reconstruct_state;
+	spinlock_t		stripe_lock;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target

