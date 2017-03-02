From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH v1] mdadm: add checking clustered bitmap in assemble mode
Date: Thu,  2 Mar 2017 11:25:57 +0800
Message-ID: <1488425157-24582-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Both clustered and internal array don't need to specify
--bitmap when assembling array.

Signed-off-by: Zhilong Liu <zlliu@suse.com>

diff --git a/mdadm.c b/mdadm.c
index b5d89e4..4087f77 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1095,8 +1095,10 @@ int main(int argc, char *argv[])
 				pr_err("bitmap file needed with -b in --assemble mode\n");
 				exit(2);
 			}
-			if (strcmp(optarg, "internal") == 0) {
-				pr_err("there is no need to specify --bitmap when assembling arrays with internal bitmaps\n");
+			if (strcmp(optarg, "internal") == 0 ||
+			    strcmp(optarg, "clustered") == 0) {
+				pr_err("no need to specify --bitmap when assembling
+					arrays with internal or clustered bitmap\n");
 				continue;
 			}
 			bitmap_fd = open(optarg, O_RDWR);
-- 
2.6.6

