From: Dennis Yang <dennisyang@qnap.com>
Subject: [PATCH] md/raid5: preserve STRIPE_ON_UNPLUG_LIST in break_stripe_batch_list
Date: Mon, 28 Aug 2017 20:01:59 +0800
Message-ID: <1503921720-21473-1-git-send-email-dennisyang@qnap.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Dennis Yang <dennisyang@qnap.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

break_stripe_batch_list() did not preserve STRIPE_ON_UNPLUG_LIST which is
set when a stripe_head gets queued to the stripe_head list maintained by
raid5_plug_cb and waiting for releasing after blk_unplug().

In release_stripe_plug(), if a stripe_head has its STRIPE_ON_UNPLUG_LIST
set, it indicates that this stripe_head is already in the raid5_plug_cb
list and release_stripe() would be called instead to drop a reference
count. Otherwise, the STRIPE_ON_UNPLUG_LIST bit would be set for this
stripe_head and it will get queued into the raid5_plug_cb list.

Without preserving STRIPE_ON_UNPLUG_LIST in break_stripe_batch_list(),
a stripe_head could be re-added to the raid5_plug_cb list while it is
currently on that list and waiting to be released. This would mess up
the raid5_plug_cb and leads to soft/hard lockup in raid5_unplug() or
kernel crash.

Signed-off-by: Dennis Yang <dennisyang@qnap.com>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e92dd2d..faf3cfd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4611,7 +4611,8 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 
 		set_mask_bits(&sh->state, ~(STRIPE_EXPAND_SYNC_FLAGS |
 					    (1 << STRIPE_PREREAD_ACTIVE) |
-					    (1 << STRIPE_DEGRADED)),
+					    (1 << STRIPE_DEGRADED) |
+					    (1 << STRIPE_ON_UNPLUG_LIST)),
 			      head_sh->state & (1 << STRIPE_INSYNC));
 
 		sh->check_state = head_sh->check_state;
-- 
1.9.1
