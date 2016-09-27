From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 01/16] md/bitmap: Use kmalloc_array() in
 bitmap_storage_alloc()
Date: Tue, 27 Sep 2016 18:45:51 +0200
Message-ID: <c8f8d7c1-c62b-d889-9800-2da8358c1f50@users.sourceforge.net>
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
Date: Tue, 27 Sep 2016 13:01:07 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kmalloc_array".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 13041ee..8cfb02c 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -760,9 +760,9 @@ static int bitmap_storage_alloc(struct bitmap_storage *store,
 
 	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
 	offset = slot_number * num_pages;
-
-	store->filemap = kmalloc(sizeof(struct page *)
-				 * num_pages, GFP_KERNEL);
+	store->filemap = kmalloc_array(num_pages,
+				       sizeof(*store->filemap),
+				       GFP_KERNEL);
 	if (!store->filemap)
 		return -ENOMEM;
 
-- 
2.10.0

