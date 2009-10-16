From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/11] md/raid456: downlevel multicore operations to
	raid_run_ops
Date: Fri, 16 Oct 2009 16:49:19 +1100
Message-ID: <20091016054918.24208.16998.stgit@notabene.brown>
References: <20091016054316.24208.33818.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091016054316.24208.33818.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

The percpu conversion allowed a straightforward handoff of stripe
processing to the async subsytem that initially showed some modest gains
(+4%).  However, this model is too simplistic and leads to stripes
bouncing between raid5d and the async thread pool for every invocation
of handle_stripe().  As reported by Holger this can fall into a
pathological situation severely impacting throughput (6x performance
loss).

By downleveling the parallelism to raid_run_ops the pathological
stripe_head bouncing is eliminated.  This version still exhibits an
average 11% throughput loss for:

	mdadm --create /dev/md0 /dev/sd[b-q] -n 16 -l 6
	echo 1024 > /sys/block/md0/md/stripe_cache_size
	dd if=/dev/zero of=/dev/md0 bs=1024k count=2048

...but the results are at least stable and can be used as a base for
further multicore experimentation.

Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   75 ++++++++++++++++++++++++++++------------------------
 drivers/md/raid5.h |   12 ++++++++
 2 files changed, 51 insertions(+), 36 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c3e5967..25c3c29 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1139,7 +1139,7 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
 }
 
-static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
+static void __raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 {
 	int overlap_clear = 0, i, disks = sh->disks;
 	struct dma_async_tx_descriptor *tx = NULL;
@@ -1204,6 +1204,36 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	put_cpu();
 }
 
+#ifdef CONFIG_MULTICORE_RAID456
+static void async_run_ops(void *param, async_cookie_t cookie)
+{
+	struct stripe_head *sh = param;
+	unsigned long ops_request = sh->ops.request;
+
+	clear_bit_unlock(STRIPE_OPS_REQ_PENDING, &sh->state);
+	wake_up(&sh->ops.wait_for_ops);
+
+	__raid_run_ops(sh, ops_request);
+	release_stripe(sh);
+}
+
+static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
+{
+	/* since handle_stripe can be called outside of raid5d context
+	 * we need to ensure sh->ops.request is de-staged before another
+	 * request arrives
+	 */
+	wait_event(sh->ops.wait_for_ops,
+		   !test_and_set_bit_lock(STRIPE_OPS_REQ_PENDING, &sh->state));
+	sh->ops.request = ops_request;
+
+	atomic_inc(&sh->count);
+	async_schedule(async_run_ops, sh);
+}
+#else
+#define raid_run_ops __raid_run_ops
+#endif
+
 static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
@@ -1213,6 +1243,9 @@ static int grow_one_stripe(raid5_conf_t *conf)
 	memset(sh, 0, sizeof(*sh) + (conf->raid_disks-1)*sizeof(struct r5dev));
 	sh->raid_conf = conf;
 	spin_lock_init(&sh->lock);
+	#ifdef CONFIG_MULTICORE_RAID456
+	init_waitqueue_head(&sh->ops.wait_for_ops);
+	#endif
 
 	if (grow_buffers(sh, conf->raid_disks)) {
 		shrink_buffers(sh, conf->raid_disks);
@@ -1329,6 +1362,9 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 
 		nsh->raid_conf = conf;
 		spin_lock_init(&nsh->lock);
+		#ifdef CONFIG_MULTICORE_RAID456
+		init_waitqueue_head(&nsh->ops.wait_for_ops);
+		#endif
 
 		list_add(&nsh->lru, &newstripes);
 	}
@@ -4342,37 +4378,6 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 	return handled;
 }
 
-#ifdef CONFIG_MULTICORE_RAID456
-static void __process_stripe(void *param, async_cookie_t cookie)
-{
-	struct stripe_head *sh = param;
-
-	handle_stripe(sh);
-	release_stripe(sh);
-}
-
-static void process_stripe(struct stripe_head *sh, struct list_head *domain)
-{
-	async_schedule_domain(__process_stripe, sh, domain);
-}
-
-static void synchronize_stripe_processing(struct list_head *domain)
-{
-	async_synchronize_full_domain(domain);
-}
-#else
-static void process_stripe(struct stripe_head *sh, struct list_head *domain)
-{
-	handle_stripe(sh);
-	release_stripe(sh);
-	cond_resched();
-}
-
-static void synchronize_stripe_processing(struct list_head *domain)
-{
-}
-#endif
-
 
 /*
  * This is our raid5 kernel thread.
@@ -4386,7 +4391,6 @@ static void raid5d(mddev_t *mddev)
 	struct stripe_head *sh;
 	raid5_conf_t *conf = mddev->private;
 	int handled;
-	LIST_HEAD(raid_domain);
 
 	pr_debug("+++ raid5d active\n");
 
@@ -4423,7 +4427,9 @@ static void raid5d(mddev_t *mddev)
 		spin_unlock_irq(&conf->device_lock);
 		
 		handled++;
-		process_stripe(sh, &raid_domain);
+		handle_stripe(sh);
+		release_stripe(sh);
+		cond_resched();
 
 		spin_lock_irq(&conf->device_lock);
 	}
@@ -4431,7 +4437,6 @@ static void raid5d(mddev_t *mddev)
 
 	spin_unlock_irq(&conf->device_lock);
 
-	synchronize_stripe_processing(&raid_domain);
 	async_tx_issue_pending_all();
 	unplug_slaves(mddev);
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 2390e0e..dcefdc9 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -214,12 +214,20 @@ struct stripe_head {
 	int			disks;		/* disks in stripe */
 	enum check_states	check_state;
 	enum reconstruct_states reconstruct_state;
-	/* stripe_operations
+	/**
+	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
+	 * @target2 - 2nd compute target in the raid6 case
+	 * @zero_sum_result - P and Q verification flags
+	 * @request - async service request flags for raid_run_ops
 	 */
 	struct stripe_operations {
 		int 		     target, target2;
 		enum sum_check_flags zero_sum_result;
+		#ifdef CONFIG_MULTICORE_RAID456
+		unsigned long	     request;
+		wait_queue_head_t    wait_for_ops;
+		#endif
 	} ops;
 	struct r5dev {
 		struct bio	req;
@@ -294,6 +302,8 @@ struct r6_state {
 #define	STRIPE_FULL_WRITE	13 /* all blocks are set to be overwritten */
 #define	STRIPE_BIOFILL_RUN	14
 #define	STRIPE_COMPUTE_RUN	15
+#define	STRIPE_OPS_REQ_PENDING	16
+
 /*
  * Operation request flags
  */


