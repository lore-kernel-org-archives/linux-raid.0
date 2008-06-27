From: NeilBrown <neilb@suse.de>
Subject: [PATCH 028 of 29] md: md: handle operation chaining in raid5_run_ops
Date: Fri, 27 Jun 2008 16:52:25 +1000
Message-ID: <1080627065225.10779@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

Neil said:
> At the end of ops_run_compute5 you have:
>         /* ack now if postxor is not set to be run */
>         if (tx && !test_bit(STRIPE_OP_POSTXOR, &s->ops_run))
>                 async_tx_ack(tx);
>
> It looks odd having that test there.  Would it fit in raid5_run_ops
> better?

The intended global interpretation is that raid5_run_ops can build a chain
of xor and memcpy operations.  When MD registers the compute-xor it tells
async_tx to keep the operation handle around so that another item in the
dependency chain can be submitted. If we are just computing a block to
satisfy a read then we can terminate the chain immediately.  raid5_run_ops
gives a better context for this test since it cares about the entire chain.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 16:42:56.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 16:42:56.000000000 +1000
@@ -574,8 +574,7 @@ static void ops_complete_compute5(void *
 	release_stripe(sh);
 }
 
-static struct dma_async_tx_descriptor *
-ops_run_compute5(struct stripe_head *sh, unsigned long ops_request)
+static struct dma_async_tx_descriptor *ops_run_compute5(struct stripe_head *sh)
 {
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
@@ -605,10 +604,6 @@ ops_run_compute5(struct stripe_head *sh,
 			ASYNC_TX_XOR_ZERO_DST, NULL,
 			ops_complete_compute5, sh);
 
-	/* ack now if postxor is not set to be run */
-	if (tx && !test_bit(STRIPE_OP_POSTXOR, &ops_request))
-		async_tx_ack(tx);
-
 	return tx;
 }
 
@@ -813,8 +808,12 @@ static void raid5_run_ops(struct stripe_
 		overlap_clear++;
 	}
 
-	if (test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request))
-		tx = ops_run_compute5(sh, ops_request);
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request)) {
+		tx = ops_run_compute5(sh);
+		/* terminate the chain if postxor is not set to be run */
+		if (tx && !test_bit(STRIPE_OP_POSTXOR, &ops_request))
+			async_tx_ack(tx);
+	}
 
 	if (test_bit(STRIPE_OP_PREXOR, &ops_request))
 		tx = ops_run_prexor(sh, tx);
