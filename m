From: MITSUNARI Shigeo <herumi@nifty.com>
Subject: [PATCH 2/2] How about moving a code bdev->bd_invalidated = 0; into check_disk_size_change() instead of putting the code every time after check_disk_size_change().
Date: Mon, 15 Oct 2012 18:27:08 +0900
Message-ID: <1350293228-3602-2-git-send-email-herumi@nifty.com>
References: <1350293228-3602-1-git-send-email-herumi@nifty.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1350293228-3602-1-git-send-email-herumi@nifty.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: MITSUNARI Shigeo <herumi@nifty.com>
List-Id: linux-raid.ids

Signed-off-by: MITSUNARI Shigeo<herumi@nifty.com>
---
 block/partition-generic.c |    2 --
 fs/block_dev.c            |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index f1d1451..6a65169 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -429,7 +429,6 @@ rescan:
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
 	check_disk_size_change(disk, bdev);
-	bdev->bd_invalidated = 0;
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
 	if (IS_ERR(state)) {
@@ -542,7 +541,6 @@ int invalidate_partitions(struct gendisk *disk, struct block_device *bdev)
 
 	set_capacity(disk, 0);
 	check_disk_size_change(disk, bdev);
-	bdev->bd_invalidated = 0;
 	/* tell userspace that the media / partition table may have changed */
 	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2577cf4..ef0189b 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1022,6 +1022,7 @@ void check_disk_size_change(struct gendisk *disk, struct block_device *bdev)
 		i_size_write(bdev->bd_inode, disk_size);
 		flush_disk(bdev, false);
 	}
+	bdev->bd_invalidated = 0;
 }
 EXPORT_SYMBOL(check_disk_size_change);
 
@@ -1047,7 +1048,6 @@ int revalidate_disk(struct gendisk *disk)
 
 	mutex_lock(&bdev->bd_mutex);
 	check_disk_size_change(disk, bdev);
-	bdev->bd_invalidated = 0;
 	mutex_unlock(&bdev->bd_mutex);
 	bdput(bdev);
 	return ret;
-- 
1.7.9.5

