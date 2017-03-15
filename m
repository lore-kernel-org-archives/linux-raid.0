From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] md:fix a trivial typo in comments
Date: Wed, 15 Mar 2017 16:14:53 +0800
Message-ID: <1489565693-12595-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

bitmap.c: fix a trivial typo in comments of bitmap_read_sb().

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 drivers/md/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9fb2cca..af9e0f0 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -696,7 +696,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 
 out:
 	kunmap_atomic(sb);
-	/* Assiging chunksize is required for "re_read" */
+	/* Assigning chunksize is required for "re_read" */
 	bitmap->mddev->bitmap_info.chunksize = chunksize;
 	if (err == 0 && nodes && (bitmap->cluster_slot < 0)) {
 		err = md_setup_cluster(bitmap->mddev, nodes);
-- 
2.6.6

