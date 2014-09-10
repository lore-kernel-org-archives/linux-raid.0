From: shli@kernel.org
Subject: [patch v2 5/6] raid5: handle io error of batch list
Date: Wed, 10 Sep 2014 20:40:14 +0800
Message-ID: <20140910124320.020561161@kernel.org>
References: <20140910124009.810771309@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-handle-batch-io-err.patch
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If io error happens in any stripe of a batch list, the batch list will be
split, then normal process will run for the stripes in the list.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.h |    1 +
 2 files changed, 48 insertions(+)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-09-10 19:21:14.723296649 +0800
+++ linux/drivers/md/raid5.c	2014-09-10 19:21:14.715296750 +0800
@@ -1073,6 +1073,9 @@ again:
 			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
+			if (sh->batch_head)
+				set_bit(STRIPE_BATCH_ERR,
+					&sh->batch_head->state);
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
 
@@ -2382,6 +2385,9 @@ static void raid5_end_write_request(stru
 	}
 	rdev_dec_pending(rdev, conf->mddev);
 
+	if (sh->batch_head && !uptodate)
+		set_bit(STRIPE_BATCH_ERR, &sh->batch_head->state);
+
 	if (!test_and_clear_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags))
 		clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -4050,6 +4056,45 @@ static int clear_batch_ready(struct stri
 	return 0;
 }
 
+static void check_break_stripe_batch_list(struct stripe_head *sh)
+{
+	struct stripe_head *head_sh, *next;
+	int i;
+
+	if (!test_and_clear_bit(STRIPE_BATCH_ERR, &sh->state))
+		return;
+
+	head_sh = sh;
+	do {
+		sh = list_first_entry(&sh->batch_list,
+			struct stripe_head, batch_list);
+		BUG_ON(sh == head_sh);
+	} while (!test_bit(STRIPE_DEGRADED, &sh->state));
+
+	while (sh != head_sh) {
+		next = list_first_entry(&sh->batch_list,
+			struct stripe_head, batch_list);
+		list_del_init(&sh->batch_list);
+
+		sh->state = head_sh->state & (~((1 << STRIPE_ACTIVE) |
+			(1 << STRIPE_PREREAD_ACTIVE) | (1 << STRIPE_DEGRADED)));
+		sh->check_state = head_sh->check_state;
+		sh->reconstruct_state = head_sh->reconstruct_state;
+		for (i = 0; i < sh->disks; i++)
+			sh->dev[i].flags = head_sh->dev[i].flags &
+				(~((1 << R5_WriteError) | (1 << R5_Overlap)));
+
+		spin_lock_irq(&sh->stripe_lock);
+		sh->batch_head = NULL;
+		spin_unlock_irq(&sh->stripe_lock);
+
+		set_bit(STRIPE_HANDLE, &sh->state);
+		release_stripe(sh);
+
+		sh = next;
+	}
+}
+
 static void handle_stripe(struct stripe_head *sh)
 {
 	struct stripe_head_state s;
@@ -4072,6 +4117,8 @@ static void handle_stripe(struct stripe_
 		return;
 	}
 
+	check_break_stripe_batch_list(sh);
+
 	if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
 		spin_lock(&sh->stripe_lock);
 		/* Cannot process 'sync' concurrently with 'discard' */
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2014-09-10 19:21:14.723296649 +0800
+++ linux/drivers/md/raid5.h	2014-09-10 19:21:14.719296699 +0800
@@ -336,6 +336,7 @@ enum {
 	STRIPE_DISCARD,
 	STRIPE_ON_RELEASE_LIST,
 	STRIPE_BATCH_READY,
+	STRIPE_BATCH_ERR,
 };
 
 /*

