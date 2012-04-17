From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 18/24] md/bitmap: create a 'struct bitmap_counts'
 substructure of 'struct bitmap'
Date: Tue, 17 Apr 2012 18:43:42 +1000
Message-ID: <20120417084342.6433.81970.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The new "struct bitmap_counts" contains all the fields that are
related to counting the number of active writes in each bitmap chunk.

Having this separate will make it easier to change the chunksize
or overall size of a bitmap atomically.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |  138 ++++++++++++++++++++++++++-------------------------
 drivers/md/bitmap.h |   23 +++++----
 2 files changed, 84 insertions(+), 77 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index e88e553..d2750a3 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -45,7 +45,7 @@ static inline char *bmname(struct bitmap *bitmap)
  * if we find our page, we increment the page's refcount so that it stays
  * allocated while we're using it
  */
-static int bitmap_checkpage(struct bitmap *bitmap,
+static int bitmap_checkpage(struct bitmap_counts *bitmap,
 			    unsigned long page, int create)
 __releases(bitmap->lock)
 __acquires(bitmap->lock)
@@ -76,8 +76,7 @@ __acquires(bitmap->lock)
 	spin_lock_irq(&bitmap->lock);
 
 	if (mappage == NULL) {
-		pr_debug("%s: bitmap map page allocation failed, hijacking\n",
-			 bmname(bitmap));
+		pr_debug("md/bitmap: map page allocation failed, hijacking\n");
 		/* failed - set the hijacked flag so that we can use the
 		 * pointer as a counter */
 		if (!bitmap->bp[page].map)
@@ -100,7 +99,7 @@ __acquires(bitmap->lock)
 /* if page is completely empty, put it back on the free list, or dealloc it */
 /* if page was hijacked, unmark the flag so it might get alloced next time */
 /* Note: lock should be held when calling this */
-static void bitmap_checkfree(struct bitmap *bitmap, unsigned long page)
+static void bitmap_checkfree(struct bitmap_counts *bitmap, unsigned long page)
 {
 	char *ptr;
 
@@ -830,7 +829,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	unsigned long bit;
 	struct page *page;
 	void *kaddr;
-	unsigned long chunk = block >> bitmap->chunkshift;
+	unsigned long chunk = block >> bitmap->counts.chunkshift;
 
 	page = filemap_get_page(&bitmap->storage, chunk);
 	if (!page)
@@ -854,7 +853,7 @@ static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	unsigned long bit;
 	struct page *page;
 	void *paddr;
-	unsigned long chunk = block >> bitmap->chunkshift;
+	unsigned long chunk = block >> bitmap->counts.chunkshift;
 
 	page = filemap_get_page(&bitmap->storage, chunk);
 	if (!page)
@@ -936,7 +935,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	void *paddr;
 	struct bitmap_storage *store = &bitmap->storage;
 
-	chunks = bitmap->chunks;
+	chunks = bitmap->counts.chunks;
 	file = store->file;
 
 	if (!file && !bitmap->mddev->bitmap_info.offset) {
@@ -945,10 +944,10 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		store->file_pages = 0;
 		for (i = 0; i < chunks ; i++) {
 			/* if the disk bit is set, set the memory bit */
-			int needed = ((sector_t)(i+1) << (bitmap->chunkshift)
+			int needed = ((sector_t)(i+1) << (bitmap->counts.chunkshift)
 				      >= start);
 			bitmap_set_memory_bits(bitmap,
-					       (sector_t)i << bitmap->chunkshift,
+					       (sector_t)i << bitmap->counts.chunkshift,
 					       needed);
 		}
 		return 0;
@@ -1024,10 +1023,10 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		kunmap_atomic(paddr);
 		if (b) {
 			/* if the disk bit is set, set the memory bit */
-			int needed = ((sector_t)(i+1) << bitmap->chunkshift
+			int needed = ((sector_t)(i+1) << bitmap->counts.chunkshift
 				      >= start);
 			bitmap_set_memory_bits(bitmap,
-					       (sector_t)i << bitmap->chunkshift,
+					       (sector_t)i << bitmap->counts.chunkshift,
 					       needed);
 			bit_cnt++;
 		}
@@ -1066,7 +1065,8 @@ void bitmap_write_all(struct bitmap *bitmap)
 	bitmap->allclean = 0;
 }
 
-static void bitmap_count_page(struct bitmap *bitmap, sector_t offset, int inc)
+static void bitmap_count_page(struct bitmap_counts *bitmap,
+			      sector_t offset, int inc)
 {
 	sector_t chunk = offset >> bitmap->chunkshift;
 	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
@@ -1074,7 +1074,7 @@ static void bitmap_count_page(struct bitmap *bitmap, sector_t offset, int inc)
 	bitmap_checkfree(bitmap, page);
 }
 
-static void bitmap_set_pending(struct bitmap *bitmap, sector_t offset)
+static void bitmap_set_pending(struct bitmap_counts *bitmap, sector_t offset)
 {
 	sector_t chunk = offset >> bitmap->chunkshift;
 	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
@@ -1084,7 +1084,7 @@ static void bitmap_set_pending(struct bitmap *bitmap, sector_t offset)
 		bp->pending = 1;
 }
 
-static bitmap_counter_t *bitmap_get_counter(struct bitmap *bitmap,
+static bitmap_counter_t *bitmap_get_counter(struct bitmap_counts *bitmap,
 					    sector_t offset, sector_t *blocks,
 					    int create);
 
@@ -1099,6 +1099,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 	unsigned long j;
 	unsigned long nextpage;
 	sector_t blocks;
+	struct bitmap_counts *counts;
 
 	/* Use a mutex to guard daemon_work against
 	 * bitmap_destroy.
@@ -1148,21 +1149,22 @@ void bitmap_daemon_work(struct mddev *mddev)
 	/* Now look at the bitmap counters and if any are '2' or '1',
 	 * decrement and handle accordingly.
 	 */
-	spin_lock_irq(&bitmap->lock);
+	counts = &bitmap->counts;
+	spin_lock_irq(&counts->lock);
 	nextpage = 0;
-	for (j = 0; j < bitmap->chunks; j++) {
+	for (j = 0; j < counts->chunks; j++) {
 		bitmap_counter_t *bmc;
-		sector_t  block = (sector_t)j << bitmap->chunkshift;
+		sector_t  block = (sector_t)j << counts->chunkshift;
 
 		if (j == nextpage) {
 			nextpage += PAGE_COUNTER_RATIO;
-			if (!bitmap->bp[j >> PAGE_COUNTER_SHIFT].pending) {
+			if (!counts->bp[j >> PAGE_COUNTER_SHIFT].pending) {
 				j |= PAGE_COUNTER_MASK;
 				continue;
 			}
-			bitmap->bp[j >> PAGE_COUNTER_SHIFT].pending = 0;
+			counts->bp[j >> PAGE_COUNTER_SHIFT].pending = 0;
 		}
-		bmc = bitmap_get_counter(bitmap,
+		bmc = bitmap_get_counter(counts,
 					 block,
 					 &blocks, 0);
 
@@ -1173,15 +1175,15 @@ void bitmap_daemon_work(struct mddev *mddev)
 		if (*bmc == 1 && !bitmap->need_sync) {
 			/* We can clear the bit */
 			*bmc = 0;
-			bitmap_count_page(bitmap, block, -1);
+			bitmap_count_page(counts, block, -1);
 			bitmap_file_clear_bit(bitmap, block);
 		} else if (*bmc && *bmc <= 2) {
 			*bmc = 1;
-			bitmap_set_pending(bitmap, block);
+			bitmap_set_pending(counts, block);
 			bitmap->allclean = 0;
 		}
 	}
-	spin_unlock_irq(&bitmap->lock);
+	spin_unlock_irq(&counts->lock);
 
 	/* Now start writeout on any page in NEEDWRITE that isn't DIRTY.
 	 * DIRTY pages need to be written by bitmap_unplug so it can wait
@@ -1215,7 +1217,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 	mutex_unlock(&mddev->bitmap_info.mutex);
 }
 
-static bitmap_counter_t *bitmap_get_counter(struct bitmap *bitmap,
+static bitmap_counter_t *bitmap_get_counter(struct bitmap_counts *bitmap,
 					    sector_t offset, sector_t *blocks,
 					    int create)
 __releases(bitmap->lock)
@@ -1277,10 +1279,10 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 		sector_t blocks;
 		bitmap_counter_t *bmc;
 
-		spin_lock_irq(&bitmap->lock);
-		bmc = bitmap_get_counter(bitmap, offset, &blocks, 1);
+		spin_lock_irq(&bitmap->counts.lock);
+		bmc = bitmap_get_counter(&bitmap->counts, offset, &blocks, 1);
 		if (!bmc) {
-			spin_unlock_irq(&bitmap->lock);
+			spin_unlock_irq(&bitmap->counts.lock);
 			return 0;
 		}
 
@@ -1292,7 +1294,7 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 			 */
 			prepare_to_wait(&bitmap->overflow_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
-			spin_unlock_irq(&bitmap->lock);
+			spin_unlock_irq(&bitmap->counts.lock);
 			io_schedule();
 			finish_wait(&bitmap->overflow_wait, &__wait);
 			continue;
@@ -1301,7 +1303,7 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 		switch (*bmc) {
 		case 0:
 			bitmap_file_set_bit(bitmap, offset);
-			bitmap_count_page(bitmap, offset, 1);
+			bitmap_count_page(&bitmap->counts, offset, 1);
 			/* fall through */
 		case 1:
 			*bmc = 2;
@@ -1309,7 +1311,7 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 
 		(*bmc)++;
 
-		spin_unlock_irq(&bitmap->lock);
+		spin_unlock_irq(&bitmap->counts.lock);
 
 		offset += blocks;
 		if (sectors > blocks)
@@ -1339,10 +1341,10 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 		unsigned long flags;
 		bitmap_counter_t *bmc;
 
-		spin_lock_irqsave(&bitmap->lock, flags);
-		bmc = bitmap_get_counter(bitmap, offset, &blocks, 0);
+		spin_lock_irqsave(&bitmap->counts.lock, flags);
+		bmc = bitmap_get_counter(&bitmap->counts, offset, &blocks, 0);
 		if (!bmc) {
-			spin_unlock_irqrestore(&bitmap->lock, flags);
+			spin_unlock_irqrestore(&bitmap->counts.lock, flags);
 			return;
 		}
 
@@ -1361,10 +1363,10 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 
 		(*bmc)--;
 		if (*bmc <= 2) {
-			bitmap_set_pending(bitmap, offset);
+			bitmap_set_pending(&bitmap->counts, offset);
 			bitmap->allclean = 0;
 		}
-		spin_unlock_irqrestore(&bitmap->lock, flags);
+		spin_unlock_irqrestore(&bitmap->counts.lock, flags);
 		offset += blocks;
 		if (sectors > blocks)
 			sectors -= blocks;
@@ -1383,8 +1385,8 @@ static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t
 		*blocks = 1024;
 		return 1; /* always resync if no bitmap */
 	}
-	spin_lock_irq(&bitmap->lock);
-	bmc = bitmap_get_counter(bitmap, offset, blocks, 0);
+	spin_lock_irq(&bitmap->counts.lock);
+	bmc = bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
 	rv = 0;
 	if (bmc) {
 		/* locked */
@@ -1398,7 +1400,7 @@ static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t
 			}
 		}
 	}
-	spin_unlock_irq(&bitmap->lock);
+	spin_unlock_irq(&bitmap->counts.lock);
 	return rv;
 }
 
@@ -1435,8 +1437,8 @@ void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, i
 		*blocks = 1024;
 		return;
 	}
-	spin_lock_irqsave(&bitmap->lock, flags);
-	bmc = bitmap_get_counter(bitmap, offset, blocks, 0);
+	spin_lock_irqsave(&bitmap->counts.lock, flags);
+	bmc = bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
 	if (bmc == NULL)
 		goto unlock;
 	/* locked */
@@ -1447,13 +1449,13 @@ void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, i
 			*bmc |= NEEDED_MASK;
 		else {
 			if (*bmc <= 2) {
-				bitmap_set_pending(bitmap, offset);
+				bitmap_set_pending(&bitmap->counts, offset);
 				bitmap->allclean = 0;
 			}
 		}
 	}
  unlock:
-	spin_unlock_irqrestore(&bitmap->lock, flags);
+	spin_unlock_irqrestore(&bitmap->counts.lock, flags);
 }
 EXPORT_SYMBOL(bitmap_end_sync);
 
@@ -1493,7 +1495,7 @@ void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
 
 	bitmap->mddev->curr_resync_completed = sector;
 	set_bit(MD_CHANGE_CLEAN, &bitmap->mddev->flags);
-	sector &= ~((1ULL << bitmap->chunkshift) - 1);
+	sector &= ~((1ULL << bitmap->counts.chunkshift) - 1);
 	s = 0;
 	while (s < sector && s < bitmap->mddev->resync_max_sectors) {
 		bitmap_end_sync(bitmap, s, &blocks, 0);
@@ -1513,19 +1515,19 @@ static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int n
 
 	sector_t secs;
 	bitmap_counter_t *bmc;
-	spin_lock_irq(&bitmap->lock);
-	bmc = bitmap_get_counter(bitmap, offset, &secs, 1);
+	spin_lock_irq(&bitmap->counts.lock);
+	bmc = bitmap_get_counter(&bitmap->counts, offset, &secs, 1);
 	if (!bmc) {
-		spin_unlock_irq(&bitmap->lock);
+		spin_unlock_irq(&bitmap->counts.lock);
 		return;
 	}
 	if (!*bmc) {
 		*bmc = 2 | (needed ? NEEDED_MASK : 0);
-		bitmap_count_page(bitmap, offset, 1);
-		bitmap_set_pending(bitmap, offset);
+		bitmap_count_page(&bitmap->counts, offset, 1);
+		bitmap_set_pending(&bitmap->counts, offset);
 		bitmap->allclean = 0;
 	}
-	spin_unlock_irq(&bitmap->lock);
+	spin_unlock_irq(&bitmap->counts.lock);
 }
 
 /* dirty the memory and file bits for bitmap chunks "s" to "e" */
@@ -1534,7 +1536,7 @@ void bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e)
 	unsigned long chunk;
 
 	for (chunk = s; chunk <= e; chunk++) {
-		sector_t sec = (sector_t)chunk << bitmap->chunkshift;
+		sector_t sec = (sector_t)chunk << bitmap->counts.chunkshift;
 		bitmap_set_memory_bits(bitmap, sec, 1);
 		bitmap_file_set_bit(bitmap, sec);
 		if (sec < bitmap->mddev->recovery_cp)
@@ -1588,8 +1590,8 @@ static void bitmap_free(struct bitmap *bitmap)
 	/* release the bitmap file  */
 	bitmap_file_unmap(&bitmap->storage);
 
-	bp = bitmap->bp;
-	pages = bitmap->pages;
+	bp = bitmap->counts.bp;
+	pages = bitmap->counts.pages;
 
 	/* free all allocated memory */
 
@@ -1642,7 +1644,7 @@ int bitmap_create(struct mddev *mddev)
 	if (!bitmap)
 		return -ENOMEM;
 
-	spin_lock_init(&bitmap->lock);
+	spin_lock_init(&bitmap->counts.lock);
 	atomic_set(&bitmap->pending_writes, 0);
 	init_waitqueue_head(&bitmap->write_wait);
 	init_waitqueue_head(&bitmap->overflow_wait);
@@ -1689,28 +1691,29 @@ int bitmap_create(struct mddev *mddev)
 		goto error;
 
 	bitmap->daemon_lastrun = jiffies;
-	bitmap->chunkshift = (ffz(~mddev->bitmap_info.chunksize)
+	bitmap->counts.chunkshift = (ffz(~mddev->bitmap_info.chunksize)
 			      - BITMAP_BLOCK_SHIFT);
 
 	/* now that chunksize and chunkshift are set, we can use these macros */
-	chunks = (blocks + bitmap->chunkshift - 1) >>
-			bitmap->chunkshift;
+	chunks = (blocks + bitmap->counts.chunkshift - 1) >>
+			bitmap->counts.chunkshift;
 	pages = (chunks + PAGE_COUNTER_RATIO - 1) / PAGE_COUNTER_RATIO;
 
 	BUG_ON(!pages);
 
-	bitmap->chunks = chunks;
-	bitmap->pages = pages;
-	bitmap->missing_pages = pages;
+	bitmap->counts.chunks = chunks;
+	bitmap->counts.pages = pages;
+	bitmap->counts.missing_pages = pages;
 
-	bitmap->bp = kzalloc(pages * sizeof(*bitmap->bp), GFP_KERNEL);
+	bitmap->counts.bp = kzalloc(pages * sizeof(*bitmap->counts.bp),
+				    GFP_KERNEL);
 
 	err = -ENOMEM;
-	if (!bitmap->bp)
+	if (!bitmap->counts.bp)
 		goto error;
 
 	if (file || mddev->bitmap_info.offset) {
-		err = bitmap_storage_alloc(&bitmap->storage, bitmap->chunks,
+		err = bitmap_storage_alloc(&bitmap->storage, bitmap->counts.chunks,
 					   !mddev->bitmap_info.external);
 		if (err)
 			goto error;
@@ -1782,17 +1785,19 @@ EXPORT_SYMBOL_GPL(bitmap_load);
 void bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
 {
 	unsigned long chunk_kb;
+	struct bitmap_counts *counts;
 
 	if (!bitmap)
 		return;
 
-	spin_lock_irq(&bitmap->lock);
+	counts = &bitmap->counts;
+
 	chunk_kb = bitmap->mddev->bitmap_info.chunksize >> 10;
 	seq_printf(seq, "bitmap: %lu/%lu pages [%luKB], "
 		   "%lu%s chunk",
-		   bitmap->pages - bitmap->missing_pages,
-		   bitmap->pages,
-		   (bitmap->pages - bitmap->missing_pages)
+		   counts->pages - counts->missing_pages,
+		   counts->pages,
+		   (counts->pages - counts->missing_pages)
 		   << (PAGE_SHIFT - 10),
 		   chunk_kb ? chunk_kb : bitmap->mddev->bitmap_info.chunksize,
 		   chunk_kb ? "KB" : "B");
@@ -1802,7 +1807,6 @@ void bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
 	}
 
 	seq_printf(seq, "\n");
-	spin_unlock_irq(&bitmap->lock);
 }
 
 static ssize_t
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index ede1084..256a850 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -175,22 +175,25 @@ struct bitmap_page {
 
 /* the main bitmap structure - one per mddev */
 struct bitmap {
-	struct bitmap_page *bp;
-	unsigned long pages; /* total number of pages in the bitmap */
-	unsigned long missing_pages; /* number of pages not yet allocated */
 
-	struct mddev *mddev; /* the md device that the bitmap is for */
+	struct bitmap_counts {
+		spinlock_t lock;
+		struct bitmap_page *bp;
+		unsigned long pages;		/* total number of pages
+						 * in the bitmap */
+		unsigned long missing_pages;	/* number of pages
+						 * not yet allocated */
+		unsigned long chunkshift;	/* chunksize = 2^chunkshift
+						 * (for bitops) */
+		unsigned long chunks;		/* Total number of data
+						 * chunks for the array */
+	} counts;
 
-	/* bitmap chunksize -- how much data does each bit represent? */
-	unsigned long chunkshift; /* chunksize = 2^(chunkshift+9) (for bitops) */
-	unsigned long chunks; /* total number of data chunks for the array */
+	struct mddev *mddev; /* the md device that the bitmap is for */
 
 	__u64	events_cleared;
 	int need_sync;
 
-	/* bitmap spinlock */
-	spinlock_t lock;
-
 	struct bitmap_storage {
 		struct file *file;		/* backing disk file */
 		struct page *sb_page;		/* cached copy of the bitmap


