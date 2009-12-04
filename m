From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 15/22] md: Support write-intent bitmaps with externally
	managed metadata.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.68159.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In this case, the metadata needs to not be in the same
sector as the bitmap.
md will not read/write any bitmap metadata.  Config must be
done via sysfs and when a recovery makes the array non-degraded
again, writing 'true' to 'bitmap/can_clear' will allow bits in
the bitmap to be cleared again.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |  134 +++++++++++++++++++++++++++++++++++++++++++--------
 drivers/md/bitmap.h |   11 ----
 drivers/md/md.h     |    1 
 3 files changed, 114 insertions(+), 32 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 0f3d9a8..aeaa30e 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -498,6 +498,8 @@ void bitmap_update_sb(struct bitmap *bitmap)
 
 	if (!bitmap || !bitmap->mddev) /* no bitmap for this array */
 		return;
+	if (bitmap->mddev->bitmap_info.external)
+		return;
 	spin_lock_irqsave(&bitmap->lock, flags);
 	if (!bitmap->sb_page) { /* no superblock */
 		spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -678,16 +680,26 @@ static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
  * general bitmap file operations
  */
 
+/*
+ * on-disk bitmap:
+ *
+ * Use one bit per "chunk" (block set). We do the disk I/O on the bitmap
+ * file a page at a time. There's a superblock at the start of the file.
+ */
 /* calculate the index of the page that contains this bit */
-static inline unsigned long file_page_index(unsigned long chunk)
+static inline unsigned long file_page_index(struct bitmap *bitmap, unsigned long chunk)
 {
-	return CHUNK_BIT_OFFSET(chunk) >> PAGE_BIT_SHIFT;
+	if (!bitmap->mddev->bitmap_info.external)
+		chunk += sizeof(bitmap_super_t) << 3;
+	return chunk >> PAGE_BIT_SHIFT;
 }
 
 /* calculate the (bit) offset of this bit within a page */
-static inline unsigned long file_page_offset(unsigned long chunk)
+static inline unsigned long file_page_offset(struct bitmap *bitmap, unsigned long chunk)
 {
-	return CHUNK_BIT_OFFSET(chunk) & (PAGE_BITS - 1);
+	if (!bitmap->mddev->bitmap_info.external)
+		chunk += sizeof(bitmap_super_t) << 3;
+	return chunk & (PAGE_BITS - 1);
 }
 
 /*
@@ -700,8 +712,9 @@ static inline unsigned long file_page_offset(unsigned long chunk)
 static inline struct page *filemap_get_page(struct bitmap *bitmap,
 					unsigned long chunk)
 {
-	if (file_page_index(chunk) >= bitmap->file_pages) return NULL;
-	return bitmap->filemap[file_page_index(chunk) - file_page_index(0)];
+	if (file_page_index(bitmap, chunk) >= bitmap->file_pages) return NULL;
+	return bitmap->filemap[file_page_index(bitmap, chunk)
+			       - file_page_index(bitmap, 0)];
 }
 
 
@@ -724,7 +737,7 @@ static void bitmap_file_unmap(struct bitmap *bitmap)
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 
 	while (pages--)
-		if (map[pages]->index != 0) /* 0 is sb_page, release it below */
+		if (map[pages] != sb_page) /* 0 is sb_page, release it below */
 			free_buffers(map[pages]);
 	kfree(map);
 	kfree(attr);
@@ -835,7 +848,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 
 	page = filemap_get_page(bitmap, chunk);
 	if (!page) return;
-	bit = file_page_offset(chunk);
+	bit = file_page_offset(bitmap, chunk);
 
  	/* set the bit */
 	kaddr = kmap_atomic(page, KM_USER0);
@@ -933,14 +946,17 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 			"recovery\n", bmname(bitmap));
 
 	bytes = (chunks + 7) / 8;
+	if (!bitmap->mddev->bitmap_info.external)
+		bytes += sizeof(bitmap_super_t);
 
-	num_pages = (bytes + sizeof(bitmap_super_t) + PAGE_SIZE - 1) / PAGE_SIZE;
+	
+	num_pages = (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
 
-	if (file && i_size_read(file->f_mapping->host) < bytes + sizeof(bitmap_super_t)) {
+	if (file && i_size_read(file->f_mapping->host) < bytes) {
 		printk(KERN_INFO "%s: bitmap file too short %lu < %lu\n",
 			bmname(bitmap),
 			(unsigned long) i_size_read(file->f_mapping->host),
-			bytes + sizeof(bitmap_super_t));
+			bytes);
 		goto err;
 	}
 
@@ -961,17 +977,16 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 
 	for (i = 0; i < chunks; i++) {
 		int b;
-		index = file_page_index(i);
-		bit = file_page_offset(i);
+		index = file_page_index(bitmap, i);
+		bit = file_page_offset(bitmap, i);
 		if (index != oldindex) { /* this is a new page, read it in */
 			int count;
 			/* unmap the old page, we're done with it */
 			if (index == num_pages-1)
-				count = bytes + sizeof(bitmap_super_t)
-					- index * PAGE_SIZE;
+				count = bytes - index * PAGE_SIZE;
 			else
 				count = PAGE_SIZE;
-			if (index == 0) {
+			if (index == 0 && bitmap->sb_page) {
 				/*
 				 * if we're here then the superblock page
 				 * contains some bits (PAGE_SIZE != sizeof sb)
@@ -1166,7 +1181,8 @@ void bitmap_daemon_work(mddev_t *mddev)
 			/* We are possibly going to clear some bits, so make
 			 * sure that events_cleared is up-to-date.
 			 */
-			if (bitmap->need_sync) {
+			if (bitmap->need_sync &&
+			    bitmap->mddev->bitmap_info.external == 0) {
 				bitmap_super_t *sb;
 				bitmap->need_sync = 0;
 				sb = kmap_atomic(bitmap->sb_page, KM_USER0);
@@ -1176,7 +1192,8 @@ void bitmap_daemon_work(mddev_t *mddev)
 				write_page(bitmap, bitmap->sb_page, 1);
 			}
 			spin_lock_irqsave(&bitmap->lock, flags);
-			clear_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
+			if (!bitmap->need_sync)
+				clear_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}
 		bmc = bitmap_get_counter(bitmap,
 					 (sector_t)j << CHUNK_BLOCK_SHIFT(bitmap),
@@ -1191,7 +1208,7 @@ void bitmap_daemon_work(mddev_t *mddev)
 			if (*bmc == 2) {
 				*bmc=1; /* maybe clear the bit next time */
 				set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
-			} else if (*bmc == 1) {
+			} else if (*bmc == 1 && !bitmap->need_sync) {
 				/* we can clear the bit */
 				*bmc = 0;
 				bitmap_count_page(bitmap,
@@ -1201,9 +1218,11 @@ void bitmap_daemon_work(mddev_t *mddev)
 				/* clear the bit */
 				paddr = kmap_atomic(page, KM_USER0);
 				if (bitmap->flags & BITMAP_HOSTENDIAN)
-					clear_bit(file_page_offset(j), paddr);
+					clear_bit(file_page_offset(bitmap, j),
+						  paddr);
 				else
-					ext2_clear_bit(file_page_offset(j), paddr);
+					ext2_clear_bit(file_page_offset(bitmap, j),
+						       paddr);
 				kunmap_atomic(paddr, KM_USER0);
 			}
 		} else
@@ -1358,6 +1377,7 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 		    bitmap->events_cleared < bitmap->mddev->events) {
 			bitmap->events_cleared = bitmap->mddev->events;
 			bitmap->need_sync = 1;
+			sysfs_notify_dirent(bitmap->sysfs_can_clear);
 		}
 
 		if (!success && ! (*bmc & NEEDED_MASK))
@@ -1615,6 +1635,9 @@ void bitmap_destroy(mddev_t *mddev)
 	if (mddev->thread)
 		mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
 
+	if (bitmap->sysfs_can_clear)
+		sysfs_put(bitmap->sysfs_can_clear);
+
 	bitmap_free(bitmap);
 }
 
@@ -1631,6 +1654,7 @@ int bitmap_create(mddev_t *mddev)
 	struct file *file = mddev->bitmap_info.file;
 	int err;
 	sector_t start;
+	struct sysfs_dirent *bm;
 
 	BUILD_BUG_ON(sizeof(bitmap_super_t) != 256);
 
@@ -1650,6 +1674,13 @@ int bitmap_create(mddev_t *mddev)
 
 	bitmap->mddev = mddev;
 
+	bm = sysfs_get_dirent(mddev->kobj.sd, "bitmap");
+	if (bm) {
+		bitmap->sysfs_can_clear = sysfs_get_dirent(bm, "can_clear");
+		sysfs_put(bm);
+	} else
+		bitmap->sysfs_can_clear = NULL;
+
 	bitmap->file = file;
 	if (file) {
 		get_file(file);
@@ -1660,7 +1691,11 @@ int bitmap_create(mddev_t *mddev)
 		vfs_fsync(file, file->f_dentry, 1);
 	}
 	/* read superblock from bitmap file (this sets mddev->bitmap_info.chunksize) */
-	err = bitmap_read_sb(bitmap);
+	if (!mddev->bitmap_info.external)
+		err = bitmap_read_sb(bitmap);
+	else
+		/* FIXME validate chunksize etc */
+		err = 0;
 	if (err)
 		goto error;
 
@@ -1915,11 +1950,66 @@ chunksize_store(mddev_t *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry bitmap_chunksize =
 __ATTR(chunksize, S_IRUGO|S_IWUSR, chunksize_show, chunksize_store);
 
+static ssize_t metadata_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%s\n", (mddev->bitmap_info.external
+				      ? "external" : "internal"));
+}
+
+static ssize_t metadata_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	if (mddev->bitmap ||
+	    mddev->bitmap_info.file ||
+	    mddev->bitmap_info.offset)
+		return -EBUSY;
+	if (strncmp(buf, "external", 8) == 0)
+		mddev->bitmap_info.external = 1;
+	else if (strncmp(buf, "internal", 8) == 0)
+		mddev->bitmap_info.external = 0;
+	else
+		return -EINVAL;
+	return len;
+}
+
+static struct md_sysfs_entry bitmap_metadata =
+__ATTR(metadata, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
+
+static ssize_t can_clear_show(mddev_t *mddev, char *page)
+{
+	int len;
+	if (mddev->bitmap)
+		len = sprintf(page, "%s\n", (mddev->bitmap->need_sync ?
+					     "false" : "true"));
+	else
+		len = sprintf(page, "\n");
+	return len;
+}
+
+static ssize_t can_clear_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	if (mddev->bitmap == 0)
+		return -ENOENT;
+	if (strncmp(buf, "false", 5) == 0)
+		mddev->bitmap->need_sync = 1;
+	else if (strncmp(buf, "true", 4) == 0) {
+		if (mddev->degraded)
+			return -EBUSY;
+		mddev->bitmap->need_sync = 0;
+	} else
+		return -EINVAL;
+	return len;
+}
+
+static struct md_sysfs_entry bitmap_can_clear =
+__ATTR(can_clear, S_IRUGO|S_IWUSR, can_clear_show, can_clear_store);
+
 static struct attribute *md_bitmap_attrs[] = {
 	&bitmap_location.attr,
 	&bitmap_timeout.attr,
 	&bitmap_backlog.attr,
 	&bitmap_chunksize.attr,
+	&bitmap_metadata.attr,
+	&bitmap_can_clear.attr,
 	NULL
 };
 struct attribute_group md_bitmap_group = {
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 50ee424..cb821d7 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -118,16 +118,6 @@ typedef __u16 bitmap_counter_t;
 			(CHUNK_BLOCK_SHIFT(bitmap) + PAGE_COUNTER_SHIFT - 1)
 #define PAGEPTR_BLOCK_MASK(bitmap) (PAGEPTR_BLOCK_RATIO(bitmap) - 1)
 
-/*
- * on-disk bitmap:
- *
- * Use one bit per "chunk" (block set). We do the disk I/O on the bitmap
- * file a page at a time. There's a superblock at the start of the file.
- */
-
-/* map chunks (bits) to file pages - offset by the size of the superblock */
-#define CHUNK_BIT_OFFSET(chunk) ((chunk) + (sizeof(bitmap_super_t) << 3))
-
 #endif
 
 /*
@@ -250,6 +240,7 @@ struct bitmap {
 	wait_queue_head_t write_wait;
 	wait_queue_head_t overflow_wait;
 
+	struct sysfs_dirent *sysfs_can_clear;
 };
 
 /* the bitmap API */
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 05b91c3..b74b05d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -295,6 +295,7 @@ struct mddev_s
 		unsigned long		chunksize;
 		unsigned long		daemon_sleep; /* how many seconds between updates? */
 		unsigned long		max_write_behind; /* write-behind mode */
+		int			external;
 	} bitmap_info;
 	struct list_head		all_mddevs;
 


