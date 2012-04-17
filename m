From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 17/24] md/bitmap: make bitmap bitops atomic.
Date: Tue, 17 Apr 2012 18:43:42 +1000
Message-ID: <20120417084341.6433.19713.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This allows us to remove spinlock protection which is
more heavy-weight than simple atomics.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index c26100b..e88e553 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -842,7 +842,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 		set_bit(bit, kaddr);
 	else
-		__set_bit_le(bit, kaddr);
+		test_and_set_bit_le(bit, kaddr);
 	kunmap_atomic(kaddr);
 	pr_debug("set file bit %lu page %lu\n", bit, page->index);
 	/* record page number so it gets flushed to disk when unplug occurs */
@@ -864,7 +864,7 @@ static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
 	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
 		clear_bit(bit, paddr);
 	else
-		__clear_bit_le(bit, paddr);
+		test_and_clear_bit_le(bit, paddr);
 	kunmap_atomic(paddr);
 	if (!test_page_attr(bitmap, page->index, BITMAP_PAGE_NEEDWRITE)) {
 		set_page_attr(bitmap, page->index, BITMAP_PAGE_PENDING);
@@ -1536,9 +1536,7 @@ void bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e)
 	for (chunk = s; chunk <= e; chunk++) {
 		sector_t sec = (sector_t)chunk << bitmap->chunkshift;
 		bitmap_set_memory_bits(bitmap, sec, 1);
-		spin_lock_irq(&bitmap->lock);
 		bitmap_file_set_bit(bitmap, sec);
-		spin_unlock_irq(&bitmap->lock);
 		if (sec < bitmap->mddev->recovery_cp)
 			/* We are asserting that the array is dirty,
 			 * so move the recovery_cp address back so


