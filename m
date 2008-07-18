From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 3/4] md: Make mddev->array_size sector-based.
Date: Fri, 18 Jul 2008 14:00:18 +0200
Message-ID: <1216382419-2560-4-git-send-email-maan@systemlinux.org>
References: <1216382419-2560-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216382419-2560-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

This patch renames the array_size field of struct mddev_s to array_sectors
and converts all instances to use units of 512 byte sectors instead of 1k
blocks.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/faulty.c       |    2 +-
 drivers/md/linear.c       |    6 +++---
 drivers/md/md.c           |    8 ++++----
 drivers/md/multipath.c    |    2 +-
 drivers/md/raid0.c        |    8 ++++----
 drivers/md/raid1.c        |   10 +++++-----
 drivers/md/raid10.c       |    2 +-
 drivers/md/raid5.c        |   14 +++++++-------
 include/linux/raid/md_k.h |    2 +-
 9 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index d107ddc..268547d 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -297,7 +297,7 @@ static int run(mddev_t *mddev)
 	rdev_for_each(rdev, tmp, mddev)
 		conf->rdev = rdev;
 
-	mddev->array_size = mddev->size;
+	mddev->array_sectors = mddev->size * 2;
 	mddev->private = conf;
 
 	reconfig(mddev, mddev->layout, -1);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index ec921f5..57644a7 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -256,7 +256,7 @@ static int linear_run (mddev_t *mddev)
 	if (!conf)
 		return 1;
 	mddev->private = conf;
-	mddev->array_size = conf->array_size;
+	mddev->array_sectors = conf->array_size * 2;
 
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->unplug_fn = linear_unplug;
@@ -290,8 +290,8 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 	newconf->prev = mddev_to_conf(mddev);
 	mddev->private = newconf;
 	mddev->raid_disks++;
-	mddev->array_size = newconf->array_size;
-	set_capacity(mddev->gendisk, mddev->array_size << 1);
+	mddev->array_sectors = newconf->array_size * 2;
+	set_capacity(mddev->gendisk, mddev->array_sectors);
 	return 0;
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c8673f4..ba99af4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3703,7 +3703,7 @@ static int do_md_run(mddev_t * mddev)
 	if (mddev->flags)
 		md_update_sb(mddev, 0);
 
-	set_capacity(disk, mddev->array_size<<1);
+	set_capacity(disk, mddev->array_sectors);
 
 	/* If we call blk_queue_make_request here, it will
 	 * re-initialise max_sectors etc which may have been
@@ -3904,7 +3904,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 
 		export_array(mddev);
 
-		mddev->array_size = 0;
+		mddev->array_sectors = 0;
 		mddev->size = 0;
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
@@ -4643,7 +4643,7 @@ static int update_size(mddev_t *mddev, sector_t num_sectors)
 		bdev = bdget_disk(mddev->gendisk, 0);
 		if (bdev) {
 			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode, (loff_t)mddev->array_size << 10);
+			i_size_write(bdev->bd_inode, (loff_t)mddev->array_sectors << 9);
 			mutex_unlock(&bdev->bd_inode->i_mutex);
 			bdput(bdev);
 		}
@@ -5390,7 +5390,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		if (!list_empty(&mddev->disks)) {
 			if (mddev->pers)
 				seq_printf(seq, "\n      %llu blocks",
-					(unsigned long long)mddev->array_size);
+					(unsigned long long)mddev->array_sectors / 2);
 			else
 				seq_printf(seq, "\n      %llu blocks",
 					(unsigned long long)size);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 541cbe3..c4779cc 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -504,7 +504,7 @@ static int multipath_run (mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_size = mddev->size;
+	mddev->array_sectors = mddev->size * 2;
 
 	mddev->queue->unplug_fn = multipath_unplug;
 	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 914c04d..2f30ebd 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -293,16 +293,16 @@ static int raid0_run (mddev_t *mddev)
 		goto out_free_conf;
 
 	/* calculate array device size */
-	mddev->array_size = 0;
+	mddev->array_sectors = 0;
 	rdev_for_each(rdev, tmp, mddev)
-		mddev->array_size += rdev->size;
+		mddev->array_sectors += rdev->size * 2;
 
 	printk("raid0 : md_size is %llu blocks.\n", 
-		(unsigned long long)mddev->array_size);
+		(unsigned long long)mddev->array_sectors / 2);
 	printk("raid0 : conf->hash_spacing is %llu blocks.\n",
 		(unsigned long long)conf->hash_spacing);
 	{
-		sector_t s = mddev->array_size;
+		sector_t s = mddev->array_sectors / 2;
 		sector_t space = conf->hash_spacing;
 		int round;
 		conf->preshift = 0;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 491dc2d..fc5b44b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2043,7 +2043,7 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_size = mddev->size;
+	mddev->array_sectors = mddev->size * 2;
 
 	mddev->queue->unplug_fn = raid1_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
@@ -2105,14 +2105,14 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
-	mddev->array_size = sectors>>1;
-	set_capacity(mddev->gendisk, mddev->array_size << 1);
+	mddev->array_sectors = sectors;
+	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
-	if (mddev->array_size > mddev->size && mddev->recovery_cp == MaxSector) {
+	if (mddev->array_sectors / 2 > mddev->size && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->size << 1;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
-	mddev->size = mddev->array_size;
+	mddev->size = mddev->array_sectors / 2;
 	mddev->resync_max_sectors = sectors;
 	return 0;
 }
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index df08a9f..2acea40 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2164,7 +2164,7 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_size = size << (conf->chunk_shift-1);
+	mddev->array_sectors = size << conf->chunk_shift;
 	mddev->resync_max_sectors = size << conf->chunk_shift;
 
 	mddev->queue->unplug_fn = raid10_unplug;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8f4c70a..1e1a217 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3540,7 +3540,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 			    j == raid6_next_disk(sh->pd_idx, sh->disks))
 				continue;
 			s = compute_blocknr(sh, j);
-			if (s < (mddev->array_size<<1)) {
+			if (s < mddev->array_sectors) {
 				skipped = 1;
 				continue;
 			}
@@ -4189,7 +4189,7 @@ static int run(mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_data = mddev;
 	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 
-	mddev->array_size =  mddev->size * (conf->previous_raid_disks -
+	mddev->array_sectors = 2 * mddev->size * (conf->previous_raid_disks -
 					    conf->max_degraded);
 
 	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
@@ -4413,8 +4413,8 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
-	mddev->array_size = (sectors * (mddev->raid_disks-conf->max_degraded))>>1;
-	set_capacity(mddev->gendisk, mddev->array_size << 1);
+	mddev->array_sectors = sectors * mddev->raid_disks-conf->max_degraded;
+	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
 	if (sectors/2  > mddev->size && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->size << 1;
@@ -4547,15 +4547,15 @@ static void end_reshape(raid5_conf_t *conf)
 	struct block_device *bdev;
 
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
-		conf->mddev->array_size = conf->mddev->size *
+		conf->mddev->array_sectors = 2 * conf->mddev->size *
 			(conf->raid_disks - conf->max_degraded);
-		set_capacity(conf->mddev->gendisk, conf->mddev->array_size << 1);
+		set_capacity(conf->mddev->gendisk, conf->mddev->array_sectors);
 		conf->mddev->changed = 1;
 
 		bdev = bdget_disk(conf->mddev->gendisk, 0);
 		if (bdev) {
 			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode, (loff_t)conf->mddev->array_size << 10);
+			i_size_write(bdev->bd_inode, (loff_t)conf->mddev->array_sectors << 9);
 			mutex_unlock(&bdev->bd_inode->i_mutex);
 			bdput(bdev);
 		}
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index e37aaa4..6f72b47 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -150,7 +150,7 @@ struct mddev_s
 	int				raid_disks;
 	int				max_disks;
 	sector_t			size; /* used size of component devices */
-	sector_t			array_size; /* exported array size */
+	sector_t			array_sectors; /* exported array size */
 	__u64				events;
 
 	char				uuid[16];
-- 
1.5.3.8

