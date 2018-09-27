From: Jack Wang <xjtuwjp@gmail.com>
Subject: [PATCH] md/bitmap: use mddev_suspend/resume instead of ->quiesce()
Date: Thu, 27 Sep 2018 10:07:57 +0200
Message-ID: <1538035677-20770-1-git-send-email-jinpuwang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shli@kernel.org, neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

From: Jack Wang <jinpu.wang@profitbricks.com>

After 9e1cc0a54556 ("md: use mddev_suspend/resume instead of ->quiesce()")
We still have similar left in bitmap functions.

Replace quiesce() with mddev_suspend/resume.

Also move md_bitmap_create out of mddev_suspend. and move mddev_resume
after md_bitmap_destroy. as we did in set_bitmap_file.

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
Reviewed-by: Gioh Kim <gi-oh.kim@profitbricks.com>

---
v2->v1: add reviewed-by.
---
 drivers/md/md-bitmap.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 2fc8c113977f..c369f1753ea6 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2123,7 +2123,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	}
 
 	if (!init)
-		bitmap->mddev->pers->quiesce(bitmap->mddev, 1);
+		mddev_suspend(bitmap->mddev);
 
 	store.file = bitmap->storage.file;
 	bitmap->storage.file = NULL;
@@ -2239,7 +2239,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 
 	if (!init) {
 		md_bitmap_unplug(bitmap);
-		bitmap->mddev->pers->quiesce(bitmap->mddev, 0);
+		mddev_resume(bitmap->mddev);
 	}
 	ret = 0;
 err:
@@ -2288,9 +2288,9 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			goto out;
 		}
 		if (mddev->pers) {
-			mddev->pers->quiesce(mddev, 1);
+			mddev_suspend(mddev);
 			md_bitmap_destroy(mddev);
-			mddev->pers->quiesce(mddev, 0);
+			mddev_resume(mddev);
 		}
 		mddev->bitmap_info.offset = 0;
 		if (mddev->bitmap_info.file) {
@@ -2327,8 +2327,8 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			mddev->bitmap_info.offset = offset;
 			if (mddev->pers) {
 				struct bitmap *bitmap;
-				mddev->pers->quiesce(mddev, 1);
 				bitmap = md_bitmap_create(mddev, -1);
+				mddev_suspend(mddev);
 				if (IS_ERR(bitmap))
 					rv = PTR_ERR(bitmap);
 				else {
@@ -2337,11 +2337,12 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 					if (rv)
 						mddev->bitmap_info.offset = 0;
 				}
-				mddev->pers->quiesce(mddev, 0);
 				if (rv) {
 					md_bitmap_destroy(mddev);
+					mddev_resume(mddev);
 					goto out;
 				}
+				mddev_resume(mddev);
 			}
 		}
 	}
-- 
2.7.4
