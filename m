From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 2 of 12] Enable the bitmap write-back daemon and wait for it.
Date: Wed, 23 Mar 2005 16:47:10 +1100
Message-ID: <E1DDyhy-0004GS-Rj@notabene.cse.unsw.edu.au>
References: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Currently we don't wait for updates to the bitmap to be
flushed to disk properly.  The infrastructure all there, 
but it isn't being used....

A separate kernel thread (bitmap_writeback_daemon) is needed to
wait for each page as we cannot get callbacks when a page write
completes.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c         |  119 ++++++++++++++++++------------------------
 ./include/linux/raid/bitmap.h |   13 ----
 2 files changed, 55 insertions(+), 77 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-03-22 17:11:04.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-03-22 17:12:09.000000000 +1100
@@ -261,30 +261,33 @@ char *file_path(struct file *file, char 
 /*
  * write out a page
  */
-static int write_page(struct page *page, int wait)
+static int write_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	int ret = -ENOMEM;
 
 	lock_page(page);
 
-	if (page->mapping == NULL)
-		goto unlock_out;
-	else if (i_size_read(page->mapping->host) < page->index << PAGE_SHIFT) {
-		ret = -ENOENT;
-		goto unlock_out;
-	}
-
 	ret = page->mapping->a_ops->prepare_write(NULL, page, 0, PAGE_SIZE);
 	if (!ret)
 		ret = page->mapping->a_ops->commit_write(NULL, page, 0,
 			PAGE_SIZE);
 	if (ret) {
-unlock_out:
 		unlock_page(page);
 		return ret;
 	}
 
 	set_page_dirty(page); /* force it to be written out */
+
+	if (!wait) {
+		/* add to list to be waited for by daemon */
+		struct page_list *item = mempool_alloc(bitmap->write_pool, GFP_NOIO);
+		item->page = page;
+		page_cache_get(page);
+		spin_lock(&bitmap->write_lock);
+		list_add(&item->list, &bitmap->complete_pages);
+		spin_unlock(&bitmap->write_lock);
+		md_wakeup_thread(bitmap->writeback_daemon);
+	}
 	return write_one_page(page, wait);
 }
 
@@ -343,14 +346,13 @@ int bitmap_update_sb(struct bitmap *bitm
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 		return 0;
 	}
-	page_cache_get(bitmap->sb_page);
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = (bitmap_super_t *)kmap(bitmap->sb_page);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
 	if (!bitmap->mddev->degraded)
 		sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
 	kunmap(bitmap->sb_page);
-	return write_page(bitmap->sb_page, 0);
+	return write_page(bitmap, bitmap->sb_page, 0);
 }
 
 /* print out the bitmap file superblock */
@@ -556,10 +558,10 @@ static void bitmap_file_unmap(struct bit
 static void bitmap_stop_daemons(struct bitmap *bitmap);
 
 /* dequeue the next item in a page list -- don't call from irq context */
-static struct page_list *dequeue_page(struct bitmap *bitmap,
-					struct list_head *head)
+static struct page_list *dequeue_page(struct bitmap *bitmap)
 {
 	struct page_list *item = NULL;
+	struct list_head *head = &bitmap->complete_pages;
 
 	spin_lock(&bitmap->write_lock);
 	if (list_empty(head))
@@ -573,23 +575,15 @@ out:
 
 static void drain_write_queues(struct bitmap *bitmap)
 {
-	struct list_head *queues[] = { 	&bitmap->complete_pages, NULL };
-	struct list_head *head;
 	struct page_list *item;
-	int i;
 
-	for (i = 0; queues[i]; i++) {
-		head = queues[i];
-		while ((item = dequeue_page(bitmap, head))) {
-			page_cache_release(item->page);
-			mempool_free(item, bitmap->write_pool);
-		}
+	while ((item = dequeue_page(bitmap))) {
+		/* don't bother to wait */
+		page_cache_release(item->page);
+		mempool_free(item, bitmap->write_pool);
 	}
 
-	spin_lock(&bitmap->write_lock);
-	bitmap->writes_pending = 0; /* make sure waiters continue */
 	wake_up(&bitmap->write_wait);
-	spin_unlock(&bitmap->write_lock);
 }
 
 static void bitmap_file_put(struct bitmap *bitmap)
@@ -734,13 +728,13 @@ int bitmap_unplug(struct bitmap *bitmap)
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 
 		if (attr & (BITMAP_PAGE_DIRTY | BITMAP_PAGE_NEEDWRITE))
-			if (write_page(page, 0))
+			if (write_page(bitmap, page, 0))
 				return 1;
 	}
 	if (wait) { /* if any writes were performed, we need to wait on them */
 		spin_lock_irq(&bitmap->write_lock);
 		wait_event_lock_irq(bitmap->write_wait,
-			bitmap->writes_pending == 0, bitmap->write_lock,
+			list_empty(&bitmap->complete_pages), bitmap->write_lock,
 			wake_up_process(bitmap->writeback_daemon->tsk));
 		spin_unlock_irq(&bitmap->write_lock);
 	}
@@ -847,7 +841,7 @@ static int bitmap_init_from_disk(struct 
 				 */
 				memset(page_address(page) + offset, 0xff,
 					PAGE_SIZE - offset);
-				ret = write_page(page, 1);
+				ret = write_page(bitmap, page, 1);
 				if (ret) {
 					kunmap(page);
 					/* release, page not in filemap yet */
@@ -945,7 +939,7 @@ int bitmap_daemon_work(struct bitmap *bi
 			}
 			spin_unlock_irqrestore(&bitmap->lock, flags);
 			if (attr & BITMAP_PAGE_NEEDWRITE) {
-				if (write_page(page, 0))
+				if (write_page(bitmap, page, 0))
 					bitmap_file_kick(bitmap);
 				page_cache_release(page);
 			}
@@ -961,7 +955,7 @@ int bitmap_daemon_work(struct bitmap *bi
 				if (get_page_attr(bitmap, lastpage) & BITMAP_PAGE_NEEDWRITE) {
 					clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 					spin_unlock_irqrestore(&bitmap->lock, flags);
-					err = write_page(lastpage, 0);
+					err = write_page(bitmap, lastpage, 0);
 				} else {
 					set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 					spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1009,7 +1003,7 @@ int bitmap_daemon_work(struct bitmap *bi
 		if (get_page_attr(bitmap, lastpage) &BITMAP_PAGE_NEEDWRITE) {
 			clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
-			err = write_page(lastpage, 0);
+			err = write_page(bitmap, lastpage, 0);
 		} else {
 			set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1045,46 +1039,40 @@ static void bitmap_writeback_daemon(mdde
 	struct page_list *item;
 	int err = 0;
 
-	while (1) {
-		PRINTK("%s: bitmap writeback daemon waiting...\n", bmname(bitmap));
-		down_interruptible(&bitmap->write_done);
-		if (signal_pending(current)) {
-			printk(KERN_INFO
-			    "%s: bitmap writeback daemon got signal, exiting...\n",
-			    bmname(bitmap));
-			break;
-		}
+	if (signal_pending(current)) {
+		printk(KERN_INFO
+		       "%s: bitmap writeback daemon got signal, exiting...\n",
+		       bmname(bitmap));
+		err = -EINTR;
+		goto out;
+	}
 
-		PRINTK("%s: bitmap writeback daemon woke up...\n", bmname(bitmap));
-		/* wait on bitmap page writebacks */
-		while ((item = dequeue_page(bitmap, &bitmap->complete_pages))) {
-			page = item->page;
-			mempool_free(item, bitmap->write_pool);
-			PRINTK("wait on page writeback: %p %lu\n", page, bitmap->writes_pending);
-			wait_on_page_writeback(page);
-			PRINTK("finished page writeback: %p %lu\n", page, bitmap->writes_pending);
-			spin_lock(&bitmap->write_lock);
-			if (!--bitmap->writes_pending)
-				wake_up(&bitmap->write_wait);
-			spin_unlock(&bitmap->write_lock);
-			err = PageError(page);
-			page_cache_release(page);
-			if (err) {
-				printk(KERN_WARNING "%s: bitmap file writeback "
-					"failed (page %lu): %d\n",
-					bmname(bitmap), page->index, err);
-				bitmap_file_kick(bitmap);
-				goto out;
-			}
+	PRINTK("%s: bitmap writeback daemon woke up...\n", bmname(bitmap));
+	/* wait on bitmap page writebacks */
+	while ((item = dequeue_page(bitmap))) {
+		page = item->page;
+		mempool_free(item, bitmap->write_pool);
+		PRINTK("wait on page writeback: %p\n", page);
+		wait_on_page_writeback(page);
+		PRINTK("finished page writeback: %p\n", page);
+
+		err = PageError(page);
+		page_cache_release(page);
+		if (err) {
+			printk(KERN_WARNING "%s: bitmap file writeback "
+			       "failed (page %lu): %d\n",
+			       bmname(bitmap), page->index, err);
+			bitmap_file_kick(bitmap);
+			goto out;
 		}
 	}
-out:
+ out:
+	wake_up(&bitmap->write_wait);
 	if (err) {
 		printk(KERN_INFO "%s: bitmap writeback daemon exiting (%d)\n",
-			bmname(bitmap), err);
+		       bmname(bitmap), err);
 		daemon_exit(bitmap, &bitmap->writeback_daemon);
 	}
-	return;
 }
 
 static int bitmap_start_daemon(struct bitmap *bitmap, mdk_thread_t **ptr,
@@ -1384,7 +1372,7 @@ int bitmap_setallbits(struct bitmap *bit
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 		memset(kmap(page), 0xff, PAGE_SIZE);
 		kunmap(page);
-		if (write_page(page, 0))
+		if (write_page(bitmap, page, 0))
 			return 1;
 	}
 
@@ -1452,7 +1440,6 @@ int bitmap_create(mddev_t *mddev)
 	mddev->bitmap = bitmap;
 
 	spin_lock_init(&bitmap->write_lock);
-	init_MUTEX_LOCKED(&bitmap->write_done);
 	INIT_LIST_HEAD(&bitmap->complete_pages);
 	init_waitqueue_head(&bitmap->write_wait);
 	bitmap->write_pool = mempool_create(WRITE_POOL_SIZE, write_pool_alloc,

diff ./include/linux/raid/bitmap.h~current~ ./include/linux/raid/bitmap.h
--- ./include/linux/raid/bitmap.h~current~	2005-03-22 17:11:00.000000000 +1100
+++ ./include/linux/raid/bitmap.h	2005-03-22 17:12:09.000000000 +1100
@@ -233,21 +233,12 @@ struct bitmap {
 	unsigned long daemon_sleep; /* how many seconds between updates? */
 
 	/*
-	 * bitmap write daemon - this daemon performs writes to the bitmap file
-	 * this thread is only needed because of a limitation in ext3 (jbd)
-	 * that does not allow a task to have two journal transactions ongoing
-	 * simultaneously (even if the transactions are for two different
-	 * filesystems) -- in the case of bitmap, that would be the filesystem
-	 * that the bitmap file resides on and the filesystem that is mounted
-	 * on the md device -- see current->journal_info in jbd/transaction.c
+	 * bitmap_writeback_daemon waits for file-pages that have been written,
+	 * as there is no way to get a call-back when a page write completes.
 	 */
 	mdk_thread_t *writeback_daemon;
 	spinlock_t write_lock;
-	struct semaphore write_ready;
-	struct semaphore write_done;
-	unsigned long writes_pending;
 	wait_queue_head_t write_wait;
-	struct list_head write_pages;
 	struct list_head complete_pages;
 	mempool_t *write_pool;
 };
