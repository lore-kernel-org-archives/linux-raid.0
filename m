From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 08/16] md/bitmap: Rename a jump label in location_store()
Date: Tue, 27 Sep 2016 18:55:36 +0200
Message-ID: <d4de2fd9-93a6-9731-13a4-9b02a6c7f971@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <30938c84-20a7-0f13-bdda-a2d2109a6dac@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 27 Sep 2016 15:46:22 +0200

Adjust jump labels according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 41d99fd..22fa09a 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -2187,11 +2187,11 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 	if (mddev->pers) {
 		if (!mddev->pers->quiesce) {
 			rv = -EBUSY;
-			goto out;
+			goto unlock;
 		}
 		if (mddev->recovery || mddev->sync_thread) {
 			rv = -EBUSY;
-			goto out;
+			goto unlock;
 		}
 	}
 
@@ -2200,7 +2200,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 		/* bitmap already configured.  Only option is to clear it */
 		if (strncmp(buf, "none", 4) != 0) {
 			rv = -EBUSY;
-			goto out;
+			goto unlock;
 		}
 		if (mddev->pers) {
 			mddev->pers->quiesce(mddev, 1);
@@ -2221,23 +2221,23 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 		else if (strncmp(buf, "file:", 5) == 0) {
 			/* Not supported yet */
 			rv = -EINVAL;
-			goto out;
+			goto unlock;
 		} else {
 			if (buf[0] == '+')
 				rv = kstrtoll(buf+1, 10, &offset);
 			else
 				rv = kstrtoll(buf, 10, &offset);
 			if (rv)
-				goto out;
+				goto unlock;
 			if (offset == 0) {
 				rv = -EINVAL;
-				goto out;
+				goto unlock;
 			}
 			if (mddev->bitmap_info.external == 0 &&
 			    mddev->major_version == 0 &&
 			    offset != mddev->bitmap_info.default_offset) {
 				rv = -EINVAL;
-				goto out;
+				goto unlock;
 			}
 			mddev->bitmap_info.offset = offset;
 			if (mddev->pers) {
@@ -2255,7 +2255,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 				mddev->pers->quiesce(mddev, 0);
 				if (rv) {
 					bitmap_destroy(mddev);
-					goto out;
+					goto unlock;
 				}
 			}
 		}
@@ -2268,7 +2268,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 		md_wakeup_thread(mddev->thread);
 	}
 	rv = 0;
-out:
+unlock:
 	mddev_unlock(mddev);
 	if (rv)
 		return rv;
-- 
2.10.0

