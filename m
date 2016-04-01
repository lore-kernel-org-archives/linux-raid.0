From: Guoqing Jiang <gqjiang@suse.com>
Subject: [V2 PATCH] md/bitmap: clear bitmap if bitmap_create failed
Date: Fri,  1 Apr 2016 17:08:49 +0800
Message-ID: <1459501729-19224-1-git-send-email-gqjiang@suse.com>
References: <1458903614-21498-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1458903614-21498-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.com, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

If bitmap_create returns an error, we need to call
either bitmap_destroy or bitmap_free to do clean up,
and the selection is based on mddev->bitmap is set
or not.

And the sysfs_put(bitmap->sysfs_can_clear) is moved
from bitmap_destroy to bitmap_free, and the comment
of bitmap_create is changed as well.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/bitmap.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index a624792..062ac99 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1697,6 +1697,9 @@ static void bitmap_free(struct bitmap *bitmap)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
+	if (bitmap->sysfs_can_clear)
+		sysfs_put(bitmap->sysfs_can_clear);
+
 	if (mddev_is_clustered(bitmap->mddev) && bitmap->mddev->cluster_info &&
 		bitmap->cluster_slot == md_cluster_ops->slot_number(bitmap->mddev))
 		md_cluster_stop(bitmap->mddev);
@@ -1736,15 +1739,13 @@ void bitmap_destroy(struct mddev *mddev)
 	if (mddev->thread)
 		mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
 
-	if (bitmap->sysfs_can_clear)
-		sysfs_put(bitmap->sysfs_can_clear);
-
 	bitmap_free(bitmap);
 }
 
 /*
  * initialize the bitmap structure
  * if this returns an error, bitmap_destroy must be called to do clean up
+ * once mddev->bitmap is set
  */
 struct bitmap *bitmap_create(struct mddev *mddev, int slot)
 {
@@ -1889,8 +1890,10 @@ int bitmap_copy_from_slot(struct mddev *mddev, int slot,
 	struct bitmap_counts *counts;
 	struct bitmap *bitmap = bitmap_create(mddev, slot);
 
-	if (IS_ERR(bitmap))
+	if (IS_ERR(bitmap)) {
+		bitmap_free(bitmap);
 		return PTR_ERR(bitmap);
+	}
 
 	rv = bitmap_init_from_disk(bitmap, 0);
 	if (rv)
@@ -2223,14 +2226,14 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 				else {
 					mddev->bitmap = bitmap;
 					rv = bitmap_load(mddev);
-					if (rv) {
-						bitmap_destroy(mddev);
+					if (rv)
 						mddev->bitmap_info.offset = 0;
-					}
 				}
 				mddev->pers->quiesce(mddev, 0);
-				if (rv)
+				if (rv) {
+					bitmap_destroy(mddev);
 					return rv;
+				}
 			}
 		}
 	}
-- 
2.6.2

