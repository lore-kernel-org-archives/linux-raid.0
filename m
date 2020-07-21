From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/24] init: add an init_symlink helper
Date: Tue, 21 Jul 2020 18:28:15 +0200
Message-ID: <20200721162818.197315-22-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200721162818.197315-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to symlink with a kernel space file name and switch
the early init code over to it.  Remove the now unused ksys_symlink.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/internal.h            |  2 --
 fs/namei.c               |  2 +-
 include/linux/syscalls.h |  9 ---------
 init/do_mounts.h         |  1 +
 init/fs.c                | 22 ++++++++++++++++++++++
 init/initramfs.c         |  2 +-
 6 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 9a1e937e484647..ad89db759513c4 100644
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
 
diff --git a/init/do_mounts.h b/init/do_mounts.h
index c80105e47a8e66..30287ac3106dba 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -17,6 +17,7 @@ int __init init_chown(const char *filename, uid_t user, gid_t group, int flags);
 int __init init_chmod(const char *filename, umode_t mode);
 int __init init_eaccess(const char *filename);
 int __init init_link(const char *oldname, const char *newname);
+int __init init_symlink(const char *oldname, const char *newname);
 int __init init_unlink(const char *pathname);
 int __init init_rmdir(const char *pathname);
 
diff --git a/init/fs.c b/init/fs.c
index fb5fb7aa498485..8ffca538a8133f 100644
--- a/init/fs.c
+++ b/init/fs.c
@@ -136,6 +136,28 @@ int __init init_link(const char *oldname, const char *newname)
 	return error;
 }
 
+int __init init_symlink(const char *oldname, const char *newname)
+{
+	struct filename *from = getname_kernel(oldname);
+	struct dentry *dentry;
+	struct path path;
+	int error;
+
+	if (IS_ERR(from))
+		return PTR_ERR(from);
+	dentry = kern_path_create(AT_FDCWD, newname, &path, 0);
+	error = PTR_ERR(dentry);
+	if (IS_ERR(dentry))
+		goto out_putname;
+	error = security_path_symlink(&path, dentry, from->name);
+	if (!error)
+		error = vfs_symlink(path.dentry->d_inode, dentry, from->name);
+	done_path_create(&path, dentry);
+out_putname:
+	putname(from);
+	return error;
+}
+
 int __init init_unlink(const char *pathname)
 {
 	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
diff --git a/init/initramfs.c b/init/initramfs.c
index bdc3c0ec5a6c31..5dd234cd2ecf12 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -397,7 +397,7 @@ static int __init do_symlink(void)
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
