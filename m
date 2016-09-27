From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 12/16] md/bitmap: One check less in read_page() at the end
Date: Tue, 27 Sep 2016 18:59:35 +0200
Message-ID: <18d73bcc-795b-8680-c82c-9a06047a8ef3@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 27 Sep 2016 16:30:25 +0200

* Adjust a jump target.

* Delete a repeated check which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index c186e5d..e7a7fc8 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -367,7 +367,7 @@ static int read_page(struct file *file, unsigned long index,
 	bh = alloc_page_buffers(page, 1<<inode->i_blkbits, 0);
 	if (!bh) {
 		ret = -ENOMEM;
-		goto out;
+		goto report_failure;
 	}
 	attach_page_buffers(page, bh);
 	block = index << (PAGE_SHIFT - inode->i_blkbits);
@@ -379,7 +379,7 @@ static int read_page(struct file *file, unsigned long index,
 			if (bh->b_blocknr == 0) {
 				/* Cannot use this file! */
 				ret = -EINVAL;
-				goto out;
+				goto report_failure;
 			}
 			bh->b_bdev = inode->i_sb->s_bdev;
 			if (count < (1<<inode->i_blkbits))
@@ -401,14 +401,14 @@ static int read_page(struct file *file, unsigned long index,
 
 	wait_event(bitmap->write_wait,
 		   atomic_read(&bitmap->pending_writes)==0);
-	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
+	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags)) {
 		ret = -EIO;
-out:
-	if (ret)
+report_failure:
 		printk(KERN_ALERT "md: bitmap read error: (%dB @ %llu): %d\n",
 			(int)PAGE_SIZE,
 			(unsigned long long)index << PAGE_SHIFT,
 			ret);
+	}
 	return ret;
 }
 
-- 
2.10.0

