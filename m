From: NeilBrown <neilb@suse.de>
Subject: [PATCH 5/8] md/raid5: add handle_flags arg to
 break_stripe_batch_list.
Date: Fri, 22 May 2015 15:30:58 +1000
Message-ID: <20150522053058.2117.23857.stgit@notabene.brown>
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

When we break a stripe_batch_list we sometimes want to set
STRIPE_HANDLE on the individual stripes, and sometimes not.

So pass a 'handle_flags' arg.  If it is zero, always set STRIPE_HANDLE
(on non-head stripes).  If not zero, only set it if any of the given
flags are present.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bfad47e36d1a..1f12a0bfa8bd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4226,7 +4226,8 @@ static int clear_batch_ready(struct stripe_head *sh)
 	return 0;
 }
 
-static void break_stripe_batch_list(struct stripe_head *head_sh)
+static void break_stripe_batch_list(struct stripe_head *head_sh,
+				    unsigned long handle_flags)
 {
 	struct stripe_head *sh, *next;
 	int i;
@@ -4252,8 +4253,9 @@ static void break_stripe_batch_list(struct stripe_head *head_sh)
 		spin_lock_irq(&sh->stripe_lock);
 		sh->batch_head = NULL;
 		spin_unlock_irq(&sh->stripe_lock);
-
-		set_bit(STRIPE_HANDLE, &sh->state);
+		if (handle_flags == 0 ||
+		    sh->state & handle_flags)
+			set_bit(STRIPE_HANDLE, &sh->state);
 		release_stripe(sh);
 	}
 	spin_lock_irq(&head_sh->stripe_lock);
@@ -4262,6 +4264,8 @@ static void break_stripe_batch_list(struct stripe_head *head_sh)
 	for (i = 0; i < head_sh->disks; i++)
 		if (test_and_clear_bit(R5_Overlap, &head_sh->dev[i].flags))
 			do_wakeup = 1;
+	if (head_sh->state & handle_flags)
+		set_bit(STRIPE_HANDLE, &head_sh->state);
 
 	if (do_wakeup)
 		wake_up(&head_sh->raid_conf->wait_for_overlap);
@@ -4290,7 +4294,7 @@ static void handle_stripe(struct stripe_head *sh)
 	}
 
 	if (test_and_clear_bit(STRIPE_BATCH_ERR, &sh->state))
-		break_stripe_batch_list(sh);
+		break_stripe_batch_list(sh, 0);
 
 	if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state) && !sh->batch_head) {
 		spin_lock(&sh->stripe_lock);


