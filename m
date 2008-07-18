From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 2/4] md: Make super_type->rdev_size_change() take sector-based sizes.
Date: Fri, 18 Jul 2008 14:00:17 +0200
Message-ID: <1216382419-2560-3-git-send-email-maan@systemlinux.org>
References: <1216382419-2560-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216382419-2560-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Also, change the type of the size parameter from unsigned long long to
sector_t and rename it to num_sectors.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |   40 +++++++++++++++++++---------------------
 1 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1bfa1f2..c8673f4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -655,7 +655,7 @@ struct super_type  {
 	int		    (*validate_super)(mddev_t *mddev, mdk_rdev_t *rdev);
 	void		    (*sync_super)(mddev_t *mddev, mdk_rdev_t *rdev);
 	unsigned long long  (*rdev_size_change)(mdk_rdev_t *rdev,
-						unsigned long long size);
+						sector_t num_sectors);
 };
 
 /*
@@ -998,20 +998,19 @@ static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
  * rdev_size_change for 0.90.0
  */
 static unsigned long long
-super_90_rdev_size_change(mdk_rdev_t *rdev, unsigned long long size)
+super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 {
-	if (size && size < rdev->mddev->size)
+	if (num_sectors && num_sectors < rdev->mddev->size * 2)
 		return 0; /* component must fit device */
-	size *= 2; /* convert to sectors */
 	if (rdev->mddev->bitmap_offset)
 		return 0; /* can't move bitmap */
 	rdev->sb_start = calc_dev_sboffset(rdev->bdev);
-	if (!size || size > rdev->sb_start)
-		size = rdev->sb_start;
+	if (!num_sectors || num_sectors > rdev->sb_start)
+		num_sectors = rdev->sb_start;
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-	return size/2; /* kB for sysfs */
+	return num_sectors / 2; /* kB for sysfs */
 }
 
 
@@ -1339,19 +1338,18 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 }
 
 static unsigned long long
-super_1_rdev_size_change(mdk_rdev_t *rdev, unsigned long long size)
+super_1_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 {
 	struct mdp_superblock_1 *sb;
-	unsigned long long max_size;
-	if (size && size < rdev->mddev->size)
+	sector_t max_sectors;
+	if (num_sectors && num_sectors < rdev->mddev->size * 2)
 		return 0; /* component must fit device */
-	size *= 2; /* convert to sectors */
 	if (rdev->sb_start < rdev->data_offset) {
 		/* minor versions 1 and 2; superblock before data */
-		max_size = (rdev->bdev->bd_inode->i_size >> 9);
-		max_size -= rdev->data_offset;
-		if (!size || size > max_size)
-			size = max_size;
+		max_sectors = rdev->bdev->bd_inode->i_size >> 9;
+		max_sectors -= rdev->data_offset;
+		if (!num_sectors || num_sectors > max_sectors)
+			num_sectors = max_sectors;
 	} else if (rdev->mddev->bitmap_offset) {
 		/* minor version 0 with bitmap we can't move */
 		return 0;
@@ -1360,19 +1358,19 @@ super_1_rdev_size_change(mdk_rdev_t *rdev, unsigned long long size)
 		sector_t sb_start;
 		sb_start = (rdev->bdev->bd_inode->i_size >> 9) - 8*2;
 		sb_start &= ~(sector_t)(4*2 - 1);
-		max_size = rdev->size*2 + sb_start - rdev->sb_start;
-		if (!size || size > max_size)
-			size = max_size;
+		max_sectors = rdev->size * 2 + sb_start - rdev->sb_start;
+		if (!num_sectors || num_sectors > max_sectors)
+			num_sectors = max_sectors;
 		rdev->sb_start = sb_start;
 	}
 	sb = (struct mdp_superblock_1 *) page_address(rdev->sb_page);
-	sb->data_size = cpu_to_le64(size);
+	sb->data_size = cpu_to_le64(num_sectors);
 	sb->super_offset = rdev->sb_start;
 	sb->sb_csum = calc_sb_1_csum(sb);
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-	return size/2; /* kB for sysfs */
+	return num_sectors / 2; /* kB for sysfs */
 }
 
 static struct super_type super_types[] = {
@@ -2112,7 +2110,7 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 	if (my_mddev->pers && rdev->raid_disk >= 0) {
 		if (my_mddev->persistent) {
 			size = super_types[my_mddev->major_version].
-				rdev_size_change(rdev, size);
+				rdev_size_change(rdev, size * 2);
 			if (!size)
 				return -EBUSY;
 		} else if (!size) {
-- 
1.5.3.8

