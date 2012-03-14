From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 16/23] md/bitmap: remove some unused noise from bitmap.h
Date: Wed, 14 Mar 2012 15:40:41 +1100
Message-ID: <20120314044041.7978.17045.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index a15436d..557e3e8 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -13,8 +13,6 @@
 #define BITMAP_MAJOR_HI 4
 #define	BITMAP_MAJOR_HOSTENDIAN 3
 
-#define BITMAP_MINOR 39
-
 /*
  * in-memory bitmap:
  *
@@ -101,21 +99,11 @@ typedef __u16 bitmap_counter_t;
 /* same, except a mask value for more efficient bitops */
 #define PAGE_COUNTER_MASK  (PAGE_COUNTER_RATIO - 1)
 
-#define BITMAP_BLOCK_SIZE 512
 #define BITMAP_BLOCK_SHIFT 9
 
 /* how many blocks per chunk? (this is variable) */
 #define CHUNK_BLOCK_RATIO(bitmap) ((bitmap)->mddev->bitmap_info.chunksize >> BITMAP_BLOCK_SHIFT)
 #define CHUNK_BLOCK_SHIFT(bitmap) ((bitmap)->chunkshift - BITMAP_BLOCK_SHIFT)
-#define CHUNK_BLOCK_MASK(bitmap) (CHUNK_BLOCK_RATIO(bitmap) - 1)
-
-/* when hijacked, the counters and bits represent even larger "chunks" */
-/* there will be 1024 chunks represented by each counter in the page pointers */
-#define PAGEPTR_BLOCK_RATIO(bitmap) \
-			(CHUNK_BLOCK_RATIO(bitmap) << PAGE_COUNTER_SHIFT >> 1)
-#define PAGEPTR_BLOCK_SHIFT(bitmap) \
-			(CHUNK_BLOCK_SHIFT(bitmap) + PAGE_COUNTER_SHIFT - 1)
-#define PAGEPTR_BLOCK_MASK(bitmap) (PAGEPTR_BLOCK_RATIO(bitmap) - 1)
 
 #endif
 
@@ -181,12 +169,6 @@ struct bitmap_page {
 	unsigned int  count:31;
 };
 
-/* keep track of bitmap file pages that have pending writes on them */
-struct page_list {
-	struct list_head list;
-	struct page *page;
-};
-
 /* the main bitmap structure - one per mddev */
 struct bitmap {
 	struct bitmap_page *bp;


