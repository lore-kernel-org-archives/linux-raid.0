From: Shaohua Li <shli@kernel.org>
Subject: [PATCH] raid5: fix broken async operation chain
Date: Wed, 13 May 2015 09:30:08 -0700
Message-ID: <abe8bcda859c8d2a11544a273c117c190fe736a4.1431464773.git.shli@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, maxime.ripard@free-electrons.com
List-Id: linux-raid.ids

ops_run_reconstruct6() doesn't correctly chain asyn operations. The tx returned
by async_gen_syndrome should be added as the dependent tx of next stripe.

The issue is introduced by commit 59fc630b8b5f9f21c8ce3ba153341c107dce1b0c
    RAID5: batch adjacent full stripe write

Reported-and-tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1ba97fd..b9f2b9c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1822,7 +1822,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 	} else
 		init_async_submit(&submit, 0, tx, NULL, NULL,
 				  to_addr_conv(sh, percpu, j));
-	async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
+	tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
 	if (!last_stripe) {
 		j++;
 		sh = list_first_entry(&sh->batch_list, struct stripe_head,
-- 
2.1.0

