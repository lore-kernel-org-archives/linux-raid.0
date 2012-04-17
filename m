From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/24] md/bitmap: separate bitmap file allocation to its
 own function.
Date: Tue, 17 Apr 2012 18:43:40 +1000
Message-ID: <20120417084340.6433.93849.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This will allow allocation before swapping in a new bitmap.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |  113 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 46 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9221f97..0819ec2 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -714,6 +714,58 @@ static inline struct page *filemap_get_page(struct bitmap_storage *store,
 			      - file_page_index(store, 0)];
 }
 
+static int bitmap_storage_alloc(struct bitmap_storage *store,
+				unsigned long chunks, int with_super)
+{
+	int pnum;
+	unsigned long num_pages;
+	unsigned long bytes;
+
+	bytes = DIV_ROUND_UP(chunks, 8);
+	if (with_super)
+		bytes += sizeof(bitmap_super_t);
+
+	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
+
+	store->filemap = kmalloc(sizeof(struct page *)
+				 * num_pages, GFP_KERNEL);
+	if (!store->filemap)
+		return -ENOMEM;
+
+	if (with_super && !store->sb_page) {
+		store->sb_page = alloc_page(GFP_KERNEL);
+		if (store->sb_page == NULL)
+			return -ENOMEM;
+		store->sb_page->index = 0;
+	}
+	pnum = 0;
+	if (store->sb_page) {
+		store->filemap[0] = store->sb_page;
+		pnum = 1;
+	}
+	for ( ; pnum < num_pages; pnum++) {
+		store->filemap[pnum] = alloc_page(GFP_KERNEL);
+		if (!store->filemap[pnum]) {
+			store->file_pages = pnum;
+			return -ENOMEM;
+		}
+		store->filemap[pnum]->index = pnum;
+	}
+	store->file_pages = pnum;
+
+	/* We need 4 bits per page, rounded up to a multiple
+	 * of sizeof(unsigned long) */
+	store->filemap_attr = kzalloc(
+		roundup(DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
+		GFP_KERNEL);
+	if (!store->filemap_attr)
+		return -ENOMEM;
+
+	store->bytes = bytes;
+
+	return 0;
+}
+
 static void bitmap_file_unmap(struct bitmap *bitmap)
 {
 	struct page **map, *sb_page;
@@ -938,11 +990,10 @@ static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int n
 static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 {
 	unsigned long i, chunks, index, oldindex, bit;
-	int pnum;
 	struct page *page = NULL;
-	unsigned long num_pages, bit_cnt = 0;
+	unsigned long bit_cnt = 0;
 	struct file *file;
-	unsigned long bytes, offset;
+	unsigned long offset;
 	int outofdate;
 	int ret = -ENOSPC;
 	void *paddr;
@@ -971,53 +1022,23 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		printk(KERN_INFO "%s: bitmap file is out of date, doing full "
 			"recovery\n", bmname(bitmap));
 
-	bytes = DIV_ROUND_UP(bitmap->chunks, 8);
-	if (!bitmap->mddev->bitmap_info.external)
-		bytes += sizeof(bitmap_super_t);
-
-	store->bytes = bytes;
-
-	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
-
-	if (file && i_size_read(file->f_mapping->host) < bytes) {
+	if (file && i_size_read(file->f_mapping->host) < store->bytes) {
 		printk(KERN_INFO "%s: bitmap file too short %lu < %lu\n",
-			bmname(bitmap),
-			(unsigned long) i_size_read(file->f_mapping->host),
-			bytes);
+		       bmname(bitmap),
+		       (unsigned long) i_size_read(file->f_mapping->host),
+		       store->bytes);
 		goto err;
 	}
 
-	ret = -ENOMEM;
-
-	store->filemap = kmalloc(sizeof(struct page *)
-					  * num_pages, GFP_KERNEL);
-	if (!store->filemap)
+	ret = bitmap_storage_alloc(&bitmap->storage, bitmap->chunks,
+				   !bitmap->mddev->bitmap_info.external);
+	if (ret)
 		goto err;
 
-	pnum = 0;
+	oldindex = ~0L;
 	offset = 0;
-	if (store->sb_page) {
-		store->filemap[0] = store->sb_page;
-		pnum = 1;
+	if (!bitmap->mddev->bitmap_info.external)
 		offset = sizeof(bitmap_super_t);
-	}
-	for ( ; pnum < num_pages; pnum++) {
-		store->filemap[pnum] = alloc_page(GFP_KERNEL);
-		if (!store->filemap[pnum]) {
-			store->file_pages = pnum;
-			goto err;
-		}
-	}
-	store->file_pages = pnum;
-
-	/* We need 4 bits per page, rounded up to a multiple of sizeof(unsigned long) */
-	store->filemap_attr = kzalloc(
-		roundup(DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
-		GFP_KERNEL);
-	if (!store->filemap_attr)
-		goto err;
-
-	oldindex = ~0L;
 
 	for (i = 0; i < chunks; i++) {
 		int b;
@@ -1026,8 +1047,8 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		if (index != oldindex) { /* this is a new page, read it in */
 			int count;
 			/* unmap the old page, we're done with it */
-			if (index == num_pages-1)
-				count = bytes - index * PAGE_SIZE;
+			if (index == store->file_pages-1)
+				count = store->bytes - index * PAGE_SIZE;
 			else
 				count = PAGE_SIZE;
 			page = store->filemap[index];
@@ -1081,9 +1102,9 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	}
 
 	printk(KERN_INFO "%s: bitmap initialized from disk: "
-	       "read %lu/%lu pages, set %lu of %lu bits\n",
+	       "read %lu pages, set %lu of %lu bits\n",
 	       bmname(bitmap), store->file_pages,
-	       num_pages, bit_cnt, chunks);
+	       bit_cnt, chunks);
 
 	return 0;
 


