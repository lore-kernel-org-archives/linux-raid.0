From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm:it doesn't make sense to set --bitmap twice
Date: Mon, 20 Mar 2017 13:21:03 +0800
Message-ID: <1489987263-22735-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

mdadm.c: it doesn't make sense to set --bitmap twice.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdadm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mdadm.c b/mdadm.c
index 566051f..2d8498f 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1145,6 +1145,10 @@ int main(int argc, char *argv[])
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
2.6.6

