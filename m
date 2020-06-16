From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 1/3] raid5: call clear_batch_ready before set STRIPE_ACTIVE
Date: Tue, 16 Jun 2020 11:25:50 +0200
Message-ID: <20200616092552.1754-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

We tried to only put the head sh of batch list to handle_list, then the
handle_stripe doesn't handle other members in the batch list. However,
we still got the calltrace in break_stripe_batch_list.

[593764.644269] stripe state: 2003
kernel: [593764.644299] ------------[ cut here ]------------
kernel: [593764.644308] WARNING: CPU: 12 PID: 856 at drivers/md/raid5.c:4625 break_stripe_batch_list+0x203/0x240 [raid456]
[...]
kernel: [593764.644363] Call Trace:
kernel: [593764.644370]  handle_stripe+0x907/0x20c0 [raid456]
kernel: [593764.644376]  ? __wake_up_common_lock+0x89/0xc0
kernel: [593764.644379]  handle_active_stripes.isra.57+0x35f/0x570 [raid456]
kernel: [593764.644382]  ? raid5_wakeup_stripe_thread+0x96/0x1f0 [raid456]
kernel: [593764.644385]  raid5d+0x480/0x6a0 [raid456]
kernel: [593764.644390]  ? md_thread+0x11f/0x160
kernel: [593764.644392]  md_thread+0x11f/0x160
kernel: [593764.644394]  ? wait_woken+0x80/0x80
kernel: [593764.644396]  kthread+0xfc/0x130
kernel: [593764.644398]  ? find_pers+0x70/0x70
kernel: [593764.644399]  ? kthread_create_on_node+0x70/0x70
kernel: [593764.644401]  ret_from_fork+0x1f/0x30

As we can see, the stripe was set with STRIPE_ACTIVE and STRIPE_HANDLE,
and only handle_stripe could set those flags then return. And since the
stipe was already in the batch list, we need to return earlier before
set the two flags.

And after dig a little about git history especially commit 3664847d95e6
("md/raid5: fix a race condition in stripe batch"), it seems the batched
stipe still could be handled by handle_stipe, then handle_stipe needs to
return earlier if clear_batch_ready to return true.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
Another alternative would be just not warn if STRIPE_ACTIVE is valid for 
the batched list.

What do you think?

Thanks,
Guoqing

 drivers/md/raid5.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ab8067f9ce8c..a35332364f07 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4682,6 +4682,16 @@ static void handle_stripe(struct stripe_head *sh)
 	struct r5dev *pdev, *qdev;
 
 	clear_bit(STRIPE_HANDLE, &sh->state);
+
+	/*
+	 * handle_stripe should not continue handle the batched stripe, only
+	 * the head of batch list or lone stripe can continue. Otherwise we
+	 * could see break_stripe_batch_list warns about the STRIPE_ACTIVE
+	 * is set for the batched stripe.
+	 */
+	if (clear_batch_ready(sh))
+		return;
+
 	if (test_and_set_bit_lock(STRIPE_ACTIVE, &sh->state)) {
 		/* already being handled, ensure it gets handled
 		 * again when current action finishes */
@@ -4689,11 +4699,6 @@ static void handle_stripe(struct stripe_head *sh)
 		return;
 	}
 
-	if (clear_batch_ready(sh) ) {
-		clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
-		return;
-	}
-
 	if (test_and_clear_bit(STRIPE_BATCH_ERR, &sh->state))
 		break_stripe_batch_list(sh, 0);
 
-- 
2.17.1
