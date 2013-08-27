From: Shaohua Li <shli@kernel.org>
Subject: [patch v3 1/5] raid5: make release_stripe lockless
Date: Tue, 27 Aug 2013 17:50:39 +0800
Message-ID: <20130827095427.324728970@kernel.org>
References: <20130827095038.303090029@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-reduce-release_stripe.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

release_stripe still has big lock contention. We just add the stripe to a llist
without taking device_lock. We let the raid5d thread to do the real stripe
release, which must hold device_lock anyway. In this way, release_stripe
doesn't hold any locks.

The side effect is the released stripes order is changed. But sounds not a big
deal, stripes are never handled in order. And I thought block layer can already
do nice request merge, which means order isn't that important.

I kept the unplug release batch, which is unnecessary with this patch from lock
contention avoid point of view, and actually if we delete it, the stripe_head
release_list and lru can share storage. But the unplug release batch is also
helpful for request merge. We probably can delay wakeup raid5d till unplug, but
I'm still afraid of the case which raid5d is running.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/raid5.h |    3 +++
 2 files changed, 49 insertions(+), 3 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-08-27 16:58:13.526743800 +0800
+++ linux/drivers/md/raid5.c	2013-08-27 16:58:13.522743850 +0800
@@ -239,12 +239,47 @@ static void __release_stripe(struct r5co
 		do_release_stripe(conf, sh);
 }
 
+/* should hold conf->device_lock already */
+static int release_stripe_list(struct r5conf *conf)
+{
+	struct stripe_head *sh;
+	int count = 0;
+	struct llist_node *head;
+
+	head = llist_del_all(&conf->released_stripes);
+	while (head) {
+		sh = llist_entry(head, struct stripe_head, release_list);
+		head = llist_next(head);
+		/* sh could be readded after STRIPE_ON_RELEASE_LIST is cleard */
+		smp_mb();
+		clear_bit(STRIPE_ON_RELEASE_LIST, &sh->state);
+		/*
+		 * Don't worry the bit is set here, because if the bit is set
+		 * again, the count is always > 1. This is true for
+		 * STRIPE_ON_UNPLUG_LIST bit too.
+		 */
+		__release_stripe(conf, sh);
+		count++;
+	}
+
+	return count;
+}
+
 static void release_stripe(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 	unsigned long flags;
+	bool wakeup;
 
+	if (test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
+		goto slow_path;
+	wakeup = llist_add(&sh->release_list, &conf->released_stripes);
+	if (wakeup)
+		md_wakeup_thread(conf->mddev->thread);
+	return;
+slow_path:
 	local_irq_save(flags);
+	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
 	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
 		do_release_stripe(conf, sh);
 		spin_unlock(&conf->device_lock);
@@ -491,7 +526,8 @@ get_active_stripe(struct r5conf *conf, s
 			if (atomic_read(&sh->count)) {
 				BUG_ON(!list_empty(&sh->lru)
 				    && !test_bit(STRIPE_EXPANDING, &sh->state)
-				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state));
+				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state)
+				    && !test_bit(STRIPE_ON_RELEASE_LIST, &sh->state));
 			} else {
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
@@ -4127,6 +4163,10 @@ static void raid5_unplug(struct blk_plug
 			 */
 			smp_mb__before_clear_bit();
 			clear_bit(STRIPE_ON_UNPLUG_LIST, &sh->state);
+			/*
+			 * STRIPE_ON_RELEASE_LIST could be set here. In that
+			 * case, the count is always > 1 here
+			 */
 			__release_stripe(conf, sh);
 			cnt++;
 		}
@@ -4845,7 +4885,9 @@ static void raid5d(struct md_thread *thr
 	spin_lock_irq(&conf->device_lock);
 	while (1) {
 		struct bio *bio;
-		int batch_size;
+		int batch_size, released;
+
+		released = release_stripe_list(conf);
 
 		if (
 		    !list_empty(&conf->bitmap_list)) {
@@ -4870,7 +4912,7 @@ static void raid5d(struct md_thread *thr
 		}
 
 		batch_size = handle_active_stripes(conf);
-		if (!batch_size)
+		if (!batch_size && !released)
 			break;
 		handled += batch_size;
 
@@ -5186,6 +5228,7 @@ static struct r5conf *setup_conf(struct
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
 	INIT_LIST_HEAD(&conf->inactive_list);
+	init_llist_head(&conf->released_stripes);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2013-08-27 16:58:13.526743800 +0800
+++ linux/drivers/md/raid5.h	2013-08-27 16:58:13.522743850 +0800
@@ -197,6 +197,7 @@ enum reconstruct_states {
 struct stripe_head {
 	struct hlist_node	hash;
 	struct list_head	lru;	      /* inactive_list or handle_list */
+	struct llist_node	release_list;
 	struct r5conf		*raid_conf;
 	short			generation;	/* increments with every
 						 * reshape */
@@ -321,6 +322,7 @@ enum {
 	STRIPE_OPS_REQ_PENDING,
 	STRIPE_ON_UNPLUG_LIST,
 	STRIPE_DISCARD,
+	STRIPE_ON_RELEASE_LIST,
 };
 
 /*
@@ -446,6 +448,7 @@ struct r5conf {
 	 */
 	atomic_t		active_stripes;
 	struct list_head	inactive_list;
+	struct llist_head	released_stripes;
 	wait_queue_head_t	wait_for_stripe;
 	wait_queue_head_t	wait_for_overlap;
 	int			inactive_blocked;	/* release of inactive stripes blocked,

