From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm: add checking the clustered bitmap in assemble mode
Date: Wed,  1 Mar 2017 15:47:49 +0800
Message-ID: <1488354469-19137-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

1. both clustered and internal array don't need to specify
--bitmap when assembling array.
2. clustered array doesn't support external bitmap mode.

Signed-off-by: Zhilong Liu <zlliu@suse.com>

diff --git a/mdadm.c b/mdadm.c
index b5d89e4..b08cace 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1095,8 +1095,14 @@ int main(int argc, char *argv[])
 				pr_err("bitmap file needed with -b in --assemble mode\n");
 				exit(2);
 			}
-			if (strcmp(optarg, "internal") == 0) {
-				pr_err("there is no need to specify --bitmap when assembling arrays with internal bitmaps\n");
+			if (strcmp(optarg, "internal") == 0 ||
+			    strcmp(optarg, "clustered") == 0) {
+				pr_err("no need to specify --bitmap when assembling arrays with internal or clustered bitmaps\n");
+				continue;
+			}
+			if (strcmp(optarg, "clustered") == 0 &&
+			    strchr(optarg, '/') != NULL) {
+				pr_err("clustered array doesn't support external bitmap\n");
 				continue;
 			}
 			bitmap_fd = open(optarg, O_RDWR);
-- 
2.6.6

