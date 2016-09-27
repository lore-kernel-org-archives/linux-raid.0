From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 11/16] md/bitmap: Rename a jump label in
 bitmap_init_from_disk()
Date: Tue, 27 Sep 2016 18:58:31 +0200
Message-ID: <c0627779-73fd-9da6-6c85-04db90481227@users.sourceforge.net>
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
Date: Tue, 27 Sep 2016 16:12:47 +0200

Adjust jump labels according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 1f7f1e1..c186e5d 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1064,7 +1064,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		       bmname(bitmap),
 		       (unsigned long) i_size_read(file->f_mapping->host),
 		       store->bytes);
-		goto err;
+		goto report_failure;
 	}
 
 	oldindex = ~0L;
@@ -1098,7 +1098,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 					index + node_offset, count);
 
 			if (ret)
-				goto err;
+				goto report_failure;
 
 			oldindex = index;
 
@@ -1116,7 +1116,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 				ret = -EIO;
 				if (test_bit(BITMAP_WRITE_ERROR,
 					     &bitmap->flags))
-					goto err;
+					goto report_failure;
 			}
 		}
 		paddr = kmap_atomic(page);
@@ -1143,8 +1143,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	       bit_cnt, chunks);
 
 	return 0;
-
- err:
+report_failure:
 	printk(KERN_INFO "%s: bitmap initialisation failed: %d\n",
 	       bmname(bitmap), ret);
 	return ret;
-- 
2.10.0

