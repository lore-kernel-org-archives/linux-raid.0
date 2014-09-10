From: shli@kernel.org
Subject: [patch v2 6/6] raid5: handle expansion/resync case with stripe batching
Date: Wed, 10 Sep 2014 20:40:15 +0800
Message-ID: <20140910124326.392941811@kernel.org>
References: <20140910124009.810771309@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-handle-resync-stripe-for-batching.patch
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

expansion/resync can grab a stripe when the stripe is in batch list. Since all
stripes in batch list must be in the same state, we can't allow some stripes
run into expansion/resync. So we delay expansion/resync for stripe in batch
list.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   22 +++++++++++++++-------
 drivers/md/raid5.h |    5 +++++
 2 files changed, 20 insertions(+), 7 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-09-10 19:21:16.759271053 +0800
+++ linux/drivers/md/raid5.c	2014-09-10 19:21:16.755271103 +0800
@@ -3371,8 +3371,10 @@ unhash:
 			struct stripe_head, batch_list);
 		list_del_init(&sh->batch_list);
 
-		sh->state = head_sh->state & (~((1 << STRIPE_ACTIVE) |
-			(1 << STRIPE_PREREAD_ACTIVE)));
+		set_mask_bits(&sh->state, ~STRIPE_EXPAND_SYNC_FLAG,
+			head_sh->state & (~((1 << STRIPE_ACTIVE) |
+			(1 << STRIPE_PREREAD_ACTIVE) |
+			STRIPE_EXPAND_SYNC_FLAG)));
 		sh->check_state = head_sh->check_state;
 		sh->reconstruct_state = head_sh->reconstruct_state;
 		for (i = 0; i < sh->disks; i++) {
@@ -3384,6 +3386,8 @@ unhash:
 		spin_lock_irq(&sh->stripe_lock);
 		sh->batch_head = NULL;
 		spin_unlock_irq(&sh->stripe_lock);
+		if (sh->state & STRIPE_EXPAND_SYNC_FLAG)
+			set_bit(STRIPE_HANDLE, &sh->state);
 		release_stripe(sh);
 	}
 
@@ -3391,6 +3395,8 @@ unhash:
 	head_sh->batch_head = NULL;
 	spin_unlock_irq(&head_sh->stripe_lock);
 	wake_up_nr(&conf->wait_for_overlap, wakeup_nr);
+	if (head_sh->state & STRIPE_EXPAND_SYNC_FLAG)
+		set_bit(STRIPE_HANDLE, &head_sh->state);
 }
 
 static void handle_stripe_dirtying(struct r5conf *conf,
@@ -3853,8 +3859,8 @@ static void analyse_stripe(struct stripe
 
 	memset(s, 0, sizeof(*s));
 
-	s->expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-	s->expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
+	s->expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state) && !sh->batch_head;
+	s->expanded = test_bit(STRIPE_EXPAND_READY, &sh->state) && !sh->batch_head;
 	s->failed_num[0] = -1;
 	s->failed_num[1] = -1;
 
@@ -4076,8 +4082,10 @@ static void check_break_stripe_batch_lis
 			struct stripe_head, batch_list);
 		list_del_init(&sh->batch_list);
 
-		sh->state = head_sh->state & (~((1 << STRIPE_ACTIVE) |
-			(1 << STRIPE_PREREAD_ACTIVE) | (1 << STRIPE_DEGRADED)));
+		set_mask_bits(&sh->state, ~STRIPE_EXPAND_SYNC_FLAG,
+			head_sh->state & (~((1 << STRIPE_ACTIVE) |
+			(1 << STRIPE_PREREAD_ACTIVE) | (1 << STRIPE_DEGRADED) |
+			STRIPE_EXPAND_SYNC_FLAG)));
 		sh->check_state = head_sh->check_state;
 		sh->reconstruct_state = head_sh->reconstruct_state;
 		for (i = 0; i < sh->disks; i++)
@@ -4119,7 +4127,7 @@ static void handle_stripe(struct stripe_
 
 	check_break_stripe_batch_list(sh);
 
-	if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
+	if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state) && !sh->batch_head) {
 		spin_lock(&sh->stripe_lock);
 		/* Cannot process 'sync' concurrently with 'discard' */
 		if (!test_bit(STRIPE_DISCARD, &sh->state) &&
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2014-09-10 19:21:16.759271053 +0800
+++ linux/drivers/md/raid5.h	2014-09-10 19:21:16.755271103 +0800
@@ -339,6 +339,11 @@ enum {
 	STRIPE_BATCH_ERR,
 };
 
+#define STRIPE_EXPAND_SYNC_FLAG \
+	((1 << STRIPE_EXPAND_SOURCE) |\
+	(1 << STRIPE_EXPAND_READY) |\
+	(1 << STRIPE_EXPANDING) |\
+	(1 << STRIPE_SYNC_REQUESTED))
 /*
  * Operation request flags
  */

