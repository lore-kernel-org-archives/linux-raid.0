From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 3/5] md: Make calc_dev_sboffset() return a sector count.
Date: Thu, 10 Jul 2008 11:15:36 +0200
Message-ID: <1215681338-32365-4-git-send-email-maan@systemlinux.org>
References: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

As BLOCK_SIZE_BITS is 10 and

	MD_NEW_SIZE_SECTORS(2 * x) = 2 * NEW_SIZE_BLOCKS(x),

the return value of calc_dev_sboffset() doubles. Fix up all three
callers accordingly.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1a6001e..6179e8f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -347,10 +347,11 @@ static struct mdk_personality *find_pers(int level, char *clevel)
 	return NULL;
 }
 
+/* return the offset of the super block in 512byte sectors */
 static inline sector_t calc_dev_sboffset(struct block_device *bdev)
 {
-	sector_t size = bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
-	return MD_NEW_SIZE_BLOCKS(size);
+	sector_t num_sectors = bdev->bd_inode->i_size / 512;
+	return MD_NEW_SIZE_SECTORS(num_sectors);
 }
 
 static sector_t calc_num_sectors(mdk_rdev_t *rdev, unsigned chunk_size)
@@ -679,7 +680,7 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 	 *
 	 * It also happens to be a multiple of 4Kb.
 	 */
-	sb_offset = calc_dev_sboffset(rdev->bdev);
+	sb_offset = calc_dev_sboffset(rdev->bdev) / 2;
 	rdev->sb_offset = sb_offset;
 
 	ret = read_disk_sb(rdev, MD_SB_BYTES);
@@ -4212,7 +4213,7 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 			printk(KERN_INFO "md: nonpersistent superblock ...\n");
 			rdev->sb_offset = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
 		} else 
-			rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
+			rdev->sb_offset = calc_dev_sboffset(rdev->bdev) / 2;
 		rdev->size = calc_num_sectors(rdev, mddev->chunk_size) / 2;
 
 		err = bind_rdev_to_array(rdev, mddev);
@@ -4282,7 +4283,7 @@ static int hot_add_disk(mddev_t * mddev, dev_t dev)
 	}
 
 	if (mddev->persistent)
-		rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
+		rdev->sb_offset = calc_dev_sboffset(rdev->bdev) / 2;
 	else
 		rdev->sb_offset =
 			rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
-- 
1.5.3.8

