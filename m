From: shli@kernel.org
Subject: [PATCH 2/3] MD: hold mddev lock to change bitmap location
Date: Sat, 30 Jul 2016 16:54:39 -0700
Message-ID: <13390282c96961ddd675199c2826f36a44bfa8aa.1469922791.git.shli@fb.com>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
In-Reply-To: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

Changing the location changes a lot of things. Holding the lock to avoid race.
This makes the .quiesce called with mddev lock hold too.

Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/bitmap.c | 47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 6fff794..13041ee 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -2183,19 +2183,29 @@ location_show(struct mddev *mddev, char *page)
 static ssize_t
 location_store(struct mddev *mddev, const char *buf, size_t len)
 {
+	int rv;
 
+	rv = mddev_lock(mddev);
+	if (rv)
+		return rv;
 	if (mddev->pers) {
-		if (!mddev->pers->quiesce)
-			return -EBUSY;
-		if (mddev->recovery || mddev->sync_thread)
-			return -EBUSY;
+		if (!mddev->pers->quiesce) {
+			rv = -EBUSY;
+			goto out;
+		}
+		if (mddev->recovery || mddev->sync_thread) {
+			rv = -EBUSY;
+			goto out;
+		}
 	}
 
 	if (mddev->bitmap || mddev->bitmap_info.file ||
 	    mddev->bitmap_info.offset) {
 		/* bitmap already configured.  Only option is to clear it */
-		if (strncmp(buf, "none", 4) != 0)
-			return -EBUSY;
+		if (strncmp(buf, "none", 4) != 0) {
+			rv = -EBUSY;
+			goto out;
+		}
 		if (mddev->pers) {
 			mddev->pers->quiesce(mddev, 1);
 			bitmap_destroy(mddev);
@@ -2214,21 +2224,25 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			/* nothing to be done */;
 		else if (strncmp(buf, "file:", 5) == 0) {
 			/* Not supported yet */
-			return -EINVAL;
+			rv = -EINVAL;
+			goto out;
 		} else {
-			int rv;
 			if (buf[0] == '+')
 				rv = kstrtoll(buf+1, 10, &offset);
 			else
 				rv = kstrtoll(buf, 10, &offset);
 			if (rv)
-				return rv;
-			if (offset == 0)
-				return -EINVAL;
+				goto out;
+			if (offset == 0) {
+				rv = -EINVAL;
+				goto out;
+			}
 			if (mddev->bitmap_info.external == 0 &&
 			    mddev->major_version == 0 &&
-			    offset != mddev->bitmap_info.default_offset)
-				return -EINVAL;
+			    offset != mddev->bitmap_info.default_offset) {
+				rv = -EINVAL;
+				goto out;
+			}
 			mddev->bitmap_info.offset = offset;
 			if (mddev->pers) {
 				struct bitmap *bitmap;
@@ -2245,7 +2259,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 				mddev->pers->quiesce(mddev, 0);
 				if (rv) {
 					bitmap_destroy(mddev);
-					return rv;
+					goto out;
 				}
 			}
 		}
@@ -2257,6 +2271,11 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		md_wakeup_thread(mddev->thread);
 	}
+	rv = 0;
+out:
+	mddev_unlock(mddev);
+	if (rv)
+		return rv;
 	return len;
 }
 
-- 
2.7.4

