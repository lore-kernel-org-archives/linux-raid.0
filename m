From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 20/24] init: add an init_link helper
Date: Tue, 21 Jul 2020 18:28:14 +0200
Message-ID: <20200721162818.197315-21-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200721162818.197315-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Add a simple helper to link with a kernel space file name and switch
the early init code over to it.  Remove the now unused ksys_link.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/internal.h            |  3 +--
 fs/namei.c               |  4 ++--
 include/linux/syscalls.h |  9 ---------
 init/do_mounts.h         |  1 +
 init/fs.c                | 33 +++++++++++++++++++++++++++++++++
 init/initramfs.c         |  2 +-
 6 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 585968c0286cf7..9a1e937e484647 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -69,8 +69,7 @@ long do_rmdir(int dfd, struct filename *name);
 long do_unlinkat(int dfd, struct filename *name);
 long do_symlinkat(const char __user *oldname, int newdfd,
 		  const char __user *newname);
-int do_linkat(int olddfd, const char __user *oldname, int newdfd,
-	      const char __user *newname, int flags);
+int may_linkat(struct path *link);
 
 /*
  * namespace.c
diff --git a/fs/namei.c b/fs/namei.c
index d75a6039ae3966..13de64c6be7640 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1024,7 +1024,7 @@ static bool safe_hardlink_source(struct inode *inode)
  *
  * Returns 0 if successful, -ve on error.
  */
-static int may_linkat(struct path *link)
+int may_linkat(struct path *link)
 {
 	struct inode *inode = link->dentry->d_inode;
 
@@ -4086,7 +4086,7 @@ EXPORT_SYMBOL(vfs_link);
  * with linux 2.0, and to avoid hard-linking to directories
  * and other special files.  --ADM
  */
-int do_linkat(int olddfd, const char __user *oldname, int newdfd,
+static int do_linkat(int olddfd, const char __user *oldname, int newdfd,
 	      const char __user *newname, int flags)
 {
 	struct dentry *new_dentry;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a2779638e41445..4b18b91ce46573 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1295,15 +1295,6 @@ static inline long ksys_mknod(const char __user *filename, umode_t mode,
 	return do_mknodat(AT_FDCWD, filename, mode, dev);
 }
 
-extern int do_linkat(int olddfd, const char __user *oldname, int newdfd,
-		     const char __user *newname, int flags);
-
-static inline long ksys_link(const char __user *oldname,
-			     const char __user *newname)
-{
-	return do_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
-}
-
 extern int do_fchownat(int dfd, const char __user *filename, uid_t user,
 		       gid_t group, int flag);
 
diff --git a/init/do_mounts.h b/init/do_mounts.h
index b886aaa0d09716..c80105e47a8e66 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -16,6 +16,7 @@ int __init init_chroot(const char *filename);
 int __init init_chown(const char *filename, uid_t user, gid_t group, int flags);
 int __init init_chmod(const char *filename, umode_t mode);
 int __init init_eaccess(const char *filename);
+int __init init_link(const char *oldname, const char *newname);
 int __init init_unlink(const char *pathname);
 int __init init_rmdir(const char *pathname);
 
diff --git a/init/fs.c b/init/fs.c
index 9929cdd19affbe..fb5fb7aa498485 100644
--- a/init/fs.c
+++ b/init/fs.c
@@ -103,6 +103,39 @@ int __init init_eaccess(const char *filename)
 	return error;
 }
 
+int __init init_link(const char *oldname, const char *newname)
+{
+	struct dentry *new_dentry;
+	struct path old_path, new_path;
+	int error;
+
+	error = kern_path(oldname, 0, &old_path);
+	if (error)
+		return error;
+
+	new_dentry = kern_path_create(AT_FDCWD, newname, &new_path, 0);
+	error = PTR_ERR(new_dentry);
+	if (IS_ERR(new_dentry))
+		goto out;
+
+	error = -EXDEV;
+	if (old_path.mnt != new_path.mnt)
+		goto out_dput;
+	error = may_linkat(&old_path);
+	if (unlikely(error))
+		goto out_dput;
+	error = security_path_link(old_path.dentry, &new_path, new_dentry);
+	if (error)
+		goto out_dput;
+	error = vfs_link(old_path.dentry, new_path.dentry->d_inode, new_dentry,
+			 NULL);
+out_dput:
+	done_path_create(&new_path, new_dentry);
+out:
+	path_put(&old_path);
+	return error;
+}
+
 int __init init_unlink(const char *pathname)
 {
 	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
diff --git a/init/initramfs.c b/init/initramfs.c
index 771da27e87afa1..bdc3c0ec5a6c31 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -318,7 +318,7 @@ static int __init maybe_link(void)
 		char *old = find_link(major, minor, ino, mode, collected);
 		if (old) {
 			clean_path(collected, 0);
-			return (ksys_link(old, collected) < 0) ? -1 : 1;
+			return (init_link(old, collected) < 0) ? -1 : 1;
 		}
 	}
 	return 0;
-- 
2.27.0
