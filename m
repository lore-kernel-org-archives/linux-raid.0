From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 4/5] md: Turn rdev->sb_offset into a sector-based quantity.
Date: Thu, 10 Jul 2008 11:15:37 +0200
Message-ID: <1215681338-32365-5-git-send-email-maan@systemlinux.org>
References: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Rename it to sb_start to make sure all users have been converted.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/bitmap.c       |   10 ++++----
 drivers/md/md.c           |   56 +++++++++++++++++++++------------------------
 include/linux/raid/md_k.h |    2 +-
 3 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index b26927c..f1c44ff 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -225,7 +225,7 @@ static struct page *read_sb_page(mddev_t *mddev, long offset, unsigned long inde
 		    || test_bit(Faulty, &rdev->flags))
 			continue;
 
-		target = (rdev->sb_offset << 1) + offset + index * (PAGE_SIZE/512);
+		target = rdev->sb_start + offset + index * (PAGE_SIZE/512);
 
 		if (sync_page_io(rdev->bdev, target, PAGE_SIZE, page, READ)) {
 			page->index = index;
@@ -262,12 +262,12 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 					/* bitmap runs in to metadata */
 					return -EINVAL;
 				if (rdev->data_offset + mddev->size*2
-				    > rdev->sb_offset*2 + bitmap->offset)
+				    > rdev->sb_start + bitmap->offset)
 					/* data runs in to bitmap */
 					return -EINVAL;
-			} else if (rdev->sb_offset*2 < rdev->data_offset) {
+			} else if (rdev->sb_start < rdev->data_offset) {
 				/* METADATA BITMAP DATA */
-				if (rdev->sb_offset*2
+				if (rdev->sb_start
 				    + bitmap->offset
 				    + page->index*(PAGE_SIZE/512) + size/512
 				    > rdev->data_offset)
@@ -277,7 +277,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 				/* DATA METADATA BITMAP - no problems */
 			}
 			md_super_write(mddev, rdev,
-				       (rdev->sb_offset<<1) + bitmap->offset
+				       rdev->sb_start + bitmap->offset
 				       + page->index * (PAGE_SIZE/512),
 				       size,
 				       page);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6179e8f..7b6e238 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -356,7 +356,7 @@ static inline sector_t calc_dev_sboffset(struct block_device *bdev)
 
 static sector_t calc_num_sectors(mdk_rdev_t *rdev, unsigned chunk_size)
 {
-	sector_t num_sectors = rdev->sb_offset * 2;
+	sector_t num_sectors = rdev->sb_start;
 
 	if (chunk_size)
 		num_sectors &= ~((sector_t)chunk_size/512 - 1);
@@ -383,7 +383,7 @@ static void free_disk_sb(mdk_rdev_t * rdev)
 		put_page(rdev->sb_page);
 		rdev->sb_loaded = 0;
 		rdev->sb_page = NULL;
-		rdev->sb_offset = 0;
+		rdev->sb_start = 0;
 		rdev->size = 0;
 	}
 }
@@ -529,7 +529,7 @@ static int read_disk_sb(mdk_rdev_t * rdev, int size)
 		return 0;
 
 
-	if (!sync_page_io(rdev->bdev, rdev->sb_offset<<1, size, rdev->sb_page, READ))
+	if (!sync_page_io(rdev->bdev, rdev->sb_start, size, rdev->sb_page, READ))
 		goto fail;
 	rdev->sb_loaded = 1;
 	return 0;
@@ -672,16 +672,14 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	mdp_super_t *sb;
 	int ret;
-	sector_t sb_offset;
 
 	/*
-	 * Calculate the position of the superblock,
+	 * Calculate the position of the superblock (512byte sectors),
 	 * it's at the end of the disk.
 	 *
 	 * It also happens to be a multiple of 4Kb.
 	 */
-	sb_offset = calc_dev_sboffset(rdev->bdev) / 2;
-	rdev->sb_offset = sb_offset;
+	rdev->sb_start = calc_dev_sboffset(rdev->bdev);
 
 	ret = read_disk_sb(rdev, MD_SB_BYTES);
 	if (ret) return ret;
@@ -1033,12 +1031,12 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 {
 	struct mdp_superblock_1 *sb;
 	int ret;
-	sector_t sb_offset;
+	sector_t sb_start;
 	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	int bmask;
 
 	/*
-	 * Calculate the position of the superblock.
+	 * Calculate the position of the superblock in 512byte sectors.
 	 * It is always aligned to a 4K boundary and
 	 * depeding on minor_version, it can be:
 	 * 0: At least 8K, but less than 12K, from end of device
@@ -1047,22 +1045,21 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 	 */
 	switch(minor_version) {
 	case 0:
-		sb_offset = rdev->bdev->bd_inode->i_size >> 9;
-		sb_offset -= 8*2;
-		sb_offset &= ~(sector_t)(4*2-1);
+		sb_start = rdev->bdev->bd_inode->i_size >> 9;
+		sb_start -= 8*2;
+		sb_start &= ~(sector_t)(4*2-1);
 		/* convert from sectors to K */
-		sb_offset /= 2;
 		break;
 	case 1:
-		sb_offset = 0;
+		sb_start = 0;
 		break;
 	case 2:
-		sb_offset = 4;
+		sb_start = 8;
 		break;
 	default:
 		return -EINVAL;
 	}
-	rdev->sb_offset = sb_offset;
+	rdev->sb_start = sb_start;
 
 	/* superblock is rarely larger than 1K, but it can be larger,
 	 * and it is safe to read 4k, so we do that
@@ -1076,7 +1073,7 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 	if (sb->magic != cpu_to_le32(MD_SB_MAGIC) ||
 	    sb->major_version != cpu_to_le32(1) ||
 	    le32_to_cpu(sb->max_dev) > (4096-256)/2 ||
-	    le64_to_cpu(sb->super_offset) != (rdev->sb_offset<<1) ||
+	    le64_to_cpu(sb->super_offset) != rdev->sb_start ||
 	    (le32_to_cpu(sb->feature_map) & ~MD_FEATURE_ALL) != 0)
 		return -EINVAL;
 
@@ -1112,7 +1109,7 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 		rdev->sb_size = (rdev->sb_size | bmask) + 1;
 
 	if (minor_version
-	    && rdev->data_offset < sb_offset + (rdev->sb_size/512))
+	    && rdev->data_offset < sb_start / 2 + (rdev->sb_size/512))
 		return -EINVAL;
 
 	if (sb->level == cpu_to_le32(LEVEL_MULTIPATH))
@@ -1148,7 +1145,7 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 	if (minor_version)
 		rdev->size = ((rdev->bdev->bd_inode->i_size>>9) - le64_to_cpu(sb->data_offset)) / 2;
 	else
-		rdev->size = rdev->sb_offset;
+		rdev->size = rdev->sb_start / 2;
 	if (rdev->size < le64_to_cpu(sb->data_size)/2)
 		return -EINVAL;
 	rdev->size = le64_to_cpu(sb->data_size)/2;
@@ -1757,11 +1754,11 @@ repeat:
 		dprintk("%s ", bdevname(rdev->bdev,b));
 		if (!test_bit(Faulty, &rdev->flags)) {
 			md_super_write(mddev,rdev,
-				       rdev->sb_offset<<1, rdev->sb_size,
+				       rdev->sb_start, rdev->sb_size,
 				       rdev->sb_page);
 			dprintk(KERN_INFO "(write) %s's sb offset: %llu\n",
 				bdevname(rdev->bdev,b),
-				(unsigned long long)rdev->sb_offset);
+				(unsigned long long)rdev->sb_start);
 			rdev->sb_events = mddev->events;
 
 		} else
@@ -3431,16 +3428,16 @@ static int do_md_run(mddev_t * mddev)
 		 * We don't want the data to overlap the metadata,
 		 * Internal Bitmap issues has handled elsewhere.
 		 */
-		if (rdev->data_offset < rdev->sb_offset) {
+		if (rdev->data_offset < rdev->sb_start / 2) {
 			if (mddev->size &&
 			    rdev->data_offset + mddev->size*2
-			    > rdev->sb_offset*2) {
+			    > rdev->sb_start) {
 				printk("md: %s: data overlaps metadata\n",
 				       mdname(mddev));
 				return -EINVAL;
 			}
 		} else {
-			if (rdev->sb_offset*2 + rdev->sb_size/512
+			if (rdev->sb_start + rdev->sb_size/512
 			    > rdev->data_offset) {
 				printk("md: %s: metadata overlaps data\n",
 				       mdname(mddev));
@@ -4211,9 +4208,9 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 
 		if (!mddev->persistent) {
 			printk(KERN_INFO "md: nonpersistent superblock ...\n");
-			rdev->sb_offset = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
+			rdev->sb_start = rdev->bdev->bd_inode->i_size / 512;
 		} else 
-			rdev->sb_offset = calc_dev_sboffset(rdev->bdev) / 2;
+			rdev->sb_start = calc_dev_sboffset(rdev->bdev);
 		rdev->size = calc_num_sectors(rdev, mddev->chunk_size) / 2;
 
 		err = bind_rdev_to_array(rdev, mddev);
@@ -4283,10 +4280,9 @@ static int hot_add_disk(mddev_t * mddev, dev_t dev)
 	}
 
 	if (mddev->persistent)
-		rdev->sb_offset = calc_dev_sboffset(rdev->bdev) / 2;
+		rdev->sb_start = calc_dev_sboffset(rdev->bdev);
 	else
-		rdev->sb_offset =
-			rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
+		rdev->sb_start = rdev->bdev->bd_inode->i_size / 512;
 
 	rdev->size = calc_num_sectors(rdev, mddev->chunk_size) / 2;
 
@@ -4487,7 +4483,7 @@ static int update_size(mddev_t *mddev, sector_t num_sectors)
 	 * linear and raid0 always use whatever space is available. We can only
 	 * consider changing this number if no resync or reconstruction is
 	 * happening, and if the new size is acceptable. It must fit before the
-	 * sb_offset or, if that is <data_offset, it must fit before the size
+	 * sb_start or, if that is <data_offset, it must fit before the size
 	 * of each device.  If num_sectors is zero, we find the largest size
 	 * that fits.
 
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 3dea9f5..3df92af 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -59,7 +59,7 @@ struct mdk_rdev_s
 	int		sb_loaded;
 	__u64		sb_events;
 	sector_t	data_offset;	/* start of data in array */
-	sector_t	sb_offset;
+	sector_t 	sb_start;	/* offset of the super block (in 512byte sectors) */
 	int		sb_size;	/* bytes in the superblock */
 	int		preferred_minor;	/* autorun support */
 
-- 
1.5.3.8

