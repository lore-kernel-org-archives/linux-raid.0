From: Yuri Tikhonov <yur@emcraft.com>
Subject: [md-raid6-accel PATCH 11/12] md: remove unused functions
Date: Tue, 4 Dec 2007 14:38:25 +0300
Message-ID: <200712041438.26047.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Some clean-up of the replaced or already unnecessary functions.

 Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
 Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9b6336f..1d45887 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2202,250 +2202,6 @@ compute_blocknr(raid5_conf_t *conf, int raid_disks, sector_t sector,
 	return r_sector;
 }
 
-
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
-	struct stripe_queue *sq = sh->sq;
-	raid6_conf_t *conf = sq->raid_conf;
-	int i, pd_idx = sq->pd_idx, qd_idx, d0_idx, disks = sq->disks, count;
-	struct bio *chosen;
-	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
-	void *ptrs[disks];
-
-	qd_idx = raid6_next_disk(pd_idx, disks);
-	d0_idx = raid6_next_disk(qd_idx, disks);
-
-	pr_debug("compute_parity, stripe %llu, method %d\n",
-		(unsigned long long)sh->sector, method);
-
-	switch(method) {
-	case READ_MODIFY_WRITE:
-		BUG();		/* READ_MODIFY_WRITE N/A for RAID-6 */
-	case RECONSTRUCT_WRITE:
-		for (i= disks; i-- ;)
-			if (i != pd_idx && i != qd_idx && sq->dev[i].towrite) {
-				chosen = sq->dev[i].towrite;
-				sq->dev[i].towrite = NULL;
-				clear_bit(i, sq->to_write);
-
-				if (test_and_clear_bit(i, sq->overlap))
-					wake_up(&conf->wait_for_overlap);
-
-				BUG_ON(sq->dev[i].written);
-				sq->dev[i].written = chosen;
-			}
-		break;
-	case CHECK_PARITY:
-		BUG();		/* Not implemented yet */
-	}
-
-	for (i = disks; i--;)
-		if (sq->dev[i].written) {
-			sector_t sector = sq->dev[i].sector;
-			struct bio *wbi = sq->dev[i].written;
-			while (wbi && wbi->bi_sector < sector + STRIPE_SECTORS) {
-				copy_data(1, wbi, sh->dev[i].page, sector);
-				wbi = r5_next_bio(wbi, sector);
-			}
-
-			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			set_bit(R5_UPTODATE, &sh->dev[i].flags);
-		}
-
-//	switch(method) {
-//	case RECONSTRUCT_WRITE:
-//	case CHECK_PARITY:
-//	case UPDATE_PARITY:
-		/* Note that unlike RAID-5, the ordering of the disks matters greatly. */
-		/* FIX: Is this ordering of drives even remotely optimal? */
-		count = 0;
-		i = d0_idx;
-		do {
-			ptrs[count++] = page_address(sh->dev[i].page);
-			if (count <= disks-2 && !test_bit(R5_UPTODATE, &sh->dev[i].flags))
-				printk("block %d/%d not uptodate on parity calc\n", i,count);
-			i = raid6_next_disk(i, disks);
-		} while ( i != d0_idx );
-//		break;
-//	}
-
-	raid6_call.gen_syndrome(disks, STRIPE_SIZE, ptrs);
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
-	struct stripe_queue *sq = sh->sq;
-	int i, count, disks = sq->disks;
-	void *ptr[MAX_XOR_BLOCKS], *dest, *p;
-	int pd_idx = sq->pd_idx;
-	int qd_idx = raid6_next_disk(pd_idx, disks);
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
-	struct stripe_queue *sq = sh->sq;
-	int i, count, disks = sq->disks;
-	int pd_idx = sq->pd_idx;
-	int qd_idx = raid6_next_disk(pd_idx, disks);
-	int d0_idx = raid6_next_disk(qd_idx, disks);
-	int faila, failb;
-
-	/* faila and failb are disk numbers relative to d0_idx */
-	/* pd_idx become disks-2 and qd_idx become disks-1 */
-	faila = (dd_idx1 < d0_idx) ? dd_idx1+(disks-d0_idx) : dd_idx1-d0_idx;
-	failb = (dd_idx2 < d0_idx) ? dd_idx2+(disks-d0_idx) : dd_idx2-d0_idx;
-
-	BUG_ON(faila == failb);
-	if ( failb < faila ) { int tmp = faila; faila = failb; failb = tmp; }
-
-	pr_debug("compute_block_2, stripe %llu, idx %d,%d (%d,%d)\n",
-	       (unsigned long long)sh->sector, dd_idx1, dd_idx2, faila, failb);
-
-	if ( failb == disks-1 ) {
-		/* Q disk is one of the missing disks */
-		if ( faila == disks-2 ) {
-			/* Missing P+Q, just recompute */
-			compute_parity6(sh, UPDATE_PARITY);
-			return;
-		} else {
-			/* We're missing D+Q; recompute D from P */
-			compute_block_1(sh, (dd_idx1 == qd_idx) ? dd_idx2 : dd_idx1, 0);
-			compute_parity6(sh, UPDATE_PARITY); /* Is this necessary? */
-			return;
-		}
-	}
-
-	/* We're missing D+P or D+D; build pointer table */
-	{
-		/**** FIX THIS: This could be very bad if disks is close to 256 ****/
-		void *ptrs[disks];
-
-		count = 0;
-		i = d0_idx;
-		do {
-			ptrs[count++] = page_address(sh->dev[i].page);
-			i = raid6_next_disk(i, disks);
-			if (i != dd_idx1 && i != dd_idx2 &&
-			    !test_bit(R5_UPTODATE, &sh->dev[i].flags))
-				printk("compute_2 with missing block %d/%d\n", count, i);
-		} while ( i != d0_idx );
-
-		if ( failb == disks-2 ) {
-			/* We're missing D+P. */
-			raid6_datap_recov(disks, STRIPE_SIZE, faila, ptrs);
-		} else {
-			/* We're missing D+D. */
-			raid6_2data_recov(disks, STRIPE_SIZE, faila, failb, ptrs);
-		}
-
-		/* Both the above update both missing blocks */
-		set_bit(R5_UPTODATE, &sh->dev[dd_idx1].flags);
-		set_bit(R5_UPTODATE, &sh->dev[dd_idx2].flags);
-	}
-}
-
 static int
 handle_write_operations(struct stripe_head *sh, int rcw, int expand)
 {
@@ -2615,13 +2371,6 @@ static int add_queue_bio(struct stripe_queue *sq, struct bio *bi, int dd_idx,
 
 static void end_reshape(raid5_conf_t *conf);
 
-static int page_is_zero(struct page *p)
-{
-	char *a = page_address(p);
-	return ((*(u32*)a) == 0 &&
-		memcmp(a, a+4, STRIPE_SIZE-4)==0);
-}
-
 static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
 {
 	int sectors_per_chunk = conf->chunk_size >> 9;

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
