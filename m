From: "majianpeng" <majianpeng@gmail.com>
Subject: md: Return proper err if d_path error in get_bitmap_file.
Date: Wed, 29 Feb 2012 09:47:13 +0800
Message-ID: <201202290947090008466@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From dd2c011a73a97b169e81bb6b8fc1b141a3812368 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Wed, 29 Feb 2012 09:32:29 +0800
Subject: [PATCH] md: Return proper err if d_path error in get_bitmap_file.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/md.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ce88755..f2085ee 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5427,8 +5427,10 @@ static int get_bitmap_file(struct mddev * mddev, void __user * arg)
 		goto out;
 
 	ptr = d_path(&mddev->bitmap->file->f_path, buf, sizeof(file->pathname));
-	if (IS_ERR(ptr))
+	if (IS_ERR(ptr)) {
+		err = PTR_ERR(ptr);
 		goto out;
+	}
 
 	strcpy(file->pathname, ptr);
 
-- 
1.7.5.4

 				
--------------
majianpeng
2012-02-29

