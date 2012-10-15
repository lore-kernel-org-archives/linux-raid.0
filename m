From: MITSUNARI Shigeo <herumi@nifty.com>
Subject: [PATCH 1/2] block: fs: bd_invalidated should be cleared in check_disk_size_change
Date: Mon, 15 Oct 2012 18:27:07 +0900
Message-ID: <1350293228-3602-1-git-send-email-herumi@nifty.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: MITSUNARI Shigeo <herumi@nifty.com>
List-Id: linux-raid.ids

rescan_partitions() and invalidate_partitions() in block/partition-generic.c
set bdev->bd_invalidated = 0 after calling check_disk_size_change().
But revalidate_disk() in fs/block_dev.c does not clear it so I add
bdev->bd_invalidated = 0; after calling check_disk_size_change().

If bdev->bd_invalidated = 1 then rescan_partitions() is called when
__blkdev_get() is called.
So if revalidate_disk() is once called, all buffer cache pages will be
cleared every time when the device is opened.

This patch fixes the bug.
Signed-off-by: MITSUNARI Shigeo<herumi@nifty.com>
---
 fs/block_dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 38e721b..2577cf4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1047,6 +1047,7 @@ int revalidate_disk(struct gendisk *disk)
 
 	mutex_lock(&bdev->bd_mutex);
 	check_disk_size_change(disk, bdev);
+	bdev->bd_invalidated = 0;
 	mutex_unlock(&bdev->bd_mutex);
 	bdput(bdev);
 	return ret;
-- 
1.7.9.5

