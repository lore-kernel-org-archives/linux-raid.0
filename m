From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/14] md/raid5: prepare for allowing reshape to change
	chunksize.
Date: Tue, 31 Mar 2009 15:54:43 +1100
Message-ID: <20090331045443.2589.28627.stgit@notabene.brown>
References: <20090331044827.2589.95894.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090331044827.2589.95894.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Add "prev_chunk" to raid5_conf_t, similar to "previous_raid_disks", to
remember what the chunk size was before the reshape that is currently
underway.

This seems like duplication with "chunk_size" and "new_chunk" in
mddev_t, and to some extent it is, but there are differences.
The values in mddev_t are always defined and often the same.
The prev* values are only defined if a reshape is underway.

Also (and more significantly) the raid5_conf_t values will be changed
at the same time (inside an appropriate lock) that the reshape is
started by setting reshape_position.  In contrast, the new_chunk value
is set when the sysfs file is written which could be well before the
reshape starts.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   43 +++++++++++++++++++++++++++----------------
 drivers/md/raid5.h |    1 +
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 73cdf43..7638cc3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -299,7 +299,7 @@ static int grow_buffers(struct stripe_head *sh, int num)
 	return 0;
 }
 
-static void raid5_build_block(struct stripe_head *sh, int i);
+static void raid5_build_block(struct stripe_head *sh, int i, int previous);
 static void stripe_set_idx(sector_t stripe, raid5_conf_t *conf, int previous,
 			    struct stripe_head *sh);
 
@@ -337,7 +337,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 			BUG();
 		}
 		dev->flags = 0;
-		raid5_build_block(sh, i);
+		raid5_build_block(sh, i, previous);
 	}
 	insert_hash(conf, sh);
 }
@@ -1212,9 +1212,9 @@ static void raid5_end_write_request(struct bio *bi, int error)
 }
 
 
-static sector_t compute_blocknr(struct stripe_head *sh, int i);
+static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous);
 	
-static void raid5_build_block(struct stripe_head *sh, int i)
+static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 {
 	struct r5dev *dev = &sh->dev[i];
 
@@ -1230,7 +1230,7 @@ static void raid5_build_block(struct stripe_head *sh, int i)
 	dev->req.bi_private = sh;
 
 	dev->flags = 0;
-	dev->sector = compute_blocknr(sh, i);
+	dev->sector = compute_blocknr(sh, i, previous);
 }
 
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
@@ -1273,7 +1273,8 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 	int pd_idx, qd_idx;
 	int ddf_layout = 0;
 	sector_t new_sector;
-	int sectors_per_chunk = conf->chunk_size >> 9;
+	int sectors_per_chunk = previous ? (conf->prev_chunk >> 9)
+					 : (conf->chunk_size >> 9);
 	int raid_disks = previous ? conf->previous_raid_disks
 				  : conf->raid_disks;
 	int data_disks = raid_disks - conf->max_degraded;
@@ -1472,13 +1473,14 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 }
 
 
-static sector_t compute_blocknr(struct stripe_head *sh, int i)
+static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int raid_disks = sh->disks;
 	int data_disks = raid_disks - conf->max_degraded;
 	sector_t new_sector = sh->sector, check;
-	int sectors_per_chunk = conf->chunk_size >> 9;
+	int sectors_per_chunk = previous ? (conf->prev_chunk >> 9)
+					 : (conf->chunk_size >> 9);
 	sector_t stripe;
 	int chunk_offset;
 	int chunk_number, dummy1, dd_idx = i;
@@ -1579,8 +1581,7 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 	r_sector = (sector_t)chunk_number * sectors_per_chunk + chunk_offset;
 
 	check = raid5_compute_sector(conf, r_sector,
-				     (raid_disks != conf->raid_disks),
-				     &dummy1, &sh2);
+				     previous, &dummy1, &sh2);
 	if (check != sh->sector || dummy1 != dd_idx || sh2.pd_idx != sh->pd_idx
 		|| sh2.qd_idx != sh->qd_idx) {
 		printk(KERN_ERR "compute_blocknr: map not correct\n");
@@ -1992,7 +1993,9 @@ static int page_is_zero(struct page *p)
 static void stripe_set_idx(sector_t stripe, raid5_conf_t *conf, int previous,
 			    struct stripe_head *sh)
 {
-	int sectors_per_chunk = conf->chunk_size >> 9;
+	int sectors_per_chunk =
+		previous ? (conf->prev_chunk >> 9)
+			 : (conf->chunk_size >> 9);
 	int dd_idx;
 	int chunk_offset = sector_div(stripe, sectors_per_chunk);
 	int disks = previous ? conf->previous_raid_disks : conf->raid_disks;
@@ -2662,7 +2665,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 			int dd_idx, j;
 			struct stripe_head *sh2;
 
-			sector_t bn = compute_blocknr(sh, i);
+			sector_t bn = compute_blocknr(sh, i, 1);
 			sector_t s = raid5_compute_sector(conf, bn, 0,
 							  &dd_idx, NULL);
 			sh2 = get_active_stripe(conf, s, 0, 1);
@@ -3318,6 +3321,8 @@ static int raid5_mergeable_bvec(struct request_queue *q,
 	if ((bvm->bi_rw & 1) == WRITE)
 		return biovec->bv_len; /* always allow writes to be mergeable */
 
+	if (mddev->new_chunk < mddev->chunk_size)
+		chunk_sectors = mddev->new_chunk >> 9;
 	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
 	if (max < 0) max = 0;
 	if (max <= biovec->bv_len && bio_sectors == 0)
@@ -3333,6 +3338,8 @@ static int in_chunk_boundary(mddev_t *mddev, struct bio *bio)
 	unsigned int chunk_sectors = mddev->chunk_size >> 9;
 	unsigned int bio_sectors = bio->bi_size >> 9;
 
+	if (mddev->new_chunk < mddev->chunk_size)
+		chunk_sectors = mddev->new_chunk >> 9;
 	return  chunk_sectors >=
 		((sector & (chunk_sectors - 1)) + bio_sectors);
 }
@@ -3788,7 +3795,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		BUG_ON(conf->reshape_progress == 0);
 		stripe_addr = writepos;
 		BUG_ON((mddev->dev_sectors &
-			~((sector_t)mddev->chunk_size / 512 - 1))
+			~((sector_t)conf->chunk_size / 512 - 1))
 		       - (conf->chunk_size / 512) - stripe_addr
 		       != sector_nr);
 	} else {
@@ -3811,7 +3818,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 			if (conf->level == 6 &&
 			    j == sh->qd_idx)
 				continue;
-			s = compute_blocknr(sh, j);
+			s = compute_blocknr(sh, j, 0);
 			if (s < raid5_size(mddev, 0, 0)) {
 				skipped = 1;
 				continue;
@@ -4217,6 +4224,7 @@ raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 	}
 
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
+	sectors &= ~((sector_t)mddev->new_chunk/512 - 1);
 	return sectors * (raid_disks - conf->max_degraded);
 }
 
@@ -4322,6 +4330,8 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	conf->algorithm = mddev->new_layout;
 	conf->max_nr_stripes = NR_STRIPES;
 	conf->reshape_progress = mddev->reshape_position;
+	if (conf->reshape_progress != MaxSector)
+		conf->prev_chunk = mddev->chunk_size;
 
 	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
 		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
@@ -4385,7 +4395,7 @@ static int run(mddev_t *mddev)
 		 * geometry.
 		 */
 		here_new = mddev->reshape_position;
-		if (sector_div(here_new, (mddev->chunk_size>>9)*
+		if (sector_div(here_new, (mddev->new_chunk>>9)*
 			       (mddev->raid_disks - max_degraded))) {
 			printk(KERN_ERR "raid5: reshape_position not "
 			       "on a stripe boundary\n");
@@ -4789,7 +4799,8 @@ static int raid5_check_reshape(mddev_t *mddev)
 	if ((mddev->chunk_size / STRIPE_SIZE) * 4 > conf->max_nr_stripes ||
 	    (mddev->new_chunk / STRIPE_SIZE) * 4 > conf->max_nr_stripes) {
 		printk(KERN_WARNING "raid5: reshape: not enough stripes.  Needed %lu\n",
-		       (mddev->chunk_size / STRIPE_SIZE)*4);
+		       (max(mddev->chunk_size, mddev->new_chunk)
+			/ STRIPE_SIZE)*4);
 		return -ENOSPC;
 	}
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index a081fb4..b9c9328 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -350,6 +350,7 @@ struct raid5_private_data {
 	 */
 	sector_t		reshape_safe;
 	int			previous_raid_disks;
+	int			prev_chunk;
 	short			generation; /* increments with every reshape */
 
 	struct list_head	handle_list; /* stripes needing handling */


