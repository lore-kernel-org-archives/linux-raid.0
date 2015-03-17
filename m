From: jgq516@gmail.com
Subject: [PATCH 1/1] Make bm_blocks to match previous semantic
Date: Tue, 17 Mar 2015 10:40:30 +0800
Message-ID: <1426560030-16152-1-git-send-email-jgq516@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, rgoldwyn@suse.de
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

The bm_blocks is modified by commit fe60ce (md/bitmap: use
sector_div for sector_t divisions), but it makes bm_blocks
has different value which is changed from like "a/b" to "a%b",
need to correct this to make sure cluster-md still works.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
This is against for-next branch.

 drivers/md/bitmap.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 501f83f..ea9c685 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -571,11 +571,10 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 re_read:
 	/* If cluster_slot is set, the cluster is setup */
 	if (bitmap->cluster_slot >= 0) {
-		sector_t bm_blocks;
-		sector_t resync_sectors = bitmap->mddev->resync_max_sectors;
+		sector_t bm_blocks = bitmap->mddev->resync_max_sectors;
 
-		bm_blocks = sector_div(resync_sectors,
-				       bitmap->mddev->bitmap_info.chunksize >> 9);
+		sector_div(bm_blocks,
+				bitmap->mddev->bitmap_info.chunksize >> 9);
 		bm_blocks = bm_blocks << 3;
 		bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
 		bitmap->mddev->bitmap_info.offset += bitmap->cluster_slot * (bm_blocks << 3);
-- 
1.7.12.4

