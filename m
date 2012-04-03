From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/10] md/raid5:  Use correct data_offset for all IO.
Date: Tue, 03 Apr 2012 15:53:01 +1000
Message-ID: <20120403055301.19495.22124.stgit@notabene.brown>
References: <20120403054656.19495.36380.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403054656.19495.36380.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As there can now be two different data_offsets - an 'old' and
a 'new' - we need to carefully choose between them.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   72 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3705585..71d1de9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -488,6 +488,27 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
 	return sh;
 }
 
+/* Determine if 'data_offset' or 'new_data_offset' should be used
+ * in this stripe_head.
+ */
+static int use_new_offset(struct r5conf *conf, struct stripe_head *sh)
+{
+	sector_t progress = conf->reshape_progress;
+	/* Need a memory barrier to make sure we see the value
+	 * of conf->generation, or ->data_offset that was set before
+	 * reshape_progress was updated.
+	 */
+	smp_rmb();
+	if (progress == MaxSector)
+		return 0;
+	if (sh->generation == conf->generation - 1)
+		return 0;
+	/* We are in a reshape, and this is a new-generation stripe,
+	 * so use new_data_offset.
+	 */
+	return 1;
+}
+
 static void
 raid5_end_read_request(struct bio *bi, int error);
 static void
@@ -603,7 +624,12 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				__func__, (unsigned long long)sh->sector,
 				bi->bi_rw, i);
 			atomic_inc(&sh->count);
-			bi->bi_sector = sh->sector + rdev->data_offset;
+			if (use_new_offset(conf, sh))
+				bi->bi_sector = (sh->sector
+						 + rdev->new_data_offset);
+			else
+				bi->bi_sector = (sh->sector
+						 + rdev->data_offset);
 			bi->bi_flags = 1 << BIO_UPTODATE;
 			bi->bi_idx = 0;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
@@ -627,7 +653,12 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				__func__, (unsigned long long)sh->sector,
 				rbi->bi_rw, i);
 			atomic_inc(&sh->count);
-			rbi->bi_sector = sh->sector + rrdev->data_offset;
+			if (use_new_offset(conf, sh))
+				rbi->bi_sector = (sh->sector
+						  + rrdev->new_data_offset);
+			else
+				rbi->bi_sector = (sh->sector
+						  + rrdev->data_offset);
 			rbi->bi_flags = 1 << BIO_UPTODATE;
 			rbi->bi_idx = 0;
 			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
@@ -1648,7 +1679,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev = NULL;
-
+	sector_t s;
 
 	for (i=0 ; i<disks; i++)
 		if (bi == &sh->dev[i].req)
@@ -1671,6 +1702,10 @@ static void raid5_end_read_request(struct bio * bi, int error)
 	if (!rdev)
 		rdev = conf->disks[i].rdev;
 
+	if (use_new_offset(conf, sh))
+		s = sh->sector + rdev->new_data_offset;
+	else
+		s = sh->sector + rdev->data_offset;
 	if (uptodate) {
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
@@ -1683,8 +1718,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 				"md/raid:%s: read error corrected"
 				" (%lu sectors at %llu on %s)\n",
 				mdname(conf->mddev), STRIPE_SECTORS,
-				(unsigned long long)(sh->sector
-						     + rdev->data_offset),
+				(unsigned long long)s,
 				bdevname(rdev->bdev, b));
 			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
@@ -1704,8 +1738,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 				"md/raid:%s: read error on replacement device "
 				"(sector %llu on %s).\n",
 				mdname(conf->mddev),
-				(unsigned long long)(sh->sector
-						     + rdev->data_offset),
+				(unsigned long long)s,
 				bdn);
 		else if (conf->mddev->degraded >= conf->max_degraded)
 			printk_ratelimited(
@@ -1713,8 +1746,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 				"md/raid:%s: read error not correctable "
 				"(sector %llu on %s).\n",
 				mdname(conf->mddev),
-				(unsigned long long)(sh->sector
-						     + rdev->data_offset),
+				(unsigned long long)s,
 				bdn);
 		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
 			/* Oh, no!!! */
@@ -1723,8 +1755,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 				"md/raid:%s: read error NOT corrected!! "
 				"(sector %llu on %s).\n",
 				mdname(conf->mddev),
-				(unsigned long long)(sh->sector
-						     + rdev->data_offset),
+				(unsigned long long)s,
 				bdn);
 		else if (atomic_read(&rdev->read_errors)
 			 > conf->max_nr_stripes)
@@ -3842,6 +3873,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 		raid_bio->bi_next = (void*)rdev;
 		align_bi->bi_bdev =  rdev->bdev;
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
+		/* No reshape active, so we can trust rdev->data_offset */
 		align_bi->bi_sector += rdev->data_offset;
 
 		if (!bio_fits_rdev(align_bi) ||
@@ -5182,9 +5214,12 @@ static int run(struct mddev *mddev)
 		blk_queue_io_opt(mddev->queue, chunk_size *
 				 (conf->raid_disks - conf->max_degraded));
 
-		rdev_for_each(rdev, mddev)
+		rdev_for_each(rdev, mddev) {
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+					  rdev->new_data_offset << 9);
+		}
 	}
 
 	return 0;
@@ -5539,12 +5574,16 @@ static int raid5_start_reshape(struct mddev *mddev)
 	conf->chunk_sectors = mddev->new_chunk_sectors;
 	conf->prev_algo = conf->algorithm;
 	conf->algorithm = mddev->new_layout;
+	conf->generation++;
+	/* Code that selects data_offset needs to see the generation update
+	 * if reshape_progress has been set - so a memory barrier needed.
+	 */
+	smp_mb();
 	if (mddev->reshape_backwards)
 		conf->reshape_progress = raid5_size(mddev, 0, 0);
 	else
 		conf->reshape_progress = 0;
 	conf->reshape_safe = conf->reshape_progress;
-	conf->generation++;
 	spin_unlock_irq(&conf->device_lock);
 
 	/* Add some new drives, as many as will fit.
@@ -5596,6 +5635,9 @@ static int raid5_start_reshape(struct mddev *mddev)
 		mddev->recovery = 0;
 		spin_lock_irq(&conf->device_lock);
 		mddev->raid_disks = conf->raid_disks = conf->previous_raid_disks;
+		rdev_for_each(rdev, mddev)
+			rdev->new_data_offset = rdev->data_offset;
+		smp_wmb();
 		conf->reshape_progress = MaxSector;
 		mddev->reshape_position = MaxSector;
 		spin_unlock_irq(&conf->device_lock);
@@ -5614,9 +5656,13 @@ static void end_reshape(struct r5conf *conf)
 {
 
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
+		struct md_rdev *rdev;
 
 		spin_lock_irq(&conf->device_lock);
 		conf->previous_raid_disks = conf->raid_disks;
+		rdev_for_each(rdev, conf->mddev)
+			rdev->data_offset = rdev->new_data_offset;
+		smp_wmb();
 		conf->reshape_progress = MaxSector;
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_for_overlap);


