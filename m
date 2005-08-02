From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 005 of 7] Always honour md bitmap being read from disk
Date: Tue, 02 Aug 2005 19:53:41 +1000
Message-ID: <E1DztSv-0004Va-Q4@notabene.cse.unsw.edu.au>
References: <20050802193525.12307.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The code currently will ignore the bitmap if the array seem to be
in-sync.  This is wrong if the array is degraded, and probably wrong anyway.
If the bitmap says some chunks are not in in-sync, and the superblock says
everything IS in sync, then something is clearly wrong, and it is safer
to trust the bitmap.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |   52 ++++++++++++++++++++++----------------------------
 1 files changed, 23 insertions(+), 29 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-08-02 15:23:11.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-08-02 15:23:11.000000000 +1000
@@ -817,8 +817,7 @@ int bitmap_unplug(struct bitmap *bitmap)
 	return 0;
 }
 
-static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset,
-	unsigned long sectors, int in_sync);
+static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset);
 /* * bitmap_init_from_disk -- called at bitmap_create time to initialize
  * the in-memory bitmap from the on-disk bitmap -- also, sets up the
  * memory mapping of the bitmap file
@@ -827,7 +826,7 @@ static void bitmap_set_memory_bits(struc
  *   previously kicked from the array, we mark all the bits as
  *   1's in order to cause a full resync.
  */
-static int bitmap_init_from_disk(struct bitmap *bitmap, int in_sync)
+static int bitmap_init_from_disk(struct bitmap *bitmap)
 {
 	unsigned long i, chunks, index, oldindex, bit;
 	struct page *page = NULL, *oldpage = NULL;
@@ -928,8 +927,7 @@ static int bitmap_init_from_disk(struct 
 		}
 		if (test_bit(bit, page_address(page))) {
 			/* if the disk bit is set, set the memory bit */
-			bitmap_set_memory_bits(bitmap,
-					i << CHUNK_BLOCK_SHIFT(bitmap), 1, in_sync);
+			bitmap_set_memory_bits(bitmap, i << CHUNK_BLOCK_SHIFT(bitmap));
 			bit_cnt++;
 		}
 	}
@@ -1425,35 +1423,30 @@ void bitmap_close_sync(struct bitmap *bi
 	}
 }
 
-static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset,
-				   unsigned long sectors, int in_sync)
+static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset)
 {
 	/* For each chunk covered by any of these sectors, set the
-	 * counter to 1 and set resync_needed unless in_sync.  They should all
+	 * counter to 1 and set resync_needed.  They should all
 	 * be 0 at this point
 	 */
-	while (sectors) {
-		int secs;
-		bitmap_counter_t *bmc;
-		spin_lock_irq(&bitmap->lock);
-		bmc = bitmap_get_counter(bitmap, offset, &secs, 1);
-		if (!bmc) {
-			spin_unlock_irq(&bitmap->lock);
-			return;
-		}
-		if (! *bmc) {
-			struct page *page;
-			*bmc = 1 | (in_sync? 0 : NEEDED_MASK);
-			bitmap_count_page(bitmap, offset, 1);
-			page = filemap_get_page(bitmap, offset >> CHUNK_BLOCK_SHIFT(bitmap));
-			set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
-		}
+
+	int secs;
+	bitmap_counter_t *bmc;
+	spin_lock_irq(&bitmap->lock);
+	bmc = bitmap_get_counter(bitmap, offset, &secs, 1);
+	if (!bmc) {
 		spin_unlock_irq(&bitmap->lock);
-		if (sectors > secs)
-			sectors -= secs;
-		else
-			sectors = 0;
+		return;
 	}
+	if (! *bmc) {
+		struct page *page;
+		*bmc = 1 | NEEDED_MASK;
+		bitmap_count_page(bitmap, offset, 1);
+		page = filemap_get_page(bitmap, offset >> CHUNK_BLOCK_SHIFT(bitmap));
+		set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
+	}
+	spin_unlock_irq(&bitmap->lock);
+
 }
 
 /*
@@ -1564,7 +1557,8 @@ int bitmap_create(mddev_t *mddev)
 
 	/* now that we have some pages available, initialize the in-memory
 	 * bitmap from the on-disk bitmap */
-	err = bitmap_init_from_disk(bitmap, mddev->recovery_cp == MaxSector);
+	err = bitmap_init_from_disk(bitmap);
+
 	if (err)
 		return err;
 
