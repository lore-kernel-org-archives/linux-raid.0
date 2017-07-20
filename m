From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm/bitmap: regular file descriptor is omissive in bitmap_file_open
Date: Thu, 20 Jul 2017 15:11:57 +0800
Message-ID: <1500534717-14088-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

External bitmap supports to store bitmap in a regular file,
bitmap_file_open() also supports to return the regular file
descriptor.
This commit is partial revert of commit 0a6bff09d416
(mdadm/util: unify fstat checking blkdev into function)

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 bitmap.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/bitmap.c b/bitmap.c
index 3653660..989cfb1 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -183,6 +183,7 @@ static int
 bitmap_file_open(char *filename, struct supertype **stp, int node_num)
 {
 	int fd;
+	struct stat stb;
 	struct supertype *st = *stp;
 
 	fd = open(filename, O_RDONLY|O_DIRECT);
@@ -191,8 +192,13 @@ bitmap_file_open(char *filename, struct supertype **stp, int node_num)
 		       filename, strerror(errno));
 		return -1;
 	}
-
-	if (fstat_is_blkdev(fd, filename, NULL)) {
+	if (fstat(fd, &stb) < 0) {
+		pr_err("fstat failed for %s: %s\n",
+			filename, strerror(errno));
+		close(fd);
+		return -1;
+	}
+	if ((stb.st_mode & S_IFMT) == S_IFBLK) {
 		/* block device, so we are probably after an internal bitmap */
 		if (!st)
 			st = guess_super(fd);
@@ -211,11 +217,7 @@ bitmap_file_open(char *filename, struct supertype **stp, int node_num)
 				fd = -1;
 			}
 		}
-
 		*stp = st;
-	} else {
-		close(fd);
-		return -1;
 	}
 
 	return fd;
-- 
2.6.6

