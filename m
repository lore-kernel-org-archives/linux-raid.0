From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 10/16] md/bitmap: Rename a jump label in bitmap_create()
Date: Tue, 27 Sep 2016 18:57:29 +0200
Message-ID: <b2984a33-8918-edf9-92b3-9969e45f634f@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 27 Sep 2016 16:06:35 +0200

Adjust jump labels according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5125186..1f7f1e1 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1818,22 +1818,22 @@ struct bitmap *bitmap_create(struct mddev *mddev, int slot)
 			err = -EINVAL;
 	}
 	if (err)
-		goto error;
+		goto free_bitmap;
 
 	bitmap->daemon_lastrun = jiffies;
 	err = bitmap_resize(bitmap, blocks, mddev->bitmap_info.chunksize, 1);
 	if (err)
-		goto error;
+		goto free_bitmap;
 
 	printk(KERN_INFO "created bitmap (%lu pages) for device %s\n",
 	       bitmap->counts.pages, bmname(bitmap));
 
 	err = test_bit(BITMAP_WRITE_ERROR, &bitmap->flags) ? -EIO : 0;
 	if (err)
-		goto error;
+		goto free_bitmap;
 
 	return bitmap;
- error:
+free_bitmap:
 	bitmap_free(bitmap);
 	return ERR_PTR(err);
 }
-- 
2.10.0

