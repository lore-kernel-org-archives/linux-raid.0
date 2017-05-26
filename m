From: Lidong Zhong <lzhong@suse.com>
Subject: [Patch v1] Detail: fix a bug when trying to show the detail of a raid device
Date: Fri, 26 May 2017 10:42:16 +0800
Message-ID: <20170526024216.10248-1-lzhong@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com, neilb@suse.com
List-Id: linux-raid.ids

It's introduced from commit a4dcdb23ea63.

Signed-off-by: Lidong Zhong <lzhong@suse.com>
---
 Detail.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Detail.c b/Detail.c
index bf881ff..c89b927 100644
--- a/Detail.c
+++ b/Detail.c
@@ -98,8 +98,8 @@ int Detail(char *dev, struct context *c)
 		    sra->array.minor_version == -2);
 	inactive = (sra->array_state == ARRAY_ACTIVE ||
 		    sra->array_state == ARRAY_CLEAR);
-	st = super_by_fd(fd, &subarray);
-	if (md_get_array_info(fd, &array) && errno == ENODEV) {
+	rv = md_get_array_info(fd, &array);
+	if (rv && errno == ENODEV) {
 		if (sra->array.major_version == -1 &&
 		    sra->array.minor_version == -1 &&
 		    sra->devs == NULL) {
@@ -109,7 +109,7 @@ int Detail(char *dev, struct context *c)
 			return rv;
 		}
 		array = sra->array;
-	} else {
+	} else if (rv) {
 		pr_err("cannot get array detail for %s: %s\n",
 		       dev, strerror(errno));
 		close(fd);
@@ -118,8 +118,8 @@ int Detail(char *dev, struct context *c)
 
 	if (fstat(fd, &stb) != 0 && !S_ISBLK(stb.st_mode))
 		stb.st_rdev = 0;
-	rv = 0;
 
+	st = super_by_fd(fd, &subarray);
 	if (st)
 		max_disks = st->max_devs;
 
-- 
2.12.0

