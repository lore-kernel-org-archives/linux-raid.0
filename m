From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] md.c:didn't unlock the mddev before return EINVAL in array_size_store
Date: Mon, 10 Apr 2017 14:15:55 +0800
Message-ID: <1491804955-7548-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

md.c: it needs to release the mddev lock before
the array_size_store() returns.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f6ae1d6..5327236 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4843,8 +4843,10 @@ array_size_store(struct mddev *mddev, const char *buf, size_t len)
 		return err;
 
 	/* cluster raid doesn't support change array_sectors */
-	if (mddev_is_clustered(mddev))
+	if (mddev_is_clustered(mddev)) {
+		mddev_unlock(mddev);
 		return -EINVAL;
+	}
 
 	if (strncmp(buf, "default", 7) == 0) {
 		if (mddev->pers)
-- 
2.6.6

