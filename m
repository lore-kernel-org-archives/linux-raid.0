From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 21/34] md: use proper little-endian bitops
Date: Thu, 21 Jul 2011 12:32:27 +1000
Message-ID: <20110721023227.6728.60858.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
List-Id: linux-raid.ids

From: Akinobu Mita <akinobu.mita@gmail.com>

Using __test_and_{set,clear}_bit_le() with ignoring its return value
can be replaced with __{set,clear}_bit_le().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 574b09a..39ff0ef 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -932,7 +932,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			set_bit(bit, kaddr);
 		else
-			__test_and_set_bit_le(bit, kaddr);
+			__set_bit_le(bit, kaddr);
 		kunmap_atomic(kaddr, KM_USER0);
 		PRINTK("set file bit %lu page %lu\n", bit, page->index);
 	}
@@ -1304,8 +1304,10 @@ void bitmap_daemon_work(mddev_t *mddev)
 						clear_bit(file_page_offset(bitmap, j),
 							  paddr);
 					else
-						__test_and_clear_bit_le(file_page_offset(bitmap, j),
-							       paddr);
+						__clear_bit_le(
+							file_page_offset(bitmap,
+									 j),
+							paddr);
 					kunmap_atomic(paddr, KM_USER0);
 				} else
 					log->type->clear_region(log, j);


