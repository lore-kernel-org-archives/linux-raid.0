From: heinzm@redhat.com
Subject: [PATCH 3/3] md bitmap: export bitmap_destroy() to support dm-raid down takover to raid0
Date: Fri, 13 Feb 2015 19:48:02 +0100
Message-ID: <1423853282-6218-4-git-send-email-heinzm@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: linux-raid.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This patch exports symbol bitmap_destroy to allow dm-raid to remove
bitmaps when performing a down takeover to md raid0.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/bitmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 3a57679..b484d15 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1631,6 +1631,7 @@ void bitmap_destroy(struct mddev *mddev)
 
 	bitmap_free(bitmap);
 }
+EXPORT_SYMBOL_GPL(bitmap_destroy);
 
 /*
  * initialize the bitmap structure
-- 
2.1.0

