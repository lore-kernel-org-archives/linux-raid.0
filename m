From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 1/4] md-cluster: fix bitmap sub-offset in bitmap_read_sb
Date: Wed, 8 Apr 2015 14:22:25 -0500
Message-ID: <20150408192225.GA9678@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, GQJiang@suse.com
List-Id: linux-raid.ids

bitmap_read_sb is modifying mddev->bitmap_info.offset. Thi works for
the first bitmap read. However, when multiple bitmaps need to be opened
by the same node, it ends up corrupting the offset. Fix it by using a
local variable.

Also, bitmap_read_sb is not required in bitmap_copy_from_slot since
it is called in bitmap_create. Remove bitmap_read_sb().

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/bitmap.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index e495604..eccfa27 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -547,6 +547,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	unsigned long sectors_reserved = 0;
 	int err = -EINVAL;
 	struct page *sb_page;
+	loff_t offset = bitmap->mddev->bitmap_info.offset;
 
 	if (!bitmap->storage.file && !bitmap->mddev->bitmap_info.offset) {
 		chunksize = 128 * 1024 * 1024;
@@ -573,9 +574,9 @@ re_read:
 		bm_blocks = ((bm_blocks+7) >> 3) + sizeof(bitmap_super_t);
 		/* to 4k blocks */
 		bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
-		bitmap->mddev->bitmap_info.offset += bitmap->cluster_slot * (bm_blocks << 3);
+		offset = bitmap->mddev->bitmap_info.offset + (bitmap->cluster_slot * (bm_blocks << 3));
 		pr_info("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
-			bitmap->cluster_slot, (unsigned long long)bitmap->mddev->bitmap_info.offset);
+			bitmap->cluster_slot, offset);
 	}
 
 	if (bitmap->storage.file) {
@@ -586,7 +587,7 @@ re_read:
 				bitmap, bytes, sb_page);
 	} else {
 		err = read_sb_page(bitmap->mddev,
-				   bitmap->mddev->bitmap_info.offset,
+				   offset,
 				   sb_page,
 				   0, sizeof(bitmap_super_t));
 	}
@@ -1878,10 +1879,6 @@ int bitmap_copy_from_slot(struct mddev *mddev, int slot,
 	if (IS_ERR(bitmap))
 		return PTR_ERR(bitmap);
 
-	rv = bitmap_read_sb(bitmap);
-	if (rv)
-		goto err;
-
 	rv = bitmap_init_from_disk(bitmap, 0);
 	if (rv)
 		goto err;
-- 
2.1.4

