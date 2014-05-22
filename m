From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/3]raid5: make raid_run_ops take reference of ops_request
Date: Thu, 22 May 2014 19:24:50 +0800
Message-ID: <20140522112450.GB10509@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


Next patch will make handle_stripe() call raid_run_ops several times, so we
need clear the operations which already are handled to avoid they are handled
multiple times.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-05-22 14:41:05.603276379 +0800
+++ linux/drivers/md/raid5.c	2014-05-22 14:51:03.007766003 +0800
@@ -1612,7 +1612,7 @@ static void ops_run_check_pq(struct stri
 			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
 }
 
-static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
+static void raid_run_ops(struct stripe_head *sh, unsigned long *ops_request)
 {
 	int overlap_clear = 0, i, disks = sh->disks;
 	struct dma_async_tx_descriptor *tx = NULL;
@@ -1623,12 +1623,12 @@ static void raid_run_ops(struct stripe_h
 
 	cpu = get_cpu();
 	percpu = per_cpu_ptr(conf->percpu, cpu);
-	if (test_bit(STRIPE_OP_BIOFILL, &ops_request)) {
+	if (__test_and_clear_bit(STRIPE_OP_BIOFILL, ops_request)) {
 		ops_run_biofill(sh);
 		overlap_clear++;
 	}
 
-	if (test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request)) {
+	if (__test_and_clear_bit(STRIPE_OP_COMPUTE_BLK, ops_request)) {
 		if (level < 6)
 			tx = ops_run_compute5(sh, percpu);
 		else {
@@ -1638,26 +1638,26 @@ static void raid_run_ops(struct stripe_h
 				tx = ops_run_compute6_2(sh, percpu);
 		}
 		/* terminate the chain if reconstruct is not set to be run */
-		if (tx && !test_bit(STRIPE_OP_RECONSTRUCT, &ops_request))
+		if (tx && !test_bit(STRIPE_OP_RECONSTRUCT, ops_request))
 			async_tx_ack(tx);
 	}
 
-	if (test_bit(STRIPE_OP_PREXOR, &ops_request))
+	if (__test_and_clear_bit(STRIPE_OP_PREXOR, ops_request))
 		tx = ops_run_prexor(sh, percpu, tx);
 
-	if (test_bit(STRIPE_OP_BIODRAIN, &ops_request)) {
+	if (__test_and_clear_bit(STRIPE_OP_BIODRAIN, ops_request)) {
 		tx = ops_run_biodrain(sh, tx);
 		overlap_clear++;
 	}
 
-	if (test_bit(STRIPE_OP_RECONSTRUCT, &ops_request)) {
+	if (__test_and_clear_bit(STRIPE_OP_RECONSTRUCT, ops_request)) {
 		if (level < 6)
 			ops_run_reconstruct5(sh, percpu, tx);
 		else
 			ops_run_reconstruct6(sh, percpu, tx);
 	}
 
-	if (test_bit(STRIPE_OP_CHECK, &ops_request)) {
+	if (__test_and_clear_bit(STRIPE_OP_CHECK, ops_request)) {
 		if (sh->check_state == check_state_run)
 			ops_run_check_p(sh, percpu);
 		else if (sh->check_state == check_state_run_q)
@@ -3981,7 +3981,7 @@ finish:
 		}
 
 	if (s.ops_request)
-		raid_run_ops(sh, s.ops_request);
+		raid_run_ops(sh, &s.ops_request);
 
 	ops_run_io(sh, &s);
 
