From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 003 of 6] Improve handling of bitmap initialisation.
Date: Thu, 11 Aug 2005 17:22:26 +1000
Message-ID: <E1E37OU-0002jH-Rs@notabene.cse.unsw.edu.au>
References: <20050811171720.10115.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When we find a 'stale' bitmap, possibly because it is new,
we should just assume every bit needs to be set, but rather
base the setting of bits on the current state of the array
(degraded and recovery_cp).

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-08-11 15:12:54.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-08-11 15:12:54.000000000 +1000
@@ -520,6 +520,8 @@ success:
 	bitmap->daemon_sleep = daemon_sleep;
 	bitmap->flags |= sb->state;
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
+	if (sb->state & BITMAP_STALE)
+		bitmap->events_cleared = bitmap->mddev->events;
 	err = 0;
 out:
 	kunmap(bitmap->sb_page);
@@ -818,7 +820,7 @@ int bitmap_unplug(struct bitmap *bitmap)
 	return 0;
 }
 
-static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset);
+static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed);
 /* * bitmap_init_from_disk -- called at bitmap_create time to initialize
  * the in-memory bitmap from the on-disk bitmap -- also, sets up the
  * memory mapping of the bitmap file
@@ -826,8 +828,11 @@ static void bitmap_set_memory_bits(struc
  *   if there's no bitmap file, or if the bitmap file had been
  *   previously kicked from the array, we mark all the bits as
  *   1's in order to cause a full resync.
+ *
+ * We ignore all bits for sectors that end earlier than 'start'.
+ * This is used when reading an out-of-date bitmap...
  */
-static int bitmap_init_from_disk(struct bitmap *bitmap)
+static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 {
 	unsigned long i, chunks, index, oldindex, bit;
 	struct page *page = NULL, *oldpage = NULL;
@@ -914,7 +919,7 @@ static int bitmap_init_from_disk(struct 
 			 	 * whole page and write it out
 				 */
 				memset(page_address(page) + offset, 0xff,
-					PAGE_SIZE - offset);
+				       PAGE_SIZE - offset);
 				ret = write_page(bitmap, page, 1);
 				if (ret) {
 					kunmap(page);
@@ -928,8 +933,11 @@ static int bitmap_init_from_disk(struct 
 		}
 		if (test_bit(bit, page_address(page))) {
 			/* if the disk bit is set, set the memory bit */
-			bitmap_set_memory_bits(bitmap, i << CHUNK_BLOCK_SHIFT(bitmap));
+			bitmap_set_memory_bits(bitmap, i << CHUNK_BLOCK_SHIFT(bitmap),
+					       ((i+1) << (CHUNK_BLOCK_SHIFT(bitmap)) >= start)
+				);
 			bit_cnt++;
+			set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}
 	}
 
@@ -1424,7 +1432,7 @@ void bitmap_close_sync(struct bitmap *bi
 	}
 }
 
-static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset)
+static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed)
 {
 	/* For each chunk covered by any of these sectors, set the
 	 * counter to 1 and set resync_needed.  They should all
@@ -1441,7 +1449,7 @@ static void bitmap_set_memory_bits(struc
 	}
 	if (! *bmc) {
 		struct page *page;
-		*bmc = 1 | NEEDED_MASK;
+		*bmc = 1 | (needed?NEEDED_MASK:0);
 		bitmap_count_page(bitmap, offset, 1);
 		page = filemap_get_page(bitmap, offset >> CHUNK_BLOCK_SHIFT(bitmap));
 		set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
@@ -1517,6 +1525,7 @@ int bitmap_create(mddev_t *mddev)
 	unsigned long pages;
 	struct file *file = mddev->bitmap_file;
 	int err;
+	sector_t start;
 
 	BUG_ON(sizeof(bitmap_super_t) != 256);
 
@@ -1581,7 +1590,12 @@ int bitmap_create(mddev_t *mddev)
 
 	/* now that we have some pages available, initialize the in-memory
 	 * bitmap from the on-disk bitmap */
-	err = bitmap_init_from_disk(bitmap);
+	start = 0;
+	if (mddev->degraded == 0
+	    || bitmap->events_cleared == mddev->events)
+		/* no need to keep dirty bits to optimise a re-add of a missing device */
+		start = mddev->recovery_cp;
+	err = bitmap_init_from_disk(bitmap, start);
 
 	if (err)
 		return err;
