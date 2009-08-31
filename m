From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 8/9] md/raid6: remove synchronous infrastructure
Date: Mon, 31 Aug 2009 09:41:45 -0700
Message-ID: <20090831164144.1696.55931.stgit@dwillia2-linux.ch.intel.com>
References: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

From: Yuri Tikhonov <yur@emcraft.com>

These routines have been replaced by there asynchronous counterparts.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |  254 ----------------------------------------------------
 1 files changed, 0 insertions(+), 254 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a833de1..7c22e19 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1927,253 +1927,6 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
 }
 
 
-
-/*
- * Copy data between a page in the stripe cache, and one or more bion
- * The page could align with the middle of the bio, or there could be
- * several bion, each with several bio_vecs, which cover part of the page
- * Multiple bion are linked together on bi_next.  There may be extras
- * at the end of this list.  We ignore them.
- */
-static void copy_data(int frombio, struct bio *bio,
-		     struct page *page,
-		     sector_t sector)
-{
-	char *pa = page_address(page);
-	struct bio_vec *bvl;
-	int i;
-	int page_offset;
-
-	if (bio->bi_sector >= sector)
-		page_offset = (signed)(bio->bi_sector - sector) * 512;
-	else
-		page_offset = (signed)(sector - bio->bi_sector) * -512;
-	bio_for_each_segment(bvl, bio, i) {
-		int len = bio_iovec_idx(bio,i)->bv_len;
-		int clen;
-		int b_offset = 0;
-
-		if (page_offset < 0) {
-			b_offset = -page_offset;
-			page_offset += b_offset;
-			len -= b_offset;
-		}
-
-		if (len > 0 && page_offset + len > STRIPE_SIZE)
-			clen = STRIPE_SIZE - page_offset;
-		else clen = len;
-
-		if (clen > 0) {
-			char *ba = __bio_kmap_atomic(bio, i, KM_USER0);
-			if (frombio)
-				memcpy(pa+page_offset, ba+b_offset, clen);
-			else
-				memcpy(ba+b_offset, pa+page_offset, clen);
-			__bio_kunmap_atomic(ba, KM_USER0);
-		}
-		if (clen < len) /* hit end of page */
-			break;
-		page_offset +=  len;
-	}
-}
-
-#define check_xor()	do {						  \
-				if (count == MAX_XOR_BLOCKS) {		  \
-				xor_blocks(count, STRIPE_SIZE, dest, ptr);\
-				count = 0;				  \
-			   }						  \
-			} while(0)
-
-static void compute_parity6(struct stripe_head *sh, int method)
-{
-	raid5_conf_t *conf = sh->raid_conf;
-	int i, pd_idx, qd_idx, d0_idx, disks = sh->disks, count;
-	int syndrome_disks = sh->ddf_layout ? disks : (disks - 2);
-	struct bio *chosen;
-	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
-	void *ptrs[syndrome_disks+2];
-
-	pd_idx = sh->pd_idx;
-	qd_idx = sh->qd_idx;
-	d0_idx = raid6_d0(sh);
-
-	pr_debug("compute_parity, stripe %llu, method %d\n",
-		(unsigned long long)sh->sector, method);
-
-	switch(method) {
-	case READ_MODIFY_WRITE:
-		BUG();		/* READ_MODIFY_WRITE N/A for RAID-6 */
-	case RECONSTRUCT_WRITE:
-		for (i= disks; i-- ;)
-			if ( i != pd_idx && i != qd_idx && sh->dev[i].towrite ) {
-				chosen = sh->dev[i].towrite;
-				sh->dev[i].towrite = NULL;
-
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-					wake_up(&conf->wait_for_overlap);
-
-				BUG_ON(sh->dev[i].written);
-				sh->dev[i].written = chosen;
-			}
-		break;
-	case CHECK_PARITY:
-		BUG();		/* Not implemented yet */
-	}
-
-	for (i = disks; i--;)
-		if (sh->dev[i].written) {
-			sector_t sector = sh->dev[i].sector;
-			struct bio *wbi = sh->dev[i].written;
-			while (wbi && wbi->bi_sector < sector + STRIPE_SECTORS) {
-				copy_data(1, wbi, sh->dev[i].page, sector);
-				wbi = r5_next_bio(wbi, sector);
-			}
-
-			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			set_bit(R5_UPTODATE, &sh->dev[i].flags);
-		}
-
-	/* Note that unlike RAID-5, the ordering of the disks matters greatly.*/
-
-	for (i = 0; i < disks; i++)
-		ptrs[i] = (void *)raid6_empty_zero_page;
-
-	count = 0;
-	i = d0_idx;
-	do {
-		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
-
-		ptrs[slot] = page_address(sh->dev[i].page);
-		if (slot < syndrome_disks &&
-		    !test_bit(R5_UPTODATE, &sh->dev[i].flags)) {
-			printk(KERN_ERR "block %d/%d not uptodate "
-			       "on parity calc\n", i, count);
-			BUG();
-		}
-
-		i = raid6_next_disk(i, disks);
-	} while (i != d0_idx);
-	BUG_ON(count != syndrome_disks);
-
-	raid6_call.gen_syndrome(syndrome_disks+2, STRIPE_SIZE, ptrs);
-
-	switch(method) {
-	case RECONSTRUCT_WRITE:
-		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
-		set_bit(R5_UPTODATE, &sh->dev[qd_idx].flags);
-		set_bit(R5_LOCKED,   &sh->dev[pd_idx].flags);
-		set_bit(R5_LOCKED,   &sh->dev[qd_idx].flags);
-		break;
-	case UPDATE_PARITY:
-		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
-		set_bit(R5_UPTODATE, &sh->dev[qd_idx].flags);
-		break;
-	}
-}
-
-
-/* Compute one missing block */
-static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
-{
-	int i, count, disks = sh->disks;
-	void *ptr[MAX_XOR_BLOCKS], *dest, *p;
-	int qd_idx = sh->qd_idx;
-
-	pr_debug("compute_block_1, stripe %llu, idx %d\n",
-		(unsigned long long)sh->sector, dd_idx);
-
-	if ( dd_idx == qd_idx ) {
-		/* We're actually computing the Q drive */
-		compute_parity6(sh, UPDATE_PARITY);
-	} else {
-		dest = page_address(sh->dev[dd_idx].page);
-		if (!nozero) memset(dest, 0, STRIPE_SIZE);
-		count = 0;
-		for (i = disks ; i--; ) {
-			if (i == dd_idx || i == qd_idx)
-				continue;
-			p = page_address(sh->dev[i].page);
-			if (test_bit(R5_UPTODATE, &sh->dev[i].flags))
-				ptr[count++] = p;
-			else
-				printk("compute_block() %d, stripe %llu, %d"
-				       " not present\n", dd_idx,
-				       (unsigned long long)sh->sector, i);
-
-			check_xor();
-		}
-		if (count)
-			xor_blocks(count, STRIPE_SIZE, dest, ptr);
-		if (!nozero) set_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
-		else clear_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
-	}
-}
-
-/* Compute two missing blocks */
-static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
-{
-	int i, count, disks = sh->disks;
-	int syndrome_disks = sh->ddf_layout ? disks : disks-2;
-	int d0_idx = raid6_d0(sh);
-	int faila = -1, failb = -1;
-	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
-	void *ptrs[syndrome_disks+2];
-
-	for (i = 0; i < disks ; i++)
-		ptrs[i] = (void *)raid6_empty_zero_page;
-	count = 0;
-	i = d0_idx;
-	do {
-		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
-
-		ptrs[slot] = page_address(sh->dev[i].page);
-
-		if (i == dd_idx1)
-			faila = slot;
-		if (i == dd_idx2)
-			failb = slot;
-		i = raid6_next_disk(i, disks);
-	} while (i != d0_idx);
-	BUG_ON(count != syndrome_disks);
-
-	BUG_ON(faila == failb);
-	if ( failb < faila ) { int tmp = faila; faila = failb; failb = tmp; }
-
-	pr_debug("compute_block_2, stripe %llu, idx %d,%d (%d,%d)\n",
-		 (unsigned long long)sh->sector, dd_idx1, dd_idx2,
-		 faila, failb);
-
-	if (failb == syndrome_disks+1) {
-		/* Q disk is one of the missing disks */
-		if (faila == syndrome_disks) {
-			/* Missing P+Q, just recompute */
-			compute_parity6(sh, UPDATE_PARITY);
-			return;
-		} else {
-			/* We're missing D+Q; recompute D from P */
-			compute_block_1(sh, ((dd_idx1 == sh->qd_idx) ?
-					     dd_idx2 : dd_idx1),
-					0);
-			compute_parity6(sh, UPDATE_PARITY); /* Is this necessary? */
-			return;
-		}
-	}
-
-	/* We're missing D+P or D+D; */
-	if (failb == syndrome_disks) {
-		/* We're missing D+P. */
-		raid6_datap_recov(syndrome_disks+2, STRIPE_SIZE, faila, ptrs);
-	} else {
-		/* We're missing D+D. */
-		raid6_2data_recov(syndrome_disks+2, STRIPE_SIZE, faila, failb,
-				  ptrs);
-	}
-
-	/* Both the above update both missing blocks */
-	set_bit(R5_UPTODATE, &sh->dev[dd_idx1].flags);
-	set_bit(R5_UPTODATE, &sh->dev[dd_idx2].flags);
-}
-
 static void
 schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 			 int rcw, int expand)
@@ -2331,13 +2084,6 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 
 static void end_reshape(raid5_conf_t *conf);
 
-static int page_is_zero(struct page *p)
-{
-	char *a = page_address(p);
-	return ((*(u32*)a) == 0 &&
-		memcmp(a, a+4, STRIPE_SIZE-4)==0);
-}
-
 static void stripe_set_idx(sector_t stripe, raid5_conf_t *conf, int previous,
 			    struct stripe_head *sh)
 {

