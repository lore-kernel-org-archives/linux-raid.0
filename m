From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/24] fs: add a kern_link helper
Date: Mon, 20 Jul 2020 17:58:53 +0200
Message-ID: <20200720155902.181712-16-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper perform a link with a kernel space file name and use
it in the early init code instead of relying on the implicit
set_fs(KERNEL_DS) there.  To do so push the getname from do_linkat into the
callers.  Remove the now unused ksys_link.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/internal.h            |  2 --
 fs/namei.c               | 39 +++++++++++++++++++++++++++++----------
 include/linux/fs.h       |  1 +
 include/linux/syscalls.h |  9 ---------
 init/initramfs.c         |  2 +-
 5 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 1e7a72bd183e63..f0869d5dc4dbfa 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -66,8 +66,6 @@ long do_rmdir(int dfd, const char __user *pathname);
 long do_unlinkat(int dfd, struct filename *name);
 long do_symlinkat(const char __user *oldname, int newdfd,
 		  const char __user *newname);
-int do_linkat(int olddfd, const char __user *oldname, int newdfd,
-	      const char __user *newname, int flags);
 
 /*
  * namespace.c
diff --git a/fs/namei.c b/fs/namei.c
index de97edac21849d..9d80a5bce1051a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4122,8 +4122,8 @@ EXPORT_SYMBOL(vfs_link);
  * with linux 2.0, and to avoid hard-linking to directories
  * and other special files.  --ADM
  */
-int do_linkat(int olddfd, const char __user *oldname, int newdfd,
-	      const char __user *newname, int flags)
+static int do_linkat(int olddfd, struct filename *oldname, int newdfd,
+	      struct filename *newname, int flags)
 {
 	struct dentry *new_dentry;
 	struct path old_path, new_path;
@@ -4131,27 +4131,29 @@ int do_linkat(int olddfd, const char __user *oldname, int newdfd,
 	int how = 0;
 	int error;
 
+	error = -EINVAL;
 	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0)
-		return -EINVAL;
+		goto out_put_both_names;
 	/*
 	 * To use null names we require CAP_DAC_READ_SEARCH
 	 * This ensures that not everyone will be able to create
 	 * handlink using the passed filedescriptor.
 	 */
 	if (flags & AT_EMPTY_PATH) {
+		error = -ENOENT;
 		if (!capable(CAP_DAC_READ_SEARCH))
-			return -ENOENT;
+			goto out_put_both_names;
 		how = LOOKUP_EMPTY;
 	}
 
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
 retry:
-	error = user_path_at(olddfd, oldname, how, &old_path);
+	error = filename_lookup(olddfd, oldname, how, &old_path, NULL);
 	if (error)
-		return error;
+		goto out_put_newname;
 
-	new_dentry = user_path_create(newdfd, newname, &new_path,
+	new_dentry = filename_create(newdfd, newname, &new_path,
 					(how & LOOKUP_REVAL));
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
@@ -4181,21 +4183,38 @@ int do_linkat(int olddfd, const char __user *oldname, int newdfd,
 		how |= LOOKUP_REVAL;
 		goto retry;
 	}
+	putname(newname);
 out:
 	path_put(&old_path);
-
+	putname(oldname);
+	return error;
+out_put_both_names:
+	if (!IS_ERR(oldname))
+		putname(oldname);
+out_put_newname:
+	if (!IS_ERR(newname))
+		putname(newname);
 	return error;
 }
 
+int __init kern_link(const char *oldname, const char *newname)
+{
+	return do_linkat(AT_FDCWD, getname_kernel(oldname), AT_FDCWD,
+			 getname_kernel(newname), 0);
+}
+
 SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname, int, flags)
 {
-	return do_linkat(olddfd, oldname, newdfd, newname, flags);
+	int how = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
+
+	return do_linkat(olddfd, getname_flags(oldname, how, NULL), newdfd,
+			 getname(newname), flags);
 }
 
 SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname)
 {
-	return do_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
+	return do_linkat(AT_FDCWD, getname(oldname), AT_FDCWD, getname(newname), 0);
 }
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 846a21a9b3e14c..fc3b09d473945f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3679,5 +3679,6 @@ int __init kern_chmod(const char *filename, umode_t mode);
 int __init kern_utimes(const char *filename, struct timespec64 *tv, int flags);
 int kern_mkdir(const char *pathname, umode_t mode);
 int kern_mknod(const char *filename, umode_t mode, unsigned int dev);
+int __init kern_link(const char *oldname, const char *newname);
 
 #endif /* _LINUX_FS_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3dfcae351a077d..467cc4413874ed 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1293,15 +1293,6 @@ static inline long ksys_symlink(const char __user *oldname,
 	return do_symlinkat(oldname, AT_FDCWD, newname);
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
 extern long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 
 static inline long ksys_ftruncate(unsigned int fd, loff_t length)
diff --git a/init/initramfs.c b/init/initramfs.c
index f32226d0388100..e484381c6c131b 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -310,7 +310,7 @@ static int __init maybe_link(void)
 		char *old = find_link(major, minor, ino, mode, collected);
 		if (old) {
 			clean_path(collected, 0);
-			return (ksys_link(old, collected) < 0) ? -1 : 1;
+			return (kern_link(old, collected) < 0) ? -1 : 1;
 		}
 	}
 	return 0;
-- 
2.27.0
