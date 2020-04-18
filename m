From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 5/5] md-bitmap: don't duplicate code for __clear_page_buffers
Date: Sun, 19 Apr 2020 00:51:23 +0200
Message-ID: <20200418225123.31850-6-guoqing.jiang@cloud.ionos.com>
References: <20200418225123.31850-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200418225123.31850-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After __clear_page_buffers is exported, we can use it directly instead of
copy the implementation.

Cc: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/md-bitmap.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b952bd45bd6a..a1464417ada6 100644
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
-- 
2.17.1
