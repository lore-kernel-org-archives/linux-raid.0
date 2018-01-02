From: Sean Fu <fxinrong@gmail.com>
Subject: [PATCH 3/3] md: bitmap: Support circular buffer list.
Date: Tue,  2 Jan 2018 14:54:49 +0800
Message-ID: <694be2a2fa9aba6955a11c9ce5556705431d4528.1514867850.git.fxinrong@gmail.com>
References: <cover.1514867850.git.fxinrong@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1514867850.git.fxinrong@gmail.com>
In-Reply-To: <cover.1514867850.git.fxinrong@gmail.com>
References: <cover.1514867850.git.fxinrong@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, viro@zeniv.linux.org.uk, anton@tuxera.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, Sean Fu <fxinrong@gmail.com>
List-Id: linux-raid.ids

Modify write_page free_buffers and read_page to support circular buffer
list.

Signed-off-by: Sean Fu <fxinrong@gmail.com>
---
 drivers/md/md-bitmap.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 239c7bb..b8412c2 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -286,7 +286,7 @@ static void bitmap_file_kick(struct bitmap *bitmap);
  */
 static void write_page(struct bitmap *bitmap, struct page *page, int wait)
 {
-	struct buffer_head *bh;
+	struct buffer_head *bh, *head;
 
 	if (bitmap->storage.file == NULL) {
 		switch (write_sb_page(bitmap, page, wait)) {
@@ -295,15 +295,16 @@ static void write_page(struct bitmap *bitmap, struct page *page, int wait)
 		}
 	} else {
 
-		bh = page_buffers(page);
+		bh = head = page_buffers(page);
 
-		while (bh && bh->b_blocknr) {
-			atomic_inc(&bitmap->pending_writes);
-			set_buffer_locked(bh);
-			set_buffer_mapped(bh);
-			submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
-			bh = bh->b_this_page;
-		}
+		do {
+			if (bh && bh->b_blocknr) {
+				atomic_inc(&bitmap->pending_writes);
+				set_buffer_locked(bh);
+				set_buffer_mapped(bh);
+				submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
+			}
+		} while ((bh = bh->b_this_page) != head);
 
 		if (wait)
 			wait_event(bitmap->write_wait,
@@ -333,17 +334,18 @@ __clear_page_buffers(struct page *page)
 }
 static void free_buffers(struct page *page)
 {
-	struct buffer_head *bh;
+	struct buffer_head *bh, *head;
 
 	if (!PagePrivate(page))
 		return;
 
-	bh = page_buffers(page);
-	while (bh) {
+	bh = head = page_buffers(page);
+	do {
 		struct buffer_head *next = bh->b_this_page;
 		free_buffer_head(bh);
 		bh = next;
-	}
+	} while (bh != head);
+
 	__clear_page_buffers(page);
 	put_page(page);
 }
@@ -362,20 +364,20 @@ static int read_page(struct file *file, unsigned long index,
 {
 	int ret = 0;
 	struct inode *inode = file_inode(file);
-	struct buffer_head *bh;
+	struct buffer_head *bh, *head;
 	sector_t block;
 
 	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
 		 (unsigned long long)index << PAGE_SHIFT);
 
-	bh = alloc_page_buffers(page, 1<<inode->i_blkbits, false);
+	bh = head = alloc_page_buffers(page, 1<<inode->i_blkbits, false);
 	if (!bh) {
 		ret = -ENOMEM;
 		goto out;
 	}
 	attach_page_buffers(page, bh);
 	block = index << (PAGE_SHIFT - inode->i_blkbits);
-	while (bh) {
+	do {
 		if (count == 0)
 			bh->b_blocknr = 0;
 		else {
@@ -400,7 +402,7 @@ static int read_page(struct file *file, unsigned long index,
 		}
 		block++;
 		bh = bh->b_this_page;
-	}
+	} while (bh != head);
 	page->index = index;
 
 	wait_event(bitmap->write_wait,
-- 
2.6.2

