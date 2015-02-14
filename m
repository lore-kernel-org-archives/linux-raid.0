From: Mike Lovell <mlovell@bluehost.com>
Subject: [PATCH 1/1] Use dev_t for devnm2devid and devid2devnm
Date: Fri, 13 Feb 2015 18:08:08 -0700
Message-ID: <1423876088-7169-2-git-send-email-mlovell@bluehost.com>
References: <1423876088-7169-1-git-send-email-mlovell@bluehost.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1423876088-7169-1-git-send-email-mlovell@bluehost.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, mlovell@bluehost.com
List-Id: linux-raid.ids

Commit 4dd2df0966ec added a trip through makedev(), major(), and minor() for
device major and minor numbers. This would cause mdadm to fail in operating
on a device with a minor number bigger than (2^19)-1 due to it changing
from dev_t to a signed int and back.

Where this was found as a problem was when a array was created with a device
specified as a name like /dev/md/raidname and there were already 128 arrays
on the system. In this case, mdadm would chose 1048575 ((2^20)-1) for the
array and minor number. This would cause the major and minor number to become
negative when generated from devnm2devid() and passed to major() and minor()
in open_dev_excl(). open_dev_excl() would then call dev_open() which would
detect the negative minor number and call open() on the *char containing the
major:minor pair which isn't a valid file.

Signed-off-by: Mike Lovell <mlovell@bluehost.com>
---
 Detail.c              | 4 ++--
 Grow.c                | 2 +-
 lib.c                 | 2 +-
 mapfile.c             | 2 +-
 mdadm.h               | 4 ++--
 mdopen.c              | 4 ++--
 tests/00largemdnumber | 7 +++++++
 util.c                | 6 +++---
 8 files changed, 19 insertions(+), 12 deletions(-)
 create mode 100644 tests/00largemdnumber

diff --git a/Detail.c b/Detail.c
index dd72ede..18fa5df 100644
--- a/Detail.c
+++ b/Detail.c
@@ -130,7 +130,7 @@ int Detail(char *dev, struct context *c)
 		/* This is a subarray of some container.
 		 * We want the name of the container, and the member
 		 */
-		int devid = devnm2devid(st->container_devnm);
+		dev_t devid = devnm2devid(st->container_devnm);
 		int cfd, err;
 
 		member = subarray;
@@ -573,7 +573,7 @@ This is pretty boring
 				char path[200];
 				char vbuf[1024];
 				int nlen = strlen(sra->sys_name);
-				int devid;
+				dev_t devid;
 				if (de->d_name[0] == '.')
 					continue;
 				sprintf(path, "/sys/block/%s/md/metadata_version",
diff --git a/Grow.c b/Grow.c
index b78d063..e8f6a2a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3467,7 +3467,7 @@ int reshape_container(char *container, char *devname,
 		int fd;
 		struct mdstat_ent *mdstat;
 		char *adev;
-		int devid;
+		dev_t devid;
 
 		sysfs_free(cc);
 
diff --git a/lib.c b/lib.c
index 6808f62..e9f7018 100644
--- a/lib.c
+++ b/lib.c
@@ -84,7 +84,7 @@ char *devid2kname(int devid)
 	return NULL;
 }
 
-char *devid2devnm(int devid)
+char *devid2devnm(dev_t devid)
 {
 	char path[30];
 	char link[200];
diff --git a/mapfile.c b/mapfile.c
index 41599df..9135450 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -374,7 +374,7 @@ void RebuildMap(void)
 			char dn[30];
 			int dfd;
 			int ok;
-			int devid;
+			dev_t devid;
 			struct supertype *st;
 			char *subarray = NULL;
 			char *path;
diff --git a/mdadm.h b/mdadm.h
index 141f963..13279a5 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1372,8 +1372,8 @@ extern char *find_free_devnm(int use_partitions);
 
 extern void put_md_name(char *name);
 extern char *devid2kname(int devid);
-extern char *devid2devnm(int devid);
-extern int devnm2devid(char *devnm);
+extern char *devid2devnm(dev_t devid);
+extern dev_t devnm2devid(char *devnm);
 extern char *get_md_name(char *devnm);
 
 extern char DefaultConfFile[];
diff --git a/mdopen.c b/mdopen.c
index 28410f4..e71d758 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -348,7 +348,7 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 		if (lstat(devname, &stb) == 0) {
 			/* Must be the correct device, else error */
 			if ((stb.st_mode&S_IFMT) != S_IFBLK ||
-			    stb.st_rdev != (dev_t)devnm2devid(devnm)) {
+			    stb.st_rdev != devnm2devid(devnm)) {
 				pr_err("%s exists but looks wrong, please fix\n",
 					devname);
 				return -1;
@@ -452,7 +452,7 @@ char *find_free_devnm(int use_partitions)
 		if (!use_udev()) {
 			/* make sure it is new to /dev too, at least as a
 			 * non-standard */
-			int devid = devnm2devid(devnm);
+			dev_t devid = devnm2devid(devnm);
 			if (devid) {
 				char *dn = map_dev(major(devid),
 						   minor(devid), 0);
diff --git a/tests/00largemdnumber b/tests/00largemdnumber
new file mode 100644
index 0000000..432e5f4
--- /dev/null
+++ b/tests/00largemdnumber
@@ -0,0 +1,7 @@
+
+# create a simple linear with a large device number
+
+mdadm -CR /dev/md1048575 -l linear -n3 $dev0 $dev1 $dev2
+check linear
+testdev /dev/md1048575 3 $mdsize2_l 1
+mdadm -S /dev/md1048575
diff --git a/util.c b/util.c
index 6f1e2b1..a11f995 100644
--- a/util.c
+++ b/util.c
@@ -779,7 +779,7 @@ int get_data_disks(int level, int layout, int raid_disks)
 	return data_disks;
 }
 
-int devnm2devid(char *devnm)
+dev_t devnm2devid(char *devnm)
 {
 	/* First look in /sys/block/$DEVNM/dev for %d:%d
 	 * If that fails, try parsing out a number
@@ -916,7 +916,7 @@ int dev_open(char *dev, int flags)
 
 int open_dev_flags(char *devnm, int flags)
 {
-	int devid;
+	dev_t devid;
 	char buf[20];
 
 	devid = devnm2devid(devnm);
@@ -934,7 +934,7 @@ int open_dev_excl(char *devnm)
 	char buf[20];
 	int i;
 	int flags = O_RDWR;
-	int devid = devnm2devid(devnm);
+	dev_t devid = devnm2devid(devnm);
 	long delay = 1000;
 
 	sprintf(buf, "%d:%d", major(devid), minor(devid));
-- 
1.9.1

