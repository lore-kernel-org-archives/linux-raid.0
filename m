From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md/bitmap:If bmap() failed,free buffers must check bitmap->pending_writes == 0.
Date: Fri, 18 May 2012 19:38:34 +0800
Message-ID: <201205181938310931047@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/bitmap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 17e2b47..74540d7 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -376,6 +376,8 @@ static struct page *read_page(struct file *file, unsigned long index,
 			bh->b_blocknr = bmap(inode, block);
 			if (bh->b_blocknr == 0) {
 				/* Cannot use this file! */
+				wait_event(bitmap->write_wait,
+					atomic_read(&bitmap->pending_writes) == 0);
 				free_buffers(page);
 				page = ERR_PTR(-EINVAL);
 				goto out;
-- 
1.7.5.4

 				
--------------
majianpeng
2012-05-18

