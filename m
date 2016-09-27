From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 02/16] md/bitmap: Move an assignment for the variable "offset"
 in bitmap_storage_alloc()
Date: Tue, 27 Sep 2016 18:48:13 +0200
Message-ID: <dfc56cbb-212f-7d1c-1760-e9b8b1ab121b@users.sourceforge.net>
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
Date: Tue, 27 Sep 2016 13:10:05 +0200

Move the assignment for the local variable "offset" behind
the source code for memory allocations by this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 8cfb02c..78512c6 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -759,7 +759,6 @@ static int bitmap_storage_alloc(struct bitmap_storage *store,
 		bytes += sizeof(bitmap_super_t);
 
 	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
-	offset = slot_number * num_pages;
 	store->filemap = kmalloc_array(num_pages,
 				       sizeof(*store->filemap),
 				       GFP_KERNEL);
@@ -772,6 +771,7 @@ static int bitmap_storage_alloc(struct bitmap_storage *store,
 			return -ENOMEM;
 	}
 
+	offset = slot_number * num_pages;
 	pnum = 0;
 	if (store->sb_page) {
 		store->filemap[0] = store->sb_page;
-- 
2.10.0

