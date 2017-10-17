From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 4/5] md: use mddev_suspend/resume instead of ->quiesce()
Date: Tue, 17 Oct 2017 13:46:43 +1100
Message-ID: <150820840353.1646.9951955640818765437.stgit@noble>
References: <150820826980.1646.6380214598725492144.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150820826980.1646.6380214598725492144.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mddev_suspend() is a more general interface than
calling ->quiesce() and is so more extensible.  A
future patch will make use of this.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f8d0e41120cb..60a5022bd9bb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4864,8 +4864,8 @@ suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->pers->quiesce(mddev, 2);
 	} else {
 		/* Expanding suspended region - need to wait */
-		mddev->pers->quiesce(mddev, 1);
-		mddev->pers->quiesce(mddev, 0);
+		mddev_suspend(mddev);
+		mddev_resume(mddev);
 	}
 	err = 0;
 unlock:
@@ -4908,8 +4908,8 @@ suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->pers->quiesce(mddev, 2);
 	} else {
 		/* Expanding suspended region - need to wait */
-		mddev->pers->quiesce(mddev, 1);
-		mddev->pers->quiesce(mddev, 0);
+		mddev_suspend(mddev);
+		mddev_resume(mddev);
 	}
 	err = 0;
 unlock:
@@ -6640,7 +6640,7 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 			struct bitmap *bitmap;
 
 			bitmap = bitmap_create(mddev, -1);
-			mddev->pers->quiesce(mddev, 1);
+			mddev_suspend(mddev);
 			if (!IS_ERR(bitmap)) {
 				mddev->bitmap = bitmap;
 				err = bitmap_load(mddev);
@@ -6650,11 +6650,11 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 				bitmap_destroy(mddev);
 				fd = -1;
 			}
-			mddev->pers->quiesce(mddev, 0);
+			mddev_resume(mddev);
 		} else if (fd < 0) {
-			mddev->pers->quiesce(mddev, 1);
+			mddev_suspend(mddev);
 			bitmap_destroy(mddev);
-			mddev->pers->quiesce(mddev, 0);
+			mddev_resume(mddev);
 		}
 	}
 	if (fd < 0) {
@@ -6940,7 +6940,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
 			bitmap = bitmap_create(mddev, -1);
-			mddev->pers->quiesce(mddev, 1);
+			mddev_suspend(mddev);
 			if (!IS_ERR(bitmap)) {
 				mddev->bitmap = bitmap;
 				rv = bitmap_load(mddev);
@@ -6948,7 +6948,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				rv = PTR_ERR(bitmap);
 			if (rv)
 				bitmap_destroy(mddev);
-			mddev->pers->quiesce(mddev, 0);
+			mddev_resume(mddev);
 		} else {
 			/* remove the bitmap */
 			if (!mddev->bitmap) {
@@ -6971,9 +6971,9 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.nodes = 0;
 				md_cluster_ops->leave(mddev);
 			}
-			mddev->pers->quiesce(mddev, 1);
+			mddev_suspend(mddev);
 			bitmap_destroy(mddev);
-			mddev->pers->quiesce(mddev, 0);
+			mddev_resume(mddev);
 			mddev->bitmap_info.offset = 0;
 		}
 	}


