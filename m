From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 13/16] md/bitmap: Adjust checks for null pointers in 11
 functions
Date: Tue, 27 Sep 2016 19:00:45 +0200
Message-ID: <f379e7a5-e380-2fe5-8ee3-b74db4aba86f@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 27 Sep 2016 17:40:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" can point information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index e7a7fc8..f8900cc 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -88,7 +88,7 @@ __acquires(bitmap->lock)
 	mappage = kzalloc(PAGE_SIZE, GFP_NOIO);
 	spin_lock_irq(&bitmap->lock);
 
-	if (mappage == NULL) {
+	if (!mappage) {
 		pr_debug("md/bitmap: map page allocation failed, hijacking\n");
 		/* We don't support hijack for cluster raid */
 		if (no_hijack)
@@ -186,7 +186,7 @@ static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mdde
 	 * list_for_each_entry_continue_rcu() to find the first entry.
 	 */
 	rcu_read_lock();
-	if (rdev == NULL)
+	if (!rdev)
 		/* start at the beginning */
 		rdev = list_entry(&mddev->disks, struct md_rdev, same_set);
 	else {
@@ -284,7 +284,7 @@ static void write_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	struct buffer_head *bh;
 
-	if (bitmap->storage.file == NULL) {
+	if (!bitmap->storage.file) {
 		switch (write_sb_page(bitmap, page, wait)) {
 		case -EINVAL:
 			set_bit(BITMAP_WRITE_ERROR, &bitmap->flags);
@@ -493,7 +493,7 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 	unsigned long chunksize, daemon_sleep, write_behind;
 
 	bitmap->storage.sb_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (bitmap->storage.sb_page == NULL)
+	if (!bitmap->storage.sb_page)
 		return -ENOMEM;
 	bitmap->storage.sb_page->index = 0;
 
@@ -767,7 +767,7 @@ static int bitmap_storage_alloc(struct bitmap_storage *store,
 
 	if (with_super && !store->sb_page) {
 		store->sb_page = alloc_page(GFP_KERNEL|__GFP_ZERO);
-		if (store->sb_page == NULL)
+		if (!store->sb_page)
 			return -ENOMEM;
 	}
 
@@ -1209,7 +1209,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 	 */
 	mutex_lock(&mddev->bitmap_info.mutex);
 	bitmap = mddev->bitmap;
-	if (bitmap == NULL) {
+	if (!bitmap) {
 		mutex_unlock(&mddev->bitmap_info.mutex);
 		return;
 	}
@@ -1336,7 +1336,7 @@ __acquires(bitmap->lock)
 	err = bitmap_checkpage(bitmap, page, create, 0);
 
 	if (bitmap->bp[page].hijacked ||
-	    bitmap->bp[page].map == NULL)
+	    !bitmap->bp[page].map)
 		csize = ((sector_t)1) << (bitmap->chunkshift +
 					  PAGE_COUNTER_SHIFT - 1);
 	else
@@ -1481,7 +1481,7 @@ static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t
 {
 	bitmap_counter_t *bmc;
 	int rv;
-	if (bitmap == NULL) {/* FIXME or bitmap set as 'failed' */
+	if (!bitmap) {/* FIXME or bitmap set as 'failed' */
 		*blocks = 1024;
 		return 1; /* always resync if no bitmap */
 	}
@@ -1533,13 +1533,13 @@ void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, i
 	bitmap_counter_t *bmc;
 	unsigned long flags;
 
-	if (bitmap == NULL) {
+	if (!bitmap) {
 		*blocks = 1024;
 		return;
 	}
 	spin_lock_irqsave(&bitmap->counts.lock, flags);
 	bmc = bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
-	if (bmc == NULL)
+	if (!bmc)
 		goto unlock;
 	/* locked */
 	if (RESYNC(*bmc)) {
@@ -2455,7 +2455,7 @@ static ssize_t can_clear_show(struct mddev *mddev, char *page)
 
 static ssize_t can_clear_store(struct mddev *mddev, const char *buf, size_t len)
 {
-	if (mddev->bitmap == NULL)
+	if (!mddev->bitmap)
 		return -ENOENT;
 	if (strncmp(buf, "false", 5) == 0)
 		mddev->bitmap->need_sync = 1;
@@ -2476,7 +2476,7 @@ behind_writes_used_show(struct mddev *mddev, char *page)
 {
 	ssize_t ret;
 	spin_lock(&mddev->lock);
-	if (mddev->bitmap == NULL)
+	if (!mddev->bitmap)
 		ret = sprintf(page, "0\n");
 	else
 		ret = sprintf(page, "%lu\n",
-- 
2.10.0

