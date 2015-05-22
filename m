From: NeilBrown <neilb@suse.de>
Subject: [PATCH 6/8] md/raid5: be more selective about distributing flags
 across batch.
Date: Fri, 22 May 2015 15:30:58 +1000
Message-ID: <20150522053058.2117.62712.stgit@notabene.brown>
References: <20150522052802.2117.40527.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150522052802.2117.40527.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When a batch of stripes is broken up, we keep some of the flags
that were per-stripe, and copy other flags from the head to all
others.

This only happens while a stripe is being handled, so many of the
flags are irrelevant.

The "SYNC_FLAGS" (which I've renamed to make it clear there are
several) and STRIPE_DEGRADED are set per-stripe and so need to be
preserved.  STRIPE_INSYNC is the only flag that is set on the head
that needs to be propagated to all others.

For safety, add a WARN_ON if others are set.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   57 ++++++++++++++++++++++++++++++++++++++++++----------
 drivers/md/raid5.h |    2 +-
 2 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1f12a0bfa8bd..39901e2b5502 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3526,10 +3526,28 @@ unhash:
 				      struct stripe_head, batch_list);
 		list_del_init(&sh->batch_list);
 
-		set_mask_bits(&sh->state, ~STRIPE_EXPAND_SYNC_FLAG,
-			      head_sh->state & ~((1 << STRIPE_ACTIVE) |
-						 (1 << STRIPE_PREREAD_ACTIVE) |
-						 STRIPE_EXPAND_SYNC_FLAG));
+		WARN_ON_ONCE(sh->state & ((1 << STRIPE_ACTIVE) |
+					  (1 << STRIPE_SYNCING) |
+					  (1 << STRIPE_REPLACED) |
+					  (1 << STRIPE_PREREAD_ACTIVE) |
+					  (1 << STRIPE_DELAYED) |
+					  (1 << STRIPE_BIT_DELAY) |
+					  (1 << STRIPE_FULL_WRITE) |
+					  (1 << STRIPE_BIOFILL_RUN) |
+					  (1 << STRIPE_COMPUTE_RUN)  |
+					  (1 << STRIPE_OPS_REQ_PENDING) |
+					  (1 << STRIPE_ON_UNPLUG_LIST) |
+					  (1 << STRIPE_DISCARD) |
+					  (1 << STRIPE_ON_RELEASE_LIST) |
+					  (1 << STRIPE_BATCH_READY) |
+					  (1 << STRIPE_BATCH_ERR)));
+		WARN_ON_ONCE(head_sh->state & ((1 << STRIPE_DISCARD) |
+					      (1 << STRIPE_REPLACED)));
+
+		set_mask_bits(&sh->state, ~(STRIPE_EXPAND_SYNC_FLAGS |
+					    (1 << STRIPE_DEGRADED)),
+			      head_sh->state & (1 << STRIPE_INSYNC));
+
 		sh->check_state = head_sh->check_state;
 		sh->reconstruct_state = head_sh->reconstruct_state;
 		for (i = 0; i < sh->disks; i++) {
@@ -3541,7 +3559,7 @@ unhash:
 		spin_lock_irq(&sh->stripe_lock);
 		sh->batch_head = NULL;
 		spin_unlock_irq(&sh->stripe_lock);
-		if (sh->state & STRIPE_EXPAND_SYNC_FLAG)
+		if (sh->state & STRIPE_EXPAND_SYNC_FLAGS)
 			set_bit(STRIPE_HANDLE, &sh->state);
 		release_stripe(sh);
 	}
@@ -3550,7 +3568,7 @@ unhash:
 	head_sh->batch_head = NULL;
 	spin_unlock_irq(&head_sh->stripe_lock);
 	wake_up_nr(&conf->wait_for_overlap, wakeup_nr);
-	if (head_sh->state & STRIPE_EXPAND_SYNC_FLAG)
+	if (head_sh->state & STRIPE_EXPAND_SYNC_FLAGS)
 		set_bit(STRIPE_HANDLE, &head_sh->state);
 }
 
@@ -4237,11 +4255,28 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 
 		list_del_init(&sh->batch_list);
 
-		set_mask_bits(&sh->state, ~STRIPE_EXPAND_SYNC_FLAG,
-			      head_sh->state & ~((1 << STRIPE_ACTIVE) |
-						 (1 << STRIPE_PREREAD_ACTIVE) |
-						 (1 << STRIPE_DEGRADED) |
-						 STRIPE_EXPAND_SYNC_FLAG));
+		WARN_ON_ONCE(sh->state & ((1 << STRIPE_ACTIVE) |
+					  (1 << STRIPE_SYNCING) |
+					  (1 << STRIPE_REPLACED) |
+					  (1 << STRIPE_PREREAD_ACTIVE) |
+					  (1 << STRIPE_DELAYED) |
+					  (1 << STRIPE_BIT_DELAY) |
+					  (1 << STRIPE_FULL_WRITE) |
+					  (1 << STRIPE_BIOFILL_RUN) |
+					  (1 << STRIPE_COMPUTE_RUN)  |
+					  (1 << STRIPE_OPS_REQ_PENDING) |
+					  (1 << STRIPE_ON_UNPLUG_LIST) |
+					  (1 << STRIPE_DISCARD) |
+					  (1 << STRIPE_ON_RELEASE_LIST) |
+					  (1 << STRIPE_BATCH_READY) |
+					  (1 << STRIPE_BATCH_ERR)));
+		WARN_ON_ONCE(head_sh->state & ((1 << STRIPE_DISCARD) |
+					      (1 << STRIPE_REPLACED)));
+
+		set_mask_bits(&sh->state, ~(STRIPE_EXPAND_SYNC_FLAGS |
+					    (1 << STRIPE_DEGRADED)),
+			      head_sh->state & (1 << STRIPE_INSYNC));
+
 		sh->check_state = head_sh->check_state;
 		sh->reconstruct_state = head_sh->reconstruct_state;
 		for (i = 0; i < sh->disks; i++) {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 6307b904d318..d7b2bc8b756f 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -339,7 +339,7 @@ enum {
 	STRIPE_BATCH_ERR,
 };
 
-#define STRIPE_EXPAND_SYNC_FLAG \
+#define STRIPE_EXPAND_SYNC_FLAGS \
 	((1 << STRIPE_EXPAND_SOURCE) |\
 	(1 << STRIPE_EXPAND_READY) |\
 	(1 << STRIPE_EXPANDING) |\


