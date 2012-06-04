From: Shaohua Li <shli@kernel.org>
Subject: [patch 4/8] raid5: reduce chance release_stripe() taking device_lock
Date: Mon, 04 Jun 2012 16:01:56 +0800
Message-ID: <20120604080321.874560112@kernel.org>
References: <20120604080152.098975870@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-reduce-release_stripe-lock.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

release_stripe() is a place conf->device_lock is heavily contended. We take the
lock even stripe count isn't 1, which isn't required. On the on the other hand,
decreasing count first and taking lock if count is 0 can expose races:
1. bewteen dec count and taking lock, another thread hits the stripe in cache,
so increase count. The stripe will be deleted from any list. In this case
stripe count isn't 0.
2. between dec count and taking lock, another thread hits the stripe in cache
and release it. In this case the stripe is already in specific list. We do
list_move to adjust its position.
So both cases are fixable to me.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-01 13:50:56.336138112 +0800
+++ linux/drivers/md/raid5.c	2012-06-01 14:03:17.062826938 +0800
@@ -201,20 +201,39 @@ static int stripe_operations_active(stru
 	       test_bit(STRIPE_COMPUTE_RUN, &sh->state);
 }
 
-static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
+static void __release_stripe(struct r5conf *conf, struct stripe_head *sh,
+	int locking)
 {
+	unsigned long uninitialized_var(flags);
+
 	if (atomic_dec_and_test(&sh->count)) {
-		BUG_ON(!list_empty(&sh->lru));
+		/*
+		 * Before we hold device_lock, other thread can hit this stripe
+		 * in cache. It could do:
+		 * 1. just get_active_stripe(). The stripe count isn't 0 then.
+		 * 2. do get_active_stripe() and follow release_stripe(). So the
+		 * stripe might be already released and already in specific
+		 * list. we do list_move to adjust its position in the list.
+		 */
+		if (locking) {
+			spin_lock_irqsave(&conf->device_lock, flags);
+			if (atomic_read(&sh->count) != 0) {
+				spin_unlock_irqrestore(&conf->device_lock,
+							flags);
+				return;
+			}
+		}
+
 		BUG_ON(atomic_read(&conf->active_stripes)==0);
 		if (test_bit(STRIPE_HANDLE, &sh->state)) {
 			if (test_bit(STRIPE_DELAYED, &sh->state))
-				list_add_tail(&sh->lru, &conf->delayed_list);
+				list_move_tail(&sh->lru, &conf->delayed_list);
 			else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
 				   sh->bm_seq - conf->seq_write > 0)
-				list_add_tail(&sh->lru, &conf->bitmap_list);
+				list_move_tail(&sh->lru, &conf->bitmap_list);
 			else {
 				clear_bit(STRIPE_BIT_DELAY, &sh->state);
-				list_add_tail(&sh->lru, &conf->handle_list);
+				list_move_tail(&sh->lru, &conf->handle_list);
 			}
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
@@ -225,23 +244,22 @@ static void __release_stripe(struct r5co
 					md_wakeup_thread(conf->mddev->thread);
 			atomic_dec(&conf->active_stripes);
 			if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
-				list_add_tail(&sh->lru, &conf->inactive_list);
+				list_move_tail(&sh->lru, &conf->inactive_list);
 				wake_up(&conf->wait_for_stripe);
 				if (conf->retry_read_aligned)
 					md_wakeup_thread(conf->mddev->thread);
 			}
 		}
+		if (locking)
+			spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 }
 
 static void release_stripe(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
-	unsigned long flags;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
-	__release_stripe(conf, sh);
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	__release_stripe(conf, sh, 1);
 }
 
 static inline void remove_hash(struct stripe_head *sh)
@@ -484,9 +502,6 @@ get_active_stripe(struct r5conf *conf, s
 			} else {
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
-				if (list_empty(&sh->lru) &&
-				    !test_bit(STRIPE_EXPANDING, &sh->state))
-					BUG();
 				list_del_init(&sh->lru);
 			}
 		}
@@ -3672,7 +3687,7 @@ static void activate_bit_delay(struct r5
 		struct stripe_head *sh = list_entry(head.next, struct stripe_head, lru);
 		list_del_init(&sh->lru);
 		atomic_inc(&sh->count);
-		__release_stripe(conf, sh);
+		__release_stripe(conf, sh, 0);
 	}
 }
 

