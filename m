From: NeilBrown <neilb@suse.de>
Subject: [PATCH 019 of 29] md: md: kill STRIPE_OP_MOD_DMA in raid5 offload
Date: Fri, 27 Jun 2008 16:51:23 +1000
Message-ID: <1080627065123.10617@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

This micro-optimization allowed the raid code to skip a re-read of the
parity block after checking parity.  It took advantage of the fact that
xor-offload-engines have their own internal result buffer and can check
parity without writing to memory.  Remove it for the following reasons:

1/ It is a layering violation for MD to need to manage the DMA and
   non-DMA paths within async_xor_zero_sum
2/ Bad precedent to toggle the 'ops' flags outside the lock
3/ Hard to realize a performance gain as reads will not need an updated
   parity block and writes will dirty it anyways.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c         |   10 ----------
 ./include/linux/raid/raid5.h |    2 --
 2 files changed, 12 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 16:20:58.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 16:22:03.000000000 +1000
@@ -837,15 +837,10 @@ ops_run_postxor(struct stripe_head *sh, 
 static void ops_complete_check(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	int pd_idx = sh->pd_idx;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
-	if (test_and_clear_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending) &&
-		sh->ops.zero_sum_result == 0)
-		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
-
 	set_bit(STRIPE_OP_CHECK, &sh->ops.complete);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
@@ -873,11 +868,6 @@ static void ops_run_check(struct stripe_
 	tx = async_xor_zero_sum(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
 		&sh->ops.zero_sum_result, 0, NULL, NULL, NULL);
 
-	if (tx)
-		set_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending);
-	else
-		clear_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending);
-
 	atomic_inc(&sh->count);
 	tx = async_trigger_callback(ASYNC_TX_DEP_ACK | ASYNC_TX_ACK, tx,
 		ops_complete_check, sh);

diff .prev/include/linux/raid/raid5.h ./include/linux/raid/raid5.h
--- .prev/include/linux/raid/raid5.h	2008-06-27 16:20:33.000000000 +1000
+++ ./include/linux/raid/raid5.h	2008-06-27 16:22:03.000000000 +1000
@@ -267,10 +267,8 @@ struct r6_state {
 
 /* modifiers to the base operations
  * STRIPE_OP_MOD_REPAIR_PD - compute the parity block and write it back
- * STRIPE_OP_MOD_DMA_CHECK - parity is not corrupted by the check
  */
 #define STRIPE_OP_MOD_REPAIR_PD 7
-#define STRIPE_OP_MOD_DMA_CHECK 8
 
 /*
  * Plugging:
