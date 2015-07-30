From: Guoqing Jiang <gqjiang@suse.com>
Subject: [V2 PATCH] Safeguard against writing to an active device of another node
Date: Thu, 30 Jul 2015 16:49:50 +0800
Message-ID: <1438246190-24079-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

Modifying an exiting device's superblock or creating a new superblock
on an existing device needs to be checked because the device could be
in use by another node in another array. So, we check this by taking
all superblock locks in userspace so that we don't  step onto an active
device used by another node and safeguard against accidental edits.
After the edit is complete, we release all locks and the lockspace so
that it can be used by the kernel space.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
V2 Changes: use run-time check for dlm library

 Makefile |   6 +-
 mdadm.h  |   3 +
 super1.c |  51 ++++++++++++++++
 util.c   | 204 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 263 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c189279..a76ae13 100644
--- a/Makefile
+++ b/Makefile
@@ -81,11 +81,12 @@ FAILED_SLOTS_DIR = $(RUN_DIR)/failed-slots
 SYSTEMD_DIR=/lib/systemd/system
 
 COROSYNC:=$(shell [ -d /usr/include/corosync ] || echo -DNO_COROSYNC)
+DLM:=$(shell [ -f /usr/include/libdlm.h ] || echo -DNO_DLM)
 
 DIRFLAGS = -DMAP_DIR=\"$(MAP_DIR)\" -DMAP_FILE=\"$(MAP_FILE)\"
 DIRFLAGS += -DMDMON_DIR=\"$(MDMON_DIR)\"
 DIRFLAGS += -DFAILED_SLOTS_DIR=\"$(FAILED_SLOTS_DIR)\"
-CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS) $(COROSYNC)
+CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS) $(COROSYNC) $(DLM)
 
 VERSION = $(shell [ -d .git ] && git describe HEAD | sed 's/mdadm-//')
 VERS_DATE = $(shell [ -d .git ] && date --date="`git log -n1 --format=format:%cd --date=short`" '+%0dth %B %Y' | sed -e 's/1th/1st/' -e 's/2th/2nd/' -e 's/11st/11th/' -e 's/12nd/12th/')
@@ -105,6 +106,9 @@ endif
 # LDFLAGS = -static
 # STRIP = -s
 LDLIBS=-ldl
+ifneq ($(DLM), -DNO_DLM)
+LDLIBS += -ldlm_lt
+endif
 
 INSTALL = /usr/bin/install
 DESTDIR =
diff --git a/mdadm.h b/mdadm.h
index 97892e6..59f851e 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1429,6 +1429,9 @@ extern char *fd2devnm(int fd);
 
 extern int in_initrd(void);
 extern int get_cluster_name(char **name);
+extern int is_clustered(struct supertype *st);
+extern int cluster_get_dlmlock(struct supertype *st, int *lockid);
+extern int cluster_release_dlmlock(struct supertype *st, int lockid);
 
 #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
 #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
diff --git a/super1.c b/super1.c
index fda71e3..bd88c36 100644
--- a/super1.c
+++ b/super1.c
@@ -1072,8 +1072,18 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 	 * ignored.
 	 */
 	int rv = 0;
+	int lockid;
 	struct mdp_superblock_1 *sb = st->sb;
 
+	if (is_clustered(st)) {
+		rv = cluster_get_dlmlock(st, &lockid);
+		if (rv) {
+			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
+			cluster_release_dlmlock(st, lockid);
+			return rv;
+		}
+	}
+
 	if (strcmp(update, "homehost") == 0 &&
 	    homehost) {
 		/* Note that 'homehost' is special as it is really
@@ -1330,6 +1340,9 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		rv = -1;
 
 	sb->sb_csum = calc_sb_1_csum(sb);
+	if (is_clustered(st))
+		cluster_release_dlmlock(st, lockid);
+
 	return rv;
 }
 
@@ -1433,6 +1446,16 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 	struct mdp_superblock_1 *sb = st->sb;
 	__u16 *rp = sb->dev_roles + dk->number;
 	struct devinfo *di, **dip;
+	int rv, lockid;
+
+	if (is_clustered(st)) {
+		rv = cluster_get_dlmlock(st, &lockid);
+		if (rv) {
+			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
+			cluster_release_dlmlock(st, lockid);
+			return rv;
+		}
+	}
 
 	if ((dk->state & 6) == 6) /* active, sync */
 		*rp = __cpu_to_le16(dk->raid_disk);
@@ -1460,6 +1483,9 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 	di->next = NULL;
 	*dip = di;
 
+	if (is_clustered(st))
+		cluster_release_dlmlock(st, lockid);
+
 	return 0;
 }
 #endif
@@ -1473,6 +1499,16 @@ static int store_super1(struct supertype *st, int fd)
 	struct align_fd afd;
 	int sbsize;
 	unsigned long long dsize;
+	int rv, lockid;
+
+	if (is_clustered(st)) {
+		rv = cluster_get_dlmlock(st, &lockid);
+		if (rv) {
+			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
+			cluster_release_dlmlock(st, lockid);
+			return rv;
+		}
+	}
 
 	if (!get_dev_size(fd, NULL, &dsize))
 		return 1;
@@ -1533,6 +1569,9 @@ static int store_super1(struct supertype *st, int fd)
 		}
 	}
 	fsync(fd);
+	if (is_clustered(st))
+		cluster_release_dlmlock(st, lockid);
+
 	return 0;
 }
 
@@ -2282,6 +2321,16 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 
 static void free_super1(struct supertype *st)
 {
+	int rv, lockid;
+	if (is_clustered(st)) {
+		rv = cluster_get_dlmlock(st, &lockid);
+		if (rv) {
+			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
+			cluster_release_dlmlock(st, lockid);
+			return;
+		}
+	}
+
 	if (st->sb)
 		free(st->sb);
 	while (st->info) {
@@ -2292,6 +2341,8 @@ static void free_super1(struct supertype *st)
 		free(di);
 	}
 	st->sb = NULL;
+	if (is_clustered(st))
+		cluster_release_dlmlock(st, lockid);
 }
 
 #ifndef MDASSEMBLE
diff --git a/util.c b/util.c
index ea6e688..3d01219 100644
--- a/util.c
+++ b/util.c
@@ -24,6 +24,7 @@
 
 #include	"mdadm.h"
 #include	"md_p.h"
+#include	<sys/poll.h>
 #include	<sys/socket.h>
 #include	<sys/utsname.h>
 #include	<sys/wait.h>
@@ -42,6 +43,25 @@
 #else
  #include	<corosync/cmap.h>
 #endif
+#ifndef NO_DLM
+#include	<libdlm.h>
+#include	<errno.h>
+#else
+#define LKF_NOQUEUE	0x00000001
+#define LKF_CONVERT	0x00000004
+#define LKM_PWMODE	4
+#define EUNLOCK		0x10002
+
+typedef unsigned int uint32_t;
+typedef void *dlm_lshandle_t;
+
+struct dlm_lksb {
+	int sb_status;
+	uint32_t sb_lkid;
+	char sb_flags;
+	char *sb_lvbptr;
+};
+#endif
 
 
 /*
@@ -88,6 +108,190 @@ struct blkpg_partition {
    aren't permitted). */
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
 
+struct dlm_lock_resource {
+	dlm_lshandle_t *ls;
+	struct dlm_lksb lksb;
+};
+
+struct dlm_lock_resource *dlm_lock_res = NULL;
+static int ast_called = 0;
+
+int is_clustered(struct supertype *st)
+{
+	/* is it a cluster md or not */
+	return st->cluster_name ? 1 :0;
+}
+
+/* Using poll(2) to wait for and dispatch ASTs */
+static int poll_for_ast(dlm_lshandle_t ls)
+{
+	void *lib_handle = NULL;
+	struct pollfd pfd;
+
+	static int (*ls_get_fd)(dlm_lshandle_t ls);
+	static int (*dispatch)(int fd);
+
+        lib_handle = dlopen("libdlm_lt.so.3", RTLD_NOW | RTLD_LOCAL);
+        if (!lib_handle)
+                return -1;
+
+        ls_get_fd = dlsym(lib_handle, "dlm_ls_get_fd");
+        if (!ls_get_fd)
+                goto out;
+
+        dispatch = dlsym(lib_handle, "dlm_dispatch");
+        if (!dispatch)
+                goto out;
+
+	pfd.fd = ls_get_fd(ls);
+	pfd.events = POLLIN;
+
+	while (!ast_called)
+	{
+		if (poll(&pfd, 1, 0) < 0)
+		{
+			perror("poll");
+			dlclose(lib_handle);
+			return -1;
+		}
+		dispatch(ls_get_fd(ls));
+	}
+	ast_called = 0;
+
+out:
+        dlclose(lib_handle);
+	return 0;
+}
+
+static void dlm_ast(void *arg)
+{
+	ast_called = 1;
+}
+
+/* Create the lockspace, take bitmapXXX locks on all the bitmaps. */
+int cluster_get_dlmlock(struct supertype *st, int *lockid)
+{
+	int ret = -1;
+	void *lib_handle = NULL;
+	char str[64];
+	int flags = LKF_NOQUEUE;
+
+	static dlm_lshandle_t (*create_lockspace)(const char *name,
+						  unsigned int mode);
+	static int (*ls_lock)(dlm_lshandle_t lockspace, uint32_t mode,
+			      struct dlm_lksb *lksb, uint32_t flags,
+			      const void *name, unsigned int namelen,
+			      uint32_t parent, void (*astaddr) (void *astarg),
+			      void *astarg, void (*bastaddr) (void *astarg),
+			      void *range);
+
+        lib_handle = dlopen("libdlm_lt.so.3", RTLD_NOW | RTLD_LOCAL);
+        if (!lib_handle)
+                return ret;
+
+        create_lockspace = dlsym(lib_handle, "dlm_create_lockspace");
+        if (!create_lockspace)
+                goto out;
+
+        ls_lock = dlsym(lib_handle, "dlm_ls_lock");
+        if (!ls_lock)
+                goto out;
+
+	dlm_lock_res = xmalloc(sizeof(struct dlm_lock_resource));
+	if (!dlm_lock_res)
+                goto out;
+
+	dlm_lock_res->ls = create_lockspace(st->cluster_name, O_RDWR);
+	if (!dlm_lock_res->ls) {
+		pr_err("%s failed to create lockspace\n", st->cluster_name);
+                goto out;
+	}
+
+	/* Conversions need the lockid in the LKSB */
+	if (flags & LKF_CONVERT)
+		dlm_lock_res->lksb.sb_lkid = *lockid;
+
+	snprintf(str, 64, "bitmap%04d", st->nodes);
+	/* if flags with LKF_CONVERT causes below return ENOENT which means
+	 * "No such file or directory" */
+	ret = ls_lock(dlm_lock_res->ls, LKM_PWMODE, &dlm_lock_res->lksb,
+			  flags, str, strlen(str), 0, dlm_ast,
+			  dlm_lock_res, NULL, NULL);
+	if (ret) {
+		pr_err("error %d when get PW mode on lock %s\n", errno, str);
+                goto out;
+	}
+
+	/* Wait for it to complete */
+	poll_for_ast(dlm_lock_res->ls);
+	*lockid = dlm_lock_res->lksb.sb_lkid;
+
+	errno =	dlm_lock_res->lksb.sb_status;
+	if (errno) {
+		pr_err("error %d happened in ast with lock %s\n", errno, str);
+		goto out;
+	}
+
+out:
+        dlclose(lib_handle);
+	return ret;
+}
+
+int cluster_release_dlmlock(struct supertype *st, int lockid)
+{
+	int ret = -1;
+	void *lib_handle = NULL;
+
+	static int (*ls_unlock)(dlm_lshandle_t lockspace, uint32_t lkid,
+				 uint32_t flags, struct dlm_lksb *lksb,
+				 void *astarg);
+	static int (*release_lockspace)(const char *name, dlm_lshandle_t ls,
+					 int force);
+
+        lib_handle = dlopen("libdlm_lt.so.3", RTLD_NOW | RTLD_LOCAL);
+        if (!lib_handle)
+                return ret;
+
+        ls_unlock = dlsym(lib_handle, "dlm_ls_unlock");
+        if (!ls_unlock)
+                goto out;
+
+        release_lockspace = dlsym(lib_handle, "dlm_release_lockspace");
+        if (!release_lockspace)
+                goto out;
+
+	/* if flags with LKF_CONVERT causes below return EINVAL which means
+	 * "Invalid argument" */
+	ret = ls_unlock(dlm_lock_res->ls, lockid, 0, &dlm_lock_res->lksb, dlm_lock_res);
+	if (ret) {
+		pr_err("error %d happened when unlock\n", errno);
+		/* XXX make sure the lock is unlocked eventually */
+                goto out;
+	}
+
+	/* Wait for it to complete */
+	poll_for_ast(dlm_lock_res->ls);
+
+	errno =	dlm_lock_res->lksb.sb_status;
+	if (errno != EUNLOCK) {
+		pr_err("error %d happened in ast when unlock lockspace\n", errno);
+		/* XXX make sure the lockspace is unlocked eventually */
+                goto out;
+	}
+
+	ret = release_lockspace(st->cluster_name, dlm_lock_res->ls, 1);
+	if (ret) {
+		pr_err("error %d happened when release lockspace\n", errno);
+		/* XXX make sure the lockspace is released eventually */
+                goto out;
+	}
+	free(dlm_lock_res);
+
+out:
+        dlclose(lib_handle);
+	return ret;
+}
+
 /*
  * Parse a 128 bit uuid in 4 integers
  * format is 32 hexx nibbles with options :.<space> separator
-- 
1.7.12.4

