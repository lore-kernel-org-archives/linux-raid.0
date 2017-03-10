From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] md: fix super_offset endianness in super_1_rdev_size_change
Date: Fri, 10 Mar 2017 11:27:23 +0800
Message-ID: <1489116443-16195-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, linux-raid@vger.kernel.org
Cc: miaoxie@huawei.com, zhaohongjiang@huawei.com, Jason Yan <yanaijie@huawei.com>
List-Id: linux-raid.ids

The sb->super_offset should be big-endian, but the rdev->sb_start is in
host byte order, so fix this by adding cpu_to_le64.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 548d1b8..b6516f8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1887,7 +1887,7 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	}
 	sb = page_address(rdev->sb_page);
 	sb->data_size = cpu_to_le64(num_sectors);
-	sb->super_offset = rdev->sb_start;
+	sb->super_offset = cpu_to_le64(rdev->sb_start);
 	sb->sb_csum = calc_sb_1_csum(sb);
 	do {
 		md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
-- 
2.5.0

