From: NeilBrown <neilb@suse.de>
Subject: [PATCH 09/18] md/raid6: remove expectation that Q device is
	immediately after P device.
Date: Thu, 12 Feb 2009 14:10:11 +1100
Message-ID: <20090212031010.23983.26264.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Code currently assumes that the devices in a raid6 stripe are
  0 1 ... N-1 P Q
in some rotated order.  We will shortly add new layouts in which
this strict pattern is broken.
So remove this expectation.  We still assume that the data disks
are roughly in-order.  However P and Q can be inserted anywhere within
that order.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c         |  197 +++++++++++++++++++++++++-------------------
 include/linux/raid/raid5.h |   15 ++-
 2 files changed, 120 insertions(+), 92 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a061484..95f39d2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -130,6 +130,14 @@ static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigned int cnt)
 	bio->bi_phys_segments = raid5_bi_phys_segments(bio) || (cnt << 16);
 }
 
+/* Find first data disk in a raid6 stripe */
+static inline int raid6_d0(struct stripe_head *sh)
+{
+	if (sh->qd_idx == sh->disks - 1)
+		return 0;
+	else
+		return sh->qd_idx + 1;
+}
 static inline int raid6_next_disk(int disk, int raid_disks)
 {
 	disk++;
@@ -193,6 +201,7 @@ static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 		}
 	}
 }
+
 static void release_stripe(struct stripe_head *sh)
 {
 	raid5_conf_t *conf = sh->raid_conf;
@@ -271,12 +280,14 @@ static int grow_buffers(struct stripe_head *sh, int num)
 }
 
 static void raid5_build_block(struct stripe_head *sh, int i);
-static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous);
+static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous,
+			   int *qd_idx);
 
 static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int i;
+	int qd_idx;
 
 	BUG_ON(atomic_read(&sh->count) != 0);
 	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
@@ -290,7 +301,8 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 
 	sh->disks = previous ? conf->previous_raid_disks : conf->raid_disks;
 	sh->sector = sector;
-	sh->pd_idx = stripe_to_pdidx(sector, conf, previous);
+	sh->pd_idx = stripe_to_pdidx(sector, conf, previous, &qd_idx);
+	sh->qd_idx = qd_idx;
 	sh->state = 0;
 
 
@@ -1232,7 +1244,7 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
  */
 static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 				     int previous,
-				     int *dd_idx, int *pd_idx)
+				     int *dd_idx, int *pd_idx, int *qd_idx)
 {
 	long stripe;
 	unsigned long chunk_number;
@@ -1265,6 +1277,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 	/*
 	 * Select the parity disk based on the user selected algorithm.
 	 */
+	*qd_idx = ~0;
 	switch(conf->level) {
 	case 4:
 		*pd_idx = data_disks;
@@ -1300,24 +1313,30 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 		switch (conf->algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
 			*pd_idx = raid_disks - 1 - (stripe % raid_disks);
-			if (*pd_idx == raid_disks-1)
+			*qd_idx = *pd_idx + 1;
+			if (*pd_idx == raid_disks-1) {
 				(*dd_idx)++; 	/* Q D D D P */
-			else if (*dd_idx >= *pd_idx)
+				*qd_idx = 0;
+			} else if (*dd_idx >= *pd_idx)
 				(*dd_idx) += 2; /* D D P Q D */
 			break;
 		case ALGORITHM_RIGHT_ASYMMETRIC:
 			*pd_idx = stripe % raid_disks;
-			if (*pd_idx == raid_disks-1)
+			*qd_idx = *pd_idx + 1;
+			if (*pd_idx == raid_disks-1) {
 				(*dd_idx)++; 	/* Q D D D P */
-			else if (*dd_idx >= *pd_idx)
+				*qd_idx = 0;
+			} else if (*dd_idx >= *pd_idx)
 				(*dd_idx) += 2; /* D D P Q D */
 			break;
 		case ALGORITHM_LEFT_SYMMETRIC:
 			*pd_idx = raid_disks - 1 - (stripe % raid_disks);
+			*qd_idx = (*pd_idx + 1) % raid_disks;
 			*dd_idx = (*pd_idx + 2 + *dd_idx) % raid_disks;
 			break;
 		case ALGORITHM_RIGHT_SYMMETRIC:
 			*pd_idx = stripe % raid_disks;
+			*qd_idx = (*pd_idx + 1) % raid_disks;
 			*dd_idx = (*pd_idx + 2 + *dd_idx) % raid_disks;
 			break;
 		default:
@@ -1344,7 +1363,7 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	sector_t stripe;
 	int chunk_offset;
-	int chunk_number, dummy1, dummy2, dd_idx = i;
+	int chunk_number, dummy1, dummy2, dummy3, dd_idx = i;
 	sector_t r_sector;
 
 
@@ -1375,7 +1394,7 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 		}
 		break;
 	case 6:
-		if (i == raid6_next_disk(sh->pd_idx, raid_disks))
+		if (i == sh->qd_idx)
 			return 0; /* It is the Q disk */
 		switch (conf->algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
@@ -1408,7 +1427,7 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 
 	check = raid5_compute_sector(conf, r_sector,
 				     (raid_disks != conf->raid_disks),
-				     &dummy1, &dummy2);
+				     &dummy1, &dummy2, &dummy3);
 	if (check != sh->sector || dummy1 != dd_idx || dummy2 != sh->pd_idx) {
 		printk(KERN_ERR "compute_blocknr: map not correct\n");
 		return 0;
@@ -1477,13 +1496,14 @@ static void copy_data(int frombio, struct bio *bio,
 static void compute_parity6(struct stripe_head *sh, int method)
 {
 	raid6_conf_t *conf = sh->raid_conf;
-	int i, pd_idx = sh->pd_idx, qd_idx, d0_idx, disks = sh->disks, count;
+	int i, pd_idx, qd_idx, d0_idx, disks = sh->disks, count;
 	struct bio *chosen;
 	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
 	void *ptrs[disks];
 
-	qd_idx = raid6_next_disk(pd_idx, disks);
-	d0_idx = raid6_next_disk(qd_idx, disks);
+	pd_idx = sh->pd_idx;
+	qd_idx = sh->qd_idx;
+	d0_idx = raid6_d0(sh);
 
 	pr_debug("compute_parity, stripe %llu, method %d\n",
 		(unsigned long long)sh->sector, method);
@@ -1521,22 +1541,23 @@ static void compute_parity6(struct stripe_head *sh, int method)
 			set_bit(R5_UPTODATE, &sh->dev[i].flags);
 		}
 
-//	switch(method) {
-//	case RECONSTRUCT_WRITE:
-//	case CHECK_PARITY:
-//	case UPDATE_PARITY:
-		/* Note that unlike RAID-5, the ordering of the disks matters greatly. */
-		/* FIX: Is this ordering of drives even remotely optimal? */
-		count = 0;
-		i = d0_idx;
-		do {
+	/* Note that unlike RAID-5, the ordering of the disks matters greatly.*/
+	/* FIX: Is this ordering of drives even remotely optimal? */
+	count = 0;
+	i = d0_idx;
+	do {
+		if (i == sh->pd_idx)
+			ptrs[disks-2] = page_address(sh->dev[i].page);
+		else if (i == sh->qd_idx)
+			ptrs[disks-1] = page_address(sh->dev[i].page);
+		else {
 			ptrs[count++] = page_address(sh->dev[i].page);
-			if (count <= disks-2 && !test_bit(R5_UPTODATE, &sh->dev[i].flags))
+			if (!test_bit(R5_UPTODATE, &sh->dev[i].flags))
 				printk("block %d/%d not uptodate on parity calc\n", i,count);
-			i = raid6_next_disk(i, disks);
-		} while ( i != d0_idx );
-//		break;
-//	}
+		}
+		i = raid6_next_disk(i, disks);
+	} while (i != d0_idx);
+	BUG_ON(count+2 != disks);
 
 	raid6_call.gen_syndrome(disks, STRIPE_SIZE, ptrs);
 
@@ -1560,8 +1581,7 @@ static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 {
 	int i, count, disks = sh->disks;
 	void *ptr[MAX_XOR_BLOCKS], *dest, *p;
-	int pd_idx = sh->pd_idx;
-	int qd_idx = raid6_next_disk(pd_idx, disks);
+	int qd_idx = sh->qd_idx;
 
 	pr_debug("compute_block_1, stripe %llu, idx %d\n",
 		(unsigned long long)sh->sector, dd_idx);
@@ -1597,21 +1617,36 @@ static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 {
 	int i, count, disks = sh->disks;
-	int pd_idx = sh->pd_idx;
-	int qd_idx = raid6_next_disk(pd_idx, disks);
-	int d0_idx = raid6_next_disk(qd_idx, disks);
-	int faila, failb;
+	int d0_idx = raid6_d0(sh);
+	int faila = -1, failb = -1;
+	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
+	void *ptrs[disks];
 
-	/* faila and failb are disk numbers relative to d0_idx */
-	/* pd_idx become disks-2 and qd_idx become disks-1 */
-	faila = (dd_idx1 < d0_idx) ? dd_idx1+(disks-d0_idx) : dd_idx1-d0_idx;
-	failb = (dd_idx2 < d0_idx) ? dd_idx2+(disks-d0_idx) : dd_idx2-d0_idx;
+	count = 0;
+	i = d0_idx;
+	do {
+		int slot;
+		if (i == sh->pd_idx)
+			slot = disks-2;
+		else if (i == sh->qd_idx)
+			slot = disks-1;
+		else
+			slot = count++;
+		ptrs[slot] = page_address(sh->dev[i].page);
+		if (i == dd_idx1)
+			faila = slot;
+		if (i == dd_idx2)
+			failb = slot;
+		i = raid6_next_disk(i, disks);
+	} while (i != d0_idx);
+	BUG_ON(count+2 != disks);
 
 	BUG_ON(faila == failb);
 	if ( failb < faila ) { int tmp = faila; faila = failb; failb = tmp; }
 
 	pr_debug("compute_block_2, stripe %llu, idx %d,%d (%d,%d)\n",
-	       (unsigned long long)sh->sector, dd_idx1, dd_idx2, faila, failb);
+		 (unsigned long long)sh->sector, dd_idx1, dd_idx2,
+		 faila, failb);
 
 	if ( failb == disks-1 ) {
 		/* Q disk is one of the missing disks */
@@ -1621,39 +1656,26 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 			return;
 		} else {
 			/* We're missing D+Q; recompute D from P */
-			compute_block_1(sh, (dd_idx1 == qd_idx) ? dd_idx2 : dd_idx1, 0);
+			compute_block_1(sh, ((dd_idx1 == sh->qd_idx) ?
+					     dd_idx2 : dd_idx1),
+					0);
 			compute_parity6(sh, UPDATE_PARITY); /* Is this necessary? */
 			return;
 		}
 	}
 
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
+	/* We're missing D+P or D+D; */
+	if (failb == disks-2) {
+		/* We're missing D+P. */
+		raid6_datap_recov(disks, STRIPE_SIZE, faila, ptrs);
+	} else {
+		/* We're missing D+D. */
+		raid6_2data_recov(disks, STRIPE_SIZE, faila, failb, ptrs);
 	}
+
+	/* Both the above update both missing blocks */
+	set_bit(R5_UPTODATE, &sh->dev[dd_idx1].flags);
+	set_bit(R5_UPTODATE, &sh->dev[dd_idx2].flags);
 }
 
 static void
@@ -1808,7 +1830,8 @@ static int page_is_zero(struct page *p)
 		memcmp(a, a+4, STRIPE_SIZE-4)==0);
 }
 
-static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous)
+static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous,
+			   int *qd_idxp)
 {
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	int pd_idx, dd_idx;
@@ -1819,7 +1842,7 @@ static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous)
 			     stripe * (disks - conf->max_degraded)
 			     *sectors_per_chunk + chunk_offset,
 			     previous,
-			     &dd_idx, &pd_idx);
+			     &dd_idx, &pd_idx, qd_idxp);
 	return pd_idx;
 }
 
@@ -2478,12 +2501,13 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	for (i = 0; i < sh->disks; i++)
 		if (i != sh->pd_idx && (!r6s || i != r6s->qd_idx)) {
-			int dd_idx, pd_idx, j;
+			int dd_idx, pd_idx, qd_idx, j;
 			struct stripe_head *sh2;
 
 			sector_t bn = compute_blocknr(sh, i);
-			sector_t s = raid5_compute_sector(conf, bn, 0,
-							  &dd_idx, &pd_idx);
+			sector_t s =
+				raid5_compute_sector(conf, bn, 0,
+						     &dd_idx, &pd_idx, &qd_idx);
 			sh2 = get_active_stripe(conf, s, 0, 1);
 			if (sh2 == NULL)
 				/* so far only the early blocks of this stripe
@@ -2507,8 +2531,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
 			for (j = 0; j < conf->raid_disks; j++)
 				if (j != sh2->pd_idx &&
-				    (!r6s || j != raid6_next_disk(sh2->pd_idx,
-								 sh2->disks)) &&
+				    (!r6s || j != sh2->qd_idx) &&
 				    !test_bit(R5_Expanded, &sh2->dev[j].flags))
 					break;
 			if (j == conf->raid_disks) {
@@ -2768,9 +2791,11 @@ static bool handle_stripe5(struct stripe_head *sh)
 
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
 	    !sh->reconstruct_state) {
+		int qd_idx;
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, 0);
+		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, 0, &qd_idx);
+		sh->qd_idx = qd_idx;
 		schedule_reconstruction5(sh, &s, 1, 1);
 	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
@@ -2811,7 +2836,7 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	struct r5dev *dev, *pdev, *qdev;
 	mdk_rdev_t *blocked_rdev = NULL;
 
-	r6s.qd_idx = raid6_next_disk(pd_idx, disks);
+	r6s.qd_idx = sh->qd_idx;
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
 		"pd_idx=%d, qd_idx=%d\n",
 	       (unsigned long long)sh->sector, sh->state,
@@ -2987,8 +3012,10 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
 		/* Need to write out all blocks after computing P&Q */
+		int qd_idx;
 		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, 0);
+		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, 0, &qd_idx);
+		sh->qd_idx = qd_idx;
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		for (i = conf->raid_disks ; i-- ;  ) {
 			set_bit(R5_LOCKED, &sh->dev[i].flags);
@@ -3260,7 +3287,7 @@ static int chunk_aligned_read(struct request_queue *q, struct bio * raid_bio)
 {
 	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	unsigned int dd_idx, pd_idx;
+	unsigned int dd_idx, pd_idx, qd_idx;
 	struct bio* align_bi;
 	mdk_rdev_t *rdev;
 
@@ -3285,7 +3312,7 @@ static int chunk_aligned_read(struct request_queue *q, struct bio * raid_bio)
 	 */
 	align_bi->bi_sector =  raid5_compute_sector(conf, raid_bio->bi_sector,
 						    0,
-						    &dd_idx, &pd_idx);
+						    &dd_idx, &pd_idx, &qd_idx);
 
 	rcu_read_lock();
 	rdev = rcu_dereference(conf->disks[dd_idx].rdev);
@@ -3377,7 +3404,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 {
 	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	unsigned int dd_idx, pd_idx;
+	int dd_idx, pd_idx, qd_idx;
 	sector_t new_sector;
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
@@ -3444,7 +3471,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 
 		new_sector = raid5_compute_sector(conf, logical_sector,
 						  previous,
-						  &dd_idx, &pd_idx);
+						  &dd_idx, &pd_idx, &qd_idx);
 		pr_debug("raid5: make_request, sector %llu logical %llu\n",
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
@@ -3532,7 +3559,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 */
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	struct stripe_head *sh;
-	int pd_idx;
+	int pd_idx, qd_idx;
 	sector_t first_sector, last_sector;
 	int raid_disks = conf->previous_raid_disks;
 	int data_disks = raid_disks - conf->max_degraded;
@@ -3595,7 +3622,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 			if (j == sh->pd_idx)
 				continue;
 			if (conf->level == 6 &&
-			    j == raid6_next_disk(sh->pd_idx, sh->disks))
+			    j == sh->qd_idx)
 				continue;
 			s = compute_blocknr(sh, j);
 			if (s < mddev->array_sectors) {
@@ -3622,11 +3649,11 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 */
 	first_sector =
 		raid5_compute_sector(conf, sector_nr*(new_data_disks),
-				     1, &dd_idx, &pd_idx);
+				     1, &dd_idx, &pd_idx, &qd_idx);
 	last_sector =
 		raid5_compute_sector(conf, ((sector_nr+conf->chunk_size/512)
 					    *(new_data_disks) - 1),
-				     1, &dd_idx, &pd_idx);
+				     1, &dd_idx, &pd_idx, &qd_idx);
 	if (last_sector >= mddev->dev_sectors)
 		last_sector = mddev->dev_sectors - 1;
 	while (first_sector <= last_sector) {
@@ -3761,7 +3788,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 	 * it will be only one 'dd_idx' and only need one call to raid5_compute_sector.
 	 */
 	struct stripe_head *sh;
-	int dd_idx, pd_idx;
+	int dd_idx, pd_idx, qd_idx;
 	sector_t sector, logical_sector, last_sector;
 	int scnt = 0;
 	int remaining;
@@ -3769,7 +3796,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 
 	logical_sector = raid_bio->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	sector = raid5_compute_sector(conf, logical_sector,
-				      0, &dd_idx, &pd_idx);
+				      0, &dd_idx, &pd_idx, &qd_idx);
 	last_sector = raid_bio->bi_sector + (raid_bio->bi_size>>9);
 
 	for (; logical_sector < last_sector;
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 3b26727..804dac7 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -197,15 +197,16 @@ enum reconstruct_states {
 
 struct stripe_head {
 	struct hlist_node	hash;
-	struct list_head	lru;			/* inactive_list or handle_list */
-	struct raid5_private_data	*raid_conf;
-	sector_t		sector;			/* sector of this row */
-	int			pd_idx;			/* parity disk index */
-	unsigned long		state;			/* state flags */
-	atomic_t		count;			/* nr of active thread/requests */
+	struct list_head	lru;	      /* inactive_list or handle_list */
+	struct raid5_private_data *raid_conf;
+	sector_t		sector;		/* sector of this row */
+	short			pd_idx;		/* parity disk index */
+	short			qd_idx;		/* 'Q' disk index for raid6 */
+	unsigned long		state;		/* state flags */
+	atomic_t		count;	      /* nr of active thread/requests */
 	spinlock_t		lock;
 	int			bm_seq;	/* sequence number for bitmap flushes */
-	int			disks;			/* disks in stripe */
+	int			disks;		/* disks in stripe */
 	enum check_states	check_state;
 	enum reconstruct_states reconstruct_state;
 	/* stripe_operations


