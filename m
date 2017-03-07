From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH v2] mdadm:add checking clustered bitmap in assemble mode
Date: Tue,  7 Mar 2017 11:13:03 +0800
Message-ID: <20170307031303.3009-1-zlliu@suse.com>
References: <wrfjzigyks66.fsf@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjzigyks66.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

mdadm:Both clustered and internal array don't need
to specify --bitmap when assembling array.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
Acked-by: Coly Li <colyli@suse.de>

diff --git a/mdadm.c b/mdadm.c
index b5ac061..d6ad8dc 100644
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
+				pr_err("no need to specify --bitmap when assembling"
+					" arrays with internal or clustered bitmap\n");
 				continue;
 			}
 			bitmap_fd = open(optarg, O_RDWR);
-- 
2.10.2

