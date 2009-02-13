From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] md: 'size_limit' attribute
Date: Fri, 13 Feb 2009 11:30:11 -0700
Message-ID: <1234549811.26769.7.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids

Subject: md: 'size_limit' attribute
From: Dan Williams <dan.j.williams@intel.com>

Provide a sysfs attribute to allow a raid array to be truncated to an
arbitrary size.  This functionality is needed to support imsm raid
arrays where the metadata format expects that the size of some arrays is
rounded down to the nearest 1MB boundary.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/linear.c       |    2 +
 drivers/md/md.c           |   64 +++++++++++++++++++++++++++++++++++----------
 drivers/md/raid0.c        |    2 +
 drivers/md/raid1.c        |    2 +
 drivers/md/raid5.c        |    6 ++--
 include/linux/raid/md.h   |    1 +
 include/linux/raid/md_k.h |    1 +
 7 files changed, 58 insertions(+), 20 deletions(-)

Also available here:

   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git for-neil

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 09658b2..55e5520 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -284,7 +284,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 	mddev->private = newconf;
 	mddev->raid_disks++;
 	mddev->array_sectors = newconf->array_sectors;
-	set_capacity(mddev->gendisk, mddev->array_sectors);
+	set_capacity(mddev->gendisk, md_array_sectors(mddev));
 	return 0;
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4495104..d25d178 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -319,6 +319,7 @@ static mddev_t * mddev_find(dev_t unit)
 	init_waitqueue_head(&new->sb_wait);
 	init_waitqueue_head(&new->recovery_wait);
 	new->reshape_position = MaxSector;
+	new->size_limit = MaxSector;
 	new->resync_min = 0;
 	new->resync_max = MaxSector;
 	new->level = LEVEL_NONE;
@@ -2694,6 +2695,43 @@ resync_start_store(mddev_t *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_resync_start =
 __ATTR(resync_start, S_IRUGO|S_IWUSR, resync_start_show, resync_start_store);
 
+static ssize_t size_limit_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%llu\n", (unsigned long long)mddev->size_limit);
+}
+
+static void update_array_sectors(mddev_t *mddev)
+{
+	struct block_device *bdev;
+
+	bdev = bdget_disk(mddev->gendisk, 0);
+	if (bdev) {
+		mutex_lock(&bdev->bd_inode->i_mutex);
+		i_size_write(bdev->bd_inode,
+			     (loff_t)md_array_sectors(mddev) << 9);
+		mutex_unlock(&bdev->bd_inode->i_mutex);
+		bdput(bdev);
+	}
+}
+
+static ssize_t size_limit_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	unsigned long long limit;
+
+	if (strict_strtoull(buf, 10, &limit) < 0)
+		return -EINVAL;
+
+	mddev->size_limit = limit;
+	set_capacity(mddev->gendisk, md_array_sectors(mddev));
+	if (mddev->pers)
+		update_array_sectors(mddev);
+
+	return len;
+}
+
+static struct md_sysfs_entry md_size_limit =
+__ATTR(size_limit, S_IRUGO|S_IWUSR, size_limit_show, size_limit_store);
+
 /*
  * The array state can be:
  *
@@ -3449,6 +3487,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_safe_delay.attr,
 	&md_array_state.attr,
 	&md_reshape_position.attr,
+	&md_size_limit.attr,
 	NULL,
 };
 
@@ -3676,6 +3715,12 @@ static void md_safemode_timeout(unsigned long data)
 
 static int start_dirty_degraded;
 
+sector_t md_array_sectors(mddev_t *mddev)
+{
+	return min(mddev->size_limit, mddev->array_sectors);
+}
+EXPORT_SYMBOL(md_array_sectors);
+
 static int do_md_run(mddev_t * mddev)
 {
 	int err;
@@ -3887,7 +3932,7 @@ static int do_md_run(mddev_t * mddev)
 	if (mddev->flags)
 		md_update_sb(mddev, 0);
 
-	set_capacity(disk, mddev->array_sectors);
+	set_capacity(disk, md_array_sectors(mddev));
 
 	/* If we call blk_queue_make_request here, it will
 	 * re-initialise max_sectors etc which may have been
@@ -4095,6 +4140,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		mddev->resync_min = 0;
 		mddev->resync_max = MaxSector;
 		mddev->reshape_position = MaxSector;
+		mddev->size_limit = MaxSector;
 		mddev->external = 0;
 		mddev->persistent = 0;
 		mddev->level = LEVEL_NONE;
@@ -4817,18 +4863,8 @@ static int update_size(mddev_t *mddev, sector_t num_sectors)
 			return -ENOSPC;
 	}
 	rv = mddev->pers->resize(mddev, num_sectors);
-	if (!rv) {
-		struct block_device *bdev;
-
-		bdev = bdget_disk(mddev->gendisk, 0);
-		if (bdev) {
-			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode,
-				     (loff_t)mddev->array_sectors << 9);
-			mutex_unlock(&bdev->bd_inode->i_mutex);
-			bdput(bdev);
-		}
-	}
+	if (!rv)
+		update_array_sectors(mddev);
 	return rv;
 }
 
@@ -5586,7 +5622,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 			if (mddev->pers)
 				seq_printf(seq, "\n      %llu blocks",
 					   (unsigned long long)
-					   mddev->array_sectors / 2);
+					   md_array_sectors(mddev) / 2);
 			else
 				seq_printf(seq, "\n      %llu blocks",
 					   (unsigned long long)size);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c605ba8..4eee081 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -296,7 +296,7 @@ static int raid0_run (mddev_t *mddev)
 		mddev->array_sectors += rdev->size * 2;
 
 	printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
-		(unsigned long long)mddev->array_sectors);
+		(unsigned long long)md_array_sectors(mddev));
 	printk(KERN_INFO "raid0 : conf->spacing is %llu sectors.\n",
 		(unsigned long long)conf->spacing);
 	{
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 01e3cff..045d66c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2110,7 +2110,7 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	 * worth it.
 	 */
 	mddev->array_sectors = sectors;
-	set_capacity(mddev->gendisk, mddev->array_sectors);
+	set_capacity(mddev->gendisk, md_array_sectors(mddev));
 	mddev->changed = 1;
 	if (mddev->array_sectors / 2 > mddev->size &&
 	    mddev->recovery_cp == MaxSector) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a5ba080..4262176 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4477,7 +4477,7 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
 	mddev->array_sectors = sectors * (mddev->raid_disks
 					  - conf->max_degraded);
-	set_capacity(mddev->gendisk, mddev->array_sectors);
+	set_capacity(mddev->gendisk, md_array_sectors(mddev));
 	mddev->changed = 1;
 	if (sectors/2  > mddev->size && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->size << 1;
@@ -4614,14 +4614,14 @@ static void end_reshape(raid5_conf_t *conf)
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
 		conf->mddev->array_sectors = 2 * conf->mddev->size *
 			(conf->raid_disks - conf->max_degraded);
-		set_capacity(conf->mddev->gendisk, conf->mddev->array_sectors);
+		set_capacity(conf->mddev->gendisk, md_array_sectors(conf->mddev));
 		conf->mddev->changed = 1;
 
 		bdev = bdget_disk(conf->mddev->gendisk, 0);
 		if (bdev) {
 			mutex_lock(&bdev->bd_inode->i_mutex);
 			i_size_write(bdev->bd_inode,
-				     (loff_t)conf->mddev->array_sectors << 9);
+				     (loff_t)md_array_sectors(conf->mddev) << 9);
 			mutex_unlock(&bdev->bd_inode->i_mutex);
 			bdput(bdev);
 		}
diff --git a/include/linux/raid/md.h b/include/linux/raid/md.h
index 82bea14..d489835 100644
--- a/include/linux/raid/md.h
+++ b/include/linux/raid/md.h
@@ -75,6 +75,7 @@ extern void md_do_sync(mddev_t *mddev);
 extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
+extern sector_t md_array_sectors(mddev_t *mddev);
 
 #endif /* CONFIG_MD */
 #endif 
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 9743e4d..fcea4ca 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -157,6 +157,7 @@ struct mddev_s
 	int				max_disks;
 	sector_t			size; /* used size of component devices */
 	sector_t			array_sectors; /* exported array size */
+	sector_t			size_limit; /* limit for array_sectors */
 	__u64				events;
 
 	char				uuid[16];


