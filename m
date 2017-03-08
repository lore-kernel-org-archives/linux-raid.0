From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 1/4] mdadm:bitmap cannot be set twice
Date: Wed,  8 Mar 2017 15:50:59 +0800
Message-ID: <20170308075059.24789-1-zlliu@suse.com>
References: <20170308074831.24683-1-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170308074831.24683-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

mdadm:it doesn't make sense to set bitmap twice.

Signed-off-by: Zhilong Liu <zlliu@suse.com>

diff --git a/mdadm.c b/mdadm.c
index b5ac061..eb9a4e9 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1137,6 +1137,10 @@ int main(int argc, char *argv[])
 		case O(CREATE,Bitmap): /* here we create the bitmap */
 		case O(GROW,'b'):
 		case O(GROW,Bitmap):
+			if (s.bitmap_file) {
+				pr_err("bitmap cannot be set twice. Second value: %s.\n", optarg);
+				exit(2);
+			}
 			if (strcmp(optarg, "internal") == 0 ||
 			    strcmp(optarg, "none") == 0 ||
 			    strchr(optarg, '/') != NULL) {
-- 
2.10.2

