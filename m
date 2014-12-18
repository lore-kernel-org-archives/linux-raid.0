From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 13/24] Copy set bits from another slot
Date: Thu, 18 Dec 2014 10:17:34 -0600
Message-ID: <20141218161734.GA29627@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

bitmap_copy_from_slot reads the bitmap from the slot mentioned.
It then copies the set bits to the node local bitmap.

This is helper function for the resync operation on node failure.

bitmap_set_memory_bits() currently assumes it is only run at startup and that
they bitmap is currently empty.  So if it finds that a region is already
marked as dirty, it won't mark it dirty again. Change bitmap_set_memory_bits()
to always set the NEEDED_MASK bit if 'needed' is set.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/bitmap.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/bitmap.h |  2 ++
 2 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 49b7e33..6f7e178 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -919,6 +919,28 @@ static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	}
 }
 
+static int bitmap_file_test_bit(struct bitmap *bitmap, sector_t block)
+{
+	unsigned long bit;
+	struct page *page;
+	void *paddr;
+	unsigned long chunk = block >> bitmap->counts.chunkshift;
+	int set = 0;
+
+	page = filemap_get_page(&bitmap->storage, chunk);
+	if (!page)
+		return -EINVAL;
+	bit = file_page_offset(&bitmap->storage, chunk);
+	paddr = kmap_atomic(page);
+	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
+		set = test_bit(bit, paddr);
+	else
+		set = test_bit_le(bit, paddr);
+	kunmap_atomic(paddr);
+	return set;
+}
+
+
 /* this gets called when the md device is ready to unplug its underlying
  * (slave) device queues -- before we let any writes go down, we need to
  * sync the dirty pages of the bitmap file to disk */
@@ -1570,11 +1592,13 @@ static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int n
 		return;
 	}
 	if (!*bmc) {
-		*bmc = 2 | (needed ? NEEDED_MASK : 0);
+		*bmc = 2;
 		bitmap_count_page(&bitmap->counts, offset, 1);
 		bitmap_set_pending(&bitmap->counts, offset);
 		bitmap->allclean = 0;
 	}
+	if (needed)
+		*bmc |= NEEDED_MASK;
 	spin_unlock_irq(&bitmap->counts.lock);
 }
 
@@ -1810,6 +1834,57 @@ out:
 }
 EXPORT_SYMBOL_GPL(bitmap_load);
 
+/* Loads the bitmap associated with slot and copies the resync information
+ * to our bitmap
+ */
+int bitmap_copy_from_slot(struct mddev *mddev, int slot,
+		sector_t *low, sector_t *high)
+{
+	int rv = 0, i, j;
+	sector_t block, lo = 0, hi = 0;
+	struct bitmap_counts *counts;
+	struct bitmap *bitmap = bitmap_create(mddev, slot);
+	if (IS_ERR(bitmap))
+		return PTR_ERR(bitmap);
+	else
+		rv = bitmap_read_sb(bitmap);
+	if (rv)
+		goto err;
+
+	rv = bitmap_init_from_disk(bitmap, 0);
+	if (rv)
+		goto err;
+
+	counts = &bitmap->counts;
+	for (j = 0; j < counts->chunks; j++) {
+		block = (sector_t)j << counts->chunkshift;
+		if (bitmap_file_test_bit(bitmap, block)) {
+			if (!lo)
+				lo = block;
+			hi = block;
+			bitmap_file_clear_bit(bitmap, block);
+			bitmap_set_memory_bits(mddev->bitmap, block, 1);
+			bitmap_file_set_bit(mddev->bitmap, block);
+		}
+	}
+
+	bitmap_update_sb(bitmap);
+	/* Setting this for the ev_page should be enough.
+	 * And we do not require both write_all and PAGE_DIRT either
+	 */
+	for (i = 0; i < bitmap->storage.file_pages; i++)
+		set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
+	bitmap_write_all(bitmap);
+	bitmap_unplug(bitmap);
+	*low = lo;
+	*high = hi;
+err:
+	bitmap_free(bitmap);
+	return rv;
+}
+EXPORT_SYMBOL_GPL(bitmap_copy_from_slot);
+
+
 void bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
 {
 	unsigned long chunk_kb;
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index ac3fc40..123ef8c 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -262,6 +262,8 @@ void bitmap_daemon_work(struct mddev *mddev);
 
 int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		  int chunksize, int init);
+int bitmap_copy_from_slot(struct mddev *mddev, int slot,
+				sector_t *lo, sector_t *hi);
 #endif
 
 #endif
-- 
2.1.2

