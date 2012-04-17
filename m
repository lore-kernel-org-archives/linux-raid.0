From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 04/24] md/bitmap: centralise allocation of bitmap file
 pages.
Date: Tue, 17 Apr 2012 18:43:40 +1000
Message-ID: <20120417084340.6433.12553.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Instead of allocating pages in read_sb_page, read_page and
bitmap_read_sb, allocate them all in bitmap_init_from disk.

Also replace the hack of calling "attach_page_buffers(page, NULL)" to
ensure that free_buffer() won't complain, by putting a test for
PagePrivate in free_buffer().

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |  149 +++++++++++++++++++++++----------------------------
 1 file changed, 68 insertions(+), 81 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9cc42ba..5629d4a 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -130,22 +130,14 @@ static void bitmap_checkfree(struct bitmap *bitmap, unsigned long page)
  */
 
 /* IO operations when bitmap is stored near all superblocks */
-static struct page *read_sb_page(struct mddev *mddev, loff_t offset,
-				 struct page *page,
-				 unsigned long index, int size)
+static int read_sb_page(struct mddev *mddev, loff_t offset,
+			struct page *page,
+			unsigned long index, int size)
 {
 	/* choose a good rdev and read the page from there */
 
 	struct md_rdev *rdev;
 	sector_t target;
-	int did_alloc = 0;
-
-	if (!page) {
-		page = alloc_page(GFP_KERNEL);
-		if (!page)
-			return ERR_PTR(-ENOMEM);
-		did_alloc = 1;
-	}
 
 	rdev_for_each(rdev, mddev) {
 		if (! test_bit(In_sync, &rdev->flags)
@@ -158,15 +150,10 @@ static struct page *read_sb_page(struct mddev *mddev, loff_t offset,
 				 roundup(size, bdev_logical_block_size(rdev->bdev)),
 				 page, READ, true)) {
 			page->index = index;
-			attach_page_buffers(page, NULL); /* so that free_buffer will
-							  * quietly no-op */
-			return page;
+			return 0;
 		}
 	}
-	if (did_alloc)
-		put_page(page);
-	return ERR_PTR(-EIO);
-
+	return -EIO;
 }
 
 static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mddev)
@@ -325,8 +312,12 @@ __clear_page_buffers(struct page *page)
 }
 static void free_buffers(struct page *page)
 {
-	struct buffer_head *bh = page_buffers(page);
+	struct buffer_head *bh;
 
+	if (!PagePrivate(page))
+		return;
+
+	bh = page_buffers(page);
 	while (bh) {
 		struct buffer_head *next = bh->b_this_page;
 		free_buffer_head(bh);
@@ -343,11 +334,12 @@ static void free_buffers(struct page *page)
  * This usage is similar to how swap files are handled, and allows us
  * to write to a file with no concerns of memory allocation failing.
  */
-static struct page *read_page(struct file *file, unsigned long index,
-			      struct bitmap *bitmap,
-			      unsigned long count)
+static int read_page(struct file *file, unsigned long index,
+		     struct bitmap *bitmap,
+		     unsigned long count,
+		     struct page *page)
 {
-	struct page *page = NULL;
+	int ret = 0;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct buffer_head *bh;
 	sector_t block;
@@ -355,16 +347,9 @@ static struct page *read_page(struct file *file, unsigned long index,
 	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
 		 (unsigned long long)index << PAGE_SHIFT);
 
-	page = alloc_page(GFP_KERNEL);
-	if (!page)
-		page = ERR_PTR(-ENOMEM);
-	if (IS_ERR(page))
-		goto out;
-
 	bh = alloc_page_buffers(page, 1<<inode->i_blkbits, 0);
 	if (!bh) {
-		put_page(page);
-		page = ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
 		goto out;
 	}
 	attach_page_buffers(page, bh);
@@ -376,8 +361,7 @@ static struct page *read_page(struct file *file, unsigned long index,
 			bh->b_blocknr = bmap(inode, block);
 			if (bh->b_blocknr == 0) {
 				/* Cannot use this file! */
-				free_buffers(page);
-				page = ERR_PTR(-EINVAL);
+				ret = -EINVAL;
 				goto out;
 			}
 			bh->b_bdev = inode->i_sb->s_bdev;
@@ -400,17 +384,15 @@ static struct page *read_page(struct file *file, unsigned long index,
 
 	wait_event(bitmap->write_wait,
 		   atomic_read(&bitmap->pending_writes)==0);
-	if (bitmap->flags & BITMAP_WRITE_ERROR) {
-		free_buffers(page);
-		page = ERR_PTR(-EIO);
-	}
+	if (bitmap->flags & BITMAP_WRITE_ERROR)
+		ret = -EIO;
 out:
-	if (IS_ERR(page))
-		printk(KERN_ALERT "md: bitmap read error: (%dB @ %llu): %ld\n",
+	if (ret)
+		printk(KERN_ALERT "md: bitmap read error: (%dB @ %llu): %d\n",
 			(int)PAGE_SIZE,
 			(unsigned long long)index << PAGE_SHIFT,
-			PTR_ERR(page));
-	return page;
+			ret);
+	return ret;
 }
 
 /*
@@ -552,6 +534,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	unsigned long chunksize, daemon_sleep, write_behind;
 	unsigned long long events;
 	int err = -EINVAL;
+	struct page *sb_page;
 
 	if (!bitmap->file && !bitmap->mddev->bitmap_info.offset) {
 		chunksize = 128 * 1024 * 1024;
@@ -562,24 +545,27 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 		goto out_no_sb;
 	}
 	/* page 0 is the superblock, read it... */
+	sb_page = alloc_page(GFP_KERNEL);
+	if (!sb_page)
+		return -ENOMEM;
+	bitmap->sb_page = sb_page;
+
 	if (bitmap->file) {
 		loff_t isize = i_size_read(bitmap->file->f_mapping->host);
 		int bytes = isize > PAGE_SIZE ? PAGE_SIZE : isize;
 
-		bitmap->sb_page = read_page(bitmap->file, 0, bitmap, bytes);
+		err = read_page(bitmap->file, 0,
+				bitmap, bytes, sb_page);
 	} else {
-		bitmap->sb_page = read_sb_page(bitmap->mddev,
-					       bitmap->mddev->bitmap_info.offset,
-					       NULL,
-					       0, sizeof(bitmap_super_t));
+		err = read_sb_page(bitmap->mddev,
+				   bitmap->mddev->bitmap_info.offset,
+				   sb_page,
+				   0, sizeof(bitmap_super_t));
 	}
-	if (IS_ERR(bitmap->sb_page)) {
-		err = PTR_ERR(bitmap->sb_page);
-		bitmap->sb_page = NULL;
+	if (err)
 		return err;
-	}
 
-	sb = kmap_atomic(bitmap->sb_page);
+	sb = kmap_atomic(sb_page);
 
 	chunksize = le32_to_cpu(sb->chunksize);
 	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
@@ -948,7 +934,8 @@ static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int n
 static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 {
 	unsigned long i, chunks, index, oldindex, bit;
-	struct page *page = NULL, *oldpage = NULL;
+	int pnum;
+	struct page *page = NULL;
 	unsigned long num_pages, bit_cnt = 0;
 	struct file *file;
 	unsigned long bytes, offset;
@@ -999,6 +986,22 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	if (!bitmap->filemap)
 		goto err;
 
+	pnum = 0;
+	offset = 0;
+	if (bitmap->sb_page) {
+		bitmap->filemap[0] = bitmap->sb_page;
+		pnum = 1;
+		offset = sizeof(bitmap_super_t);
+	}
+	for ( ; pnum < num_pages; pnum++) {
+		bitmap->filemap[pnum] = alloc_page(GFP_KERNEL);
+		if (!bitmap->filemap[pnum]) {
+			bitmap->file_pages = pnum;
+			goto err;
+		}
+	}
+	bitmap->file_pages = pnum;
+
 	/* We need 4 bits per page, rounded up to a multiple of sizeof(unsigned long) */
 	bitmap->filemap_attr = kzalloc(
 		roundup(DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
@@ -1019,39 +1022,22 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 				count = bytes - index * PAGE_SIZE;
 			else
 				count = PAGE_SIZE;
-			if (index == 0 && bitmap->sb_page) {
-				/*
-				 * if we're here then the superblock page
-				 * contains some bits (PAGE_SIZE != sizeof sb)
-				 * we've already read it in, so just use it
-				 */
-				page = bitmap->sb_page;
-				offset = sizeof(bitmap_super_t);
-				if (!file)
-					page = read_sb_page(
-						bitmap->mddev,
-						bitmap->mddev->bitmap_info.offset,
-						page,
-						index, count);
-			} else if (file) {
-				page = read_page(file, index, bitmap, count);
-				offset = 0;
-			} else {
-				page = read_sb_page(bitmap->mddev,
-						    bitmap->mddev->bitmap_info.offset,
-						    NULL,
-						    index, count);
-				offset = 0;
-			}
-			if (IS_ERR(page)) { /* read error */
-				ret = PTR_ERR(page);
+			page = bitmap->filemap[index];
+			if (file)
+				ret = read_page(file, index, bitmap,
+						count, page);
+			else
+				ret = read_sb_page(
+					bitmap->mddev,
+					bitmap->mddev->bitmap_info.offset,
+					page,
+					index, count);
+
+			if (ret)
 				goto err;
-			}
 
 			oldindex = index;
-			oldpage = page;
 
-			bitmap->filemap[bitmap->file_pages++] = page;
 			bitmap->last_page_size = count;
 
 			if (outofdate) {
@@ -1085,6 +1071,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 					       needed);
 			bit_cnt++;
 		}
+		offset = 0;
 	}
 
 	printk(KERN_INFO "%s: bitmap initialized from disk: "


