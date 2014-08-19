From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v2 5/6] raid6: activate rmw feature
Date: Tue, 19 Aug 2014 16:36:50 +0000
Message-ID: <d1447a50-c385-46ef-84d2-d013df3ab0eb@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-de9458af-816a-44c9-a7f6-eeaf50ce62fe"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-de9458af-816a-44c9-a7f6-eeaf50ce62fe
Content-Type: text/plain

commit 6068e211d2bdf481346658bec717c3ff88ff5dbe
Author: Markus Stockhausen <markus.stockhausen@collogia.de>
Date:   Tue Aug 19 16:05:47 2014 +0000

    raid6: activate rmw feature
    
    v2: Merge async patches. Default to rmw for raid6
    
    Glue it altogehter. The raid6 rmw path should work the same as the
    already existing raid5 logic. So emulate the prexor handling/flags
    and split functions as needed.
    
    1) Enable xor_syndrome() in the async layer.
    
    2) Split ops_run_prexor() into RAID4/5 and RAID6 logic. Xor the syndrome
    at the start of a rmw run as we did it before for the single parity.
    
    3) Take care of rmw run in ops_run_reconstruct6(). Again process only
    the changed pages to get syndrome back into sync.
    
    4) Enhance set_syndrome_sources() to fill NULL pages if we are in a rmw
    run. The lower layers will calculate start & end pages from that and
    call the xor_syndrome() correspondingly.
    
    5) Adapt the several places where we ignored Q handling up to now.

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index d05327c..5d355e0 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -124,6 +124,7 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 {
 	void **srcs;
 	int i;
+	int start = -1, stop = disks - 3;
 
 	if (submit->scribble)
 		srcs = submit->scribble;
@@ -134,10 +135,21 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 		if (blocks[i] == NULL) {
 			BUG_ON(i > disks - 3); /* P or Q can't be zero */
 			srcs[i] = (void*)raid6_empty_zero_page;
-		} else
+		} else {
 			srcs[i] = page_address(blocks[i]) + offset;
+			if (i < disks - 2) {
+				stop = i;
+				if (start == -1)
+					start = i;
+			}
+		}
 	}
-	raid6_call.gen_syndrome(disks, len, srcs);
+	if (submit->flags & ASYNC_TX_PQ_XOR_DST) {
+		BUG_ON(!raid6_call.xor_syndrome);
+		if (start >= 0)
+			raid6_call.xor_syndrome(disks, start, stop, len, srcs);
+	} else
+		raid6_call.gen_syndrome(disks, len, srcs);
 	async_tx_sync_epilog(submit);
 }
 
@@ -178,7 +190,8 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 	if (device)
 		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOIO);
 
-	if (unmap &&
+	/* XORing P/Q is only implemented in software */
+	if (unmap && !(submit->flags & ASYNC_TX_PQ_XOR_DST) &&
 	    (src_cnt <= dma_maxpq(device, 0) ||
 	     dma_maxpq(device, DMA_PREP_CONTINUE) > 0) &&
 	    is_dma_pq_aligned(device, offset, 0, len)) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6234b2e..eb63e31 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1159,7 +1159,9 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
  * destination buffer is recorded in srcs[count] and the Q destination
  * is recorded in srcs[count+1]].
  */
-static int set_syndrome_sources(struct page **srcs, struct stripe_head *sh)
+static int set_syndrome_sources(struct page **srcs,
+				struct stripe_head *sh,
+				int srctype)
 {
 	int disks = sh->disks;
 	int syndrome_disks = sh->ddf_layout ? disks : (disks - 2);
@@ -1174,8 +1176,15 @@ static int set_syndrome_sources(struct page **srcs, struct stripe_head *sh)
 	i = d0_idx;
 	do {
 		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
+		struct r5dev *dev = &sh->dev[i];
 
-		srcs[slot] = sh->dev[i].page;
+		if (i == sh->qd_idx || i == sh->pd_idx ||
+		    (srctype == SYNDROME_SRC_ALL) ||
+		    (srctype == SYNDROME_SRC_WANT_DRAIN &&
+		     test_bit(R5_Wantdrain, &dev->flags)) ||
+		    (srctype == SYNDROME_SRC_WRITTEN &&
+		     dev->written))
+			srcs[slot] = sh->dev[i].page;
 		i = raid6_next_disk(i, disks);
 	} while (i != d0_idx);
 
@@ -1214,7 +1223,7 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 	atomic_inc(&sh->count);
 
 	if (target == qd_idx) {
-		count = set_syndrome_sources(blocks, sh);
+		count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_ALL);
 		blocks[count] = NULL; /* regenerating p is not necessary */
 		BUG_ON(blocks[count+1] != dest); /* q should already be set */
 		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
@@ -1321,7 +1330,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE,
 				       &submit);
 
-			count = set_syndrome_sources(blocks, sh);
+			count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_ALL);
 			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
 					  ops_complete_compute, sh,
 					  to_addr_conv(sh, percpu));
@@ -1356,7 +1365,7 @@ static void ops_complete_prexor(void *stripe_head_ref)
 }
 
 static struct dma_async_tx_descriptor *
-ops_run_prexor(struct stripe_head *sh, struct raid5_percpu *percpu,
+ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	       struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
@@ -1385,6 +1394,26 @@ ops_run_prexor(struct stripe_head *sh, struct raid5_percpu *percpu,
 }
 
 static struct dma_async_tx_descriptor *
+ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu,
+               struct dma_async_tx_descriptor *tx)
+{
+	struct page **blocks = percpu->scribble;
+	int count;
+	struct async_submit_ctl submit;
+
+	pr_debug("%s: stripe %llu\n", __func__,
+		(unsigned long long)sh->sector);
+
+	count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_WANT_DRAIN);
+
+	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_PQ_XOR_DST, tx,
+		ops_complete_prexor, sh, to_addr_conv(sh, percpu));
+	tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
+
+	return tx;
+}
+
+static struct dma_async_tx_descriptor *
 ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
@@ -1548,7 +1577,8 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 {
 	struct async_submit_ctl submit;
 	struct page **blocks = percpu->scribble;
-	int count, i;
+	int count, i, synflags;
+	unsigned long txflags;
 
 	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
 
@@ -1566,11 +1596,19 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 		return;
 	}
 
-	count = set_syndrome_sources(blocks, sh);
+	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
+		synflags = SYNDROME_SRC_WRITTEN;
+		txflags = ASYNC_TX_ACK | ASYNC_TX_PQ_XOR_DST;
+	} else {
+		synflags = SYNDROME_SRC_ALL;
+		txflags = ASYNC_TX_ACK;
+	}
+
+	count = set_syndrome_sources(blocks, sh, synflags);
 
 	atomic_inc(&sh->count);
 
-	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_reconstruct,
+	init_async_submit(&submit, txflags, tx, ops_complete_reconstruct,
 			  sh, to_addr_conv(sh, percpu));
 	async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
 }
@@ -1630,7 +1668,7 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 	pr_debug("%s: stripe %llu checkp: %d\n", __func__,
 		(unsigned long long)sh->sector, checkp);
 
-	count = set_syndrome_sources(srcs, sh);
+	count = set_syndrome_sources(srcs, sh, SYNDROME_SRC_ALL);
 	if (!checkp)
 		srcs[count] = NULL;
 
@@ -1671,8 +1709,12 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 			async_tx_ack(tx);
 	}
 
-	if (test_bit(STRIPE_OP_PREXOR, &ops_request))
-		tx = ops_run_prexor(sh, percpu, tx);
+	if (test_bit(STRIPE_OP_PREXOR, &ops_request)) {
+		if (level < 6)
+			tx = ops_run_prexor5(sh, percpu, tx);
+		else
+			tx = ops_run_prexor6(sh, percpu, tx);
+	}
 
 	if (test_bit(STRIPE_OP_BIODRAIN, &ops_request)) {
 		tx = ops_run_biodrain(sh, tx);
@@ -2542,7 +2584,7 @@ static void
 schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 			 int rcw, int expand)
 {
-	int i, pd_idx = sh->pd_idx, disks = sh->disks;
+	int i, pd_idx = sh->pd_idx, qd_idx = sh->qd_idx, disks = sh->disks;
 	struct r5conf *conf = sh->raid_conf;
 	int level = conf->level;
 
@@ -2578,13 +2620,15 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 			if (!test_and_set_bit(STRIPE_FULL_WRITE, &sh->state))
 				atomic_inc(&conf->pending_full_writes);
 	} else {
-		BUG_ON(level == 6);
 		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
 			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
+		BUG_ON(level == 6 &&
+			(!(test_bit(R5_UPTODATE, &sh->dev[qd_idx].flags) ||
+                        test_bit(R5_Wantcompute, &sh->dev[qd_idx].flags))));
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (i == pd_idx)
+			if (i == pd_idx || i == qd_idx)
 				continue;
 
 			if (dev->towrite &&
@@ -3095,27 +3139,26 @@ static void handle_stripe_dirtying(struct r5conf *conf,
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
+	if (conf->rmw_level == PARITY_DISABLE_RMW ||
 	    (recovery_cp < MaxSector && sh->sector >= recovery_cp)) {
 		/* Calculate the real rcw later - for now make it
 		 * look like rcw is cheaper
 		 */
 		rcw = 1; rmw = 2;
-		pr_debug("force RCW max_degraded=%u, recovery_cp=%llu sh->sector=%llu\n",
-			 conf->max_degraded, (unsigned long long)recovery_cp,
+		pr_debug("force RCW rmw_level=%u, recovery_cp=%llu sh->sector=%llu\n",
+			 conf->rmw_level, (unsigned long long)recovery_cp,
 			 (unsigned long long)sh->sector);
 	} else for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
 		struct r5dev *dev = &sh->dev[i];
-		if ((dev->towrite || i == sh->pd_idx) &&
+		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
 		      test_bit(R5_Wantcompute, &dev->flags))) {
@@ -3125,7 +3168,8 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 				rmw += 2*disks;  /* cannot read it */
 		}
 		/* Would I have to read this buffer for reconstruct_write */
-		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
+		if (!test_bit(R5_OVERWRITE, &dev->flags) &&
+		    i != sh->pd_idx && i != sh->qd_idx &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
 		    test_bit(R5_Wantcompute, &dev->flags))) {
@@ -3138,7 +3182,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	pr_debug("for sector %llu, rmw=%d rcw=%d\n",
 		(unsigned long long)sh->sector, rmw, rcw);
 	set_bit(STRIPE_HANDLE, &sh->state);
-	if (rmw < rcw && rmw > 0) {
+	if ((rmw < rcw || (rmw == rcw && conf->rmw_level == PARITY_ENABLE_RMW)) && rmw > 0) {
 		/* prefer read-modify-write, but need to get some data */
 		if (conf->mddev->queue)
 			blk_add_trace_msg(conf->mddev->queue,
@@ -3146,7 +3190,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 					  (unsigned long long)sh->sector, rmw);
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if ((dev->towrite || i == sh->pd_idx) &&
+			if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
 			    test_bit(R5_Wantcompute, &dev->flags)) &&
@@ -3165,7 +3209,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 			}
 		}
 	}
-	if (rcw <= rmw && rcw > 0) {
+	if ((rcw < rmw || (rcw == rmw && conf->rmw_level != PARITY_ENABLE_RMW)) && rcw > 0) {
 		/* want reconstruct write, but need to get some data */
 		int qread =0;
 		rcw = 0;
@@ -5850,10 +5894,16 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	conf->chunk_sectors = mddev->new_chunk_sectors;
 	conf->level = mddev->new_level;
-	if (conf->level == 6)
+	if (conf->level == 6) {
 		conf->max_degraded = 2;
-	else
+		if (raid6_call.xor_syndrome)
+			conf->rmw_level = PARITY_ENABLE_RMW;
+		else
+			conf->rmw_level = PARITY_DISABLE_RMW;
+	} else {
 		conf->max_degraded = 1;
+		conf->rmw_level = PARITY_ENABLE_RMW;
+	}
 	conf->algorithm = mddev->new_layout;
 	conf->reshape_progress = mddev->reshape_position;
 	if (conf->reshape_progress != MaxSector) {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index bc72cd4..cbb00e2 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -340,6 +340,23 @@ enum {
 	STRIPE_OP_RECONSTRUCT,
 	STRIPE_OP_CHECK,
 };
+
+/*
+ * RAID parity calculation preferences
+ */
+enum {
+	PARITY_DISABLE_RMW = 0,
+	PARITY_ENABLE_RMW,
+};
+
+/*
+ * Pages requested from set_syndrome_sources()
+ */
+enum {
+	SYNDROME_SRC_ALL,
+	SYNDROME_SRC_WANT_DRAIN,
+	SYNDROME_SRC_WRITTEN,
+};
 /*
  * Plugging:
  *
@@ -397,7 +414,7 @@ struct r5conf {
 	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
 	struct mddev		*mddev;
 	int			chunk_sectors;
-	int			level, algorithm;
+	int			level, algorithm, rmw_level;
 	int			max_degraded;
 	int			raid_disks;
 	int			max_nr_stripes;
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 179b38f..388574e 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -60,12 +60,15 @@ struct dma_chan_ref {
  * dependency chain
  * @ASYNC_TX_FENCE: specify that the next operation in the dependency
  * chain uses this operation's result as an input
+ * @ASYNC_TX_PQ_XOR_DST: do not overwrite the syndrome but XOR it with the
+ * input data. Required for rmw case.
  */
 enum async_tx_flags {
 	ASYNC_TX_XOR_ZERO_DST	 = (1 << 0),
 	ASYNC_TX_XOR_DROP_DST	 = (1 << 1),
 	ASYNC_TX_ACK		 = (1 << 2),
 	ASYNC_TX_FENCE		 = (1 << 3),
+	ASYNC_TX_PQ_XOR_DST	 = (1 << 4),
 };
 
 /**

------=_NextPartTM-000-de9458af-816a-44c9-a7f6-eeaf50ce62fe
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-de9458af-816a-44c9-a7f6-eeaf50ce62fe--
