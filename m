From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.20-rc5 04/12] md: use raid5_run_ops for stripe cache operations
Date: Tue, 23 Jan 2007 11:47:49 -0700
Message-ID: <20070123184749.2482.61587.stgit@dwillia2-linux.ch.intel.com>
References: <20070123184141.2482.75179.stgit@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070123184141.2482.75179.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

Each stripe has three flag variables to reflect the state of operations
(pending, ack, and complete).
-pending: set to request servicing in raid5_run_ops
-ack: set to reflect that raid5_runs_ops has seen this request
-complete: set when the operation is complete and it is ok for handle_stripe5
to clear 'pending' and 'ack'.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   65 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e70ee17..2c74f9b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -126,6 +126,7 @@ static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
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
 	PRINTK("init_stripe called, stripe %llu\n", 
 		(unsigned long long)sh->sector);
@@ -241,11 +243,11 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 
-		if (dev->toread || dev->towrite || dev->written ||
+		if (dev->toread || dev->read || dev->towrite || dev->written ||
 		    test_bit(R5_LOCKED, &dev->flags)) {
-			printk("sector=%llx i=%d %p %p %p %d\n",
+			printk("sector=%llx i=%d %p %p %p %p %d\n",
 			       (unsigned long long)sh->sector, i, dev->toread,
-			       dev->towrite, dev->written,
+			       dev->read, dev->towrite, dev->written,
 			       test_bit(R5_LOCKED, &dev->flags));
 			BUG();
 		}
@@ -325,6 +327,43 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 	return sh;
 }
 
+/* check_op() ensures that we only dequeue an operation once */
+#define check_op(op) do {\
+	if (test_bit(op, &sh->ops.pending) &&\
+		!test_bit(op, &sh->ops.complete)) {\
+		if (test_and_set_bit(op, &sh->ops.ack))\
+			clear_bit(op, &pending);\
+		else\
+			ack++;\
+	} else\
+		clear_bit(op, &pending);\
+} while(0)
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
+	check_op(STRIPE_OP_BIOFILL);
+	check_op(STRIPE_OP_COMPUTE_BLK);
+	check_op(STRIPE_OP_PREXOR);
+	check_op(STRIPE_OP_BIODRAIN);
+	check_op(STRIPE_OP_POSTXOR);
+	check_op(STRIPE_OP_CHECK);
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
 raid5_end_read_request(struct bio * bi, unsigned int bytes_done, int error);
 static int
@@ -1859,7 +1898,6 @@ static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
  *    schedule a write of some buffers
  *    return confirmation of parity correctness
  *
- * Parity calculations are done inside the stripe lock
  * buffers are taken off read_list or write_list, and bh_cache buffers
  * get BH_Lock set before the stripe lock is released.
  *
@@ -1877,10 +1915,11 @@ static void handle_stripe5(struct stripe_head *sh)
 	int non_overwrite = 0;
 	int failed_num=0;
 	struct r5dev *dev;
+	unsigned long pending=0;
 
-	PRINTK("handling stripe %llu, cnt=%d, pd_idx=%d\n",
-		(unsigned long long)sh->sector, atomic_read(&sh->count),
-		sh->pd_idx);
+	PRINTK("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d ops=%lx:%lx:%lx\n",
+	       (unsigned long long)sh->sector, sh->state, atomic_read(&sh->count),
+	       sh->pd_idx, sh->ops.pending, sh->ops.ack, sh->ops.complete);
 
 	spin_lock(&sh->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
@@ -2330,8 +2369,14 @@ static void handle_stripe5(struct stripe_head *sh)
 			}
 	}
 
+	if (sh->ops.count)
+		pending = get_stripe_work(sh);
+
 	spin_unlock(&sh->lock);
 
+	if (pending)
+		raid5_run_ops(sh, pending);
+
 	while ((bi=return_bi)) {
 		int bytes = bi->bi_size;
 
@@ -3712,8 +3757,10 @@ static void raid5d (mddev_t *mddev)
 			handled++;
 		}
 
-		if (list_empty(&conf->handle_list))
+		if (list_empty(&conf->handle_list)) {
+			async_tx_issue_pending_all();
 			break;
+		}
 
 		first = conf->handle_list.next;
 		sh = list_entry(first, struct stripe_head, lru);
