From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 1/5] mdadm/bitmap: examine-bitmap failed when bitmap is external mode
Date: Mon, 28 Aug 2017 17:24:27 +0800
Message-ID: <1503912271-6463-2-git-send-email-zlliu@suse.com>
References: <1503912271-6463-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1503912271-6463-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

--examine-bitmap: the bitmap_file_open() shouldn't omit the
regular file descriptor when the bitmap is external mode.
Such as: ./mdadm -X /mnt/3

This commit is partial revert of commit 0a6bff09d416
(mdadm/util: unify fstat checking blkdev into function)

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 bitmap.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/bitmap.c b/bitmap.c
index 3653660..de5f9db 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -183,6 +183,7 @@ static int
 bitmap_file_open(char *filename, struct supertype **stp, int node_num)
 {
 	int fd;
+	struct stat stb;
 	struct supertype *st = *stp;
 
 	fd = open(filename, O_RDONLY|O_DIRECT);
@@ -192,7 +193,13 @@ bitmap_file_open(char *filename, struct supertype **stp, int node_num)
 		return -1;
 	}
 
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
@@ -211,11 +218,7 @@ bitmap_file_open(char *filename, struct supertype **stp, int node_num)
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

