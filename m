From: NeilBrown <neilb@suse.de>
Subject: [PATCH 08/18] md/raid5: change raid5_compute_sector and
	stripe_to_pdidx to take a 'previous' argument
Date: Thu, 12 Feb 2009 14:10:10 +1100
Message-ID: <20090212031010.23983.4781.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This similar to the recent change to get_active_stripe.
There is no functional change, just come rearrangement to make
future patches cleaner.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   78 +++++++++++++++++++++++-----------------------------
 1 files changed, 34 insertions(+), 44 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 94ed206..a061484 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -271,7 +271,7 @@ static int grow_buffers(struct stripe_head *sh, int num)
 }
 
 static void raid5_build_block(struct stripe_head *sh, int i);
-static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks);
+static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous);
 
 static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 {
@@ -290,7 +290,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 
 	sh->disks = previous ? conf->previous_raid_disks : conf->raid_disks;
 	sh->sector = sector;
-	sh->pd_idx = stripe_to_pdidx(sector, conf, sh->disks);
+	sh->pd_idx = stripe_to_pdidx(sector, conf, previous);
 	sh->state = 0;
 
 
@@ -1230,15 +1230,18 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
  * Input: a 'big' sector number,
  * Output: index of the data and parity disk, and the sector # in them.
  */
-static sector_t raid5_compute_sector(sector_t r_sector, unsigned int raid_disks,
-			unsigned int data_disks, unsigned int * dd_idx,
-			unsigned int * pd_idx, raid5_conf_t *conf)
+static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
+				     int previous,
+				     int *dd_idx, int *pd_idx)
 {
 	long stripe;
 	unsigned long chunk_number;
 	unsigned int chunk_offset;
 	sector_t new_sector;
 	int sectors_per_chunk = conf->chunk_size >> 9;
+	int raid_disks = previous ? conf->previous_raid_disks
+				  : conf->raid_disks;
+	int data_disks = raid_disks - conf->max_degraded;
 
 	/* First compute the information on this sector */
 
@@ -1403,7 +1406,9 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 	chunk_number = stripe * data_disks + i;
 	r_sector = (sector_t)chunk_number * sectors_per_chunk + chunk_offset;
 
-	check = raid5_compute_sector(r_sector, raid_disks, data_disks, &dummy1, &dummy2, conf);
+	check = raid5_compute_sector(conf, r_sector,
+				     (raid_disks != conf->raid_disks),
+				     &dummy1, &dummy2);
 	if (check != sh->sector || dummy1 != dd_idx || dummy2 != sh->pd_idx) {
 		printk(KERN_ERR "compute_blocknr: map not correct\n");
 		return 0;
@@ -1803,16 +1808,18 @@ static int page_is_zero(struct page *p)
 		memcmp(a, a+4, STRIPE_SIZE-4)==0);
 }
 
-static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
+static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous)
 {
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	int pd_idx, dd_idx;
 	int chunk_offset = sector_div(stripe, sectors_per_chunk);
+	int disks = previous ? conf->previous_raid_disks : conf->raid_disks;
 
-	raid5_compute_sector(stripe * (disks - conf->max_degraded)
+	raid5_compute_sector(conf,
+			     stripe * (disks - conf->max_degraded)
 			     *sectors_per_chunk + chunk_offset,
-			     disks, disks - conf->max_degraded,
-			     &dd_idx, &pd_idx, conf);
+			     previous,
+			     &dd_idx, &pd_idx);
 	return pd_idx;
 }
 
@@ -2475,10 +2482,8 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 			struct stripe_head *sh2;
 
 			sector_t bn = compute_blocknr(sh, i);
-			sector_t s = raid5_compute_sector(bn, conf->raid_disks,
-						conf->raid_disks -
-						conf->max_degraded, &dd_idx,
-						&pd_idx, conf);
+			sector_t s = raid5_compute_sector(conf, bn, 0,
+							  &dd_idx, &pd_idx);
 			sh2 = get_active_stripe(conf, s, 0, 1);
 			if (sh2 == NULL)
 				/* so far only the early blocks of this stripe
@@ -2765,8 +2770,7 @@ static bool handle_stripe5(struct stripe_head *sh)
 	    !sh->reconstruct_state) {
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
-			conf->raid_disks);
+		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, 0);
 		schedule_reconstruction5(sh, &s, 1, 1);
 	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
@@ -2984,8 +2988,7 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
 		/* Need to write out all blocks after computing P&Q */
 		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
-					     conf->raid_disks);
+		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, 0);
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		for (i = conf->raid_disks ; i-- ;  ) {
 			set_bit(R5_LOCKED, &sh->dev[i].flags);
@@ -3257,8 +3260,6 @@ static int chunk_aligned_read(struct request_queue *q, struct bio * raid_bio)
 {
 	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	const unsigned int raid_disks = conf->raid_disks;
-	const unsigned int data_disks = raid_disks - conf->max_degraded;
 	unsigned int dd_idx, pd_idx;
 	struct bio* align_bi;
 	mdk_rdev_t *rdev;
@@ -3282,12 +3283,9 @@ static int chunk_aligned_read(struct request_queue *q, struct bio * raid_bio)
 	/*
 	 *	compute position
 	 */
-	align_bi->bi_sector =  raid5_compute_sector(raid_bio->bi_sector,
-					raid_disks,
-					data_disks,
-					&dd_idx,
-					&pd_idx,
-					conf);
+	align_bi->bi_sector =  raid5_compute_sector(conf, raid_bio->bi_sector,
+						    0,
+						    &dd_idx, &pd_idx);
 
 	rcu_read_lock();
 	rdev = rcu_dereference(conf->disks[dd_idx].rdev);
@@ -3444,8 +3442,9 @@ static int make_request(struct request_queue *q, struct bio * bi)
 		}
 		data_disks = disks - conf->max_degraded;
 
- 		new_sector = raid5_compute_sector(logical_sector, disks, data_disks,
-						  &dd_idx, &pd_idx, conf);
+		new_sector = raid5_compute_sector(conf, logical_sector,
+						  previous,
+						  &dd_idx, &pd_idx);
 		pr_debug("raid5: make_request, sector %llu logical %llu\n",
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
@@ -3622,14 +3621,12 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 * block on the destination stripes.
 	 */
 	first_sector =
-		raid5_compute_sector(sector_nr*(new_data_disks),
-				     raid_disks, data_disks,
-				     &dd_idx, &pd_idx, conf);
+		raid5_compute_sector(conf, sector_nr*(new_data_disks),
+				     1, &dd_idx, &pd_idx);
 	last_sector =
-		raid5_compute_sector((sector_nr+conf->chunk_size/512)
-				     *(new_data_disks) -1,
-				     raid_disks, data_disks,
-				     &dd_idx, &pd_idx, conf);
+		raid5_compute_sector(conf, ((sector_nr+conf->chunk_size/512)
+					    *(new_data_disks) - 1),
+				     1, &dd_idx, &pd_idx);
 	if (last_sector >= mddev->dev_sectors)
 		last_sector = mddev->dev_sectors - 1;
 	while (first_sector <= last_sector) {
@@ -3666,8 +3663,6 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	struct stripe_head *sh;
-	int pd_idx;
-	int raid_disks = conf->raid_disks;
 	sector_t max_sector = mddev->dev_sectors;
 	int sync_blocks;
 	int still_degraded = 0;
@@ -3722,7 +3717,6 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 
 	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
 
-	pd_idx = stripe_to_pdidx(sector_nr, conf, raid_disks);
 	sh = get_active_stripe(conf, sector_nr, 0, 1);
 	if (sh == NULL) {
 		sh = get_active_stripe(conf, sector_nr, 0, 0);
@@ -3774,12 +3768,8 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 	int handled = 0;
 
 	logical_sector = raid_bio->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
-	sector = raid5_compute_sector(	logical_sector,
-					conf->raid_disks,
-					conf->raid_disks - conf->max_degraded,
-					&dd_idx,
-					&pd_idx,
-					conf);
+	sector = raid5_compute_sector(conf, logical_sector,
+				      0, &dd_idx, &pd_idx);
 	last_sector = raid_bio->bi_sector + (raid_bio->bi_size>>9);
 
 	for (; logical_sector < last_sector;


