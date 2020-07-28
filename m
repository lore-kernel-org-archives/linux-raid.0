From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/23] init: add an init_chmod helper
Date: Tue, 28 Jul 2020 18:34:08 +0200
Message-ID: <20200728163416.556521-16-hch@lst.de>
References: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200728163416.556521-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to chmod with a kernel space file name and switch
the early init code over to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/init.c                     | 13 +++++++++++++
 fs/internal.h                 |  2 +-
 fs/open.c                     |  4 ++--
 include/linux/init_syscalls.h |  1 +
 include/linux/syscalls.h      |  7 -------
 init/initramfs.c              |  4 ++--
 6 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index edd0244655956e..a66032d128b618 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -96,6 +96,19 @@ int __init init_chown(const char *filename, uid_t user, gid_t group, int flags)
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
diff --git a/fs/internal.h b/fs/internal.h
index e81b9e23c3ea3f..6d82681c7d8372 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -131,7 +131,7 @@ extern struct open_how build_open_how(int flags, umode_t mode);
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
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
index 0da59d76133e17..2b1b4dc586825f 100644
--- a/include/linux/init_syscalls.h
+++ b/include/linux/init_syscalls.h
@@ -6,5 +6,6 @@ int __init init_umount(const char *name, int flags);
 int __init init_chdir(const char *filename);
 int __init init_chroot(const char *filename);
 int __init init_chown(const char *filename, uid_t user, gid_t group, int flags);
+int __init init_chmod(const char *filename, umode_t mode);
 int __init init_unlink(const char *pathname);
 int __init init_rmdir(const char *pathname);
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
diff --git a/init/initramfs.c b/init/initramfs.c
index 24a8dcc6734064..21a75f6ca893a9 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -350,14 +350,14 @@ static int __init do_name(void)
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
 			init_chown(collected, uid, gid, 0);
-			ksys_chmod(collected, mode);
+			init_chmod(collected, mode);
 			do_utime(collected, mtime);
 		}
 	}
-- 
2.27.0
