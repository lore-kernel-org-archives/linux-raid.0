From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/23] init: add an init_link helper
Date: Tue, 28 Jul 2020 18:34:10 +0200
Message-ID: <20200728163416.556521-18-hch@lst.de>
References: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200728163416.556521-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to link with a kernel space file name and switch
the early init code over to it.  Remove the now unused ksys_link.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/init.c                     | 33 +++++++++++++++++++++++++++++++++
 fs/internal.h                 |  3 +--
 fs/namei.c                    |  4 ++--
 include/linux/init_syscalls.h |  1 +
 include/linux/syscalls.h      |  9 ---------
 init/initramfs.c              |  2 +-
 6 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index 6d9af40d2897b1..5db9d9f74868e1 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -122,6 +122,39 @@ int __init init_eaccess(const char *filename)
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
diff --git a/fs/internal.h b/fs/internal.h
index 6d82681c7d8372..58451b033d2698 100644
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
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
index 7031c0934bee9f..5ca15a5b55b7d7 100644
--- a/include/linux/init_syscalls.h
+++ b/include/linux/init_syscalls.h
@@ -8,5 +8,6 @@ int __init init_chroot(const char *filename);
 int __init init_chown(const char *filename, uid_t user, gid_t group, int flags);
 int __init init_chmod(const char *filename, umode_t mode);
 int __init init_eaccess(const char *filename);
+int __init init_link(const char *oldname, const char *newname);
 int __init init_unlink(const char *pathname);
 int __init init_rmdir(const char *pathname);
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
 
diff --git a/init/initramfs.c b/init/initramfs.c
index 21a75f6ca893a9..a3d29318cc351d 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -312,7 +312,7 @@ static int __init maybe_link(void)
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
