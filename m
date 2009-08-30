From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 07/14] md/raid5,
	6: add percpu scribble region for buffer lists
Date: Sat, 29 Aug 2009 19:30:36 -0700
Message-ID: <20090830023036.5934.79772.stgit@dwillia2-linux.ch.intel.com>
References: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Use percpu memory rather than stack for storing the buffer lists used in
parity calculations.  Include space for dma address conversions and pass
that to async_tx via the async_submit_ctl.scribble pointer.

[ Impact: move memory pressure from stack to heap ]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |  132 ++++++++++++++++++++++++++++++++++++++++------------
 drivers/md/raid5.h |    8 +++
 2 files changed, 110 insertions(+), 30 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5359236..7727954 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -642,11 +642,18 @@ static void ops_complete_compute5(void *stripe_head_ref)
 	release_stripe(sh);
 }
 
-static struct dma_async_tx_descriptor *ops_run_compute5(struct stripe_head *sh)
+/* return a pointer to the address conversion region of the scribble buffer */
+static addr_conv_t *to_addr_conv(struct stripe_head *sh,
+				 struct raid5_percpu *percpu)
+{
+	return percpu->scribble + sizeof(struct page *) * (sh->disks + 2);
+}
+
+static struct dma_async_tx_descriptor *
+ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
-	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
-	struct page *xor_srcs[disks];
+	struct page **xor_srcs = percpu->scribble;
 	int target = sh->ops.target;
 	struct r5dev *tgt = &sh->dev[target];
 	struct page *xor_dest = tgt->page;
@@ -666,7 +673,7 @@ static struct dma_async_tx_descriptor *ops_run_compute5(struct stripe_head *sh)
 	atomic_inc(&sh->count);
 
 	init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, NULL,
-			  ops_complete_compute5, sh, NULL);
+			  ops_complete_compute5, sh, to_addr_conv(sh, percpu));
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
 	else
@@ -684,11 +691,11 @@ static void ops_complete_prexor(void *stripe_head_ref)
 }
 
 static struct dma_async_tx_descriptor *
-ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+ops_run_prexor(struct stripe_head *sh, struct raid5_percpu *percpu,
+	       struct dma_async_tx_descriptor *tx)
 {
-	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
-	struct page *xor_srcs[disks];
+	struct page **xor_srcs = percpu->scribble;
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct async_submit_ctl submit;
 
@@ -706,7 +713,7 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	}
 
 	init_async_submit(&submit, ASYNC_TX_XOR_DROP_DST, tx,
-			  ops_complete_prexor, sh, NULL);
+			  ops_complete_prexor, sh, to_addr_conv(sh, percpu));
 	tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
 
 	return tx;
@@ -775,11 +782,11 @@ static void ops_complete_postxor(void *stripe_head_ref)
 }
 
 static void
-ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+ops_run_postxor(struct stripe_head *sh, struct raid5_percpu *percpu,
+		struct dma_async_tx_descriptor *tx)
 {
-	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
-	struct page *xor_srcs[disks];
+	struct page **xor_srcs = percpu->scribble;
 	struct async_submit_ctl submit;
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
@@ -819,7 +826,8 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 	atomic_inc(&sh->count);
 
-	init_async_submit(&submit, flags, tx, ops_complete_postxor, sh, NULL);
+	init_async_submit(&submit, flags, tx, ops_complete_postxor, sh,
+			  to_addr_conv(sh, percpu));
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
 	else
@@ -838,11 +846,10 @@ static void ops_complete_check(void *stripe_head_ref)
 	release_stripe(sh);
 }
 
-static void ops_run_check(struct stripe_head *sh)
+static void ops_run_check(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
-	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
-	struct page *xor_srcs[disks];
+	struct page **xor_srcs = percpu->scribble;
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
 
@@ -858,7 +865,8 @@ static void ops_run_check(struct stripe_head *sh)
 			xor_srcs[count++] = dev->page;
 	}
 
-	init_async_submit(&submit, 0, NULL, NULL, NULL, NULL);
+	init_async_submit(&submit, 0, NULL, NULL, NULL,
+			  to_addr_conv(sh, percpu));
 	tx = async_xor_val(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
 			   &sh->ops.zero_sum_result, &submit);
 
@@ -871,21 +879,26 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
 {
 	int overlap_clear = 0, i, disks = sh->disks;
 	struct dma_async_tx_descriptor *tx = NULL;
+	raid5_conf_t *conf = sh->raid_conf;
+	struct raid5_percpu *percpu;
+	unsigned long cpu;
 
+	cpu = get_cpu();
+	percpu = per_cpu_ptr(conf->percpu, cpu);
 	if (test_bit(STRIPE_OP_BIOFILL, &ops_request)) {
 		ops_run_biofill(sh);
 		overlap_clear++;
 	}
 
 	if (test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request)) {
-		tx = ops_run_compute5(sh);
+		tx = ops_run_compute5(sh, percpu);
 		/* terminate the chain if postxor is not set to be run */
 		if (tx && !test_bit(STRIPE_OP_POSTXOR, &ops_request))
 			async_tx_ack(tx);
 	}
 
 	if (test_bit(STRIPE_OP_PREXOR, &ops_request))
-		tx = ops_run_prexor(sh, tx);
+		tx = ops_run_prexor(sh, percpu, tx);
 
 	if (test_bit(STRIPE_OP_BIODRAIN, &ops_request)) {
 		tx = ops_run_biodrain(sh, tx);
@@ -893,10 +906,10 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	}
 
 	if (test_bit(STRIPE_OP_POSTXOR, &ops_request))
-		ops_run_postxor(sh, tx);
+		ops_run_postxor(sh, percpu, tx);
 
 	if (test_bit(STRIPE_OP_CHECK, &ops_request))
-		ops_run_check(sh);
+		ops_run_check(sh, percpu);
 
 	if (overlap_clear)
 		for (i = disks; i--; ) {
@@ -904,6 +917,7 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
 				wake_up(&sh->raid_conf->wait_for_overlap);
 		}
+	put_cpu();
 }
 
 static int grow_one_stripe(raid5_conf_t *conf)
@@ -953,6 +967,28 @@ static int grow_stripes(raid5_conf_t *conf, int num)
 	return 0;
 }
 
+/**
+ * scribble_len - return the required size of the scribble region
+ * @num - total number of disks in the array
+ *
+ * The size must be enough to contain:
+ * 1/ a struct page pointer for each device in the array +2
+ * 2/ room to convert each entry in (1) to its corresponding dma
+ *    (dma_map_page()) or page (page_address()) address.
+ *
+ * Note: the +2 is for the destination buffers of the ddf/raid6 case where we
+ * calculate over all devices (not just the data blocks), using zeros in place
+ * of the P and Q blocks.
+ */
+static size_t scribble_len(int num)
+{
+	size_t len;
+
+	len = sizeof(struct page *) * (num+2) + sizeof(addr_conv_t) * (num+2);
+
+	return len;
+}
+
 static int resize_stripes(raid5_conf_t *conf, int newsize)
 {
 	/* Make all the stripes able to hold 'newsize' devices.
@@ -981,6 +1017,7 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	struct stripe_head *osh, *nsh;
 	LIST_HEAD(newstripes);
 	struct disk_info *ndisks;
+	unsigned long cpu;
 	int err;
 	struct kmem_cache *sc;
 	int i;
@@ -1046,7 +1083,7 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	/* Step 3.
 	 * At this point, we are holding all the stripes so the array
 	 * is completely stalled, so now is a good time to resize
-	 * conf->disks.
+	 * conf->disks and the scribble region
 	 */
 	ndisks = kzalloc(newsize * sizeof(struct disk_info), GFP_NOIO);
 	if (ndisks) {
@@ -1057,10 +1094,30 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	} else
 		err = -ENOMEM;
 
+	get_online_cpus();
+	conf->scribble_len = scribble_len(newsize);
+	for_each_present_cpu(cpu) {
+		struct raid5_percpu *percpu;
+		void *scribble;
+
+		percpu = per_cpu_ptr(conf->percpu, cpu);
+		scribble = kmalloc(conf->scribble_len, GFP_NOIO);
+
+		if (scribble) {
+			kfree(percpu->scribble);
+			percpu->scribble = scribble;
+		} else {
+			err = -ENOMEM;
+			break;
+		}
+	}
+	put_online_cpus();
+
 	/* Step 4, return new stripes to service */
 	while(!list_empty(&newstripes)) {
 		nsh = list_entry(newstripes.next, struct stripe_head, lru);
 		list_del_init(&nsh->lru);
+
 		for (i=conf->raid_disks; i < newsize; i++)
 			if (nsh->dev[i].page == NULL) {
 				struct page *p = alloc_page(GFP_NOIO);
@@ -4318,6 +4375,7 @@ static void raid5_free_percpu(raid5_conf_t *conf)
 	for_each_possible_cpu(cpu) {
 		percpu = per_cpu_ptr(conf->percpu, cpu);
 		safe_put_page(percpu->spare_page);
+		kfree(percpu->scribble);
 	}
 #ifdef CONFIG_HOTPLUG_CPU
 	unregister_cpu_notifier(&conf->cpu_notify);
@@ -4347,9 +4405,15 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (!percpu->spare_page)
+		if (conf->level == 6 && !percpu->spare_page)
 			percpu->spare_page = alloc_page(GFP_KERNEL);
-		if (!percpu->spare_page) {
+		if (!percpu->scribble)
+			percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
+
+		if (!percpu->scribble ||
+		    (conf->level == 6 && !percpu->spare_page)) {
+			safe_put_page(percpu->spare_page);
+			kfree(percpu->scribble);
 			pr_err("%s: failed memory allocation for cpu%ld\n",
 			       __func__, cpu);
 			return NOTIFY_BAD;
@@ -4358,7 +4422,9 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		safe_put_page(percpu->spare_page);
+		kfree(percpu->scribble);
 		percpu->spare_page = NULL;
+		percpu->scribble = NULL;
 		break;
 	default:
 		break;
@@ -4372,12 +4438,9 @@ static int raid5_alloc_percpu(raid5_conf_t *conf)
 	unsigned long cpu;
 	struct page *spare_page;
 	struct raid5_percpu *allcpus;
+	void *scribble;
 	int err;
 
-	/* the only percpu data is the raid6 spare page */
-	if (conf->level != 6)
-		return 0;
-
 	allcpus = alloc_percpu(struct raid5_percpu);
 	if (!allcpus)
 		return -ENOMEM;
@@ -4386,12 +4449,20 @@ static int raid5_alloc_percpu(raid5_conf_t *conf)
 	get_online_cpus();
 	err = 0;
 	for_each_present_cpu(cpu) {
-		spare_page = alloc_page(GFP_KERNEL);
-		if (!spare_page) {
+		if (conf->level == 6) {
+			spare_page = alloc_page(GFP_KERNEL);
+			if (!spare_page) {
+				err = -ENOMEM;
+				break;
+			}
+			per_cpu_ptr(conf->percpu, cpu)->spare_page = spare_page;
+		}
+		scribble = kmalloc(scribble_len(conf->raid_disks), GFP_KERNEL);
+		if (!scribble) {
 			err = -ENOMEM;
 			break;
 		}
-		per_cpu_ptr(conf->percpu, cpu)->spare_page = spare_page;
+		per_cpu_ptr(conf->percpu, cpu)->scribble = scribble;
 	}
 #ifdef CONFIG_HOTPLUG_CPU
 	conf->cpu_notify.notifier_call = raid456_cpu_notify;
@@ -4443,6 +4514,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 		goto abort;
 
 	conf->raid_disks = mddev->raid_disks;
+	conf->scribble_len = scribble_len(conf->raid_disks);
 	if (mddev->reshape_position == MaxSector)
 		conf->previous_raid_disks = mddev->raid_disks;
 	else
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 07a7a41..e7baabf 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -386,7 +386,15 @@ struct raid5_private_data {
 	/* per cpu variables */
 	struct raid5_percpu {
 		struct page	*spare_page; /* Used when checking P/Q in raid6 */
+		void		*scribble;   /* space for constructing buffer
+					      * lists and performing address
+					      * conversions
+					      */
 	} *percpu;
+	size_t			scribble_len; /* size of scribble region must be
+					       * associated with conf to handle
+					       * cpu hotplug while reshaping
+					       */
 #ifdef CONFIG_HOTPLUG_CPU
 	struct notifier_block	cpu_notify;
 #endif

