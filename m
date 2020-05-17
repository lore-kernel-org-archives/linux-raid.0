From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 02/10] md: remove __clear_page_buffers and use attach/detach_page_private
Date: Sun, 17 May 2020 23:47:10 +0200
Message-ID: <20200517214718.468-3-guoqing.jiang@cloud.ionos.com>
References: <20200517214718.468-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200517214718.468-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, david@fromorbit.com, hch@infradead.org, willy@infradead.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After introduce attach/detach_page_private in pagemap.h, we can remove
the duplicat code and call the new functions.

Cc: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
No change since RFC V3.

RFC V2 -> RFC V3
1. rename clear_page_private to detach_page_private.

RFC -> RFC V2
1. change the name of new functions to attach/clear_page_private.

 drivers/md/md-bitmap.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b952bd45bd6a..95a5f3757fa3 100644
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
+	detach_page_private(page);
 	put_page(page);
 }
 
@@ -374,7 +366,7 @@ static int read_page(struct file *file, unsigned long index,
 		ret = -ENOMEM;
 		goto out;
 	}
-	attach_page_buffers(page, bh);
+	attach_page_private(page, bh);
 	blk_cur = index << (PAGE_SHIFT - inode->i_blkbits);
 	while (bh) {
 		block = blk_cur;
-- 
2.17.1
