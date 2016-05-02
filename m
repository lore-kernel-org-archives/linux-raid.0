From: Guoqing Jiang <gqjiang@suse.com>
Subject: [V2 PATCH 08/13] md-cluster: always setup in-memory bitmap
Date: Mon,  2 May 2016 11:50:11 -0400
Message-ID: <1462204216-2269-1-git-send-email-gqjiang@suse.com>
References: <1462203200-1375-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1462203200-1375-1-git-send-email-gqjiang@suse.com>
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
 drivers/md/bitmap.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 3fe86b5..431da21 100644
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
@@ -1321,7 +1324,7 @@ __acquires(bitmap->lock)
 	sector_t csize;
 	int err;
 
-	err = bitmap_checkpage(bitmap, page, create);
+	err = bitmap_checkpage(bitmap, page, create, 0);
 
 	if (bitmap->bp[page].hijacked ||
 	    bitmap->bp[page].map == NULL)
@@ -2032,6 +2035,36 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
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
-- 
2.6.6

