From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 18/24] init: add an init_chmod helper
Date: Tue, 21 Jul 2020 18:28:12 +0200
Message-ID: <20200721162818.197315-19-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200721162818.197315-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Add a simple helper to chmod with a kernel space file name and switch
the early init code over to it.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/internal.h            |  2 +-
 fs/open.c                |  4 ++--
 include/linux/syscalls.h |  7 -------
 init/do_mounts.h         |  1 +
 init/fs.c                | 13 +++++++++++++
 init/initramfs.c         |  4 ++--
 6 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 4a66730fabefa7..585968c0286cf7 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -126,7 +126,7 @@ extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
 
 long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
-int do_fchmodat(int dfd, const char __user *filename, umode_t mode);
+int chmod_common(const struct path *path, umode_t mode);
 int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 		int flag);
 int chown_common(const struct path *path, uid_t user, gid_t group);
diff --git a/fs/open.c b/fs/open.c
index 49960a1248f14b..7ba89eae46c560 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -563,7 +563,7 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 	return error;
 }
 
-static int chmod_common(const struct path *path, umode_t mode)
+int chmod_common(const struct path *path, umode_t mode)
 {
 	struct inode *inode = path->dentry->d_inode;
 	struct inode *delegated_inode = NULL;
@@ -610,7 +610,7 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
 	return err;
 }
 
-int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
+static int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
 {
 	struct path path;
 	int error;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e89d62e944dc0e..8b71fa321ca20c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1304,13 +1304,6 @@ static inline long ksys_link(const char __user *oldname,
 	return do_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
 
-extern int do_fchmodat(int dfd, const char __user *filename, umode_t mode);
-
-static inline int ksys_chmod(const char __user *filename, umode_t mode)
-{
-	return do_fchmodat(AT_FDCWD, filename, mode);
-}
-
 long do_faccessat(int dfd, const char __user *filename, int mode, int flags);
 
 static inline long ksys_access(const char __user *filename, int mode)
diff --git a/init/do_mounts.h b/init/do_mounts.h
index db42564080a2f9..b323d9755d7e5e 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -14,6 +14,7 @@ int __init init_mount(const char *dev_name, const char *dir_name,
 int __init init_chdir(const char *filename);
 int __init init_chroot(const char *filename);
 int __init init_chown(const char *filename, uid_t user, gid_t group, int flags);
+int __init init_chmod(const char *filename, umode_t mode);
 int __init init_unlink(const char *pathname);
 int __init init_rmdir(const char *pathname);
 
diff --git a/init/fs.c b/init/fs.c
index 30000b7097b9f0..c636f25c9a6d69 100644
--- a/init/fs.c
+++ b/init/fs.c
@@ -77,6 +77,19 @@ int __init init_chown(const char *filename, uid_t user, gid_t group, int flags)
 	return error;
 }
 
+int __init init_chmod(const char *filename, umode_t mode)
+{
+	struct path path;
+	int error;
+
+	error = kern_path(filename, LOOKUP_FOLLOW, &path);
+	if (error)
+		return error;
+	error = chmod_common(&path, mode);
+	path_put(&path);
+	return error;
+}
+
 int __init init_unlink(const char *pathname)
 {
 	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
diff --git a/init/initramfs.c b/init/initramfs.c
index 076413dbe8bcf3..771da27e87afa1 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -354,14 +354,14 @@ static int __init do_name(void)
 	} else if (S_ISDIR(mode)) {
 		ksys_mkdir(collected, mode);
 		init_chown(collected, uid, gid, 0);
-		ksys_chmod(collected, mode);
+		init_chmod(collected, mode);
 		dir_add(collected, mtime);
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
 			ksys_mknod(collected, mode, rdev);
 			init_chown(collected, uid, gid, AT_SYMLINK_NOFOLLOW);
-			ksys_chmod(collected, mode);
+			init_chmod(collected, mode);
 			do_utime(collected, mtime);
 		}
 	}
-- 
2.27.0
