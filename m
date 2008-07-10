From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 2/5] md: Replace calc_dev_size() by calc_num_sectors().
Date: Thu, 10 Jul 2008 11:15:35 +0200
Message-ID: <1215681338-32365-3-git-send-email-maan@systemlinux.org>
References: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Number of sectors is the preferred unit for sizes of raid devices,
so change calc_dev_size() so that it returns this unit instead of
the number of 1K blocks.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2ab13a3..1a6001e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -353,15 +353,13 @@ static inline sector_t calc_dev_sboffset(struct block_device *bdev)
 	return MD_NEW_SIZE_BLOCKS(size);
 }
 
-static sector_t calc_dev_size(mdk_rdev_t *rdev, unsigned chunk_size)
+static sector_t calc_num_sectors(mdk_rdev_t *rdev, unsigned chunk_size)
 {
-	sector_t size;
-
-	size = rdev->sb_offset;
+	sector_t num_sectors = rdev->sb_offset * 2;
 
 	if (chunk_size)
-		size &= ~((sector_t)chunk_size/1024 - 1);
-	return size;
+		num_sectors &= ~((sector_t)chunk_size/512 - 1);
+	return num_sectors;
 }
 
 static int alloc_disk_sb(mdk_rdev_t * rdev)
@@ -759,7 +757,7 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 		else 
 			ret = 0;
 	}
-	rdev->size = calc_dev_size(rdev, sb->chunk_size);
+	rdev->size = calc_num_sectors(rdev, sb->chunk_size) / 2;
 
 	if (rdev->size < sb->size && sb->level > 1)
 		/* "this cannot possibly happen" ... */
@@ -4215,7 +4213,7 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 			rdev->sb_offset = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
 		} else 
 			rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
-		rdev->size = calc_dev_size(rdev, mddev->chunk_size);
+		rdev->size = calc_num_sectors(rdev, mddev->chunk_size) / 2;
 
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err) {
@@ -4257,7 +4255,6 @@ static int hot_add_disk(mddev_t * mddev, dev_t dev)
 {
 	char b[BDEVNAME_SIZE];
 	int err;
-	unsigned int size;
 	mdk_rdev_t *rdev;
 
 	if (!mddev->pers)
@@ -4290,8 +4287,7 @@ static int hot_add_disk(mddev_t * mddev, dev_t dev)
 		rdev->sb_offset =
 			rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
 
-	size = calc_dev_size(rdev, mddev->chunk_size);
-	rdev->size = size;
+	rdev->size = calc_num_sectors(rdev, mddev->chunk_size) / 2;
 
 	if (test_bit(Faulty, &rdev->flags)) {
 		printk(KERN_WARNING 
-- 
1.5.3.8

