From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH 02/12] md/raid5: add a new member of offset into r5dev
Date: Wed, 12 Aug 2020 08:49:21 -0400
Message-ID: <20200812124931.2584743-3-yuyufen@huawei.com>
References: <20200812124931.2584743-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200812124931.2584743-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

Add a new member of offset into struct r5dev. It indicates the
offset of related dev[i].page. For now, since each device have a
privated page, the value is always 0. Thus, we set offset as 0
when allcate page in grow_buffers() and resize_stripes().

To support following different page offset, we try to use the page
offset rather than '0' directly for async_memcpy() and ops_run_io().

No functional change.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 36 +++++++++++++++++++++++++++---------
 drivers/md/raid5.h |  1 +
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a4df2c2085a6..508dceafa533 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -477,6 +477,7 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
 		}
 		sh->dev[i].page = page;
 		sh->dev[i].orig_page = page;
+		sh->dev[i].offset = 0;
 	}
 
 	return 0;
@@ -1130,7 +1131,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				sh->dev[i].vec.bv_page = sh->dev[i].page;
 			bi->bi_vcnt = 1;
 			bi->bi_io_vec[0].bv_len = RAID5_STRIPE_SIZE(conf);
-			bi->bi_io_vec[0].bv_offset = 0;
+			bi->bi_io_vec[0].bv_offset = sh->dev[i].offset;
 			bi->bi_iter.bi_size = RAID5_STRIPE_SIZE(conf);
 			bi->bi_write_hint = sh->dev[i].write_hint;
 			if (!rrdev)
@@ -1184,7 +1185,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			sh->dev[i].rvec.bv_page = sh->dev[i].page;
 			rbi->bi_vcnt = 1;
 			rbi->bi_io_vec[0].bv_len = RAID5_STRIPE_SIZE(conf);
-			rbi->bi_io_vec[0].bv_offset = 0;
+			rbi->bi_io_vec[0].bv_offset = sh->dev[i].offset;
 			rbi->bi_iter.bi_size = RAID5_STRIPE_SIZE(conf);
 			rbi->bi_write_hint = sh->dev[i].write_hint;
 			sh->dev[i].write_hint = RWH_WRITE_LIFE_NOT_SET;
@@ -1418,9 +1419,11 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
 	struct page **xor_srcs = to_addr_page(percpu, 0);
+	unsigned int *off_srcs = to_addr_offs(sh, percpu);
 	int target = sh->ops.target;
 	struct r5dev *tgt = &sh->dev[target];
 	struct page *xor_dest = tgt->page;
+	unsigned int off_dest = tgt->offset;
 	int count = 0;
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
@@ -1432,16 +1435,19 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 		__func__, (unsigned long long)sh->sector, target);
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 
-	for (i = disks; i--; )
-		if (i != target)
+	for (i = disks; i--; ) {
+		if (i != target) {
+			off_srcs[count] = sh->dev[i].offset;
 			xor_srcs[count++] = sh->dev[i].page;
+		}
+	}
 
 	atomic_inc(&sh->count);
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
 			  ops_complete_compute, sh, to_addr_conv(sh, percpu, 0));
 	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0,
+		tx = async_memcpy(xor_dest, xor_srcs[0], off_dest, off_srcs[0],
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	else
 		tx = async_xor(xor_dest, xor_srcs, 0, count,
@@ -1863,9 +1869,11 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 {
 	int disks = sh->disks;
 	struct page **xor_srcs;
+	unsigned int *off_srcs;
 	struct async_submit_ctl submit;
 	int count, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
+	unsigned int off_dest;
 	int prexor = 0;
 	unsigned long flags;
 	int j = 0;
@@ -1890,24 +1898,31 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 again:
 	count = 0;
 	xor_srcs = to_addr_page(percpu, j);
+	off_srcs = to_addr_offs(sh, percpu);
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (written)
 	 */
 	if (head_sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
 		prexor = 1;
+		off_dest = off_srcs[count] = sh->dev[pd_idx].offset;
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (head_sh->dev[i].written ||
-			    test_bit(R5_InJournal, &head_sh->dev[i].flags))
+			    test_bit(R5_InJournal, &head_sh->dev[i].flags)) {
+				off_srcs[count] = dev->offset;
 				xor_srcs[count++] = dev->page;
+			}
 		}
 	} else {
 		xor_dest = sh->dev[pd_idx].page;
+		off_dest = sh->dev[pd_idx].offset;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (i != pd_idx)
+			if (i != pd_idx) {
+				off_srcs[count] = dev->offset;
 				xor_srcs[count++] = dev->page;
+			}
 		}
 	}
 
@@ -1933,7 +1948,7 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	}
 
 	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0,
+		tx = async_memcpy(xor_dest, xor_srcs[0], off_dest, off_srcs[0],
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	else
 		tx = async_xor(xor_dest, xor_srcs, 0, count,
@@ -2399,6 +2414,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		for(i=0; i<conf->pool_size; i++) {
 			nsh->dev[i].page = osh->dev[i].page;
 			nsh->dev[i].orig_page = osh->dev[i].page;
+			nsh->dev[i].offset = osh->dev[i].offset;
 		}
 		nsh->hash_lock_index = hash;
 		free_stripe(conf->slab_cache, osh);
@@ -2454,6 +2470,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 				struct page *p = alloc_page(GFP_NOIO);
 				nsh->dev[i].page = p;
 				nsh->dev[i].orig_page = p;
+				nsh->dev[i].offset = 0;
 				if (!p)
 					err = -ENOMEM;
 			}
@@ -4379,7 +4396,8 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 			/* place all the copies on one channel */
 			init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
 			tx = async_memcpy(sh2->dev[dd_idx].page,
-					  sh->dev[i].page, 0, 0, RAID5_STRIPE_SIZE(conf),
+					  sh->dev[i].page, sh2->dev[dd_idx].offset,
+					  sh->dev[i].offset, RAID5_STRIPE_SIZE(conf),
 					  &submit);
 
 			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 7fb3b26a181a..6b019cbe0fba 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -253,6 +253,7 @@ struct stripe_head {
 		struct bio	req, rreq;
 		struct bio_vec	vec, rvec;
 		struct page	*page, *orig_page;
+		unsigned int    offset;     /* offset of the page */
 		struct bio	*toread, *read, *towrite, *written;
 		sector_t	sector;			/* sector of this page */
 		unsigned long	flags;
-- 
2.25.4
