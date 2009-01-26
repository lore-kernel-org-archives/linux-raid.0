From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 1/2] md: Make mddev->size sector-based.
Date: Mon, 26 Jan 2009 16:14:11 +0100
Message-ID: <1232982852-32747-2-git-send-email-maan@systemlinux.org>
References: <1232982852-32747-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1232982852-32747-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

This patch renames the "size" field of struct mddev_s to "dev_sectors"
and stores the number of 512-byte sectors instead of the number of
1K-blocks in it.

All users of that field, including raid levels 1,4-6,10, are adjusted
accordingly. This simplifies the code a bit because it allows to get
rid of a couple of divisions/multiplications by two.

In order to make checkpatch happy, some minor coding style issues
have also been addressed. In particular, size_store() now uses
strict_strtoull() instead of simple_strtoull().

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/bitmap.c       |    2 +-
 drivers/md/faulty.c       |    2 +-
 drivers/md/md.c           |   97 ++++++++++++++++++++++++--------------------
 drivers/md/multipath.c    |    2 +-
 drivers/md/raid1.c        |   10 ++--
 drivers/md/raid10.c       |    6 +-
 drivers/md/raid5.c        |   24 ++++++------
 include/linux/raid/md_k.h |    3 +-
 8 files changed, 78 insertions(+), 68 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 7199437..56a941a 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -297,7 +297,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 				    + size/512 > 0)
 					/* bitmap runs in to metadata */
 					goto bad_alignment;
-				if (rdev->data_offset + mddev->size*2
+				if (rdev->data_offset + mddev->dev_sectors
 				    > rdev->sb_start + bitmap->offset)
 					/* data runs in to bitmap */
 					goto bad_alignment;
diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 86d9adf..b3b0437 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -298,7 +298,7 @@ static int run(mddev_t *mddev)
 	list_for_each_entry(rdev, &mddev->disks, same_set)
 		conf->rdev = rdev;
 
-	mddev->array_sectors = mddev->size * 2;
+	mddev->array_sectors = mddev->dev_sectors;
 	mddev->private = conf;
 
 	reconfig(mddev, mddev->layout, -1);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 41e2509..4e04804 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -817,7 +817,7 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 		mddev->clevel[0] = 0;
 		mddev->layout = sb->layout;
 		mddev->raid_disks = sb->raid_disks;
-		mddev->size = sb->size;
+		mddev->dev_sectors = sb->size * 2;
 		mddev->events = ev1;
 		mddev->bitmap_offset = 0;
 		mddev->default_bitmap_offset = MD_SB_BYTES >> 9;
@@ -931,7 +931,7 @@ static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 
 	sb->ctime = mddev->ctime;
 	sb->level = mddev->level;
-	sb->size  = mddev->size;
+	sb->size = mddev->dev_sectors / 2;
 	sb->raid_disks = mddev->raid_disks;
 	sb->md_minor = mddev->md_minor;
 	sb->not_persistent = 0;
@@ -1029,7 +1029,7 @@ static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 static unsigned long long
 super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 {
-	if (num_sectors && num_sectors < rdev->mddev->size * 2)
+	if (num_sectors && num_sectors < rdev->mddev->dev_sectors)
 		return 0; /* component must fit device */
 	if (rdev->mddev->bitmap_offset)
 		return 0; /* can't move bitmap */
@@ -1221,7 +1221,7 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 		mddev->clevel[0] = 0;
 		mddev->layout = le32_to_cpu(sb->layout);
 		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
-		mddev->size = le64_to_cpu(sb->size)/2;
+		mddev->dev_sectors = le64_to_cpu(sb->size);
 		mddev->events = ev1;
 		mddev->bitmap_offset = 0;
 		mddev->default_bitmap_offset = 1024 >> 9;
@@ -1317,7 +1317,7 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 	sb->cnt_corrected_read = cpu_to_le32(atomic_read(&rdev->corrected_errors));
 
 	sb->raid_disks = cpu_to_le32(mddev->raid_disks);
-	sb->size = cpu_to_le64(mddev->size<<1);
+	sb->size = cpu_to_le64(mddev->dev_sectors);
 
 	if (mddev->bitmap && mddev->bitmap_file == NULL) {
 		sb->bitmap_offset = cpu_to_le32((__u32)mddev->bitmap_offset);
@@ -1370,7 +1370,7 @@ super_1_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 {
 	struct mdp_superblock_1 *sb;
 	sector_t max_sectors;
-	if (num_sectors && num_sectors < rdev->mddev->size * 2)
+	if (num_sectors && num_sectors < rdev->mddev->dev_sectors)
 		return 0; /* component must fit device */
 	if (rdev->sb_start < rdev->data_offset) {
 		/* minor versions 1 and 2; superblock before data */
@@ -1454,8 +1454,9 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 	if (find_rdev(mddev, rdev->bdev->bd_dev))
 		return -EEXIST;
 
-	/* make sure rdev->size exceeds mddev->size */
-	if (rdev->size && (mddev->size == 0 || rdev->size < mddev->size)) {
+	/* make sure rdev->size exceeds mddev->dev_sectors / 2 */
+	if (rdev->size && (mddev->dev_sectors == 0 ||
+			rdev->size < mddev->dev_sectors / 2)) {
 		if (mddev->pers) {
 			/* Cannot change size, so fail
 			 * If mddev->level <= 0, then we don't care
@@ -1464,7 +1465,7 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 			if (mddev->level > 0)
 				return -ENOSPC;
 		} else
-			mddev->size = rdev->size;
+			mddev->dev_sectors = rdev->size * 2;
 	}
 
 	/* Verify rdev->desc_nr is unique.
@@ -2200,7 +2201,7 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 			size -= rdev->data_offset/2;
 		}
 	}
-	if (size < my_mddev->size)
+	if (size < my_mddev->dev_sectors / 2)
 		return -EINVAL; /* component must fit device */
 
 	rdev->size = size;
@@ -2757,7 +2758,7 @@ array_state_show(mddev_t *mddev, char *page)
 	else {
 		if (list_empty(&mddev->disks) &&
 		    mddev->raid_disks == 0 &&
-		    mddev->size == 0)
+		    mddev->dev_sectors == 0)
 			st = clear;
 		else
 			st = inactive;
@@ -2964,7 +2965,8 @@ __ATTR(bitmap_set_bits, S_IWUSR, null_show, bitmap_store);
 static ssize_t
 size_show(mddev_t *mddev, char *page)
 {
-	return sprintf(page, "%llu\n", (unsigned long long)mddev->size);
+	return sprintf(page, "%llu\n",
+		(unsigned long long)mddev->dev_sectors / 2);
 }
 
 static int update_size(mddev_t *mddev, sector_t num_sectors);
@@ -2976,20 +2978,19 @@ size_store(mddev_t *mddev, const char *buf, size_t len)
 	 * not increase it (except from 0).
 	 * If array is active, we can try an on-line resize
 	 */
-	char *e;
-	int err = 0;
-	unsigned long long size = simple_strtoull(buf, &e, 10);
-	if (!*buf || *buf == '\n' ||
-	    (*e && *e != '\n'))
-		return -EINVAL;
+	unsigned long long sectors;
+	int err = strict_strtoull(buf, 10, &sectors);
 
+	if (err < 0)
+		return err;
+	sectors *= 2;
 	if (mddev->pers) {
-		err = update_size(mddev, size * 2);
+		err = update_size(mddev, sectors);
 		md_update_sb(mddev, 1);
 	} else {
-		if (mddev->size == 0 ||
-		    mddev->size > size)
-			mddev->size = size;
+		if (mddev->dev_sectors == 0 ||
+		    mddev->dev_sectors > sectors)
+			mddev->dev_sectors = sectors;
 		else
 			err = -ENOSPC;
 	}
@@ -3254,15 +3255,15 @@ static struct md_sysfs_entry md_sync_speed = __ATTR_RO(sync_speed);
 static ssize_t
 sync_completed_show(mddev_t *mddev, char *page)
 {
-	unsigned long max_blocks, resync;
+	unsigned long max_sectors, resync;
 
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
-		max_blocks = mddev->resync_max_sectors;
+		max_sectors = mddev->resync_max_sectors;
 	else
-		max_blocks = mddev->size << 1;
+		max_sectors = mddev->dev_sectors;
 
 	resync = (mddev->curr_resync - atomic_read(&mddev->recovery_active));
-	return sprintf(page, "%lu / %lu\n", resync, max_blocks);
+	return sprintf(page, "%lu / %lu\n", resync, max_sectors);
 }
 
 static struct md_sysfs_entry md_sync_completed = __ATTR_RO(sync_completed);
@@ -3737,11 +3738,11 @@ static int do_md_run(mddev_t * mddev)
 
 		/* perform some consistency tests on the device.
 		 * We don't want the data to overlap the metadata,
-		 * Internal Bitmap issues has handled elsewhere.
+		 * Internal Bitmap issues have been handled elsewhere.
 		 */
 		if (rdev->data_offset < rdev->sb_start) {
-			if (mddev->size &&
-			    rdev->data_offset + mddev->size*2
+			if (mddev->dev_sectors &&
+			    rdev->data_offset + mddev->dev_sectors
 			    > rdev->sb_start) {
 				printk("md: %s: data overlaps metadata\n",
 				       mdname(mddev));
@@ -3819,7 +3820,9 @@ static int do_md_run(mddev_t * mddev)
 	}
 
 	mddev->recovery = 0;
-	mddev->resync_max_sectors = mddev->size << 1; /* may be over-ridden by personality */
+	/* may be over-ridden by personality */
+	mddev->resync_max_sectors = mddev->dev_sectors;
+
 	mddev->barriers_work = 1;
 	mddev->ok_start_degraded = start_dirty_degraded;
 
@@ -4075,7 +4078,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		export_array(mddev);
 
 		mddev->array_sectors = 0;
-		mddev->size = 0;
+		mddev->dev_sectors = 0;
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
 		mddev->resync_min = 0;
@@ -4280,8 +4283,8 @@ static int get_array_info(mddev_t * mddev, void __user * arg)
 	info.patch_version = MD_PATCHLEVEL_VERSION;
 	info.ctime         = mddev->ctime;
 	info.level         = mddev->level;
-	info.size          = mddev->size;
-	if (info.size != mddev->size) /* overflow */
+	info.size          = mddev->dev_sectors / 2;
+	if (info.size != mddev->dev_sectors / 2) /* overflow */
 		info.size = -1;
 	info.nr_disks      = nr;
 	info.raid_disks    = mddev->raid_disks;
@@ -4739,7 +4742,7 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 
 	mddev->level         = info->level;
 	mddev->clevel[0]     = 0;
-	mddev->size          = info->size;
+	mddev->dev_sectors   = 2 * (sector_t)info->size;
 	mddev->raid_disks    = info->raid_disks;
 	/* don't set md_minor, it is determined by which /dev/md* was
 	 * openned
@@ -4877,12 +4880,18 @@ static int update_array_info(mddev_t *mddev, mdu_array_info_t *info)
 		)
 		return -EINVAL;
 	/* Check there is only one change */
-	if (info->size >= 0 && mddev->size != info->size) cnt++;
-	if (mddev->raid_disks != info->raid_disks) cnt++;
-	if (mddev->layout != info->layout) cnt++;
-	if ((state ^ info->state) & (1<<MD_SB_BITMAP_PRESENT)) cnt++;
-	if (cnt == 0) return 0;
-	if (cnt > 1) return -EINVAL;
+	if (info->size >= 0 && mddev->dev_sectors / 2 != info->size)
+		cnt++;
+	if (mddev->raid_disks != info->raid_disks)
+		cnt++;
+	if (mddev->layout != info->layout)
+		cnt++;
+	if ((state ^ info->state) & (1<<MD_SB_BITMAP_PRESENT))
+		cnt++;
+	if (cnt == 0)
+		return 0;
+	if (cnt > 1)
+		return -EINVAL;
 
 	if (mddev->layout != info->layout) {
 		/* Change layout
@@ -4894,7 +4903,7 @@ static int update_array_info(mddev_t *mddev, mdu_array_info_t *info)
 		else
 			return mddev->pers->reconfig(mddev, info->layout, -1);
 	}
-	if (info->size >= 0 && mddev->size != info->size)
+	if (info->size >= 0 && mddev->dev_sectors / 2 != info->size)
 		rv = update_size(mddev, (sector_t)info->size * 2);
 
 	if (mddev->raid_disks    != info->raid_disks)
@@ -5394,7 +5403,7 @@ static void status_resync(struct seq_file *seq, mddev_t * mddev)
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 		max_blocks = mddev->resync_max_sectors >> 1;
 	else
-		max_blocks = mddev->size;
+		max_blocks = mddev->dev_sectors / 2;
 
 	/*
 	 * Should not happen.
@@ -5970,10 +5979,10 @@ void md_do_sync(mddev_t *mddev)
 			j = mddev->recovery_cp;
 
 	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
-		max_sectors = mddev->size << 1;
+		max_sectors = mddev->dev_sectors;
 	else {
 		/* recovery follows the physical size of devices */
-		max_sectors = mddev->size << 1;
+		max_sectors = mddev->dev_sectors;
 		j = MaxSector;
 		list_for_each_entry(rdev, &mddev->disks, same_set)
 			if (rdev->raid_disk >= 0 &&
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index f6d08f2..a21084b 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -498,7 +498,7 @@ static int multipath_run (mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = mddev->size * 2;
+	mddev->array_sectors = mddev->dev_sectors;
 
 	mddev->queue->unplug_fn = multipath_unplug;
 	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7b4f5f7..7b73bc9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1721,7 +1721,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 			return 0;
 	}
 
-	max_sector = mddev->size << 1;
+	max_sector = mddev->dev_sectors;
 	if (sector_nr >= max_sector) {
 		/* If we aborted, we need to abort the
 		 * sync on the 'current' bitmap chunk (there will
@@ -2046,7 +2046,7 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = mddev->size * 2;
+	mddev->array_sectors = mddev->dev_sectors;
 
 	mddev->queue->unplug_fn = raid1_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
@@ -2111,12 +2111,12 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	mddev->array_sectors = sectors;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
-	if (mddev->array_sectors / 2 > mddev->size &&
+	if (mddev->array_sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp == MaxSector) {
-		mddev->recovery_cp = mddev->size << 1;
+		mddev->recovery_cp = mddev->dev_sectors;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
-	mddev->size = mddev->array_sectors / 2;
+	mddev->dev_sectors = mddev->array_sectors;
 	mddev->resync_max_sectors = sectors;
 	return 0;
 }
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6736d6d..0484c7e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1694,7 +1694,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 			return 0;
 
  skipped:
-	max_sector = mddev->size << 1;
+	max_sector = mddev->dev_sectors;
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 		max_sector = mddev->resync_max_sectors;
 	if (sector_nr >= max_sector) {
@@ -2075,7 +2075,7 @@ static int run(mddev_t *mddev)
 	conf->far_offset = fo;
 	conf->chunk_mask = (sector_t)(mddev->chunk_size>>9)-1;
 	conf->chunk_shift = ffz(~mddev->chunk_size) - 9;
-	size = mddev->size >> (conf->chunk_shift-1);
+	size = mddev->dev_sectors >> conf->chunk_shift;
 	sector_div(size, fc);
 	size = size * conf->raid_disks;
 	sector_div(size, nc);
@@ -2088,7 +2088,7 @@ static int run(mddev_t *mddev)
 	 */
 	stride += conf->raid_disks - 1;
 	sector_div(stride, conf->raid_disks);
-	mddev->size = stride  << (conf->chunk_shift-1);
+	mddev->dev_sectors = stride << conf->chunk_shift;
 
 	if (fo)
 		stride = 1;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a5ba080..99c5261 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3626,8 +3626,8 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 				     *(new_data_disks) -1,
 				     raid_disks, data_disks,
 				     &dd_idx, &pd_idx, conf);
-	if (last_sector >= (mddev->size<<1))
-		last_sector = (mddev->size<<1)-1;
+	if (last_sector >= mddev->dev_sectors)
+		last_sector = mddev->dev_sectors - 1;
 	while (first_sector <= last_sector) {
 		pd_idx = stripe_to_pdidx(first_sector, conf,
 					 conf->previous_raid_disks);
@@ -3667,7 +3667,7 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 	struct stripe_head *sh;
 	int pd_idx;
 	int raid_disks = conf->raid_disks;
-	sector_t max_sector = mddev->size << 1;
+	sector_t max_sector = mddev->dev_sectors;
 	int sync_blocks;
 	int still_degraded = 0;
 	int i;
@@ -3705,7 +3705,7 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 	 */
 	if (mddev->degraded >= conf->max_degraded &&
 	    test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-		sector_t rv = (mddev->size << 1) - sector_nr;
+		sector_t rv = mddev->dev_sectors - sector_nr;
 		*skipped = 1;
 		return rv;
 	}
@@ -4143,8 +4143,8 @@ static int run(mddev_t *mddev)
 	conf->expand_progress = mddev->reshape_position;
 
 	/* device size must be a multiple of chunk size */
-	mddev->size &= ~(mddev->chunk_size/1024 -1);
-	mddev->resync_max_sectors = mddev->size << 1;
+	mddev->dev_sectors &= ~(mddev->chunk_size / 512 - 1);
+	mddev->resync_max_sectors = mddev->dev_sectors;
 
 	if (conf->level == 6 && conf->raid_disks < 4) {
 		printk(KERN_ERR "raid6: not enough configured devices for %s (%d, minimum 4)\n",
@@ -4251,8 +4251,8 @@ static int run(mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_data = mddev;
 	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 
-	mddev->array_sectors = 2 * mddev->size * (conf->previous_raid_disks -
-					    conf->max_degraded);
+	mddev->array_sectors = mddev->dev_sectors *
+		(conf->previous_raid_disks - conf->max_degraded);
 
 	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
 
@@ -4479,11 +4479,11 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 					  - conf->max_degraded);
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
-	if (sectors/2  > mddev->size && mddev->recovery_cp == MaxSector) {
-		mddev->recovery_cp = mddev->size << 1;
+	if (sectors > mddev->dev_sectors && mddev->recovery_cp == MaxSector) {
+		mddev->recovery_cp = mddev->dev_sectors;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
-	mddev->size = sectors /2;
+	mddev->dev_sectors = sectors;
 	mddev->resync_max_sectors = sectors;
 	return 0;
 }
@@ -4612,7 +4612,7 @@ static void end_reshape(raid5_conf_t *conf)
 	struct block_device *bdev;
 
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
-		conf->mddev->array_sectors = 2 * conf->mddev->size *
+		conf->mddev->array_sectors = conf->mddev->dev_sectors *
 			(conf->raid_disks - conf->max_degraded);
 		set_capacity(conf->mddev->gendisk, conf->mddev->array_sectors);
 		conf->mddev->changed = 1;
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 9743e4d..ed2f24b 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -155,7 +155,8 @@ struct mddev_s
 	char				clevel[16];
 	int				raid_disks;
 	int				max_disks;
-	sector_t			size; /* used size of component devices */
+	sector_t			dev_sectors; 	/* used size of
+							 * component devices */
 	sector_t			array_sectors; /* exported array size */
 	__u64				events;
 
-- 
1.5.3.8

