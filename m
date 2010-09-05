From: Kulikov Vasiliy <segooon@gmail.com>
Subject: [PATCH 03/14] md: check return code of read_sb_page
Date: Sun,  5 Sep 2010 22:32:25 +0400
Message-ID: <1283711546-7205-1-git-send-email-segooon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

From: Vasiliy Kulikov <segooon@gmail.com>

Function read_sb_page may return ERR_PTR(...). Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/md/bitmap.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index ed4900a..33531da 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -936,6 +936,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	int outofdate;
 	int ret = -ENOSPC;
 	void *paddr;
+	struct page *p;
 
 	chunks = bitmap->chunks;
 	file = bitmap->file;
@@ -999,11 +1000,16 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 				 */
 				page = bitmap->sb_page;
 				offset = sizeof(bitmap_super_t);
-				if (!file)
-					read_sb_page(bitmap->mddev,
+				if (!file) {
+					p = read_sb_page(bitmap->mddev,
 						     bitmap->mddev->bitmap_info.offset,
 						     page,
 						     index, count);
+					if (IS_ERR(p)) {
+						ret = PTR_ERR(p);
+						goto err;
+					}
+				}
 			} else if (file) {
 				page = read_page(file, index, bitmap, count);
 				offset = 0;
-- 
1.7.0.4
