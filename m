From: Artur Wojcik <artur.wojcik@intel.com>
Subject: [mdadm PATCH v3] Fix required to enable RAID arrays on SAS disks.
Date: Wed, 9 Dec 2009 18:15:52 +0100
Message-ID: <20091209171552.29567.94832.stgit@awojcik-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, maan@systemlinux.org, ed.ciechanowski@intel.com, dan.j.williams@intel.com, artur.wojcik@intel.com
List-Id: linux-raid.ids

The patch increases the capacity of buffers used to store
sysfs path names. Originally the buffers were too small to
hold the canonical representation of sysfs path (in case
of a SAS device, especially a device installed behind an
expander).

Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
---

 mdadm.h       |    7 +++++++
 super-intel.c |    2 +-
 sysfs.c       |   13 ++++---------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index c7f864b..fb243e5 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1001,3 +1001,10 @@ static inline int xasprintf(char **strp, const char *fmt, ...) {
 #define ALGORITHM_PARITY_0_6		20
 #define ALGORITHM_PARITY_N_6		ALGORITHM_PARITY_N
 
+/* Define PATH_MAX in case we don't use glibc or standard library does
+ * not have PATH_MAX defined. Assume max path length is 4K characters.
+ */
+#ifndef PATH_MAX
+#define PATH_MAX	4096
+#endif
+
diff --git a/super-intel.c b/super-intel.c
index 2e119f8..af485c2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1577,7 +1577,7 @@ static void fd2devname(int fd, char *name)
 {
 	struct stat st;
 	char path[256];
-	char dname[100];
+	char dname[PATH_MAX];
 	char *nm;
 	int rv;
 
diff --git a/sysfs.c b/sysfs.c
index 35dfbd4..1d15ff6 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -100,13 +100,8 @@ void sysfs_init(struct mdinfo *mdi, int fd, int devnum)
 
 struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
 {
-	/* Longest possible name in sysfs, mounted at /sys, is
-	 *  /sys/block/md_dXXX/md/dev-XXXXX/block/dev
-	 *  /sys/block/md_dXXX/md/metadata_version
-	 * which is about 41 characters.  50 should do for now
-	 */
-	char fname[50];
-	char buf[1024];
+	char fname[PATH_MAX];
+	char buf[PATH_MAX];
 	char *base;
 	char *dbase;
 	struct mdinfo *sra;
@@ -574,8 +569,8 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 
 int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int in_sync)
 {
-	char dv[100];
-	char nm[100];
+	char dv[PATH_MAX];
+	char nm[PATH_MAX];
 	char *dname;
 	int rv;
 

