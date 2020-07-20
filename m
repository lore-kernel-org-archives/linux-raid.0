From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 11/24] fs: add a kern_chmod helper
Date: Mon, 20 Jul 2020 17:58:49 +0200
Message-ID: <20200720155902.181712-12-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200720155902.181712-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Add a simple helper to chown with a kernel space name and use it in the
early init code instead of relying on the implicit set_fs(KERNEL_DS)
there.  Remove the now unused ksys_chmod.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/internal.h            |  1 -
 fs/open.c                | 28 +++++++++++++++++-----------
 include/linux/fs.h       |  1 +
 include/linux/syscalls.h |  7 -------
 init/initramfs.c         |  4 ++--
 5 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index ad62729e7ae587..1e2b425f56ee9e 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -126,7 +126,6 @@ extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
 
 long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
-int do_fchmodat(int dfd, const char __user *filename, umode_t mode);
 
 extern int vfs_open(const struct path *, struct file *);
 
diff --git a/fs/open.c b/fs/open.c
index 8157db254c8f8a..bb8ffc24c4b034 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -643,33 +643,39 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
 	return err;
 }
 
-int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
+static int do_fchmodat(int dfd, struct filename *name, umode_t mode)
 {
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
 retry:
-	error = user_path_at(dfd, filename, lookup_flags, &path);
-	if (!error) {
-		error = chmod_common(&path, mode);
-		path_put(&path);
-		if (retry_estale(error, lookup_flags)) {
-			lookup_flags |= LOOKUP_REVAL;
-			goto retry;
-		}
+	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
+	if (error)
+		return error;
+	error = chmod_common(&path, mode);
+	path_put(&path);
+	if (retry_estale(error, lookup_flags)) {
+		lookup_flags |= LOOKUP_REVAL;
+		goto retry;
 	}
+	putname(name);
 	return error;
 }
 
+int __init kern_chmod(const char *filename, umode_t mode)
+{
+	return do_fchmodat(AT_FDCWD, getname_kernel(filename), mode);
+}
+
 SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename,
 		umode_t, mode)
 {
-	return do_fchmodat(dfd, filename, mode);
+	return do_fchmodat(dfd, getname(filename), mode);
 }
 
 SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
 {
-	return do_fchmodat(AT_FDCWD, filename, mode);
+	return do_fchmodat(AT_FDCWD, getname(filename), mode);
 }
 
 static int chown_common(const struct path *path, uid_t user, gid_t group)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 75d6ef7e1de52b..ca034126cb0e4d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3675,5 +3675,6 @@ int kern_chdir(const char *filename);
 int kern_chroot(const char *filename);
 int __init kern_access(const char *filename, int mode);
 int __init kern_chown(const char *filename, uid_t user, gid_t group, int flag);
+int __init kern_chmod(const char *filename, umode_t mode);
 
 #endif /* _LINUX_FS_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 82346a68a73877..a2ece4cc8692f5 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1318,13 +1318,6 @@ static inline long ksys_link(const char __user *oldname,
 	return do_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
 
-extern int do_fchmodat(int dfd, const char __user *filename, umode_t mode);
-
-static inline int ksys_chmod(const char __user *filename, umode_t mode)
-{
-	return do_fchmodat(AT_FDCWD, filename, mode);
-}
-
 extern long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 
 static inline long ksys_ftruncate(unsigned int fd, loff_t length)
diff --git a/init/initramfs.c b/init/initramfs.c
index 45e4ddb63caba1..2c2d4480d495e8 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -346,14 +346,14 @@ static int __init do_name(void)
 	} else if (S_ISDIR(mode)) {
 		ksys_mkdir(collected, mode);
 		kern_chown(collected, uid, gid, 0);
-		ksys_chmod(collected, mode);
+		kern_chmod(collected, mode);
 		dir_add(collected, mtime);
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
 			ksys_mknod(collected, mode, rdev);
 			kern_chown(collected, uid, gid, 0);
-			ksys_chmod(collected, mode);
+			kern_chmod(collected, mode);
 			do_utime(collected, mtime);
 		}
 	}
-- 
2.27.0
