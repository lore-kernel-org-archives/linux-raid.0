From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 5 of 8 - Handle hot-add for arrays with non-persistent superblocks
Date: Fri, 28 May 2004 16:45:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BTb7N-0002Ts-E2@notabene.cse.unsw.edu.au>
References: <20040528163700.9426.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



If the superblock isn't persistent, we shouldn't allow
room for it.

From: Paul Clements <Paul.Clements@SteelEye.com>
Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-05-28 15:48:47.000000000 +1000
+++ ./drivers/md/md.c	2004-05-28 15:49:25.000000000 +1000
@@ -2285,7 +2285,12 @@ static int hot_add_disk(mddev_t * mddev,
 		return -EINVAL;
 	}
 
-	rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
+	if (mddev->persistent)
+		rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
+	else
+		rdev->sb_offset =
+			rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
+
 	size = calc_dev_size(rdev, mddev->chunk_size);
 	rdev->size = size;
 
