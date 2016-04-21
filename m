From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 13/13] md-cluster/bitmap: unplug bitmap to sync dirty pages to disk
Date: Thu, 21 Apr 2016 13:58:14 +0800
Message-ID: <1461218294-4960-14-git-send-email-gqjiang@suse.com>
References: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

This patch is doing two distinct but related things.

1. It adds bitmap_unplug() for the main bitmap (mddev->bitmap).  As bit
have been set, BITMAP_PAGE_DIRTY is set so bitmap_deamon_work() will
not write those pages out in its regular scans, only bitmap_unplug()
will.  If there are no writes to the array, bitmap_unplug() won't be
called, so we need to call it explicitly here.

2. bitmap_write_all() is a bit of a confusing interface as it doesn't
actually write anything.  The current code for writing "bitmap" works
but this change makes it a bit clearer.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/bitmap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 08f4c04..9830dbf 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1921,14 +1921,14 @@ int bitmap_copy_from_slot(struct mddev *mddev, int slot,
 
 	if (clear_bits) {
 		bitmap_update_sb(bitmap);
-		/* Setting this for the ev_page should be enough.
-		 * And we do not require both write_all and PAGE_DIRT either
-		 */
+		/* BITMAP_PAGE_PENDING is set, but bitmap_unplug needs
+		 * BITMAP_PAGE_DIRTY or _NEEDWRITE to write ... */
 		for (i = 0; i < bitmap->storage.file_pages; i++)
-			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
-		bitmap_write_all(bitmap);
+			if (test_page_attr(bitmap, i, BITMAP_PAGE_PENDING))
+				set_page_attr(bitmap, i, BITMAP_PAGE_NEEDWRITE);
 		bitmap_unplug(bitmap);
 	}
+	bitmap_unplug(mddev->bitmap);
 	*low = lo;
 	*high = hi;
 err:
-- 
2.6.6

