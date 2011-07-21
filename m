From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/34] md/raid5: Remove use of sh->lock in sync_request
Date: Thu, 21 Jul 2011 12:32:25 +1000
Message-ID: <20110721023225.6728.58904.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is the start of a series of patches to remove sh->lock.

sync_request takes sh->lock before setting STRIPE_SYNCING to ensure
there is no race with testing it in handle_stripe[56].

Instead, use a new flag STRIPE_SYNC_REQUESTED and test it early
in handle_stripe[56] (after getting the same lock) and perform the
same set/clear operations if it was set.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   13 +++++++++----
 drivers/md/raid5.h |   33 ++++++++++++++++++---------------
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7148064..f2f2ab3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3022,6 +3022,10 @@ static void handle_stripe5(struct stripe_head *sh)
 		 sh->reconstruct_state);
 
 	spin_lock(&sh->lock);
+	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
+		set_bit(STRIPE_SYNCING, &sh->state);
+		clear_bit(STRIPE_INSYNC, &sh->state);
+	}
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
@@ -3313,6 +3317,10 @@ static void handle_stripe6(struct stripe_head *sh)
 	memset(&s, 0, sizeof(s));
 
 	spin_lock(&sh->lock);
+	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
+		set_bit(STRIPE_SYNCING, &sh->state);
+		clear_bit(STRIPE_INSYNC, &sh->state);
+	}
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
@@ -4373,10 +4381,7 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 
 	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_degraded);
 
-	spin_lock(&sh->lock);
-	set_bit(STRIPE_SYNCING, &sh->state);
-	clear_bit(STRIPE_INSYNC, &sh->state);
-	spin_unlock(&sh->lock);
+	set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
 
 	handle_stripe(sh);
 	release_stripe(sh);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 3ca77a2..a330011 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -289,21 +289,24 @@ struct r6_state {
 /*
  * Stripe state
  */
-#define STRIPE_HANDLE		2
-#define	STRIPE_SYNCING		3
-#define	STRIPE_INSYNC		4
-#define	STRIPE_PREREAD_ACTIVE	5
-#define	STRIPE_DELAYED		6
-#define	STRIPE_DEGRADED		7
-#define	STRIPE_BIT_DELAY	8
-#define	STRIPE_EXPANDING	9
-#define	STRIPE_EXPAND_SOURCE	10
-#define	STRIPE_EXPAND_READY	11
-#define	STRIPE_IO_STARTED	12 /* do not count towards 'bypass_count' */
-#define	STRIPE_FULL_WRITE	13 /* all blocks are set to be overwritten */
-#define	STRIPE_BIOFILL_RUN	14
-#define	STRIPE_COMPUTE_RUN	15
-#define	STRIPE_OPS_REQ_PENDING	16
+enum {
+	STRIPE_HANDLE,
+	STRIPE_SYNC_REQUESTED,
+	STRIPE_SYNCING,
+	STRIPE_INSYNC,
+	STRIPE_PREREAD_ACTIVE,
+	STRIPE_DELAYED,
+	STRIPE_DEGRADED,
+	STRIPE_BIT_DELAY,
+	STRIPE_EXPANDING,
+	STRIPE_EXPAND_SOURCE,
+	STRIPE_EXPAND_READY,
+	STRIPE_IO_STARTED,	/* do not count towards 'bypass_count' */
+	STRIPE_FULL_WRITE,	/* all blocks are set to be overwritten */
+	STRIPE_BIOFILL_RUN,
+	STRIPE_COMPUTE_RUN,
+	STRIPE_OPS_REQ_PENDING,
+};
 
 /*
  * Operation request flags


