From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm:reminded external bitmap only supports ext[2-4] filesystem
Date: Mon, 20 Mar 2017 13:20:47 +0800
Message-ID: <1489987247-22681-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

mdadm: ensure that the external bitmap_file is
stored by ext[2-4] file system, because bmap()
of linux/driver/md/bitmap.c only implements in
inode.c of ext[2-4]. it's better to make users
aware of this scenario and give a prompt.

steps:
zlliu:/home/liu/git-tree/mdadm # df -T /mnt/2
Filesystem     Type  1K-blocks     Used Available Use% Mounted on
/dev/sda5      btrfs 103078176 11110620  90902628  11% /

./mdadm -CR /dev/md0 -l1 -b /mnt/2 -n2 /dev/loop[0-1]

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Create.c |  5 -----
 mdadm.c  | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/Create.c b/Create.c
index 50ec85e..beec29f 100644
--- a/Create.c
+++ b/Create.c
@@ -827,11 +827,6 @@ int Create(struct supertype *st, char *mddev,
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
index fcb33d1..566051f 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1149,6 +1149,21 @@ int main(int argc, char *argv[])
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
2.6.6

