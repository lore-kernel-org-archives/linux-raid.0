From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 09/13] md-cluster: always setup in-memory bitmap
Date: Thu, 21 Apr 2016 13:58:10 +0800
Message-ID: <1461218294-4960-10-git-send-email-gqjiang@suse.com>
References: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The in-memory bitmap for raid is allocated on demand,
then for cluster scenario, it is possible that slave
node which received RESYNCING message doesn't have the
in-memory bitmap when master node is perform resyncing,
so we can't make bitmap is match up well among each
nodes.

So for cluster scenario, we need always preserve the
bitmap, and ensure the page will not be freed. And a
no_hijack flag is introduced to both bitmap_checkpage
and bitmap_get_counter, which makes cluster raid returns
fail once allocate failed.

And the next patch is relied on this change since it
keeps sync bitmap among each nodes during resyncing
stage.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/bitmap.c | 59 +++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 7df6b4f..00cf1c1 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -46,7 +46,7 @@ static inline char *bmname(struct bitmap *bitmap)
  * allocated while we're using it
  */
 static int bitmap_checkpage(struct bitmap_counts *bitmap,
-			    unsigned long page, int create)
+			    unsigned long page, int create, int no_hijack)
 __releases(bitmap->lock)
 __acquires(bitmap->lock)
 {
@@ -90,6 +90,9 @@ __acquires(bitmap->lock)
 
 	if (mappage == NULL) {
 		pr_debug("md/bitmap: map page allocation failed, hijacking\n");
+		/* We don't support hijack for cluster raid */
+		if (no_hijack)
+			return -ENOMEM;
 		/* failed - set the hijacked flag so that we can use the
 		 * pointer as a counter */
 		if (!bitmap->bp[page].map)
@@ -1177,7 +1180,7 @@ static void bitmap_set_pending(struct bitmap_counts *bitmap, sector_t offset)
 
 static bitmap_counter_t *bitmap_get_counter(struct bitmap_counts *bitmap,
 					    sector_t offset, sector_t *blocks,
-					    int create);
+					    int create, int no_hijack);
 
 /*
  * bitmap daemon -- periodically wakes up to clean bits and flush pages
@@ -1257,7 +1260,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 		}
 		bmc = bitmap_get_counter(counts,
 					 block,
-					 &blocks, 0);
+					 &blocks, 0, 0);
 
 		if (!bmc) {
 			j |= PAGE_COUNTER_MASK;
@@ -1307,7 +1310,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 
 static bitmap_counter_t *bitmap_get_counter(struct bitmap_counts *bitmap,
 					    sector_t offset, sector_t *blocks,
-					    int create)
+					    int create, int no_hijack)
 __releases(bitmap->lock)
 __acquires(bitmap->lock)
 {
@@ -1321,7 +1324,7 @@ __acquires(bitmap->lock)
 	sector_t csize;
 	int err;
 
-	err = bitmap_checkpage(bitmap, page, create);
+	err = bitmap_checkpage(bitmap, page, create, 0);
 
 	if (bitmap->bp[page].hijacked ||
 	    bitmap->bp[page].map == NULL)
@@ -1368,7 +1371,7 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 		bitmap_counter_t *bmc;
 
 		spin_lock_irq(&bitmap->counts.lock);
-		bmc = bitmap_get_counter(&bitmap->counts, offset, &blocks, 1);
+		bmc = bitmap_get_counter(&bitmap->counts, offset, &blocks, 1, 0);
 		if (!bmc) {
 			spin_unlock_irq(&bitmap->counts.lock);
 			return 0;
@@ -1430,7 +1433,7 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 		bitmap_counter_t *bmc;
 
 		spin_lock_irqsave(&bitmap->counts.lock, flags);
-		bmc = bitmap_get_counter(&bitmap->counts, offset, &blocks, 0);
+		bmc = bitmap_get_counter(&bitmap->counts, offset, &blocks, 0, 0);
 		if (!bmc) {
 			spin_unlock_irqrestore(&bitmap->counts.lock, flags);
 			return;
@@ -1474,7 +1477,7 @@ static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t
 		return 1; /* always resync if no bitmap */
 	}
 	spin_lock_irq(&bitmap->counts.lock);
-	bmc = bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
+	bmc = bitmap_get_counter(&bitmap->counts, offset, blocks, 0, 0);
 	rv = 0;
 	if (bmc) {
 		/* locked */
@@ -1526,7 +1529,7 @@ void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, i
 		return;
 	}
 	spin_lock_irqsave(&bitmap->counts.lock, flags);
-	bmc = bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
+	bmc = bitmap_get_counter(&bitmap->counts, offset, blocks, 0, 0);
 	if (bmc == NULL)
 		goto unlock;
 	/* locked */
@@ -1604,7 +1607,7 @@ static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int n
 	sector_t secs;
 	bitmap_counter_t *bmc;
 	spin_lock_irq(&bitmap->counts.lock);
-	bmc = bitmap_get_counter(&bitmap->counts, offset, &secs, 1);
+	bmc = bitmap_get_counter(&bitmap->counts, offset, &secs, 1, 0);
 	if (!bmc) {
 		spin_unlock_irq(&bitmap->counts.lock);
 		return;
@@ -2029,17 +2032,47 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		     chunks << chunkshift);
 
 	spin_lock_irq(&bitmap->counts.lock);
+	/* For cluster raid, need to pre-allocate bitmap */
+	if (mddev_is_clustered(bitmap->mddev)) {
+		unsigned long page;
+		for (page = 0; page < pages; page++) {
+			ret = bitmap_checkpage(&bitmap->counts, page, 1, 1);
+			if (ret) {
+				unsigned long k;
+
+				/* deallocate the page memory */
+				for (k = 0; k < page; k++) {
+					if (new_bp[k].map)
+						kfree(new_bp[k].map);
+				}
+
+				/* restore some fields from old_counts */
+				bitmap->counts.bp = old_counts.bp;
+				bitmap->counts.pages = old_counts.pages;
+				bitmap->counts.missing_pages = old_counts.pages;
+				bitmap->counts.chunkshift = old_counts.chunkshift;
+				bitmap->counts.chunks = old_counts.chunks;
+				bitmap->mddev->bitmap_info.chunksize = 1 << (old_counts.chunkshift +
+									     BITMAP_BLOCK_SHIFT);
+				blocks = old_counts.chunks << old_counts.chunkshift;
+				pr_err("Could not pre-allocate in-memory bitmap for cluster raid\n");
+				break;
+			} else
+				bitmap->counts.bp[page].count += 1;
+		}
+	}
+
 	for (block = 0; block < blocks; ) {
 		bitmap_counter_t *bmc_old, *bmc_new;
 		int set;
 
 		bmc_old = bitmap_get_counter(&old_counts, block,
-					     &old_blocks, 0);
+					     &old_blocks, 0, 0);
 		set = bmc_old && NEEDED(*bmc_old);
 
 		if (set) {
 			bmc_new = bitmap_get_counter(&bitmap->counts, block,
-						     &new_blocks, 1);
+						     &new_blocks, 1, 0);
 			if (*bmc_new == 0) {
 				/* need to set on-disk bits too. */
 				sector_t end = block + new_blocks;
@@ -2067,7 +2100,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		while (block < (chunks << chunkshift)) {
 			bitmap_counter_t *bmc;
 			bmc = bitmap_get_counter(&bitmap->counts, block,
-						 &new_blocks, 1);
+						 &new_blocks, 1, 0);
 			if (bmc) {
 				/* new space.  It needs to be resynced, so
 				 * we set NEEDED_MASK.
-- 
2.6.6

