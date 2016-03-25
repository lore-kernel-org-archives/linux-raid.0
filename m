From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] md/bitmap: call bitmap_destroy in case bitmap_create failed
Date: Fri, 25 Mar 2016 19:00:14 +0800
Message-ID: <1458903614-21498-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

If bitmap_create returns an error, bitmap_destroy must be
called to do clean up.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/bitmap.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 7df6b4f..ba908e7 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1865,8 +1865,10 @@ int bitmap_copy_from_slot(struct mddev *mddev, int slot,
 	struct bitmap_counts *counts;
 	struct bitmap *bitmap = bitmap_create(mddev, slot);
 
-	if (IS_ERR(bitmap))
+	if (IS_ERR(bitmap)) {
+		bitmap_destroy(mddev);
 		return PTR_ERR(bitmap);
+	}
 
 	rv = bitmap_init_from_disk(bitmap, 0);
 	if (rv)
@@ -1898,7 +1900,7 @@ int bitmap_copy_from_slot(struct mddev *mddev, int slot,
 	*low = lo;
 	*high = hi;
 err:
-	bitmap_free(bitmap);
+	bitmap_destroy(mddev);
 	return rv;
 }
 EXPORT_SYMBOL_GPL(bitmap_copy_from_slot);
@@ -2170,14 +2172,14 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
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
2.1.4

