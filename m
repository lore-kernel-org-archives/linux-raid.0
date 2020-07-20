From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/24] fs: add a kern_stat helper
Date: Mon, 20 Jul 2020 17:59:02 +0200
Message-ID: <20200720155902.181712-25-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to stat/lstat with a kernel space file name and
switch the early init code over to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md-autodetect.c |  2 +-
 fs/stat.c                  | 32 ++++++++++++++++++++++----------
 include/linux/fs.h         |  1 +
 init/initramfs.c           |  3 ++-
 4 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 14b6e86814c061..5bd52ec05ed821 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -151,7 +151,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 		if (strncmp(devname, "/dev/", 5) == 0)
 			devname += 5;
 		snprintf(comp_name, 63, "/dev/%s", devname);
-		if (vfs_stat(comp_name, &stat) == 0 && S_ISBLK(stat.mode))
+		if (kern_stat(comp_name, &stat, 0) == 0 && S_ISBLK(stat.mode))
 			dev = new_decode_dev(stat.rdev);
 		if (!dev) {
 			pr_warn("md: Unknown device name: %s\n", devname);
diff --git a/fs/stat.c b/fs/stat.c
index dacecdda2e7967..3c976b92db00ca 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -151,7 +151,7 @@ int vfs_fstat(int fd, struct kstat *stat)
 /**
  * vfs_statx - Get basic and extra attributes by filename
  * @dfd: A file descriptor representing the base dir for a relative filename
- * @filename: The name of the file of interest
+ * @name: The name of the file of interest
  * @flags: Flags to control the query
  * @stat: The result structure to fill in.
  * @request_mask: STATX_xxx flags indicating what the caller wants
@@ -163,16 +163,16 @@ int vfs_fstat(int fd, struct kstat *stat)
  *
  * 0 will be returned on success, and a -ve error code if unsuccessful.
  */
-static int vfs_statx(int dfd, const char __user *filename, int flags,
+static int vfs_statx(int dfd, struct filename *name, int flags,
 	      struct kstat *stat, u32 request_mask)
 {
 	struct path path;
 	unsigned lookup_flags = 0;
-	int error;
+	int error = -EINVAL;
 
 	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT | AT_EMPTY_PATH |
 		      AT_STATX_SYNC_TYPE))
-		return -EINVAL;
+		goto out_putname;
 
 	if (!(flags & AT_SYMLINK_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
@@ -182,9 +182,9 @@ static int vfs_statx(int dfd, const char __user *filename, int flags,
 		lookup_flags |= LOOKUP_EMPTY;
 
 retry:
-	error = user_path_at(dfd, filename, lookup_flags, &path);
+	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (error)
-		goto out;
+		return error;
 
 	error = vfs_getattr(&path, stat, request_mask, flags);
 	stat->mnt_id = real_mount(path.mnt)->mnt_id;
@@ -197,15 +197,25 @@ static int vfs_statx(int dfd, const char __user *filename, int flags,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
+out_putname:
+	if (!IS_ERR(name))
+		putname(name);
 	return error;
 }
 
+int __init kern_stat(const char *filename, struct kstat *stat, int flags)
+{
+	return vfs_statx(AT_FDCWD, getname_kernel(filename),
+			 flags | AT_NO_AUTOMOUNT, stat, STATX_BASIC_STATS);
+}
+
 int vfs_fstatat(int dfd, const char __user *filename,
 			      struct kstat *stat, int flags)
 {
-	return vfs_statx(dfd, filename, flags | AT_NO_AUTOMOUNT,
-			 stat, STATX_BASIC_STATS);
+	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
+
+	return vfs_statx(dfd, getname_flags(filename, lookup_flags, NULL),
+			 flags | AT_NO_AUTOMOUNT, stat, STATX_BASIC_STATS);
 }
 
 #ifdef __ARCH_WANT_OLD_STAT
@@ -569,6 +579,7 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 int do_statx(int dfd, const char __user *filename, unsigned flags,
 	     unsigned int mask, struct statx __user *buffer)
 {
+	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
 	struct kstat stat;
 	int error;
 
@@ -577,7 +588,8 @@ int do_statx(int dfd, const char __user *filename, unsigned flags,
 	if ((flags & AT_STATX_SYNC_TYPE) == AT_STATX_SYNC_TYPE)
 		return -EINVAL;
 
-	error = vfs_statx(dfd, filename, flags, &stat, mask);
+	error = vfs_statx(dfd, getname_flags(filename, lookup_flags, NULL),
+			  flags, &stat, mask);
 	if (error)
 		return error;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0e0cd6a988bb38..d1f8edb39cf969 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3671,5 +3671,6 @@ int __init kern_link(const char *oldname, const char *newname);
 int __init kern_symlink(const char *oldname, const char *newname);
 int kern_unlink(const char *pathname);
 int __init kern_rmdir(const char *pathname);
+int __init kern_stat(const char *filename, struct kstat *stat, int flags);
 
 #endif /* _LINUX_FS_H */
diff --git a/init/initramfs.c b/init/initramfs.c
index d72594298133a7..6c605f23900fa1 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -296,7 +296,8 @@ static void __init clean_path(char *path, umode_t fmode)
 {
 	struct kstat st;
 
-	if (!vfs_lstat(path, &st) && (st.mode ^ fmode) & S_IFMT) {
+	if (kern_stat(path, &st, AT_SYMLINK_NOFOLLOW) &&
+	    (st.mode ^ fmode) & S_IFMT) {
 		if (S_ISDIR(st.mode))
 			kern_rmdir(path);
 		else
-- 
2.27.0
