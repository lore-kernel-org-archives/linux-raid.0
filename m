From: Sean Fu <fxinrong@gmail.com>
Subject: [PATCH] fs: buffer: Modify alloc_page_buffers.
Date: Mon, 19 Jun 2017 21:01:36 +0800
Message-ID: <1497877296-22441-1-git-send-email-fxinrong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: shli@kernel.org, anton@tuxera.com, jack@suse.cz, axboe@fb.com, ebiggers@google.com, rpeterso@redhat.com, bmarzins@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, Sean Fu <fxinrong@gmail.com>
List-Id: linux-raid.ids

Make alloc_page_buffers support circular buffer list and initialise
b_state field.
Optimize the performance by removing the buffer list traversal to create
circular buffer list.

Signed-off-by: Sean Fu <fxinrong@gmail.com>
---
 drivers/md/bitmap.c         |  2 +-
 fs/buffer.c                 | 37 +++++++++++++++----------------------
 fs/ntfs/aops.c              |  2 +-
 fs/ntfs/mft.c               |  2 +-
 include/linux/buffer_head.h |  2 +-
 5 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index f4eace5..615a46e 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -367,7 +367,7 @@ static int read_page(struct file *file, unsigned long index,
 	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
 		 (unsigned long long)index << PAGE_SHIFT);
 
-	bh = alloc_page_buffers(page, 1<<inode->i_blkbits, 0);
+	bh = alloc_page_buffers(page, 1<<inode->i_blkbits, 0, 0, 0);
 	if (!bh) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/fs/buffer.c b/fs/buffer.c
index 161be58..8111eca 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -864,9 +864,9 @@ int remove_inode_buffers(struct inode *inode)
  * which may not fail from ordinary buffer allocations.
  */
 struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
-		int retry)
+		int retry, int circular, unsigned long b_state)
 {
-	struct buffer_head *bh, *head;
+	struct buffer_head *bh, *head, *tail;
 	long offset;
 
 try_again:
@@ -879,13 +879,21 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 
 		bh->b_this_page = head;
 		bh->b_blocknr = -1;
-		head = bh;
 
+		if (head == NULL)
+			tail = bh;
+
+		head = bh;
+		bh->b_state = b_state;
 		bh->b_size = size;
 
 		/* Link the buffer to its page */
 		set_bh_page(bh, page, offset);
 	}
+
+	if (circular)
+		tail->b_this_page = head;
+
 	return head;
 /*
  * In case anything failed, we just free everything we got.
@@ -922,14 +930,6 @@ EXPORT_SYMBOL_GPL(alloc_page_buffers);
 static inline void
 link_dev_buffers(struct page *page, struct buffer_head *head)
 {
-	struct buffer_head *bh, *tail;
-
-	bh = head;
-	do {
-		tail = bh;
-		bh = bh->b_this_page;
-	} while (bh);
-	tail->b_this_page = head;
 	attach_page_buffers(page, head);
 }
 
@@ -1024,7 +1024,7 @@ grow_dev_page(struct block_device *bdev, sector_t block,
 	/*
 	 * Allocate some buffers for this page
 	 */
-	bh = alloc_page_buffers(page, size, 0);
+	bh = alloc_page_buffers(page, size, 0, 1, 0);
 	if (!bh)
 		goto failed;
 
@@ -1578,16 +1578,9 @@ EXPORT_SYMBOL(block_invalidatepage);
 void create_empty_buffers(struct page *page,
 			unsigned long blocksize, unsigned long b_state)
 {
-	struct buffer_head *bh, *head, *tail;
+	struct buffer_head *bh, *head;
 
-	head = alloc_page_buffers(page, blocksize, 1);
-	bh = head;
-	do {
-		bh->b_state |= b_state;
-		tail = bh;
-		bh = bh->b_this_page;
-	} while (bh);
-	tail->b_this_page = head;
+	head = alloc_page_buffers(page, blocksize, 1, 1, b_state);
 
 	spin_lock(&page->mapping->private_lock);
 	if (PageUptodate(page) || PageDirty(page)) {
@@ -2642,7 +2635,7 @@ int nobh_write_begin(struct address_space *mapping,
 	 * Be careful: the buffer linked list is a NULL terminated one, rather
 	 * than the circular one we're used to.
 	 */
-	head = alloc_page_buffers(page, blocksize, 0);
+	head = alloc_page_buffers(page, blocksize, 0, 0, 0);
 	if (!head) {
 		ret = -ENOMEM;
 		goto out_release;
diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index cc91856..e692142 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -1739,7 +1739,7 @@ void mark_ntfs_record_dirty(struct page *page, const unsigned int ofs) {
 	spin_lock(&mapping->private_lock);
 	if (unlikely(!page_has_buffers(page))) {
 		spin_unlock(&mapping->private_lock);
-		bh = head = alloc_page_buffers(page, bh_size, 1);
+		bh = head = alloc_page_buffers(page, bh_size, 1, 0, 0);
 		spin_lock(&mapping->private_lock);
 		if (likely(!page_has_buffers(page))) {
 			struct buffer_head *tail;
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index b6f4021..175a02b 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -507,7 +507,7 @@ int ntfs_sync_mft_mirror(ntfs_volume *vol, const unsigned long mft_no,
 	if (unlikely(!page_has_buffers(page))) {
 		struct buffer_head *tail;
 
-		bh = head = alloc_page_buffers(page, blocksize, 1);
+		bh = head = alloc_page_buffers(page, blocksize, 1, 0, 0);
 		do {
 			set_buffer_uptodate(bh);
 			tail = bh;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index bd029e52..9a29826 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -155,7 +155,7 @@ void set_bh_page(struct buffer_head *bh,
 		struct page *page, unsigned long offset);
 int try_to_free_buffers(struct page *);
 struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
-		int retry);
+		int retry, int circular, unsigned long b_state);
 void create_empty_buffers(struct page *, unsigned long,
 			unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
-- 
2.6.2
