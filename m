From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 15/24] md/bitmap: merge bitmap_file_unmap and
 bitmap_file_put.
Date: Tue, 17 Apr 2012 18:43:41 +1000
Message-ID: <20120417084341.6433.27170.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There functions really do one thing together: release the
'bitmap_storage'.  So make them just one function.

Since we removed the locking (previous patch), we don't need to zero
any fields before freeing them, so it all becomes a bit simpler.


Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index fb8c978..d8e2591 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -730,43 +730,25 @@ static int bitmap_storage_alloc(struct bitmap_storage *store,
 	return 0;
 }
 
-static void bitmap_file_unmap(struct bitmap *bitmap)
+static void bitmap_file_unmap(struct bitmap_storage *store)
 {
 	struct page **map, *sb_page;
-	unsigned long *attr;
 	int pages;
-	struct bitmap_storage *store = &bitmap->storage;
+	struct file *file;
 
+	file = store->file;
 	map = store->filemap;
-	store->filemap = NULL;
-	attr = store->filemap_attr;
-	store->filemap_attr = NULL;
 	pages = store->file_pages;
-	store->file_pages = 0;
 	sb_page = store->sb_page;
-	store->sb_page = NULL;
 
 	while (pages--)
 		if (map[pages] != sb_page) /* 0 is sb_page, release it below */
 			free_buffers(map[pages]);
 	kfree(map);
-	kfree(attr);
+	kfree(store->filemap_attr);
 
 	if (sb_page)
 		free_buffers(sb_page);
-}
-
-static void bitmap_file_put(struct bitmap *bitmap)
-{
-	struct file *file;
-
-	file = bitmap->storage.file;
-	bitmap->storage.file = NULL;
-
-	if (file)
-		wait_event(bitmap->write_wait,
-			   atomic_read(&bitmap->pending_writes)==0);
-	bitmap_file_unmap(bitmap);
 
 	if (file) {
 		struct inode *inode = file->f_path.dentry->d_inode;
@@ -1610,8 +1592,12 @@ static void bitmap_free(struct bitmap *bitmap)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
-	/* release the bitmap file and kill the daemon */
-	bitmap_file_put(bitmap);
+	/* Shouldn't be needed - but just in case.... */
+	wait_event(bitmap->write_wait,
+		   atomic_read(&bitmap->pending_writes) == 0);
+
+	/* release the bitmap file  */
+	bitmap_file_unmap(&bitmap->storage);
 
 	bp = bitmap->bp;
 	pages = bitmap->pages;


