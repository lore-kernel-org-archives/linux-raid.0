From: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] md: fix return value of rdev_size_change()
Date: Thu, 11 Nov 2010 20:25:17 +0000
Message-ID: <4cdc55d1.4800e70a.1ffa.6729@mx.google.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

When trying to grow an array by enlarging component devices, rdev_size_store()
expects the return value of rdev_size_change() to be in sectors, but the actual
value is returned in KBs.

Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
---
 drivers/md/md.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e957f3..a0615af 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1337,7 +1337,7 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-	return num_sectors / 2; /* kB for sysfs */
+	return num_sectors;
 }
 
 
@@ -1704,7 +1704,7 @@ super_1_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-	return num_sectors / 2; /* kB for sysfs */
+	return num_sectors;
 }
 
 static struct super_type super_types[] = {
-- 
1.7.1

