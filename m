From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 21/23] md/bitmap: discard CHUNK_BLOCK_SHIFT macro
Date: Wed, 14 Mar 2012 15:40:41 +1100
Message-ID: <20120314044041.7978.72928.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Be redefining ->chunkshift as the shift from sectors to chunks rather
than bytes to chunks, we can just use "bitmap->chunkshift" which is
shorter than the macro call, and less indirect.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   35 ++++++++++++++++++-----------------
 drivers/md/bitmap.h |    3 +--
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 534e007..cf5863c 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -838,7 +838,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	unsigned long bit;
 	struct page *page;
 	void *kaddr;
-	unsigned long chunk = block >> CHUNK_BLOCK_SHIFT(bitmap);
+	unsigned long chunk = block >> bitmap->chunkshift;
 
 	if (!bitmap->filemap)
 		return;
@@ -1037,10 +1037,10 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		kunmap_atomic(paddr, KM_USER0);
 		if (b) {
 			/* if the disk bit is set, set the memory bit */
-			int needed = ((sector_t)(i+1) << (CHUNK_BLOCK_SHIFT(bitmap))
+			int needed = ((sector_t)(i+1) << bitmap->chunkshift
 				      >= start);
 			bitmap_set_memory_bits(bitmap,
-					       (sector_t)i << CHUNK_BLOCK_SHIFT(bitmap),
+					       (sector_t)i << bitmap->chunkshift,
 					       needed);
 			bit_cnt++;
 		}
@@ -1084,7 +1084,7 @@ void bitmap_write_all(struct bitmap *bitmap)
 
 static void bitmap_count_page(struct bitmap *bitmap, sector_t offset, int inc)
 {
-	sector_t chunk = offset >> CHUNK_BLOCK_SHIFT(bitmap);
+	sector_t chunk = offset >> bitmap->chunkshift;
 	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
 	bitmap->bp[page].count += inc;
 	bitmap_checkfree(bitmap, page);
@@ -1190,7 +1190,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 				bitmap->allclean = 0;
 		}
 		bmc = bitmap_get_counter(bitmap,
-					 (sector_t)j << CHUNK_BLOCK_SHIFT(bitmap),
+					 (sector_t)j << bitmap->chunkshift,
 					 &blocks, 0);
 		if (!bmc)
 			j |= PAGE_COUNTER_MASK;
@@ -1199,7 +1199,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 				/* we can clear the bit */
 				*bmc = 0;
 				bitmap_count_page(bitmap,
-						  (sector_t)j << CHUNK_BLOCK_SHIFT(bitmap),
+						  (sector_t)j << bitmap->chunkshift,
 						  -1);
 
 				/* clear the bit */
@@ -1253,7 +1253,7 @@ __acquires(bitmap->lock)
 	 * The lock must have been taken with interrupts enabled.
 	 * If !create, we don't release the lock.
 	 */
-	sector_t chunk = offset >> CHUNK_BLOCK_SHIFT(bitmap);
+	sector_t chunk = offset >> bitmap->chunkshift;
 	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
 	unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) << COUNTER_BYTE_SHIFT;
 	sector_t csize;
@@ -1263,10 +1263,10 @@ __acquires(bitmap->lock)
 
 	if (bitmap->bp[page].hijacked ||
 	    bitmap->bp[page].map == NULL)
-		csize = ((sector_t)1) << (CHUNK_BLOCK_SHIFT(bitmap) +
+		csize = ((sector_t)1) << (bitmap->chunkshift +
 					  PAGE_COUNTER_SHIFT - 1);
 	else
-		csize = ((sector_t)1) << (CHUNK_BLOCK_SHIFT(bitmap));
+		csize = ((sector_t)1) << bitmap->chunkshift;
 	*blocks = csize - (offset & (csize - 1));
 
 	if (err < 0)
@@ -1392,7 +1392,7 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 			set_page_attr(bitmap,
 				      filemap_get_page(
 					      bitmap,
-					      offset >> CHUNK_BLOCK_SHIFT(bitmap)),
+					      offset >> bitmap->chunkshift),
 				      BITMAP_PAGE_PENDING);
 			bitmap->allclean = 0;
 		}
@@ -1480,7 +1480,7 @@ void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, i
 		else {
 			if (*bmc <= 2) {
 				set_page_attr(bitmap,
-					      filemap_get_page(bitmap, offset >> CHUNK_BLOCK_SHIFT(bitmap)),
+					      filemap_get_page(bitmap, offset >> bitmap->chunkshift),
 					      BITMAP_PAGE_PENDING);
 				bitmap->allclean = 0;
 			}
@@ -1527,7 +1527,7 @@ void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
 
 	bitmap->mddev->curr_resync_completed = sector;
 	set_bit(MD_CHANGE_CLEAN, &bitmap->mddev->flags);
-	sector &= ~((1ULL << CHUNK_BLOCK_SHIFT(bitmap)) - 1);
+	sector &= ~((1ULL << bitmap->chunkshift) - 1);
 	s = 0;
 	while (s < sector && s < bitmap->mddev->resync_max_sectors) {
 		bitmap_end_sync(bitmap, s, &blocks, 0);
@@ -1557,7 +1557,7 @@ static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int n
 		struct page *page;
 		*bmc = 2 | (needed ? NEEDED_MASK : 0);
 		bitmap_count_page(bitmap, offset, 1);
-		page = filemap_get_page(bitmap, offset >> CHUNK_BLOCK_SHIFT(bitmap));
+		page = filemap_get_page(bitmap, offset >> bitmap->chunkshift);
 		set_page_attr(bitmap, page, BITMAP_PAGE_PENDING);
 		bitmap->allclean = 0;
 	}
@@ -1570,7 +1570,7 @@ void bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e)
 	unsigned long chunk;
 
 	for (chunk = s; chunk <= e; chunk++) {
-		sector_t sec = (sector_t)chunk << CHUNK_BLOCK_SHIFT(bitmap);
+		sector_t sec = (sector_t)chunk << bitmap->chunkshift;
 		bitmap_set_memory_bits(bitmap, sec, 1);
 		spin_lock_irq(&bitmap->lock);
 		bitmap_file_set_bit(bitmap, sec);
@@ -1727,11 +1727,12 @@ int bitmap_create(struct mddev *mddev)
 		goto error;
 
 	bitmap->daemon_lastrun = jiffies;
-	bitmap->chunkshift = ffz(~mddev->bitmap_info.chunksize);
+	bitmap->chunkshift = (ffz(~mddev->bitmap_info.chunksize)
+			      - BITMAP_BLOCK_SHIFT);
 
 	/* now that chunksize and chunkshift are set, we can use these macros */
-	chunks = (blocks + CHUNK_BLOCK_RATIO(bitmap) - 1) >>
-			CHUNK_BLOCK_SHIFT(bitmap);
+	chunks = (blocks + bitmap->chunkshift - 1) >>
+			bitmap->chunkshift;
 	pages = (chunks + PAGE_COUNTER_RATIO - 1) / PAGE_COUNTER_RATIO;
 
 	BUG_ON(!pages);
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index e196e6a5..55ca5ae 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -103,7 +103,6 @@ typedef __u16 bitmap_counter_t;
 
 /* how many blocks per chunk? (this is variable) */
 #define CHUNK_BLOCK_RATIO(bitmap) ((bitmap)->mddev->bitmap_info.chunksize >> BITMAP_BLOCK_SHIFT)
-#define CHUNK_BLOCK_SHIFT(bitmap) ((bitmap)->chunkshift - BITMAP_BLOCK_SHIFT)
 
 #endif
 
@@ -178,7 +177,7 @@ struct bitmap {
 	struct mddev *mddev; /* the md device that the bitmap is for */
 
 	/* bitmap chunksize -- how much data does each bit represent? */
-	unsigned long chunkshift; /* chunksize = 2^chunkshift (for bitops) */
+	unsigned long chunkshift; /* chunksize = 2^(chunkshift+9) (for bitops) */
 	unsigned long chunks; /* total number of data chunks for the array */
 
 	__u64	events_cleared;


