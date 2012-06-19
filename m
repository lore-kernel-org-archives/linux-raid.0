From: Shaohua Li <shli@kernel.org>
Subject: [patch 5/9 v2] raid5: reduce chance release_stripe() taking device_lock
Date: Tue, 19 Jun 2012 09:59:46 +0800
Message-ID: <20120619020124.124186362@kernel.org>
References: <20120619015941.891400722@kernel.org>
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
 drivers/md/raid5.c |   79 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 34 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-08 13:18:39.296561227 +0800
+++ linux/drivers/md/raid5.c	2012-06-08 13:38:38.209487084 +0800
@@ -196,47 +196,61 @@ static int stripe_operations_active(stru
 	       test_bit(STRIPE_COMPUTE_RUN, &sh->state);
 }
 
-static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
+static void handle_release_stripe(struct r5conf *conf, struct stripe_head *sh)
 {
-	if (atomic_dec_and_test(&sh->count)) {
-		BUG_ON(!list_empty(&sh->lru));
-		BUG_ON(atomic_read(&conf->active_stripes)==0);
-		if (test_bit(STRIPE_HANDLE, &sh->state)) {
-			if (test_bit(STRIPE_DELAYED, &sh->state))
-				list_add_tail(&sh->lru, &conf->delayed_list);
-			else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
-				   sh->bm_seq - conf->seq_write > 0)
-				list_add_tail(&sh->lru, &conf->bitmap_list);
-			else {
-				clear_bit(STRIPE_BIT_DELAY, &sh->state);
-				list_add_tail(&sh->lru, &conf->handle_list);
-			}
-			md_wakeup_thread(conf->mddev->thread);
-		} else {
-			BUG_ON(stripe_operations_active(sh));
-			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-				if (atomic_dec_return(&conf->preread_active_stripes)
-				    < IO_THRESHOLD)
-					md_wakeup_thread(conf->mddev->thread);
-			atomic_dec(&conf->active_stripes);
-			if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
-				list_add_tail(&sh->lru, &conf->inactive_list);
-				wake_up(&conf->wait_for_stripe);
-				if (conf->retry_read_aligned)
-					md_wakeup_thread(conf->mddev->thread);
-			}
+	/*
+	 * Before we hold device_lock, other thread can hit this stripe
+	 * in cache. It could do:
+	 * 1. just get_active_stripe(). The stripe count isn't 0 then.
+	 * 2. do get_active_stripe() and follow release_stripe(). So the
+	 * stripe might be already released and already in specific
+	 * list. we do list_move to adjust its position in the list.
+	 */
+	BUG_ON(atomic_read(&conf->active_stripes)==0);
+	if (test_bit(STRIPE_HANDLE, &sh->state)) {
+		if (test_bit(STRIPE_DELAYED, &sh->state))
+			list_move_tail(&sh->lru, &conf->delayed_list);
+		else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
+			   sh->bm_seq - conf->seq_write > 0)
+			list_move_tail(&sh->lru, &conf->bitmap_list);
+		else {
+			clear_bit(STRIPE_BIT_DELAY, &sh->state);
+			list_move_tail(&sh->lru, &conf->handle_list);
+		}
+		md_wakeup_thread(conf->mddev->thread);
+	} else {
+		BUG_ON(stripe_operations_active(sh));
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+			if (atomic_dec_return(&conf->preread_active_stripes)
+			    < IO_THRESHOLD)
+				md_wakeup_thread(conf->mddev->thread);
+		atomic_dec(&conf->active_stripes);
+		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
+			list_move_tail(&sh->lru, &conf->inactive_list);
+			wake_up(&conf->wait_for_stripe);
+			if (conf->retry_read_aligned)
+				md_wakeup_thread(conf->mddev->thread);
 		}
 	}
 }
 
+static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
+{
+	if (atomic_dec_and_test(&sh->count))
+		handle_release_stripe(conf, sh);
+}
+
 static void release_stripe(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&conf->device_lock, flags);
-	__release_stripe(conf, sh);
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	local_irq_save(flags);
+	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
+		handle_release_stripe(conf, sh);
+		spin_unlock(&conf->device_lock);
+	}
+	local_irq_restore(flags);
 }
 
 static inline void remove_hash(struct stripe_head *sh)
@@ -479,9 +493,6 @@ get_active_stripe(struct r5conf *conf, s
 			} else {
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
-				if (list_empty(&sh->lru) &&
-				    !test_bit(STRIPE_EXPANDING, &sh->state))
-					BUG();
 				list_del_init(&sh->lru);
 			}
 		}

