From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/24] md/bitmap: move some fields of 'struct bitmap' into
 a 'storage' substruct.
Date: Tue, 17 Apr 2012 18:43:40 +1000
Message-ID: <20120417084340.6433.64880.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This new 'struct bitmap_storage' reflects the external storage of the
bitmap.
Having this clearly defined will make it easier to change the storage
used while the array is active.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |  180 +++++++++++++++++++++++++++------------------------
 drivers/md/bitmap.h |   17 +++--
 drivers/md/md.c     |    9 +--
 3 files changed, 110 insertions(+), 96 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index d655399..614062a 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -195,6 +195,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 	struct md_rdev *rdev = NULL;
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
+	struct bitmap_storage *store = &bitmap->storage;
 
 	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
 		int size = PAGE_SIZE;
@@ -202,8 +203,8 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 
 		bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
 
-		if (page->index == bitmap->file_pages-1)
-			size = roundup(bitmap->last_page_size,
+		if (page->index == store->file_pages-1)
+			size = roundup(store->last_page_size,
 				       bdev_logical_block_size(bdev));
 		/* Just make sure we aren't corrupting data or
 		 * metadata
@@ -263,7 +264,7 @@ static void write_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	struct buffer_head *bh;
 
-	if (bitmap->file == NULL) {
+	if (bitmap->storage.file == NULL) {
 		switch (write_sb_page(bitmap, page, wait)) {
 		case -EINVAL:
 			bitmap->flags |= BITMAP_WRITE_ERROR;
@@ -408,9 +409,9 @@ void bitmap_update_sb(struct bitmap *bitmap)
 		return;
 	if (bitmap->mddev->bitmap_info.external)
 		return;
-	if (!bitmap->sb_page) /* no superblock */
+	if (!bitmap->storage.sb_page) /* no superblock */
 		return;
-	sb = kmap_atomic(bitmap->sb_page);
+	sb = kmap_atomic(bitmap->storage.sb_page);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
 	if (bitmap->mddev->events < bitmap->events_cleared)
 		/* rocking back to read-only */
@@ -421,7 +422,7 @@ void bitmap_update_sb(struct bitmap *bitmap)
 	sb->daemon_sleep = cpu_to_le32(bitmap->mddev->bitmap_info.daemon_sleep/HZ);
 	sb->write_behind = cpu_to_le32(bitmap->mddev->bitmap_info.max_write_behind);
 	kunmap_atomic(sb);
-	write_page(bitmap, bitmap->sb_page, 1);
+	write_page(bitmap, bitmap->storage.sb_page, 1);
 }
 
 /* print out the bitmap file superblock */
@@ -429,9 +430,9 @@ void bitmap_print_sb(struct bitmap *bitmap)
 {
 	bitmap_super_t *sb;
 
-	if (!bitmap || !bitmap->sb_page)
+	if (!bitmap || !bitmap->storage.sb_page)
 		return;
-	sb = kmap_atomic(bitmap->sb_page);
+	sb = kmap_atomic(bitmap->storage.sb_page);
 	printk(KERN_DEBUG "%s: bitmap file superblock:\n", bmname(bitmap));
 	printk(KERN_DEBUG "         magic: %08x\n", le32_to_cpu(sb->magic));
 	printk(KERN_DEBUG "       version: %d\n", le32_to_cpu(sb->version));
@@ -470,15 +471,15 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 	unsigned long chunksize, daemon_sleep, write_behind;
 	int err = -EINVAL;
 
-	bitmap->sb_page = alloc_page(GFP_KERNEL);
-	if (IS_ERR(bitmap->sb_page)) {
-		err = PTR_ERR(bitmap->sb_page);
-		bitmap->sb_page = NULL;
+	bitmap->storage.sb_page = alloc_page(GFP_KERNEL);
+	if (IS_ERR(bitmap->storage.sb_page)) {
+		err = PTR_ERR(bitmap->storage.sb_page);
+		bitmap->storage.sb_page = NULL;
 		return err;
 	}
-	bitmap->sb_page->index = 0;
+	bitmap->storage.sb_page->index = 0;
 
-	sb = kmap_atomic(bitmap->sb_page);
+	sb = kmap_atomic(bitmap->storage.sb_page);
 
 	sb->magic = cpu_to_le32(BITMAP_MAGIC);
 	sb->version = cpu_to_le32(BITMAP_MAJOR_HI);
@@ -536,7 +537,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	int err = -EINVAL;
 	struct page *sb_page;
 
-	if (!bitmap->file && !bitmap->mddev->bitmap_info.offset) {
+	if (!bitmap->storage.file && !bitmap->mddev->bitmap_info.offset) {
 		chunksize = 128 * 1024 * 1024;
 		daemon_sleep = 5 * HZ;
 		write_behind = 0;
@@ -548,13 +549,13 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	sb_page = alloc_page(GFP_KERNEL);
 	if (!sb_page)
 		return -ENOMEM;
-	bitmap->sb_page = sb_page;
+	bitmap->storage.sb_page = sb_page;
 
-	if (bitmap->file) {
-		loff_t isize = i_size_read(bitmap->file->f_mapping->host);
+	if (bitmap->storage.file) {
+		loff_t isize = i_size_read(bitmap->storage.file->f_mapping->host);
 		int bytes = isize > PAGE_SIZE ? PAGE_SIZE : isize;
 
-		err = read_page(bitmap->file, 0,
+		err = read_page(bitmap->storage.file, 0,
 				bitmap, bytes, sb_page);
 	} else {
 		err = read_sb_page(bitmap->mddev,
@@ -647,9 +648,9 @@ static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
 	bitmap_super_t *sb;
 	int old;
 
-	if (!bitmap->sb_page) /* can't set the state */
+	if (!bitmap->storage.sb_page) /* can't set the state */
 		return 0;
-	sb = kmap_atomic(bitmap->sb_page);
+	sb = kmap_atomic(bitmap->storage.sb_page);
 	old = le32_to_cpu(sb->state) & bits;
 	switch (op) {
 	case MASK_SET:
@@ -678,17 +679,19 @@ static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
  * file a page at a time. There's a superblock at the start of the file.
  */
 /* calculate the index of the page that contains this bit */
-static inline unsigned long file_page_index(struct bitmap *bitmap, unsigned long chunk)
+static inline unsigned long file_page_index(struct bitmap_storage *store,
+					    unsigned long chunk)
 {
-	if (!bitmap->mddev->bitmap_info.external)
+	if (store->sb_page)
 		chunk += sizeof(bitmap_super_t) << 3;
 	return chunk >> PAGE_BIT_SHIFT;
 }
 
 /* calculate the (bit) offset of this bit within a page */
-static inline unsigned long file_page_offset(struct bitmap *bitmap, unsigned long chunk)
+static inline unsigned long file_page_offset(struct bitmap_storage *store,
+					     unsigned long chunk)
 {
-	if (!bitmap->mddev->bitmap_info.external)
+	if (store->sb_page)
 		chunk += sizeof(bitmap_super_t) << 3;
 	return chunk & (PAGE_BITS - 1);
 }
@@ -700,13 +703,13 @@ static inline unsigned long file_page_offset(struct bitmap *bitmap, unsigned lon
  * 1 page (e.g., x86) or less than 1 page -- so the bitmap might start on page
  * 0 or page 1
  */
-static inline struct page *filemap_get_page(struct bitmap *bitmap,
+static inline struct page *filemap_get_page(struct bitmap_storage *store,
 					    unsigned long chunk)
 {
-	if (file_page_index(bitmap, chunk) >= bitmap->file_pages)
+	if (file_page_index(store, chunk) >= store->file_pages)
 		return NULL;
-	return bitmap->filemap[file_page_index(bitmap, chunk)
-			       - file_page_index(bitmap, 0)];
+	return store->filemap[file_page_index(store, chunk)
+			      - file_page_index(store, 0)];
 }
 
 static void bitmap_file_unmap(struct bitmap *bitmap)
@@ -715,16 +718,17 @@ static void bitmap_file_unmap(struct bitmap *bitmap)
 	unsigned long *attr;
 	int pages;
 	unsigned long flags;
+	struct bitmap_storage *store = &bitmap->storage;
 
 	spin_lock_irqsave(&bitmap->lock, flags);
-	map = bitmap->filemap;
-	bitmap->filemap = NULL;
-	attr = bitmap->filemap_attr;
-	bitmap->filemap_attr = NULL;
-	pages = bitmap->file_pages;
-	bitmap->file_pages = 0;
-	sb_page = bitmap->sb_page;
-	bitmap->sb_page = NULL;
+	map = store->filemap;
+	store->filemap = NULL;
+	attr = store->filemap_attr;
+	store->filemap_attr = NULL;
+	pages = store->file_pages;
+	store->file_pages = 0;
+	sb_page = store->sb_page;
+	store->sb_page = NULL;
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 
 	while (pages--)
@@ -743,8 +747,8 @@ static void bitmap_file_put(struct bitmap *bitmap)
 	unsigned long flags;
 
 	spin_lock_irqsave(&bitmap->lock, flags);
-	file = bitmap->file;
-	bitmap->file = NULL;
+	file = bitmap->storage.file;
+	bitmap->storage.file = NULL;
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 
 	if (file)
@@ -771,11 +775,11 @@ static void bitmap_file_kick(struct bitmap *bitmap)
 	if (bitmap_mask_state(bitmap, BITMAP_STALE, MASK_SET) == 0) {
 		bitmap_update_sb(bitmap);
 
-		if (bitmap->file) {
+		if (bitmap->storage.file) {
 			path = kmalloc(PAGE_SIZE, GFP_KERNEL);
 			if (path)
-				ptr = d_path(&bitmap->file->f_path, path,
-					     PAGE_SIZE);
+				ptr = d_path(&bitmap->storage.file->f_path,
+					     path, PAGE_SIZE);
 
 			printk(KERN_ALERT
 			      "%s: kicking failed bitmap file %s from array!\n",
@@ -803,19 +807,19 @@ enum bitmap_page_attr {
 static inline void set_page_attr(struct bitmap *bitmap, int pnum,
 				 enum bitmap_page_attr attr)
 {
-	__set_bit((pnum<<2) + attr, bitmap->filemap_attr);
+	__set_bit((pnum<<2) + attr, bitmap->storage.filemap_attr);
 }
 
 static inline void clear_page_attr(struct bitmap *bitmap, int pnum,
 				   enum bitmap_page_attr attr)
 {
-	__clear_bit((pnum<<2) + attr, bitmap->filemap_attr);
+	__clear_bit((pnum<<2) + attr, bitmap->storage.filemap_attr);
 }
 
 static inline unsigned long test_page_attr(struct bitmap *bitmap, int pnum,
 					   enum bitmap_page_attr attr)
 {
-	return test_bit((pnum<<2) + attr, bitmap->filemap_attr);
+	return test_bit((pnum<<2) + attr, bitmap->storage.filemap_attr);
 }
 
 /*
@@ -832,10 +836,10 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	void *kaddr;
 	unsigned long chunk = block >> bitmap->chunkshift;
 
-	page = filemap_get_page(bitmap, chunk);
+	page = filemap_get_page(&bitmap->storage, chunk);
 	if (!page)
 		return;
-	bit = file_page_offset(bitmap, chunk);
+	bit = file_page_offset(&bitmap->storage, chunk);
 
 	/* set the bit */
 	kaddr = kmap_atomic(page);
@@ -856,10 +860,10 @@ static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	void *paddr;
 	unsigned long chunk = block >> bitmap->chunkshift;
 
-	page = filemap_get_page(bitmap, chunk);
+	page = filemap_get_page(&bitmap->storage, chunk);
 	if (!page)
 		return;
-	bit = file_page_offset(bitmap, chunk);
+	bit = file_page_offset(&bitmap->storage, chunk);
 	paddr = kmap_atomic(page);
 	if (bitmap->flags & BITMAP_HOSTENDIAN)
 		clear_bit(bit, paddr);
@@ -881,14 +885,14 @@ void bitmap_unplug(struct bitmap *bitmap)
 	int dirty, need_write;
 	int wait = 0;
 
-	if (!bitmap || !bitmap->filemap)
+	if (!bitmap || !bitmap->storage.filemap)
 		return;
 
 	/* look at each page to see if there are any set bits that need to be
 	 * flushed out to disk */
-	for (i = 0; i < bitmap->file_pages; i++) {
+	for (i = 0; i < bitmap->storage.file_pages; i++) {
 		spin_lock_irqsave(&bitmap->lock, flags);
-		if (!bitmap->filemap) {
+		if (!bitmap->storage.filemap) {
 			spin_unlock_irqrestore(&bitmap->lock, flags);
 			return;
 		}
@@ -903,10 +907,10 @@ void bitmap_unplug(struct bitmap *bitmap)
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 
 		if (dirty || need_write)
-			write_page(bitmap, bitmap->filemap[i], 0);
+			write_page(bitmap, bitmap->storage.filemap[i], 0);
 	}
 	if (wait) { /* if any writes were performed, we need to wait on them */
-		if (bitmap->file)
+		if (bitmap->storage.file)
 			wait_event(bitmap->write_wait,
 				   atomic_read(&bitmap->pending_writes)==0);
 		else
@@ -940,14 +944,15 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	int outofdate;
 	int ret = -ENOSPC;
 	void *paddr;
+	struct bitmap_storage *store = &bitmap->storage;
 
 	chunks = bitmap->chunks;
-	file = bitmap->file;
+	file = store->file;
 
 	if (!file && !bitmap->mddev->bitmap_info.offset) {
 		/* No permanent bitmap - fill with '1s'. */
-		bitmap->filemap = NULL;
-		bitmap->file_pages = 0;
+		store->filemap = NULL;
+		store->file_pages = 0;
 		for (i = 0; i < chunks ; i++) {
 			/* if the disk bit is set, set the memory bit */
 			int needed = ((sector_t)(i+1) << (bitmap->chunkshift)
@@ -980,39 +985,40 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 
 	ret = -ENOMEM;
 
-	bitmap->filemap = kmalloc(sizeof(struct page *) * num_pages, GFP_KERNEL);
-	if (!bitmap->filemap)
+	store->filemap = kmalloc(sizeof(struct page *)
+					  * num_pages, GFP_KERNEL);
+	if (!store->filemap)
 		goto err;
 
 	pnum = 0;
 	offset = 0;
-	if (bitmap->sb_page) {
-		bitmap->filemap[0] = bitmap->sb_page;
+	if (store->sb_page) {
+		store->filemap[0] = store->sb_page;
 		pnum = 1;
 		offset = sizeof(bitmap_super_t);
 	}
 	for ( ; pnum < num_pages; pnum++) {
-		bitmap->filemap[pnum] = alloc_page(GFP_KERNEL);
-		if (!bitmap->filemap[pnum]) {
-			bitmap->file_pages = pnum;
+		store->filemap[pnum] = alloc_page(GFP_KERNEL);
+		if (!store->filemap[pnum]) {
+			store->file_pages = pnum;
 			goto err;
 		}
 	}
-	bitmap->file_pages = pnum;
+	store->file_pages = pnum;
 
 	/* We need 4 bits per page, rounded up to a multiple of sizeof(unsigned long) */
-	bitmap->filemap_attr = kzalloc(
+	store->filemap_attr = kzalloc(
 		roundup(DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
 		GFP_KERNEL);
-	if (!bitmap->filemap_attr)
+	if (!store->filemap_attr)
 		goto err;
 
 	oldindex = ~0L;
 
 	for (i = 0; i < chunks; i++) {
 		int b;
-		index = file_page_index(bitmap, i);
-		bit = file_page_offset(bitmap, i);
+		index = file_page_index(&bitmap->storage, i);
+		bit = file_page_offset(&bitmap->storage, i);
 		if (index != oldindex) { /* this is a new page, read it in */
 			int count;
 			/* unmap the old page, we're done with it */
@@ -1020,7 +1026,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 				count = bytes - index * PAGE_SIZE;
 			else
 				count = PAGE_SIZE;
-			page = bitmap->filemap[index];
+			page = store->filemap[index];
 			if (file)
 				ret = read_page(file, index, bitmap,
 						count, page);
@@ -1036,7 +1042,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 
 			oldindex = index;
 
-			bitmap->last_page_size = count;
+			store->last_page_size = count;
 
 			if (outofdate) {
 				/*
@@ -1074,7 +1080,8 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 
 	printk(KERN_INFO "%s: bitmap initialized from disk: "
 	       "read %lu/%lu pages, set %lu of %lu bits\n",
-	       bmname(bitmap), bitmap->file_pages, num_pages, bit_cnt, chunks);
+	       bmname(bitmap), store->file_pages,
+	       num_pages, bit_cnt, chunks);
 
 	return 0;
 
@@ -1091,14 +1098,14 @@ void bitmap_write_all(struct bitmap *bitmap)
 	 */
 	int i;
 
-	if (!bitmap || !bitmap->filemap)
+	if (!bitmap || !bitmap->storage.filemap)
 		return;
-	if (bitmap->file)
+	if (bitmap->storage.file)
 		/* Only one copy, so nothing needed */
 		return;
 
 	spin_lock_irq(&bitmap->lock);
-	for (i = 0; i < bitmap->file_pages; i++)
+	for (i = 0; i < bitmap->storage.file_pages; i++)
 		set_page_attr(bitmap, i,
 			      BITMAP_PAGE_NEEDWRITE);
 	bitmap->allclean = 0;
@@ -1165,7 +1172,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 	 * we will write it.
 	 */
 	spin_lock_irqsave(&bitmap->lock, flags);
-	for (j = 0; j < bitmap->file_pages; j++)
+	for (j = 0; j < bitmap->storage.file_pages; j++)
 		if (test_page_attr(bitmap, j,
 				   BITMAP_PAGE_PENDING)) {
 			set_page_attr(bitmap, j,
@@ -1180,8 +1187,8 @@ void bitmap_daemon_work(struct mddev *mddev)
 		 * other changes */
 		bitmap_super_t *sb;
 		bitmap->need_sync = 0;
-		if (bitmap->filemap) {
-			sb = kmap_atomic(bitmap->sb_page);
+		if (bitmap->storage.filemap) {
+			sb = kmap_atomic(bitmap->storage.sb_page);
 			sb->events_cleared =
 				cpu_to_le64(bitmap->events_cleared);
 			kunmap_atomic(sb);
@@ -1233,7 +1240,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 	 * the first blocking holds the superblock and it has been updated.
 	 * We mustn't write any other blocks before the superblock.
 	 */
-	for (j = 0; j < bitmap->file_pages; j++) {
+	for (j = 0; j < bitmap->storage.file_pages; j++) {
 
 		if (test_page_attr(bitmap, j,
 				    BITMAP_PAGE_DIRTY))
@@ -1244,9 +1251,9 @@ void bitmap_daemon_work(struct mddev *mddev)
 			clear_page_attr(bitmap, j,
 					BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
-			write_page(bitmap, bitmap->filemap[j], 0);
+			write_page(bitmap, bitmap->storage.filemap[j], 0);
 			spin_lock_irqsave(&bitmap->lock, flags);
-			if (!bitmap->filemap)
+			if (!bitmap->storage.filemap)
 				break;
 		}
 	}
@@ -1700,7 +1707,7 @@ int bitmap_create(struct mddev *mddev)
 	} else
 		bitmap->sysfs_can_clear = NULL;
 
-	bitmap->file = file;
+	bitmap->storage.file = file;
 	if (file) {
 		get_file(file);
 		/* As future accesses to this file will use bmap,
@@ -1833,9 +1840,9 @@ void bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
 		   << (PAGE_SHIFT - 10),
 		   chunk_kb ? chunk_kb : bitmap->mddev->bitmap_info.chunksize,
 		   chunk_kb ? "KB" : "B");
-	if (bitmap->file) {
+	if (bitmap->storage.file) {
 		seq_printf(seq, ", file: ");
-		seq_path(seq, &bitmap->file->f_path, " \t\n");
+		seq_path(seq, &bitmap->storage.file->f_path, " \t\n");
 	}
 
 	seq_printf(seq, "\n");
@@ -1959,8 +1966,9 @@ space_store(struct mddev *mddev, const char *buf, size_t len)
 		return -EINVAL;
 
 	if (mddev->bitmap &&
-	    sectors  < ((mddev->bitmap->file_pages - 1) * PAGE_SIZE
-			+ mddev->bitmap->last_page_size + 511) >> 9)
+	    sectors  < ((mddev->bitmap->storage.file_pages - 1)
+			      * PAGE_SIZE
+			+ mddev->bitmap->storage.last_page_size + 511) >> 9)
 		return -EFBIG; /* Bitmap is too big for this small space */
 
 	/* could make sure it isn't too big, but that isn't really
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 5563043..3cdea44 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -191,12 +191,17 @@ struct bitmap {
 	/* bitmap spinlock */
 	spinlock_t lock;
 
-	struct file *file; /* backing disk file */
-	struct page *sb_page; /* cached copy of the bitmap file superblock */
-	struct page **filemap; /* list of cache pages for the file */
-	unsigned long *filemap_attr; /* attributes associated w/ filemap pages */
-	unsigned long file_pages; /* number of pages in the file */
-	int last_page_size; /* bytes in the last page */
+	struct bitmap_storage {
+		struct file *file;		/* backing disk file */
+		struct page *sb_page;		/* cached copy of the bitmap
+						 * file superblock */
+		struct page **filemap;		/* list of cache pages for
+						 * the file */
+		unsigned long *filemap_attr;	/* attributes associated
+						 * w/ filemap pages */
+		unsigned long file_pages;	/* number of pages in the file*/
+		int last_page_size;		/* bytes in the last page */
+	} storage;
 
 	unsigned long flags;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index e84e2e6..9524192 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1989,7 +1989,7 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 	bitmap = rdev->mddev->bitmap;
 	if (bitmap && !rdev->mddev->bitmap_info.file &&
 	    rdev->sb_start + rdev->mddev->bitmap_info.offset +
-	    bitmap->file_pages * (PAGE_SIZE>>9) > new_offset)
+	    bitmap->storage.file_pages * (PAGE_SIZE>>9) > new_offset)
 		return 0;
 	if (rdev->badblocks.sector + rdev->badblocks.size > new_offset)
 		return 0;
@@ -5649,7 +5649,7 @@ static int get_bitmap_file(struct mddev * mddev, void __user * arg)
 		goto out;
 
 	/* bitmap disabled, zero the first byte and copy out */
-	if (!mddev->bitmap || !mddev->bitmap->file) {
+	if (!mddev->bitmap || !mddev->bitmap->storage.file) {
 		file->pathname[0] = '\0';
 		goto copy_out;
 	}
@@ -5658,7 +5658,8 @@ static int get_bitmap_file(struct mddev * mddev, void __user * arg)
 	if (!buf)
 		goto out;
 
-	ptr = d_path(&mddev->bitmap->file->f_path, buf, sizeof(file->pathname));
+	ptr = d_path(&mddev->bitmap->storage.file->f_path,
+		     buf, sizeof(file->pathname));
 	if (IS_ERR(ptr))
 		goto out;
 
@@ -6299,7 +6300,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 			/* remove the bitmap */
 			if (!mddev->bitmap)
 				return -ENOENT;
-			if (mddev->bitmap->file)
+			if (mddev->bitmap->storage.file)
 				return -EINVAL;
 			mddev->pers->quiesce(mddev, 1);
 			bitmap_destroy(mddev);


