From: "kedacomkernel" <kedacomkernel@gmail.com>
Subject: md: Use existed macro instead of number
Date: Fri, 24 Feb 2012 15:00:21 +0800
Message-ID: <201202241500185468624@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From d5905ed3c5355a13e954057856733f8ad64a86ac Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Fri, 24 Feb 2012 22:49:45 +0800
Subject: [PATCH] md: Use existed macro instead of number


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 include/linux/raid/md_p.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
index 6f6df86..7c3577c 100644
--- a/include/linux/raid/md_p.h
+++ b/include/linux/raid/md_p.h
@@ -281,6 +281,8 @@ struct mdp_superblock_1 {
 					    * active device with same 'role'.
 					    * 'recovery_offset' is also set.
 					    */
-#define	MD_FEATURE_ALL			(1|2|4|8|16)
-
+#define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET | MD_FEATURE_RECOVERY_OFFSET | \
+					MD_FEATURE_RESHAPE_ACTIVE | MD_FEATURE_BAD_BLOCKS | \
+					MD_FEATURE_REPLACEMENT)
+
 #endif 
-- 
1.7.5.4

 				
--------------
kedacomkernel
2012-02-24

