From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] block: remove flush_disk
Date: Wed,  8 Jul 2020 14:25:43 +0200
Message-ID: <20200708122546.214579-4-hch@lst.de>
References: <20200708122546.214579-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20200708122546.214579-1-hch@lst.de>
Sender: linux-mmc-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

flush_disk has only two callers, so open code it there.  That also helps
clarifying the error message for the particular case, and allows to remove
setting bd_invalidated in check_disk_size_change, which will be cleared
again instantly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2d2fcb50e78eac..a36d5b6907ea4e 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1347,26 +1347,6 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 #endif
 
-/**
- * flush_disk - invalidates all buffer-cache entries on a disk
- *
- * @bdev:      struct block device to be flushed
- * @kill_dirty: flag to guide handling of dirty inodes
- *
- * Invalidates all buffer-cache entries on a disk. It should be called
- * when a disk has been changed -- either by a media change or online
- * resize.
- */
-static void flush_disk(struct block_device *bdev, bool kill_dirty)
-{
-	if (__invalidate_device(bdev, kill_dirty)) {
-		printk(KERN_WARNING "VFS: busy inodes on changed media or "
-		       "resized disk %s\n",
-		       bdev->bd_disk ? bdev->bd_disk->disk_name : "");
-	}
-	bdev->bd_invalidated = 1;
-}
-
 /**
  * check_disk_size_change - checks for disk size change and adjusts bdev size.
  * @disk: struct gendisk to check
@@ -1391,8 +1371,9 @@ static void check_disk_size_change(struct gendisk *disk,
 			       disk->disk_name, bdev_size, disk_size);
 		}
 		i_size_write(bdev->bd_inode, disk_size);
-		if (bdev_size > disk_size)
-			flush_disk(bdev, false);
+		if (bdev_size > disk_size && __invalidate_device(bdev, false))
+			pr_warn("VFS: busy inodes on resized disk %s\n",
+				disk->disk_name);
 	}
 	bdev->bd_invalidated = 0;
 }
@@ -1451,7 +1432,10 @@ int check_disk_change(struct block_device *bdev)
 	if (!(events & DISK_EVENT_MEDIA_CHANGE))
 		return 0;
 
-	flush_disk(bdev, true);
+	if (__invalidate_device(bdev, true))
+		pr_warn("VFS: busy inodes on changed media %s\n",
+			disk->disk_name);
+	bdev->bd_invalidated = 1;
 	if (bdops->revalidate_disk)
 		bdops->revalidate_disk(bdev->bd_disk);
 	return 1;
-- 
2.26.2
