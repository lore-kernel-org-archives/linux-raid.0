From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 07/16] md/bitmap: Replace a kzalloc() call by kcalloc() in
 bitmap_resize()
Date: Tue, 27 Sep 2016 18:54:39 +0200
Message-ID: <7345990e-3c59-de68-f07b-8b68458b6cf3@users.sourceforge.net>
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
Date: Tue, 27 Sep 2016 15:26:51 +0200

The script "checkpatch.pl" can point information out like the following.

WARNING: Prefer kcalloc over kzalloc with multiply

Thus fix the affected source code place.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 2d30c83..41d99fd 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -2035,8 +2035,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		return ret;
 
 	pages = DIV_ROUND_UP(chunks, PAGE_COUNTER_RATIO);
-
-	new_bp = kzalloc(pages * sizeof(*new_bp), GFP_KERNEL);
+	new_bp = kcalloc(pages, sizeof(*new_bp), GFP_KERNEL);
 	if (!new_bp) {
 		bitmap_file_unmap(&store);
 		return -ENOMEM;
-- 
2.10.0

