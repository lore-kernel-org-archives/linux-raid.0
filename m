From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] md/r5cache: handle sync with data in write back cache
Date: Thu, 11 May 2017 17:03:44 -0700
Message-ID: <20170512000344.2509283-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Currently, sync of raid456 array cannot make progress when hitting
data in writeback r5cache.

This patch fixes this issue by flushing cached data of the stripe
before processing the sync request. This is achived by:

1. In handle_stripe(), do not set STRIPE_SYNCING if the stripe is
   in write back cache;
2. In r5c_try_caching_write(), handle the stripe in sync with write
   through;
3. In do_release_stripe(), make stripe in sync write out and send
   it to the state machine.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c |  5 ++++-
 drivers/md/raid5.c       | 21 +++++++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index a6a62e2..f476105 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2631,8 +2631,11 @@ int r5c_try_caching_write(struct r5conf *conf,
 	 * When run in degraded mode, array is set to write-through mode.
 	 * This check helps drain pending write safely in the transition to
 	 * write-through mode.
+	 *
+	 * When a stripe is syncing, the write is also handled in write
+	 * through mode.
 	 */
-	if (s->failed) {
+	if (s->failed || test_bit(STRIPE_SYNCING, &sh->state)) {
 		r5c_make_stripe_write_out(sh);
 		return -EAGAIN;
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f8055a7..680b1f6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -233,11 +233,15 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			if (test_bit(R5_InJournal, &sh->dev[i].flags))
 				injournal++;
 	/*
-	 * When quiesce in r5c write back, set STRIPE_HANDLE for stripes with
-	 * data in journal, so they are not released to cached lists
+	 * In the following cases, the stripe cannot be released to cached
+	 * lists. Therefore, we make the stripe write out and set
+	 * STRIPE_HANDLE:
+	 *   1. when quiesce in r5c write back;
+	 *   2. when resync is requested fot the stripe.
 	 */
-	if (conf->quiesce && r5c_is_writeback(conf->log) &&
-	    !test_bit(STRIPE_HANDLE, &sh->state) && injournal != 0) {
+	if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state) ||
+	    (conf->quiesce && r5c_is_writeback(conf->log) &&
+	     !test_bit(STRIPE_HANDLE, &sh->state) && injournal != 0)) {
 		if (test_bit(STRIPE_R5C_CACHING, &sh->state))
 			r5c_make_stripe_write_out(sh);
 		set_bit(STRIPE_HANDLE, &sh->state);
@@ -4648,8 +4652,13 @@ static void handle_stripe(struct stripe_head *sh)
 
 	if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state) && !sh->batch_head) {
 		spin_lock(&sh->stripe_lock);
-		/* Cannot process 'sync' concurrently with 'discard' */
-		if (!test_bit(STRIPE_DISCARD, &sh->state) &&
+		/*
+		 * Cannot process 'sync' concurrently with 'discard'.
+		 * Flush data in r5cache before 'sync'.
+		 */
+		if (!test_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state) &&
+		    !test_bit(STRIPE_R5C_FULL_STRIPE, &sh->state) &&
+		    !test_bit(STRIPE_DISCARD, &sh->state) &&
 		    test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
 			set_bit(STRIPE_SYNCING, &sh->state);
 			clear_bit(STRIPE_INSYNC, &sh->state);
-- 
2.9.3

