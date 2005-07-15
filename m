From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md ] md/raid1: clear bitmap when fullsync completes
Date: Fri, 15 Jul 2005 14:21:40 +1000
Message-ID: <E1DtHhk-0004zS-Qo@notabene.cse.unsw.edu.au>
References: <20050715141642.19145.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch against 2.6.13-rc2-mm2 fixes a slightly obscure problem
with the bitmap resync code.  With this it should be quite reliable
(still room for more testing though).

It would be good for this to get into 2.6.13.

Thanks,
NeilBrown


### Comments for Changeset

We need to be careful differentiating between a resync of a complete array,
in which we can clear the bitmap, and a resync of a degraded array,
in which we cannot.

This patch cleans all that up.

Cc: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c         |    9 ++++++---
 ./drivers/md/raid1.c          |   34 ++++++++++++++++------------------
 ./include/linux/raid/bitmap.h |    2 +-
 3 files changed, 23 insertions(+), 22 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-07-15 13:57:39.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-07-15 13:57:39.000000000 +1000
@@ -1345,7 +1345,8 @@ void bitmap_endwrite(struct bitmap *bitm
 	}
 }
 
-int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks)
+int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks,
+			int degraded)
 {
 	bitmap_counter_t *bmc;
 	int rv;
@@ -1362,8 +1363,10 @@ int bitmap_start_sync(struct bitmap *bit
 			rv = 1;
 		else if (NEEDED(*bmc)) {
 			rv = 1;
-			*bmc |= RESYNC_MASK;
-			*bmc &= ~NEEDED_MASK;
+			if (!degraded) { /* don't set/clear bits if degraded */
+				*bmc |= RESYNC_MASK;
+				*bmc &= ~NEEDED_MASK;
+			}
 		}
 	}
 	spin_unlock_irq(&bitmap->lock);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-07-15 13:57:39.000000000 +1000
+++ ./drivers/md/raid1.c	2005-07-15 13:57:39.000000000 +1000
@@ -1126,21 +1126,19 @@ static sector_t sync_request(mddev_t *md
 		 * only be one in raid1 resync.
 		 * We can find the current addess in mddev->curr_resync
 		 */
-		if (!conf->fullsync) {
-			if (mddev->curr_resync < max_sector)
-				bitmap_end_sync(mddev->bitmap,
-						mddev->curr_resync,
+		if (mddev->curr_resync < max_sector) /* aborted */
+			bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
 						&sync_blocks, 1);
-			bitmap_close_sync(mddev->bitmap);
-		}
-		if (mddev->curr_resync >= max_sector)
+		else /* completed sync */
 			conf->fullsync = 0;
+
+		bitmap_close_sync(mddev->bitmap);
 		close_sync(conf);
 		return 0;
 	}
 
-	if (!conf->fullsync &&
-	    !bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks)) {
+	if (!bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, mddev->degraded) &&
+	    !conf->fullsync) {
 		/* We can skip this block, and probably several more */
 		*skipped = 1;
 		return sync_blocks;
@@ -1243,15 +1241,15 @@ static sector_t sync_request(mddev_t *md
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
 			break;
-		if (!conf->fullsync) {
-			if (sync_blocks == 0) {
-				if (!bitmap_start_sync(mddev->bitmap,
-						       sector_nr, &sync_blocks))
-					break;
-				if (sync_blocks < (PAGE_SIZE>>9))
-					BUG();
-				if (len > (sync_blocks<<9)) len = sync_blocks<<9;
-			}
+		if (sync_blocks == 0) {
+			if (!bitmap_start_sync(mddev->bitmap, sector_nr,
+					       &sync_blocks,
+					       mddev->degraded)
+			    && !conf->fullsync)
+				break;
+			if (sync_blocks < (PAGE_SIZE>>9))
+				BUG();
+			if (len > (sync_blocks<<9)) len = sync_blocks<<9;
 		}
 
 		for (i=0 ; i < conf->raid_disks; i++) {

diff ./include/linux/raid/bitmap.h~current~ ./include/linux/raid/bitmap.h
--- ./include/linux/raid/bitmap.h~current~	2005-07-15 13:57:39.000000000 +1000
+++ ./include/linux/raid/bitmap.h	2005-07-15 13:57:39.000000000 +1000
@@ -262,7 +262,7 @@ void bitmap_write_all(struct bitmap *bit
 int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors);
 void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors,
 		     int success);
-int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks);
+int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int degraded);
 void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int aborted);
 void bitmap_close_sync(struct bitmap *bitmap);
 
