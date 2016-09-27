From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 05/16] md/bitmap: Return directly after a failed
 bitmap_storage_alloc() in bitmap_resize()
Date: Tue, 27 Sep 2016 18:51:15 +0200
Message-ID: <6971c808-fc6d-0d78-c672-7c63c043485b@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 27 Sep 2016 14:47:29 +0200

Return directly after a memory allocation failed in this function
at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index c278865..5092bc0 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -2032,7 +2032,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 					   mddev_is_clustered(bitmap->mddev)
 					   ? bitmap->cluster_slot : 0);
 	if (ret)
-		goto err;
+		return ret;
 
 	pages = DIV_ROUND_UP(chunks, PAGE_COUNTER_RATIO);
 
-- 
2.10.0
