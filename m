From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 12/13] md-cluster/bitmap: fix wrong page num in bitmap_file_clear_bit and bitmap_file_set_bit
Date: Thu, 21 Apr 2016 13:58:13 +0800
Message-ID: <1461218294-4960-13-git-send-email-gqjiang@suse.com>
References: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The pnum passed to set_page_attr and test_page_attr should from
0 to storage.file_pages - 1, but bitmap_file_set_bit and
bitmap_file_clear_bit call set_page_attr and test_page_attr with
page->index parameter while page->index has already added node_offset
before.

So we need to minus node_offset in both bitmap_file_clear_bit
and bitmap_file_set_bit.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/bitmap.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index bdae67a..08f4c04 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -903,6 +903,11 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	struct page *page;
 	void *kaddr;
 	unsigned long chunk = block >> bitmap->counts.chunkshift;
+	struct bitmap_storage *store = &bitmap->storage;
+	unsigned long node_offset = 0;
+
+	if (mddev_is_clustered(bitmap->mddev))
+		node_offset = bitmap->cluster_slot * store->file_pages;
 
 	page = filemap_get_page(&bitmap->storage, chunk);
 	if (!page)
@@ -918,7 +923,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	kunmap_atomic(kaddr);
 	pr_debug("set file bit %lu page %lu\n", bit, page->index);
 	/* record page number so it gets flushed to disk when unplug occurs */
-	set_page_attr(bitmap, page->index, BITMAP_PAGE_DIRTY);
+	set_page_attr(bitmap, page->index - node_offset, BITMAP_PAGE_DIRTY);
 }
 
 static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
@@ -927,6 +932,11 @@ static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	struct page *page;
 	void *paddr;
 	unsigned long chunk = block >> bitmap->counts.chunkshift;
+	struct bitmap_storage *store = &bitmap->storage;
+	unsigned long node_offset = 0;
+
+	if (mddev_is_clustered(bitmap->mddev))
+		node_offset = bitmap->cluster_slot * store->file_pages;
 
 	page = filemap_get_page(&bitmap->storage, chunk);
 	if (!page)
@@ -938,8 +948,8 @@ static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	else
 		clear_bit_le(bit, paddr);
 	kunmap_atomic(paddr);
-	if (!test_page_attr(bitmap, page->index, BITMAP_PAGE_NEEDWRITE)) {
-		set_page_attr(bitmap, page->index, BITMAP_PAGE_PENDING);
+	if (!test_page_attr(bitmap, page->index - node_offset, BITMAP_PAGE_NEEDWRITE)) {
+		set_page_attr(bitmap, page->index - node_offset, BITMAP_PAGE_PENDING);
 		bitmap->allclean = 0;
 	}
 }
-- 
2.6.6

