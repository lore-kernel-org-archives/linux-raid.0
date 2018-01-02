From: Sean Fu <fxinrong@gmail.com>
Subject: [PATCH 1/3] fs: buffer: Create circular buffer list for pages.
Date: Tue,  2 Jan 2018 14:54:47 +0800
Message-ID: <db4e1a1d0da147d014d7c8359951b37f80434a43.1514867850.git.fxinrong@gmail.com>
References: <cover.1514867850.git.fxinrong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1514867850.git.fxinrong@gmail.com>
In-Reply-To: <cover.1514867850.git.fxinrong@gmail.com>
References: <cover.1514867850.git.fxinrong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: shli@kernel.org, viro@zeniv.linux.org.uk, anton@tuxera.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, Sean Fu <fxinrong@gmail.com>
List-Id: linux-raid.ids

Make alloc_page_buffers to create circular buffer list instead linear
list.
Remove unnecessary traversal in link_dev_buffers to create circular
buffer list.
Make nobh_write_begin and nobh_write_end to support circular buffer list
traversal.

Signed-off-by: Sean Fu <fxinrong@gmail.com>
---
 fs/buffer.c | 48 +++++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 0736a6a..7e62c75 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -842,29 +842,36 @@ int remove_inode_buffers(struct inode *inode)
 struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 		bool retry)
 {
-	struct buffer_head *bh, *head;
+	struct buffer_head *bh, *head, *tail;
 	gfp_t gfp = GFP_NOFS;
 	long offset;
 
 	if (retry)
 		gfp |= __GFP_NOFAIL;
 
-	head = NULL;
+	head = tail = NULL;
 	offset = PAGE_SIZE;
 	while ((offset -= size) >= 0) {
 		bh = alloc_buffer_head(gfp);
 		if (!bh)
 			goto no_grow;
 
-		bh->b_this_page = head;
+		if (unlikely(!head))
+			tail = bh;
+		else
+			bh->b_this_page = head;
+
 		bh->b_blocknr = -1;
 		head = bh;
-
 		bh->b_size = size;
 
 		/* Link the buffer to its page */
 		set_bh_page(bh, page, offset);
 	}
+
+	if (tail)
+		tail->b_this_page = head;
+
 	return head;
 /*
  * In case anything failed, we just free everything we got.
@@ -882,20 +889,6 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 }
 EXPORT_SYMBOL_GPL(alloc_page_buffers);
 
-static inline void
-link_dev_buffers(struct page *page, struct buffer_head *head)
-{
-	struct buffer_head *bh, *tail;
-
-	bh = head;
-	do {
-		tail = bh;
-		bh = bh->b_this_page;
-	} while (bh);
-	tail->b_this_page = head;
-	attach_page_buffers(page, head);
-}
-
 static sector_t blkdev_max_block(struct block_device *bdev, unsigned int size)
 {
 	sector_t retval = ~((sector_t)0);
@@ -993,7 +986,7 @@ grow_dev_page(struct block_device *bdev, sector_t block,
 	 * run under the page lock.
 	 */
 	spin_lock(&inode->i_mapping->private_lock);
-	link_dev_buffers(page, bh);
+	attach_page_buffers(page, bh);
 	end_block = init_page_buffers(page, bdev, (sector_t)index << sizebits,
 			size);
 	spin_unlock(&inode->i_mapping->private_lock);
@@ -1533,16 +1526,14 @@ EXPORT_SYMBOL(block_invalidatepage);
 void create_empty_buffers(struct page *page,
 			unsigned long blocksize, unsigned long b_state)
 {
-	struct buffer_head *bh, *head, *tail;
+	struct buffer_head *bh, *head;
 
 	head = alloc_page_buffers(page, blocksize, true);
 	bh = head;
 	do {
 		bh->b_state |= b_state;
-		tail = bh;
 		bh = bh->b_this_page;
-	} while (bh);
-	tail->b_this_page = head;
+	} while (bh != head);
 
 	spin_lock(&page->mapping->private_lock);
 	if (PageUptodate(page) || PageDirty(page)) {
@@ -2655,11 +2646,14 @@ int nobh_write_begin(struct address_space *mapping,
 		 * any VM or truncate activity.  Hence we don't need to care
 		 * for the buffer_head refcounts.
 		 */
-		for (bh = head; bh; bh = bh->b_this_page) {
+		bh = head;
+		do {
 			wait_on_buffer(bh);
 			if (!buffer_uptodate(bh))
 				ret = -EIO;
-		}
+			bh = bh->b_this_page;
+		} while (bh != head);
+
 		if (ret)
 			goto failed;
 	}
@@ -2717,11 +2711,11 @@ int nobh_write_end(struct file *file, struct address_space *mapping,
 	unlock_page(page);
 	put_page(page);
 
-	while (head) {
+	do {
 		bh = head;
 		head = head->b_this_page;
 		free_buffer_head(bh);
-	}
+	} while (head != fsdata);
 
 	return copied;
 }
-- 
2.6.2
