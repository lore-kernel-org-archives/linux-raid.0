From: Shaohua Li <shli@kernel.org>
Subject: [RFC]RAID5: batch adjacent full stripe write
Date: Mon, 18 Aug 2014 16:25:31 +0800
Message-ID: <20140818082531.GA13732@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


stripe cache is 4k size. Even adjacent full stripe writes are handled in 4k
unit. Idealy we should use big size for adjacent full stripe writes. Bigger
stripe cache size means less stripes runing in the state machine so can reduce
cpu overhead. And also bigger size can cause bigger IO size dispatched to under
layer disks.

With below patch, we will automatically batch adjacent full stripe write
together. Such stripes will form to a container and be added to the container
list. Only the first stripe of a container will be put to handle_list and so
run handle_stripe(). Some steps of handle_stripe() are extended to cover whole
container stripes, including ops_run_io, ops_run_biodrain and so on. With this
patch, we have less stripes running in handle_stripe() and we send IO of whole
container stripes together to increase IO size.

Stripes added to a container have some limitations. A container can only
include full stripe write and can't cross chunk boundary to make sure stripes
have the same parity disk. Stripes in a container must in the same state (no
written, toread and so on). If a stripe is in a container, all new read/write
to add_stripe_bio will be blocked to overlap conflict till the container are
handled. The limitations will make sure stripes in a container in exactly the
same state in the life circly of the container.

I did test running 160k randwrite in a RAID5 array with 32k chunk size and 6
PCIe SSD. This patch improves around 30% performance and IO size to under layer
disk is exactly 32k. I also run a 4k randwrite test in the same array to make
sure the performance isn't changed with the patch.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |  504 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/raid5.h |   23 ++
 2 files changed, 480 insertions(+), 47 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-08-18 16:19:30.974169837 +0800
+++ linux/drivers/md/raid5.c	2014-08-18 16:19:30.966169938 +0800
@@ -525,6 +525,7 @@ static void init_stripe(struct stripe_he
 	BUG_ON(atomic_read(&sh->count) != 0);
 	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
 	BUG_ON(stripe_operations_active(sh));
+	BUG_ON(sh->container_stripe);
 
 	pr_debug("init_stripe called, stripe %llu\n",
 		(unsigned long long)sh->sector);
@@ -711,6 +712,154 @@ get_active_stripe(struct r5conf *conf, s
 	return sh;
 }
 
+static void lock_two_stripes(struct stripe_head *sh1, struct stripe_head *sh2)
+{
+	local_irq_disable();
+	if (sh1 > sh2) {
+		spin_lock(&sh2->stripe_lock);
+		spin_lock_nested(&sh1->stripe_lock, 1);
+	} else {
+		spin_lock(&sh1->stripe_lock);
+		spin_lock_nested(&sh2->stripe_lock, 1);
+	}
+}
+
+static void unlock_two_stripes(struct stripe_head *sh1, struct stripe_head *sh2)
+{
+	spin_unlock(&sh1->stripe_lock);
+	spin_unlock(&sh2->stripe_lock);
+	local_irq_enable();
+}
+
+/* Only freshly new full stripe normal write stripe can be added to a container */
+static int set_stripe_container_ready(struct stripe_head *sh)
+{
+	int ret = 1;
+	int i;
+
+	if (test_and_set_bit_lock(STRIPE_ACTIVE, &sh->state))
+		return 1;
+
+	if ((sh->state & (~STRIPE_CONTAINER_FLAGS)) ||
+		sh->reconstruct_state || sh->check_state)
+		goto unlock_out;
+
+	spin_lock_irq(&sh->stripe_lock);
+	for (i = 0; i < sh->disks; i++) {
+		if (sh->dev[i].flags & (~STRIPE_CONTAINER_DEV_FLAGS)) {
+			spin_unlock_irq(&sh->stripe_lock);
+			goto unlock_out;
+		}
+
+		if (i == sh->pd_idx || i == sh->qd_idx)
+			continue;
+		if (sh->dev[i].toread || sh->dev[i].read ||
+				sh->dev[i].written) {
+			spin_unlock_irq(&sh->stripe_lock);
+			goto unlock_out;
+		}
+	}
+
+	ret = 0;
+	set_bit(STRIPE_CONTAINER_READY, &sh->state);
+	spin_unlock_irq(&sh->stripe_lock);
+unlock_out:
+	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
+	return ret;
+}
+
+/* we only do back search */
+static void add_to_stripe_container(struct r5conf *conf, struct stripe_head *sh)
+{
+	struct stripe_head *head;
+	sector_t head_sector;
+	int hash;
+	int dd_idx;
+
+	if (set_stripe_container_ready(sh))
+		return;
+	/* Don't cross chunks, so stripe pd_idx/qd_idx is the same */
+	if (!(sh->sector % conf->chunk_sectors))
+		return;
+	head_sector = sh->sector - STRIPE_SECTORS;
+
+	hash = stripe_hash_locks_hash(head_sector);
+	spin_lock_irq(conf->hash_locks + hash);
+	head = __find_stripe(conf, head_sector, conf->generation);
+	if (head && !atomic_inc_not_zero(&head->count)) {
+		spin_lock(&conf->device_lock);
+		if (!atomic_read(&head->count)) {
+			if (!test_bit(STRIPE_HANDLE, &head->state))
+				atomic_inc(&conf->active_stripes);
+			BUG_ON(list_empty(&head->lru) &&
+			       !test_bit(STRIPE_EXPANDING, &head->state));
+			list_del_init(&head->lru);
+			if (head->group) {
+				head->group->stripes_cnt--;
+				head->group = NULL;
+			}
+		}
+		atomic_inc(&head->count);
+		spin_unlock(&conf->device_lock);
+	}
+	spin_unlock_irq(conf->hash_locks + hash);
+
+	if (!head)
+		return;
+	if (!test_bit(STRIPE_CONTAINER_READY, &head->state))
+		goto out;
+
+	lock_two_stripes(head, sh);
+	/* clear_container_ready clear the flag */
+	if (!test_bit(STRIPE_CONTAINER_READY, &head->state) ||
+		!test_bit(STRIPE_CONTAINER_READY, &sh->state))
+		goto unlock_out;
+
+	if (sh->container_stripe)
+		goto unlock_out;
+
+	dd_idx = 0;
+	while (dd_idx == sh->pd_idx || dd_idx == sh->qd_idx)
+		dd_idx++;
+	if (head->dev[dd_idx].towrite->bi_rw != sh->dev[dd_idx].towrite->bi_rw)
+		goto unlock_out;
+
+	if (head->container_stripe) {
+		spin_lock(&head->container_stripe->container_lock);
+		/* This container is already running */
+		if (!test_bit(STRIPE_CONTAINER_READY, &head->state)) {
+			spin_unlock(&head->container_stripe->container_lock);
+			goto unlock_out;
+		}
+
+		/*
+		 * at this point, head's CONTAINER_READY could be cleared, but we
+		 * can still add the stripe to container
+		 */
+		list_add(&sh->container_list, &head->container_list);
+		spin_unlock(&head->container_stripe->container_lock);
+
+		sh->container_stripe = head->container_stripe;
+	} else {
+		head->container_stripe = head;
+		sh->container_stripe = head->container_stripe;
+		spin_lock(&head->container_lock);
+		list_add_tail(&sh->container_list, &head->container_list);
+		spin_unlock(&head->container_lock);
+	}
+
+	if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+		if (atomic_dec_return(&conf->preread_active_stripes)
+		    < IO_THRESHOLD)
+			md_wakeup_thread(conf->mddev->thread);
+
+	atomic_inc(&sh->count);
+unlock_out:
+	unlock_two_stripes(head, sh);
+out:
+	release_stripe(head);
+}
+
 /* Determine if 'data_offset' or 'new_data_offset' should be used
  * in this stripe_head.
  */
@@ -741,6 +890,7 @@ static void ops_run_io(struct stripe_hea
 {
 	struct r5conf *conf = sh->raid_conf;
 	int i, disks = sh->disks;
+	struct stripe_head *head_sh = sh;
 
 	might_sleep();
 
@@ -749,6 +899,8 @@ static void ops_run_io(struct stripe_hea
 		int replace_only = 0;
 		struct bio *bi, *rbi;
 		struct md_rdev *rdev, *rrdev = NULL;
+
+		sh = head_sh;
 		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags)) {
 			if (test_and_clear_bit(R5_WantFUA, &sh->dev[i].flags))
 				rw = WRITE_FUA;
@@ -767,6 +919,7 @@ static void ops_run_io(struct stripe_hea
 		if (test_and_clear_bit(R5_SyncIO, &sh->dev[i].flags))
 			rw |= REQ_SYNC;
 
+again:
 		bi = &sh->dev[i].req;
 		rbi = &sh->dev[i].rreq; /* For writing to replacement */
 
@@ -785,7 +938,7 @@ static void ops_run_io(struct stripe_hea
 				/* We raced and saw duplicates */
 				rrdev = NULL;
 		} else {
-			if (test_bit(R5_ReadRepl, &sh->dev[i].flags) && rrdev)
+			if (test_bit(R5_ReadRepl, &head_sh->dev[i].flags) && rrdev)
 				rdev = rrdev;
 			rrdev = NULL;
 		}
@@ -856,13 +1009,15 @@ static void ops_run_io(struct stripe_hea
 				__func__, (unsigned long long)sh->sector,
 				bi->bi_rw, i);
 			atomic_inc(&sh->count);
+			if (sh != head_sh)
+				atomic_inc(&head_sh->count);
 			if (use_new_offset(conf, sh))
 				bi->bi_iter.bi_sector = (sh->sector
 						 + rdev->new_data_offset);
 			else
 				bi->bi_iter.bi_sector = (sh->sector
 						 + rdev->data_offset);
-			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
+			if (test_bit(R5_ReadNoMerge, &head_sh->dev[i].flags))
 				bi->bi_rw |= REQ_NOMERGE;
 
 			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
@@ -906,6 +1061,8 @@ static void ops_run_io(struct stripe_hea
 				__func__, (unsigned long long)sh->sector,
 				rbi->bi_rw, i);
 			atomic_inc(&sh->count);
+			if (sh != head_sh)
+				atomic_inc(&head_sh->count);
 			if (use_new_offset(conf, sh))
 				rbi->bi_iter.bi_sector = (sh->sector
 						  + rrdev->new_data_offset);
@@ -937,8 +1094,18 @@ static void ops_run_io(struct stripe_hea
 			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
+			if (sh->container_stripe)
+				set_bit(STRIPE_CONTAINER_ERR,
+					&sh->container_stripe->state);
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
+
+		if (!head_sh->container_stripe)
+			continue;
+		sh = list_first_entry(&sh->container_list, struct stripe_head,
+			container_list);
+		if (sh != head_sh)
+			goto again;
 	}
 }
 
@@ -1054,6 +1221,7 @@ static void ops_run_biofill(struct strip
 	struct async_submit_ctl submit;
 	int i;
 
+	BUG_ON(sh->container_stripe);
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
@@ -1112,11 +1280,24 @@ static void ops_complete_compute(void *s
 
 /* return a pointer to the address conversion region of the scribble buffer */
 static addr_conv_t *to_addr_conv(struct stripe_head *sh,
-				 struct raid5_percpu *percpu)
+				 struct raid5_percpu *percpu, int i)
 {
-	return percpu->scribble + sizeof(struct page *) * (sh->disks + 2);
+	return percpu->scribble +
+		i * (sizeof(struct page *) * (sh->disks + 2) +
+		sizeof(addr_conv_t) * (sh->disks + 2)) +
+		sizeof(struct page *) * (sh->disks + 2);
 }
 
+/* return a pointer to the address conversion region of the scribble buffer */
+static struct page **to_addr_page(struct stripe_head *sh,
+				 struct raid5_percpu *percpu, int i)
+{
+	return percpu->scribble +
+		i * (sizeof(struct page *) * (sh->disks + 2) +
+		sizeof(addr_conv_t) * (sh->disks + 2));
+}
+
+
 static struct dma_async_tx_descriptor *
 ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
@@ -1130,6 +1311,8 @@ ops_run_compute5(struct stripe_head *sh,
 	struct async_submit_ctl submit;
 	int i;
 
+	BUG_ON(sh->container_stripe);
+
 	pr_debug("%s: stripe %llu block: %d\n",
 		__func__, (unsigned long long)sh->sector, target);
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
@@ -1141,7 +1324,7 @@ ops_run_compute5(struct stripe_head *sh,
 	atomic_inc(&sh->count);
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
-			  ops_complete_compute, sh, to_addr_conv(sh, percpu));
+			  ops_complete_compute, sh, to_addr_conv(sh, percpu, 0));
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
 	else
@@ -1186,7 +1369,7 @@ static struct dma_async_tx_descriptor *
 ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
-	struct page **blocks = percpu->scribble;
+	struct page **blocks = to_addr_page(sh, percpu, 0);
 	int target;
 	int qd_idx = sh->qd_idx;
 	struct dma_async_tx_descriptor *tx;
@@ -1196,6 +1379,7 @@ ops_run_compute6_1(struct stripe_head *s
 	int i;
 	int count;
 
+	BUG_ON(sh->container_stripe);
 	if (sh->ops.target < 0)
 		target = sh->ops.target2;
 	else if (sh->ops.target2 < 0)
@@ -1219,7 +1403,7 @@ ops_run_compute6_1(struct stripe_head *s
 		BUG_ON(blocks[count+1] != dest); /* q should already be set */
 		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 				  ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu));
+				  to_addr_conv(sh, percpu, 0));
 		tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);
 	} else {
 		/* Compute any data- or p-drive using XOR */
@@ -1232,7 +1416,7 @@ ops_run_compute6_1(struct stripe_head *s
 
 		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
 				  NULL, ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu));
+				  to_addr_conv(sh, percpu, 0));
 		tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE, &submit);
 	}
 
@@ -1251,9 +1435,10 @@ ops_run_compute6_2(struct stripe_head *s
 	struct r5dev *tgt = &sh->dev[target];
 	struct r5dev *tgt2 = &sh->dev[target2];
 	struct dma_async_tx_descriptor *tx;
-	struct page **blocks = percpu->scribble;
+	struct page **blocks = to_addr_page(sh, percpu, 0);
 	struct async_submit_ctl submit;
 
+	BUG_ON(sh->container_stripe);
 	pr_debug("%s: stripe %llu block1: %d block2: %d\n",
 		 __func__, (unsigned long long)sh->sector, target, target2);
 	BUG_ON(target < 0 || target2 < 0);
@@ -1293,7 +1478,7 @@ ops_run_compute6_2(struct stripe_head *s
 			/* Missing P+Q, just recompute */
 			init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 					  ops_complete_compute, sh,
-					  to_addr_conv(sh, percpu));
+					  to_addr_conv(sh, percpu, 0));
 			return async_gen_syndrome(blocks, 0, syndrome_disks+2,
 						  STRIPE_SIZE, &submit);
 		} else {
@@ -1317,21 +1502,21 @@ ops_run_compute6_2(struct stripe_head *s
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
@@ -1360,13 +1545,14 @@ ops_run_prexor(struct stripe_head *sh, s
 	       struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
-	struct page **xor_srcs = percpu->scribble;
+	struct page **xor_srcs = to_addr_page(sh, percpu, 0);
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct async_submit_ctl submit;
 
 	/* existing parity data subtracted */
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 
+	BUG_ON(sh->container_stripe);
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
@@ -1378,7 +1564,7 @@ ops_run_prexor(struct stripe_head *sh, s
 	}
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
-			  ops_complete_prexor, sh, to_addr_conv(sh, percpu));
+			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, 0));
 	tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
 
 	return tx;
@@ -1389,17 +1575,21 @@ ops_run_biodrain(struct stripe_head *sh,
 {
 	int disks = sh->disks;
 	int i;
+	struct stripe_head *head_sh = sh;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
-		struct r5dev *dev = &sh->dev[i];
+		struct r5dev *dev;
 		struct bio *chosen;
 
-		if (test_and_clear_bit(R5_Wantdrain, &dev->flags)) {
+		sh = head_sh;
+		if (test_and_clear_bit(R5_Wantdrain, &head_sh->dev[i].flags)) {
 			struct bio *wbi;
 
+again:
+			dev = &sh->dev[i];
 			spin_lock_irq(&sh->stripe_lock);
 			chosen = dev->towrite;
 			dev->towrite = NULL;
@@ -1427,6 +1617,14 @@ ops_run_biodrain(struct stripe_head *sh,
 				}
 				wbi = r5_next_bio(wbi, dev->sector);
 			}
+
+			if (head_sh->container_stripe) {
+				sh = list_first_entry(&sh->container_list,
+					struct stripe_head, container_list);
+				if (sh == head_sh)
+					continue;
+				goto again;
+			}
 		}
 	}
 
@@ -1482,12 +1680,15 @@ ops_run_reconstruct5(struct stripe_head
 		     struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
-	struct page **xor_srcs = percpu->scribble;
+	struct page **xor_srcs;
 	struct async_submit_ctl submit;
-	int count = 0, pd_idx = sh->pd_idx, i;
+	int count, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
 	int prexor = 0;
 	unsigned long flags;
+	int j = 0;
+	struct stripe_head *head_sh = sh;
+	int last_stripe;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
@@ -1504,15 +1705,18 @@ ops_run_reconstruct5(struct stripe_head
 		ops_complete_reconstruct(sh);
 		return;
 	}
+again:
+	count = 0;
+	xor_srcs = to_addr_page(sh, percpu, j);
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (written)
 	 */
-	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
+	if (head_sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
 		prexor = 1;
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (dev->written)
+			if (head_sh->dev[i].written)
 				xor_srcs[count++] = dev->page;
 		}
 	} else {
@@ -1529,17 +1733,31 @@ ops_run_reconstruct5(struct stripe_head
 	 * set ASYNC_TX_XOR_DROP_DST and ASYNC_TX_XOR_ZERO_DST
 	 * for the synchronous xor case
 	 */
-	flags = ASYNC_TX_ACK |
-		(prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST);
-
-	atomic_inc(&sh->count);
+	last_stripe = !head_sh->container_stripe || list_first_entry(&sh->container_list,
+		struct stripe_head, container_list) == head_sh;
+	if (last_stripe) {
+		flags = ASYNC_TX_ACK |
+			(prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST);
+
+		atomic_inc(&head_sh->count);
+		init_async_submit(&submit, flags, tx, ops_complete_reconstruct, head_sh,
+			  to_addr_conv(sh, percpu, j));
+	} else {
+		flags = prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST;
+		init_async_submit(&submit, flags, tx, NULL, NULL,
+			  to_addr_conv(sh, percpu, j));
+	}
 
-	init_async_submit(&submit, flags, tx, ops_complete_reconstruct, sh,
-			  to_addr_conv(sh, percpu));
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
 	else
 		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
+	if (!last_stripe) {
+		j++;
+		sh = list_first_entry(&sh->container_list, struct stripe_head,
+			container_list);
+		goto again;
+	}
 }
 
 static void
@@ -1547,8 +1765,10 @@ ops_run_reconstruct6(struct stripe_head
 		     struct dma_async_tx_descriptor *tx)
 {
 	struct async_submit_ctl submit;
-	struct page **blocks = percpu->scribble;
-	int count, i;
+	struct page **blocks;
+	int count, i, j = 0;
+	struct stripe_head *head_sh = sh;
+	int last_stripe;
 
 	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
 
@@ -1565,14 +1785,27 @@ ops_run_reconstruct6(struct stripe_head
 		ops_complete_reconstruct(sh);
 		return;
 	}
-
+again:
+	blocks = to_addr_page(sh, percpu, j);
 	count = set_syndrome_sources(blocks, sh);
+	last_stripe = !head_sh->container_stripe || list_first_entry(&sh->container_list,
+		struct stripe_head, container_list) == head_sh;
 
-	atomic_inc(&sh->count);
+	if (last_stripe) {
+		atomic_inc(&head_sh->count);
 
-	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_reconstruct,
-			  sh, to_addr_conv(sh, percpu));
+		init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_reconstruct,
+			  head_sh, to_addr_conv(sh, percpu, j));
+	} else
+		init_async_submit(&submit, 0, tx, NULL, NULL,
+			  to_addr_conv(sh, percpu, j));
 	async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
+	if (!last_stripe) {
+		j++;
+		sh = list_first_entry(&sh->container_list, struct stripe_head,
+			container_list);
+		goto again;
+	}
 }
 
 static void ops_complete_check(void *stripe_head_ref)
@@ -1593,7 +1826,7 @@ static void ops_run_check_p(struct strip
 	int pd_idx = sh->pd_idx;
 	int qd_idx = sh->qd_idx;
 	struct page *xor_dest;
-	struct page **xor_srcs = percpu->scribble;
+	struct page **xor_srcs = to_addr_page(sh, percpu, 0);
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
 	int count;
@@ -1602,6 +1835,7 @@ static void ops_run_check_p(struct strip
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+	BUG_ON(sh->container_stripe);
 	count = 0;
 	xor_dest = sh->dev[pd_idx].page;
 	xor_srcs[count++] = xor_dest;
@@ -1612,7 +1846,7 @@ static void ops_run_check_p(struct strip
 	}
 
 	init_async_submit(&submit, 0, NULL, NULL, NULL,
-			  to_addr_conv(sh, percpu));
+			  to_addr_conv(sh, percpu, 0));
 	tx = async_xor_val(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
 			   &sh->ops.zero_sum_result, &submit);
 
@@ -1623,20 +1857,21 @@ static void ops_run_check_p(struct strip
 
 static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu, int checkp)
 {
-	struct page **srcs = percpu->scribble;
+	struct page **srcs = to_addr_page(sh, percpu, 0);
 	struct async_submit_ctl submit;
 	int count;
 
 	pr_debug("%s: stripe %llu checkp: %d\n", __func__,
 		(unsigned long long)sh->sector, checkp);
 
+	BUG_ON(sh->container_stripe);
 	count = set_syndrome_sources(srcs, sh);
 	if (!checkp)
 		srcs[count] = NULL;
 
 	atomic_inc(&sh->count);
 	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
-			  sh, to_addr_conv(sh, percpu));
+			  sh, to_addr_conv(sh, percpu, 0));
 	async_syndrome_val(srcs, 0, count+2, STRIPE_SIZE,
 			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
 }
@@ -1697,7 +1932,7 @@ static void raid_run_ops(struct stripe_h
 			BUG();
 	}
 
-	if (overlap_clear)
+	if (overlap_clear && !sh->container_stripe)
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
@@ -1727,6 +1962,10 @@ static int grow_one_stripe(struct r5conf
 	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
 	INIT_LIST_HEAD(&sh->lru);
+
+	spin_lock_init(&sh->container_lock);
+	INIT_LIST_HEAD(&sh->container_list);
+	sh->container_stripe = NULL;
 	release_stripe(sh);
 	return 1;
 }
@@ -1776,11 +2015,12 @@ static int grow_stripes(struct r5conf *c
  * calculate over all devices (not just the data blocks), using zeros in place
  * of the P and Q blocks.
  */
-static size_t scribble_len(int num)
+static size_t scribble_len(int chunk_sectors, int num)
 {
 	size_t len;
 
 	len = sizeof(struct page *) * (num+2) + sizeof(addr_conv_t) * (num+2);
+	len *= chunk_sectors / STRIPE_SECTORS;
 
 	return len;
 }
@@ -1900,7 +2140,7 @@ static int resize_stripes(struct r5conf
 		err = -ENOMEM;
 
 	get_online_cpus();
-	conf->scribble_len = scribble_len(newsize);
+	conf->scribble_len = scribble_len(conf->chunk_sectors, newsize);
 	for_each_present_cpu(cpu) {
 		struct raid5_percpu *percpu;
 		void *scribble;
@@ -2158,10 +2398,16 @@ static void raid5_end_write_request(stru
 	}
 	rdev_dec_pending(rdev, conf->mddev);
 
+	if (sh->container_stripe && !uptodate)
+		set_bit(STRIPE_CONTAINER_ERR, &sh->container_stripe->state);
+
 	if (!test_and_clear_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags))
 		clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
+
+	if (sh->container_stripe && sh != sh->container_stripe)
+		release_stripe(sh->container_stripe);
 }
 
 static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous);
@@ -2631,11 +2877,13 @@ schedule_reconstruction(struct stripe_he
  * toread/towrite point to the first in a chain.
  * The bi_next chain must be in order.
  */
-static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
+static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
+	int forwrite, int previous)
 {
 	struct bio **bip;
 	struct r5conf *conf = sh->raid_conf;
 	int firstwrite=0;
+	int search_batch = 0;
 
 	pr_debug("adding bi b#%llu to stripe s#%llu\n",
 		(unsigned long long)bi->bi_iter.bi_sector,
@@ -2650,6 +2898,9 @@ static int add_stripe_bio(struct stripe_
 	 * protect it.
 	 */
 	spin_lock_irq(&sh->stripe_lock);
+	/* Don't allow new IO added to stripes in container */
+	if (sh->container_stripe)
+		goto overlap;
 	if (forwrite) {
 		bip = &sh->dev[dd_idx].towrite;
 		if (*bip == NULL)
@@ -2680,8 +2931,21 @@ static int add_stripe_bio(struct stripe_
 			if (bio_end_sector(bi) >= sector)
 				sector = bio_end_sector(bi);
 		}
-		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
+		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS) {
+			int i = 0;
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
+			for (i = 0; i < sh->disks; i++) {
+				if (i == sh->pd_idx || i == sh->qd_idx)
+					continue;
+				if (sh->dev[i].toread || sh->dev[i].read ||
+					sh->dev[i].written)
+					break;
+				if (!test_bit(R5_OVERWRITE, &sh->dev[i].flags))
+					break;
+			}
+			if (i >= sh->disks)
+				search_batch = 1;
+		}
 	}
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
@@ -2695,6 +2959,9 @@ static int add_stripe_bio(struct stripe_
 		sh->bm_seq = conf->seq_flush+1;
 		set_bit(STRIPE_BIT_DELAY, &sh->state);
 	}
+
+	if (search_batch && !previous)
+		add_to_stripe_container(conf, sh);
 	return 1;
 
  overlap:
@@ -2727,6 +2994,7 @@ handle_failed_stripe(struct r5conf *conf
 				struct bio **return_bi)
 {
 	int i;
+	BUG_ON(sh->container_stripe);
 	for (i = disks; i--; ) {
 		struct bio *bi;
 		int bitmap_end = 0;
@@ -2841,6 +3109,7 @@ handle_failed_sync(struct r5conf *conf,
 	int abort = 0;
 	int i;
 
+	BUG_ON(sh->container_stripe);
 	clear_bit(STRIPE_SYNCING, &sh->state);
 	if (test_and_clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags))
 		wake_up(&conf->wait_for_overlap);
@@ -2997,6 +3266,7 @@ static void handle_stripe_fill(struct st
 {
 	int i;
 
+	BUG_ON(sh->container_stripe);
 	/* look for blocks to read/compute, skip this if a compute
 	 * is already in flight, or if the stripe contents are in the
 	 * midst of changing due to a write
@@ -3021,6 +3291,9 @@ static void handle_stripe_clean_event(st
 	int i;
 	struct r5dev *dev;
 	int discard_pending = 0;
+	struct stripe_head *head_sh = sh;
+	bool do_endio = false;
+	int wakeup_nr = 0;
 
 	for (i = disks; i--; )
 		if (sh->dev[i].written) {
@@ -3036,8 +3309,11 @@ static void handle_stripe_clean_event(st
 					clear_bit(R5_UPTODATE, &dev->flags);
 				if (test_and_clear_bit(R5_SkipCopy, &dev->flags)) {
 					WARN_ON(test_bit(R5_UPTODATE, &dev->flags));
-					dev->page = dev->orig_page;
 				}
+				do_endio = true;
+
+returnbi:
+				dev->page = dev->orig_page;
 				wbi = dev->written;
 				dev->written = NULL;
 				while (wbi && wbi->bi_iter.bi_sector <
@@ -3054,6 +3330,16 @@ static void handle_stripe_clean_event(st
 						STRIPE_SECTORS,
 					 !test_bit(STRIPE_DEGRADED, &sh->state),
 						0);
+				if (head_sh->container_stripe) {
+					sh = list_first_entry(&sh->container_list,
+						struct stripe_head, container_list);
+					if (sh != head_sh) {
+						dev = &sh->dev[i];
+						goto returnbi;
+					}
+				}
+				sh = head_sh;
+				dev = &sh->dev[i];
 			} else if (test_bit(R5_Discard, &dev->flags))
 				discard_pending = 1;
 			WARN_ON(test_bit(R5_SkipCopy, &dev->flags));
@@ -3075,8 +3361,17 @@ static void handle_stripe_clean_event(st
 		 * will be reinitialized
 		 */
 		spin_lock_irq(&conf->device_lock);
+unhash:
 		remove_hash(sh);
+		if (head_sh->container_stripe) {
+			sh = list_first_entry(&sh->container_list,
+				struct stripe_head, container_list);
+			if (sh != head_sh)
+					goto unhash;
+		}
 		spin_unlock_irq(&conf->device_lock);
+		sh = head_sh;
+
 		if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state))
 			set_bit(STRIPE_HANDLE, &sh->state);
 
@@ -3085,6 +3380,39 @@ static void handle_stripe_clean_event(st
 	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
 		if (atomic_dec_and_test(&conf->pending_full_writes))
 			md_wakeup_thread(conf->mddev->thread);
+
+	if (!head_sh->container_stripe || !do_endio)
+		return;
+	for (i = 0; i < head_sh->disks; i++) {
+		if (test_and_clear_bit(R5_Overlap, &head_sh->dev[i].flags))
+			wakeup_nr++;
+	}
+	while (!list_empty(&head_sh->container_list)) {
+		int i;
+		sh = list_first_entry(&head_sh->container_list,
+			struct stripe_head, container_list);
+		list_del_init(&sh->container_list);
+
+		sh->state = head_sh->state & (~((1 << STRIPE_ACTIVE) |
+			(1 << STRIPE_PREREAD_ACTIVE)));
+		sh->check_state = head_sh->check_state;
+		sh->reconstruct_state = head_sh->reconstruct_state;
+		for (i = 0; i < sh->disks; i++) {
+			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				wakeup_nr++;
+			sh->dev[i].flags = head_sh->dev[i].flags;
+		}
+
+		spin_lock_irq(&sh->stripe_lock);
+		sh->container_stripe = NULL;
+		spin_unlock_irq(&sh->stripe_lock);
+		release_stripe(sh);
+	}
+
+	spin_lock_irq(&head_sh->stripe_lock);
+	head_sh->container_stripe = NULL;
+	spin_unlock_irq(&head_sh->stripe_lock);
+	wake_up_nr(&conf->wait_for_overlap, wakeup_nr);
 }
 
 static void handle_stripe_dirtying(struct r5conf *conf,
@@ -3218,6 +3546,7 @@ static void handle_parity_checks5(struct
 {
 	struct r5dev *dev = NULL;
 
+	BUG_ON(sh->container_stripe);
 	set_bit(STRIPE_HANDLE, &sh->state);
 
 	switch (sh->check_state) {
@@ -3309,6 +3638,7 @@ static void handle_parity_checks6(struct
 	int qd_idx = sh->qd_idx;
 	struct r5dev *dev;
 
+	BUG_ON(sh->container_stripe);
 	set_bit(STRIPE_HANDLE, &sh->state);
 
 	BUG_ON(s->failed > 2);
@@ -3472,6 +3802,7 @@ static void handle_stripe_expansion(stru
 	 * copy some of them into a target stripe for expand.
 	 */
 	struct dma_async_tx_descriptor *tx = NULL;
+	BUG_ON(sh->container_stripe);
 	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	for (i = 0; i < sh->disks; i++)
 		if (i != sh->pd_idx && i != sh->qd_idx) {
@@ -3715,6 +4046,77 @@ static void analyse_stripe(struct stripe
 	rcu_read_unlock();
 }
 
+static int clear_container_ready(struct stripe_head *sh)
+{
+	struct stripe_head *tmp;
+	if (!test_and_clear_bit(STRIPE_CONTAINER_READY, &sh->state))
+		return 0;
+	spin_lock(&sh->stripe_lock);
+	if (!sh->container_stripe) {
+		spin_unlock(&sh->stripe_lock);
+		return 0;
+	}
+
+	/*
+	 * this stripe could be added to a container before we check
+	 * CONTAINER_READY, skips it
+	 */
+	if (sh->container_stripe != sh) {
+		spin_unlock(&sh->stripe_lock);
+		return 1;
+	}
+	spin_lock(&sh->container_lock);
+	list_for_each_entry(tmp, &sh->container_list, container_list)
+		clear_bit(STRIPE_CONTAINER_READY, &tmp->state);
+	spin_unlock(&sh->container_lock);
+	spin_unlock(&sh->stripe_lock);
+
+	/*
+	 * CONTAINER_READY is cleared, no new stripes can be added.
+	 * Container_list can be accessed without lock
+	 */
+	return 0;
+}
+
+static void check_break_stripe_container(struct stripe_head *sh)
+{
+	struct stripe_head *head_sh, *next;
+	int i;
+
+	if (!test_and_clear_bit(STRIPE_CONTAINER_ERR, &sh->state))
+		return;
+
+	head_sh = sh;
+	do {
+		sh = list_first_entry(&sh->container_list,
+			struct stripe_head, container_list);
+		BUG_ON(sh == head_sh);
+	} while (!test_bit(STRIPE_DEGRADED, &sh->state));
+
+	while (sh != head_sh) {
+		next = list_first_entry(&sh->container_list,
+			struct stripe_head, container_list);
+		list_del_init(&sh->container_list);
+
+		sh->state = head_sh->state & (~((1 << STRIPE_ACTIVE) |
+			(1 << STRIPE_PREREAD_ACTIVE) | (1 << STRIPE_DEGRADED)));
+		sh->check_state = head_sh->check_state;
+		sh->reconstruct_state = head_sh->reconstruct_state;
+		for (i = 0; i < sh->disks; i++)
+			sh->dev[i].flags = head_sh->dev[i].flags &
+				(~((1 << R5_WriteError) | (1 << R5_Overlap)));
+
+		spin_lock_irq(&sh->stripe_lock);
+		sh->container_stripe = NULL;
+		spin_unlock_irq(&sh->stripe_lock);
+
+		set_bit(STRIPE_HANDLE, &sh->state);
+		release_stripe(sh);
+
+		sh = next;
+	}
+}
+
 static void handle_stripe(struct stripe_head *sh)
 {
 	struct stripe_head_state s;
@@ -3732,6 +4134,13 @@ static void handle_stripe(struct stripe_
 		return;
 	}
 
+	if (clear_container_ready(sh) ) {
+		clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
+		return;
+	}
+
+	check_break_stripe_container(sh);
+
 	if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
 		spin_lock(&sh->stripe_lock);
 		/* Cannot process 'sync' concurrently with 'discard' */
@@ -4715,7 +5124,7 @@ static void make_request(struct mddev *m
 			}
 
 			if (test_bit(STRIPE_EXPANDING, &sh->state) ||
-			    !add_stripe_bio(sh, bi, dd_idx, rw)) {
+			    !add_stripe_bio(sh, bi, dd_idx, rw, previous)) {
 				/* Stripe is busy expanding or
 				 * add failed due to overlap.  Flush everything
 				 * and wait a while
@@ -4728,7 +5137,8 @@ static void make_request(struct mddev *m
 			}
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
-			if ((bi->bi_rw & REQ_SYNC) &&
+			if ((!sh->container_stripe || sh == sh->container_stripe) &&
+			    (bi->bi_rw & REQ_SYNC) &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			release_stripe_plug(mddev, sh);
@@ -5124,7 +5534,7 @@ static int  retry_aligned_read(struct r5
 			return handled;
 		}
 
-		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
+		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0, 0)) {
 			release_stripe(sh);
 			raid5_set_bi_processed_stripes(raid_bio, scnt);
 			conf->retry_read_aligned = raid_bio;
@@ -5788,7 +6198,7 @@ static struct r5conf *setup_conf(struct
 	else
 		conf->previous_raid_disks = mddev->raid_disks - mddev->delta_disks;
 	max_disks = max(conf->raid_disks, conf->previous_raid_disks);
-	conf->scribble_len = scribble_len(max_disks);
+	conf->scribble_len = scribble_len(mddev->new_chunk_sectors, max_disks);
 
 	conf->disks = kzalloc(max_disks * sizeof(struct disk_info),
 			      GFP_KERNEL);
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2014-08-18 16:19:30.974169837 +0800
+++ linux/drivers/md/raid5.h	2014-08-18 16:19:30.970169888 +0800
@@ -215,6 +215,10 @@ struct stripe_head {
 	spinlock_t		stripe_lock;
 	int			cpu;
 	struct r5worker_group	*group;
+
+	struct stripe_head	*container_stripe; /* protected by stripe lock */
+	spinlock_t		container_lock; /* only header's lock is useful */
+	struct list_head	container_list; /* protected by head's container lock*/
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -327,8 +331,27 @@ enum {
 	STRIPE_ON_UNPLUG_LIST,
 	STRIPE_DISCARD,
 	STRIPE_ON_RELEASE_LIST,
+	STRIPE_CONTAINER_READY,
+	STRIPE_CONTAINER_ERR,
 };
 
+#define STRIPE_CONTAINER_DEV_FLAGS (\
+	(1 << R5_UPTODATE) |\
+	(1 << R5_OVERWRITE) |\
+	(1 << R5_Insync) |\
+	(1 << R5_Overlap))
+
+#define STRIPE_CONTAINER_FLAGS (\
+	(1 << STRIPE_ACTIVE) | \
+	(1 << STRIPE_HANDLE) | \
+	(1 << STRIPE_PREREAD_ACTIVE) | \
+	(1 << STRIPE_DELAYED) | \
+	(1 << STRIPE_BIT_DELAY) | \
+	(1 << STRIPE_ON_UNPLUG_LIST) | \
+	(1 << STRIPE_DISCARD) | \
+	(1 << STRIPE_ON_RELEASE_LIST) | \
+	(1 << STRIPE_CONTAINER_READY))
+
 /*
  * Operation request flags
  */
