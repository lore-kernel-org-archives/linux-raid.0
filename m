From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/24] fs: move the uid16 (f)chown syscalls to fs/open.c
Date: Mon, 20 Jul 2020 17:58:48 +0200
Message-ID: <20200720155902.181712-11-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200720155902.181712-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

This allows to keep the internal (f)chown helper private in open.c.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/open.c                | 25 ++++++++++++++++++++++---
 include/linux/syscalls.h |  4 ----
 kernel/uid16.c           | 17 -----------------
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 7d7456070503f2..8157db254c8f8a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -714,7 +714,7 @@ static int chown_common(const struct path *path, uid_t user, gid_t group)
 	return error;
 }
 
-int do_fchownat(int dfd, struct filename *name, uid_t user, gid_t group,
+static int do_fchownat(int dfd, struct filename *name, uid_t user, gid_t group,
 		int flag)
 {
 	struct path path;
@@ -787,7 +787,7 @@ int vfs_fchown(struct file *file, uid_t user, gid_t group)
 	return error;
 }
 
-int ksys_fchown(unsigned int fd, uid_t user, gid_t group)
+static int do_fchown(unsigned int fd, uid_t user, gid_t group)
 {
 	struct fd f = fdget(fd);
 	int error = -EBADF;
@@ -801,9 +801,28 @@ int ksys_fchown(unsigned int fd, uid_t user, gid_t group)
 
 SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group)
 {
-	return ksys_fchown(fd, user, group);
+	return do_fchown(fd, user, group);
 }
 
+#ifdef CONFIG_UID16
+SYSCALL_DEFINE3(chown16, const char __user *, filename, old_uid_t, user, old_gid_t, group)
+{
+	return do_fchownat(AT_FDCWD, getname(filename), low2highuid(user),
+			low2highgid(group), 0);
+}
+
+SYSCALL_DEFINE3(lchown16, const char __user *, filename, old_uid_t, user, old_gid_t, group)
+{
+	return do_fchownat(AT_FDCWD, getname(filename), low2highuid(user),
+			low2highgid(group), AT_SYMLINK_NOFOLLOW);
+}
+
+SYSCALL_DEFINE3(fchown16, unsigned int, fd, old_uid_t, user, old_gid_t, group)
+{
+	return do_fchown(fd, low2highuid(user), low2highgid(group));
+}
+#endif /* CONFIG_UID16 */
+
 static int do_dentry_open(struct file *f,
 			  struct inode *inode,
 			  int (*open)(struct inode *, struct file *))
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 42dd2715e07688..82346a68a73877 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1237,7 +1237,6 @@ asmlinkage long sys_ni_syscall(void);
  */
 
 ssize_t ksys_write(unsigned int fd, const char __user *buf, size_t count);
-int ksys_fchown(unsigned int fd, uid_t user, gid_t group);
 ssize_t ksys_read(unsigned int fd, char __user *buf, size_t count);
 void ksys_sync(void);
 int ksys_unshare(unsigned long unshare_flags);
@@ -1326,9 +1325,6 @@ static inline int ksys_chmod(const char __user *filename, umode_t mode)
 	return do_fchmodat(AT_FDCWD, filename, mode);
 }
 
-extern int do_fchownat(int dfd, struct filename *name, uid_t user,
-		       gid_t group, int flag);
-
 extern long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 
 static inline long ksys_ftruncate(unsigned int fd, loff_t length)
diff --git a/kernel/uid16.c b/kernel/uid16.c
index a332947e92d12e..ec2a5634e99af6 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -20,23 +20,6 @@
 
 #include "uid16.h"
 
-SYSCALL_DEFINE3(chown16, const char __user *, filename, old_uid_t, user, old_gid_t, group)
-{
-	return do_fchownat(AT_FDCWD, getname(filename), low2highuid(user),
-			low2highgid(group), 0);
-}
-
-SYSCALL_DEFINE3(lchown16, const char __user *, filename, old_uid_t, user, old_gid_t, group)
-{
-	return do_fchownat(AT_FDCWD, getname(filename), low2highuid(user),
-			low2highgid(group), AT_SYMLINK_NOFOLLOW);
-}
-
-SYSCALL_DEFINE3(fchown16, unsigned int, fd, old_uid_t, user, old_gid_t, group)
-{
-	return ksys_fchown(fd, low2highuid(user), low2highgid(group));
-}
-
 SYSCALL_DEFINE2(setregid16, old_gid_t, rgid, old_gid_t, egid)
 {
 	return __sys_setregid(low2highgid(rgid), low2highgid(egid));
-- 
2.27.0
