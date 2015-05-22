From: NeilBrown <neilb@suse.de>
Subject: [PATCH 4/8] md/raid5: duplicate some more handle_stripe_clean_event
 code in break_stripe_batch_list
Date: Fri, 22 May 2015 15:30:58 +1000
Message-ID: <20150522053058.2117.39913.stgit@notabene.brown>
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

break_stripe_batch list didn't clear head_sh->batch_head.
This was probably a bug.

Also clear all R5_Overlap flags and if any were cleared, wake up
'wait_for_overlap'.
This isn't always necessary but the worst effect is a little
extra checking for code that is waiting on wait_for_overlap.

Also, don't use wake_up_nr() because that does the wrong thing
if 'nr' is zero, and it number of flags cleared doesn't
strongly correlate with the number of threads to wake.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4952205460e5..bfad47e36d1a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4230,6 +4230,7 @@ static void break_stripe_batch_list(struct stripe_head *head_sh)
 {
 	struct stripe_head *sh, *next;
 	int i;
+	int do_wakeup = 0;
 
 	list_for_each_entry_safe(sh, next, &head_sh->batch_list, batch_list) {
 
@@ -4242,10 +4243,12 @@ static void break_stripe_batch_list(struct stripe_head *head_sh)
 						 STRIPE_EXPAND_SYNC_FLAG));
 		sh->check_state = head_sh->check_state;
 		sh->reconstruct_state = head_sh->reconstruct_state;
-		for (i = 0; i < sh->disks; i++)
+		for (i = 0; i < sh->disks; i++) {
+			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				do_wakeup = 1;
 			sh->dev[i].flags = head_sh->dev[i].flags &
 				(~((1 << R5_WriteError) | (1 << R5_Overlap)));
-
+		}
 		spin_lock_irq(&sh->stripe_lock);
 		sh->batch_head = NULL;
 		spin_unlock_irq(&sh->stripe_lock);
@@ -4253,6 +4256,15 @@ static void break_stripe_batch_list(struct stripe_head *head_sh)
 		set_bit(STRIPE_HANDLE, &sh->state);
 		release_stripe(sh);
 	}
+	spin_lock_irq(&head_sh->stripe_lock);
+	head_sh->batch_head = NULL;
+	spin_unlock_irq(&head_sh->stripe_lock);
+	for (i = 0; i < head_sh->disks; i++)
+		if (test_and_clear_bit(R5_Overlap, &head_sh->dev[i].flags))
+			do_wakeup = 1;
+
+	if (do_wakeup)
+		wake_up(&head_sh->raid_conf->wait_for_overlap);
 }
 
 static void handle_stripe(struct stripe_head *sh)


