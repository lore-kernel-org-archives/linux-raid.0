From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 2/3] md/bitmap: remove redundant return in bitmap_checkpage
Date: Mon, 14 Mar 2016 17:01:38 +0800
Message-ID: <1457946099-1878-3-git-send-email-gqjiang@suse.com>
References: <1457946099-1878-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457946099-1878-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The "return 0" is not needed since bitmap_checkpage
will finally return 0 for the case.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/bitmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index bbe7b64..7df6b4f 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -98,7 +98,6 @@ __acquires(bitmap->lock)
 		   bitmap->bp[page].hijacked) {
 		/* somebody beat us to getting the page */
 		kfree(mappage);
-		return 0;
 	} else {
 
 		/* no page was in place and we have one, so install it */
-- 
2.6.2

