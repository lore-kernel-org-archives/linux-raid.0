From: Shaohua Li <shli@kernel.org>
Subject: [patch 1/2]RAID5: make stripe size configurable
Date: Tue, 8 Jul 2014 09:00:18 +0800
Message-ID: <20140708010018.GA8941@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


stripe size is 4k default. Bigger stripe size is considered harmful, because if
IO size is small, big stripe size can cause a lot of unnecessary IO/parity
calculation. But if upper layer always sends full stripe write to RAID5 array,
this drawback goes away. And bigger stripe size can improve performance
actually in this case because of bigger size IO and less stripes to handle. In
my full stripe write test case, 16k stripe size can improve throughput 40% -
120% depending on RAID5 configuration.

Signed-off-by: Shaohua Li<shli@fusionio.com>
---
 drivers/md/raid5.c |  683 +++++++++++++++++++++++++++++++++++------------------
 drivers/md/raid5.h |    6 
 2 files changed, 456 insertions(+), 233 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-07-08 08:47:57.092178441 +0800
+++ linux/drivers/md/raid5.c	2014-07-08 08:47:57.080178591 +0800
@@ -70,9 +70,10 @@ static struct workqueue_struct *raid5_wq
  */
 
 #define NR_STRIPES		256
-#define STRIPE_SIZE		PAGE_SIZE
-#define STRIPE_SHIFT		(PAGE_SHIFT - 9)
-#define STRIPE_SECTORS		(STRIPE_SIZE>>9)
+#define STRIPE_SIZE(conf)	(PAGE_SIZE << conf->stripe_size_order)
+#define STRIPE_SHIFT(conf)	(PAGE_SHIFT - 9 + conf->stripe_size_order)
+#define STRIPE_SECTORS(conf)	(STRIPE_SIZE(conf) >> 9)
+#define STRIPE_PAGES(conf)	(1 << conf->stripe_size_order)
 #define	IO_THRESHOLD		1
 #define BYPASS_THRESHOLD	1
 #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
@@ -81,13 +82,13 @@ static struct workqueue_struct *raid5_wq
 
 static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
 {
-	int hash = (sect >> STRIPE_SHIFT) & HASH_MASK;
+	int hash = (sect >> STRIPE_SHIFT(conf)) & HASH_MASK;
 	return &conf->stripe_hashtbl[hash];
 }
 
-static inline int stripe_hash_locks_hash(sector_t sect)
+static inline int stripe_hash_locks_hash(struct r5conf *conf, sector_t sect)
 {
-	return (sect >> STRIPE_SHIFT) & STRIPE_HASH_LOCKS_MASK;
+	return (sect >> STRIPE_SHIFT(conf)) & STRIPE_HASH_LOCKS_MASK;
 }
 
 static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
@@ -130,10 +131,10 @@ static inline void unlock_all_device_has
  * This function is used to determine the 'next' bio in the list, given the sector
  * of the current stripe+device
  */
-static inline struct bio *r5_next_bio(struct bio *bio, sector_t sector)
+static inline struct bio *r5_next_bio(struct r5conf *conf, struct bio *bio, sector_t sector)
 {
 	int sectors = bio_sectors(bio);
-	if (bio->bi_iter.bi_sector + sectors < sector + STRIPE_SECTORS)
+	if (bio->bi_iter.bi_sector + sectors < sector + STRIPE_SECTORS(conf))
 		return bio->bi_next;
 	else
 		return NULL;
@@ -487,32 +488,44 @@ static void shrink_buffers(struct stripe
 	int num = sh->raid_conf->pool_size;
 
 	for (i = 0; i < num ; i++) {
-		WARN_ON(sh->dev[i].page != sh->dev[i].orig_page);
-		p = sh->dev[i].page;
+		WARN_ON(sh->dev[i].pages[0] != sh->dev[i].orig_page);
+		p = sh->dev[i].orig_page;
 		if (!p)
 			continue;
-		sh->dev[i].page = NULL;
-		put_page(p);
+		__free_pages(p, sh->raid_conf->stripe_size_order);
+		sh->dev[i].pages = NULL;
+		sh->dev[i].orig_page = NULL;
 	}
 }
 
 static int grow_buffers(struct stripe_head *sh)
 {
-	int i;
+	int i, j;
 	int num = sh->raid_conf->pool_size;
 
 	for (i = 0; i < num; i++) {
 		struct page *page;
 
-		if (!(page = alloc_page(GFP_KERNEL))) {
+		if (!(page = alloc_pages(GFP_KERNEL,
+		    sh->raid_conf->stripe_size_order))) {
 			return 1;
 		}
-		sh->dev[i].page = page;
+		for (j = 0; j < STRIPE_PAGES(sh->raid_conf); j++)
+			sh->dev[i].pages[j] = page + j;
 		sh->dev[i].orig_page = page;
 	}
 	return 0;
 }
 
+static void reset_stripe_devpage(struct stripe_head *sh, int i)
+{
+	struct r5conf *conf = sh->raid_conf;
+	int j;
+
+	for (j = 0; j < STRIPE_PAGES(conf); j++)
+		sh->dev[i].pages[j] = sh->dev[i].orig_page + j;
+}
+
 static void raid5_build_block(struct stripe_head *sh, int i, int previous);
 static void stripe_set_idx(sector_t stripe, struct r5conf *conf, int previous,
 			    struct stripe_head *sh);
@@ -659,7 +672,7 @@ get_active_stripe(struct r5conf *conf, s
 		  int previous, int noblock, int noquiesce)
 {
 	struct stripe_head *sh;
-	int hash = stripe_hash_locks_hash(sector);
+	int hash = stripe_hash_locks_hash(conf, sector);
 
 	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
 
@@ -740,7 +753,7 @@ raid5_end_write_request(struct bio *bi,
 static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 {
 	struct r5conf *conf = sh->raid_conf;
-	int i, disks = sh->disks;
+	int i, disks = sh->disks, j;
 
 	might_sleep();
 
@@ -808,7 +821,7 @@ static void ops_run_io(struct stripe_hea
 		       test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
 			int bad_sectors;
-			int bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS,
+			int bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS(conf),
 					      &first_bad, &bad_sectors);
 			if (!bad)
 				break;
@@ -840,7 +853,7 @@ static void ops_run_io(struct stripe_hea
 		if (rdev) {
 			if (s->syncing || s->expanding || s->expanded
 			    || s->replacing)
-				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
+				md_sync_acct(rdev->bdev, STRIPE_SECTORS(conf));
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
@@ -867,11 +880,12 @@ static void ops_run_io(struct stripe_hea
 
 			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
 				WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
-			sh->dev[i].vec.bv_page = sh->dev[i].page;
-			bi->bi_vcnt = 1;
-			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
-			bi->bi_io_vec[0].bv_offset = 0;
-			bi->bi_iter.bi_size = STRIPE_SIZE;
+
+			bi->bi_max_vecs = 1 << conf->stripe_size_order;
+			bi->bi_io_vec = sh->dev[i].vecs;
+
+			for (j = 0; j < STRIPE_PAGES(conf); j++)
+				bio_add_page(bi, sh->dev[i].pages[j], PAGE_SIZE, 0);
 			/*
 			 * If this is discard request, set bi_vcnt 0. We don't
 			 * want to confuse SCSI because SCSI will replace payload
@@ -890,7 +904,7 @@ static void ops_run_io(struct stripe_hea
 		if (rrdev) {
 			if (s->syncing || s->expanding || s->expanded
 			    || s->replacing)
-				md_sync_acct(rrdev->bdev, STRIPE_SECTORS);
+				md_sync_acct(rrdev->bdev, STRIPE_SECTORS(conf));
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
@@ -914,11 +928,12 @@ static void ops_run_io(struct stripe_hea
 						  + rrdev->data_offset);
 			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
 				WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
-			sh->dev[i].rvec.bv_page = sh->dev[i].page;
-			rbi->bi_vcnt = 1;
-			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
-			rbi->bi_io_vec[0].bv_offset = 0;
-			rbi->bi_iter.bi_size = STRIPE_SIZE;
+
+			rbi->bi_max_vecs = 1 << conf->stripe_size_order;
+			rbi->bi_io_vec = sh->dev[i].rvecs;
+
+			for (j = 0; j < STRIPE_PAGES(conf); j++)
+				bio_add_page(rbi, sh->dev[i].pages[j], PAGE_SIZE, 0);
 			/*
 			 * If this is discard request, set bi_vcnt 0. We don't
 			 * want to confuse SCSI because SCSI will replace payload
@@ -943,7 +958,7 @@ static void ops_run_io(struct stripe_hea
 }
 
 static struct dma_async_tx_descriptor *
-async_copy_data(int frombio, struct bio *bio, struct page **page,
+async_copy_one_page(int frombio, struct bio *bio, struct page **page,
 	sector_t sector, struct dma_async_tx_descriptor *tx,
 	struct stripe_head *sh)
 {
@@ -974,8 +989,8 @@ async_copy_data(int frombio, struct bio
 			len -= b_offset;
 		}
 
-		if (len > 0 && page_offset + len > STRIPE_SIZE)
-			clen = STRIPE_SIZE - page_offset;
+		if (len > 0 && page_offset + len > PAGE_SIZE)
+			clen = PAGE_SIZE - page_offset;
 		else
 			clen = len;
 
@@ -985,7 +1000,7 @@ async_copy_data(int frombio, struct bio
 			if (frombio) {
 				if (sh->raid_conf->skip_copy &&
 				    b_offset == 0 && page_offset == 0 &&
-				    clen == STRIPE_SIZE)
+				    clen == PAGE_SIZE)
 					*page = bio_page;
 				else
 					tx = async_memcpy(*page, bio_page, page_offset,
@@ -997,14 +1012,42 @@ async_copy_data(int frombio, struct bio
 		/* chain the operations */
 		submit.depend_tx = tx;
 
-		if (clen < len) /* hit end of page */
-			break;
 		page_offset +=  len;
+		/* hit end of page */
+		if (page_offset > 0 && (page_offset % PAGE_SIZE) == 0)
+			break;
 	}
 
 	return tx;
 }
 
+static struct dma_async_tx_descriptor *
+async_copy_data(int frombio, struct bio *bio, struct page **pages,
+	sector_t sector, struct dma_async_tx_descriptor *tx,
+	struct stripe_head *sh, int *skip_copy)
+{
+	sector_t offset;
+	struct page **cur_page, *tmp;
+
+	*skip_copy = 0;
+	if (sector > bio->bi_iter.bi_sector)
+		offset = sector;
+	else {
+		offset = bio->bi_iter.bi_sector >> 3;
+		offset <<= 3;
+	}
+	while (offset < bio_end_sector(bio) &&
+	       offset < sector + STRIPE_SECTORS(sh->raid_conf)) {
+		cur_page = &pages[(offset - sector) >> 3];
+		tmp = *cur_page;
+		tx = async_copy_one_page(frombio, bio, cur_page, offset, tx, sh);
+		if (tmp != *cur_page)
+			*skip_copy = 1;
+		offset += PAGE_SIZE >> 9;
+	}
+	return tx;
+}
+
 static void ops_complete_biofill(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
@@ -1030,8 +1073,8 @@ static void ops_complete_biofill(void *s
 			rbi = dev->read;
 			dev->read = NULL;
 			while (rbi && rbi->bi_iter.bi_sector <
-				dev->sector + STRIPE_SECTORS) {
-				rbi2 = r5_next_bio(rbi, dev->sector);
+				dev->sector + STRIPE_SECTORS(sh->raid_conf)) {
+				rbi2 = r5_next_bio(sh->raid_conf, rbi, dev->sector);
 				if (!raid5_dec_bi_active_stripes(rbi)) {
 					rbi->bi_next = return_bi;
 					return_bi = rbi;
@@ -1052,7 +1095,7 @@ static void ops_run_biofill(struct strip
 {
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct async_submit_ctl submit;
-	int i;
+	int i, dummy;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
@@ -1066,10 +1109,10 @@ static void ops_run_biofill(struct strip
 			dev->toread = NULL;
 			spin_unlock_irq(&sh->stripe_lock);
 			while (rbi && rbi->bi_iter.bi_sector <
-				dev->sector + STRIPE_SECTORS) {
-				tx = async_copy_data(0, rbi, &dev->page,
-					dev->sector, tx, sh);
-				rbi = r5_next_bio(rbi, dev->sector);
+				dev->sector + STRIPE_SECTORS(sh->raid_conf)) {
+				tx = async_copy_data(0, rbi, dev->pages,
+					dev->sector, tx, sh, &dummy);
+				rbi = r5_next_bio(sh->raid_conf, rbi, dev->sector);
 			}
 		}
 	}
@@ -1112,40 +1155,64 @@ static void ops_complete_compute(void *s
 
 /* return a pointer to the address conversion region of the scribble buffer */
 static addr_conv_t *to_addr_conv(struct stripe_head *sh,
-				 struct raid5_percpu *percpu)
+				 struct raid5_percpu *percpu, int page_index)
 {
-	return percpu->scribble + sizeof(struct page *) * (sh->disks + 2);
+
+	return percpu->scribble + sizeof(struct page *) * (sh->disks + 2) +
+		page_index * (sh->raid_conf->scribble_len /
+		STRIPE_PAGES(sh->raid_conf));
+}
+
+static struct page **to_scribble_page(struct stripe_head *sh,
+				struct raid5_percpu *percpu, int page_index)
+{
+	return percpu->scribble + page_index * (sh->raid_conf->scribble_len /
+		STRIPE_PAGES(sh->raid_conf));
 }
 
 static struct dma_async_tx_descriptor *
 ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
-	struct page **xor_srcs = percpu->scribble;
+	struct page **xor_srcs;
 	int target = sh->ops.target;
 	struct r5dev *tgt = &sh->dev[target];
-	struct page *xor_dest = tgt->page;
-	int count = 0;
-	struct dma_async_tx_descriptor *tx;
+	struct page *xor_dest;
+	int count;
+	struct dma_async_tx_descriptor *tx = NULL;
 	struct async_submit_ctl submit;
-	int i;
+	int i, j = 0;
 
 	pr_debug("%s: stripe %llu block: %d\n",
 		__func__, (unsigned long long)sh->sector, target);
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 
+again:
+	count = 0;
+	xor_srcs = to_scribble_page(sh, percpu, j);
+	xor_dest = tgt->pages[j];
+
 	for (i = disks; i--; )
 		if (i != target)
-			xor_srcs[count++] = sh->dev[i].page;
+			xor_srcs[count++] = sh->dev[i].pages[j];
 
-	atomic_inc(&sh->count);
+	if (j == STRIPE_PAGES(sh->raid_conf) - 1) {
+		atomic_inc(&sh->count);
+
+		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, tx,
+			ops_complete_compute, sh, to_addr_conv(sh, percpu, j));
+	} else
+		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, tx,
+				  NULL, NULL, to_addr_conv(sh, percpu, j));
 
-	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
-			  ops_complete_compute, sh, to_addr_conv(sh, percpu));
 	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
+		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, PAGE_SIZE, &submit);
 	else
-		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
+		tx = async_xor(xor_dest, xor_srcs, 0, count, PAGE_SIZE, &submit);
+
+	j++;
+	if (j < STRIPE_PAGES(sh->raid_conf))
+		goto again;
 
 	return tx;
 }
@@ -1159,7 +1226,8 @@ ops_run_compute5(struct stripe_head *sh,
  * destination buffer is recorded in srcs[count] and the Q destination
  * is recorded in srcs[count+1]].
  */
-static int set_syndrome_sources(struct page **srcs, struct stripe_head *sh)
+static int set_syndrome_sources(struct page **srcs, struct stripe_head *sh,
+	int page_index)
 {
 	int disks = sh->disks;
 	int syndrome_disks = sh->ddf_layout ? disks : (disks - 2);
@@ -1175,7 +1243,7 @@ static int set_syndrome_sources(struct p
 	do {
 		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
 
-		srcs[slot] = sh->dev[i].page;
+		srcs[slot] = sh->dev[i].pages[page_index];
 		i = raid6_next_disk(i, disks);
 	} while (i != d0_idx);
 
@@ -1186,14 +1254,14 @@ static struct dma_async_tx_descriptor *
 ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
-	struct page **blocks = percpu->scribble;
+	struct page **blocks;
 	int target;
 	int qd_idx = sh->qd_idx;
-	struct dma_async_tx_descriptor *tx;
+	struct dma_async_tx_descriptor *tx = NULL;
 	struct async_submit_ctl submit;
 	struct r5dev *tgt;
 	struct page *dest;
-	int i;
+	int i, j = 0;
 	int count;
 
 	if (sh->ops.target < 0)
@@ -1209,40 +1277,57 @@ ops_run_compute6_1(struct stripe_head *s
 
 	tgt = &sh->dev[target];
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
-	dest = tgt->page;
 
-	atomic_inc(&sh->count);
+again:
+	dest = tgt->pages[j];
+	blocks = to_scribble_page(sh, percpu, j);
+
+	if (j == STRIPE_PAGES(sh->raid_conf) - 1)
+		atomic_inc(&sh->count);
 
 	if (target == qd_idx) {
-		count = set_syndrome_sources(blocks, sh);
+		count = set_syndrome_sources(blocks, sh, j);
 		blocks[count] = NULL; /* regenerating p is not necessary */
 		BUG_ON(blocks[count+1] != dest); /* q should already be set */
-		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
-				  ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu));
-		tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);
+
+		if (j == STRIPE_PAGES(sh->raid_conf) - 1)
+			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
+ 				  ops_complete_compute, sh,
+				  to_addr_conv(sh, percpu, j));
+		else
+			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
+				  NULL, NULL, to_addr_conv(sh, percpu, j));
+		tx = async_gen_syndrome(blocks, 0, count+2, PAGE_SIZE, &submit);
 	} else {
 		/* Compute any data- or p-drive using XOR */
 		count = 0;
 		for (i = disks; i-- ; ) {
 			if (i == target || i == qd_idx)
 				continue;
-			blocks[count++] = sh->dev[i].page;
+			blocks[count++] = sh->dev[i].pages[j];
 		}
 
-		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
-				  NULL, ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu));
-		tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE, &submit);
+		if (j == STRIPE_PAGES(sh->raid_conf) - 1)
+			init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
+				  tx, ops_complete_compute, sh,
+				  to_addr_conv(sh, percpu, j));
+		else
+			init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
+				  tx, NULL, NULL,
+				  to_addr_conv(sh, percpu, j));
+		tx = async_xor(dest, blocks, 0, count, PAGE_SIZE, &submit);
 	}
 
+	j++;
+	if (j < STRIPE_PAGES(sh->raid_conf))
+		goto again;
 	return tx;
 }
 
 static struct dma_async_tx_descriptor *
 ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
-	int i, count, disks = sh->disks;
+	int i, count, disks = sh->disks, j = 0;
 	int syndrome_disks = sh->ddf_layout ? disks : disks-2;
 	int d0_idx = raid6_d0(sh);
 	int faila = -1, failb = -1;
@@ -1250,8 +1335,8 @@ ops_run_compute6_2(struct stripe_head *s
 	int target2 = sh->ops.target2;
 	struct r5dev *tgt = &sh->dev[target];
 	struct r5dev *tgt2 = &sh->dev[target2];
-	struct dma_async_tx_descriptor *tx;
-	struct page **blocks = percpu->scribble;
+	struct dma_async_tx_descriptor *tx = NULL;
+	struct page **blocks;
 	struct async_submit_ctl submit;
 
 	pr_debug("%s: stripe %llu block1: %d block2: %d\n",
@@ -1260,6 +1345,8 @@ ops_run_compute6_2(struct stripe_head *s
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt2->flags));
 
+again:
+	blocks = to_scribble_page(sh, percpu, j);
 	/* we need to open-code set_syndrome_sources to handle the
 	 * slot number conversion for 'faila' and 'failb'
 	 */
@@ -1270,7 +1357,7 @@ ops_run_compute6_2(struct stripe_head *s
 	do {
 		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
 
-		blocks[slot] = sh->dev[i].page;
+		blocks[slot] = sh->dev[i].pages[j];
 
 		if (i == target)
 			faila = slot;
@@ -1285,17 +1372,23 @@ ops_run_compute6_2(struct stripe_head *s
 	pr_debug("%s: stripe: %llu faila: %d failb: %d\n",
 		 __func__, (unsigned long long)sh->sector, faila, failb);
 
-	atomic_inc(&sh->count);
+	if (j == STRIPE_PAGES(sh->raid_conf) - 1)
+		atomic_inc(&sh->count);
 
 	if (failb == syndrome_disks+1) {
 		/* Q disk is one of the missing disks */
 		if (faila == syndrome_disks) {
 			/* Missing P+Q, just recompute */
-			init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
+			if (j == STRIPE_PAGES(sh->raid_conf) - 1)
+				init_async_submit(&submit, ASYNC_TX_FENCE, tx,
 					  ops_complete_compute, sh,
-					  to_addr_conv(sh, percpu));
-			return async_gen_syndrome(blocks, 0, syndrome_disks+2,
-						  STRIPE_SIZE, &submit);
+					  to_addr_conv(sh, percpu, j));
+			else
+				init_async_submit(&submit, ASYNC_TX_FENCE, tx,
+					  NULL, NULL,
+					  to_addr_conv(sh, percpu, j));
+			tx = async_gen_syndrome(blocks, 0, syndrome_disks+2,
+						  PAGE_SIZE, &submit);
 		} else {
 			struct page *dest;
 			int data_target;
@@ -1311,39 +1404,55 @@ ops_run_compute6_2(struct stripe_head *s
 			for (i = disks; i-- ; ) {
 				if (i == data_target || i == qd_idx)
 					continue;
-				blocks[count++] = sh->dev[i].page;
+				blocks[count++] = sh->dev[i].pages[j];
 			}
-			dest = sh->dev[data_target].page;
+			dest = sh->dev[data_target].pages[j];
 			init_async_submit(&submit,
 					  ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
-					  NULL, NULL, NULL,
-					  to_addr_conv(sh, percpu));
-			tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE,
+					  tx, NULL, NULL,
+					  to_addr_conv(sh, percpu, j));
+			tx = async_xor(dest, blocks, 0, count, PAGE_SIZE,
 				       &submit);
 
-			count = set_syndrome_sources(blocks, sh);
-			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
+			count = set_syndrome_sources(blocks, sh, j);
+			if (j == STRIPE_PAGES(sh->raid_conf) - 1)
+				init_async_submit(&submit, ASYNC_TX_FENCE, tx,
 					  ops_complete_compute, sh,
-					  to_addr_conv(sh, percpu));
-			return async_gen_syndrome(blocks, 0, count+2,
-						  STRIPE_SIZE, &submit);
+					  to_addr_conv(sh, percpu, j));
+			else
+				init_async_submit(&submit, ASYNC_TX_FENCE, tx,
+					  NULL, NULL,
+					  to_addr_conv(sh, percpu, j));
+			tx = async_gen_syndrome(blocks, 0, count+2,
+						  PAGE_SIZE, &submit);
 		}
 	} else {
-		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
+		if (j == STRIPE_PAGES(sh->raid_conf) - 1)
+			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
 				  ops_complete_compute, sh,
-				  to_addr_conv(sh, percpu));
+				  to_addr_conv(sh, percpu, j));
+		else
+			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
+				  NULL, NULL, to_addr_conv(sh, percpu, j));
+
 		if (failb == syndrome_disks) {
 			/* We're missing D+P. */
-			return async_raid6_datap_recov(syndrome_disks+2,
-						       STRIPE_SIZE, faila,
+			tx = async_raid6_datap_recov(syndrome_disks+2,
+						       PAGE_SIZE, faila,
 						       blocks, &submit);
 		} else {
 			/* We're missing D+D. */
-			return async_raid6_2data_recov(syndrome_disks+2,
-						       STRIPE_SIZE, faila, failb,
+			tx = async_raid6_2data_recov(syndrome_disks+2,
+						       PAGE_SIZE, faila, failb,
 						       blocks, &submit);
 		}
 	}
+
+	j++;
+	if (j < STRIPE_PAGES(sh->raid_conf))
+		goto again;
+
+	return tx;
 }
 
 
@@ -1360,26 +1469,40 @@ ops_run_prexor(struct stripe_head *sh, s
 	       struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
-	struct page **xor_srcs = percpu->scribble;
-	int count = 0, pd_idx = sh->pd_idx, i;
+	struct page **xor_srcs;
+	int count, pd_idx = sh->pd_idx, i, j = 0;
 	struct async_submit_ctl submit;
 
 	/* existing parity data subtracted */
-	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
+	struct page *xor_dest;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+again:
+	count = 0;
+	xor_srcs = to_scribble_page(sh, percpu, j);
+	/* existing parity data subtracted */
+	xor_dest = xor_srcs[count++] = sh->dev[pd_idx].pages[j];
+
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Only process blocks that are known to be uptodate */
 		if (test_bit(R5_Wantdrain, &dev->flags))
-			xor_srcs[count++] = dev->page;
+			xor_srcs[count++] = dev->pages[j];
 	}
 
-	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
-			  ops_complete_prexor, sh, to_addr_conv(sh, percpu));
-	tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
+	if (j == STRIPE_PAGES(sh->raid_conf) - 1)
+		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
+			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, j));
+	else
+		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
+			  NULL, NULL, to_addr_conv(sh, percpu, j));
+	tx = async_xor(xor_dest, xor_srcs, 0, count, PAGE_SIZE, &submit);
+
+	j++;
+	if (j < STRIPE_PAGES(sh->raid_conf))
+		goto again;
 
 	return tx;
 }
@@ -1406,10 +1529,10 @@ ops_run_biodrain(struct stripe_head *sh,
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
 			spin_unlock_irq(&sh->stripe_lock);
-			WARN_ON(dev->page != dev->orig_page);
+			WARN_ON(dev->pages[0] != dev->orig_page);
 
 			while (wbi && wbi->bi_iter.bi_sector <
-				dev->sector + STRIPE_SECTORS) {
+				dev->sector + STRIPE_SECTORS(sh->raid_conf)) {
 				if (wbi->bi_rw & REQ_FUA)
 					set_bit(R5_WantFUA, &dev->flags);
 				if (wbi->bi_rw & REQ_SYNC)
@@ -1417,15 +1540,16 @@ ops_run_biodrain(struct stripe_head *sh,
 				if (wbi->bi_rw & REQ_DISCARD)
 					set_bit(R5_Discard, &dev->flags);
 				else {
-					tx = async_copy_data(1, wbi, &dev->page,
-						dev->sector, tx, sh);
-					if (dev->page != dev->orig_page) {
+					int skip_copy;
+					tx = async_copy_data(1, wbi, dev->pages,
+						dev->sector, tx, sh, &skip_copy);
+					if (skip_copy) {
 						set_bit(R5_SkipCopy, &dev->flags);
 						clear_bit(R5_UPTODATE, &dev->flags);
 						clear_bit(R5_OVERWRITE, &dev->flags);
 					}
 				}
-				wbi = r5_next_bio(wbi, dev->sector);
+				wbi = r5_next_bio(sh->raid_conf, wbi, dev->sector);
 			}
 		}
 	}
@@ -1482,9 +1606,9 @@ ops_run_reconstruct5(struct stripe_head
 		     struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
-	struct page **xor_srcs = percpu->scribble;
+	struct page **xor_srcs;
 	struct async_submit_ctl submit;
-	int count = 0, pd_idx = sh->pd_idx, i;
+	int count, pd_idx = sh->pd_idx, i, j = 0;
 	struct page *xor_dest;
 	int prexor = 0;
 	unsigned long flags;
@@ -1504,23 +1628,27 @@ ops_run_reconstruct5(struct stripe_head
 		ops_complete_reconstruct(sh);
 		return;
 	}
+
+again:
+	count = 0;
+	xor_srcs = to_scribble_page(sh, percpu, j);
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (written)
 	 */
 	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
 		prexor = 1;
-		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
+		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].pages[j];
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (dev->written)
-				xor_srcs[count++] = dev->page;
+				xor_srcs[count++] = dev->pages[j];
 		}
 	} else {
-		xor_dest = sh->dev[pd_idx].page;
+		xor_dest = sh->dev[pd_idx].pages[j];
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (i != pd_idx)
-				xor_srcs[count++] = dev->page;
+				xor_srcs[count++] = dev->pages[j];
 		}
 	}
 
@@ -1529,17 +1657,28 @@ ops_run_reconstruct5(struct stripe_head
 	 * set ASYNC_TX_XOR_DROP_DST and ASYNC_TX_XOR_ZERO_DST
 	 * for the synchronous xor case
 	 */
-	flags = ASYNC_TX_ACK |
-		(prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST);
+	if (j == STRIPE_PAGES(sh->raid_conf) - 1) {
+		flags = ASYNC_TX_ACK |
+			(prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST);
 
-	atomic_inc(&sh->count);
+		atomic_inc(&sh->count);
+
+		init_async_submit(&submit, flags, tx, ops_complete_reconstruct, sh,
+			  to_addr_conv(sh, percpu, j));
+	} else {
+		flags = prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST;
+		init_async_submit(&submit, flags, tx, NULL, NULL,
+			  to_addr_conv(sh, percpu, j));
+	}
 
-	init_async_submit(&submit, flags, tx, ops_complete_reconstruct, sh,
-			  to_addr_conv(sh, percpu));
 	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
+		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, PAGE_SIZE, &submit);
 	else
-		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
+		tx = async_xor(xor_dest, xor_srcs, 0, count, PAGE_SIZE, &submit);
+
+	j++;
+	if (j < STRIPE_PAGES(sh->raid_conf))
+		goto again;
 }
 
 static void
@@ -1547,8 +1686,8 @@ ops_run_reconstruct6(struct stripe_head
 		     struct dma_async_tx_descriptor *tx)
 {
 	struct async_submit_ctl submit;
-	struct page **blocks = percpu->scribble;
-	int count, i;
+	struct page **blocks;
+	int count, i, j = 0;
 
 	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
 
@@ -1566,22 +1705,38 @@ ops_run_reconstruct6(struct stripe_head
 		return;
 	}
 
-	count = set_syndrome_sources(blocks, sh);
+again:
+	blocks = to_scribble_page(sh, percpu, j);
 
-	atomic_inc(&sh->count);
+	count = set_syndrome_sources(blocks, sh, j);
 
-	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_reconstruct,
-			  sh, to_addr_conv(sh, percpu));
-	async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
+	if (j == STRIPE_PAGES(sh->raid_conf) - 1) {
+		atomic_inc(&sh->count);
+
+		init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_reconstruct,
+			  sh, to_addr_conv(sh, percpu, j));
+	} else
+		init_async_submit(&submit, 0, tx, NULL,
+			  NULL, to_addr_conv(sh, percpu, j));
+	tx = async_gen_syndrome(blocks, 0, count+2, PAGE_SIZE,  &submit);
+
+	j++;
+	if (j < STRIPE_PAGES(sh->raid_conf))
+		goto again;
 }
 
 static void ops_complete_check(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
+	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+	sh->ops.zero_sum_result = 0;
+	for (i = 0; i < STRIPE_PAGES(sh->raid_conf); i++)
+		sh->ops.zero_sum_result |= sh->ops.sum_results[i];
+
 	sh->check_state = check_state_check_result;
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
@@ -1593,28 +1748,34 @@ static void ops_run_check_p(struct strip
 	int pd_idx = sh->pd_idx;
 	int qd_idx = sh->qd_idx;
 	struct page *xor_dest;
-	struct page **xor_srcs = percpu->scribble;
-	struct dma_async_tx_descriptor *tx;
+	struct page **xor_srcs;
+	struct dma_async_tx_descriptor *tx = NULL;
 	struct async_submit_ctl submit;
 	int count;
-	int i;
+	int i, j = 0;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+again:
+	xor_srcs = to_scribble_page(sh, percpu, j);
 	count = 0;
-	xor_dest = sh->dev[pd_idx].page;
+	xor_dest = sh->dev[pd_idx].pages[j];
 	xor_srcs[count++] = xor_dest;
 	for (i = disks; i--; ) {
 		if (i == pd_idx || i == qd_idx)
 			continue;
-		xor_srcs[count++] = sh->dev[i].page;
+		xor_srcs[count++] = sh->dev[i].pages[j];
 	}
 
-	init_async_submit(&submit, 0, NULL, NULL, NULL,
-			  to_addr_conv(sh, percpu));
-	tx = async_xor_val(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
-			   &sh->ops.zero_sum_result, &submit);
+	init_async_submit(&submit, 0, tx, NULL, NULL,
+			  to_addr_conv(sh, percpu, j));
+	tx = async_xor_val(xor_dest, xor_srcs, 0, count, PAGE_SIZE,
+			   &sh->ops.sum_results[j], &submit);
+
+	j++;
+	if (j < STRIPE_PAGES(sh->raid_conf))
+		goto again;
 
 	atomic_inc(&sh->count);
 	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_check, sh, NULL);
@@ -1623,22 +1784,32 @@ static void ops_run_check_p(struct strip
 
 static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu, int checkp)
 {
-	struct page **srcs = percpu->scribble;
+	struct page **srcs;
 	struct async_submit_ctl submit;
-	int count;
+	int count, j = 0;
+	struct dma_async_tx_descriptor *tx = NULL;
 
 	pr_debug("%s: stripe %llu checkp: %d\n", __func__,
 		(unsigned long long)sh->sector, checkp);
 
-	count = set_syndrome_sources(srcs, sh);
+again:
+	srcs = to_scribble_page(sh, percpu, j);
+	count = set_syndrome_sources(srcs, sh, j);
 	if (!checkp)
 		srcs[count] = NULL;
 
-	atomic_inc(&sh->count);
-	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
-			  sh, to_addr_conv(sh, percpu));
-	async_syndrome_val(srcs, 0, count+2, STRIPE_SIZE,
-			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
+	init_async_submit(&submit, 0, tx, NULL,
+			  NULL, to_addr_conv(sh, percpu, j));
+	async_syndrome_val(srcs, 0, count+2, PAGE_SIZE,
+			   &sh->ops.sum_results[j], percpu->spare_page + j, &submit);
+
+	j++;
+	if (j < STRIPE_PAGES(sh->raid_conf))
+		goto again;
+
+ 	atomic_inc(&sh->count);
+	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_check, sh, NULL);
+	tx = async_trigger_callback(&submit);
 }
 
 static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
@@ -1706,6 +1877,35 @@ static void raid_run_ops(struct stripe_h
 	put_cpu();
 }
 
+#define STRIPE_ALLOC_SIZE(conf, devs) \
+	(sizeof(struct stripe_head) + (devs - 1) * sizeof(struct r5dev) + \
+	 sizeof(enum sum_check_flags) * STRIPE_PAGES(conf) + \
+	 sizeof(struct bio_vec) * devs * STRIPE_PAGES(conf) + \
+	 sizeof(struct bio_vec) * devs * STRIPE_PAGES(conf) + \
+	 sizeof(struct page *) * devs * STRIPE_PAGES(conf))
+
+static void init_stripe_pointer(struct r5conf *conf, struct stripe_head *sh, int devs)
+{
+	void *p = sh;
+	struct bio_vec *vecs, *rvecs;
+	struct page **pages;
+	int i;
+
+	p += sizeof(struct stripe_head) + (devs - 1) * sizeof(struct r5dev);
+	sh->ops.sum_results = p;
+	p += sizeof(enum sum_check_flags) * STRIPE_PAGES(conf);
+	vecs = p;
+	p += sizeof(struct bio_vec) * devs * STRIPE_PAGES(conf);
+	rvecs = p;
+	p += sizeof(struct bio_vec) * devs * STRIPE_PAGES(conf);
+	pages = p;
+	for (i = 0; i < devs; i++) {
+		sh->dev[i].vecs = vecs + i * STRIPE_PAGES(conf);
+		sh->dev[i].rvecs = rvecs + i * STRIPE_PAGES(conf);
+		sh->dev[i].pages = pages + i * STRIPE_PAGES(conf);
+	}
+}
+
 static int grow_one_stripe(struct r5conf *conf, int hash)
 {
 	struct stripe_head *sh;
@@ -1713,6 +1913,7 @@ static int grow_one_stripe(struct r5conf
 	if (!sh)
 		return 0;
 
+	init_stripe_pointer(conf, sh, conf->pool_size);
 	sh->raid_conf = conf;
 
 	spin_lock_init(&sh->stripe_lock);
@@ -1747,7 +1948,7 @@ static int grow_stripes(struct r5conf *c
 
 	conf->active_name = 0;
 	sc = kmem_cache_create(conf->cache_name[conf->active_name],
-			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
+			       STRIPE_ALLOC_SIZE(conf, devs),
 			       0, 0, NULL);
 	if (!sc)
 		return 1;
@@ -1776,11 +1977,12 @@ static int grow_stripes(struct r5conf *c
  * calculate over all devices (not just the data blocks), using zeros in place
  * of the P and Q blocks.
  */
-static size_t scribble_len(int num)
+static size_t scribble_len(struct r5conf *conf, int num)
 {
 	size_t len;
 
 	len = sizeof(struct page *) * (num+2) + sizeof(addr_conv_t) * (num+2);
+	len *= STRIPE_PAGES(conf);
 
 	return len;
 }
@@ -1816,7 +2018,7 @@ static int resize_stripes(struct r5conf
 	unsigned long cpu;
 	int err;
 	struct kmem_cache *sc;
-	int i;
+	int i, j;
 	int hash, cnt;
 
 	if (newsize <= conf->pool_size)
@@ -1828,7 +2030,7 @@ static int resize_stripes(struct r5conf
 
 	/* Step 1 */
 	sc = kmem_cache_create(conf->cache_name[1-conf->active_name],
-			       sizeof(struct stripe_head)+(newsize-1)*sizeof(struct r5dev),
+			       STRIPE_ALLOC_SIZE(conf, newsize),
 			       0, 0, NULL);
 	if (!sc)
 		return -ENOMEM;
@@ -1838,6 +2040,8 @@ static int resize_stripes(struct r5conf
 		if (!nsh)
 			break;
 
+		init_stripe_pointer(conf, nsh, newsize);
+
 		nsh->raid_conf = conf;
 		spin_lock_init(&nsh->stripe_lock);
 
@@ -1869,11 +2073,12 @@ static int resize_stripes(struct r5conf
 		unlock_device_hash_lock(conf, hash);
 		atomic_set(&nsh->count, 1);
 		for(i=0; i<conf->pool_size; i++) {
-			nsh->dev[i].page = osh->dev[i].page;
-			nsh->dev[i].orig_page = osh->dev[i].page;
+			nsh->dev[i].orig_page = osh->dev[i].orig_page;
+			for (j = 0; j < STRIPE_PAGES(conf); j++)
+				nsh->dev[i].pages[j] = osh->dev[i].pages[j];
 		}
 		for( ; i<newsize; i++)
-			nsh->dev[i].page = NULL;
+			nsh->dev[i].orig_page = NULL;
 		nsh->hash_lock_index = hash;
 		kmem_cache_free(conf->slab_cache, osh);
 		cnt++;
@@ -1900,7 +2105,7 @@ static int resize_stripes(struct r5conf
 		err = -ENOMEM;
 
 	get_online_cpus();
-	conf->scribble_len = scribble_len(newsize);
+	conf->scribble_len = scribble_len(conf, newsize);
 	for_each_present_cpu(cpu) {
 		struct raid5_percpu *percpu;
 		void *scribble;
@@ -1924,12 +2129,15 @@ static int resize_stripes(struct r5conf
 		list_del_init(&nsh->lru);
 
 		for (i=conf->raid_disks; i < newsize; i++)
-			if (nsh->dev[i].page == NULL) {
-				struct page *p = alloc_page(GFP_NOIO);
-				nsh->dev[i].page = p;
-				nsh->dev[i].orig_page = p;
-				if (!p)
+			if (nsh->dev[i].orig_page == NULL) {
+				struct page *p = alloc_pages(GFP_NOIO, conf->stripe_size_order);
+				if (!p) {
 					err = -ENOMEM;
+					continue;
+				}
+				nsh->dev[i].orig_page = p;
+				for (j = 0; j < STRIPE_PAGES(conf); j++)
+					nsh->dev[i].pages[j] = p + j;
 			}
 		release_stripe(nsh);
 	}
@@ -2015,10 +2223,10 @@ static void raid5_end_read_request(struc
 				KERN_INFO
 				"md/raid:%s: read error corrected"
 				" (%lu sectors at %llu on %s)\n",
-				mdname(conf->mddev), STRIPE_SECTORS,
+				mdname(conf->mddev), STRIPE_SECTORS(conf),
 				(unsigned long long)s,
 				bdevname(rdev->bdev, b));
-			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
+			atomic_add(STRIPE_SECTORS(conf), &rdev->corrected_errors);
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		} else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
@@ -2082,7 +2290,7 @@ static void raid5_end_read_request(struc
 			if (!(set_bad
 			      && test_bit(In_sync, &rdev->flags)
 			      && rdev_set_badblocks(
-				      rdev, sh->sector, STRIPE_SECTORS, 0)))
+				      rdev, sh->sector, STRIPE_SECTORS(conf), 0)))
 				md_error(conf->mddev, rdev);
 		}
 	}
@@ -2133,7 +2341,7 @@ static void raid5_end_write_request(stru
 		if (!uptodate)
 			md_error(conf->mddev, rdev);
 		else if (is_badblock(rdev, sh->sector,
-				     STRIPE_SECTORS,
+				     STRIPE_SECTORS(conf),
 				     &first_bad, &bad_sectors))
 			set_bit(R5_MadeGoodRepl, &sh->dev[i].flags);
 	} else {
@@ -2145,7 +2353,7 @@ static void raid5_end_write_request(stru
 				set_bit(MD_RECOVERY_NEEDED,
 					&rdev->mddev->recovery);
 		} else if (is_badblock(rdev, sh->sector,
-				       STRIPE_SECTORS,
+				       STRIPE_SECTORS(conf),
 				       &first_bad, &bad_sectors)) {
 			set_bit(R5_MadeGood, &sh->dev[i].flags);
 			if (test_bit(R5_ReadError, &sh->dev[i].flags))
@@ -2171,13 +2379,9 @@ static void raid5_build_block(struct str
 	struct r5dev *dev = &sh->dev[i];
 
 	bio_init(&dev->req);
-	dev->req.bi_io_vec = &dev->vec;
-	dev->req.bi_max_vecs = 1;
 	dev->req.bi_private = sh;
 
 	bio_init(&dev->rreq);
-	dev->rreq.bi_io_vec = &dev->rvec;
-	dev->rreq.bi_max_vecs = 1;
 	dev->rreq.bi_private = sh;
 
 	dev->flags = 0;
@@ -2674,13 +2878,13 @@ static int add_stripe_bio(struct stripe_
 		/* check if page is covered */
 		sector_t sector = sh->dev[dd_idx].sector;
 		for (bi=sh->dev[dd_idx].towrite;
-		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
+		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS(conf) &&
 			     bi && bi->bi_iter.bi_sector <= sector;
-		     bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
+		     bi = r5_next_bio(conf, bi, sh->dev[dd_idx].sector)) {
 			if (bio_end_sector(bi) >= sector)
 				sector = bio_end_sector(bi);
 		}
-		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
+		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS(conf))
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
 
@@ -2691,7 +2895,7 @@ static int add_stripe_bio(struct stripe_
 
 	if (conf->mddev->bitmap && firstwrite) {
 		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
-				  STRIPE_SECTORS, 0);
+				  STRIPE_SECTORS(conf), 0);
 		sh->bm_seq = conf->seq_flush+1;
 		set_bit(STRIPE_BIT_DELAY, &sh->state);
 	}
@@ -2744,7 +2948,7 @@ handle_failed_stripe(struct r5conf *conf
 				if (!rdev_set_badblocks(
 					    rdev,
 					    sh->sector,
-					    STRIPE_SECTORS, 0))
+					    STRIPE_SECTORS(conf), 0))
 					md_error(conf->mddev, rdev);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
@@ -2761,8 +2965,8 @@ handle_failed_stripe(struct r5conf *conf
 			wake_up(&conf->wait_for_overlap);
 
 		while (bi && bi->bi_iter.bi_sector <
-			sh->dev[i].sector + STRIPE_SECTORS) {
-			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
+			sh->dev[i].sector + STRIPE_SECTORS(conf)) {
+			struct bio *nextbi = r5_next_bio(conf, bi, sh->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (!raid5_dec_bi_active_stripes(bi)) {
 				md_write_end(conf->mddev);
@@ -2773,20 +2977,20 @@ handle_failed_stripe(struct r5conf *conf
 		}
 		if (bitmap_end)
 			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-				STRIPE_SECTORS, 0, 0);
+				STRIPE_SECTORS(conf), 0, 0);
 		bitmap_end = 0;
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
 		sh->dev[i].written = NULL;
 		if (test_and_clear_bit(R5_SkipCopy, &sh->dev[i].flags)) {
 			WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
-			sh->dev[i].page = sh->dev[i].orig_page;
+			reset_stripe_devpage(sh, i);
 		}
 
 		if (bi) bitmap_end = 1;
 		while (bi && bi->bi_iter.bi_sector <
-		       sh->dev[i].sector + STRIPE_SECTORS) {
-			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
+		       sh->dev[i].sector + STRIPE_SECTORS(conf)) {
+			struct bio *bi2 = r5_next_bio(conf, bi, sh->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (!raid5_dec_bi_active_stripes(bi)) {
 				md_write_end(conf->mddev);
@@ -2809,9 +3013,9 @@ handle_failed_stripe(struct r5conf *conf
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
 			while (bi && bi->bi_iter.bi_sector <
-			       sh->dev[i].sector + STRIPE_SECTORS) {
+			       sh->dev[i].sector + STRIPE_SECTORS(conf)) {
 				struct bio *nextbi =
-					r5_next_bio(bi, sh->dev[i].sector);
+					r5_next_bio(conf, bi, sh->dev[i].sector);
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
 				if (!raid5_dec_bi_active_stripes(bi)) {
 					bi->bi_next = *return_bi;
@@ -2822,7 +3026,7 @@ handle_failed_stripe(struct r5conf *conf
 		}
 		if (bitmap_end)
 			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					STRIPE_SECTORS, 0, 0);
+					STRIPE_SECTORS(conf), 0, 0);
 		/* If we were in the middle of a write the parity block might
 		 * still be locked - so just clear all R5_LOCKED flags
 		 */
@@ -2863,21 +3067,21 @@ handle_failed_sync(struct r5conf *conf,
 			    && !test_bit(Faulty, &rdev->flags)
 			    && !test_bit(In_sync, &rdev->flags)
 			    && !rdev_set_badblocks(rdev, sh->sector,
-						   STRIPE_SECTORS, 0))
+						   STRIPE_SECTORS(conf), 0))
 				abort = 1;
 			rdev = conf->disks[i].replacement;
 			if (rdev
 			    && !test_bit(Faulty, &rdev->flags)
 			    && !test_bit(In_sync, &rdev->flags)
 			    && !rdev_set_badblocks(rdev, sh->sector,
-						   STRIPE_SECTORS, 0))
+						   STRIPE_SECTORS(conf), 0))
 				abort = 1;
 		}
 		if (abort)
 			conf->recovery_disabled =
 				conf->mddev->recovery_disabled;
 	}
-	md_done_sync(conf->mddev, STRIPE_SECTORS, !abort);
+	md_done_sync(conf->mddev, STRIPE_SECTORS(conf), !abort);
 }
 
 static int want_replace(struct stripe_head *sh, int disk_idx)
@@ -3036,13 +3240,13 @@ static void handle_stripe_clean_event(st
 					clear_bit(R5_UPTODATE, &dev->flags);
 				if (test_and_clear_bit(R5_SkipCopy, &dev->flags)) {
 					WARN_ON(test_bit(R5_UPTODATE, &dev->flags));
-					dev->page = dev->orig_page;
+					reset_stripe_devpage(sh, i);
 				}
 				wbi = dev->written;
 				dev->written = NULL;
 				while (wbi && wbi->bi_iter.bi_sector <
-					dev->sector + STRIPE_SECTORS) {
-					wbi2 = r5_next_bio(wbi, dev->sector);
+					dev->sector + STRIPE_SECTORS(conf)) {
+					wbi2 = r5_next_bio(conf, wbi, dev->sector);
 					if (!raid5_dec_bi_active_stripes(wbi)) {
 						md_write_end(conf->mddev);
 						wbi->bi_next = *return_bi;
@@ -3051,13 +3255,13 @@ static void handle_stripe_clean_event(st
 					wbi = wbi2;
 				}
 				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-						STRIPE_SECTORS,
+						STRIPE_SECTORS(conf),
 					 !test_bit(STRIPE_DEGRADED, &sh->state),
 						0);
 			} else if (test_bit(R5_Discard, &dev->flags))
 				discard_pending = 1;
 			WARN_ON(test_bit(R5_SkipCopy, &dev->flags));
-			WARN_ON(dev->page != dev->orig_page);
+			WARN_ON(dev->pages[0] != dev->orig_page);
 		}
 	if (!discard_pending &&
 	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
@@ -3274,7 +3478,7 @@ static void handle_parity_checks5(struct
 			 */
 			set_bit(STRIPE_INSYNC, &sh->state);
 		else {
-			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
+			atomic64_add(STRIPE_SECTORS(conf), &conf->mddev->resync_mismatches);
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
 				/* don't try to repair!! */
 				set_bit(STRIPE_INSYNC, &sh->state);
@@ -3426,7 +3630,7 @@ static void handle_parity_checks6(struct
 				 */
 			}
 		} else {
-			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
+			atomic64_add(STRIPE_SECTORS(conf), &conf->mddev->resync_mismatches);
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
 				/* don't try to repair!! */
 				set_bit(STRIPE_INSYNC, &sh->state);
@@ -3466,7 +3670,7 @@ static void handle_parity_checks6(struct
 
 static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 {
-	int i;
+	int i, k;
 
 	/* We have read all the blocks in this stripe and now we need to
 	 * copy some of them into a target stripe for expand.
@@ -3496,11 +3700,13 @@ static void handle_stripe_expansion(stru
 				continue;
 			}
 
-			/* place all the copies on one channel */
-			init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
-			tx = async_memcpy(sh2->dev[dd_idx].page,
-					  sh->dev[i].page, 0, 0, STRIPE_SIZE,
-					  &submit);
+			for (k = 0; k < STRIPE_PAGES(sh->raid_conf); k++) {
+				/* place all the copies on one channel */
+				init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
+				tx = async_memcpy(sh2->dev[dd_idx].pages[k],
+						  sh->dev[i].pages[k], 0, 0, PAGE_SIZE,
+						  &submit);
+			}
 
 			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
 			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
@@ -3597,8 +3803,8 @@ static void analyse_stripe(struct stripe
 		 */
 		rdev = rcu_dereference(conf->disks[i].replacement);
 		if (rdev && !test_bit(Faulty, &rdev->flags) &&
-		    rdev->recovery_offset >= sh->sector + STRIPE_SECTORS &&
-		    !is_badblock(rdev, sh->sector, STRIPE_SECTORS,
+		    rdev->recovery_offset >= sh->sector + STRIPE_SECTORS(conf) &&
+		    !is_badblock(rdev, sh->sector, STRIPE_SECTORS(conf),
 				 &first_bad, &bad_sectors))
 			set_bit(R5_ReadRepl, &dev->flags);
 		else {
@@ -3610,7 +3816,7 @@ static void analyse_stripe(struct stripe
 		if (rdev && test_bit(Faulty, &rdev->flags))
 			rdev = NULL;
 		if (rdev) {
-			is_bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS,
+			is_bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS(conf),
 					     &first_bad, &bad_sectors);
 			if (s->blocked_rdev == NULL
 			    && (test_bit(Blocked, &rdev->flags)
@@ -3637,7 +3843,7 @@ static void analyse_stripe(struct stripe
 			}
 		} else if (test_bit(In_sync, &rdev->flags))
 			set_bit(R5_Insync, &dev->flags);
-		else if (sh->sector + STRIPE_SECTORS <= rdev->recovery_offset)
+		else if (sh->sector + STRIPE_SECTORS(conf) <= rdev->recovery_offset)
 			/* in sync if before recovery_offset */
 			set_bit(R5_Insync, &dev->flags);
 		else if (test_bit(R5_UPTODATE, &dev->flags) &&
@@ -3903,7 +4109,7 @@ static void handle_stripe(struct stripe_
 	if ((s.syncing || s.replacing) && s.locked == 0 &&
 	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
 	    test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
+		md_done_sync(conf->mddev, STRIPE_SECTORS(conf), 1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags))
 			wake_up(&conf->wait_for_overlap);
@@ -3972,7 +4178,7 @@ static void handle_stripe(struct stripe_
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
-		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
+		md_done_sync(conf->mddev, STRIPE_SECTORS(conf), 1);
 	}
 
 	if (s.expanding && s.locked == 0 &&
@@ -4002,14 +4208,14 @@ finish:
 				/* We own a safe reference to the rdev */
 				rdev = conf->disks[i].rdev;
 				if (!rdev_set_badblocks(rdev, sh->sector,
-							STRIPE_SECTORS, 0))
+							STRIPE_SECTORS(conf), 0))
 					md_error(conf->mddev, rdev);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			if (test_and_clear_bit(R5_MadeGood, &dev->flags)) {
 				rdev = conf->disks[i].rdev;
 				rdev_clear_badblocks(rdev, sh->sector,
-						     STRIPE_SECTORS, 0);
+						     STRIPE_SECTORS(conf), 0);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			if (test_and_clear_bit(R5_MadeGoodRepl, &dev->flags)) {
@@ -4018,7 +4224,7 @@ finish:
 					/* rdev have been moved down */
 					rdev = conf->disks[i].rdev;
 				rdev_clear_badblocks(rdev, sh->sector,
-						     STRIPE_SECTORS, 0);
+						     STRIPE_SECTORS(conf), 0);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 		}
@@ -4502,7 +4708,7 @@ static void make_discard_request(struct
 		/* Skip discard while reshape is happening */
 		return;
 
-	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS-1);
+	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS(conf)-1);
 	last_sector = bi->bi_iter.bi_sector + (bi->bi_iter.bi_size>>9);
 
 	bi->bi_next = NULL;
@@ -4518,7 +4724,7 @@ static void make_discard_request(struct
 	last_sector *= conf->chunk_sectors;
 
 	for (; logical_sector < last_sector;
-	     logical_sector += STRIPE_SECTORS) {
+	     logical_sector += STRIPE_SECTORS(conf)) {
 		DEFINE_WAIT(w);
 		int d;
 	again:
@@ -4560,7 +4766,7 @@ static void make_discard_request(struct
 			     d++)
 				bitmap_startwrite(mddev->bitmap,
 						  sh->sector,
-						  STRIPE_SECTORS,
+						  STRIPE_SECTORS(conf),
 						  0);
 			sh->bm_seq = conf->seq_flush + 1;
 			set_bit(STRIPE_BIT_DELAY, &sh->state);
@@ -4609,13 +4815,13 @@ static void make_request(struct mddev *m
 		return;
 	}
 
-	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS-1);
+	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS(conf)-1);
 	last_sector = bio_end_sector(bi);
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
 
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
-	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
+	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS(conf)) {
 		int previous;
 		int seq;
 
@@ -4895,7 +5101,7 @@ static sector_t reshape_request(struct m
 	}
 
 	INIT_LIST_HEAD(&stripes);
-	for (i = 0; i < reshape_sectors; i += STRIPE_SECTORS) {
+	for (i = 0; i < reshape_sectors; i += STRIPE_SECTORS(conf)) {
 		int j;
 		int skipped_disk = 0;
 		sh = get_active_stripe(conf, stripe_addr+i, 0, 0, 1);
@@ -4906,6 +5112,7 @@ static sector_t reshape_request(struct m
 		 */
 		for (j=sh->disks; j--;) {
 			sector_t s;
+			int k;
 			if (j == sh->pd_idx)
 				continue;
 			if (conf->level == 6 &&
@@ -4916,7 +5123,8 @@ static sector_t reshape_request(struct m
 				skipped_disk = 1;
 				continue;
 			}
-			memset(page_address(sh->dev[j].page), 0, STRIPE_SIZE);
+			for (k = 0; k < STRIPE_PAGES(conf); k++)
+				memset(page_address(sh->dev[j].pages[k]), 0, PAGE_SIZE);
 			set_bit(R5_Expanded, &sh->dev[j].flags);
 			set_bit(R5_UPTODATE, &sh->dev[j].flags);
 		}
@@ -4951,7 +5159,7 @@ static sector_t reshape_request(struct m
 		set_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 		set_bit(STRIPE_HANDLE, &sh->state);
 		release_stripe(sh);
-		first_sector += STRIPE_SECTORS;
+		first_sector += STRIPE_SECTORS(conf);
 	}
 	/* Now that the sources are clearly marked, we can release
 	 * the destination stripes
@@ -5046,11 +5254,11 @@ static inline sector_t sync_request(stru
 	if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    !conf->fullsync &&
 	    !bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
-	    sync_blocks >= STRIPE_SECTORS) {
+	    sync_blocks >= STRIPE_SECTORS(conf)) {
 		/* we can skip this block, and probably more */
-		sync_blocks /= STRIPE_SECTORS;
+		sync_blocks /= STRIPE_SECTORS(conf);
 		*skipped = 1;
-		return sync_blocks * STRIPE_SECTORS; /* keep things rounded to whole stripes */
+		return sync_blocks * STRIPE_SECTORS(conf); /* keep things rounded to whole stripes */
 	}
 
 	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
@@ -5078,7 +5286,7 @@ static inline sector_t sync_request(stru
 
 	release_stripe(sh);
 
-	return STRIPE_SECTORS;
+	return STRIPE_SECTORS(conf);
 }
 
 static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
@@ -5101,14 +5309,14 @@ static int  retry_aligned_read(struct r5
 	int handled = 0;
 
 	logical_sector = raid_bio->bi_iter.bi_sector &
-		~((sector_t)STRIPE_SECTORS-1);
+		~((sector_t)STRIPE_SECTORS(conf)-1);
 	sector = raid5_compute_sector(conf, logical_sector,
 				      0, &dd_idx, NULL);
 	last_sector = bio_end_sector(raid_bio);
 
 	for (; logical_sector < last_sector;
-	     logical_sector += STRIPE_SECTORS,
-		     sector += STRIPE_SECTORS,
+	     logical_sector += STRIPE_SECTORS(conf),
+		     sector += STRIPE_SECTORS(conf),
 		     scnt++) {
 
 		if (scnt < raid5_bi_processed_stripes(raid_bio))
@@ -5607,7 +5815,8 @@ raid5_size(struct mddev *mddev, sector_t
 
 static void free_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu)
 {
-	safe_put_page(percpu->spare_page);
+	if (percpu->spare_page)
+		__free_pages(percpu->spare_page, conf->stripe_size_order);
 	kfree(percpu->scribble);
 	percpu->spare_page = NULL;
 	percpu->scribble = NULL;
@@ -5616,7 +5825,7 @@ static void free_scratch_buffer(struct r
 static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu)
 {
 	if (conf->level == 6 && !percpu->spare_page)
-		percpu->spare_page = alloc_page(GFP_KERNEL);
+		percpu->spare_page = alloc_pages(GFP_KERNEL, conf->stripe_size_order);
 	if (!percpu->scribble)
 		percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
 
@@ -5788,7 +5997,7 @@ static struct r5conf *setup_conf(struct
 	else
 		conf->previous_raid_disks = mddev->raid_disks - mddev->delta_disks;
 	max_disks = max(conf->raid_disks, conf->previous_raid_disks);
-	conf->scribble_len = scribble_len(max_disks);
+	conf->scribble_len = scribble_len(conf, max_disks);
 
 	conf->disks = kzalloc(max_disks * sizeof(struct disk_info),
 			      GFP_KERNEL);
@@ -6512,14 +6721,25 @@ static int check_stripe_cache(struct mdd
 	 * stripe_heads first.
 	 */
 	struct r5conf *conf = mddev->private;
-	if (((mddev->chunk_sectors << 9) / STRIPE_SIZE) * 4
+
+	/*
+	 * stripe size is bigger than chunk size is possible, but not very
+	 * useful. We don't allow it at this point.
+	 */
+	if ((mddev->new_chunk_sectors << 9) < STRIPE_SIZE(conf)) {
+		printk(KERN_WARNING
+		  "md/raid:%s: reshape: chunk size is smaller than stripe cache size\n",
+		  mdname(mddev));
+		return 0;
+	}
+	if (((mddev->chunk_sectors << 9) / STRIPE_SIZE(conf)) * 4
 	    > conf->max_nr_stripes ||
-	    ((mddev->new_chunk_sectors << 9) / STRIPE_SIZE) * 4
+	    ((mddev->new_chunk_sectors << 9) / STRIPE_SIZE(conf)) * 4
 	    > conf->max_nr_stripes) {
 		printk(KERN_WARNING "md/raid:%s: reshape: not enough stripes.  Needed %lu\n",
 		       mdname(mddev),
 		       ((max(mddev->chunk_sectors, mddev->new_chunk_sectors) << 9)
-			/ STRIPE_SIZE)*4);
+			/ STRIPE_SIZE(conf))*4);
 		return 0;
 	}
 	return 1;
@@ -6827,6 +7047,7 @@ static void *raid45_takeover_raid0(struc
 static void *raid5_takeover_raid1(struct mddev *mddev)
 {
 	int chunksect;
+	struct r5conf *conf = mddev->private;
 
 	if (mddev->raid_disks != 2 ||
 	    mddev->degraded > 1)
@@ -6840,7 +7061,7 @@ static void *raid5_takeover_raid1(struct
 	while (chunksect && (mddev->array_sectors & (chunksect-1)))
 		chunksect >>= 1;
 
-	if ((chunksect<<9) < STRIPE_SIZE)
+	if ((chunksect<<9) < STRIPE_SIZE(conf))
 		/* array size does not allow a suitable chunk size */
 		return ERR_PTR(-EINVAL);
 
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2014-07-08 08:47:57.092178441 +0800
+++ linux/drivers/md/raid5.h	2014-07-08 08:47:57.080178591 +0800
@@ -225,14 +225,15 @@ struct stripe_head {
 	struct stripe_operations {
 		int 		     target, target2;
 		enum sum_check_flags zero_sum_result;
+		enum sum_check_flags *sum_results;
 	} ops;
 	struct r5dev {
 		/* rreq and rvec are used for the replacement device when
 		 * writing data to both devices.
 		 */
 		struct bio	req, rreq;
-		struct bio_vec	vec, rvec;
-		struct page	*page, *orig_page;
+		struct bio_vec	*vecs, *rvecs;
+		struct page	**pages, *orig_page;
 		struct bio	*toread, *read, *towrite, *written;
 		sector_t	sector;			/* sector of this page */
 		unsigned long	flags;
@@ -487,6 +488,7 @@ struct r5conf {
 	int			pool_size; /* number of disks in stripeheads in pool */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
+	int			stripe_size_order;
 
 	/* When taking over an array from a different personality, we store
 	 * the new thread here until we fully activate the array.
