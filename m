From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [RFC PATCH 2/9] md: remove __clear_page_buffers and use set/clear_fs_page_private
Date: Sun, 26 Apr 2020 23:49:18 +0200
Message-ID: <20200426214925.10970-3-guoqing.jiang@cloud.ionos.com>
References: <20200426214925.10970-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200426214925.10970-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: hch@infradead.org, david@fromorbit.com, willy@infradead.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After introduce set/clear_fs_page_private in pagemap.h, we can remove
the duplicat code and call the new functions.

Cc: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/md-bitmap.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b952bd45bd6a..b935473c82b7 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -324,14 +324,6 @@ static void end_bitmap_write(struct buffer_head *bh, int uptodate)
 		wake_up(&bitmap->write_wait);
 }
 
-/* copied from buffer.c */
-static void
-__clear_page_buffers(struct page *page)
-{
-	ClearPagePrivate(page);
-	set_page_private(page, 0);
-	put_page(page);
-}
 static void free_buffers(struct page *page)
 {
 	struct buffer_head *bh;
@@ -345,7 +337,7 @@ static void free_buffers(struct page *page)
 		free_buffer_head(bh);
 		bh = next;
 	}
-	__clear_page_buffers(page);
+	clear_fs_page_private(page);
 	put_page(page);
 }
 
@@ -374,7 +366,7 @@ static int read_page(struct file *file, unsigned long index,
 		ret = -ENOMEM;
 		goto out;
 	}
-	attach_page_buffers(page, bh);
+	set_fs_page_private(page, bh);
 	blk_cur = index << (PAGE_SHIFT - inode->i_blkbits);
 	while (bh) {
 		block = blk_cur;
-- 
2.17.1
