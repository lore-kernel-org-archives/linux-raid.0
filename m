From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] Increase buffer for sysfs path
Date: Fri, 28 Oct 2016 10:35:50 +0200
Message-ID: <1477643750-4381-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

'unacknowledged_bad_blocks' is a long name for sysfs property and it
makes sysfs path over 50 characters long. Increase buffer to the double
length of the longest path available in sysfs at the moment.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 sysfs.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/sysfs.c b/sysfs.c
index c7a8e66..fc1f01e 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -27,6 +27,8 @@
 #include	<dirent.h>
 #include	<ctype.h>
 
+#define MAX_SYSFS_PATH_LEN	120
+
 int load_sys(char *path, char *buf, int len)
 {
 	int fd = open(path, O_RDONLY);
@@ -63,15 +65,15 @@ void sysfs_free(struct mdinfo *sra)
 
 int sysfs_open(char *devnm, char *devname, char *attr)
 {
-	char fname[50];
+	char fname[MAX_SYSFS_PATH_LEN];
 	int fd;
 
-	sprintf(fname, "/sys/block/%s/md/", devnm);
+	snprintf(fname, MAX_SYSFS_PATH_LEN, "/sys/block/%s/md/", devnm);
 	if (devname) {
-		strcat(fname, devname);
-		strcat(fname, "/");
+		strncat(fname, devname, MAX_SYSFS_PATH_LEN - strlen(fname));
+		strncat(fname, "/", MAX_SYSFS_PATH_LEN - strlen(fname));
 	}
-	strcat(fname, attr);
+	strncat(fname, attr, MAX_SYSFS_PATH_LEN - strlen(fname));
 	fd = open(fname, O_RDWR);
 	if (fd < 0 && errno == EACCES)
 		fd = open(fname, O_RDONLY);
@@ -396,15 +398,17 @@ unsigned long long get_component_size(int fd)
 	 * This returns in units of sectors.
 	 */
 	struct stat stb;
-	char fname[50];
+	char fname[MAX_SYSFS_PATH_LEN];
 	int n;
 	if (fstat(fd, &stb))
 		return 0;
 	if (major(stb.st_rdev) != (unsigned)get_mdp_major())
-		sprintf(fname, "/sys/block/md%d/md/component_size",
+		snprintf(fname, MAX_SYSFS_PATH_LEN,
+			"/sys/block/md%d/md/component_size",
 			(int)minor(stb.st_rdev));
 	else
-		sprintf(fname, "/sys/block/md_d%d/md/component_size",
+		snprintf(fname, MAX_SYSFS_PATH_LEN,
+			"/sys/block/md_d%d/md/component_size",
 			(int)minor(stb.st_rdev)>>MdpMinorShift);
 	fd = open(fname, O_RDONLY);
 	if (fd < 0)
@@ -420,11 +424,11 @@ unsigned long long get_component_size(int fd)
 int sysfs_set_str(struct mdinfo *sra, struct mdinfo *dev,
 		  char *name, char *val)
 {
-	char fname[50];
+	char fname[MAX_SYSFS_PATH_LEN];
 	unsigned int n;
 	int fd;
 
-	sprintf(fname, "/sys/block/%s/md/%s/%s",
+	snprintf(fname, MAX_SYSFS_PATH_LEN, "/sys/block/%s/md/%s/%s",
 		sra->sys_name, dev?dev->sys_name:"", name);
 	fd = open(fname, O_WRONLY);
 	if (fd < 0)
@@ -457,11 +461,11 @@ int sysfs_set_num_signed(struct mdinfo *sra, struct mdinfo *dev,
 
 int sysfs_uevent(struct mdinfo *sra, char *event)
 {
-	char fname[50];
+	char fname[MAX_SYSFS_PATH_LEN];
 	int n;
 	int fd;
 
-	sprintf(fname, "/sys/block/%s/uevent",
+	snprintf(fname, MAX_SYSFS_PATH_LEN, "/sys/block/%s/uevent",
 		sra->sys_name);
 	fd = open(fname, O_WRONLY);
 	if (fd < 0)
@@ -478,10 +482,10 @@ int sysfs_uevent(struct mdinfo *sra, char *event)
 
 int sysfs_attribute_available(struct mdinfo *sra, struct mdinfo *dev, char *name)
 {
-	char fname[50];
+	char fname[MAX_SYSFS_PATH_LEN];
 	struct stat st;
 
-	sprintf(fname, "/sys/block/%s/md/%s/%s",
+	snprintf(fname, MAX_SYSFS_PATH_LEN, "/sys/block/%s/md/%s/%s",
 		sra->sys_name, dev?dev->sys_name:"", name);
 
 	return stat(fname, &st) == 0;
@@ -490,10 +494,10 @@ int sysfs_attribute_available(struct mdinfo *sra, struct mdinfo *dev, char *name
 int sysfs_get_fd(struct mdinfo *sra, struct mdinfo *dev,
 		       char *name)
 {
-	char fname[50];
+	char fname[MAX_SYSFS_PATH_LEN];
 	int fd;
 
-	sprintf(fname, "/sys/block/%s/md/%s/%s",
+	snprintf(fname, MAX_SYSFS_PATH_LEN, "/sys/block/%s/md/%s/%s",
 		sra->sys_name, dev?dev->sys_name:"", name);
 	fd = open(fname, O_RDWR);
 	if (fd < 0)
-- 
1.8.3.1

