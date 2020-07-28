From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/23] init: add an init_symlink helper
Date: Tue, 28 Jul 2020 18:34:11 +0200
Message-ID: <20200728163416.556521-19-hch@lst.de>
References: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200728163416.556521-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to symlink with a kernel space file name and switch
the early init code over to it.  Remove the now unused ksys_symlink.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/init.c                     | 16 ++++++++++++++++
 fs/internal.h                 |  2 --
 fs/namei.c                    |  2 +-
 include/linux/init_syscalls.h |  1 +
 include/linux/syscalls.h      |  9 ---------
 init/initramfs.c              |  2 +-
 6 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index 5db9d9f74868e1..09ef2b58d48caa 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -155,6 +155,22 @@ int __init init_link(const char *oldname, const char *newname)
 	return error;
 }
 
+int __init init_symlink(const char *oldname, const char *newname)
+{
+	struct dentry *dentry;
+	struct path path;
+	int error;
+
+	dentry = kern_path_create(AT_FDCWD, newname, &path, 0);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+	error = security_path_symlink(&path, dentry, oldname);
+	if (!error)
+		error = vfs_symlink(path.dentry->d_inode, dentry, oldname);
+	done_path_create(&path, dentry);
+	return error;
+}
+
 int __init init_unlink(const char *pathname)
 {
 	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
diff --git a/fs/internal.h b/fs/internal.h
index 58451b033d2698..40b50a222d7a22 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -67,8 +67,6 @@ long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 long do_mkdirat(int dfd, const char __user *pathname, umode_t mode);
 long do_rmdir(int dfd, struct filename *name);
 long do_unlinkat(int dfd, struct filename *name);
-long do_symlinkat(const char __user *oldname, int newdfd,
-		  const char __user *newname);
 int may_linkat(struct path *link);
 
 /*
diff --git a/fs/namei.c b/fs/namei.c
index 13de64c6be7640..2f6fa53eb3da28 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3955,7 +3955,7 @@ int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-long do_symlinkat(const char __user *oldname, int newdfd,
+static long do_symlinkat(const char __user *oldname, int newdfd,
 		  const char __user *newname)
 {
 	int error;
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
index 5ca15a5b55b7d7..125f55ae3f80b8 100644
--- a/include/linux/init_syscalls.h
+++ b/include/linux/init_syscalls.h
@@ -9,5 +9,6 @@ int __init init_chown(const char *filename, uid_t user, gid_t group, int flags);
 int __init init_chmod(const char *filename, umode_t mode);
 int __init init_eaccess(const char *filename);
 int __init init_link(const char *oldname, const char *newname);
+int __init init_symlink(const char *oldname, const char *newname);
 int __init init_unlink(const char *pathname);
 int __init init_rmdir(const char *pathname);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4b18b91ce46573..7cdc0d749a049f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1277,15 +1277,6 @@ static inline long ksys_mkdir(const char __user *pathname, umode_t mode)
 	return do_mkdirat(AT_FDCWD, pathname, mode);
 }
 
-extern long do_symlinkat(const char __user *oldname, int newdfd,
-			 const char __user *newname);
-
-static inline long ksys_symlink(const char __user *oldname,
-				const char __user *newname)
-{
-	return do_symlinkat(oldname, AT_FDCWD, newname);
-}
-
 extern long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 		       unsigned int dev);
 
diff --git a/init/initramfs.c b/init/initramfs.c
index a3d29318cc351d..b74d18657e7a17 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -393,7 +393,7 @@ static int __init do_symlink(void)
 {
 	collected[N_ALIGN(name_len) + body_len] = '\0';
 	clean_path(collected, 0);
-	ksys_symlink(collected + N_ALIGN(name_len), collected);
+	init_symlink(collected + N_ALIGN(name_len), collected);
 	init_chown(collected, uid, gid, AT_SYMLINK_NOFOLLOW);
 	do_utime(collected, mtime);
 	state = SkipIt;
-- 
2.27.0
