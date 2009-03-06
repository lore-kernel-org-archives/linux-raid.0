From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3/3] md: 'array_size' sysfs attribute
Date: Thu, 05 Mar 2009 17:24:58 -0700
Message-ID: <20090306002458.9882.82188.stgit@dwillia2-linux.ch.intel.com>
References: <20090306002341.9882.61625.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090306002341.9882.61625.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids

Allow userspace to set the size of the array according to the following
semantics:

1/ size must be <= to the size returned by mddev->pers->size(mddev, 0, 0)
   a) If size is set before the array is running, do_md_run will fail
      if size is greater than the default size
   b) A reshape attempt that reduces the default size to less than the set
      array size should be blocked
2/ once userspace sets the size the kernel will not change it
3/ writing 'default' to this attribute returns control of the size to the
   kernel and reverts to the size reported by the personality

Also, convert locations that need to know the default size from directly
reading ->array_sectors to <pers>_size.  Resync/reshape operations
always follow the default size.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/md.c           |   91 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid0.c        |    2 -
 drivers/md/raid1.c        |    6 ++-
 drivers/md/raid10.c       |    2 -
 drivers/md/raid5.c        |   15 +++++--
 include/linux/raid/md.h   |    1 
 include/linux/raid/md_k.h |    1 
 7 files changed, 109 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 031411b..de55758 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -388,6 +388,11 @@ static inline int mddev_lock(mddev_t * mddev)
 	return mutex_lock_interruptible(&mddev->reconfig_mutex);
 }
 
+static inline int mddev_is_locked(mddev_t *mddev)
+{
+	return mutex_is_locked(&mddev->reconfig_mutex);
+}
+
 static inline int mddev_trylock(mddev_t * mddev)
 {
 	return mutex_trylock(&mddev->reconfig_mutex);
@@ -3628,6 +3633,65 @@ static struct md_sysfs_entry md_reshape_position =
 __ATTR(reshape_position, S_IRUGO|S_IWUSR, reshape_position_show,
        reshape_position_store);
 
+static ssize_t
+array_size_show(mddev_t *mddev, char *page)
+{
+	if (mddev->external_size)
+		return sprintf(page, "%llu\n",
+			       (unsigned long long)mddev->array_sectors/2);
+	else
+		return sprintf(page, "default\n");
+}
+
+static ssize_t
+array_size_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	unsigned long long sectors;
+	struct block_device *bdev;
+
+	if (strncmp(buf, "default", 7) == 0) {
+		if (mddev->pers)
+			sectors = mddev->pers->size(mddev, 0, 0);
+		else
+			sectors = mddev->array_sectors;
+
+		mddev->external_size = 0;
+	} else {
+		int err;
+		sector_t new;
+
+		err = strict_strtoull(buf, 10, &sectors);
+		if (err < 0)
+			return err;
+		sectors *= 2;
+		new = sectors;
+		if (new != sectors) /* overflow */
+			return -EINVAL;
+		if (mddev->pers && mddev->pers->size(mddev, 0, 0) < sectors)
+			return -EINVAL;
+
+		mddev->external_size = 1;
+	}
+
+	mddev->array_sectors = sectors;
+	set_capacity(mddev->gendisk, mddev->array_sectors);
+	if (mddev->pers) {
+		bdev = bdget_disk(mddev->gendisk, 0);
+		if (bdev) {
+			mutex_lock(&bdev->bd_inode->i_mutex);
+			i_size_write(bdev->bd_inode,
+				     (loff_t)mddev->array_sectors << 9);
+			mutex_unlock(&bdev->bd_inode->i_mutex);
+			bdput(bdev);
+		}
+	}
+
+	return len;
+}
+
+static struct md_sysfs_entry md_array_size =
+__ATTR(array_size, S_IRUGO|S_IWUSR, array_size_show,
+       array_size_store);
 
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
@@ -3641,6 +3705,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_safe_delay.attr,
 	&md_array_state.attr,
 	&md_reshape_position.attr,
+	&md_array_size.attr,
 	NULL,
 };
 
@@ -4043,7 +4108,17 @@ static int do_md_run(mddev_t * mddev)
 	err = mddev->pers->run(mddev);
 	if (err)
 		printk(KERN_ERR "md: pers->run() failed ...\n");
-	else if (mddev->pers->sync_request) {
+	else if (mddev->pers->size(mddev, 0, 0) < mddev->array_sectors) {
+		WARN_ONCE(!mddev->external_size, "%s: default size too small,"
+			  " but 'external_size' not in effect?\n", __func__);
+		printk(KERN_ERR
+		       "md: invalid array_size %llu > default size %llu\n",
+		       (unsigned long long)mddev->array_sectors / 2,
+		       (unsigned long long)mddev->pers->size(mddev, 0, 0) / 2);
+		err = -EINVAL;
+		mddev->pers->stop(mddev);
+	}
+	if (err == 0 && mddev->pers->sync_request) {
 		err = bitmap_create(mddev);
 		if (err) {
 			printk(KERN_ERR "%s: failed to create bitmap (%d)\n",
@@ -4279,6 +4354,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		export_array(mddev);
 
 		mddev->array_sectors = 0;
+		mddev->external_size = 0;
 		mddev->dev_sectors = 0;
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
@@ -4977,10 +5053,23 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 
 void md_set_size(mddev_t *mddev, sector_t array_sectors)
 {
+	WARN(!mddev_is_locked(mddev), "%s: unlocked mddev!\n", __func__);
+
+	if (mddev->external_size)
+		return;
+
 	mddev->array_sectors = array_sectors;
 }
 EXPORT_SYMBOL(md_set_size);
 
+void md_set_size_lock(mddev_t *mddev, sector_t array_sectors)
+{
+	mddev_lock(mddev);
+	md_set_size(mddev, array_sectors);
+	mddev_unlock(mddev);
+}
+EXPORT_SYMBOL(md_set_size_lock);
+
 static int update_size(mddev_t *mddev, sector_t num_sectors)
 {
 	mdk_rdev_t *rdev;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 64c62bc..6547d9c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -310,7 +310,7 @@ static int raid0_run (mddev_t *mddev)
 	printk(KERN_INFO "raid0 : conf->spacing is %llu sectors.\n",
 		(unsigned long long)conf->spacing);
 	{
-		sector_t s = mddev->array_sectors;
+		sector_t s = raid0_size(mddev, 0, 0);
 		sector_t space = conf->spacing;
 		int round;
 		conf->sector_shift = 0;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a9f19b7..4d0df53 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2122,14 +2122,16 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	 * worth it.
 	 */
 	md_set_size(mddev, raid1_size(mddev, sectors, 0));
+	if (mddev->array_sectors > raid1_size(mddev, sectors, 0))
+		return -EINVAL;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
-	if (mddev->array_sectors > mddev->dev_sectors &&
+	if (sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->dev_sectors;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
-	mddev->dev_sectors = mddev->array_sectors;
+	mddev->dev_sectors = sectors;
 	mddev->resync_max_sectors = sectors;
 	return 0;
 }
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 571a3c8..4c30d03 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2194,7 +2194,7 @@ static int run(mddev_t *mddev)
 	 * Ok, everything is just fine now
 	 */
 	md_set_size(mddev, raid10_size(mddev, 0, 0));
-	mddev->resync_max_sectors = mddev->array_sectors;
+	mddev->resync_max_sectors = raid10_size(mddev, 0, 0);
 
 	mddev->queue->unplug_fn = raid10_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid10_congested;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 41a6ec9..017c948 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3700,6 +3700,8 @@ static int make_request(struct request_queue *q, struct bio * bi)
 	return 0;
 }
 
+static sector_t raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks);
+
 static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped)
 {
 	/* reshaping is quite different to recovery/resync so it is
@@ -3778,7 +3780,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 			    j == sh->qd_idx)
 				continue;
 			s = compute_blocknr(sh, j);
-			if (s < mddev->array_sectors) {
+			if (s < raid5_size(mddev, 0, 0)) {
 				skipped = 1;
 				continue;
 			}
@@ -4695,6 +4697,9 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	 */
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
 	md_set_size(mddev, raid5_size(mddev, sectors, mddev->raid_disks));
+	if (mddev->array_sectors >
+	    raid5_size(mddev, sectors, mddev->raid_disks))
+		return -EINVAL;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
 	if (sectors > mddev->dev_sectors && mddev->recovery_cp == MaxSector) {
@@ -4832,7 +4837,7 @@ static void end_reshape(raid5_conf_t *conf)
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
 		mddev_t *mddev = conf->mddev;
 
-		md_set_size(mddev, raid5_size(mddev, 0, conf->raid_disks));
+		md_set_size_lock(mddev, raid5_size(mddev, 0, conf->raid_disks));
 		set_capacity(mddev->gendisk, mddev->array_sectors);
 		mddev->changed = 1;
 		conf->previous_raid_disks = conf->raid_disks;
@@ -4959,8 +4964,10 @@ static int raid5_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
 	/* Currently the layout and chunk size can only be changed
 	 * for a 2-drive raid array, as in that case no data shuffling
 	 * is required.
-	 * Later we might validate these and set new_* so a reshape
-	 * can complete the change.
+	 * Later we might validate these and set new_* so a reshape can
+	 * complete the change (in which case raid5_size would need to
+	 * be updated to allow validating the new geometry does not
+	 * reduce the size below the user specified array_size)
 	 */
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 
diff --git a/include/linux/raid/md.h b/include/linux/raid/md.h
index de9bec2..e4ae183 100644
--- a/include/linux/raid/md.h
+++ b/include/linux/raid/md.h
@@ -76,6 +76,7 @@ extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern void md_set_size(mddev_t *mddev, sector_t array_sectors);
+extern void md_set_size_lock(mddev_t *mddev, sector_t array_sectors);
 
 #endif /* CONFIG_MD */
 #endif 
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 564ce81..fd28152 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -160,6 +160,7 @@ struct mddev_s
 	sector_t			dev_sectors; 	/* used size of
 							 * component devices */
 	sector_t			array_sectors; /* exported array size */
+	int				external_size; /* size managed externallly */
 	__u64				events;
 
 	char				uuid[16];

