From: Shaohua Li <shli@kernel.org>
Subject: [patch 3/3]raid5: reduce handle_stripe() called times for full
 stripe write
Date: Thu, 22 May 2014 19:25:05 +0800
Message-ID: <20140522112505.GC10509@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


For a full stripe write, the ideal operation order is handle_stripe_dirtying(),
raid_run_ops(), set R5_Wantwrite bit, and ops_run_io(). In this way, one
handle_stripe() will dispatch IO for the stripe, otherwise there are more extra
rounds of handle_stripe(). In a high speed raid5 array, handle_stripe()
consumes considered cpu time. Reducing its overhead has around 10% performance
boost.

Previous patch already adjusts operation order as handle_stripe_dirtying, set
R5_Wantwrite bit and ops_run_io. This one adds the missing raid_run_ops.

We have two raid_run_ops called in handle_stripe() now. There are some
dependent operations in raid_run_ops. The operations are COMPUTE_BLK, PREXOR,
BIODRAIN, RECONSTRUCT. COMPUTE_BLK is set in handle_stripe_fill and others are
set in handle_stripe_dirtying. We didn't change the order of the two routines.
PREXOR, BIODRAIN and RECONSTRUCT are set togther, so we don't need worry about
misorder of them. For async operations, the async engine will handle dependency
as before. So the new raid_run_ops just moves some operations in advance, we
don't break any order.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-05-22 14:46:34.299143973 +0800
+++ linux/drivers/md/raid5.c	2014-05-22 14:47:58.742081003 +0800
@@ -3790,6 +3790,9 @@ static void handle_stripe(struct stripe_
 	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
 		handle_stripe_dirtying(conf, sh, &s, disks);
 
+	if (s.ops_request)
+		raid_run_ops(sh, &s.ops_request);
+
 	/* Now we check to see if any write operations have recently
 	 * completed
 	 */
