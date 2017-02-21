From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v4 2/7] raid5: calculate partial parity for a stripe
Date: Tue, 21 Feb 2017 20:43:56 +0100
Message-ID: <20170221194401.18733-3-artur.paszkiewicz@intel.com>
References: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Attach a page for holding the partial parity data to stripe_head.
Allocate it only if mddev has the MD_HAS_PPL flag set.

Partial parity is the xor of not modified data chunks of a stripe and is
calculated as follows:

- reconstruct-write case:
  xor data from all not updated disks in a stripe

- read-modify-write case:
  xor old data and parity from all updated disks in a stripe

Implement it using the async_tx API and integrate into raid_run_ops().
It must be called when we still have access to old data, so do it when
STRIPE_OP_BIODRAIN is set, but before ops_run_prexor5(). The result is
stored into sh->ppl_page.

Partial parity is not meaningful for full stripe write and is not stored
in the log or used for recovery, so don't attempt to calculate it when
stripe has STRIPE_FULL_WRITE.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.h |   3 ++
 2 files changed, 103 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7b7722bb2e8d..02e02fe5b04e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -463,6 +463,11 @@ static void shrink_buffers(struct stripe_head *sh)
 		sh->dev[i].page = NULL;
 		put_page(p);
 	}
+
+	if (sh->ppl_page) {
+		put_page(sh->ppl_page);
+		sh->ppl_page = NULL;
+	}
 }
 
 static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
@@ -479,6 +484,13 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
 		sh->dev[i].page = page;
 		sh->dev[i].orig_page = page;
 	}
+
+	if (test_bit(MD_HAS_PPL, &sh->raid_conf->mddev->flags)) {
+		sh->ppl_page = alloc_page(gfp);
+		if (!sh->ppl_page)
+			return 1;
+	}
+
 	return 0;
 }
 
@@ -1974,6 +1986,55 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
 }
 
+static struct dma_async_tx_descriptor *
+ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
+		       struct dma_async_tx_descriptor *tx)
+{
+	int disks = sh->disks;
+	struct page **xor_srcs = flex_array_get(percpu->scribble, 0);
+	int count = 0, pd_idx = sh->pd_idx, i;
+	struct async_submit_ctl submit;
+
+	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
+
+	/*
+	 * Partial parity is the XOR of stripe data chunks that are not changed
+	 * during the write request. Depending on available data
+	 * (read-modify-write vs. reconstruct-write case) we calculate it
+	 * differently.
+	 */
+	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
+		/* rmw: xor old data and parity from updated disks */
+		for (i = disks; i--;) {
+			struct r5dev *dev = &sh->dev[i];
+			if (test_bit(R5_Wantdrain, &dev->flags) || i == pd_idx)
+				xor_srcs[count++] = dev->page;
+		}
+	} else if (sh->reconstruct_state == reconstruct_state_drain_run) {
+		/* rcw: xor data from all not updated disks */
+		for (i = disks; i--;) {
+			struct r5dev *dev = &sh->dev[i];
+			if (test_bit(R5_UPTODATE, &dev->flags))
+				xor_srcs[count++] = dev->page;
+		}
+	} else {
+		return tx;
+	}
+
+	init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, tx, NULL, sh,
+			  flex_array_get(percpu->scribble, 0)
+			  + sizeof(struct page *) * (sh->disks + 2));
+
+	if (count == 1)
+		tx = async_memcpy(sh->ppl_page, xor_srcs[0], 0, 0, PAGE_SIZE,
+				  &submit);
+	else
+		tx = async_xor(sh->ppl_page, xor_srcs, 0, count, PAGE_SIZE,
+			       &submit);
+
+	return tx;
+}
+
 static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 {
 	int overlap_clear = 0, i, disks = sh->disks;
@@ -2004,6 +2065,9 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 			async_tx_ack(tx);
 	}
 
+	if (test_bit(STRIPE_OP_PARTIAL_PARITY, &ops_request))
+		tx = ops_run_partial_parity(sh, percpu, tx);
+
 	if (test_bit(STRIPE_OP_PREXOR, &ops_request)) {
 		if (level < 6)
 			tx = ops_run_prexor5(sh, percpu, tx);
@@ -3079,6 +3143,12 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 		s->locked++;
 	}
 
+	if (level == 5 && sh->ppl_page &&
+	    test_bit(STRIPE_OP_BIODRAIN, &s->ops_request) &&
+	    !test_bit(STRIPE_FULL_WRITE, &sh->state) &&
+	    test_bit(R5_Insync, &sh->dev[pd_idx].flags))
+		set_bit(STRIPE_OP_PARTIAL_PARITY, &s->ops_request);
+
 	pr_debug("%s: stripe %llu locked: %d ops_request: %lx\n",
 		__func__, (unsigned long long)sh->sector,
 		s->locked, s->ops_request);
@@ -3126,6 +3196,36 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 	if (*bip && (*bip)->bi_iter.bi_sector < bio_end_sector(bi))
 		goto overlap;
 
+	if (forwrite && sh->ppl_page) {
+		/*
+		 * With PPL only writes to consecutive data chunks within a
+		 * stripe are allowed because for a single stripe_head we can
+		 * only have one PPL entry at a time, which describes one data
+		 * range. Not really an overlap, but wait_for_overlap can be
+		 * used to handle this.
+		 */
+		sector_t sector;
+		sector_t first = 0;
+		sector_t last = 0;
+		int count = 0;
+		int i;
+
+		for (i = 0; i < sh->disks; i++) {
+			if (i != sh->pd_idx &&
+			    (i == dd_idx || sh->dev[i].towrite)) {
+				sector = sh->dev[i].sector;
+				if (count == 0 || sector < first)
+					first = sector;
+				if (sector > last)
+					last = sector;
+				count++;
+			}
+		}
+
+		if (first + conf->chunk_sectors * (count - 1) != last)
+			goto overlap;
+	}
+
 	if (!forwrite || previous)
 		clear_bit(STRIPE_BATCH_READY, &sh->state);
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 4bb27b97bf6b..3cc4cb28f7e6 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -228,6 +228,8 @@ struct stripe_head {
 	struct list_head	log_list;
 	sector_t		log_start; /* first meta block on the journal */
 	struct list_head	r5c; /* for r5c_cache->stripe_in_journal */
+
+	struct page		*ppl_page; /* partial parity of this stripe */
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -400,6 +402,7 @@ enum {
 	STRIPE_OP_BIODRAIN,
 	STRIPE_OP_RECONSTRUCT,
 	STRIPE_OP_CHECK,
+	STRIPE_OP_PARTIAL_PARITY,
 };
 
 /*
-- 
2.11.0

