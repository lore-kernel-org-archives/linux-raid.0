From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/22] md: collect bitmap-specific fields into one
	structure.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.32105.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In preparation for making bitmap fields configurable via sysfs,
start tidying up by making a single structure to contain the
configuration fields.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |    8 +++--
 drivers/md/md.c     |   75 +++++++++++++++++++++++++++------------------------
 drivers/md/md.h     |   21 +++++++-------
 3 files changed, 54 insertions(+), 50 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index a39f632..4c70a01 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1610,16 +1610,16 @@ int bitmap_create(mddev_t *mddev)
 	sector_t blocks = mddev->resync_max_sectors;
 	unsigned long chunks;
 	unsigned long pages;
-	struct file *file = mddev->bitmap_file;
+	struct file *file = mddev->bitmap_info.file;
 	int err;
 	sector_t start;
 
 	BUILD_BUG_ON(sizeof(bitmap_super_t) != 256);
 
-	if (!file && !mddev->bitmap_offset) /* bitmap disabled, nothing to do */
+	if (!file && !mddev->bitmap_info.offset) /* bitmap disabled, nothing to do */
 		return 0;
 
-	BUG_ON(file && mddev->bitmap_offset);
+	BUG_ON(file && mddev->bitmap_info.offset);
 
 	bitmap = kzalloc(sizeof(*bitmap), GFP_KERNEL);
 	if (!bitmap)
@@ -1633,7 +1633,7 @@ int bitmap_create(mddev_t *mddev)
 	bitmap->mddev = mddev;
 
 	bitmap->file = file;
-	bitmap->offset = mddev->bitmap_offset;
+	bitmap->offset = mddev->bitmap_info.offset;
 	if (file) {
 		get_file(file);
 		/* As future accesses to this file will use bmap,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ffe92db..b989189 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -865,7 +865,7 @@ struct super_type  {
  */
 int md_check_no_bitmap(mddev_t *mddev)
 {
-	if (!mddev->bitmap_file && !mddev->bitmap_offset)
+	if (!mddev->bitmap_info.file && !mddev->bitmap_info.offset)
 		return 0;
 	printk(KERN_ERR "%s: bitmaps are not supported for %s\n",
 		mdname(mddev), mddev->pers->name);
@@ -993,8 +993,8 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 		mddev->raid_disks = sb->raid_disks;
 		mddev->dev_sectors = sb->size * 2;
 		mddev->events = ev1;
-		mddev->bitmap_offset = 0;
-		mddev->default_bitmap_offset = MD_SB_BYTES >> 9;
+		mddev->bitmap_info.offset = 0;
+		mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
 
 		if (mddev->minor_version >= 91) {
 			mddev->reshape_position = sb->reshape_position;
@@ -1028,8 +1028,9 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 		mddev->max_disks = MD_SB_DISKS;
 
 		if (sb->state & (1<<MD_SB_BITMAP_PRESENT) &&
-		    mddev->bitmap_file == NULL)
-			mddev->bitmap_offset = mddev->default_bitmap_offset;
+		    mddev->bitmap_info.file == NULL)
+			mddev->bitmap_info.offset =
+				mddev->bitmap_info.default_offset;
 
 	} else if (mddev->pers == NULL) {
 		/* Insist on good event counter while assembling */
@@ -1146,7 +1147,7 @@ static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 	sb->layout = mddev->layout;
 	sb->chunk_size = mddev->chunk_sectors << 9;
 
-	if (mddev->bitmap && mddev->bitmap_file == NULL)
+	if (mddev->bitmap && mddev->bitmap_info.file == NULL)
 		sb->state |= (1<<MD_SB_BITMAP_PRESENT);
 
 	sb->disks[0].state = (1<<MD_DISK_REMOVED);
@@ -1224,7 +1225,7 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 {
 	if (num_sectors && num_sectors < rdev->mddev->dev_sectors)
 		return 0; /* component must fit device */
-	if (rdev->mddev->bitmap_offset)
+	if (rdev->mddev->bitmap_info.offset)
 		return 0; /* can't move bitmap */
 	rdev->sb_start = calc_dev_sboffset(rdev->bdev);
 	if (!num_sectors || num_sectors > rdev->sb_start)
@@ -1403,8 +1404,8 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
 		mddev->dev_sectors = le64_to_cpu(sb->size);
 		mddev->events = ev1;
-		mddev->bitmap_offset = 0;
-		mddev->default_bitmap_offset = 1024 >> 9;
+		mddev->bitmap_info.offset = 0;
+		mddev->bitmap_info.default_offset = 1024 >> 9;
 		
 		mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
 		memcpy(mddev->uuid, sb->set_uuid, 16);
@@ -1412,8 +1413,9 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 		mddev->max_disks =  (4096-256)/2;
 
 		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) &&
-		    mddev->bitmap_file == NULL )
-			mddev->bitmap_offset = (__s32)le32_to_cpu(sb->bitmap_offset);
+		    mddev->bitmap_info.file == NULL )
+			mddev->bitmap_info.offset =
+				(__s32)le32_to_cpu(sb->bitmap_offset);
 
 		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_RESHAPE_ACTIVE)) {
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
@@ -1507,8 +1509,8 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 	sb->level = cpu_to_le32(mddev->level);
 	sb->layout = cpu_to_le32(mddev->layout);
 
-	if (mddev->bitmap && mddev->bitmap_file == NULL) {
-		sb->bitmap_offset = cpu_to_le32((__u32)mddev->bitmap_offset);
+	if (mddev->bitmap && mddev->bitmap_info.file == NULL) {
+		sb->bitmap_offset = cpu_to_le32((__u32)mddev->bitmap_info.offset);
 		sb->feature_map = cpu_to_le32(MD_FEATURE_BITMAP_OFFSET);
 	}
 
@@ -1575,7 +1577,7 @@ super_1_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 		max_sectors -= rdev->data_offset;
 		if (!num_sectors || num_sectors > max_sectors)
 			num_sectors = max_sectors;
-	} else if (rdev->mddev->bitmap_offset) {
+	} else if (rdev->mddev->bitmap_info.offset) {
 		/* minor version 0 with bitmap we can't move */
 		return 0;
 	} else {
@@ -4522,12 +4524,12 @@ out:
 		printk(KERN_INFO "md: %s stopped.\n", mdname(mddev));
 
 		bitmap_destroy(mddev);
-		if (mddev->bitmap_file) {
-			restore_bitmap_write_access(mddev->bitmap_file);
-			fput(mddev->bitmap_file);
-			mddev->bitmap_file = NULL;
+		if (mddev->bitmap_info.file) {
+			restore_bitmap_write_access(mddev->bitmap_info.file);
+			fput(mddev->bitmap_info.file);
+			mddev->bitmap_info.file = NULL;
 		}
-		mddev->bitmap_offset = 0;
+		mddev->bitmap_info.offset = 0;
 
 		/* make sure all md_delayed_delete calls have finished */
 		flush_scheduled_work();
@@ -4753,7 +4755,7 @@ static int get_array_info(mddev_t * mddev, void __user * arg)
 	info.state         = 0;
 	if (mddev->in_sync)
 		info.state = (1<<MD_SB_CLEAN);
-	if (mddev->bitmap && mddev->bitmap_offset)
+	if (mddev->bitmap && mddev->bitmap_info.offset)
 		info.state = (1<<MD_SB_BITMAP_PRESENT);
 	info.active_disks  = insync;
 	info.working_disks = working;
@@ -5111,23 +5113,23 @@ static int set_bitmap_file(mddev_t *mddev, int fd)
 	if (fd >= 0) {
 		if (mddev->bitmap)
 			return -EEXIST; /* cannot add when bitmap is present */
-		mddev->bitmap_file = fget(fd);
+		mddev->bitmap_info.file = fget(fd);
 
-		if (mddev->bitmap_file == NULL) {
+		if (mddev->bitmap_info.file == NULL) {
 			printk(KERN_ERR "%s: error: failed to get bitmap file\n",
 			       mdname(mddev));
 			return -EBADF;
 		}
 
-		err = deny_bitmap_write_access(mddev->bitmap_file);
+		err = deny_bitmap_write_access(mddev->bitmap_info.file);
 		if (err) {
 			printk(KERN_ERR "%s: error: bitmap file is already in use\n",
 			       mdname(mddev));
-			fput(mddev->bitmap_file);
-			mddev->bitmap_file = NULL;
+			fput(mddev->bitmap_info.file);
+			mddev->bitmap_info.file = NULL;
 			return err;
 		}
-		mddev->bitmap_offset = 0; /* file overrides offset */
+		mddev->bitmap_info.offset = 0; /* file overrides offset */
 	} else if (mddev->bitmap == NULL)
 		return -ENOENT; /* cannot remove what isn't there */
 	err = 0;
@@ -5142,11 +5144,11 @@ static int set_bitmap_file(mddev_t *mddev, int fd)
 		mddev->pers->quiesce(mddev, 0);
 	}
 	if (fd < 0) {
-		if (mddev->bitmap_file) {
-			restore_bitmap_write_access(mddev->bitmap_file);
-			fput(mddev->bitmap_file);
+		if (mddev->bitmap_info.file) {
+			restore_bitmap_write_access(mddev->bitmap_info.file);
+			fput(mddev->bitmap_info.file);
 		}
-		mddev->bitmap_file = NULL;
+		mddev->bitmap_info.file = NULL;
 	}
 
 	return err;
@@ -5213,8 +5215,8 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 		mddev->flags         = 0;
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
-	mddev->default_bitmap_offset = MD_SB_BYTES >> 9;
-	mddev->bitmap_offset = 0;
+	mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
+	mddev->bitmap_info.offset = 0;
 
 	mddev->reshape_position = MaxSector;
 
@@ -5314,7 +5316,7 @@ static int update_array_info(mddev_t *mddev, mdu_array_info_t *info)
 	int state = 0;
 
 	/* calculate expected state,ignoring low bits */
-	if (mddev->bitmap && mddev->bitmap_offset)
+	if (mddev->bitmap && mddev->bitmap_info.offset)
 		state |= (1 << MD_SB_BITMAP_PRESENT);
 
 	if (mddev->major_version != info->major_version ||
@@ -5373,9 +5375,10 @@ static int update_array_info(mddev_t *mddev, mdu_array_info_t *info)
 			/* add the bitmap */
 			if (mddev->bitmap)
 				return -EEXIST;
-			if (mddev->default_bitmap_offset == 0)
+			if (mddev->bitmap_info.default_offset == 0)
 				return -EINVAL;
-			mddev->bitmap_offset = mddev->default_bitmap_offset;
+			mddev->bitmap_info.offset =
+				mddev->bitmap_info.default_offset;
 			mddev->pers->quiesce(mddev, 1);
 			rv = bitmap_create(mddev);
 			if (rv)
@@ -5390,7 +5393,7 @@ static int update_array_info(mddev_t *mddev, mdu_array_info_t *info)
 			mddev->pers->quiesce(mddev, 1);
 			bitmap_destroy(mddev);
 			mddev->pers->quiesce(mddev, 0);
-			mddev->bitmap_offset = 0;
+			mddev->bitmap_info.offset = 0;
 		}
 	}
 	md_update_sb(mddev, 1);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 77f0aad..94a8e51 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -280,16 +280,17 @@ struct mddev_s
 	unsigned int                    max_write_behind; /* 0 = sync */
 
 	struct bitmap                   *bitmap; /* the bitmap for the device */
-	struct file			*bitmap_file; /* the bitmap file */
-	long				bitmap_offset; /* offset from superblock of
-							* start of bitmap. May be
-							* negative, but not '0'
-							*/
-	long				default_bitmap_offset; /* this is the offset to use when
-								* hot-adding a bitmap.  It should
-								* eventually be settable by sysfs.
-								*/
-
+	struct {
+		struct file		*file; /* the bitmap file */
+		long			offset; /* offset from superblock of
+						 * start of bitmap. May be
+						 * negative, but not '0'
+						 */
+		long			default_offset; /* this is the offset to use when
+							 * hot-adding a bitmap.  It should
+							 * eventually be settable by sysfs.
+							 */
+	} bitmap_info;
 	struct list_head		all_mddevs;
 
 	/* Generic barrier handling.


