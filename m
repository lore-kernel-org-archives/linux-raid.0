From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 08/19] md: common infrastructure for running
	operations with raid5_run_ops
Date: Tue, 26 Jun 2007 18:51:15 -0700
Message-ID: <20070627015115.18962.76642.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

All the handle_stripe operations that are to be transitioned to use
raid5_run_ops need a method to coherently gather work under the stripe-lock
and hand that work off to raid5_run_ops.  The 'get_stripe_work' routine
runs under the lock to read all the bits in sh->ops.pending that do not
have the corresponding bit set in sh->ops.ack.  This modified 'pending'
bitmap is then passed to raid5_run_ops for processing.

The transition from 'ack' to 'completion' does not need similar protection
as the existing release_stripe infrastructure will guarantee that
handle_stripe will run again after a completion bit is set, and
handle_stripe can tolerate a sh->ops.completed bit being set while the lock
is held.

A call to async_tx_issue_pending_all() is added to raid5d to kick the
offload engines once all pending stripe operations work has been submitted.
This enables batching of the submission and completion of operations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-By: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   67 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 34fcda0..7c688f6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -124,6 +124,7 @@ static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 			}
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
+			BUG_ON(sh->ops.pending);
 			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 				atomic_dec(&conf->preread_active_stripes);
 				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
@@ -225,7 +226,8 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int
 
 	BUG_ON(atomic_read(&sh->count) != 0);
 	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
-	
+	BUG_ON(sh->ops.pending || sh->ops.ack || sh->ops.complete);
+
 	CHECK_DEVLOCK();
 	pr_debug("init_stripe called, stripe %llu\n",
 		(unsigned long long)sh->sector);
@@ -241,11 +243,11 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 
-		if (dev->toread || dev->towrite || dev->written ||
+		if (dev->toread || dev->read || dev->towrite || dev->written ||
 		    test_bit(R5_LOCKED, &dev->flags)) {
-			printk("sector=%llx i=%d %p %p %p %d\n",
+			printk(KERN_ERR "sector=%llx i=%d %p %p %p %p %d\n",
 			       (unsigned long long)sh->sector, i, dev->toread,
-			       dev->towrite, dev->written,
+			       dev->read, dev->towrite, dev->written,
 			       test_bit(R5_LOCKED, &dev->flags));
 			BUG();
 		}
@@ -325,6 +327,44 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 	return sh;
 }
 
+/* test_and_ack_op() ensures that we only dequeue an operation once */
+#define test_and_ack_op(op, pend) \
+do {							\
+	if (test_bit(op, &sh->ops.pending) &&		\
+		!test_bit(op, &sh->ops.complete)) {	\
+		if (test_and_set_bit(op, &sh->ops.ack)) \
+			clear_bit(op, &pend);		\
+		else					\
+			ack++;				\
+	} else						\
+		clear_bit(op, &pend);			\
+} while (0)
+
+/* find new work to run, do not resubmit work that is already
+ * in flight
+ */
+static unsigned long get_stripe_work(struct stripe_head *sh)
+{
+	unsigned long pending;
+	int ack = 0;
+
+	pending = sh->ops.pending;
+
+	test_and_ack_op(STRIPE_OP_BIOFILL, pending);
+	test_and_ack_op(STRIPE_OP_COMPUTE_BLK, pending);
+	test_and_ack_op(STRIPE_OP_PREXOR, pending);
+	test_and_ack_op(STRIPE_OP_BIODRAIN, pending);
+	test_and_ack_op(STRIPE_OP_POSTXOR, pending);
+	test_and_ack_op(STRIPE_OP_CHECK, pending);
+	if (test_and_clear_bit(STRIPE_OP_IO, &sh->ops.pending))
+		ack++;
+
+	sh->ops.count -= ack;
+	BUG_ON(sh->ops.count < 0);
+
+	return pending;
+}
+
 static int
 raid5_end_read_request(struct bio *bi, unsigned int bytes_done, int error);
 static int
@@ -2487,7 +2527,6 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
  *    schedule a write of some buffers
  *    return confirmation of parity correctness
  *
- * Parity calculations are done inside the stripe lock
  * buffers are taken off read_list or write_list, and bh_cache buffers
  * get BH_Lock set before the stripe lock is released.
  *
@@ -2500,11 +2539,13 @@ static void handle_stripe5(struct stripe_head *sh)
 	struct bio *return_bi = NULL, *bi;
 	struct stripe_head_state s;
 	struct r5dev *dev;
+	unsigned long pending = 0;
 
 	memset(&s, 0, sizeof(s));
-	pr_debug("handling stripe %llu, cnt=%d, pd_idx=%d\n",
-		(unsigned long long)sh->sector, atomic_read(&sh->count),
-		sh->pd_idx);
+	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d "
+		"ops=%lx:%lx:%lx\n", (unsigned long long)sh->sector, sh->state,
+		atomic_read(&sh->count), sh->pd_idx,
+		sh->ops.pending, sh->ops.ack, sh->ops.complete);
 
 	spin_lock(&sh->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
@@ -2667,8 +2708,14 @@ static void handle_stripe5(struct stripe_head *sh)
 	if (s.expanding && s.locked == 0)
 		handle_stripe_expansion(conf, sh, NULL);
 
+	if (sh->ops.count)
+		pending = get_stripe_work(sh);
+
 	spin_unlock(&sh->lock);
 
+	if (pending)
+		raid5_run_ops(sh, pending);
+
 	while ((bi=return_bi)) {
 		int bytes = bi->bi_size;
 
@@ -3808,8 +3855,10 @@ static void raid5d (mddev_t *mddev)
 			handled++;
 		}
 
-		if (list_empty(&conf->handle_list))
+		if (list_empty(&conf->handle_list)) {
+			async_tx_issue_pending_all();
 			break;
+		}
 
 		first = conf->handle_list.next;
 		sh = list_entry(first, struct stripe_head, lru);
