From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 1/5] imsm: load_super_imsm_all function refactoring
Date: Fri, 13 Jan 2012 11:20:04 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D4075DC1@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Subject: [PATCH 1/5] imsm: load_super_imsm_all function refactoring

Prepare function for subsequent changes related to
loading metadata from devices list.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |  170 ++++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 113 insertions(+), 57 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2f963cf..e5fe16e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4010,67 +4010,28 @@ imsm_thunderdome(struct intel_super **super_list, int len)
 	return champion;
 }
 
+
+static int
+get_sra_super_block(int fd, struct intel_super **super_list, char *devname, int *max, int keep_fd);
+
+static int get_super_block(struct intel_super **super_list, int devnum, char *devname,
+			   int major, int minor, int keep_fd);
+
 static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
-			       char *devname)
+			       char *devname, int keep_fd)
 {
-	struct mdinfo *sra;
 	struct intel_super *super_list = NULL;
 	struct intel_super *super = NULL;
-	int devnum = fd2devnum(fd);
-	struct mdinfo *sd;
-	int retry;
 	int err = 0;
-	int i;
+	int i = 0;
 
-	/* check if 'fd' an opened container */
-	sra = sysfs_read(fd, 0, GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE);
-	if (!sra)
+	if (fd >= 0)
+		/* 'fd' is an opened container */
+		err = get_sra_super_block(fd, &super_list, devname, &i, keep_fd);
+	else
 		return 1;
-
-	if (sra->array.major_version != -1 ||
-	    sra->array.minor_version != -2 ||
-	    strcmp(sra->text_version, "imsm") != 0) {
-		err = 1;
+	if (err)
 		goto error;
-	}
-	/* load all mpbs */
-	for (sd = sra->devs, i = 0; sd; sd = sd->next, i++) {
-		struct intel_super *s = alloc_super();
-		char nm[32];
-		int dfd;
-		int rv;
-
-		err = 1;
-		if (!s)
-			goto error;
-		s->next = super_list;
-		super_list = s;
-
-		err = 2;
-		sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
-		dfd = dev_open(nm, O_RDWR);
-		if (dfd < 0)
-			goto error;
-
-		rv = find_intel_hba_capability(dfd, s, devname);
-		/* no orom/efi or non-intel hba of the disk */
-		if (rv != 0)
-			goto error;
-
-		err = load_and_parse_mpb(dfd, s, NULL, 1);
-
-		/* retry the load if we might have raced against mdmon */
-		if (err == 3 && mdmon_running(devnum))
-			for (retry = 0; retry < 3; retry++) {
-				usleep(3000);
-				err = load_and_parse_mpb(dfd, s, NULL, 1);
-				if (err != 3)
-					break;
-			}
-		if (err)
-			goto error;
-	}
-
 	/* all mpbs enter, maybe one leaves */
 	super = imsm_thunderdome(&super_list, i);
 	if (!super) {
@@ -4115,13 +4076,16 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 		super_list = super_list->next;
 		free_imsm(s);
 	}
-	sysfs_free(sra);
+
 
 	if (err)
 		return err;
 
 	*sbp = super;
-	st->container_dev = devnum;
+	if (fd >= 0)
+		st->container_dev = fd2devnum(fd);
+	else
+		st->container_dev = NoMdDev;
 	if (err == 0 && st->ss == NULL) {
 		st->ss = &super_imsm;
 		st->minor_version = 0;
@@ -4130,9 +4094,101 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 	return 0;
 }
 
+
+
+
+static int get_super_block(struct intel_super **super_list, int devnum, char *devname,
+			   int major, int minor, int keep_fd)
+{
+	struct intel_super*s = NULL;
+	char nm[32];
+	int dfd = -1;
+	int rv;
+	int err = 0;
+	int retry;
+
+	s = alloc_super();
+	if (!s) {
+		err = 1;
+		goto error;
+	}
+	
+	sprintf(nm, "%d:%d", major, minor);
+	dfd = dev_open(nm, O_RDWR);
+	if (dfd < 0) {
+		err = 2;
+		goto error;
+	}
+
+	rv = find_intel_hba_capability(dfd, s, devname);
+	/* no orom/efi or non-intel hba of the disk */
+	if (rv != 0) {
+		err = 4;
+		goto error;
+	}
+
+	err = load_and_parse_mpb(dfd, s, NULL, keep_fd);
+	
+	/* retry the load if we might have raced against mdmon */
+	if (err == 3 && (devnum != -1) && mdmon_running(devnum))
+		for (retry = 0; retry < 3; retry++) {
+			usleep(3000);
+			err = load_and_parse_mpb(dfd, s, NULL, keep_fd);
+			if (err != 3)
+				break;
+		}
+ error:
+	if (!err) {
+		s->next = *super_list;
+		*super_list = s;
+	} else {
+		if (s)
+			free(s);
+		if (dfd)
+			close(dfd);
+	}
+	if ((dfd >= 0) && (!keep_fd))
+		close(dfd);
+	return err;
+	
+}
+
+static int
+get_sra_super_block(int fd, struct intel_super **super_list, char *devname, int *max, int keep_fd)
+{
+	struct mdinfo *sra;
+	int devnum;
+	struct mdinfo *sd;
+	int err = 0;
+	int i = 0;
+	sra = sysfs_read(fd, 0, GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE);
+	if (!sra)
+		return 1;
+	  
+	if (sra->array.major_version != -1 ||
+	    sra->array.minor_version != -2 ||
+	    strcmp(sra->text_version, "imsm") != 0) {
+		err = 1;
+		goto error;
+	}
+	/* load all mpbs */
+	devnum = fd2devnum(fd);
+	for (sd = sra->devs, i = 0; sd; sd = sd->next, i++) {
+		if (get_super_block(super_list, devnum, devname,
+				    sd->disk.major, sd->disk.minor, keep_fd) != 0) {
+			err = 7;
+			goto error;
+		}
+	}
+ error:
+	sysfs_free(sra);
+	*max = i;
+	return err;
+}
+
 static int load_container_imsm(struct supertype *st, int fd, char *devname)
 {
-	return load_super_imsm_all(st, fd, &st->sb, devname);
+	return load_super_imsm_all(st, fd, &st->sb, devname, 1);
 }
 #endif
 
@@ -5630,7 +5686,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 		 */
 		struct intel_super *super;
 
-		if (load_super_imsm_all(st, cfd, (void **) &super, NULL) == 0) {
+		if (load_super_imsm_all(st, cfd, (void **) &super, NULL, 1) == 0) {
 			st->sb = super;
 			st->container_dev = fd2devnum(cfd);
 			close(cfd);
-- 
1.7.1

