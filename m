From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 2/5] imsm: load_imsm_super_all supports loading metadata
 from the device list
Date: Fri, 13 Jan 2012 11:20:10 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D4075DD1@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Subject: [PATCH 2/5] imsm: load_imsm_super_all supports loading metadata from the device list

This option is going to be used to load and analyse the metadata from
devices. This is needed to count the number of volumes on devcies attached
to particular Intel controller (SATA or SAS). It shall be done without
activation of container and volumes on the devices.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 73 insertions(+), 6 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e5fe16e..0d68002 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -277,6 +277,22 @@ struct migr_record {
 				     * (for recovered migrations) */
 } __attribute__ ((__packed__));
 
+struct md_list {
+	/* usage marker: 
+	 *  1: load metadata
+	 *  2: metadata does not match
+	 *  4: already checked
+	 */
+	int   used;
+	char  *devname;
+	int   found;
+	int   container;
+	dev_t st_rdev;
+	struct md_list *next;
+};
+
+#define pr_vrb(fmt, arg...) (void) (verbose && fprintf(stderr, Name fmt, ##arg))
+
 static __u8 migr_type(struct imsm_dev *dev)
 {
 	if (dev->vol.migr_type == MIGR_VERIFY &&
@@ -4013,12 +4029,16 @@ imsm_thunderdome(struct intel_super **super_list, int len)
 
 static int
 get_sra_super_block(int fd, struct intel_super **super_list, char *devname, int *max, int keep_fd);
-
 static int get_super_block(struct intel_super **super_list, int devnum, char *devname,
 			   int major, int minor, int keep_fd);
+static int
+get_devlist_super_block(struct md_list *devlist, struct intel_super **super_list,
+			int *max, int keep_fd);
+
 
 static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
-			       char *devname, int keep_fd)
+			       char *devname, struct md_list *devlist,
+			       int keep_fd)
 {
 	struct intel_super *super_list = NULL;
 	struct intel_super *super = NULL;
@@ -4029,7 +4049,8 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 		/* 'fd' is an opened container */
 		err = get_sra_super_block(fd, &super_list, devname, &i, keep_fd);
 	else
-		return 1;
+		/* get super block from devlist devices */
+		err = get_devlist_super_block(devlist, &super_list, &i, keep_fd);
 	if (err)
 		goto error;
 	/* all mpbs enter, maybe one leaves */
@@ -4095,7 +4116,54 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 }
 
 
+static int
+get_devlist_super_block(struct md_list *devlist, struct intel_super **super_list,
+			int *max, int keep_fd)
+{
+	struct md_list *tmpdev;
+	int err = 0;
+	int i = 0;
+	int lmax = 0;
 
+	for (i = 0, tmpdev = devlist; tmpdev; tmpdev = tmpdev->next) {
+		if (tmpdev->used != 1)
+			continue;
+		if (tmpdev->container == 1) {
+			int fd = dev_open(tmpdev->devname, O_RDONLY|O_EXCL);
+			if (fd < 0) {
+				fprintf(stderr, Name ": cannot open device %s: %s\n",
+					tmpdev->devname, strerror(errno));
+				err = 8;
+				goto error;
+			}
+			err = get_sra_super_block(fd, super_list,
+						  tmpdev->devname, &lmax,
+						  keep_fd);
+			i += lmax;
+			close(fd);
+			if (err) {
+				err = 7;
+				goto error;
+			}
+		} else {
+			int major = major(tmpdev->st_rdev);
+			int minor = minor(tmpdev->st_rdev);
+			err = get_super_block(super_list,
+					      -1,
+					      tmpdev->devname,
+					      major, minor,
+					      keep_fd);
+			i++;
+			if (err) {
+				err = 6;
+				goto error;
+			}
+		}
+	}
+ error:
+	*max = i;
+	return err;
+}
 
 static int get_super_block(struct intel_super **super_list, int devnum, char *devname,
 			   int major, int minor, int keep_fd)
@@ -4188,7 +4256,7 @@ get_sra_super_block(int fd, struct intel_super **super_list, char *devname, int
 
 static int load_container_imsm(struct supertype *st, int fd, char *devname)
 {
-	return load_super_imsm_all(st, fd, &st->sb, devname, 1);
+	return load_super_imsm_all(st, fd, &st->sb, devname, NULL, 1);
 }
 #endif
 
@@ -5306,7 +5374,6 @@ static int imsm_default_chunk(const struct imsm_orom *orom)
 	return min(512, (1 << fs));
 }
 
-#define pr_vrb(fmt, arg...) (void) (verbose && fprintf(stderr, Name fmt, ##arg))
 static int
 validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
 			    int raiddisks, int *chunk, int verbose)
@@ -5686,7 +5753,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 		 */
 		struct intel_super *super;
 
-		if (load_super_imsm_all(st, cfd, (void **) &super, NULL, 1) == 0) {
+		if (load_super_imsm_all(st, cfd, (void **) &super, NULL, NULL, 1) == 0) {
 			st->sb = super;
 			st->container_dev = fd2devnum(cfd);
 			close(cfd);
-- 
1.7.1

