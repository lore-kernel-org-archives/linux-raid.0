From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 20/23] md/bitmap: remove unnecessary indirection when
 allocating.
Date: Wed, 14 Mar 2012 15:40:41 +1100
Message-ID: <20120314044041.7978.86998.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

These funcitons don't add anything useful except possibly the trace
points, and I don't think they are worth the extra indirection.
So remove them.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   31 +++----------------------------
 1 files changed, 3 insertions(+), 28 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index e12b515..534e007 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -36,31 +36,6 @@ static inline char *bmname(struct bitmap *bitmap)
 }
 
 /*
- * just a placeholder - calls kmalloc for bitmap pages
- */
-static unsigned char *bitmap_alloc_page(struct bitmap *bitmap)
-{
-	unsigned char *page;
-
-	page = kzalloc(PAGE_SIZE, GFP_NOIO);
-	if (!page)
-		printk("%s: bitmap_alloc_page FAILED\n", bmname(bitmap));
-	else
-		pr_debug("%s: bitmap_alloc_page: allocated page at %p\n",
-			 bmname(bitmap), page);
-	return page;
-}
-
-/*
- * for now just a placeholder -- just calls kfree for bitmap pages
- */
-static void bitmap_free_page(struct bitmap *bitmap, unsigned char *page)
-{
-	pr_debug("%s: bitmap_free_page: free page %p\n", bmname(bitmap), page);
-	kfree(page);
-}
-
-/*
  * check a page and, if necessary, allocate it (or hijack it if the alloc fails)
  *
  * 1) check to see if this page is allocated, if it's not then try to alloc
@@ -97,7 +72,7 @@ __acquires(bitmap->lock)
 	/* this page has not been allocated yet */
 
 	spin_unlock_irq(&bitmap->lock);
-	mappage = bitmap_alloc_page(bitmap);
+	mappage = kzalloc(PAGE_SIZE, GFP_NOIO);
 	spin_lock_irq(&bitmap->lock);
 
 	if (mappage == NULL) {
@@ -110,7 +85,7 @@ __acquires(bitmap->lock)
 	} else if (bitmap->bp[page].map ||
 		   bitmap->bp[page].hijacked) {
 		/* somebody beat us to getting the page */
-		bitmap_free_page(bitmap, mappage);
+		kfree(mappage);
 		return 0;
 	} else {
 
@@ -142,7 +117,7 @@ static void bitmap_checkfree(struct bitmap *bitmap, unsigned long page)
 		ptr = bitmap->bp[page].map;
 		bitmap->bp[page].map = NULL;
 		bitmap->missing_pages++;
-		bitmap_free_page(bitmap, ptr);
+		kfree(ptr);
 	}
 }
 


