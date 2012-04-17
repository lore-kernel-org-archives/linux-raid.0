From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/24] md/bitmap: allow a bitmap with no backing storage.
Date: Tue, 17 Apr 2012 18:43:40 +1000
Message-ID: <20120417084339.6433.72325.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

An md bitmap comprises two parts
 - internal counting of active writes per 'chunk'.
 - external storage of whether there are any active writes on
   each chunk

The second requires the first, but the first doesn't require the
second.

Not having backing storage means that the bitmap cannot expedite
resync after a crash, but it still allows us to expedite the recovery
of a recently-removed device.

So: allow a bitmap to exist even if there is no backing device.
In that case we default to 128M chunks.

A particular value of this is that we can remove and re-add a bitmap
(possibly of a different granularity) on a degraded array, and not
lose the information needed to fast-recover the missing device.

We don't actually activate these bitmaps yet - that will come
in a later patch.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |  136 +++++++++++++++++++++++++++++----------------------
 drivers/md/md.c     |    5 +-
 2 files changed, 79 insertions(+), 62 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index c894aa4..9cc42ba 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -553,6 +553,14 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	unsigned long long events;
 	int err = -EINVAL;
 
+	if (!bitmap->file && !bitmap->mddev->bitmap_info.offset) {
+		chunksize = 128 * 1024 * 1024;
+		daemon_sleep = 5 * HZ;
+		write_behind = 0;
+		bitmap->flags = BITMAP_STALE;
+		err = 0;
+		goto out_no_sb;
+	}
 	/* page 0 is the superblock, read it... */
 	if (bitmap->file) {
 		loff_t isize = i_size_read(bitmap->file->f_mapping->host);
@@ -623,18 +631,19 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	}
 
 	/* assign fields using values from superblock */
-	bitmap->mddev->bitmap_info.chunksize = chunksize;
-	bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
-	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
 	bitmap->flags |= le32_to_cpu(sb->state);
 	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
 		bitmap->flags |= BITMAP_HOSTENDIAN;
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
-	if (bitmap->flags & BITMAP_STALE)
-		bitmap->events_cleared = bitmap->mddev->events;
 	err = 0;
 out:
 	kunmap_atomic(sb);
+out_no_sb:
+	if (bitmap->flags & BITMAP_STALE)
+		bitmap->events_cleared = bitmap->mddev->events;
+	bitmap->mddev->bitmap_info.chunksize = chunksize;
+	bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
+	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
 	if (err)
 		bitmap_print_sb(bitmap);
 	return err;
@@ -837,9 +846,6 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	void *kaddr;
 	unsigned long chunk = block >> bitmap->chunkshift;
 
-	if (!bitmap->filemap)
-		return;
-
 	page = filemap_get_page(bitmap, chunk);
 	if (!page)
 		return;
@@ -857,6 +863,29 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	set_page_attr(bitmap, page, BITMAP_PAGE_DIRTY);
 }
 
+static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
+{
+	unsigned long bit;
+	struct page *page;
+	void *paddr;
+	unsigned long chunk = block >> bitmap->chunkshift;
+
+	page = filemap_get_page(bitmap, chunk);
+	if (!page)
+		return;
+	bit = file_page_offset(bitmap, chunk);
+	paddr = kmap_atomic(page);
+	if (bitmap->flags & BITMAP_HOSTENDIAN)
+		clear_bit(bit, paddr);
+	else
+		__clear_bit_le(bit, paddr);
+	kunmap_atomic(paddr);
+	if (!test_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE)) {
+		set_page_attr(bitmap, page, BITMAP_PAGE_PENDING);
+		bitmap->allclean = 0;
+	}
+}
+
 /* this gets called when the md device is ready to unplug its underlying
  * (slave) device queues -- before we let any writes go down, we need to
  * sync the dirty pages of the bitmap file to disk */
@@ -867,7 +896,7 @@ void bitmap_unplug(struct bitmap *bitmap)
 	struct page *page;
 	int wait = 0;
 
-	if (!bitmap)
+	if (!bitmap || !bitmap->filemap)
 		return;
 
 	/* look at each page to see if there are any set bits that need to be
@@ -930,7 +959,20 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	chunks = bitmap->chunks;
 	file = bitmap->file;
 
-	BUG_ON(!file && !bitmap->mddev->bitmap_info.offset);
+	if (!file && !bitmap->mddev->bitmap_info.offset) {
+		/* No permanent bitmap - fill with '1s'. */
+		bitmap->filemap = NULL;
+		bitmap->file_pages = 0;
+		for (i = 0; i < chunks ; i++) {
+			/* if the disk bit is set, set the memory bit */
+			int needed = ((sector_t)(i+1) << (bitmap->chunkshift)
+				      >= start);
+			bitmap_set_memory_bits(bitmap,
+					       (sector_t)i << bitmap->chunkshift,
+					       needed);
+		}
+		return 0;
+	}
 
 	outofdate = bitmap->flags & BITMAP_STALE;
 	if (outofdate)
@@ -1045,15 +1087,6 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		}
 	}
 
-	/* everything went OK */
-	ret = 0;
-	bitmap_mask_state(bitmap, BITMAP_STALE, MASK_UNSET);
-
-	if (bit_cnt) { /* Kick recovery if any bits were set */
-		set_bit(MD_RECOVERY_NEEDED, &bitmap->mddev->recovery);
-		md_wakeup_thread(bitmap->mddev->thread);
-	}
-
 	printk(KERN_INFO "%s: bitmap initialized from disk: "
 	       "read %lu/%lu pages, set %lu of %lu bits\n",
 	       bmname(bitmap), bitmap->file_pages, num_pages, bit_cnt, chunks);
@@ -1073,6 +1106,12 @@ void bitmap_write_all(struct bitmap *bitmap)
 	 */
 	int i;
 
+	if (!bitmap || !bitmap->filemap)
+		return;
+	if (bitmap->file)
+		/* Only one copy, so nothing needed */
+		return;
+
 	spin_lock_irq(&bitmap->lock);
 	for (i = 0; i < bitmap->file_pages; i++)
 		set_page_attr(bitmap, bitmap->filemap[i],
@@ -1115,7 +1154,6 @@ void bitmap_daemon_work(struct mddev *mddev)
 	unsigned long nextpage;
 	unsigned long flags;
 	sector_t blocks;
-	void *paddr;
 
 	/* Use a mutex to guard daemon_work against
 	 * bitmap_destroy.
@@ -1142,10 +1180,6 @@ void bitmap_daemon_work(struct mddev *mddev)
 	 * we will write it.
 	 */
 	spin_lock_irqsave(&bitmap->lock, flags);
-	if (!bitmap->filemap)
-		/* error or shutdown */
-		goto out;
-
 	for (j = 0; j < bitmap->file_pages; j++)
 		if (test_page_attr(bitmap, bitmap->filemap[j],
 				   BITMAP_PAGE_PENDING)) {
@@ -1161,11 +1195,14 @@ void bitmap_daemon_work(struct mddev *mddev)
 		 * other changes */
 		bitmap_super_t *sb;
 		bitmap->need_sync = 0;
-		sb = kmap_atomic(bitmap->sb_page);
-		sb->events_cleared =
-			cpu_to_le64(bitmap->events_cleared);
-		kunmap_atomic(sb);
-		set_page_attr(bitmap, bitmap->sb_page, BITMAP_PAGE_NEEDWRITE);
+		if (bitmap->filemap) {
+			sb = kmap_atomic(bitmap->sb_page);
+			sb->events_cleared =
+				cpu_to_le64(bitmap->events_cleared);
+			kunmap_atomic(sb);
+			set_page_attr(bitmap, bitmap->sb_page,
+				      BITMAP_PAGE_NEEDWRITE);
+		}
 	}
 	/* Now look at the bitmap counters and if any are '2' or '1',
 	 * decrement and handle accordingly.
@@ -1173,6 +1210,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 	nextpage = 0;
 	for (j = 0; j < bitmap->chunks; j++) {
 		bitmap_counter_t *bmc;
+		sector_t  block = (sector_t)j << bitmap->chunkshift;
 
 		if (j == nextpage) {
 			nextpage += PAGE_COUNTER_RATIO;
@@ -1183,7 +1221,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 			bitmap->bp[j >> PAGE_COUNTER_SHIFT].pending = 0;
 		}
 		bmc = bitmap_get_counter(bitmap,
-					 (sector_t)j << bitmap->chunkshift,
+					 block,
 					 &blocks, 0);
 
 		if (!bmc) {
@@ -1192,33 +1230,12 @@ void bitmap_daemon_work(struct mddev *mddev)
 		}
 		if (*bmc == 1 && !bitmap->need_sync) {
 			/* We can clear the bit */
-			struct page *page;
 			*bmc = 0;
-			bitmap_count_page(
-				bitmap,
-				(sector_t)j << bitmap->chunkshift,
-				-1);
-
-			page = filemap_get_page(bitmap, j);
-			paddr = kmap_atomic(page);
-			if (bitmap->flags & BITMAP_HOSTENDIAN)
-				clear_bit(file_page_offset(bitmap, j),
-					  paddr);
-			else
-				__clear_bit_le(file_page_offset(bitmap, j),
-					       paddr);
-			kunmap_atomic(paddr);
-			if (!test_page_attr(bitmap, page,
-					    BITMAP_PAGE_NEEDWRITE)) {
-				set_page_attr(bitmap, page,
-					      BITMAP_PAGE_PENDING);
-				bitmap->allclean = 0;
-			}
+			bitmap_count_page(bitmap, block, -1);
+			bitmap_file_clear_bit(bitmap, block);
 		} else if (*bmc && *bmc <= 2) {
 			*bmc = 1;
-			bitmap_set_pending(
-				bitmap,
-				(sector_t)j << bitmap->chunkshift);
+			bitmap_set_pending(bitmap, block);
 			bitmap->allclean = 0;
 		}
 	}
@@ -1249,7 +1266,6 @@ void bitmap_daemon_work(struct mddev *mddev)
 				break;
 		}
 	}
-out:
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 
  done:
@@ -1551,7 +1567,7 @@ EXPORT_SYMBOL(bitmap_cond_end_sync);
 static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed)
 {
 	/* For each chunk covered by any of these sectors, set the
-	 * counter to 1 and set resync_needed.  They should all
+	 * counter to 2 and possibly set resync_needed.  They should all
 	 * be 0 at this point
 	 */
 
@@ -1678,10 +1694,6 @@ int bitmap_create(struct mddev *mddev)
 
 	BUILD_BUG_ON(sizeof(bitmap_super_t) != 256);
 
-	if (!file
-	    && !mddev->bitmap_info.offset) /* bitmap disabled, nothing to do */
-		return 0;
-
 	BUG_ON(file && mddev->bitmap_info.offset);
 
 	bitmap = kzalloc(sizeof(*bitmap), GFP_KERNEL);
@@ -1802,6 +1814,10 @@ int bitmap_load(struct mddev *mddev)
 
 	if (err)
 		goto out;
+	bitmap_mask_state(bitmap, BITMAP_STALE, MASK_UNSET);
+
+	/* Kick recovery in case any bits were set */
+	set_bit(MD_RECOVERY_NEEDED, &bitmap->mddev->recovery);
 
 	mddev->thread->timeout = mddev->bitmap_info.daemon_sleep;
 	md_wakeup_thread(mddev->thread);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 64b86c7..e84e2e6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5139,7 +5139,8 @@ int md_run(struct mddev *mddev)
 		err = -EINVAL;
 		mddev->pers->stop(mddev);
 	}
-	if (err == 0 && mddev->pers->sync_request) {
+	if (err == 0 && mddev->pers->sync_request &&
+	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
 		err = bitmap_create(mddev);
 		if (err) {
 			printk(KERN_ERR "%s: failed to create bitmap (%d)\n",
@@ -7847,7 +7848,7 @@ void md_check_recovery(struct mddev *mddev)
 			goto unlock;
 
 		if (mddev->pers->sync_request) {
-			if (spares && mddev->bitmap && ! mddev->bitmap->file) {
+			if (spares) {
 				/* We are adding a device or devices to an array
 				 * which has the bitmap stored on all devices.
 				 * So make sure all bitmap pages get written


