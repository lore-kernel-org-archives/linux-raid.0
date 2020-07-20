From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/24] fs: add a kern_mkdir helper
Date: Mon, 20 Jul 2020 17:58:51 +0200
Message-ID: <20200720155902.181712-14-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper perform a mkdir with a kernel space file name and use
it in the early init code instead of relying on the implicit
set_fs(KERNEL_DS) there.  To do so push the getname from do_mkdirat into the
callers.  Remove the now unused ksys_mkdir.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/internal.h            |  1 -
 fs/namei.c               | 14 ++++++++++----
 include/linux/fs.h       |  1 +
 include/linux/syscalls.h |  7 -------
 init/do_mounts_initrd.c  |  2 +-
 init/initramfs.c         |  2 +-
 init/noinitramfs.c       |  4 ++--
 7 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 1e2b425f56ee9e..722d33a66d9645 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -64,7 +64,6 @@ extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct path *);
 long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 		unsigned int dev);
-long do_mkdirat(int dfd, const char __user *pathname, umode_t mode);
 long do_rmdir(int dfd, const char __user *pathname);
 long do_unlinkat(int dfd, struct filename *name);
 long do_symlinkat(const char __user *oldname, int newdfd,
diff --git a/fs/namei.c b/fs/namei.c
index 6daffd59e97270..3545623495d1f4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3665,7 +3665,7 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
+static int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 {
 	struct dentry *dentry;
 	struct path path;
@@ -3673,7 +3673,7 @@ long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
 	unsigned int lookup_flags = LOOKUP_DIRECTORY;
 
 retry:
-	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
+	dentry = filename_create(dfd, name, &path, lookup_flags);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
@@ -3687,17 +3687,23 @@ long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+	putname(name);
 	return error;
 }
 
+int kern_mkdir(const char *pathname, umode_t mode)
+{
+	return do_mkdirat(AT_FDCWD, getname_kernel(pathname), mode);
+}
+
 SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
 {
-	return do_mkdirat(dfd, pathname, mode);
+	return do_mkdirat(dfd, getname(pathname), mode);
 }
 
 SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
 {
-	return do_mkdirat(AT_FDCWD, pathname, mode);
+	return do_mkdirat(AT_FDCWD, getname(pathname), mode);
 }
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7472ff0b7062d9..3bbeeadf2ddd98 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3677,5 +3677,6 @@ int __init kern_access(const char *filename, int mode);
 int __init kern_chown(const char *filename, uid_t user, gid_t group, int flag);
 int __init kern_chmod(const char *filename, umode_t mode);
 int __init kern_utimes(const char *filename, struct timespec64 *tv, int flags);
+int kern_mkdir(const char *pathname, umode_t mode);
 
 #endif /* _LINUX_FS_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a2ece4cc8692f5..6aa1cd200425a4 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1284,13 +1284,6 @@ static inline long ksys_rmdir(const char __user *pathname)
 	return do_rmdir(AT_FDCWD, pathname);
 }
 
-extern long do_mkdirat(int dfd, const char __user *pathname, umode_t mode);
-
-static inline long ksys_mkdir(const char __user *pathname, umode_t mode)
-{
-	return do_mkdirat(AT_FDCWD, pathname, mode);
-}
-
 extern long do_symlinkat(const char __user *oldname, int newdfd,
 			 const char __user *newname);
 
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 1cbc9988d2e0ad..b9a749ebe85c2d 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -81,7 +81,7 @@ static void __init handle_initrd(void)
 	create_dev("/dev/root.old", Root_RAM0);
 	/* mount initrd on rootfs' /root */
 	mount_block_root("/dev/root.old", root_mountflags & ~MS_RDONLY);
-	ksys_mkdir("/old", 0700);
+	kern_mkdir("/old", 0700);
 	kern_chdir("/old");
 
 	/*
diff --git a/init/initramfs.c b/init/initramfs.c
index de850d4c6da200..40b97ca5fe8cde 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -344,7 +344,7 @@ static int __init do_name(void)
 			state = CopyFile;
 		}
 	} else if (S_ISDIR(mode)) {
-		ksys_mkdir(collected, mode);
+		kern_mkdir(collected, mode);
 		kern_chown(collected, uid, gid, 0);
 		kern_chmod(collected, mode);
 		dir_add(collected, mtime);
diff --git a/init/noinitramfs.c b/init/noinitramfs.c
index fa9cdfa7101d3c..89109c1d633adb 100644
--- a/init/noinitramfs.c
+++ b/init/noinitramfs.c
@@ -17,7 +17,7 @@ static int __init default_rootfs(void)
 {
 	int err;
 
-	err = ksys_mkdir((const char __user __force *) "/dev", 0755);
+	err = kern_mkdir("/dev", 0755);
 	if (err < 0)
 		goto out;
 
@@ -27,7 +27,7 @@ static int __init default_rootfs(void)
 	if (err < 0)
 		goto out;
 
-	err = ksys_mkdir((const char __user __force *) "/root", 0700);
+	err = kern_mkdir("/root", 0700);
 	if (err < 0)
 		goto out;
 
-- 
2.27.0
