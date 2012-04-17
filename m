From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/24] md/bitmap: store bytes in file rather than just in
 last page.
Date: Tue, 17 Apr 2012 18:43:40 +1000
Message-ID: <20120417084340.6433.82130.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This number is more generally useful, and bytes-in-last-page is
easily extracted from it.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   14 +++++++-------
 drivers/md/bitmap.h |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 614062a..9221f97 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -203,9 +203,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 
 		bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
 
-		if (page->index == store->file_pages-1)
-			size = roundup(store->last_page_size,
+		if (page->index == store->file_pages-1) {
+			int last_page_size = store->bytes & (PAGE_SIZE-1);
+			size = roundup(last_page_size,
 				       bdev_logical_block_size(bdev));
+		}
 		/* Just make sure we aren't corrupting data or
 		 * metadata
 		 */
@@ -973,6 +975,8 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	if (!bitmap->mddev->bitmap_info.external)
 		bytes += sizeof(bitmap_super_t);
 
+	store->bytes = bytes;
+
 	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
 
 	if (file && i_size_read(file->f_mapping->host) < bytes) {
@@ -1042,8 +1046,6 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 
 			oldindex = index;
 
-			store->last_page_size = count;
-
 			if (outofdate) {
 				/*
 				 * if bitmap is out of date, dirty the
@@ -1966,9 +1968,7 @@ space_store(struct mddev *mddev, const char *buf, size_t len)
 		return -EINVAL;
 
 	if (mddev->bitmap &&
-	    sectors  < ((mddev->bitmap->storage.file_pages - 1)
-			      * PAGE_SIZE
-			+ mddev->bitmap->storage.last_page_size + 511) >> 9)
+	    sectors < (mddev->bitmap->storage.bytes + 511) >> 9)
 		return -EFBIG; /* Bitmap is too big for this small space */
 
 	/* could make sure it isn't too big, but that isn't really
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 3cdea44..987ad3c 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -200,7 +200,7 @@ struct bitmap {
 		unsigned long *filemap_attr;	/* attributes associated
 						 * w/ filemap pages */
 		unsigned long file_pages;	/* number of pages in the file*/
-		int last_page_size;		/* bytes in the last page */
+		unsigned long bytes;		/* total bytes in the bitmap */
 	} storage;
 
 	unsigned long flags;


