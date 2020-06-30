From: Xiao Ni <xni@redhat.com>
Subject: [PATCH 2/2] Don't need to reset superblock start address for super1.0
Date: Tue, 30 Jun 2020 15:55:37 +0800
Message-ID: <1593503737-5067-3-git-send-email-xni@redhat.com>
References: <1593503737-5067-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1593503737-5067-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, ncroxon@redhat.com
List-Id: linux-raid.ids

The superblock start address doesn't change after creating raid device. It always at the end
of the device(end_pos-8*2).

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d2c5984..9de9c0e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2209,7 +2209,6 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 
 		if (!num_sectors || num_sectors > max_sectors)
 			num_sectors = max_sectors;
-		rdev->sb_start = sb_start;
 	}
 	sb = page_address(rdev->sb_page);
 	sb->data_size = cpu_to_le64(num_sectors);
-- 
2.7.5
