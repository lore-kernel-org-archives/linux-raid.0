From: Shaohua Li <shli@fb.com>
Subject: [patch v2 05/11] raid5: add a new state for stripe log handling
Date: Thu, 13 Aug 2015 14:31:58 -0700
Message-ID: <930e6ef57a2256464855cbf1bfd4b5cc2830e59e.1439500639.git.shli@fb.com>
References: <cover.1439500639.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1439500639.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

When a stripe finishes construction, we write the stripe to raid in
ops_run_io normally. With log, we do a bunch of other operations before
the stripe is written to raid. Mainly write the stripe to log disk,
flush disk cache and so on. The operations are still driven by raid5d
and run in the stripe state machine. We introduce a new state for such
stripe (trapped into log). The stripe is in this state from the time it
first enters ops_run_io (finish construction) to the time it is written
to raid. Since we know the state is only for log, we bypass other
check/operation in handle_stripe.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 3 +++
 drivers/md/raid5.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 786f811..bbdadee 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4322,6 +4322,9 @@ static void handle_stripe(struct stripe_head *sh)
 
 	analyse_stripe(sh, &s);
 
+	if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
+		goto finish;
+
 	if (s.handle_bad_blocks) {
 		set_bit(STRIPE_HANDLE, &sh->state);
 		goto finish;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index d8785df..6e85b82 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -340,6 +340,7 @@ enum {
 	STRIPE_BITMAP_PENDING,	/* Being added to bitmap, don't add
 				 * to batch yet.
 				 */
+	STRIPE_LOG_TRAPPED, /* trapped into log */
 };
 
 #define STRIPE_EXPAND_SYNC_FLAGS \
-- 
1.8.1

