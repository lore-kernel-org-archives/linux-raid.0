From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/24] fs: add a kern_utimes helper
Date: Mon, 20 Jul 2020 17:58:50 +0200
Message-ID: <20200720155902.181712-13-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to set timestamps with a kernel space name and use it
in the early init code instead of relying on the implicit
set_fs(KERNEL_DS) there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/utimes.c        | 19 ++++++++++++++-----
 include/linux/fs.h |  1 +
 init/initramfs.c   |  2 +-
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index fd3cc42262241f..f4d7f9a73e115a 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -7,6 +7,7 @@
 #include <linux/uaccess.h>
 #include <linux/compat.h>
 #include <asm/unistd.h>
+#include "internal.h"
 
 static bool nsec_valid(long nsec)
 {
@@ -75,14 +76,15 @@ int vfs_utimes(const struct path *path, struct timespec64 *times)
 	return error;
 }
 
-static int do_utimes_path(int dfd, const char __user *filename,
+static int do_utimes_path(int dfd, struct filename *name,
 		struct timespec64 *times, int flags)
 {
 	struct path path;
 	int lookup_flags = 0, error;
 
+	error = -EINVAL;
 	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
-		return -EINVAL;
+		goto out_putname;
 
 	if (!(flags & AT_SYMLINK_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
@@ -90,7 +92,7 @@ static int do_utimes_path(int dfd, const char __user *filename,
 		lookup_flags |= LOOKUP_EMPTY;
 
 retry:
-	error = user_path_at(dfd, filename, lookup_flags, &path);
+	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (error)
 		return error;
 
@@ -100,10 +102,17 @@ static int do_utimes_path(int dfd, const char __user *filename,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-
+out_putname:
+	if (!IS_ERR(name))
+		putname(name);
 	return error;
 }
 
+int __init kern_utimes(const char *filename, struct timespec64 *tv, int flags)
+{
+	return do_utimes_path(AT_FDCWD, getname_kernel(filename), tv, flags);
+}
+
 static int do_utimes_fd(int fd, struct timespec64 *times, int flags)
 {
 	struct fd f;
@@ -140,7 +149,7 @@ long do_utimes(int dfd, const char __user *filename, struct timespec64 *times,
 {
 	if (filename == NULL && dfd != AT_FDCWD)
 		return do_utimes_fd(dfd, times, flags);
-	return do_utimes_path(dfd, filename, times, flags);
+	return do_utimes_path(dfd, getname(filename), times, flags);
 }
 
 SYSCALL_DEFINE4(utimensat, int, dfd, const char __user *, filename,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ca034126cb0e4d..7472ff0b7062d9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3676,5 +3676,6 @@ int kern_chroot(const char *filename);
 int __init kern_access(const char *filename, int mode);
 int __init kern_chown(const char *filename, uid_t user, gid_t group, int flag);
 int __init kern_chmod(const char *filename, umode_t mode);
+int __init kern_utimes(const char *filename, struct timespec64 *tv, int flags);
 
 #endif /* _LINUX_FS_H */
diff --git a/init/initramfs.c b/init/initramfs.c
index 2c2d4480d495e8..de850d4c6da200 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -110,7 +110,7 @@ static long __init do_utime(char *filename, time64_t mtime)
 	t[1].tv_sec = mtime;
 	t[1].tv_nsec = 0;
 
-	return do_utimes(AT_FDCWD, filename, t, AT_SYMLINK_NOFOLLOW);
+	return kern_utimes(filename, t, 0);
 }
 
 static __initdata LIST_HEAD(dir_list);
-- 
2.27.0
