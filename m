From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] md: use proper little-endian bitops
Date: Mon, 30 May 2011 21:56:20 +0900
Message-ID: <1306760180-4309-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Using __test_and_{set,clear}_bit_le() with ignoring its return value
can be replaced with __{set,clear}_bit_le().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
---
 drivers/md/bitmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 70bd738..52fa6cf 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -856,7 +856,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			set_bit(bit, kaddr);
 		else
-			__test_and_set_bit_le(bit, kaddr);
+			__set_bit_le(bit, kaddr);
 		kunmap_atomic(kaddr, KM_USER0);
 		PRINTK("set file bit %lu page %lu\n", bit, page->index);
 	}
@@ -1228,7 +1228,7 @@ void bitmap_daemon_work(mddev_t *mddev)
 						clear_bit(file_page_offset(bitmap, j),
 							  paddr);
 					else
-						__test_and_clear_bit_le(file_page_offset(bitmap, j),
+						__clear_bit_le(file_page_offset(bitmap, j),
 							       paddr);
 					kunmap_atomic(paddr, KM_USER0);
 				} else
-- 
1.7.4.4
