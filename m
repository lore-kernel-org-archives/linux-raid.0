From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH 1/2] md bitmap bug fixes
Date: Wed, 09 Mar 2005 17:18:09 -0500
Message-ID: <422F7621.8090602@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050102080507000303080001"
Sender: linux-raid-owner@vger.kernel.org
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------050102080507000303080001
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Neil,

here are a couple of patches -- this one for the kernel, the next for 
mdadm. They fix a few issues that I found while testing the new bitmap 
intent logging code.

Briefly, the issues were:

kernel:

added call to bitmap_daemon_work() from raid1d so that the bitmap would 
actually get cleared

fixed the marking of pages with BITMAP_CLEAN so that the bitmap would 
get cleared correctly after resync and normal write I/O

pass back errors from write_page() since it now does actual writes itself

sync_size changed to sectors (was array_size which was KB) -- some 
divisions by 2 were needed

mdadm:

avoid setting of sb->events_lo = 1 when creating a 0.90 superblock -- it 
doesn't seem to be necessary and it was causing the event counters to 
start at 4 billion+ (events_lo is actually the high part of the events 
counter, on little endian machines anyway)

some sync_size changes, as in the kernel

if'ed out super1 definition which is now in the kernel headers

included sys/time.h to avoid compile error


Thanks,
Paul

--------------050102080507000303080001
Content-Type: text/plain;
 name="md_bitmap_3_38_bug_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_bitmap_3_38_bug_fix.diff"


Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

 bitmap.c |   58 +++++++++++++++++++++++++++++++++-------------------------
 raid1.c  |    1 +
 2 files changed, 34 insertions(+), 25 deletions(-)
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.11-rc3-mm2-patch-all/drivers/md/bitmap.c linux-2.6.11-rc3-mm2-patch-all-bitmap-bug-fix/drivers/md/bitmap.c
--- linux-2.6.11-rc3-mm2-patch-all/drivers/md/bitmap.c	Fri Feb 18 15:44:03 2005
+++ linux-2.6.11-rc3-mm2-patch-all-bitmap-bug-fix/drivers/md/bitmap.c	Wed Mar  9 14:55:03 2005
@@ -265,6 +265,7 @@ static int write_page(struct page *page,
 {
 	int ret = -ENOMEM;
 
+	PRINTK("bitmap write page %lu\n", page->index);
 	lock_page(page);
 
 	if (page->mapping == NULL)
@@ -350,8 +351,7 @@ int bitmap_update_sb(struct bitmap *bitm
 	if (!bitmap->mddev->degraded)
 		sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
 	kunmap(bitmap->sb_page);
-	write_page(bitmap->sb_page, 0);
-	return 0;
+	return write_page(bitmap->sb_page, 0);
 }
 
 /* print out the bitmap file superblock */
@@ -363,21 +363,22 @@ void bitmap_print_sb(struct bitmap *bitm
 		return;
 	sb = (bitmap_super_t *)kmap(bitmap->sb_page);
 	printk(KERN_DEBUG "%s: bitmap file superblock:\n", bmname(bitmap));
-	printk(KERN_DEBUG "       magic: %08x\n", le32_to_cpu(sb->magic));
-	printk(KERN_DEBUG "     version: %d\n", le32_to_cpu(sb->version));
-	printk(KERN_DEBUG "        uuid: %08x.%08x.%08x.%08x\n",
+	printk(KERN_DEBUG "         magic: %08x\n", le32_to_cpu(sb->magic));
+	printk(KERN_DEBUG "       version: %d\n", le32_to_cpu(sb->version));
+	printk(KERN_DEBUG "          uuid: %08x.%08x.%08x.%08x\n",
 					*(__u32 *)(sb->uuid+0),
 					*(__u32 *)(sb->uuid+4),
 					*(__u32 *)(sb->uuid+8),
 					*(__u32 *)(sb->uuid+12));
-	printk(KERN_DEBUG "      events: %llu\n",
+	printk(KERN_DEBUG "        events: %llu\n",
 			(unsigned long long) le64_to_cpu(sb->events));
-	printk(KERN_DEBUG "events_clred: %llu\n",
+	printk(KERN_DEBUG "events cleared: %llu\n",
 			(unsigned long long) le64_to_cpu(sb->events_cleared));
-	printk(KERN_DEBUG "       state: %08x\n", le32_to_cpu(sb->state));
-	printk(KERN_DEBUG "   chunksize: %d B\n", le32_to_cpu(sb->chunksize));
-	printk(KERN_DEBUG "daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
-	printk(KERN_DEBUG "   sync size: %llu KB\n", le64_to_cpu(sb->sync_size));
+	printk(KERN_DEBUG "         state: %08x\n", le32_to_cpu(sb->state));
+	printk(KERN_DEBUG "     chunksize: %d B\n", le32_to_cpu(sb->chunksize));
+	printk(KERN_DEBUG "  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
+	printk(KERN_DEBUG "     sync size: %llu KB\n", (unsigned long long)
+						le64_to_cpu(sb->sync_size) / 2);
 	kunmap(bitmap->sb_page);
 }
 
@@ -734,7 +735,8 @@ int bitmap_unplug(struct bitmap *bitmap)
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 
 		if (attr & (BITMAP_PAGE_DIRTY | BITMAP_PAGE_NEEDWRITE))
-			write_page(page, 0);
+			if (write_page(page, 0) != 0)
+				return 1;
 	}
 	if (wait) { /* if any writes were performed, we need to wait on them */
 		spin_lock_irq(&bitmap->write_lock);
@@ -795,7 +797,7 @@ static int bitmap_init_from_disk(struct 
 			bytes + sizeof(bitmap_super_t));
 		goto out;
 	}
-	num_pages++;
+	// PRC: ???: num_pages++;
 	bitmap->filemap = kmalloc(sizeof(struct page *) * num_pages, GFP_KERNEL);
 	if (!bitmap->filemap) {
 		ret = -ENOMEM;
@@ -953,14 +958,18 @@ int bitmap_daemon_work(struct bitmap *bi
 
 		bit = file_page_offset(j);
 
+
 		if (page != lastpage) {
+			PRINTK("bitmap clean at page %lu\n", j);
 			/* grab the new page, sync and release the old */
 			page_cache_get(page);
 			if (lastpage != NULL) {
 				if (get_page_attr(bitmap, lastpage) & BITMAP_PAGE_NEEDWRITE) {
 					clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 					spin_unlock_irqrestore(&bitmap->lock, flags);
-					write_page(lastpage, 0);
+					err = write_page(lastpage, 0);
+					/* we're done cleaning */
+					clear_page_attr(bitmap, lastpage, BITMAP_PAGE_CLEAN);
 				} else {
 					set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 					spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -969,22 +978,21 @@ int bitmap_daemon_work(struct bitmap *bi
 				page_cache_release(lastpage);
 				if (err)
 					bitmap_file_kick(bitmap);
+				/* we're done cleaning this page */
+				clear_page_attr(bitmap, lastpage, BITMAP_PAGE_CLEAN);
 			} else
 				spin_unlock_irqrestore(&bitmap->lock, flags);
 			lastpage = page;
 			kmap(page);
-/*
-			printk("bitmap clean at page %lu\n", j);
-*/
+
 			spin_lock_irqsave(&bitmap->lock, flags);
-			clear_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}
 		bmc = bitmap_get_counter(bitmap, j << CHUNK_BLOCK_SHIFT(bitmap),
 					&blocks, 0);
 		if (bmc) {
-/*
-  if (j < 100) printk("bitmap: j=%lu, *bmc = 0x%x\n", j, *bmc);
-*/
+
+PRINTK("bitmap: j=%lu, *bmc = 0x%x\n", j, *bmc);
+
 			if (*bmc == 2) {
 				*bmc=1; /* maybe clear the bit next time */
 				set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
@@ -1005,10 +1013,12 @@ int bitmap_daemon_work(struct bitmap *bi
 	if (lastpage != NULL) {
 		kunmap(lastpage);
 		spin_lock_irqsave(&bitmap->lock, flags);
-		if (get_page_attr(bitmap, lastpage) &BITMAP_PAGE_NEEDWRITE) {
+		if (get_page_attr(bitmap, lastpage) & BITMAP_PAGE_NEEDWRITE) {
 			clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
-			write_page(lastpage, 0);
+			err = write_page(lastpage, 0);
+			/* we're done cleaning and we've written the page out */
+			clear_page_attr(bitmap, lastpage, BITMAP_PAGE_CLEAN);
 		} else {
 			set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1118,7 +1128,7 @@ static int bitmap_start_daemon(struct bi
 	md_wakeup_thread(daemon); /* start it running */
 
 	PRINTK("%s: %s daemon (pid %d) started...\n", 
-		bmname(bitmap), name, bitmap->daemon->tsk->pid);
+		bmname(bitmap), name, daemon->tsk->pid);
 out_unlock:
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	return 0;
@@ -1381,7 +1404,8 @@ int bitmap_setallbits(struct bitmap *bit
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 		memset(kmap(page), 0xff, PAGE_SIZE);
 		kunmap(page);
-		write_page(page, 0);
+		if (write_page(page, 0) != 0)
+			return 1;
 	}
 
 	return 0;
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.11-rc3-mm2-patch-all/drivers/md/raid1.c linux-2.6.11-rc3-mm2-patch-all-bitmap-bug-fix/drivers/md/raid1.c
--- linux-2.6.11-rc3-mm2-patch-all/drivers/md/raid1.c	Fri Feb 18 15:44:03 2005
+++ linux-2.6.11-rc3-mm2-patch-all-bitmap-bug-fix/drivers/md/raid1.c	Mon Mar  7 15:25:52 2005
@@ -1001,6 +1003,7 @@ static void raid1d(mddev_t *mddev)
 	mdk_rdev_t *rdev;
 
 	md_check_recovery(mddev);
+	bitmap_daemon_work(mddev->bitmap);
 	
 	for (;;) {
 		char b[BDEVNAME_SIZE];

--------------050102080507000303080001--
