From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 01/24] md/bitmap: disentangle two different 'pending' flags.
Date: Tue, 17 Apr 2012 18:43:39 +1000
Message-ID: <20120417084339.6433.2903.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There are two different 'pending' concepts in the handling of the
write intent bitmap.

Firstly, a 'page' from the bitmap (which container PAGE_SIZE*8 bits)
may have changes (bits cleared) that should be written in due course.
There is no hurry for these and the page will transition from
PENDING to NEEDWRITE and will then be written, though if it ever
becomes DIRTY it will be written much sooner and PENDING will be
cleared.

Secondly, a page of counters - which contains PAGE_SIZE/2 counters, one
for each bit, can usefully have a 'pending' flag which indicates if
any of the counters are low (2 or 1) and ready to be processed by
bitmap_daemon_work().  If this flag is clear we can skip the whole
page.

These two concepts are currently combined in the bitmap-file flag.
This causes a tighter connection between the counters and the bitmap
file than I would like - as I want to add some flexibility to the
bitmap file.

So introduce a new flag with the page-of-counters, and rewrite
bitmap_daemon_work() so that it handles the two different 'pending'
concepts separately.

This also allows us to clear BITMAP_PAGE_PENDING when we write out
a dirty page, which may occasionally reduce the number of times we
write a page.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |  213 +++++++++++++++++++++++++++------------------------
 drivers/md/bitmap.h |    7 +-
 2 files changed, 118 insertions(+), 102 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 97e73e5..a515e5b 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -883,6 +883,8 @@ void bitmap_unplug(struct bitmap *bitmap)
 		need_write = test_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
 		clear_page_attr(bitmap, page, BITMAP_PAGE_DIRTY);
 		clear_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
+		if (dirty || need_write)
+			clear_page_attr(bitmap, page, BITMAP_PAGE_PENDING);
 		if (dirty)
 			wait = 1;
 		spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1086,6 +1088,17 @@ static void bitmap_count_page(struct bitmap *bitmap, sector_t offset, int inc)
 	bitmap->bp[page].count += inc;
 	bitmap_checkfree(bitmap, page);
 }
+
+static void bitmap_set_pending(struct bitmap *bitmap, sector_t offset)
+{
+	sector_t chunk = offset >> bitmap->chunkshift;
+	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
+	struct bitmap_page *bp = &bitmap->bp[page];
+
+	if (!bp->pending)
+		bp->pending = 1;
+}
+
 static bitmap_counter_t *bitmap_get_counter(struct bitmap *bitmap,
 					    sector_t offset, sector_t *blocks,
 					    int create);
@@ -1099,8 +1112,8 @@ void bitmap_daemon_work(struct mddev *mddev)
 {
 	struct bitmap *bitmap;
 	unsigned long j;
+	unsigned long nextpage;
 	unsigned long flags;
-	struct page *page = NULL, *lastpage = NULL;
 	sector_t blocks;
 	void *paddr;
 
@@ -1124,114 +1137,120 @@ void bitmap_daemon_work(struct mddev *mddev)
 	}
 	bitmap->allclean = 1;
 
+	/* Any file-page which is PENDING now needs to be written.
+	 * So set NEEDWRITE now, then after we make any last-minute changes
+	 * we will write it.
+	 */
 	spin_lock_irqsave(&bitmap->lock, flags);
+	if (!bitmap->filemap)
+		/* error or shutdown */
+		goto out;
+
+	for (j = 0; j < bitmap->file_pages; j++)
+		if (test_page_attr(bitmap, bitmap->filemap[j],
+				   BITMAP_PAGE_PENDING)) {
+			set_page_attr(bitmap, bitmap->filemap[j],
+				      BITMAP_PAGE_NEEDWRITE);
+			clear_page_attr(bitmap, bitmap->filemap[j],
+					BITMAP_PAGE_PENDING);
+		}
+
+	if (bitmap->need_sync &&
+	    mddev->bitmap_info.external == 0) {
+		/* Arrange for superblock update as well as
+		 * other changes */
+		bitmap_super_t *sb;
+		bitmap->need_sync = 0;
+		sb = kmap_atomic(bitmap->sb_page);
+		sb->events_cleared =
+			cpu_to_le64(bitmap->events_cleared);
+		kunmap_atomic(sb);
+		set_page_attr(bitmap, bitmap->sb_page, BITMAP_PAGE_NEEDWRITE);
+	}
+	/* Now look at the bitmap counters and if any are '2' or '1',
+	 * decrement and handle accordingly.
+	 */
+	nextpage = 0;
 	for (j = 0; j < bitmap->chunks; j++) {
 		bitmap_counter_t *bmc;
-		if (!bitmap->filemap)
-			/* error or shutdown */
-			break;
 
-		page = filemap_get_page(bitmap, j);
-
-		if (page != lastpage) {
-			/* skip this page unless it's marked as needing cleaning */
-			if (!test_page_attr(bitmap, page, BITMAP_PAGE_PENDING)) {
-				int need_write = test_page_attr(bitmap, page,
-								BITMAP_PAGE_NEEDWRITE);
-				if (need_write)
-					clear_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
-
-				spin_unlock_irqrestore(&bitmap->lock, flags);
-				if (need_write)
-					write_page(bitmap, page, 0);
-				spin_lock_irqsave(&bitmap->lock, flags);
-				j |= (PAGE_BITS - 1);
+		if (j == nextpage) {
+			nextpage += PAGE_COUNTER_RATIO;
+			if (!bitmap->bp[j >> PAGE_COUNTER_SHIFT].pending) {
+				j |= PAGE_COUNTER_MASK;
 				continue;
 			}
-
-			/* grab the new page, sync and release the old */
-			if (lastpage != NULL) {
-				if (test_page_attr(bitmap, lastpage,
-						   BITMAP_PAGE_NEEDWRITE)) {
-					clear_page_attr(bitmap, lastpage,
-							BITMAP_PAGE_NEEDWRITE);
-					spin_unlock_irqrestore(&bitmap->lock, flags);
-					write_page(bitmap, lastpage, 0);
-				} else {
-					set_page_attr(bitmap, lastpage,
-						      BITMAP_PAGE_NEEDWRITE);
-					bitmap->allclean = 0;
-					spin_unlock_irqrestore(&bitmap->lock, flags);
-				}
-			} else
-				spin_unlock_irqrestore(&bitmap->lock, flags);
-			lastpage = page;
-
-			/* We are possibly going to clear some bits, so make
-			 * sure that events_cleared is up-to-date.
-			 */
-			if (bitmap->need_sync &&
-			    mddev->bitmap_info.external == 0) {
-				bitmap_super_t *sb;
-				bitmap->need_sync = 0;
-				sb = kmap_atomic(bitmap->sb_page);
-				sb->events_cleared =
-					cpu_to_le64(bitmap->events_cleared);
-				kunmap_atomic(sb);
-				write_page(bitmap, bitmap->sb_page, 1);
-			}
-			spin_lock_irqsave(&bitmap->lock, flags);
-			if (!bitmap->need_sync)
-				clear_page_attr(bitmap, page, BITMAP_PAGE_PENDING);
-			else
-				bitmap->allclean = 0;
+			bitmap->bp[j >> PAGE_COUNTER_SHIFT].pending = 0;
 		}
 		bmc = bitmap_get_counter(bitmap,
 					 (sector_t)j << bitmap->chunkshift,
 					 &blocks, 0);
-		if (!bmc)
+
+		if (!bmc) {
 			j |= PAGE_COUNTER_MASK;
-		else if (*bmc) {
-			if (*bmc == 1 && !bitmap->need_sync) {
-				/* we can clear the bit */
-				*bmc = 0;
-				bitmap_count_page(bitmap,
-						  (sector_t)j << bitmap->chunkshift,
-						  -1);
-
-				/* clear the bit */
-				paddr = kmap_atomic(page);
-				if (bitmap->flags & BITMAP_HOSTENDIAN)
-					clear_bit(file_page_offset(bitmap, j),
-						  paddr);
-				else
-					__clear_bit_le(
-						file_page_offset(bitmap,
-								 j),
-						paddr);
-				kunmap_atomic(paddr);
-			} else if (*bmc <= 2) {
-				*bmc = 1; /* maybe clear the bit next time */
-				set_page_attr(bitmap, page, BITMAP_PAGE_PENDING);
+			continue;
+		}
+		if (*bmc == 1 && !bitmap->need_sync) {
+			/* We can clear the bit */
+			struct page *page;
+			*bmc = 0;
+			bitmap_count_page(
+				bitmap,
+				(sector_t)j << bitmap->chunkshift,
+				-1);
+
+			page = filemap_get_page(bitmap, j);
+			paddr = kmap_atomic(page);
+			if (bitmap->flags & BITMAP_HOSTENDIAN)
+				clear_bit(file_page_offset(bitmap, j),
+					  paddr);
+			else
+				__clear_bit_le(file_page_offset(bitmap, j),
+					       paddr);
+			kunmap_atomic(paddr);
+			if (!test_page_attr(bitmap, page,
+					    BITMAP_PAGE_NEEDWRITE)) {
+				set_page_attr(bitmap, page,
+					      BITMAP_PAGE_PENDING);
 				bitmap->allclean = 0;
 			}
+		} else if (*bmc && *bmc <= 2) {
+			*bmc = 1;
+			bitmap_set_pending(
+				bitmap,
+				(sector_t)j << bitmap->chunkshift);
+			bitmap->allclean = 0;
 		}
 	}
-	spin_unlock_irqrestore(&bitmap->lock, flags);
 
-	/* now sync the final page */
-	if (lastpage != NULL) {
-		spin_lock_irqsave(&bitmap->lock, flags);
-		if (test_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE)) {
-			clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
-			spin_unlock_irqrestore(&bitmap->lock, flags);
-			write_page(bitmap, lastpage, 0);
-		} else {
-			set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
-			bitmap->allclean = 0;
+	/* Now start writeout on any page in NEEDWRITE that isn't DIRTY.
+	 * DIRTY pages need to be written by bitmap_unplug so it can wait
+	 * for them.
+	 * If we find any DIRTY page we stop there and let bitmap_unplug
+	 * handle all the rest.  This is important in the case where
+	 * the first blocking holds the superblock and it has been updated.
+	 * We mustn't write any other blocks before the superblock.
+	 */
+	for (j = 0; j < bitmap->file_pages; j++) {
+		struct page *page = bitmap->filemap[j];
+
+		if (test_page_attr(bitmap, page,
+				    BITMAP_PAGE_DIRTY))
+			/* bitmap_unplug will handle the rest */
+			break;
+		if (test_page_attr(bitmap, page,
+				   BITMAP_PAGE_NEEDWRITE)) {
+			clear_page_attr(bitmap, page,
+					BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
+			write_page(bitmap, page, 0);
+			spin_lock_irqsave(&bitmap->lock, flags);
+			if (!bitmap->filemap)
+				break;
 		}
 	}
+out:
+	spin_unlock_irqrestore(&bitmap->lock, flags);
 
  done:
 	if (bitmap->allclean == 0)
@@ -1386,11 +1405,7 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 
 		(*bmc)--;
 		if (*bmc <= 2) {
-			set_page_attr(bitmap,
-				      filemap_get_page(
-					      bitmap,
-					      offset >> bitmap->chunkshift),
-				      BITMAP_PAGE_PENDING);
+			bitmap_set_pending(bitmap, offset);
 			bitmap->allclean = 0;
 		}
 		spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1476,9 +1491,7 @@ void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, i
 			*bmc |= NEEDED_MASK;
 		else {
 			if (*bmc <= 2) {
-				set_page_attr(bitmap,
-					      filemap_get_page(bitmap, offset >> bitmap->chunkshift),
-					      BITMAP_PAGE_PENDING);
+				bitmap_set_pending(bitmap, offset);
 				bitmap->allclean = 0;
 			}
 		}
@@ -1551,11 +1564,9 @@ static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int n
 		return;
 	}
 	if (!*bmc) {
-		struct page *page;
 		*bmc = 2 | (needed ? NEEDED_MASK : 0);
 		bitmap_count_page(bitmap, offset, 1);
-		page = filemap_get_page(bitmap, offset >> bitmap->chunkshift);
-		set_page_attr(bitmap, page, BITMAP_PAGE_PENDING);
+		bitmap_set_pending(bitmap, offset);
 		bitmap->allclean = 0;
 	}
 	spin_unlock_irq(&bitmap->lock);
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 55ca5ae..5563043 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -163,9 +163,14 @@ struct bitmap_page {
 	 */
 	unsigned int hijacked:1;
 	/*
+	 * If any counter in this page is '1' or '2' - and so could be
+	 * cleared then that page is marked as 'pending'
+	 */
+	unsigned int pending:1;
+	/*
 	 * count of dirty bits on the page
 	 */
-	unsigned int  count:31;
+	unsigned int  count:30;
 };
 
 /* the main bitmap structure - one per mddev */


