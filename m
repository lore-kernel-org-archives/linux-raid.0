From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 11/13] md-cluster/bitmap: fix wrong calcuation of offset
Date: Thu, 21 Apr 2016 13:58:12 +0800
Message-ID: <1461218294-4960-12-git-send-email-gqjiang@suse.com>
References: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The offset is wrong in bitmap_storage_alloc, we should
set it like below in bitmap_init_from_disk().

node_offset = bitmap->cluster_slot * (DIV_ROUND_UP(store->bytes, PAGE_SIZE));

Because 'offset' is only assigned to 'page->index' and
that is usually over-written by read_sb_page. So it does
not cause problem in general, but it still need to be fixed.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 2e198f3..bdae67a 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -759,7 +759,7 @@ static int bitmap_storage_alloc(struct bitmap_storage *store,
 		bytes += sizeof(bitmap_super_t);
 
 	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
-	offset = slot_number * (num_pages - 1);
+	offset = slot_number * num_pages;
 
 	store->filemap = kmalloc(sizeof(struct page *)
 				 * num_pages, GFP_KERNEL);
-- 
2.6.6

