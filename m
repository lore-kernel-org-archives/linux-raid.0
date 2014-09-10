From: shli@kernel.org
Subject: [patch v2 1/6] raid5: use flex_array for scribble data
Date: Wed, 10 Sep 2014 20:40:10 +0800
Message-ID: <20140910124253.864391033@kernel.org>
References: <20140910124009.810771309@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-scribble-use-flex-array.patch
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Use flex_array for scribble data. Next patch will batch several stripes
together, so scribble data should be able to cover several stripes, so this
patch also allocates scribble data for stripes across a chunk.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   89 +++++++++++++++++++++++++++++++++--------------------
 drivers/md/raid5.h |    6 ---
 2 files changed, 57 insertions(+), 38 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-09-10 19:21:00.503475395 +0800
+++ linux/drivers/md/raid5.c	2014-09-10 19:21:00.499475454 +0800
@@ -54,6 +54,7 @@
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 #include <linux/nodemask.h>
+#include <linux/flex_array.h>
 #include <trace/events/block.h>
 
 #include "md.h"
@@ -1112,16 +1113,29 @@ static void ops_complete_compute(void *s
 
 /* return a pointer to the address conversion region of the scribble buffer */
 static addr_conv_t *to_addr_conv(struct stripe_head *sh,
-				 struct raid5_percpu *percpu)
+				 struct raid5_percpu *percpu, int i)
 {
-	return percpu->scribble + sizeof(struct page *) * (sh->disks + 2);
+	void *addr;
+
+	addr = flex_array_get(percpu->scribble, i);
+	return addr + sizeof(struct page *) * (sh->disks + 2);
+}
+
+/* return a pointer to the address conversion region of the scribble buffer */
+static struct page **to_addr_page(struct stripe_head *sh,
+				 struct raid5_percpu *percpu, int i)
+{
+	void *addr;
+
+	addr = flex_array_get(percpu->scribble, i);
+	return addr;
 }
 
 static struct dma_async_tx_descriptor *
 ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
-	struct page **xor_srcs = percpu->scribble;
+	struct page **xor_srcs = to_addr_page(sh, percpu, 0);
 	int target = sh->ops.target;
 	struct r5dev *tgt = &sh->dev[target];
 	struct page *xor_dest = tgt->page;
@@ -1141,7 +1155,7 @@ ops_run_compute5(struct stripe_head *sh,
 	atomic_inc(&sh->count);
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
-			  ops_complete_compute, sh, to_addr_conv(sh, percpu));
+			  ops_complete_compute, sh, to_addr_conv(sh, percpu, 0));
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
 	else
@@ -1186,7 +1200,7 @@ static struct dma_async_tx_descriptor *
 ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
-	struct page **blocks = percpu->scribble;
+	struct page **blocks = to_addr_page(sh, percpu, 0);
 	int target;
 	int qd_idx = sh->qd_idx;
 	struct dma_async_tx_descriptor *tx;
@@ -1219,7 +1233,7 @@ ops_run_compute6_1(struct stripe_head *s
 		BUG_ON(blocks[count+1] != dest); /* q should already be set */
 		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 				  ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu));
+				  to_addr_conv(sh, percpu, 0));
 		tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);
 	} else {
 		/* Compute any data- or p-drive using XOR */
@@ -1232,7 +1246,7 @@ ops_run_compute6_1(struct stripe_head *s
 
 		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
 				  NULL, ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu));
+				  to_addr_conv(sh, percpu, 0));
 		tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE, &submit);
 	}
 
@@ -1251,7 +1265,7 @@ ops_run_compute6_2(struct stripe_head *s
 	struct r5dev *tgt = &sh->dev[target];
 	struct r5dev *tgt2 = &sh->dev[target2];
 	struct dma_async_tx_descriptor *tx;
-	struct page **blocks = percpu->scribble;
+	struct page **blocks = to_addr_page(sh, percpu, 0);
 	struct async_submit_ctl submit;
 
 	pr_debug("%s: stripe %llu block1: %d block2: %d\n",
@@ -1293,7 +1307,7 @@ ops_run_compute6_2(struct stripe_head *s
 			/* Missing P+Q, just recompute */
 			init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 					  ops_complete_compute, sh,
-					  to_addr_conv(sh, percpu));
+					  to_addr_conv(sh, percpu, 0));
 			return async_gen_syndrome(blocks, 0, syndrome_disks+2,
 						  STRIPE_SIZE, &submit);
 		} else {
@@ -1317,21 +1331,21 @@ ops_run_compute6_2(struct stripe_head *s
 			init_async_submit(&submit,
 					  ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
 					  NULL, NULL, NULL,
-					  to_addr_conv(sh, percpu));
+					  to_addr_conv(sh, percpu, 0));
 			tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE,
 				       &submit);
 
 			count = set_syndrome_sources(blocks, sh);
 			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
 					  ops_complete_compute, sh,
-					  to_addr_conv(sh, percpu));
+					  to_addr_conv(sh, percpu, 0));
 			return async_gen_syndrome(blocks, 0, count+2,
 						  STRIPE_SIZE, &submit);
 		}
 	} else {
 		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 				  ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu));
+				  to_addr_conv(sh, percpu, 0));
 		if (failb == syndrome_disks) {
 			/* We're missing D+P. */
 			return async_raid6_datap_recov(syndrome_disks+2,
@@ -1360,7 +1374,7 @@ ops_run_prexor(struct stripe_head *sh, s
 	       struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
-	struct page **xor_srcs = percpu->scribble;
+	struct page **xor_srcs = to_addr_page(sh, percpu, 0);
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct async_submit_ctl submit;
 
@@ -1378,7 +1392,7 @@ ops_run_prexor(struct stripe_head *sh, s
 	}
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
-			  ops_complete_prexor, sh, to_addr_conv(sh, percpu));
+			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, 0));
 	tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
 
 	return tx;
@@ -1482,7 +1496,7 @@ ops_run_reconstruct5(struct stripe_head
 		     struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
-	struct page **xor_srcs = percpu->scribble;
+	struct page **xor_srcs = to_addr_page(sh, percpu, 0);
 	struct async_submit_ctl submit;
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
@@ -1535,7 +1549,7 @@ ops_run_reconstruct5(struct stripe_head
 	atomic_inc(&sh->count);
 
 	init_async_submit(&submit, flags, tx, ops_complete_reconstruct, sh,
-			  to_addr_conv(sh, percpu));
+			  to_addr_conv(sh, percpu, 0));
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
 	else
@@ -1547,7 +1561,7 @@ ops_run_reconstruct6(struct stripe_head
 		     struct dma_async_tx_descriptor *tx)
 {
 	struct async_submit_ctl submit;
-	struct page **blocks = percpu->scribble;
+	struct page **blocks = to_addr_page(sh, percpu, 0);
 	int count, i;
 
 	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
@@ -1571,7 +1585,7 @@ ops_run_reconstruct6(struct stripe_head
 	atomic_inc(&sh->count);
 
 	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_reconstruct,
-			  sh, to_addr_conv(sh, percpu));
+			  sh, to_addr_conv(sh, percpu, 0));
 	async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
 }
 
@@ -1593,7 +1607,7 @@ static void ops_run_check_p(struct strip
 	int pd_idx = sh->pd_idx;
 	int qd_idx = sh->qd_idx;
 	struct page *xor_dest;
-	struct page **xor_srcs = percpu->scribble;
+	struct page **xor_srcs = to_addr_page(sh, percpu, 0);
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
 	int count;
@@ -1612,7 +1626,7 @@ static void ops_run_check_p(struct strip
 	}
 
 	init_async_submit(&submit, 0, NULL, NULL, NULL,
-			  to_addr_conv(sh, percpu));
+			  to_addr_conv(sh, percpu, 0));
 	tx = async_xor_val(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
 			   &sh->ops.zero_sum_result, &submit);
 
@@ -1623,7 +1637,7 @@ static void ops_run_check_p(struct strip
 
 static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu, int checkp)
 {
-	struct page **srcs = percpu->scribble;
+	struct page **srcs = to_addr_page(sh, percpu, 0);
 	struct async_submit_ctl submit;
 	int count;
 
@@ -1636,7 +1650,7 @@ static void ops_run_check_pq(struct stri
 
 	atomic_inc(&sh->count);
 	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
-			  sh, to_addr_conv(sh, percpu));
+			  sh, to_addr_conv(sh, percpu, 0));
 	async_syndrome_val(srcs, 0, count+2, STRIPE_SIZE,
 			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
 }
@@ -1776,13 +1790,21 @@ static int grow_stripes(struct r5conf *c
  * calculate over all devices (not just the data blocks), using zeros in place
  * of the P and Q blocks.
  */
-static size_t scribble_len(int num)
+static struct flex_array *scribble_alloc(int num, int cnt, gfp_t flags)
 {
+	struct flex_array *ret;
 	size_t len;
 
 	len = sizeof(struct page *) * (num+2) + sizeof(addr_conv_t) * (num+2);
-
-	return len;
+	ret = flex_array_alloc(len, cnt, flags);
+	if (!ret)
+		return NULL;
+	/* always prealloc all elements, so no locking is required */
+	if (flex_array_prealloc(ret, 0, cnt, flags)) {
+		flex_array_free(ret);
+		return NULL;
+	}
+	return ret;
 }
 
 static int resize_stripes(struct r5conf *conf, int newsize)
@@ -1900,16 +1922,16 @@ static int resize_stripes(struct r5conf
 		err = -ENOMEM;
 
 	get_online_cpus();
-	conf->scribble_len = scribble_len(newsize);
 	for_each_present_cpu(cpu) {
 		struct raid5_percpu *percpu;
-		void *scribble;
+		struct flex_array *scribble;
 
 		percpu = per_cpu_ptr(conf->percpu, cpu);
-		scribble = kmalloc(conf->scribble_len, GFP_NOIO);
+		scribble = scribble_alloc(newsize, conf->chunk_sectors /
+			STRIPE_SECTORS, GFP_NOIO);
 
 		if (scribble) {
-			kfree(percpu->scribble);
+			flex_array_free(percpu->scribble);
 			percpu->scribble = scribble;
 		} else {
 			err = -ENOMEM;
@@ -5610,7 +5632,7 @@ raid5_size(struct mddev *mddev, sector_t
 static void free_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu)
 {
 	safe_put_page(percpu->spare_page);
-	kfree(percpu->scribble);
+	flex_array_free(percpu->scribble);
 	percpu->spare_page = NULL;
 	percpu->scribble = NULL;
 }
@@ -5620,7 +5642,9 @@ static int alloc_scratch_buffer(struct r
 	if (conf->level == 6 && !percpu->spare_page)
 		percpu->spare_page = alloc_page(GFP_KERNEL);
 	if (!percpu->scribble)
-		percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
+		percpu->scribble = scribble_alloc(max(conf->raid_disks,
+			conf->previous_raid_disks), conf->chunk_sectors /
+			STRIPE_SECTORS, GFP_KERNEL);
 
 	if (!percpu->scribble || (conf->level == 6 && !percpu->spare_page)) {
 		free_scratch_buffer(conf, percpu);
@@ -5790,7 +5814,6 @@ static struct r5conf *setup_conf(struct
 	else
 		conf->previous_raid_disks = mddev->raid_disks - mddev->delta_disks;
 	max_disks = max(conf->raid_disks, conf->previous_raid_disks);
-	conf->scribble_len = scribble_len(max_disks);
 
 	conf->disks = kzalloc(max_disks * sizeof(struct disk_info),
 			      GFP_KERNEL);
@@ -5818,6 +5841,7 @@ static struct r5conf *setup_conf(struct
 		INIT_LIST_HEAD(conf->temp_inactive_list + i);
 
 	conf->level = mddev->new_level;
+	conf->chunk_sectors = mddev->new_chunk_sectors;
 	if (raid5_alloc_percpu(conf) != 0)
 		goto abort;
 
@@ -5850,7 +5874,6 @@ static struct r5conf *setup_conf(struct
 			conf->fullsync = 1;
 	}
 
-	conf->chunk_sectors = mddev->new_chunk_sectors;
 	conf->level = mddev->new_level;
 	if (conf->level == 6)
 		conf->max_degraded = 2;
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2014-09-10 19:21:00.503475395 +0800
+++ linux/drivers/md/raid5.h	2014-09-10 19:21:00.499475454 +0800
@@ -459,15 +459,11 @@ struct r5conf {
 	/* per cpu variables */
 	struct raid5_percpu {
 		struct page	*spare_page; /* Used when checking P/Q in raid6 */
-		void		*scribble;   /* space for constructing buffer
+		struct flex_array *scribble;   /* space for constructing buffer
 					      * lists and performing address
 					      * conversions
 					      */
 	} __percpu *percpu;
-	size_t			scribble_len; /* size of scribble region must be
-					       * associated with conf to handle
-					       * cpu hotplug while reshaping
-					       */
 #ifdef CONFIG_HOTPLUG_CPU
 	struct notifier_block	cpu_notify;
 #endif

