From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 7 of 12] Don't skip bitmap pages due to lack of bit that we just cleared.
Date: Wed, 23 Mar 2005 16:47:11 +1100
Message-ID: <E1DDyhz-0004Gm-Bg@notabene.cse.unsw.edu.au>
References: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When looking for pages that need cleaning we skip pages that
don't have BITMAP_PAGE_CLEAN set.  But if it is the 'current'
page we will have cleared that bit ourselves, so skipping it is wrong.
So: move the 'skip this page' inside 'if page != lastpage'.

Also fold call of file_page_offset into the one place where
the value (bit) is used.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |   35 +++++++++++++++++------------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-03-22 17:20:08.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-03-22 17:20:50.000000000 +1100
@@ -908,7 +908,7 @@ static bitmap_counter_t *bitmap_get_coun
 
 int bitmap_daemon_work(struct bitmap *bitmap)
 {
-	unsigned long bit, j;
+	unsigned long j;
 	unsigned long flags;
 	struct page *page = NULL, *lastpage = NULL;
 	int err = 0;
@@ -931,24 +931,23 @@ int bitmap_daemon_work(struct bitmap *bi
 		}
 
 		page = filemap_get_page(bitmap, j);
-		/* skip this page unless it's marked as needing cleaning */
-		if (!((attr=get_page_attr(bitmap, page)) & BITMAP_PAGE_CLEAN)) {
-			if (attr & BITMAP_PAGE_NEEDWRITE) {
-				page_cache_get(page);
-				clear_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
-			}
-			spin_unlock_irqrestore(&bitmap->lock, flags);
-			if (attr & BITMAP_PAGE_NEEDWRITE) {
-				if (write_page(bitmap, page, 0))
-					bitmap_file_kick(bitmap);
-				page_cache_release(page);
-			}
-			continue;
-		}
-
-		bit = file_page_offset(j);
 
 		if (page != lastpage) {
+			/* skip this page unless it's marked as needing cleaning */
+			if (!((attr=get_page_attr(bitmap, page)) & BITMAP_PAGE_CLEAN)) {
+				if (attr & BITMAP_PAGE_NEEDWRITE) {
+					page_cache_get(page);
+					clear_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
+				}
+				spin_unlock_irqrestore(&bitmap->lock, flags);
+				if (attr & BITMAP_PAGE_NEEDWRITE) {
+					if (write_page(bitmap, page, 0))
+						bitmap_file_kick(bitmap);
+					page_cache_release(page);
+				}
+				continue;
+			}
+
 			/* grab the new page, sync and release the old */
 			page_cache_get(page);
 			if (lastpage != NULL) {
@@ -990,7 +989,7 @@ int bitmap_daemon_work(struct bitmap *bi
 						  -1);
 
 				/* clear the bit */
-				clear_bit(bit, page_address(page));
+				clear_bit(file_page_offset(j), page_address(page));
 			}
 		}
 		spin_unlock_irqrestore(&bitmap->lock, flags);
