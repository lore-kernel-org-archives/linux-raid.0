From: Shaohua Li <shli@kernel.org>
Subject: [PATCH] md/bitmap: avoid read out of the disk
Date: Tue, 10 Oct 2017 14:20:30 -0700
Message-ID: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: kumba@gentoo.org, Shaohua Li <shli@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

If PAGE_SIZE is bigger than 4k, we could read out of the disk boundary. Limit
the read size to the end of disk. Write path already has similar limitation.

Fix: 8031c3ddc70a(md/bitmap: copy correct data for bitmap super)
Reported-by: Joshua Kinard <kumba@gentoo.org>
Tested-by: Joshua Kinard <kumba@gentoo.org>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/bitmap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index d2121637b4ab..f68ec973fbdd 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -153,6 +153,7 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
 
 	struct md_rdev *rdev;
 	sector_t target;
+	int target_size;
 
 	rdev_for_each(rdev, mddev) {
 		if (! test_bit(In_sync, &rdev->flags)
@@ -161,9 +162,12 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
 			continue;
 
 		target = offset + index * (PAGE_SIZE/512);
+		target_size = min_t(u64, size, i_size_read(rdev->bdev->bd_inode) -
+			((target + rdev->sb_start) << 9));
+		target_size = roundup(target_size,
+			bdev_logical_block_size(rdev->bdev));
 
-		if (sync_page_io(rdev, target,
-				 roundup(size, bdev_logical_block_size(rdev->bdev)),
+		if (sync_page_io(rdev, target, target_size,
 				 page, REQ_OP_READ, 0, true)) {
 			page->index = index;
 			return 0;
-- 
2.11.0

