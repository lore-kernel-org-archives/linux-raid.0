From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 004 of 4] Make sure md/bitmap doesn't try to write a page with active writeback
Date: Tue, 10 May 2005 15:04:02 +1000
Message-ID: <E1DVMuY-0000Q4-R1@notabene.cse.unsw.edu.au>
References: <20050510145931.1553.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Due to the use of write-behind, it is possible for md to 
write a page to the bitmap file that is still completing writeback.
This is not allowed.

With this patch, we detect those cases and either force a sync write,
or back off and try later, as appropriate.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |   68 +++++++++++++++++++++++++++-----------------------
 1 files changed, 38 insertions(+), 30 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-05-10 14:44:11.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-05-10 14:55:51.000000000 +1000
@@ -313,7 +313,16 @@ static int write_page(struct bitmap *bit
 	if (bitmap->file == NULL)
 		return write_sb_page(bitmap->mddev, bitmap->offset, page, wait);
 
-	lock_page(page);
+	if (wait)
+		lock_page(page);
+	else {
+		if (TestSetPageLocked(page))
+			return -EAGAIN; /* already locked */
+		if (PageWriteback(page)) {
+			unlock_page(page);
+			return -EAGAIN;
+		}
+	}
 
 	ret = page->mapping->a_ops->prepare_write(NULL, page, 0, PAGE_SIZE);
 	if (!ret)
@@ -400,7 +409,7 @@ int bitmap_update_sb(struct bitmap *bitm
 	if (!bitmap->mddev->degraded)
 		sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
 	kunmap(bitmap->sb_page);
-	return write_page(bitmap, bitmap->sb_page, 0);
+	return write_page(bitmap, bitmap->sb_page, 1);
 }
 
 /* print out the bitmap file superblock */
@@ -762,6 +771,7 @@ int bitmap_unplug(struct bitmap *bitmap)
 	unsigned long i, attr, flags;
 	struct page *page;
 	int wait = 0;
+	int err;
 
 	if (!bitmap)
 		return 0;
@@ -782,9 +792,17 @@ int bitmap_unplug(struct bitmap *bitmap)
 			wait = 1;
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 
-		if (attr & (BITMAP_PAGE_DIRTY | BITMAP_PAGE_NEEDWRITE))
-			if (write_page(bitmap, page, 0))
+		if (attr & (BITMAP_PAGE_DIRTY | BITMAP_PAGE_NEEDWRITE)) {
+			err = write_page(bitmap, page, 0);
+			if (err == -EAGAIN) {
+				if (attr & BITMAP_PAGE_DIRTY)
+					err = write_page(bitmap, page, 1);
+				else
+					err = 0;
+			}
+			if (err)
 				return 1;
+		}
 	}
 	if (wait) { /* if any writes were performed, we need to wait on them */
 		if (bitmap->file) {
@@ -1006,8 +1024,15 @@ int bitmap_daemon_work(struct bitmap *bi
 				}
 				spin_unlock_irqrestore(&bitmap->lock, flags);
 				if (attr & BITMAP_PAGE_NEEDWRITE) {
-					if (write_page(bitmap, page, 0))
+					switch (write_page(bitmap, page, 0)) {
+					case -EAGAIN:
+						set_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
+						break;
+					case 0:
+						break;
+					default:
 						bitmap_file_kick(bitmap);
+					}
 					page_cache_release(page);
 				}
 				continue;
@@ -1020,6 +1045,10 @@ int bitmap_daemon_work(struct bitmap *bi
 					clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 					spin_unlock_irqrestore(&bitmap->lock, flags);
 					err = write_page(bitmap, lastpage, 0);
+					if (err == -EAGAIN) {
+						err = 0;
+						set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
+					}
 				} else {
 					set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 					spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1068,6 +1097,10 @@ int bitmap_daemon_work(struct bitmap *bi
 			clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
 			err = write_page(bitmap, lastpage, 0);
+			if (err == -EAGAIN) {
+				set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
+				err = 0;
+			}
 		} else {
 			set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1421,31 +1454,6 @@ static void bitmap_set_memory_bits(struc
 	}
 }
 
-/* dirty the entire bitmap */
-int bitmap_setallbits(struct bitmap *bitmap)
-{
-	unsigned long flags;
-	unsigned long j;
-
-	/* dirty the in-memory bitmap */
-	bitmap_set_memory_bits(bitmap, 0, bitmap->chunks << CHUNK_BLOCK_SHIFT(bitmap), 1);
-
-	/* dirty the bitmap file */
-	for (j = 0; j < bitmap->file_pages; j++) {
-		struct page *page = bitmap->filemap[j];
-
-		spin_lock_irqsave(&bitmap->lock, flags);
-		page_cache_get(page);
-		spin_unlock_irqrestore(&bitmap->lock, flags);
-		memset(kmap(page), 0xff, PAGE_SIZE);
-		kunmap(page);
-		if (write_page(bitmap, page, 0))
-			return 1;
-	}
-
-	return 0;
-}
-
 /*
  * free memory that was allocated
  */
