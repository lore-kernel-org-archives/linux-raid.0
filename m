From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 13/24] md/bitmap: convert some spin_lock_irqsave to
 spin_lock_irq
Date: Tue, 17 Apr 2012 18:43:41 +1000
Message-ID: <20120417084341.6433.64895.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All of these sites can only be called from process context with
irqs enabled, so using irqsave/irqrestore just adds noise.
Remove it.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9200ed4..4322f5b 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -735,10 +735,9 @@ static void bitmap_file_unmap(struct bitmap *bitmap)
 	struct page **map, *sb_page;
 	unsigned long *attr;
 	int pages;
-	unsigned long flags;
 	struct bitmap_storage *store = &bitmap->storage;
 
-	spin_lock_irqsave(&bitmap->lock, flags);
+	spin_lock_irq(&bitmap->lock);
 	map = store->filemap;
 	store->filemap = NULL;
 	attr = store->filemap_attr;
@@ -747,7 +746,7 @@ static void bitmap_file_unmap(struct bitmap *bitmap)
 	store->file_pages = 0;
 	sb_page = store->sb_page;
 	store->sb_page = NULL;
-	spin_unlock_irqrestore(&bitmap->lock, flags);
+	spin_unlock_irq(&bitmap->lock);
 
 	while (pages--)
 		if (map[pages] != sb_page) /* 0 is sb_page, release it below */
@@ -762,12 +761,11 @@ static void bitmap_file_unmap(struct bitmap *bitmap)
 static void bitmap_file_put(struct bitmap *bitmap)
 {
 	struct file *file;
-	unsigned long flags;
 
-	spin_lock_irqsave(&bitmap->lock, flags);
+	spin_lock_irq(&bitmap->lock);
 	file = bitmap->storage.file;
 	bitmap->storage.file = NULL;
-	spin_unlock_irqrestore(&bitmap->lock, flags);
+	spin_unlock_irq(&bitmap->lock);
 
 	if (file)
 		wait_event(bitmap->write_wait,
@@ -899,7 +897,7 @@ static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
  * sync the dirty pages of the bitmap file to disk */
 void bitmap_unplug(struct bitmap *bitmap)
 {
-	unsigned long i, flags;
+	unsigned long i;
 	int dirty, need_write;
 	int wait = 0;
 
@@ -909,9 +907,9 @@ void bitmap_unplug(struct bitmap *bitmap)
 	/* look at each page to see if there are any set bits that need to be
 	 * flushed out to disk */
 	for (i = 0; i < bitmap->storage.file_pages; i++) {
-		spin_lock_irqsave(&bitmap->lock, flags);
+		spin_lock_irq(&bitmap->lock);
 		if (!bitmap->storage.filemap) {
-			spin_unlock_irqrestore(&bitmap->lock, flags);
+			spin_unlock_irq(&bitmap->lock);
 			return;
 		}
 		dirty = test_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
@@ -922,7 +920,7 @@ void bitmap_unplug(struct bitmap *bitmap)
 			clear_page_attr(bitmap, i, BITMAP_PAGE_PENDING);
 		if (dirty)
 			wait = 1;
-		spin_unlock_irqrestore(&bitmap->lock, flags);
+		spin_unlock_irq(&bitmap->lock);
 
 		if (dirty || need_write)
 			write_page(bitmap, bitmap->storage.filemap[i], 0);
@@ -1127,7 +1125,6 @@ void bitmap_daemon_work(struct mddev *mddev)
 	struct bitmap *bitmap;
 	unsigned long j;
 	unsigned long nextpage;
-	unsigned long flags;
 	sector_t blocks;
 
 	/* Use a mutex to guard daemon_work against
@@ -1154,7 +1151,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 	 * So set NEEDWRITE now, then after we make any last-minute changes
 	 * we will write it.
 	 */
-	spin_lock_irqsave(&bitmap->lock, flags);
+	spin_lock_irq(&bitmap->lock);
 	for (j = 0; j < bitmap->storage.file_pages; j++)
 		if (test_page_attr(bitmap, j,
 				   BITMAP_PAGE_PENDING)) {
@@ -1233,14 +1230,14 @@ void bitmap_daemon_work(struct mddev *mddev)
 				   BITMAP_PAGE_NEEDWRITE)) {
 			clear_page_attr(bitmap, j,
 					BITMAP_PAGE_NEEDWRITE);
-			spin_unlock_irqrestore(&bitmap->lock, flags);
+			spin_unlock_irq(&bitmap->lock);
 			write_page(bitmap, bitmap->storage.filemap[j], 0);
-			spin_lock_irqsave(&bitmap->lock, flags);
+			spin_lock_irq(&bitmap->lock);
 			if (!bitmap->storage.filemap)
 				break;
 		}
 	}
-	spin_unlock_irqrestore(&bitmap->lock, flags);
+	spin_unlock_irq(&bitmap->lock);
 
  done:
 	if (bitmap->allclean == 0)
@@ -1814,12 +1811,11 @@ EXPORT_SYMBOL_GPL(bitmap_load);
 void bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
 {
 	unsigned long chunk_kb;
-	unsigned long flags;
 
 	if (!bitmap)
 		return;
 
-	spin_lock_irqsave(&bitmap->lock, flags);
+	spin_lock_irq(&bitmap->lock);
 	chunk_kb = bitmap->mddev->bitmap_info.chunksize >> 10;
 	seq_printf(seq, "bitmap: %lu/%lu pages [%luKB], "
 		   "%lu%s chunk",
@@ -1835,7 +1831,7 @@ void bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
 	}
 
 	seq_printf(seq, "\n");
-	spin_unlock_irqrestore(&bitmap->lock, flags);
+	spin_unlock_irq(&bitmap->lock);
 }
 
 static ssize_t


