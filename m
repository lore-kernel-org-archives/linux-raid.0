From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 4/5] md: flush md_rdev_misc_wq for HOT_ADD_DISK case
Date: Sat,  4 Apr 2020 23:57:10 +0200
Message-ID: <20200404215711.4272-5-guoqing.jiang@cloud.ionos.com>
References: <20200404215711.4272-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200404215711.4272-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

Since rdev->kobj is removed asynchronously, it is possible that the
rdev->kobj still exists when try to add the rdev again after rdev
is removed. But this path md_ioctl (HOT_ADD_DISK) -> hot_add_disk
-> bind_rdev_to_array missed it.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b4ea0f38ccd8..2bd2d91f2015 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7511,7 +7511,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 
 	}
 
-	if (cmd == ADD_NEW_DISK)
+	if (cmd == ADD_NEW_DISK || cmd == HOT_ADD_DISK)
 		flush_rdev_wq(mddev);
 
 	if (cmd == HOT_REMOVE_DISK)
-- 
2.17.1
