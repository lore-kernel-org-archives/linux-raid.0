From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] md/bitmap: call bitmap_file_unmap once bitmap_storage_alloc returns -ENOMEM
Date: Mon, 31 Oct 2016 10:19:00 +0800
Message-ID: <1477880340-23036-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

It is possible that bitmap_storage_alloc could return -ENOMEM,
and some member inside store could be allocated such as filemap.

To avoid memory leak, we need to call bitmap_file_unmap to free
those members in the bitmap_resize.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/bitmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 2d826927a3bf..cd3a0659cc07 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -2029,8 +2029,10 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 					   !bitmap->mddev->bitmap_info.external,
 					   mddev_is_clustered(bitmap->mddev)
 					   ? bitmap->cluster_slot : 0);
-	if (ret)
+	if (ret) {
+		bitmap_file_unmap(&store);
 		goto err;
+	}
 
 	pages = DIV_ROUND_UP(chunks, PAGE_COUNTER_RATIO);
 
-- 
2.6.2

