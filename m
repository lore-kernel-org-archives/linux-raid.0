From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/24] fs: add a kern_symlink helper
Date: Mon, 20 Jul 2020 17:58:54 +0200
Message-ID: <20200720155902.181712-17-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper perform a symlink with a kernel space file name and
use it in the early init code instead of relying on the implicit
set_fs(KERNEL_DS) there.  To do so push the getname from do_symlinkat
into the callers.  Remove the now unused ksys_symlink.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/internal.h            |  2 --
 fs/namei.c               | 27 ++++++++++++++++++---------
 include/linux/fs.h       |  1 +
 include/linux/syscalls.h |  9 ---------
 init/initramfs.c         |  2 +-
 5 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index f0869d5dc4dbfa..46f727c0bd84e2 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -64,8 +64,6 @@ extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct path *);
 long do_rmdir(int dfd, const char __user *pathname);
 long do_unlinkat(int dfd, struct filename *name);
-long do_symlinkat(const char __user *oldname, int newdfd,
-		  const char __user *newname);
 
 /*
  * namespace.c
diff --git a/fs/namei.c b/fs/namei.c
index 9d80a5bce1051a..01e43676008644 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3991,20 +3991,21 @@ int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-long do_symlinkat(const char __user *oldname, int newdfd,
-		  const char __user *newname)
+static int do_symlinkat(struct filename *from, int newdfd,
+			struct filename *newname)
 {
 	int error;
-	struct filename *from;
 	struct dentry *dentry;
 	struct path path;
 	unsigned int lookup_flags = 0;
 
-	from = getname(oldname);
-	if (IS_ERR(from))
+	if (IS_ERR(from)) {
+		if (!IS_ERR(newname))
+			putname(newname);
 		return PTR_ERR(from);
+	}
 retry:
-	dentry = user_path_create(newdfd, newname, &path, lookup_flags);
+	dentry = filename_create(newdfd, newname, &path, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto out_putname;
@@ -4017,20 +4018,28 @@ long do_symlinkat(const char __user *oldname, int newdfd,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+	putname(newname);
 out_putname:
-	putname(from);
+	if (!IS_ERR(from))
+		putname(from);
 	return error;
 }
 
+int __init kern_symlink(const char *oldname, const char *newname)
+{
+	return do_symlinkat(getname_kernel(oldname), AT_FDCWD,
+			    getname_kernel(newname));
+}
+
 SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
-	return do_symlinkat(oldname, newdfd, newname);
+	return do_symlinkat(getname(oldname), newdfd, getname(newname));
 }
 
 SYSCALL_DEFINE2(symlink, const char __user *, oldname, const char __user *, newname)
 {
-	return do_symlinkat(oldname, AT_FDCWD, newname);
+	return do_symlinkat(getname(oldname), AT_FDCWD, getname(newname));
 }
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fc3b09d473945f..7a7b3bf1b8aa53 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3680,5 +3680,6 @@ int __init kern_utimes(const char *filename, struct timespec64 *tv, int flags);
 int kern_mkdir(const char *pathname, umode_t mode);
 int kern_mknod(const char *filename, umode_t mode, unsigned int dev);
 int __init kern_link(const char *oldname, const char *newname);
+int __init kern_symlink(const char *oldname, const char *newname);
 
 #endif /* _LINUX_FS_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 467cc4413874ed..474d5d165048c8 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1284,15 +1284,6 @@ static inline long ksys_rmdir(const char __user *pathname)
 	return do_rmdir(AT_FDCWD, pathname);
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
 extern long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 
 static inline long ksys_ftruncate(unsigned int fd, loff_t length)
diff --git a/init/initramfs.c b/init/initramfs.c
index e484381c6c131b..4efd78427996da 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -389,7 +389,7 @@ static int __init do_symlink(void)
 {
 	collected[N_ALIGN(name_len) + body_len] = '\0';
 	clean_path(collected, 0);
-	ksys_symlink(collected + N_ALIGN(name_len), collected);
+	kern_symlink(collected + N_ALIGN(name_len), collected);
 	kern_chown(collected, uid, gid, AT_SYMLINK_NOFOLLOW);
 	do_utime(collected, mtime);
 	state = SkipIt;
-- 
2.27.0
