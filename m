From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/24] fs: add a kern_mknod helper
Date: Mon, 20 Jul 2020 17:58:52 +0200
Message-ID: <20200720155902.181712-15-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper perform a mknod with a kernel space file name and use
it in the early init code instead of relying on the implicit
set_fs(KERNEL_DS) there.  To do so push the getname from do_mknodat into the
callers.  Remove the now unused ksys_mknod.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/internal.h            |  2 --
 fs/namei.c               | 18 +++++++++++++-----
 include/linux/fs.h       |  1 +
 include/linux/syscalls.h |  9 ---------
 init/do_mounts.h         |  2 +-
 init/initramfs.c         |  2 +-
 init/noinitramfs.c       |  5 ++---
 7 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 722d33a66d9645..1e7a72bd183e63 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -62,8 +62,6 @@ extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
 			   struct path *path, struct path *root);
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct path *);
-long do_mknodat(int dfd, const char __user *filename, umode_t mode,
-		unsigned int dev);
 long do_rmdir(int dfd, const char __user *pathname);
 long do_unlinkat(int dfd, struct filename *name);
 long do_symlinkat(const char __user *oldname, int newdfd,
diff --git a/fs/namei.c b/fs/namei.c
index 3545623495d1f4..de97edac21849d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3584,7 +3584,7 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-long do_mknodat(int dfd, const char __user *filename, umode_t mode,
+static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 		unsigned int dev)
 {
 	struct dentry *dentry;
@@ -3594,9 +3594,9 @@ long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 
 	error = may_mknod(mode);
 	if (error)
-		return error;
+		goto out_putname;
 retry:
-	dentry = user_path_create(dfd, filename, &path, lookup_flags);
+	dentry = filename_create(dfd, name, &path, lookup_flags);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
@@ -3625,18 +3625,26 @@ long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+out_putname:
+	if (!IS_ERR(name))
+		putname(name);
 	return error;
 }
 
+int kern_mknod(const char *filename, umode_t mode, unsigned int dev)
+{
+	return do_mknodat(AT_FDCWD, getname_kernel(filename), mode, dev);
+}
+
 SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 		unsigned int, dev)
 {
-	return do_mknodat(dfd, filename, mode, dev);
+	return do_mknodat(dfd, getname(filename), mode, dev);
 }
 
 SYSCALL_DEFINE3(mknod, const char __user *, filename, umode_t, mode, unsigned, dev)
 {
-	return do_mknodat(AT_FDCWD, filename, mode, dev);
+	return do_mknodat(AT_FDCWD, getname(filename), mode, dev);
 }
 
 int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3bbeeadf2ddd98..846a21a9b3e14c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3678,5 +3678,6 @@ int __init kern_chown(const char *filename, uid_t user, gid_t group, int flag);
 int __init kern_chmod(const char *filename, umode_t mode);
 int __init kern_utimes(const char *filename, struct timespec64 *tv, int flags);
 int kern_mkdir(const char *pathname, umode_t mode);
+int kern_mknod(const char *filename, umode_t mode, unsigned int dev);
 
 #endif /* _LINUX_FS_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 6aa1cd200425a4..3dfcae351a077d 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1293,15 +1293,6 @@ static inline long ksys_symlink(const char __user *oldname,
 	return do_symlinkat(oldname, AT_FDCWD, newname);
 }
 
-extern long do_mknodat(int dfd, const char __user *filename, umode_t mode,
-		       unsigned int dev);
-
-static inline long ksys_mknod(const char __user *filename, umode_t mode,
-			      unsigned int dev)
-{
-	return do_mknodat(AT_FDCWD, filename, mode, dev);
-}
-
 extern int do_linkat(int olddfd, const char __user *oldname, int newdfd,
 		     const char __user *newname, int flags);
 
diff --git a/init/do_mounts.h b/init/do_mounts.h
index c855b3f0e06d19..b9ec1d522f0ce1 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -16,7 +16,7 @@ extern int root_mountflags;
 static inline int create_dev(char *name, dev_t dev)
 {
 	ksys_unlink(name);
-	return ksys_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
+	return kern_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
 }
 
 #ifdef CONFIG_BLK_DEV_RAM
diff --git a/init/initramfs.c b/init/initramfs.c
index 40b97ca5fe8cde..f32226d0388100 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -351,7 +351,7 @@ static int __init do_name(void)
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
-			ksys_mknod(collected, mode, rdev);
+			kern_mknod(collected, mode, rdev);
 			kern_chown(collected, uid, gid, 0);
 			kern_chmod(collected, mode);
 			do_utime(collected, mtime);
diff --git a/init/noinitramfs.c b/init/noinitramfs.c
index 89109c1d633adb..8048777874e4f1 100644
--- a/init/noinitramfs.c
+++ b/init/noinitramfs.c
@@ -21,9 +21,8 @@ static int __init default_rootfs(void)
 	if (err < 0)
 		goto out;
 
-	err = ksys_mknod((const char __user __force *) "/dev/console",
-			S_IFCHR | S_IRUSR | S_IWUSR,
-			new_encode_dev(MKDEV(5, 1)));
+	err = kern_mknod("/dev/console", S_IFCHR | S_IRUSR | S_IWUSR,
+			 new_encode_dev(MKDEV(5, 1)));
 	if (err < 0)
 		goto out;
 
-- 
2.27.0
