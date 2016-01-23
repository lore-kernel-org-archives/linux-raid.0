From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/2] md-cluster: delete useless code
Date: Fri, 22 Jan 2016 16:45:43 -0800
Message-ID: <688b654fe7566f182d6f4fdae2c3a3242d32a179.1453509823.git.shli@fb.com>
References: <0bc7fe7dece2c5aa4f8ed7194df27b02e0ae3142.1453509823.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0bc7fe7dece2c5aa4f8ed7194df27b02e0ae3142.1453509823.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>, Guoqing Jiang <gqjiang@suse.com>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

page->index already considers node offset. The node_offset calculation
in write_sb_page is useless and confusion.

Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Guoqing Jiang <gqjiang@suse.com>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/bitmap.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 4f22e91..d80cce4 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -210,10 +210,6 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
 	struct bitmap_storage *store = &bitmap->storage;
-	int node_offset = 0;
-
-	if (mddev_is_clustered(bitmap->mddev))
-		node_offset = bitmap->cluster_slot * store->file_pages;
 
 	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
 		int size = PAGE_SIZE;
-- 
2.4.6

