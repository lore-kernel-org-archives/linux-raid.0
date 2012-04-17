From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 14/24] md/bitmap: remove async freeing of bitmap file.
Date: Tue, 17 Apr 2012 18:43:41 +1000
Message-ID: <20120417084341.6433.32572.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is no real value in freeing things the moment there is an error.
It is just as good to free the bitmap file and pages when the bitmap
is explicitly removed (and replaced?) or at shutdown.

With this gone, the bitmap will only disappear when the array is
quiescent, so we can remove some locking.

As the 'filemap' doesn't disappear now, include extra checks before
trying to write any of it out.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 4322f5b..fb8c978 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -737,7 +737,6 @@ static void bitmap_file_unmap(struct bitmap *bitmap)
 	int pages;
 	struct bitmap_storage *store = &bitmap->storage;
 
-	spin_lock_irq(&bitmap->lock);
 	map = store->filemap;
 	store->filemap = NULL;
 	attr = store->filemap_attr;
@@ -746,7 +745,6 @@ static void bitmap_file_unmap(struct bitmap *bitmap)
 	store->file_pages = 0;
 	sb_page = store->sb_page;
 	store->sb_page = NULL;
-	spin_unlock_irq(&bitmap->lock);
 
 	while (pages--)
 		if (map[pages] != sb_page) /* 0 is sb_page, release it below */
@@ -762,10 +760,8 @@ static void bitmap_file_put(struct bitmap *bitmap)
 {
 	struct file *file;
 
-	spin_lock_irq(&bitmap->lock);
 	file = bitmap->storage.file;
 	bitmap->storage.file = NULL;
-	spin_unlock_irq(&bitmap->lock);
 
 	if (file)
 		wait_event(bitmap->write_wait,
@@ -807,10 +803,6 @@ static void bitmap_file_kick(struct bitmap *bitmap)
 			       "%s: disabling internal bitmap due to errors\n",
 			       bmname(bitmap));
 	}
-
-	bitmap_file_put(bitmap);
-
-	return;
 }
 
 enum bitmap_page_attr {
@@ -901,7 +893,8 @@ void bitmap_unplug(struct bitmap *bitmap)
 	int dirty, need_write;
 	int wait = 0;
 
-	if (!bitmap || !bitmap->storage.filemap)
+	if (!bitmap || !bitmap->storage.filemap ||
+	    test_bit(BITMAP_STALE, &bitmap->flags))
 		return;
 
 	/* look at each page to see if there are any set bits that need to be
@@ -1220,7 +1213,10 @@ void bitmap_daemon_work(struct mddev *mddev)
 	 * the first blocking holds the superblock and it has been updated.
 	 * We mustn't write any other blocks before the superblock.
 	 */
-	for (j = 0; j < bitmap->storage.file_pages; j++) {
+	for (j = 0;
+	     j < bitmap->storage.file_pages
+		     && !test_bit(BITMAP_STALE, &bitmap->flags);
+	     j++) {
 
 		if (test_page_attr(bitmap, j,
 				    BITMAP_PAGE_DIRTY))


