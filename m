From: NeilBrown <neilb@suse.de>
Subject: [PATCH 12/18] md/raid5: finish support for DDF/raid6
Date: Thu, 12 Feb 2009 14:10:11 +1100
Message-ID: <20090212031011.23983.25764.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

DDF requires RAID6 calculations over different devices in a different
order.
For md/raid6, we calculate over just the data devices, starting
immediately after the 'Q' block.
For ddf/raid6 we calculate over all devices, using zeros in place of
the P and Q blocks.

This requires unfortunately complex loops...

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c         |   62 +++++++++++++++++++++++++++++---------------
 include/linux/raid/raid5.h |    1 +
 2 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b26b637..f1dbfc4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -133,6 +133,10 @@ static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigned int cnt)
 /* Find first data disk in a raid6 stripe */
 static inline int raid6_d0(struct stripe_head *sh)
 {
+	if (sh->ddf_layout)
+		/* ddf always start from first device */
+		return 0;
+	/* md starts just after Q block */
 	if (sh->qd_idx == sh->disks - 1)
 		return 0;
 	else
@@ -1248,6 +1252,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 	unsigned long chunk_number;
 	unsigned int chunk_offset;
 	int pd_idx, qd_idx;
+	int ddf_layout = 0;
 	sector_t new_sector;
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	int raid_disks = previous ? conf->previous_raid_disks
@@ -1367,6 +1372,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 				qd_idx = 0;
 			} else if (*dd_idx >= pd_idx)
 				(*dd_idx) += 2; /* D D P Q D */
+			ddf_layout = 1;
 			break;
 
 		case ALGORITHM_ROTATING_N_RESTART:
@@ -1381,6 +1387,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 				qd_idx = 0;
 			} else if (*dd_idx >= pd_idx)
 				(*dd_idx) += 2; /* D D P Q D */
+			ddf_layout = 1;
 			break;
 
 		case ALGORITHM_ROTATING_N_CONTINUE:
@@ -1388,6 +1395,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 			pd_idx = raid_disks - 1 - (stripe % raid_disks);
 			qd_idx = (pd_idx + raid_disks - 1) % raid_disks;
 			*dd_idx = (pd_idx + 1 + *dd_idx) % raid_disks;
+			ddf_layout = 1;
 			break;
 
 		case ALGORITHM_LEFT_ASYMMETRIC_6:
@@ -1435,6 +1443,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 	if (sh) {
 		sh->pd_idx = pd_idx;
 		sh->qd_idx = qd_idx;
+		sh->ddf_layout = ddf_layout;
 	}
 	/*
 	 * Finally, compute the new sector number
@@ -1623,9 +1632,10 @@ static void compute_parity6(struct stripe_head *sh, int method)
 {
 	raid6_conf_t *conf = sh->raid_conf;
 	int i, pd_idx, qd_idx, d0_idx, disks = sh->disks, count;
+	int syndrome_disks = sh->ddf_layout ? disks : (disks - 2);
 	struct bio *chosen;
 	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
-	void *ptrs[disks];
+	void *ptrs[syndrome_disks+2];
 
 	pd_idx = sh->pd_idx;
 	qd_idx = sh->qd_idx;
@@ -1672,20 +1682,23 @@ static void compute_parity6(struct stripe_head *sh, int method)
 	count = 0;
 	i = d0_idx;
 	do {
+		const void *dblk = sh->ddf_layout ? raid6_empty_zero_page : NULL;
 		if (i == sh->pd_idx)
-			ptrs[disks-2] = page_address(sh->dev[i].page);
+			ptrs[syndrome_disks] = page_address(sh->dev[i].page);
 		else if (i == sh->qd_idx)
-			ptrs[disks-1] = page_address(sh->dev[i].page);
+			ptrs[syndrome_disks+1] = page_address(sh->dev[i].page);
 		else {
-			ptrs[count++] = page_address(sh->dev[i].page);
+			dblk = page_address(sh->dev[i].page);
 			if (!test_bit(R5_UPTODATE, &sh->dev[i].flags))
 				printk("block %d/%d not uptodate on parity calc\n", i,count);
 		}
+		if (dblk)
+			ptrs[count++] = (void*)dblk;
 		i = raid6_next_disk(i, disks);
 	} while (i != d0_idx);
-	BUG_ON(count+2 != disks);
+	BUG_ON(count != syndrome_disks);
 
-	raid6_call.gen_syndrome(disks, STRIPE_SIZE, ptrs);
+	raid6_call.gen_syndrome(syndrome_disks, STRIPE_SIZE, ptrs);
 
 	switch(method) {
 	case RECONSTRUCT_WRITE:
@@ -1743,29 +1756,35 @@ static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 {
 	int i, count, disks = sh->disks;
+	int syndrome_disks = sh->ddf_layout ? disks : disks-2;
 	int d0_idx = raid6_d0(sh);
 	int faila = -1, failb = -1;
 	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
-	void *ptrs[disks];
+	void *ptrs[syndrome_disks+2];
 
 	count = 0;
 	i = d0_idx;
 	do {
-		int slot;
-		if (i == sh->pd_idx)
-			slot = disks-2;
-		else if (i == sh->qd_idx)
-			slot = disks-1;
-		else
-			slot = count++;
-		ptrs[slot] = page_address(sh->dev[i].page);
+		const void *dblk = sh->ddf_layout ? raid6_empty_zero_page : NULL;
+		int slot = count;
+		if (i == sh->pd_idx) {
+			slot = syndrome_disks;
+			ptrs[slot] = page_address(sh->dev[i].page);
+		} else if (i == sh->qd_idx) {
+			slot = syndrome_disks+1;
+			ptrs[slot] = page_address(sh->dev[i].page);
+		} else
+			dblk = page_address(sh->dev[i].page);
+		if (dblk)
+			ptrs[count++] = (void*)dblk;
+
 		if (i == dd_idx1)
 			faila = slot;
 		if (i == dd_idx2)
 			failb = slot;
 		i = raid6_next_disk(i, disks);
 	} while (i != d0_idx);
-	BUG_ON(count+2 != disks);
+	BUG_ON(count != syndrome_disks);
 
 	BUG_ON(faila == failb);
 	if ( failb < faila ) { int tmp = faila; faila = failb; failb = tmp; }
@@ -1774,9 +1793,9 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 		 (unsigned long long)sh->sector, dd_idx1, dd_idx2,
 		 faila, failb);
 
-	if ( failb == disks-1 ) {
+	if ( failb == syndrome_disks+1 ) {
 		/* Q disk is one of the missing disks */
-		if ( faila == disks-2 ) {
+		if ( faila == syndrome_disks ) {
 			/* Missing P+Q, just recompute */
 			compute_parity6(sh, UPDATE_PARITY);
 			return;
@@ -1791,12 +1810,13 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 	}
 
 	/* We're missing D+P or D+D; */
-	if (failb == disks-2) {
+	if (failb == syndrome_disks) {
 		/* We're missing D+P. */
-		raid6_datap_recov(disks, STRIPE_SIZE, faila, ptrs);
+		raid6_datap_recov(syndrome_disks+2, STRIPE_SIZE, faila, ptrs);
 	} else {
 		/* We're missing D+D. */
-		raid6_2data_recov(disks, STRIPE_SIZE, faila, failb, ptrs);
+		raid6_2data_recov(syndrome_disks+2, STRIPE_SIZE, faila, failb,
+				  ptrs);
 	}
 
 	/* Both the above update both missing blocks */
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 4d43b08..3adda05 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -202,6 +202,7 @@ struct stripe_head {
 	sector_t		sector;		/* sector of this row */
 	short			pd_idx;		/* parity disk index */
 	short			qd_idx;		/* 'Q' disk index for raid6 */
+	short			ddf_layout;		/* use DDF ordering to calculate Q */
 	unsigned long		state;		/* state flags */
 	atomic_t		count;	      /* nr of active thread/requests */
 	spinlock_t		lock;


