From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 9 of 12] Make sure md bitmap is cleared on a clean start.
Date: Wed, 23 Mar 2005 16:47:11 +1100
Message-ID: <E1DDyhz-0004Gu-Im@notabene.cse.unsw.edu.au>
References: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


As the array-wide clean bit (in the superblock) is set more
agressively than the bits in the bitmap are cleared, it is possible
to have an array which is clean despite there being bits set
in the bitmap.

These bits will currently never get cleared, as they can only be 
cleared by a resync pass, which never happens.

No, when reading bits from disk, be aware of whether the whole
array is known to be in sync, and act accordingly.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-03-22 17:21:47.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-03-22 17:22:52.000000000 +1100
@@ -742,7 +742,7 @@ int bitmap_unplug(struct bitmap *bitmap)
 }
 
 static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset,
-	unsigned long sectors, int set);
+	unsigned long sectors, int in_sync);
 /* * bitmap_init_from_disk -- called at bitmap_create time to initialize
  * the in-memory bitmap from the on-disk bitmap -- also, sets up the
  * memory mapping of the bitmap file
@@ -751,7 +751,7 @@ static void bitmap_set_memory_bits(struc
  *   previously kicked from the array, we mark all the bits as
  *   1's in order to cause a full resync.
  */
-static int bitmap_init_from_disk(struct bitmap *bitmap)
+static int bitmap_init_from_disk(struct bitmap *bitmap, int in_sync)
 {
 	unsigned long i, chunks, index, oldindex, bit;
 	struct page *page = NULL, *oldpage = NULL;
@@ -777,7 +777,7 @@ static int bitmap_init_from_disk(struct 
 
 	bytes = (chunks + 7) / 8;
 
-	num_pages = (bytes + sizeof(bitmap_super_t) + PAGE_SIZE - 1) / PAGE_SIZE + 1;
+	num_pages = (bytes + sizeof(bitmap_super_t) + PAGE_SIZE - 1) / PAGE_SIZE;
 
 	if (i_size_read(file->f_mapping->host) < bytes + sizeof(bitmap_super_t)) {
 		printk(KERN_INFO "%s: bitmap file too short %lu < %lu\n",
@@ -849,14 +849,9 @@ static int bitmap_init_from_disk(struct 
 		if (test_bit(bit, page_address(page))) {
 			/* if the disk bit is set, set the memory bit */
 			bitmap_set_memory_bits(bitmap,
-					i << CHUNK_BLOCK_SHIFT(bitmap), 1, 1);
+					i << CHUNK_BLOCK_SHIFT(bitmap), 1, in_sync);
 			bit_cnt++;
 		}
-#if 0
-		else
-			bitmap_set_memory_bits(bitmap,
-				       i << CHUNK_BLOCK_SHIFT(bitmap), 1, 0);
-#endif
 	}
 
  	/* everything went OK */
@@ -1319,10 +1314,10 @@ void bitmap_close_sync(struct bitmap *bi
 }
 
 static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset,
-				   unsigned long sectors, int set)
+				   unsigned long sectors, int in_sync)
 {
 	/* For each chunk covered by any of these sectors, set the
-	 * resync needed bit, and the counter to 1.  They should all
+	 * counter to 1 and set resync_needed unless in_sync.  They should all
 	 * be 0 at this point
 	 */
 	while (sectors) {
@@ -1334,10 +1329,12 @@ static void bitmap_set_memory_bits(struc
 			spin_unlock_irq(&bitmap->lock);
 			return;
 		}
-		if (set && !NEEDED(*bmc)) {
-			BUG_ON(*bmc);
-			*bmc = NEEDED_MASK | 1;
+		if (! *bmc) {
+			struct page *page;
+			*bmc = 1 | (in_sync? 0 : NEEDED_MASK);
 			bitmap_count_page(bitmap, offset, 1);
+			page = filemap_get_page(bitmap, offset >> CHUNK_BLOCK_SHIFT(bitmap));
+			set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}
 		spin_unlock_irq(&bitmap->lock);
 		if (sectors > secs)
@@ -1477,7 +1474,7 @@ int bitmap_create(mddev_t *mddev)
 
 	/* now that we have some pages available, initialize the in-memory
 	 * bitmap from the on-disk bitmap */
-	err = bitmap_init_from_disk(bitmap);
+	err = bitmap_init_from_disk(bitmap, mddev->recovery_cp == MaxSector);
 	if (err)
 		return err;
 
