From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [mdadm PATCH 1/2] Fix off-by-one in readlink() buffer size handling
Date: Thu, 13 Oct 2011 11:21:07 +0200
Message-ID: <201110131121.08172.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

readlink() returns the number of bytes in the buffer.

If we do something like

len = readlink(path, buf, sizeof(buf));
buf[len] = '\0';

we might write one byte past the end of the buffer.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 policy.c      |    2 +-
 super-intel.c |    2 +-
 sysfs.c       |    2 +-
 util.c        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/policy.c b/policy.c
index ef48353..7959c97 100644
--- a/policy.c
+++ b/policy.c
@@ -222,7 +222,7 @@ static char *disk_path(struct mdinfo *disk)
 	closedir(by_path);
 	/* A NULL path isn't really acceptable - use the devname.. */
 	sprintf(symlink, "/sys/dev/block/%d:%d", disk->disk.major, disk->disk.minor);
-	rv = readlink(symlink, nm, sizeof(nm));
+	rv = readlink(symlink, nm, sizeof(nm)-1);
 	if (rv > 0) {
 		char *dname;
 		nm[rv] = 0;
diff --git a/super-intel.c b/super-intel.c
index af06660..401c701 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2864,7 +2864,7 @@ static void fd2devname(int fd, char *name)
 	sprintf(path, "/sys/dev/block/%d:%d",
 		major(st.st_rdev), minor(st.st_rdev));
 
-	rv = readlink(path, dname, sizeof(dname));
+	rv = readlink(path, dname, sizeof(dname)-1);
 	if (rv <= 0)
 		return;
 	
diff --git a/sysfs.c b/sysfs.c
index e1aaf4d..a5fcdd0 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -619,7 +619,7 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 
 	memset(nm, 0, sizeof(nm));
 	sprintf(dv, "/sys/dev/block/%d:%d", sd->disk.major, sd->disk.minor);
-	rv = readlink(dv, nm, sizeof(nm));
+	rv = readlink(dv, nm, sizeof(nm)-1);
 	if (rv <= 0)
 		return -1;
 	nm[rv] = '\0';
diff --git a/util.c b/util.c
index 50c98c1..f785f03 100644
--- a/util.c
+++ b/util.c
@@ -1594,7 +1594,7 @@ int start_mdmon(int devnum)
 	if (check_env("MDADM_NO_MDMON"))
 		return 0;
 
-	len = readlink("/proc/self/exe", pathbuf, sizeof(pathbuf));
+	len = readlink("/proc/self/exe", pathbuf, sizeof(pathbuf)-1);
 	if (len > 0) {
 		char *sl;
 		pathbuf[len] = 0;
-- 
1.7.4.4
