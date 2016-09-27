From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 04/16] md/bitmap: Improve another size determination in
 bitmap_storage_alloc()
Date: Tue, 27 Sep 2016 18:50:06 +0200
Message-ID: <6ca5ea5b-6348-2d17-4cb5-f1c3a512995c@users.sourceforge.net>
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
Date: Tue, 27 Sep 2016 14:19:00 +0200

Replace the specification of a data type by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9b3f723..c278865 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -791,9 +791,9 @@ static int bitmap_storage_alloc(struct bitmap_storage *store,
 
 	/* We need 4 bits per page, rounded up to a multiple
 	 * of sizeof(unsigned long) */
-	store->filemap_attr = kzalloc(
-		roundup(DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
-		GFP_KERNEL);
+	store->filemap_attr = kzalloc(roundup(DIV_ROUND_UP(num_pages * 4, 8),
+					      sizeof(*store->filemap_attr)),
+				      GFP_KERNEL);
 	if (!store->filemap_attr)
 		return -ENOMEM;
 
-- 
2.10.0

