From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 2/4] mdadm:external bitmap only supports ext filesystem
Date: Wed,  8 Mar 2017 15:51:44 +0800
Message-ID: <20170308075144.24873-1-zlliu@suse.com>
References: <20170308074831.24683-1-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170308074831.24683-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

mdadm: ensure that the external bitmap_file is
stored by ext[2-4] file system, because bmap()
of linux/driver/md/bitmap.c exits directly when
the bitmap_file isn't suitable. mdadm should make
users aware of this scenario and give a prompt.

Signed-off-by: Zhilong Liu <zlliu@suse.com>

diff --git a/Create.c b/Create.c
index 2721884..9a951b0 100644
--- a/Create.c
+++ b/Create.c
@@ -831,11 +831,6 @@ int Create(struct supertype *st, char *mddev,
 			goto abort_locked;
 		}
 		bitmap_fd = open(s->bitmap_file, O_RDWR);
-		if (bitmap_fd < 0) {
-			pr_err("weird: %s cannot be openned\n",
-				s->bitmap_file);
-			goto abort_locked;
-		}
 		if (ioctl(mdfd, SET_BITMAP_FILE, bitmap_fd) < 0) {
 			pr_err("Cannot set bitmap file for %s: %s\n",
 				mddev, strerror(errno));
diff --git a/mdadm.c b/mdadm.c
index d6ad8dc..19a06db 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -28,6 +28,7 @@
 #include "mdadm.h"
 #include "md_p.h"
 #include <ctype.h>
+#include <sys/vfs.h>
 
 static int scan_assemble(struct supertype *ss,
 			 struct context *c,
@@ -1143,6 +1144,21 @@ int main(int argc, char *argv[])
 			    strcmp(optarg, "none") == 0 ||
 			    strchr(optarg, '/') != NULL) {
 				s.bitmap_file = optarg;
+				if (strchr(s.bitmap_file, '/') != NULL) {
+					bitmap_fd = open(s.bitmap_file, O_RDWR);
+					if (bitmap_fd < 0) {
+						pr_err("weird: %s cannot be openned\n", s.bitmap_file);
+						exit(2);
+					}
+					close(bitmap_fd);
+					struct statfs ext_bitmap;
+					statfs(s.bitmap_file, &ext_bitmap);
+					if (ext_bitmap.f_type != 0xEF53){
+						pr_err("external bitmap only supports ext[2-4] filesystem, %s.\n",
+							s.bitmap_file);
+						exit(2);
+					}
+				}
 				continue;
 			}
 			if (strcmp(optarg, "clustered") == 0) {
-- 
2.10.2

