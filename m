From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 16/24] md/bitmap: make _page_attr bitops atomic.
Date: Tue, 17 Apr 2012 18:43:41 +1000
Message-ID: <20120417084341.6433.54919.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Using e.g. set_bit instead of __set_bit and using test_and_clear_bit
allow us to remove some locking and contract other locked ranges.

It is rare that we set or clear a lot of these bits, so gain should
outweigh any cost.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   55 +++++++++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 32 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index d8e2591..c26100b 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -797,21 +797,27 @@ enum bitmap_page_attr {
 static inline void set_page_attr(struct bitmap *bitmap, int pnum,
 				 enum bitmap_page_attr attr)
 {
-	__set_bit((pnum<<2) + attr, bitmap->storage.filemap_attr);
+	set_bit((pnum<<2) + attr, bitmap->storage.filemap_attr);
 }
 
 static inline void clear_page_attr(struct bitmap *bitmap, int pnum,
 				   enum bitmap_page_attr attr)
 {
-	__clear_bit((pnum<<2) + attr, bitmap->storage.filemap_attr);
+	clear_bit((pnum<<2) + attr, bitmap->storage.filemap_attr);
 }
 
-static inline unsigned long test_page_attr(struct bitmap *bitmap, int pnum,
-					   enum bitmap_page_attr attr)
+static inline int test_page_attr(struct bitmap *bitmap, int pnum,
+				 enum bitmap_page_attr attr)
 {
 	return test_bit((pnum<<2) + attr, bitmap->storage.filemap_attr);
 }
 
+static inline int test_and_clear_page_attr(struct bitmap *bitmap, int pnum,
+					   enum bitmap_page_attr attr)
+{
+	return test_and_clear_bit((pnum<<2) + attr,
+				  bitmap->storage.filemap_attr);
+}
 /*
  * bitmap_file_set_bit -- called before performing a write to the md device
  * to set (and eventually sync) a particular bit in the bitmap file
@@ -882,23 +888,17 @@ void bitmap_unplug(struct bitmap *bitmap)
 	/* look at each page to see if there are any set bits that need to be
 	 * flushed out to disk */
 	for (i = 0; i < bitmap->storage.file_pages; i++) {
-		spin_lock_irq(&bitmap->lock);
-		if (!bitmap->storage.filemap) {
-			spin_unlock_irq(&bitmap->lock);
+		if (!bitmap->storage.filemap)
 			return;
-		}
-		dirty = test_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
-		need_write = test_page_attr(bitmap, i, BITMAP_PAGE_NEEDWRITE);
-		clear_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
-		clear_page_attr(bitmap, i, BITMAP_PAGE_NEEDWRITE);
-		if (dirty || need_write)
+		dirty = test_and_clear_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
+		need_write = test_and_clear_page_attr(bitmap, i,
+						      BITMAP_PAGE_NEEDWRITE);
+		if (dirty || need_write) {
 			clear_page_attr(bitmap, i, BITMAP_PAGE_PENDING);
+			write_page(bitmap, bitmap->storage.filemap[i], 0);
+		}
 		if (dirty)
 			wait = 1;
-		spin_unlock_irq(&bitmap->lock);
-
-		if (dirty || need_write)
-			write_page(bitmap, bitmap->storage.filemap[i], 0);
 	}
 	if (wait) { /* if any writes were performed, we need to wait on them */
 		if (bitmap->storage.file)
@@ -1060,12 +1060,10 @@ void bitmap_write_all(struct bitmap *bitmap)
 		/* Only one copy, so nothing needed */
 		return;
 
-	spin_lock_irq(&bitmap->lock);
 	for (i = 0; i < bitmap->storage.file_pages; i++)
 		set_page_attr(bitmap, i,
 			      BITMAP_PAGE_NEEDWRITE);
 	bitmap->allclean = 0;
-	spin_unlock_irq(&bitmap->lock);
 }
 
 static void bitmap_count_page(struct bitmap *bitmap, sector_t offset, int inc)
@@ -1126,15 +1124,11 @@ void bitmap_daemon_work(struct mddev *mddev)
 	 * So set NEEDWRITE now, then after we make any last-minute changes
 	 * we will write it.
 	 */
-	spin_lock_irq(&bitmap->lock);
 	for (j = 0; j < bitmap->storage.file_pages; j++)
-		if (test_page_attr(bitmap, j,
-				   BITMAP_PAGE_PENDING)) {
+		if (test_and_clear_page_attr(bitmap, j,
+					     BITMAP_PAGE_PENDING))
 			set_page_attr(bitmap, j,
 				      BITMAP_PAGE_NEEDWRITE);
-			clear_page_attr(bitmap, j,
-					BITMAP_PAGE_PENDING);
-		}
 
 	if (bitmap->need_sync &&
 	    mddev->bitmap_info.external == 0) {
@@ -1154,6 +1148,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 	/* Now look at the bitmap counters and if any are '2' or '1',
 	 * decrement and handle accordingly.
 	 */
+	spin_lock_irq(&bitmap->lock);
 	nextpage = 0;
 	for (j = 0; j < bitmap->chunks; j++) {
 		bitmap_counter_t *bmc;
@@ -1186,6 +1181,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 			bitmap->allclean = 0;
 		}
 	}
+	spin_unlock_irq(&bitmap->lock);
 
 	/* Now start writeout on any page in NEEDWRITE that isn't DIRTY.
 	 * DIRTY pages need to be written by bitmap_unplug so it can wait
@@ -1204,18 +1200,13 @@ void bitmap_daemon_work(struct mddev *mddev)
 				    BITMAP_PAGE_DIRTY))
 			/* bitmap_unplug will handle the rest */
 			break;
-		if (test_page_attr(bitmap, j,
-				   BITMAP_PAGE_NEEDWRITE)) {
-			clear_page_attr(bitmap, j,
-					BITMAP_PAGE_NEEDWRITE);
-			spin_unlock_irq(&bitmap->lock);
+		if (test_and_clear_page_attr(bitmap, j,
+					     BITMAP_PAGE_NEEDWRITE)) {
 			write_page(bitmap, bitmap->storage.filemap[j], 0);
-			spin_lock_irq(&bitmap->lock);
 			if (!bitmap->storage.filemap)
 				break;
 		}
 	}
-	spin_unlock_irq(&bitmap->lock);
 
  done:
 	if (bitmap->allclean == 0)


