From: Xiao Ni <xni@redhat.com>
Subject: [PATCH 1/2] super1.0 calculates max sectors in a wrong way
Date: Tue, 30 Jun 2020 15:55:36 +0800
Message-ID: <1593503737-5067-2-git-send-email-xni@redhat.com>
References: <1593503737-5067-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1593503737-5067-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, ncroxon@redhat.com
List-Id: linux-raid.ids

One super1.0 raid array wants to grow size, it needs to check the device max usable
size. If the requested size is bigger than max usable size, it will return an error.

Now it uses rdev->sectors for max usable size. If one disk is 500G and the raid device
only uses the 100GB of this disk. rdev->sectors can't tell the real max usable size.
The max usable size should be dev_size-(superblock_size+bitmap_size+badblock_size).

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f567f53..d2c5984 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2183,10 +2183,30 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 		return 0;
 	} else {
 		/* minor version 0; superblock after data */
-		sector_t sb_start;
-		sb_start = (i_size_read(rdev->bdev->bd_inode) >> 9) - 8*2;
+		sector_t sb_start, bm_space;
+		sector_t dev_size = i_size_read(rdev->bdev->bd_inode) >> 9;
+
+		/* 8K is for superblock */
+		sb_start = dev_size - 8*2;
 		sb_start &= ~(sector_t)(4*2 - 1);
-		max_sectors = rdev->sectors + sb_start - rdev->sb_start;
+
+		/* if the device is bigger than 8Gig, save 64k for bitmap usage,
+		 * if bigger than 200Gig, save 128k
+		 */
+		if (dev_size < 64*2)
+			bm_space = 0;
+		else if (dev_size - 64*2 >= 200*1024*1024*2)
+			bm_space = 128*2;
+		else if (dev_size - 4*2 > 8*1024*1024*2)
+			bm_space = 64*2;
+		else
+			bm_space = 4*2;
+
+		/* Space that can be used to store date needs to decrease superblock
+		 * bitmap space and bad block space(4K)
+		 */
+		max_sectors = sb_start - bm_space - 4*2;
+
 		if (!num_sectors || num_sectors > max_sectors)
 			num_sectors = max_sectors;
 		rdev->sb_start = sb_start;
-- 
2.7.5
