From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] md: fix incorrect use of lexx_to_cpu in does_sb_need_changing
Date: Fri, 10 Mar 2017 11:49:12 +0800
Message-ID: <1489117752-23907-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, linux-raid@vger.kernel.org
Cc: miaoxie@huawei.com, zhaohongjiang@huawei.com, Jason Yan <yanaijie@huawei.com>
List-Id: linux-raid.ids

The sb->layout is of type __le32, so we shoud use le32_to_cpu.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e0d4d13..ea86a89 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2287,7 +2287,7 @@ static bool does_sb_need_changing(struct mddev *mddev)
 	/* Check if any mddev parameters have changed */
 	if ((mddev->dev_sectors != le64_to_cpu(sb->size)) ||
 	    (mddev->reshape_position != le64_to_cpu(sb->reshape_position)) ||
-	    (mddev->layout != le64_to_cpu(sb->layout)) ||
+	    (mddev->layout != le32_to_cpu(sb->layout)) ||
 	    (mddev->raid_disks != le32_to_cpu(sb->raid_disks)) ||
 	    (mddev->chunk_sectors != le32_to_cpu(sb->chunksize)))
 		return true;
-- 
2.5.0

