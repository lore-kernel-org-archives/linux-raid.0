From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] md/bitmap: use i_blocksize()
Date: Fri, 20 Jan 2017 22:29:52 +0800
Message-ID: <2e7ac27f6ca34bfa01f3b6906fdf409c348e9187.1484895660.git.geliangtang@gmail.com>
References: <0a58b38c7ddfbbc8f56cb8d815114bd4357a6016.1484895399.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0a58b38c7ddfbbc8f56cb8d815114bd4357a6016.1484895399.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Since i_blocksize() helper has been defined in fs.h, use it instead
of open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/md/bitmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9fb2cca..30b1b89 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -367,7 +367,7 @@ static int read_page(struct file *file, unsigned long index,
 	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
 		 (unsigned long long)index << PAGE_SHIFT);
 
-	bh = alloc_page_buffers(page, 1<<inode->i_blkbits, 0);
+	bh = alloc_page_buffers(page, i_blocksize(inode), 0);
 	if (!bh) {
 		ret = -ENOMEM;
 		goto out;
@@ -385,10 +385,10 @@ static int read_page(struct file *file, unsigned long index,
 				goto out;
 			}
 			bh->b_bdev = inode->i_sb->s_bdev;
-			if (count < (1<<inode->i_blkbits))
+			if (count < i_blocksize(inode))
 				count = 0;
 			else
-				count -= (1<<inode->i_blkbits);
+				count -= i_blocksize(inode);
 
 			bh->b_end_io = end_bitmap_write;
 			bh->b_private = bitmap;
-- 
2.9.3
