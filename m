From: NeilBrown <neilb@suse.de>
Subject: [PATCH 10/18] md/raid5: simplify raid5_compute_sector interface
Date: Thu, 12 Feb 2009 14:10:11 +1100
Message-ID: <20090212031011.23983.99053.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rather than passing 'pd_idx' and 'qd_idx' to be filled in, pass
a 'struct stripe_head *' and fill in the relevant fields.  This is
more extensible.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  118 ++++++++++++++++++++++++++--------------------------
 1 files changed, 58 insertions(+), 60 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 95f39d2..ab751b2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -280,14 +280,13 @@ static int grow_buffers(struct stripe_head *sh, int num)
 }
 
 static void raid5_build_block(struct stripe_head *sh, int i);
-static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous,
-			   int *qd_idx);
+static void stripe_set_idx(sector_t stripe, raid5_conf_t *conf, int previous,
+			    struct stripe_head *sh);
 
 static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int i;
-	int qd_idx;
 
 	BUG_ON(atomic_read(&sh->count) != 0);
 	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
@@ -301,8 +300,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 
 	sh->disks = previous ? conf->previous_raid_disks : conf->raid_disks;
 	sh->sector = sector;
-	sh->pd_idx = stripe_to_pdidx(sector, conf, previous, &qd_idx);
-	sh->qd_idx = qd_idx;
+	stripe_set_idx(sector, conf, previous, sh);
 	sh->state = 0;
 
 
@@ -1243,12 +1241,13 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
  * Output: index of the data and parity disk, and the sector # in them.
  */
 static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
-				     int previous,
-				     int *dd_idx, int *pd_idx, int *qd_idx)
+				     int previous, int *dd_idx,
+				     struct stripe_head *sh)
 {
 	long stripe;
 	unsigned long chunk_number;
 	unsigned int chunk_offset;
+	int pd_idx, qd_idx;
 	sector_t new_sector;
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	int raid_disks = previous ? conf->previous_raid_disks
@@ -1277,30 +1276,30 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 	/*
 	 * Select the parity disk based on the user selected algorithm.
 	 */
-	*qd_idx = ~0;
+	pd_idx = qd_idx = ~0;
 	switch(conf->level) {
 	case 4:
-		*pd_idx = data_disks;
+		pd_idx = data_disks;
 		break;
 	case 5:
 		switch (conf->algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
-			*pd_idx = data_disks - stripe % raid_disks;
-			if (*dd_idx >= *pd_idx)
+			pd_idx = data_disks - stripe % raid_disks;
+			if (*dd_idx >= pd_idx)
 				(*dd_idx)++;
 			break;
 		case ALGORITHM_RIGHT_ASYMMETRIC:
-			*pd_idx = stripe % raid_disks;
-			if (*dd_idx >= *pd_idx)
+			pd_idx = stripe % raid_disks;
+			if (*dd_idx >= pd_idx)
 				(*dd_idx)++;
 			break;
 		case ALGORITHM_LEFT_SYMMETRIC:
-			*pd_idx = data_disks - stripe % raid_disks;
-			*dd_idx = (*pd_idx + 1 + *dd_idx) % raid_disks;
+			pd_idx = data_disks - stripe % raid_disks;
+			*dd_idx = (pd_idx + 1 + *dd_idx) % raid_disks;
 			break;
 		case ALGORITHM_RIGHT_SYMMETRIC:
-			*pd_idx = stripe % raid_disks;
-			*dd_idx = (*pd_idx + 1 + *dd_idx) % raid_disks;
+			pd_idx = stripe % raid_disks;
+			*dd_idx = (pd_idx + 1 + *dd_idx) % raid_disks;
 			break;
 		default:
 			printk(KERN_ERR "raid5: unsupported algorithm %d\n",
@@ -1312,32 +1311,32 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 		/**** FIX THIS ****/
 		switch (conf->algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
-			*pd_idx = raid_disks - 1 - (stripe % raid_disks);
-			*qd_idx = *pd_idx + 1;
-			if (*pd_idx == raid_disks-1) {
+			pd_idx = raid_disks - 1 - (stripe % raid_disks);
+			qd_idx = pd_idx + 1;
+			if (pd_idx == raid_disks-1) {
 				(*dd_idx)++; 	/* Q D D D P */
-				*qd_idx = 0;
-			} else if (*dd_idx >= *pd_idx)
+				qd_idx = 0;
+			} else if (*dd_idx >= pd_idx)
 				(*dd_idx) += 2; /* D D P Q D */
 			break;
 		case ALGORITHM_RIGHT_ASYMMETRIC:
-			*pd_idx = stripe % raid_disks;
-			*qd_idx = *pd_idx + 1;
-			if (*pd_idx == raid_disks-1) {
+			pd_idx = stripe % raid_disks;
+			qd_idx = pd_idx + 1;
+			if (pd_idx == raid_disks-1) {
 				(*dd_idx)++; 	/* Q D D D P */
-				*qd_idx = 0;
-			} else if (*dd_idx >= *pd_idx)
+				qd_idx = 0;
+			} else if (*dd_idx >= pd_idx)
 				(*dd_idx) += 2; /* D D P Q D */
 			break;
 		case ALGORITHM_LEFT_SYMMETRIC:
-			*pd_idx = raid_disks - 1 - (stripe % raid_disks);
-			*qd_idx = (*pd_idx + 1) % raid_disks;
-			*dd_idx = (*pd_idx + 2 + *dd_idx) % raid_disks;
+			pd_idx = raid_disks - 1 - (stripe % raid_disks);
+			qd_idx = (pd_idx + 1) % raid_disks;
+			*dd_idx = (pd_idx + 2 + *dd_idx) % raid_disks;
 			break;
 		case ALGORITHM_RIGHT_SYMMETRIC:
-			*pd_idx = stripe % raid_disks;
-			*qd_idx = (*pd_idx + 1) % raid_disks;
-			*dd_idx = (*pd_idx + 2 + *dd_idx) % raid_disks;
+			pd_idx = stripe % raid_disks;
+			qd_idx = (pd_idx + 1) % raid_disks;
+			*dd_idx = (pd_idx + 2 + *dd_idx) % raid_disks;
 			break;
 		default:
 			printk(KERN_CRIT "raid6: unsupported algorithm %d\n",
@@ -1346,6 +1345,10 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 		break;
 	}
 
+	if (sh) {
+		sh->pd_idx = pd_idx;
+		sh->qd_idx = qd_idx;
+	}
 	/*
 	 * Finally, compute the new sector number
 	 */
@@ -1363,8 +1366,9 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	sector_t stripe;
 	int chunk_offset;
-	int chunk_number, dummy1, dummy2, dummy3, dd_idx = i;
+	int chunk_number, dummy1, dd_idx = i;
 	sector_t r_sector;
+	struct stripe_head sh2;
 
 
 	chunk_offset = sector_div(new_sector, sectors_per_chunk);
@@ -1427,8 +1431,9 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 
 	check = raid5_compute_sector(conf, r_sector,
 				     (raid_disks != conf->raid_disks),
-				     &dummy1, &dummy2, &dummy3);
-	if (check != sh->sector || dummy1 != dd_idx || dummy2 != sh->pd_idx) {
+				     &dummy1, &sh2);
+	if (check != sh->sector || dummy1 != dd_idx || sh2.pd_idx != sh->pd_idx
+		|| sh2.qd_idx != sh->qd_idx) {
 		printk(KERN_ERR "compute_blocknr: map not correct\n");
 		return 0;
 	}
@@ -1830,11 +1835,11 @@ static int page_is_zero(struct page *p)
 		memcmp(a, a+4, STRIPE_SIZE-4)==0);
 }
 
-static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous,
-			   int *qd_idxp)
+static void stripe_set_idx(sector_t stripe, raid5_conf_t *conf, int previous,
+			    struct stripe_head *sh)
 {
 	int sectors_per_chunk = conf->chunk_size >> 9;
-	int pd_idx, dd_idx;
+	int dd_idx;
 	int chunk_offset = sector_div(stripe, sectors_per_chunk);
 	int disks = previous ? conf->previous_raid_disks : conf->raid_disks;
 
@@ -1842,8 +1847,7 @@ static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous,
 			     stripe * (disks - conf->max_degraded)
 			     *sectors_per_chunk + chunk_offset,
 			     previous,
-			     &dd_idx, &pd_idx, qd_idxp);
-	return pd_idx;
+			     &dd_idx, sh);
 }
 
 static void
@@ -2501,13 +2505,12 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	for (i = 0; i < sh->disks; i++)
 		if (i != sh->pd_idx && (!r6s || i != r6s->qd_idx)) {
-			int dd_idx, pd_idx, qd_idx, j;
+			int dd_idx, j;
 			struct stripe_head *sh2;
 
 			sector_t bn = compute_blocknr(sh, i);
-			sector_t s =
-				raid5_compute_sector(conf, bn, 0,
-						     &dd_idx, &pd_idx, &qd_idx);
+			sector_t s = raid5_compute_sector(conf, bn, 0,
+							  &dd_idx, NULL);
 			sh2 = get_active_stripe(conf, s, 0, 1);
 			if (sh2 == NULL)
 				/* so far only the early blocks of this stripe
@@ -2791,11 +2794,9 @@ static bool handle_stripe5(struct stripe_head *sh)
 
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
 	    !sh->reconstruct_state) {
-		int qd_idx;
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, 0, &qd_idx);
-		sh->qd_idx = qd_idx;
+		stripe_set_idx(sh->sector, conf, 0, sh);
 		schedule_reconstruction5(sh, &s, 1, 1);
 	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
@@ -3012,10 +3013,8 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
 		/* Need to write out all blocks after computing P&Q */
-		int qd_idx;
 		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, 0, &qd_idx);
-		sh->qd_idx = qd_idx;
+		stripe_set_idx(sh->sector, conf, 0, sh);
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		for (i = conf->raid_disks ; i-- ;  ) {
 			set_bit(R5_LOCKED, &sh->dev[i].flags);
@@ -3287,7 +3286,7 @@ static int chunk_aligned_read(struct request_queue *q, struct bio * raid_bio)
 {
 	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	unsigned int dd_idx, pd_idx, qd_idx;
+	unsigned int dd_idx;
 	struct bio* align_bi;
 	mdk_rdev_t *rdev;
 
@@ -3312,7 +3311,7 @@ static int chunk_aligned_read(struct request_queue *q, struct bio * raid_bio)
 	 */
 	align_bi->bi_sector =  raid5_compute_sector(conf, raid_bio->bi_sector,
 						    0,
-						    &dd_idx, &pd_idx, &qd_idx);
+						    &dd_idx, NULL);
 
 	rcu_read_lock();
 	rdev = rcu_dereference(conf->disks[dd_idx].rdev);
@@ -3404,7 +3403,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 {
 	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	int dd_idx, pd_idx, qd_idx;
+	int dd_idx;
 	sector_t new_sector;
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
@@ -3471,7 +3470,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 
 		new_sector = raid5_compute_sector(conf, logical_sector,
 						  previous,
-						  &dd_idx, &pd_idx, &qd_idx);
+						  &dd_idx, NULL);
 		pr_debug("raid5: make_request, sector %llu logical %llu\n",
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
@@ -3559,7 +3558,6 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 */
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	struct stripe_head *sh;
-	int pd_idx, qd_idx;
 	sector_t first_sector, last_sector;
 	int raid_disks = conf->previous_raid_disks;
 	int data_disks = raid_disks - conf->max_degraded;
@@ -3649,11 +3647,11 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 */
 	first_sector =
 		raid5_compute_sector(conf, sector_nr*(new_data_disks),
-				     1, &dd_idx, &pd_idx, &qd_idx);
+				     1, &dd_idx, NULL);
 	last_sector =
 		raid5_compute_sector(conf, ((sector_nr+conf->chunk_size/512)
 					    *(new_data_disks) - 1),
-				     1, &dd_idx, &pd_idx, &qd_idx);
+				     1, &dd_idx, NULL);
 	if (last_sector >= mddev->dev_sectors)
 		last_sector = mddev->dev_sectors - 1;
 	while (first_sector <= last_sector) {
@@ -3788,7 +3786,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 	 * it will be only one 'dd_idx' and only need one call to raid5_compute_sector.
 	 */
 	struct stripe_head *sh;
-	int dd_idx, pd_idx, qd_idx;
+	int dd_idx;
 	sector_t sector, logical_sector, last_sector;
 	int scnt = 0;
 	int remaining;
@@ -3796,7 +3794,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 
 	logical_sector = raid_bio->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	sector = raid5_compute_sector(conf, logical_sector,
-				      0, &dd_idx, &pd_idx, &qd_idx);
+				      0, &dd_idx, NULL);
 	last_sector = raid_bio->bi_sector + (raid_bio->bi_size>>9);
 
 	for (; logical_sector < last_sector;


