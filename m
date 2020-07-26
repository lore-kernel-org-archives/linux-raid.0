From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/21] init: add an init_stat helper
Date: Sun, 26 Jul 2020 09:13:55 +0200
Message-ID: <20200726071356.287160-21-hch@lst.de>
References: <20200726071356.287160-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200726071356.287160-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to stat with a kernel space file name and switch
the early init code over to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md-autodetect.c    |  3 ++-
 fs/for_init.c                 | 15 +++++++++++++++
 include/linux/init_syscalls.h |  1 +
 init/initramfs.c              |  3 ++-
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 14b6e86814c061..6bbec89976a748 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -5,6 +5,7 @@
 #include <linux/mount.h>
 #include <linux/major.h>
 #include <linux/delay.h>
+#include <linux/init_syscalls.h>
 #include <linux/raid/detect.h>
 #include <linux/raid/md_u.h>
 #include <linux/raid/md_p.h>
@@ -151,7 +152,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 		if (strncmp(devname, "/dev/", 5) == 0)
 			devname += 5;
 		snprintf(comp_name, 63, "/dev/%s", devname);
-		if (vfs_stat(comp_name, &stat) == 0 && S_ISBLK(stat.mode))
+		if (init_stat(comp_name, &stat, 0) == 0 && S_ISBLK(stat.mode))
 			dev = new_decode_dev(stat.rdev);
 		if (!dev) {
 			pr_warn("md: Unknown device name: %s\n", devname);
diff --git a/fs/for_init.c b/fs/for_init.c
index 50813d2913b57b..919a50130a5919 100644
--- a/fs/for_init.c
+++ b/fs/for_init.c
@@ -118,6 +118,21 @@ int __init init_eaccess(const char *filename)
 	return error;
 }
 
+int __init init_stat(const char *filename, struct kstat *stat, int flags)
+{
+	int lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	struct path path;
+	int error;
+
+	error = kern_path(filename, lookup_flags, &path);
+	if (error)
+		return error;
+	error = vfs_getattr(&path, stat, STATX_BASIC_STATS,
+			    flags | AT_NO_AUTOMOUNT);
+	path_put(&path);
+	return error;
+}
+
 int __init init_mknod(const char *filename, umode_t mode, unsigned int dev)
 {
 	struct dentry *dentry;
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
index fa1fe7a877795f..b2fda50daca6c5 100644
--- a/include/linux/init_syscalls.h
+++ b/include/linux/init_syscalls.h
@@ -8,6 +8,7 @@ int __init init_chroot(const char *filename);
 int __init init_chown(const char *filename, uid_t user, gid_t group, int flags);
 int __init init_chmod(const char *filename, umode_t mode);
 int __init init_eaccess(const char *filename);
+int __init init_stat(const char *filename, struct kstat *stat, int flags);
 int __init init_mknod(const char *filename, umode_t mode, unsigned int dev);
 int __init init_link(const char *oldname, const char *newname);
 int __init init_symlink(const char *oldname, const char *newname);
diff --git a/init/initramfs.c b/init/initramfs.c
index 9b2d93a2eb5e4b..b1be3ada3ce4b3 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -297,7 +297,8 @@ static void __init clean_path(char *path, umode_t fmode)
 {
 	struct kstat st;
 
-	if (!vfs_lstat(path, &st) && (st.mode ^ fmode) & S_IFMT) {
+	if (init_stat(path, &st, AT_SYMLINK_NOFOLLOW) &&
+	    (st.mode ^ fmode) & S_IFMT) {
 		if (S_ISDIR(st.mode))
 			init_rmdir(path);
 		else
-- 
2.27.0
