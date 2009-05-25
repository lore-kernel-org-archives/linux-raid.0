From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 1/6] md: Make mddev->chunk_size sector-based.
Date: Mon, 25 May 2009 11:27:32 +0200
Message-ID: <1243243657-21855-2-git-send-email-maan@systemlinux.org>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

This patch changes the type of the chunk_size field from int to
sector_t and renames it to chunk_sectors with the implied change of
semantics. Since

	is_power_of_2(chunk_size) = is_power_of_2(chunk_sectors << 9)
				  = is_power_of_2(chunk_sectors)

these bits don't need an adjustment for the shift.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/linear.c |    2 +-
 drivers/md/md.c     |   49 +++++++++++++++++++++++++------------------------
 drivers/md/md.h     |    2 +-
 drivers/md/raid0.c  |   29 +++++++++++++++--------------
 drivers/md/raid1.c  |    4 ++--
 drivers/md/raid10.c |   15 ++++++++-------
 drivers/md/raid5.c  |   41 ++++++++++++++++++++++-------------------
 7 files changed, 74 insertions(+), 68 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 189cc54..ead1051 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -305,7 +305,7 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 static void linear_status (struct seq_file *seq, mddev_t *mddev)
 {
 
-	seq_printf(seq, " %dk rounding", mddev->chunk_size/1024);
+	seq_printf(seq, " %dk rounding", (int)mddev->chunk_sectors / 2);
 }
 
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 149eb0d..48bdbdf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -869,7 +869,7 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 		mddev->minor_version = sb->minor_version;
 		mddev->patch_version = sb->patch_version;
 		mddev->external = 0;
-		mddev->chunk_size = sb->chunk_size;
+		mddev->chunk_sectors = sb->chunk_size >> 9;
 		mddev->ctime = sb->ctime;
 		mddev->utime = sb->utime;
 		mddev->level = sb->level;
@@ -892,7 +892,7 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 			mddev->delta_disks = 0;
 			mddev->new_level = mddev->level;
 			mddev->new_layout = mddev->layout;
-			mddev->new_chunk = mddev->chunk_size;
+			mddev->new_chunk = mddev->chunk_sectors << 9;
 		}
 
 		if (sb->state & (1<<MD_SB_CLEAN))
@@ -1021,7 +1021,7 @@ static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 		sb->recovery_cp = 0;
 
 	sb->layout = mddev->layout;
-	sb->chunk_size = mddev->chunk_size;
+	sb->chunk_size = mddev->chunk_sectors << 9;
 
 	if (mddev->bitmap && mddev->bitmap_file == NULL)
 		sb->state |= (1<<MD_SB_BITMAP_PRESENT);
@@ -1274,7 +1274,7 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 		mddev->major_version = 1;
 		mddev->patch_version = 0;
 		mddev->external = 0;
-		mddev->chunk_size = le32_to_cpu(sb->chunksize) << 9;
+		mddev->chunk_sectors = le32_to_cpu(sb->chunksize);
 		mddev->ctime = le64_to_cpu(sb->ctime) & ((1ULL << 32)-1);
 		mddev->utime = le64_to_cpu(sb->utime) & ((1ULL << 32)-1);
 		mddev->level = le32_to_cpu(sb->level);
@@ -1306,7 +1306,7 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 			mddev->delta_disks = 0;
 			mddev->new_level = mddev->level;
 			mddev->new_layout = mddev->layout;
-			mddev->new_chunk = mddev->chunk_size;
+			mddev->new_chunk = mddev->chunk_sectors << 9;
 		}
 
 	} else if (mddev->pers == NULL) {
@@ -2746,7 +2746,7 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	if (IS_ERR(priv)) {
 		mddev->new_level = mddev->level;
 		mddev->new_layout = mddev->layout;
-		mddev->new_chunk = mddev->chunk_size;
+		mddev->new_chunk = mddev->chunk_sectors << 9;
 		mddev->raid_disks -= mddev->delta_disks;
 		mddev->delta_disks = 0;
 		module_put(pers->owner);
@@ -2764,7 +2764,7 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
 	mddev->level = mddev->new_level;
 	mddev->layout = mddev->new_layout;
-	mddev->chunk_size = mddev->new_chunk;
+	mddev->chunk_sectors = mddev->new_chunk >> 9;
 	mddev->delta_disks = 0;
 	pers->run(mddev);
 	mddev_resume(mddev);
@@ -2857,10 +2857,10 @@ static ssize_t
 chunk_size_show(mddev_t *mddev, char *page)
 {
 	if (mddev->reshape_position != MaxSector &&
-	    mddev->chunk_size != mddev->new_chunk)
+	    mddev->chunk_sectors << 9 != mddev->new_chunk)
 		return sprintf(page, "%d (%d)\n", mddev->new_chunk,
-			       mddev->chunk_size);
-	return sprintf(page, "%d\n", mddev->chunk_size);
+			       (int)mddev->chunk_sectors << 9);
+	return sprintf(page, "%d\n", (int)mddev->chunk_sectors << 9);
 }
 
 static ssize_t
@@ -2882,7 +2882,7 @@ chunk_size_store(mddev_t *mddev, const char *buf, size_t len)
 	} else {
 		mddev->new_chunk = n;
 		if (mddev->reshape_position == MaxSector)
-			mddev->chunk_size = n;
+			mddev->chunk_sectors = n >> 9;
 	}
 	return len;
 }
@@ -3520,9 +3520,9 @@ min_sync_store(mddev_t *mddev, const char *buf, size_t len)
 		return -EBUSY;
 
 	/* Must be a multiple of chunk_size */
-	if (mddev->chunk_size) {
+	if (mddev->chunk_sectors) {
 		sector_t temp = min;
-		if (sector_div(temp, (mddev->chunk_size>>9)))
+		if (sector_div(temp, mddev->chunk_sectors))
 			return -EINVAL;
 	}
 	mddev->resync_min = min;
@@ -3558,9 +3558,9 @@ max_sync_store(mddev_t *mddev, const char *buf, size_t len)
 			return -EBUSY;
 
 		/* Must be a multiple of chunk_size */
-		if (mddev->chunk_size) {
+		if (mddev->chunk_sectors) {
 			sector_t temp = max;
-			if (sector_div(temp, (mddev->chunk_size>>9)))
+			if (sector_div(temp, mddev->chunk_sectors))
 				return -EINVAL;
 		}
 		mddev->resync_max = max;
@@ -3651,7 +3651,7 @@ reshape_position_store(mddev_t *mddev, const char *buf, size_t len)
 	mddev->delta_disks = 0;
 	mddev->new_level = mddev->level;
 	mddev->new_layout = mddev->layout;
-	mddev->new_chunk = mddev->chunk_size;
+	mddev->new_chunk = mddev->chunk_sectors << 9;
 	return len;
 }
 
@@ -3993,7 +3993,7 @@ static int do_md_run(mddev_t * mddev)
 		analyze_sbs(mddev);
 	}
 
-	chunk_size = mddev->chunk_size;
+	chunk_size = mddev->chunk_sectors << 9;
 
 	if (chunk_size) {
 		if (chunk_size > MAX_CHUNK_SIZE) {
@@ -4392,7 +4392,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		mddev->flags = 0;
 		mddev->ro = 0;
 		mddev->metadata_type[0] = 0;
-		mddev->chunk_size = 0;
+		mddev->chunk_sectors = 0;
 		mddev->ctime = mddev->utime = 0;
 		mddev->layout = 0;
 		mddev->max_disks = 0;
@@ -4605,7 +4605,7 @@ static int get_array_info(mddev_t * mddev, void __user * arg)
 	info.spare_disks   = spare;
 
 	info.layout        = mddev->layout;
-	info.chunk_size    = mddev->chunk_size;
+	info.chunk_size    = mddev->chunk_sectors << 9;
 
 	if (copy_to_user(arg, &info, sizeof(info)))
 		return -EFAULT;
@@ -4830,7 +4830,8 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 			rdev->sb_start = rdev->bdev->bd_inode->i_size / 512;
 		} else 
 			rdev->sb_start = calc_dev_sboffset(rdev->bdev);
-		rdev->sectors = calc_num_sectors(rdev, mddev->chunk_size);
+		rdev->sectors = calc_num_sectors(rdev,
+						 mddev->chunk_sectors << 9);
 
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err) {
@@ -4900,7 +4901,7 @@ static int hot_add_disk(mddev_t * mddev, dev_t dev)
 	else
 		rdev->sb_start = rdev->bdev->bd_inode->i_size / 512;
 
-	rdev->sectors = calc_num_sectors(rdev, mddev->chunk_size);
+	rdev->sectors = calc_num_sectors(rdev, mddev->chunk_sectors << 9);
 
 	if (test_bit(Faulty, &rdev->flags)) {
 		printk(KERN_WARNING 
@@ -5049,7 +5050,7 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 	mddev->external	     = 0;
 
 	mddev->layout        = info->layout;
-	mddev->chunk_size    = info->chunk_size;
+	mddev->chunk_sectors = info->chunk_size >> 9;
 
 	mddev->max_disks     = MD_SB_DISKS;
 
@@ -5068,7 +5069,7 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 	get_random_bytes(mddev->uuid, 16);
 
 	mddev->new_level = mddev->level;
-	mddev->new_chunk = mddev->chunk_size;
+	mddev->new_chunk = mddev->chunk_sectors << 9;
 	mddev->new_layout = mddev->layout;
 	mddev->delta_disks = 0;
 
@@ -5178,7 +5179,7 @@ static int update_array_info(mddev_t *mddev, mdu_array_info_t *info)
 	    mddev->level         != info->level         ||
 /*	    mddev->layout        != info->layout        || */
 	    !mddev->persistent	 != info->not_persistent||
-	    mddev->chunk_size    != info->chunk_size    ||
+	    mddev->chunk_sectors != info->chunk_size >> 9 ||
 	    /* ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT to change */
 	    ((state^info->state) & 0xfffffe00)
 		)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8227ab9..7cbb895 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -145,7 +145,7 @@ struct mddev_s
 	int 				external;	/* metadata is
 							 * managed externally */
 	char				metadata_type[17]; /* externally set*/
-	int				chunk_size;
+	sector_t			chunk_sectors;
 	time_t				ctime, utime;
 	int				level, layout;
 	char				clevel[16];
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d57d8ab..7d680bc 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -240,10 +240,10 @@ static int create_strip_zones(mddev_t *mddev)
 	 * now since we have the hard sector sizes, we can make sure
 	 * chunk size is a multiple of that sector size
 	 */
-	if (mddev->chunk_size % mddev->queue->hardsect_size) {
+	if ((mddev->chunk_sectors << 9) % mddev->queue->hardsect_size) {
 		printk(KERN_ERR "%s chunk_size of %d not valid\n",
 		       mdname(mddev),
-		       mddev->chunk_size);
+		       (int)mddev->chunk_sectors << 9);
 		goto abort;
 	}
 	printk(KERN_INFO "raid0: done.\n");
@@ -272,10 +272,10 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 	mddev_t *mddev = q->queuedata;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
 	int max;
-	unsigned int chunk_sectors = mddev->chunk_size >> 9;
+	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
 
-	if (is_power_of_2(mddev->chunk_size))
+	if (is_power_of_2(mddev->chunk_sectors))
 		max =  (chunk_sectors - ((sector & (chunk_sectors-1))
 						+ bio_sectors)) << 9;
 	else
@@ -306,12 +306,12 @@ static int raid0_run(mddev_t *mddev)
 {
 	int ret;
 
-	if (mddev->chunk_size == 0 ||
-	    !is_power_of_2(mddev->chunk_size)) {
+	if (mddev->chunk_sectors == 0 ||
+	    !is_power_of_2(mddev->chunk_sectors)) {
 		printk(KERN_ERR "md/raid0: chunk size must be a power of 2.\n");
 		return -EINVAL;
 	}
-	blk_queue_max_sectors(mddev->queue, mddev->chunk_size >> 9);
+	blk_queue_max_sectors(mddev->queue, mddev->chunk_sectors);
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
 	ret = create_strip_zones(mddev);
@@ -333,7 +333,8 @@ static int raid0_run(mddev_t *mddev)
 	 * chunksize should be used in that case.
 	 */
 	{
-		int stripe = mddev->raid_disks * mddev->chunk_size / PAGE_SIZE;
+		int stripe = mddev->raid_disks *
+			(mddev->chunk_sectors << 9) / PAGE_SIZE;
 		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}
@@ -384,9 +385,9 @@ static mdk_rdev_t *map_sector(mddev_t *mddev, struct strip_zone *zone,
 	unsigned int sect_in_chunk;
 	sector_t chunk;
 	raid0_conf_t *conf = mddev->private;
-	unsigned int chunk_sects = mddev->chunk_size >> 9;
+	unsigned int chunk_sects = mddev->chunk_sectors;
 
-	if (is_power_of_2(mddev->chunk_size)) {
+	if (is_power_of_2(mddev->chunk_sectors)) {
 		int chunksect_bits = ffz(~chunk_sects);
 		/* find the sector offset inside the chunk */
 		sect_in_chunk  = sector & (chunk_sects - 1);
@@ -416,7 +417,7 @@ static mdk_rdev_t *map_sector(mddev_t *mddev, struct strip_zone *zone,
 static inline int is_io_in_chunk_boundary(mddev_t *mddev,
 			unsigned int chunk_sects, struct bio *bio)
 {
-	if (likely(is_power_of_2(mddev->chunk_size))) {
+	if (likely(is_power_of_2(mddev->chunk_sectors))) {
 		return chunk_sects >= ((bio->bi_sector & (chunk_sects-1))
 					+ (bio->bi_size >> 9));
 	} else{
@@ -447,7 +448,7 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 		      bio_sectors(bio));
 	part_stat_unlock();
 
-	chunk_sects = mddev->chunk_size >> 9;
+	chunk_sects = mddev->chunk_sectors;
 	if (unlikely(!is_io_in_chunk_boundary(mddev, chunk_sects, bio))) {
 		sector_t sector = bio->bi_sector;
 		struct bio_pair *bp;
@@ -458,7 +459,7 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		if (likely(is_power_of_2(mddev->chunk_size)))
+		if (likely(is_power_of_2(mddev->chunk_sectors)))
 			bp = bio_split(bio, chunk_sects - (sector &
 							   (chunk_sects-1)));
 		else
@@ -522,7 +523,7 @@ static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 		zone_start = conf->strip_zone[j].zone_end;
 	}
 #endif
-	seq_printf(seq, " %dk chunks", mddev->chunk_size/1024);
+	seq_printf(seq, " %dk chunks", (int)mddev->chunk_sectors / 2);
 	return;
 }
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2c8d9e6..b56f075 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2161,10 +2161,10 @@ static int raid1_reshape(mddev_t *mddev)
 	int d, d2, err;
 
 	/* Cannot change chunk_size, layout, or level */
-	if (mddev->chunk_size != mddev->new_chunk ||
+	if (mddev->chunk_sectors << 9 != mddev->new_chunk ||
 	    mddev->layout != mddev->new_layout ||
 	    mddev->level != mddev->new_level) {
-		mddev->new_chunk = mddev->chunk_size;
+		mddev->new_chunk = mddev->chunk_sectors << 9;
 		mddev->new_layout = mddev->layout;
 		mddev->new_level = mddev->level;
 		return -EINVAL;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 33131fc..d75cb96 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -461,7 +461,7 @@ static int raid10_mergeable_bvec(struct request_queue *q,
 	mddev_t *mddev = q->queuedata;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
 	int max;
-	unsigned int chunk_sectors = mddev->chunk_size >> 9;
+	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
 
 	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
@@ -985,7 +985,7 @@ static void status(struct seq_file *seq, mddev_t *mddev)
 	int i;
 
 	if (conf->near_copies < conf->raid_disks)
-		seq_printf(seq, " %dK chunks", mddev->chunk_size/1024);
+		seq_printf(seq, " %dK chunks", (int)mddev->chunk_sectors / 2);
 	if (conf->near_copies > 1)
 		seq_printf(seq, " %d near-copies", conf->near_copies);
 	if (conf->far_copies > 1) {
@@ -2050,8 +2050,8 @@ static int run(mddev_t *mddev)
 	int nc, fc, fo;
 	sector_t stride, size;
 
-	if (mddev->chunk_size < PAGE_SIZE ||
-	    !is_power_of_2(mddev->chunk_size)) {
+	if (mddev->chunk_sectors << 9 < PAGE_SIZE ||
+	    !is_power_of_2(mddev->chunk_sectors)) {
 		printk(KERN_ERR "md/raid10: chunk size must be "
 		       "at least PAGE_SIZE(%ld) and be a power of 2.\n", PAGE_SIZE);
 		return -EINVAL;
@@ -2096,8 +2096,8 @@ static int run(mddev_t *mddev)
 	conf->far_copies = fc;
 	conf->copies = nc*fc;
 	conf->far_offset = fo;
-	conf->chunk_mask = (sector_t)(mddev->chunk_size>>9)-1;
-	conf->chunk_shift = ffz(~mddev->chunk_size) - 9;
+	conf->chunk_mask = mddev->chunk_sectors - 1;
+	conf->chunk_shift = ffz(~mddev->chunk_sectors);
 	size = mddev->dev_sectors >> conf->chunk_shift;
 	sector_div(size, fc);
 	size = size * conf->raid_disks;
@@ -2205,7 +2205,8 @@ static int run(mddev_t *mddev)
 	 * maybe...
 	 */
 	{
-		int stripe = conf->raid_disks * (mddev->chunk_size / PAGE_SIZE);
+		int stripe = conf->raid_disks *
+			((mddev->chunk_sectors << 9) / PAGE_SIZE);
 		stripe /= conf->near_copies;
 		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4c9e602..85653e5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3352,13 +3352,13 @@ static int raid5_mergeable_bvec(struct request_queue *q,
 	mddev_t *mddev = q->queuedata;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
 	int max;
-	unsigned int chunk_sectors = mddev->chunk_size >> 9;
+	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
 
 	if ((bvm->bi_rw & 1) == WRITE)
 		return biovec->bv_len; /* always allow writes to be mergeable */
 
-	if (mddev->new_chunk < mddev->chunk_size)
+	if (mddev->new_chunk < mddev->chunk_sectors << 9)
 		chunk_sectors = mddev->new_chunk >> 9;
 	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
 	if (max < 0) max = 0;
@@ -3372,10 +3372,10 @@ static int raid5_mergeable_bvec(struct request_queue *q,
 static int in_chunk_boundary(mddev_t *mddev, struct bio *bio)
 {
 	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
-	unsigned int chunk_sectors = mddev->chunk_size >> 9;
+	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bio->bi_size >> 9;
 
-	if (mddev->new_chunk < mddev->chunk_size)
+	if (mddev->new_chunk < mddev->chunk_sectors << 9)
 		chunk_sectors = mddev->new_chunk >> 9;
 	return  chunk_sectors >=
 		((sector & (chunk_sectors - 1)) + bio_sectors);
@@ -3791,10 +3791,10 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 * If old and new chunk sizes differ, we need to process the
 	 * largest of these
 	 */
-	if (mddev->new_chunk > mddev->chunk_size)
+	if (mddev->new_chunk > mddev->chunk_sectors << 9)
 		reshape_sectors = mddev->new_chunk / 512;
 	else
-		reshape_sectors = mddev->chunk_size / 512;
+		reshape_sectors = mddev->chunk_sectors;
 
 	/* we update the metadata when there is more than 3Meg
 	 * in the block range (that is rather arbitrary, should
@@ -4303,7 +4303,7 @@ raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 			raid_disks = conf->previous_raid_disks;
 	}
 
-	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
+	sectors &= ~(mddev->chunk_sectors - 1);
 	sectors &= ~((sector_t)mddev->new_chunk/512 - 1);
 	return sectors * (raid_disks - conf->max_degraded);
 }
@@ -4412,7 +4412,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	conf->max_nr_stripes = NR_STRIPES;
 	conf->reshape_progress = mddev->reshape_position;
 	if (conf->reshape_progress != MaxSector) {
-		conf->prev_chunk = mddev->chunk_size;
+		conf->prev_chunk = mddev->chunk_sectors << 9;
 		conf->prev_algo = mddev->layout;
 	}
 
@@ -4484,7 +4484,7 @@ static int run(mddev_t *mddev)
 		}
 		/* here_new is the stripe we will write to */
 		here_old = mddev->reshape_position;
-		sector_div(here_old, (mddev->chunk_size>>9)*
+		sector_div(here_old, mddev->chunk_sectors *
 			   (old_disks-max_degraded));
 		/* here_old is the first stripe that we might need to read
 		 * from */
@@ -4499,7 +4499,7 @@ static int run(mddev_t *mddev)
 	} else {
 		BUG_ON(mddev->level != mddev->new_level);
 		BUG_ON(mddev->layout != mddev->new_layout);
-		BUG_ON(mddev->chunk_size != mddev->new_chunk);
+		BUG_ON(mddev->chunk_sectors << 9 != mddev->new_chunk);
 		BUG_ON(mddev->delta_disks != 0);
 	}
 
@@ -4533,7 +4533,7 @@ static int run(mddev_t *mddev)
 	}
 
 	/* device size must be a multiple of chunk size */
-	mddev->dev_sectors &= ~(mddev->chunk_size / 512 - 1);
+	mddev->dev_sectors &= ~(mddev->chunk_sectors - 1);
 	mddev->resync_max_sectors = mddev->dev_sectors;
 
 	if (mddev->degraded > 0 &&
@@ -4582,7 +4582,7 @@ static int run(mddev_t *mddev)
 	{
 		int data_disks = conf->previous_raid_disks - conf->max_degraded;
 		int stripe = data_disks *
-			(mddev->chunk_size / PAGE_SIZE);
+			((mddev->chunk_sectors << 9) / PAGE_SIZE);
 		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
 	}
@@ -4679,7 +4679,8 @@ static void status(struct seq_file *seq, mddev_t *mddev)
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	int i;
 
-	seq_printf (seq, " level %d, %dk chunk, algorithm %d", mddev->level, mddev->chunk_size >> 10, mddev->layout);
+	seq_printf(seq, " level %d, %dk chunk, algorithm %d", mddev->level,
+		(int)mddev->chunk_sectors / 2, mddev->layout);
 	seq_printf (seq, " [%d/%d] [", conf->raid_disks, conf->raid_disks - mddev->degraded);
 	for (i = 0; i < conf->raid_disks; i++)
 		seq_printf (seq, "%s",
@@ -4827,7 +4828,7 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
-	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
+	sectors &= ~(mddev->chunk_sectors - 1);
 	md_set_array_sectors(mddev, raid5_size(mddev, sectors,
 					       mddev->raid_disks));
 	if (mddev->array_sectors >
@@ -4850,7 +4851,7 @@ static int raid5_check_reshape(mddev_t *mddev)
 
 	if (mddev->delta_disks == 0 &&
 	    mddev->new_layout == mddev->layout &&
-	    mddev->new_chunk == mddev->chunk_size)
+	    mddev->new_chunk == mddev->chunk_sectors << 9)
 		return -EINVAL; /* nothing to do */
 	if (mddev->bitmap)
 		/* Cannot grow a bitmap yet */
@@ -4878,10 +4879,11 @@ static int raid5_check_reshape(mddev_t *mddev)
 	 * If the chunk size is greater, user-space should request more
 	 * stripe_heads first.
 	 */
-	if ((mddev->chunk_size / STRIPE_SIZE) * 4 > conf->max_nr_stripes ||
+	if (((mddev->chunk_sectors << 9) / STRIPE_SIZE) * 4
+		> conf->max_nr_stripes ||
 	    (mddev->new_chunk / STRIPE_SIZE) * 4 > conf->max_nr_stripes) {
 		printk(KERN_WARNING "raid5: reshape: not enough stripes.  Needed %lu\n",
-		       (max(mddev->chunk_size, mddev->new_chunk)
+		       (max((int)mddev->chunk_sectors << 9, mddev->new_chunk)
 			/ STRIPE_SIZE)*4);
 		return -ENOSPC;
 	}
@@ -5054,7 +5056,7 @@ static void raid5_finish_reshape(mddev_t *mddev)
 				raid5_remove_disk(mddev, d);
 		}
 		mddev->layout = conf->algorithm;
-		mddev->chunk_size = conf->chunk_size;
+		mddev->chunk_sectors = conf->chunk_size >> 9;
 		mddev->reshape_position = MaxSector;
 		mddev->delta_disks = 0;
 	}
@@ -5183,7 +5185,8 @@ static int raid5_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
 		}
 		if (new_chunk > 0) {
 			conf->chunk_size = new_chunk;
-			mddev->chunk_size = mddev->new_chunk = new_chunk;
+			mddev->new_chunk = new_chunk;
+			mddev->chunk_sectors = new_chunk >> 9;
 		}
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		md_wakeup_thread(mddev->thread);
-- 
1.5.4.3

