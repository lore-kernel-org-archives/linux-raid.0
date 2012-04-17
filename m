From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/24] md/bitmap: change *_page_attr() to take a page
 number, not a page.
Date: Tue, 17 Apr 2012 18:43:40 +1000
Message-ID: <20120417084340.6433.16039.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Most often we have the page number, not the page.  And that is what
the  *_page_attr() functions really want.  So change the arguments to
take that number.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   55 ++++++++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5629d4a..d655399 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -800,22 +800,22 @@ enum bitmap_page_attr {
 	BITMAP_PAGE_NEEDWRITE = 2, /* there are cleared bits that need to be synced */
 };
 
-static inline void set_page_attr(struct bitmap *bitmap, struct page *page,
-				enum bitmap_page_attr attr)
+static inline void set_page_attr(struct bitmap *bitmap, int pnum,
+				 enum bitmap_page_attr attr)
 {
-	__set_bit((page->index<<2) + attr, bitmap->filemap_attr);
+	__set_bit((pnum<<2) + attr, bitmap->filemap_attr);
 }
 
-static inline void clear_page_attr(struct bitmap *bitmap, struct page *page,
-				enum bitmap_page_attr attr)
+static inline void clear_page_attr(struct bitmap *bitmap, int pnum,
+				   enum bitmap_page_attr attr)
 {
-	__clear_bit((page->index<<2) + attr, bitmap->filemap_attr);
+	__clear_bit((pnum<<2) + attr, bitmap->filemap_attr);
 }
 
-static inline unsigned long test_page_attr(struct bitmap *bitmap, struct page *page,
+static inline unsigned long test_page_attr(struct bitmap *bitmap, int pnum,
 					   enum bitmap_page_attr attr)
 {
-	return test_bit((page->index<<2) + attr, bitmap->filemap_attr);
+	return test_bit((pnum<<2) + attr, bitmap->filemap_attr);
 }
 
 /*
@@ -846,7 +846,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	kunmap_atomic(kaddr);
 	pr_debug("set file bit %lu page %lu\n", bit, page->index);
 	/* record page number so it gets flushed to disk when unplug occurs */
-	set_page_attr(bitmap, page, BITMAP_PAGE_DIRTY);
+	set_page_attr(bitmap, page->index, BITMAP_PAGE_DIRTY);
 }
 
 static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
@@ -866,8 +866,8 @@ static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	else
 		__clear_bit_le(bit, paddr);
 	kunmap_atomic(paddr);
-	if (!test_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE)) {
-		set_page_attr(bitmap, page, BITMAP_PAGE_PENDING);
+	if (!test_page_attr(bitmap, page->index, BITMAP_PAGE_NEEDWRITE)) {
+		set_page_attr(bitmap, page->index, BITMAP_PAGE_PENDING);
 		bitmap->allclean = 0;
 	}
 }
@@ -879,7 +879,6 @@ void bitmap_unplug(struct bitmap *bitmap)
 {
 	unsigned long i, flags;
 	int dirty, need_write;
-	struct page *page;
 	int wait = 0;
 
 	if (!bitmap || !bitmap->filemap)
@@ -893,19 +892,18 @@ void bitmap_unplug(struct bitmap *bitmap)
 			spin_unlock_irqrestore(&bitmap->lock, flags);
 			return;
 		}
-		page = bitmap->filemap[i];
-		dirty = test_page_attr(bitmap, page, BITMAP_PAGE_DIRTY);
-		need_write = test_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
-		clear_page_attr(bitmap, page, BITMAP_PAGE_DIRTY);
-		clear_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
+		dirty = test_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
+		need_write = test_page_attr(bitmap, i, BITMAP_PAGE_NEEDWRITE);
+		clear_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
+		clear_page_attr(bitmap, i, BITMAP_PAGE_NEEDWRITE);
 		if (dirty || need_write)
-			clear_page_attr(bitmap, page, BITMAP_PAGE_PENDING);
+			clear_page_attr(bitmap, i, BITMAP_PAGE_PENDING);
 		if (dirty)
 			wait = 1;
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 
 		if (dirty || need_write)
-			write_page(bitmap, page, 0);
+			write_page(bitmap, bitmap->filemap[i], 0);
 	}
 	if (wait) { /* if any writes were performed, we need to wait on them */
 		if (bitmap->file)
@@ -1101,7 +1099,7 @@ void bitmap_write_all(struct bitmap *bitmap)
 
 	spin_lock_irq(&bitmap->lock);
 	for (i = 0; i < bitmap->file_pages; i++)
-		set_page_attr(bitmap, bitmap->filemap[i],
+		set_page_attr(bitmap, i,
 			      BITMAP_PAGE_NEEDWRITE);
 	bitmap->allclean = 0;
 	spin_unlock_irq(&bitmap->lock);
@@ -1168,11 +1166,11 @@ void bitmap_daemon_work(struct mddev *mddev)
 	 */
 	spin_lock_irqsave(&bitmap->lock, flags);
 	for (j = 0; j < bitmap->file_pages; j++)
-		if (test_page_attr(bitmap, bitmap->filemap[j],
+		if (test_page_attr(bitmap, j,
 				   BITMAP_PAGE_PENDING)) {
-			set_page_attr(bitmap, bitmap->filemap[j],
+			set_page_attr(bitmap, j,
 				      BITMAP_PAGE_NEEDWRITE);
-			clear_page_attr(bitmap, bitmap->filemap[j],
+			clear_page_attr(bitmap, j,
 					BITMAP_PAGE_PENDING);
 		}
 
@@ -1187,7 +1185,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 			sb->events_cleared =
 				cpu_to_le64(bitmap->events_cleared);
 			kunmap_atomic(sb);
-			set_page_attr(bitmap, bitmap->sb_page,
+			set_page_attr(bitmap, 0,
 				      BITMAP_PAGE_NEEDWRITE);
 		}
 	}
@@ -1236,18 +1234,17 @@ void bitmap_daemon_work(struct mddev *mddev)
 	 * We mustn't write any other blocks before the superblock.
 	 */
 	for (j = 0; j < bitmap->file_pages; j++) {
-		struct page *page = bitmap->filemap[j];
 
-		if (test_page_attr(bitmap, page,
+		if (test_page_attr(bitmap, j,
 				    BITMAP_PAGE_DIRTY))
 			/* bitmap_unplug will handle the rest */
 			break;
-		if (test_page_attr(bitmap, page,
+		if (test_page_attr(bitmap, j,
 				   BITMAP_PAGE_NEEDWRITE)) {
-			clear_page_attr(bitmap, page,
+			clear_page_attr(bitmap, j,
 					BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
-			write_page(bitmap, page, 0);
+			write_page(bitmap, bitmap->filemap[j], 0);
 			spin_lock_irqsave(&bitmap->lock, flags);
 			if (!bitmap->filemap)
 				break;


