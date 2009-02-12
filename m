From: NeilBrown <neilb@suse.de>
Subject: [PATCH 07/18] md/raid5: simplify interface for init_stripe and
	get_active_stripe
Date: Thu, 12 Feb 2009 14:10:10 +1100
Message-ID: <20090212031010.23983.32536.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rather than passing 'pd_idx' and 'disks' to these functions, just pass
'previous' which tells whether to use the 'previous' or 'current'
geometry during a reshape, and let init_stripe calculate
disks and pd_idx and anything else it might need.

This is not a substantial simplification and even adds a division.
However we will shortly be adding more complexity to to init_stripe
to handle more interesting 'reshape' activities, and without this
change, the interface to these functions would get very complex.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   43 ++++++++++++++++++++++---------------------
 1 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 99c5261..94ed206 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -271,8 +271,9 @@ static int grow_buffers(struct stripe_head *sh, int num)
 }
 
 static void raid5_build_block(struct stripe_head *sh, int i);
+static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks);
 
-static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int disks)
+static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int i;
@@ -287,11 +288,11 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int
 
 	remove_hash(sh);
 
+	sh->disks = previous ? conf->previous_raid_disks : conf->raid_disks;
 	sh->sector = sector;
-	sh->pd_idx = pd_idx;
+	sh->pd_idx = stripe_to_pdidx(sector, conf, sh->disks);
 	sh->state = 0;
 
-	sh->disks = disks;
 
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
@@ -327,10 +328,12 @@ static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector, in
 static void unplug_slaves(mddev_t *mddev);
 static void raid5_unplug_device(struct request_queue *q);
 
-static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector, int disks,
-					     int pd_idx, int noblock)
+static struct stripe_head *
+get_active_stripe(raid5_conf_t *conf, sector_t sector,
+		  int previous, int noblock)
 {
 	struct stripe_head *sh;
+	int disks = previous ? conf->previous_raid_disks : conf->raid_disks;
 
 	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
 
@@ -358,7 +361,7 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 					);
 				conf->inactive_blocked = 0;
 			} else
-				init_stripe(sh, sector, pd_idx, disks);
+				init_stripe(sh, sector, previous);
 		} else {
 			if (atomic_read(&sh->count)) {
 			  BUG_ON(!list_empty(&sh->lru));
@@ -2476,8 +2479,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 						conf->raid_disks -
 						conf->max_degraded, &dd_idx,
 						&pd_idx, conf);
-			sh2 = get_active_stripe(conf, s, conf->raid_disks,
-						pd_idx, 1);
+			sh2 = get_active_stripe(conf, s, 0, 1);
 			if (sh2 == NULL)
 				/* so far only the early blocks of this stripe
 				 * have been requested.  When later blocks
@@ -3410,8 +3412,10 @@ static int make_request(struct request_queue *q, struct bio * bi)
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
 		int disks, data_disks;
+		int previous;
 
 	retry:
+		previous = 0;
 		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 		if (likely(conf->expand_progress == MaxSector))
 			disks = conf->raid_disks;
@@ -3426,9 +3430,10 @@ static int make_request(struct request_queue *q, struct bio * bi)
 			 */
 			spin_lock_irq(&conf->device_lock);
 			disks = conf->raid_disks;
-			if (logical_sector >= conf->expand_progress)
+			if (logical_sector >= conf->expand_progress) {
 				disks = conf->previous_raid_disks;
-			else {
+				previous = 1;
+			} else {
 				if (logical_sector >= conf->expand_lo) {
 					spin_unlock_irq(&conf->device_lock);
 					schedule();
@@ -3445,7 +3450,8 @@ static int make_request(struct request_queue *q, struct bio * bi)
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
 
-		sh = get_active_stripe(conf, new_sector, disks, pd_idx, (bi->bi_rw&RWA_MASK));
+		sh = get_active_stripe(conf, new_sector, previous,
+				       (bi->bi_rw&RWA_MASK));
 		if (sh) {
 			if (unlikely(conf->expand_progress != MaxSector)) {
 				/* expansion might have moved on while waiting for a
@@ -3579,9 +3585,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	for (i=0; i < conf->chunk_size/512; i+= STRIPE_SECTORS) {
 		int j;
 		int skipped = 0;
-		pd_idx = stripe_to_pdidx(sector_nr+i, conf, conf->raid_disks);
-		sh = get_active_stripe(conf, sector_nr+i,
-				       conf->raid_disks, pd_idx, 0);
+		sh = get_active_stripe(conf, sector_nr+i, 0, 0);
 		set_bit(STRIPE_EXPANDING, &sh->state);
 		atomic_inc(&conf->reshape_stripes);
 		/* If any of this stripe is beyond the end of the old
@@ -3629,10 +3633,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	if (last_sector >= mddev->dev_sectors)
 		last_sector = mddev->dev_sectors - 1;
 	while (first_sector <= last_sector) {
-		pd_idx = stripe_to_pdidx(first_sector, conf,
-					 conf->previous_raid_disks);
-		sh = get_active_stripe(conf, first_sector,
-				       conf->previous_raid_disks, pd_idx, 0);
+		sh = get_active_stripe(conf, first_sector, 1, 0);
 		set_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 		set_bit(STRIPE_HANDLE, &sh->state);
 		release_stripe(sh);
@@ -3722,9 +3723,9 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
 
 	pd_idx = stripe_to_pdidx(sector_nr, conf, raid_disks);
-	sh = get_active_stripe(conf, sector_nr, raid_disks, pd_idx, 1);
+	sh = get_active_stripe(conf, sector_nr, 0, 1);
 	if (sh == NULL) {
-		sh = get_active_stripe(conf, sector_nr, raid_disks, pd_idx, 0);
+		sh = get_active_stripe(conf, sector_nr, 0, 0);
 		/* make sure we don't swamp the stripe cache if someone else
 		 * is trying to get access
 		 */
@@ -3790,7 +3791,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 			/* already done this stripe */
 			continue;
 
-		sh = get_active_stripe(conf, sector, conf->raid_disks, pd_idx, 1);
+		sh = get_active_stripe(conf, sector, 0, 1);
 
 		if (!sh) {
 			/* failed to get a stripe - must wait */


