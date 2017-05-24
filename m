From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] Detail: don't exit if ioctl has been successful
Date: Wed, 24 May 2017 11:34:22 +0200
Message-ID: <1495618462-23016-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

When GET_ARRAY_INFO ioctl is successful, mdadm exits with an error.
It breaks udev and no links in /dev/md are created.

Also change debug print to error print in the message indicating lack
of the link to facilitate debugging similar issues in the future.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 Detail.c | 27 +++++++++++++++------------
 util.c   |  2 +-
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/Detail.c b/Detail.c
index ef2370c..0adccb7 100644
--- a/Detail.c
+++ b/Detail.c
@@ -99,21 +99,24 @@ int Detail(char *dev, struct context *c)
 	inactive = (sra->array_state == ARRAY_ACTIVE ||
 		    sra->array_state == ARRAY_CLEAR);
 	st = super_by_fd(fd, &subarray);
-	if (md_get_array_info(fd, &array) && errno == ENODEV) {
-		if (sra->array.major_version == -1 &&
-		    sra->array.minor_version == -1 &&
-		    sra->devs == NULL) {
-			pr_err("Array associated with md device %s does not exist.\n", dev);
+	if (md_get_array_info(fd, &array)) {
+		if (errno == ENODEV) {
+			if (sra->array.major_version == -1 &&
+			    sra->array.minor_version == -1 &&
+			    sra->devs == NULL) {
+				pr_err("Array associated with md device %s does not exist.\n",
+				       dev);
+				close(fd);
+				sysfs_free(sra);
+				return rv;
+			}
+			array = sra->array;
+		} else {
+			pr_err("cannot get array detail for %s: %s\n",
+			       dev, strerror(errno));
 			close(fd);
-			sysfs_free(sra);
 			return rv;
 		}
-		array = sra->array;
-	} else {
-		pr_err("cannot get array detail for %s: %s\n",
-		       dev, strerror(errno));
-		close(fd);
-		return rv;
 	}
 
 	if (fstat(fd, &stb) != 0 && !S_ISBLK(stb.st_mode))
diff --git a/util.c b/util.c
index 11ff2cc..2e148ef 100644
--- a/util.c
+++ b/util.c
@@ -1173,7 +1173,7 @@ void wait_for(char *dev, int fd)
 			delay *= 2;
 	}
 	if (i == 25)
-		dprintf("timeout waiting for %s\n", dev);
+		pr_err("timeout waiting for %s\n", dev);
 }
 
 struct superswitch *superlist[] =
-- 
1.8.3.1

