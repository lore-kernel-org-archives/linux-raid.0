From: lixiubo@cmss.chinamobile.com
Subject: [PATCH] bcache: Keep the labels the same in cache dev and cache set.
Date: Fri,  7 Apr 2017 14:26:22 +0800
Message-ID: <1491546382-17142-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kent.overstreet@gmail.com
Cc: inux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Xiubo Li <lixiubo@cmss.chinamobile.com>
List-Id: linux-raid.ids

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

Since the unusual characters from sysfs attributes have been stript
for dc superblock label, so should here.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/md/bcache/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index f90f136..d449f37 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -249,7 +249,7 @@
 		bch_write_bdev_super(dc, NULL);
 		if (dc->disk.c) {
 			memcpy(dc->disk.c->uuids[dc->disk.id].label,
-			       buf, SB_LABEL_SIZE);
+			       dc->sb.label, strlen(dc->sb.label));
 			bch_uuid_write(dc->disk.c);
 		}
 		env = kzalloc(sizeof(struct kobj_uevent_env), GFP_KERNEL);
-- 
1.8.3.1
