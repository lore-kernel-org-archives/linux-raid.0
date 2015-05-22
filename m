From: NeilBrown <neilb@suse.de>
Subject: [PATCH 7/8] md/raid5: call break_stripe_batch_list from
 handle_stripe_clean_event
Date: Fri, 22 May 2015 15:30:58 +1000
Message-ID: <20150522053058.2117.62863.stgit@notabene.brown>
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

Now that the code in break_stripe_batch_list() is nearly identical
to the end of handle_stripe_clean_event, replace the later
with a function call.

The only remaining difference of any interest is the masking that is
applieds to dev[i].flags copied from head_sh.
R5_WriteError certainly isn't wanted as it is set per-stripe, not
per-patch.  R5_Overlap isn't wanted as it is explicitly handled.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   61 +++-------------------------------------------------
 1 file changed, 4 insertions(+), 57 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 39901e2b5502..90da2376e0bb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3412,6 +3412,8 @@ static void handle_stripe_fill(struct stripe_head *sh,
 	set_bit(STRIPE_HANDLE, &sh->state);
 }
 
+static void break_stripe_batch_list(struct stripe_head *head_sh,
+				    unsigned long handle_flags);
 /* handle_stripe_clean_event
  * any written block on an uptodate or failed drive can be returned.
  * Note that if we 'wrote' to a failed drive, it will be UPTODATE, but
@@ -3425,7 +3427,6 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 	int discard_pending = 0;
 	struct stripe_head *head_sh = sh;
 	bool do_endio = false;
-	int wakeup_nr = 0;
 
 	for (i = disks; i--; )
 		if (sh->dev[i].written) {
@@ -3514,62 +3515,8 @@ unhash:
 		if (atomic_dec_and_test(&conf->pending_full_writes))
 			md_wakeup_thread(conf->mddev->thread);
 
-	if (!head_sh->batch_head || !do_endio)
-		return;
-	for (i = 0; i < head_sh->disks; i++) {
-		if (test_and_clear_bit(R5_Overlap, &head_sh->dev[i].flags))
-			wakeup_nr++;
-	}
-	while (!list_empty(&head_sh->batch_list)) {
-		int i;
-		sh = list_first_entry(&head_sh->batch_list,
-				      struct stripe_head, batch_list);
-		list_del_init(&sh->batch_list);
-
-		WARN_ON_ONCE(sh->state & ((1 << STRIPE_ACTIVE) |
-					  (1 << STRIPE_SYNCING) |
-					  (1 << STRIPE_REPLACED) |
-					  (1 << STRIPE_PREREAD_ACTIVE) |
-					  (1 << STRIPE_DELAYED) |
-					  (1 << STRIPE_BIT_DELAY) |
-					  (1 << STRIPE_FULL_WRITE) |
-					  (1 << STRIPE_BIOFILL_RUN) |
-					  (1 << STRIPE_COMPUTE_RUN)  |
-					  (1 << STRIPE_OPS_REQ_PENDING) |
-					  (1 << STRIPE_ON_UNPLUG_LIST) |
-					  (1 << STRIPE_DISCARD) |
-					  (1 << STRIPE_ON_RELEASE_LIST) |
-					  (1 << STRIPE_BATCH_READY) |
-					  (1 << STRIPE_BATCH_ERR)));
-		WARN_ON_ONCE(head_sh->state & ((1 << STRIPE_DISCARD) |
-					      (1 << STRIPE_REPLACED)));
-
-		set_mask_bits(&sh->state, ~(STRIPE_EXPAND_SYNC_FLAGS |
-					    (1 << STRIPE_DEGRADED)),
-			      head_sh->state & (1 << STRIPE_INSYNC));
-
-		sh->check_state = head_sh->check_state;
-		sh->reconstruct_state = head_sh->reconstruct_state;
-		for (i = 0; i < sh->disks; i++) {
-			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-				wakeup_nr++;
-			sh->dev[i].flags = head_sh->dev[i].flags;
-		}
-
-		spin_lock_irq(&sh->stripe_lock);
-		sh->batch_head = NULL;
-		spin_unlock_irq(&sh->stripe_lock);
-		if (sh->state & STRIPE_EXPAND_SYNC_FLAGS)
-			set_bit(STRIPE_HANDLE, &sh->state);
-		release_stripe(sh);
-	}
-
-	spin_lock_irq(&head_sh->stripe_lock);
-	head_sh->batch_head = NULL;
-	spin_unlock_irq(&head_sh->stripe_lock);
-	wake_up_nr(&conf->wait_for_overlap, wakeup_nr);
-	if (head_sh->state & STRIPE_EXPAND_SYNC_FLAGS)
-		set_bit(STRIPE_HANDLE, &head_sh->state);
+	if (head_sh->batch_head && do_endio)
+		break_stripe_batch_list(head_sh, STRIPE_EXPAND_SYNC_FLAGS);
 }
 
 static void handle_stripe_dirtying(struct r5conf *conf,


