From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] Introduce stat2kname() and fd2kname()
Date: Tue, 29 Mar 2016 15:20:29 +0200
Message-ID: <1459257629-22027-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

These are similar to stat2devnm() and fd2devnm() but not limited to md
devices. If the device is a partition they will return its kernel name,
not the whole device's name. For more information see commit:
8d83493 ("Introduce devid2kname - slightly different to devid2devnm.")

Also remove unsued declaration for fmt_devname().

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 lib.c         | 15 +++++++++++++++
 mdadm.h       |  3 ++-
 super-intel.c |  6 +++++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/lib.c b/lib.c
index 6808f62..621edf3 100644
--- a/lib.c
+++ b/lib.c
@@ -84,6 +84,21 @@ char *devid2kname(int devid)
 	return NULL;
 }
 
+char *stat2kname(struct stat *st)
+{
+	if ((S_IFMT & st->st_mode) != S_IFBLK)
+		return NULL;
+	return devid2kname(st->st_rdev);
+}
+
+char *fd2kname(int fd)
+{
+	struct stat stb;
+	if (fstat(fd, &stb) == 0)
+		return stat2kname(&stb);
+	return NULL;
+}
+
 char *devid2devnm(int devid)
 {
 	char path[30];
diff --git a/mdadm.h b/mdadm.h
index 3b96076..d209488 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -1474,7 +1474,8 @@ void abort_reshape(struct mdinfo *sra);
 
 void *super1_make_v0(struct supertype *st, struct mdinfo *info, mdp_super_t *sb0);
 
-extern void fmt_devname(char *name, int num);
+extern char *stat2kname(struct stat *st);
+extern char *fd2kname(int fd);
 extern char *stat2devnm(struct stat *st);
 extern char *fd2devnm(int fd);
 
diff --git a/super-intel.c b/super-intel.c
index f04ac2f..ba3ee48 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4589,7 +4589,11 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 
 	/* retry the load if we might have raced against mdmon */
 	if (rv == 3) {
-		struct mdstat_ent *mdstat = mdstat_by_component(fd2devnm(fd));
+		struct mdstat_ent *mdstat = NULL;
+		char *name = fd2kname(fd);
+
+		if (name)
+			mdstat = mdstat_by_component(name);
 
 		if (mdstat && mdmon_running(mdstat->devnm) && getpid() != mdmon_pid(mdstat->devnm)) {
 			for (retry = 0; retry < 3; retry++) {
-- 
2.6.2

