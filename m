From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH v2 1/4] Add function for getting member drive sector size
Date: Thu, 17 Nov 2016 14:58:35 +0100
Message-ID: <1479391118-31600-2-git-send-email-pawel.baldysiak@intel.com>
References: <1479391118-31600-1-git-send-email-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1479391118-31600-1-git-send-email-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

This patch introduces the function for getting sector size of
given device (fd).

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 mdadm.h  |  1 +
 super1.c |  3 +--
 util.c   | 18 +++++++++++++++++-
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 0516c82..1aeb232 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -1112,6 +1112,7 @@ static inline struct supertype *guess_super(int fd) {
 }
 extern struct supertype *dup_super(struct supertype *st);
 extern int get_dev_size(int fd, char *dname, unsigned long long *sizep);
+extern int get_dev_sector_size(int fd, char *dname, unsigned int *sectsizep);
 extern int must_be_container(int fd);
 extern int dev_size_from_id(dev_t id, unsigned long long *size);
 void wait_for(char *dev, int fd);
diff --git a/super1.c b/super1.c
index 4fef378..8f800b5 100644
--- a/super1.c
+++ b/super1.c
@@ -212,8 +212,7 @@ struct align_fd {
 static void init_afd(struct align_fd *afd, int fd)
 {
 	afd->fd = fd;
-
-	if (ioctl(afd->fd, BLKSSZGET, &afd->blk_sz) != 0)
+	if (!get_dev_sector_size(afd->fd, NULL, (unsigned int *)&afd->blk_sz))
 		afd->blk_sz = 512;
 }
 
diff --git a/util.c b/util.c
index 9e4718f..883eaa4 100644
--- a/util.c
+++ b/util.c
@@ -1324,7 +1324,7 @@ int get_dev_size(int fd, char *dname, unsigned long long *sizep)
 			ldsize <<= 9;
 		} else {
 			if (dname)
-				pr_err("Cannot get size of %s: %s\b",
+				pr_err("Cannot get size of %s: %s\n",
 					dname, strerror(errno));
 			return 0;
 		}
@@ -1333,6 +1333,22 @@ int get_dev_size(int fd, char *dname, unsigned long long *sizep)
 	return 1;
 }
 
+/* Return sector size of device in bytes */
+int get_dev_sector_size(int fd, char *dname, unsigned int *sectsizep)
+{
+	unsigned int sectsize;
+
+	if (ioctl(fd, BLKSSZGET, &sectsize) != 0) {
+		if (dname)
+			pr_err("Cannot get sector size of %s: %s\n",
+				dname, strerror(errno));
+		return 0;
+	}
+
+	*sectsizep = sectsize;
+	return 1;
+}
+
 /* Return true if this can only be a container, not a member device.
  * i.e. is and md device and size is zero
  */
-- 
2.7.4

