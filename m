From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 18/24] fs: add a kern_rmdir helper
Date: Mon, 20 Jul 2020 17:58:56 +0200
Message-ID: <20200720155902.181712-19-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200720155902.181712-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Add a simple helper to rmdir with a kernel space file name and switch
the early init code over to it.  Remove the now unused ksys_rmdir.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/internal.h            |  1 -
 fs/namei.c               | 17 ++++++++++-------
 include/linux/fs.h       |  1 +
 include/linux/syscalls.h |  7 -------
 init/initramfs.c         |  2 +-
 5 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 62e17871f16316..11b5b99c8dc689 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -62,7 +62,6 @@ extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
 			   struct path *path, struct path *root);
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct path *);
-long do_rmdir(int dfd, const char __user *pathname);
 
 /*
  * namespace.c
diff --git a/fs/namei.c b/fs/namei.c
index 3cbaca386d3189..3de1476885a18a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3754,18 +3754,16 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 }
 EXPORT_SYMBOL(vfs_rmdir);
 
-long do_rmdir(int dfd, const char __user *pathname)
+static int do_rmdir(int dfd, struct filename *name)
 {
 	int error = 0;
-	struct filename *name;
 	struct dentry *dentry;
 	struct path path;
 	struct qstr last;
 	int type;
 	unsigned int lookup_flags = 0;
 retry:
-	name = filename_parentat(dfd, getname(pathname), lookup_flags,
-				&path, &last, &type);
+	name = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
@@ -3805,17 +3803,22 @@ long do_rmdir(int dfd, const char __user *pathname)
 	mnt_drop_write(path.mnt);
 exit1:
 	path_put(&path);
-	putname(name);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+	putname(name);
 	return error;
 }
 
+int __init kern_rmdir(const char *pathname)
+{
+	return do_rmdir(AT_FDCWD, getname_kernel(pathname));
+}
+
 SYSCALL_DEFINE1(rmdir, const char __user *, pathname)
 {
-	return do_rmdir(AT_FDCWD, pathname);
+	return do_rmdir(AT_FDCWD, getname(pathname));
 }
 
 /**
@@ -3965,7 +3968,7 @@ SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
 		return -EINVAL;
 
 	if (flag & AT_REMOVEDIR)
-		return do_rmdir(dfd, pathname);
+		return do_rmdir(dfd, getname(pathname));
 
 	return do_unlinkat(dfd, getname(pathname));
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 306e58ff54f69f..6100b9f92cee8b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3682,5 +3682,6 @@ int kern_mknod(const char *filename, umode_t mode, unsigned int dev);
 int __init kern_link(const char *oldname, const char *newname);
 int __init kern_symlink(const char *oldname, const char *newname);
 int kern_unlink(const char *pathname);
+int __init kern_rmdir(const char *pathname);
 
 #endif /* _LINUX_FS_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 483431765ac823..56c1fb4fadd666 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1270,13 +1270,6 @@ int compat_ksys_ipc(u32 call, int first, int second,
  * The following kernel syscall equivalents are just wrappers to fs-internal
  * functions. Therefore, provide stubs to be inlined at the callsites.
  */
-extern long do_rmdir(int dfd, const char __user *pathname);
-
-static inline long ksys_rmdir(const char __user *pathname)
-{
-	return do_rmdir(AT_FDCWD, pathname);
-}
-
 extern long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 
 static inline long ksys_ftruncate(unsigned int fd, loff_t length)
diff --git a/init/initramfs.c b/init/initramfs.c
index 86d3750a47499d..d72594298133a7 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -298,7 +298,7 @@ static void __init clean_path(char *path, umode_t fmode)
 
 	if (!vfs_lstat(path, &st) && (st.mode ^ fmode) & S_IFMT) {
 		if (S_ISDIR(st.mode))
-			ksys_rmdir(path);
+			kern_rmdir(path);
 		else
 			kern_unlink(path);
 	}
-- 
2.27.0
