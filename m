From: Dan Williams <djbw@fb.com>
Subject: [PATCH] raid5: add support for rmw writes in raid6
Date: Wed, 17 Apr 2013 17:56:56 -0700
Message-ID: <20130418005609.6782.15041.stgit@dev279.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>
List-Id: linux-raid.ids

From: Kumar Sundararajan <kumar@fb.com>

Add support for rmw writes in raid6. This improves small write performance for most workloads.
Since there may be some configurations and workloads where rcw always outperforms rmw,
this feature is disabled by default. It can be enabled via sysfs. For example,

	#echo 1 > /sys/block/md0/md/enable_rmw

Signed-off-by: Kumar Sundararajan <kumar@fb.com>
Signed-off-by: Dan Williams <djbw@fb.com>
---
Hi Neil,

We decided to leave the enable in for the few cases where forced-rcw
outperformed rmw and there may be other cases out there.

Thoughts?

Here are some numbers from Kumar's testing with a 12 disk array:

                                     with rmw   rcw only
4K random write                    887.0 KB/s  94.4 KB/s
64k seq write                      291.5 MB/s 283.2 MB/s
64k random write                    16.4 MB/s   7.7 MB/s
64K mixed read/write                94.4 MB/s  94.0 MB/s
(70% random reads/30 % seq writes)   1.6 MB/s   1.8 MB/s

--
Dan

 drivers/md/raid5.c |  169 ++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/md/raid5.h |    4 +
 2 files changed, 161 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e25520e..c9b6112 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1015,6 +1015,40 @@ static int set_syndrome_sources(struct page **srcs, struct stripe_head *sh)
 	return syndrome_disks;
 }
 
+static int set_rmw_syndrome_sources(struct page **srcs, struct stripe_head *sh,
+	 struct raid5_percpu *percpu, int subtract)
+{
+	int disks = sh->disks;
+	int syndrome_disks = sh->ddf_layout ? disks : (disks - 2);
+	int d0_idx = raid6_d0(sh);
+	int count;
+	int i;
+
+	for (i = 0; i < disks; i++)
+		srcs[i] = NULL;
+
+	count = 0;
+	i = d0_idx;
+	do {
+		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
+
+		if (subtract) {
+			if (test_bit(R5_Wantdrain, &sh->dev[i].flags))
+				srcs[slot] = sh->dev[i].page;
+			else if (i == sh->pd_idx)
+				srcs[slot] = percpu->spare_page;
+			else if (i == sh->qd_idx)
+				srcs[slot] = percpu->spare_page2;
+		} else if (sh->dev[i].written || i == sh->pd_idx ||
+			    i == sh->qd_idx)
+			srcs[slot] = sh->dev[i].page;
+
+		i = raid6_next_disk(i, disks);
+	} while (i != d0_idx);
+
+	return syndrome_disks;
+}
+
 static struct dma_async_tx_descriptor *
 ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
@@ -1401,6 +1435,50 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 	async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
 }
 
+static struct dma_async_tx_descriptor *
+ops_run_rmw(struct stripe_head *sh, struct raid5_percpu *percpu,
+	    struct dma_async_tx_descriptor *tx, int subtract)
+{
+	int pd_idx = sh->pd_idx;
+	int qd_idx = sh->qd_idx;
+	struct page **blocks = percpu->scribble;
+	struct page *xor_dest;
+	struct r5dev *dev;
+	struct async_submit_ctl submit;
+	int count;
+
+	pr_debug("%s: stripe %llu\n", __func__,
+		(unsigned long long)sh->sector);
+
+	count = set_rmw_syndrome_sources(blocks, sh, percpu, subtract);
+
+	init_async_submit(&submit, ASYNC_TX_ACK, tx, NULL, NULL,
+			  to_addr_conv(sh, percpu));
+	tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);
+
+	dev = &sh->dev[pd_idx];
+	xor_dest = blocks[0] = subtract ? percpu->spare_page : dev->page;
+	blocks[1] = subtract ? dev->page : percpu->spare_page;
+
+	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
+			  NULL, sh, to_addr_conv(sh, percpu));
+	tx = async_xor(xor_dest, blocks, 0, 2, STRIPE_SIZE, &submit);
+
+	dev = &sh->dev[qd_idx];
+	xor_dest = blocks[0] = subtract ? percpu->spare_page2 : dev->page;
+	blocks[1] = subtract ? dev->page : percpu->spare_page2;
+
+	if (!subtract)
+		atomic_inc(&sh->count);
+
+	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
+			  subtract ? NULL : ops_complete_reconstruct, sh,
+			  to_addr_conv(sh, percpu));
+	tx = async_xor(xor_dest, blocks, 0, 2, STRIPE_SIZE, &submit);
+
+	return tx;
+}
+
 static void ops_complete_check(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
@@ -1500,6 +1578,9 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	if (test_bit(STRIPE_OP_PREXOR, &ops_request))
 		tx = ops_run_prexor(sh, percpu, tx);
 
+	if (test_bit(STRIPE_OP_RMW_SUBTRACT, &ops_request))
+		tx = ops_run_rmw(sh, percpu, tx, 1);
+
 	if (test_bit(STRIPE_OP_BIODRAIN, &ops_request)) {
 		tx = ops_run_biodrain(sh, tx);
 		overlap_clear++;
@@ -1512,6 +1593,9 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 			ops_run_reconstruct6(sh, percpu, tx);
 	}
 
+	if (test_bit(STRIPE_OP_RMW, &ops_request))
+		tx = ops_run_rmw(sh, percpu, tx, 0);
+
 	if (test_bit(STRIPE_OP_CHECK, &ops_request)) {
 		if (sh->check_state == check_state_run)
 			ops_run_check_p(sh, percpu);
@@ -2346,7 +2430,7 @@ static void
 schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 			 int rcw, int expand)
 {
-	int i, pd_idx = sh->pd_idx, disks = sh->disks;
+	int i, pd_idx = sh->pd_idx, qd_idx = sh->qd_idx, disks = sh->disks;
 	struct r5conf *conf = sh->raid_conf;
 	int level = conf->level;
 
@@ -2382,13 +2466,15 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 			if (!test_and_set_bit(STRIPE_FULL_WRITE, &sh->state))
 				atomic_inc(&conf->pending_full_writes);
 	} else {
-		BUG_ON(level == 6);
 		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
 			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
+		BUG_ON(level == 6 &&
+			(!(test_bit(R5_UPTODATE, &sh->dev[qd_idx].flags) ||
+			test_bit(R5_Wantcompute, &sh->dev[qd_idx].flags))));
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (i == pd_idx)
+			if (i == pd_idx || i == qd_idx)
 				continue;
 
 			if (dev->towrite &&
@@ -2404,9 +2490,16 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 			/* False alarm - nothing to do */
 			return;
 		sh->reconstruct_state = reconstruct_state_prexor_drain_run;
-		set_bit(STRIPE_OP_PREXOR, &s->ops_request);
-		set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
-		set_bit(STRIPE_OP_RECONSTRUCT, &s->ops_request);
+
+		if (level == 6) {
+			set_bit(STRIPE_OP_RMW_SUBTRACT, &s->ops_request);
+			set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
+			set_bit(STRIPE_OP_RMW, &s->ops_request);
+		} else {
+			set_bit(STRIPE_OP_PREXOR, &s->ops_request);
+			set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
+			set_bit(STRIPE_OP_RECONSTRUCT, &s->ops_request);
+		}
 	}
 
 	/* keep the parity disk(s) locked while asynchronous operations
@@ -2876,15 +2969,14 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	int rmw = 0, rcw = 0, i;
 	sector_t recovery_cp = conf->mddev->recovery_cp;
 
-	/* RAID6 requires 'rcw' in current implementation.
-	 * Otherwise, check whether resync is now happening or should start.
+	/* Check whether resync is now happening or should start.
 	 * If yes, then the array is dirty (after unclean shutdown or
 	 * initial creation), so parity in some stripes might be inconsistent.
 	 * In this case, we need to always do reconstruct-write, to ensure
 	 * that in case of drive failure or read-error correction, we
 	 * generate correct data from the parity.
 	 */
-	if (conf->max_degraded == 2 ||
+	if ((conf->max_degraded == 2 && !conf->enable_rmw) ||
 	    (recovery_cp < MaxSector && sh->sector >= recovery_cp)) {
 		/* Calculate the real rcw later - for now make it
 		 * look like rcw is cheaper
@@ -2896,7 +2988,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	} else for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
 		struct r5dev *dev = &sh->dev[i];
-		if ((dev->towrite || i == sh->pd_idx) &&
+		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
 		      test_bit(R5_Wantcompute, &dev->flags))) {
@@ -2907,6 +2999,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 		}
 		/* Would I have to read this buffer for reconstruct_write */
 		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
+		    i != sh->qd_idx &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
 		    test_bit(R5_Wantcompute, &dev->flags))) {
@@ -2926,7 +3019,8 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 					  (unsigned long long)sh->sector, rmw);
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if ((dev->towrite || i == sh->pd_idx) &&
+			if ((dev->towrite || i == sh->pd_idx ||
+			    i == sh->qd_idx) &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
 			    test_bit(R5_Wantcompute, &dev->flags)) &&
@@ -5360,11 +5454,48 @@ raid5_auxthread_number = __ATTR(auxthread_number, S_IRUGO|S_IWUSR,
 				raid5_show_auxthread_number,
 				raid5_store_auxthread_number);
 
+static ssize_t
+raid5_show_enable_rmw(struct mddev  *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+
+	if (conf->level == 6)
+		return sprintf(page, "%d\n", conf->enable_rmw);
+	else
+		return sprintf(page, "%d\n", 1);
+}
+
+static ssize_t
+raid5_store_enable_rmw(struct mddev  *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	unsigned long new;
+
+	if (!conf)
+		return -ENODEV;
+	if (conf->level != 6)
+		return -EINVAL;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+
+	if (kstrtoul(page, 10, &new))
+		return -EINVAL;
+	conf->enable_rmw = !!new;
+	return len;
+}
+
+static struct md_sysfs_entry
+raid5_enable_rmw = __ATTR(enable_rmw, S_IRUGO | S_IWUSR,
+				raid5_show_enable_rmw,
+				raid5_store_enable_rmw);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
 	&raid5_preread_bypass_threshold.attr,
 	&raid5_auxthread_number.attr,
+	&raid5_enable_rmw.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
@@ -5400,6 +5531,7 @@ static void raid5_free_percpu(struct r5conf *conf)
 	for_each_possible_cpu(cpu) {
 		percpu = per_cpu_ptr(conf->percpu, cpu);
 		safe_put_page(percpu->spare_page);
+		safe_put_page(percpu->spare_page2);
 		kfree(percpu->scribble);
 	}
 #ifdef CONFIG_HOTPLUG_CPU
@@ -5433,12 +5565,16 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 	case CPU_UP_PREPARE_FROZEN:
 		if (conf->level == 6 && !percpu->spare_page)
 			percpu->spare_page = alloc_page(GFP_KERNEL);
+		if (conf->level == 6 && !percpu->spare_page2)
+			percpu->spare_page2 = alloc_page(GFP_KERNEL);
 		if (!percpu->scribble)
 			percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
 
 		if (!percpu->scribble ||
-		    (conf->level == 6 && !percpu->spare_page)) {
+		    (conf->level == 6 && !percpu->spare_page) ||
+		    (conf->level == 6 && !percpu->spare_page2)) {
 			safe_put_page(percpu->spare_page);
+			safe_put_page(percpu->spare_page2);
 			kfree(percpu->scribble);
 			pr_err("%s: failed memory allocation for cpu%ld\n",
 			       __func__, cpu);
@@ -5456,8 +5592,10 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 		spin_unlock_irq(&conf->device_lock);
 
 		safe_put_page(percpu->spare_page);
+		safe_put_page(percpu->spare_page2);
 		kfree(percpu->scribble);
 		percpu->spare_page = NULL;
+		percpu->spare_page2 = NULL;
 		percpu->scribble = NULL;
 		break;
 	default:
@@ -5496,6 +5634,13 @@ static int raid5_alloc_percpu(struct r5conf *conf)
 				break;
 			}
 			percpu->spare_page = spare_page;
+			spare_page = alloc_page(GFP_KERNEL);
+			if (!spare_page) {
+				err = -ENOMEM;
+				break;
+			}
+			per_cpu_ptr(conf->percpu, cpu)->spare_page2 =
+			    spare_page;
 		}
 		scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
 		if (!scribble) {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 217cb19..fd7ed19 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -334,6 +334,8 @@ enum {
 	STRIPE_OP_PREXOR,
 	STRIPE_OP_BIODRAIN,
 	STRIPE_OP_RECONSTRUCT,
+	STRIPE_OP_RMW_SUBTRACT,
+	STRIPE_OP_RMW,
 	STRIPE_OP_CHECK,
 };
 /*
@@ -437,6 +439,7 @@ struct r5conf {
 	/* per cpu variables */
 	struct raid5_percpu {
 		struct page	*spare_page; /* Used when checking P/Q in raid6 */
+		struct page	*spare_page2; /* Used for rmw writes in raid6 */
 		void		*scribble;   /* space for constructing buffer
 					      * lists and performing address
 					      * conversions
@@ -479,6 +482,7 @@ struct r5conf {
 	struct raid5_auxth	**aux_threads;
 	/* which CPUs should raid5d thread handle stripes from */
 	cpumask_t		work_mask;
+	int			enable_rmw; /* 1 if rmw is enabled for raid6 */
 };
 
 /*

