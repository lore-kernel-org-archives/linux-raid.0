From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 20/24] md/bitmap: add bitmap_resize function to allow
 bitmap resizing.
Date: Tue, 17 Apr 2012 18:43:42 +1000
Message-ID: <20120417084342.6433.10586.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This function will allocate the new data structures and copy
bits across from old to new, allowing for the possibility that the
chunksize has changed.

Use the same function for performing the initial allocation
of the structures.  This improves test coverage.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |  191 +++++++++++++++++++++++++++++++++++++++++++--------
 drivers/md/bitmap.h |    3 +
 2 files changed, 165 insertions(+), 29 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index bcd5107..dc5ec72 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1630,8 +1630,6 @@ int bitmap_create(struct mddev *mddev)
 {
 	struct bitmap *bitmap;
 	sector_t blocks = mddev->resync_max_sectors;
-	unsigned long chunks;
-	unsigned long pages;
 	struct file *file = mddev->bitmap_info.file;
 	int err;
 	struct sysfs_dirent *bm = NULL;
@@ -1691,38 +1689,14 @@ int bitmap_create(struct mddev *mddev)
 		goto error;
 
 	bitmap->daemon_lastrun = jiffies;
-	bitmap->counts.chunkshift = (ffz(~mddev->bitmap_info.chunksize)
-			      - BITMAP_BLOCK_SHIFT);
-
-	/* now that chunksize and chunkshift are set, we can use these macros */
-	chunks = DIV_ROUND_UP(blocks, CHUNK_BLOCK_RATIO(bitmap));
-	pages = DIV_ROUND_UP(chunks, PAGE_COUNTER_RATIO);
-
-	BUG_ON(!pages);
-
-	bitmap->counts.chunks = chunks;
-	bitmap->counts.pages = pages;
-	bitmap->counts.missing_pages = pages;
-
-	bitmap->counts.bp = kzalloc(pages * sizeof(*bitmap->counts.bp),
-				    GFP_KERNEL);
-
-	err = -ENOMEM;
-	if (!bitmap->counts.bp)
+	err = bitmap_resize(bitmap, blocks, mddev->bitmap_info.chunksize, 1);
+	if (err)
 		goto error;
 
-	if (file || mddev->bitmap_info.offset) {
-		err = bitmap_storage_alloc(&bitmap->storage, bitmap->counts.chunks,
-					   !mddev->bitmap_info.external);
-		if (err)
-			goto error;
-	}
 	printk(KERN_INFO "created bitmap (%lu pages) for device %s\n",
-		pages, bmname(bitmap));
+	       bitmap->counts.pages, bmname(bitmap));
 
 	mddev->bitmap = bitmap;
-
-
 	return test_bit(BITMAP_WRITE_ERROR, &bitmap->flags) ? -EIO : 0;
 
  error:
@@ -1808,6 +1782,165 @@ void bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
 	seq_printf(seq, "\n");
 }
 
+int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
+		  int chunksize, int init)
+{
+	/* If chunk_size is 0, choose an appropriate chunk size.
+	 * Then possibly allocate new storage space.
+	 * Then quiesce, copy bits, replace bitmap, and re-start
+	 *
+	 * This function is called both to set up the initial bitmap
+	 * and to resize the bitmap while the array is active.
+	 * If this happens as a result of the array being resized,
+	 * chunksize will be zero, and we need to choose a suitable
+	 * chunksize, otherwise we use what we are given.
+	 */
+	struct bitmap_storage store;
+	struct bitmap_counts old_counts;
+	sector_t chunks;
+	sector_t block;
+	long old_blocks, new_blocks;
+	int chunkshift;
+	int ret = 0;
+	long pages;
+	struct bitmap_page *new_bp;
+
+	if (chunksize == 0) {
+		/* If there is enough space, leave the chunk size unchanged,
+		 * else increase by factor of two until there is enough space.
+		 */
+		long bytes;
+		long space = bitmap->mddev->bitmap_info.space;
+
+		if (space == 0) {
+			/* We don't know how much space there is, so limit
+			 * to current size.
+			 */
+			space = DIV_ROUND_UP(bitmap->counts.chunks, 8 * 512);
+		}
+		chunkshift = bitmap->counts.chunkshift;
+		chunkshift--;
+		do {
+			/* 'chunkshift' is shift from block size to chunk size */
+			chunkshift++;
+			chunks = DIV_ROUND_UP(blocks, 1 << chunkshift);
+			bytes = DIV_ROUND_UP(chunks, 8);
+			if (!bitmap->mddev->bitmap_info.external)
+				bytes += sizeof(bitmap_super_t);
+		} while (bytes > (space << 9));
+	} else
+		chunkshift = ffz(~chunksize) - BITMAP_BLOCK_SHIFT;
+
+	chunks = DIV_ROUND_UP(blocks, 1 << chunkshift);
+	memset(&store, 0, sizeof(store));
+	if (bitmap->mddev->bitmap_info.offset || bitmap->mddev->bitmap_info.file)
+		ret = bitmap_storage_alloc(&store, chunks,
+					   !bitmap->mddev->bitmap_info.external);
+	if (ret)
+		goto err;
+
+	pages = DIV_ROUND_UP(chunks, PAGE_COUNTER_RATIO);
+
+	new_bp = kzalloc(pages * sizeof(*new_bp), GFP_KERNEL);
+	ret = -ENOMEM;
+	if (!new_bp) {
+		bitmap_file_unmap(&store);
+		goto err;
+	}
+
+	if (!init)
+		bitmap->mddev->pers->quiesce(bitmap->mddev, 1);
+
+	store.file = bitmap->storage.file;
+	bitmap->storage.file = NULL;
+
+	if (store.sb_page && bitmap->storage.sb_page)
+		memcpy(page_address(store.sb_page),
+		       page_address(bitmap->storage.sb_page),
+		       sizeof(bitmap_super_t));
+	bitmap_file_unmap(&bitmap->storage);
+	bitmap->storage = store;
+
+	old_counts = bitmap->counts;
+	bitmap->counts.bp = new_bp;
+	bitmap->counts.pages = pages;
+	bitmap->counts.missing_pages = pages;
+	bitmap->counts.chunkshift = chunkshift;
+	bitmap->counts.chunks = chunks;
+	bitmap->mddev->bitmap_info.chunksize = 1 << (chunkshift +
+						     BITMAP_BLOCK_SHIFT);
+
+	blocks = min(old_counts.chunks << old_counts.chunkshift,
+		     chunks << chunkshift);
+
+	spin_lock_irq(&bitmap->counts.lock);
+	for (block = 0; block < blocks; ) {
+		bitmap_counter_t *bmc_old, *bmc_new;
+		int set;
+
+		bmc_old = bitmap_get_counter(&old_counts, block,
+					     &old_blocks, 0);
+		set = bmc_old && NEEDED(*bmc_old);
+
+		if (set) {
+			bmc_new = bitmap_get_counter(&bitmap->counts, block,
+						     &new_blocks, 1);
+			if (*bmc_new == 0) {
+				/* need to set on-disk bits too. */
+				sector_t end = block + new_blocks;
+				sector_t start = block >> chunkshift;
+				start <<= chunkshift;
+				while (start < end) {
+					bitmap_file_set_bit(bitmap, block);
+					start += 1 << chunkshift;
+				}
+				*bmc_new = 2;
+				bitmap_count_page(&bitmap->counts,
+						  block, 1);
+				bitmap_set_pending(&bitmap->counts,
+						   block);
+			}
+			*bmc_new |= NEEDED_MASK;
+			if (new_blocks < old_blocks)
+				old_blocks = new_blocks;
+		}
+		block += old_blocks;
+	}
+
+	if (!init) {
+		int i;
+		while (block < (chunks << chunkshift)) {
+			bitmap_counter_t *bmc;
+			bmc = bitmap_get_counter(&bitmap->counts, block,
+						 &new_blocks, 1);
+			if (bmc) {
+				/* new space.  It needs to be resynced, so
+				 * we set NEEDED_MASK.
+				 */
+				if (*bmc == 0) {
+					*bmc = NEEDED_MASK | 2;
+					bitmap_count_page(&bitmap->counts,
+							  block, 1);
+					bitmap_set_pending(&bitmap->counts,
+							   block);
+				}
+			}
+			block += new_blocks;
+		}
+		for (i = 0; i < bitmap->storage.file_pages; i++)
+			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
+	}
+	spin_unlock_irq(&bitmap->counts.lock);
+
+	if (!init) {
+		bitmap_unplug(bitmap);
+		bitmap->mddev->pers->quiesce(bitmap->mddev, 0);
+	}
+	ret = 0;
+err:
+	return ret;
+}
+
 static ssize_t
 location_show(struct mddev *mddev, char *page)
 {
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 530be4d..fd723d7 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -258,6 +258,9 @@ void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector);
 
 void bitmap_unplug(struct bitmap *bitmap);
 void bitmap_daemon_work(struct mddev *mddev);
+
+int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
+		  int chunksize, int init);
 #endif
 
 #endif


