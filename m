From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] md: use set_bit_le and clear_bit_le
Date: Sat,  2 Mar 2013 23:35:57 +0900
Message-ID: <1362234957-5570-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The value returned by test_and_set_bit_le() drivers/md/bitmap.c is not used.
So just use set_bit_le(). The same goes for test_and_clear_bit_le().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
---
 drivers/md/bitmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 4fd9d6a..5a2c754 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -846,7 +846,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 		set_bit(bit, kaddr);
 	else
-		test_and_set_bit_le(bit, kaddr);
+		set_bit_le(bit, kaddr);
 	kunmap_atomic(kaddr);
 	pr_debug("set file bit %lu page %lu\n", bit, page->index);
 	/* record page number so it gets flushed to disk when unplug occurs */
@@ -868,7 +868,7 @@ static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 		clear_bit(bit, paddr);
 	else
-		test_and_clear_bit_le(bit, paddr);
+		clear_bit_le(bit, paddr);
 	kunmap_atomic(paddr);
 	if (!test_page_attr(bitmap, page->index, BITMAP_PAGE_NEEDWRITE)) {
 		set_page_attr(bitmap, page->index, BITMAP_PAGE_PENDING);
-- 
1.8.1.2
