From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/34] md/raid5: move common code into handle_stripe
Date: Thu, 21 Jul 2011 12:32:25 +1000
Message-ID: <20110721023225.6728.48548.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is common code at the start of handle_stripe5 and
handle_stripe6.  Move it into handle_stripe.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f8275b5..dfb3d9f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3016,12 +3016,6 @@ static void handle_stripe5(struct stripe_head *sh)
 		 atomic_read(&sh->count), sh->pd_idx, sh->check_state,
 		 sh->reconstruct_state);
 
-	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
-		set_bit(STRIPE_SYNCING, &sh->state);
-		clear_bit(STRIPE_INSYNC, &sh->state);
-	}
-	clear_bit(STRIPE_DELAYED, &sh->state);
-
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
@@ -3310,12 +3304,6 @@ static void handle_stripe6(struct stripe_head *sh)
 	       sh->check_state, sh->reconstruct_state);
 	memset(&s, 0, sizeof(s));
 
-	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
-		set_bit(STRIPE_SYNCING, &sh->state);
-		clear_bit(STRIPE_INSYNC, &sh->state);
-	}
-	clear_bit(STRIPE_DELAYED, &sh->state);
-
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
@@ -3607,6 +3595,12 @@ static void handle_stripe(struct stripe_head *sh)
 		return;
 	}
 
+	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
+		set_bit(STRIPE_SYNCING, &sh->state);
+		clear_bit(STRIPE_INSYNC, &sh->state);
+	}
+	clear_bit(STRIPE_DELAYED, &sh->state);
+
 	if (sh->raid_conf->level == 6)
 		handle_stripe6(sh);
 	else


