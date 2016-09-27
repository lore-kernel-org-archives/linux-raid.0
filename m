From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 06/16] md/bitmap: Return directly after a failed kzalloc() in
 bitmap_resize()
Date: Tue, 27 Sep 2016 18:53:20 +0200
Message-ID: <358ed815-9f68-6c48-0eee-0045e40fa96d@users.sourceforge.net>
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
Date: Tue, 27 Sep 2016 15:21:23 +0200

* Return directly after a call of the function "kzalloc" failed here.

* Delete two assignments for the local variable "ret" and the jump
  target "err" which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5092bc0..2d30c83 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -2037,10 +2037,9 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	pages = DIV_ROUND_UP(chunks, PAGE_COUNTER_RATIO);
 
 	new_bp = kzalloc(pages * sizeof(*new_bp), GFP_KERNEL);
-	ret = -ENOMEM;
 	if (!new_bp) {
 		bitmap_file_unmap(&store);
-		goto err;
+		return -ENOMEM;
 	}
 
 	if (!init)
@@ -2160,8 +2159,6 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		bitmap_unplug(bitmap);
 		bitmap->mddev->pers->quiesce(bitmap->mddev, 0);
 	}
-	ret = 0;
-err:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(bitmap_resize);
-- 
2.10.0

