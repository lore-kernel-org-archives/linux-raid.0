From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 19/24] md/bitmap: use DIV_ROUND_UP instead of open-code
Date: Tue, 17 Apr 2012 18:43:42 +1000
Message-ID: <20120417084342.6433.37789.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Also take the opportunity to simplify CHUNK_BLOCK_RATIO.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |    5 ++---
 drivers/md/bitmap.h |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index d2750a3..bcd5107 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1695,9 +1695,8 @@ int bitmap_create(struct mddev *mddev)
 			      - BITMAP_BLOCK_SHIFT);
 
 	/* now that chunksize and chunkshift are set, we can use these macros */
-	chunks = (blocks + bitmap->counts.chunkshift - 1) >>
-			bitmap->counts.chunkshift;
-	pages = (chunks + PAGE_COUNTER_RATIO - 1) / PAGE_COUNTER_RATIO;
+	chunks = DIV_ROUND_UP(blocks, CHUNK_BLOCK_RATIO(bitmap));
+	pages = DIV_ROUND_UP(chunks, PAGE_COUNTER_RATIO);
 
 	BUG_ON(!pages);
 
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 256a850..530be4d 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -102,7 +102,7 @@ typedef __u16 bitmap_counter_t;
 #define BITMAP_BLOCK_SHIFT 9
 
 /* how many blocks per chunk? (this is variable) */
-#define CHUNK_BLOCK_RATIO(bitmap) ((bitmap)->mddev->bitmap_info.chunksize >> BITMAP_BLOCK_SHIFT)
+#define	CHUNK_BLOCK_RATIO(bitmap) (1 << (bitmap)->counts.chunkshift)
 
 #endif
 


