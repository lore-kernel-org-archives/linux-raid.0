From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 22/23] init: add an init_utimes helper
Date: Tue, 28 Jul 2020 18:34:15 +0200
Message-ID: <20200728163416.556521-23-hch@lst.de>
References: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200728163416.556521-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Add a simple helper to set timestamps with a kernel space file name and
switch the early init code over to it.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/init.c                     | 13 +++++++++++++
 include/linux/init_syscalls.h |  1 +
 init/initramfs.c              |  3 +--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index 51646ba38099e6..db5c48a85644fa 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -238,3 +238,16 @@ int __init init_rmdir(const char *pathname)
 {
 	return do_rmdir(AT_FDCWD, getname_kernel(pathname));
 }
+
+int __init init_utimes(char *filename, struct timespec64 *ts)
+{
+	struct path path;
+	int error;
+
+	error = kern_path(filename, 0, &path);
+	if (error)
+		return error;
+	error = vfs_utimes(&path, ts);
+	path_put(&path);
+	return error;
+}
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
index b2fda50daca6c5..3654b525ac0b17 100644
--- a/include/linux/init_syscalls.h
+++ b/include/linux/init_syscalls.h
@@ -15,3 +15,4 @@ int __init init_symlink(const char *oldname, const char *newname);
 int __init init_unlink(const char *pathname);
 int __init init_mkdir(const char *pathname, umode_t mode);
 int __init init_rmdir(const char *pathname);
+int __init init_utimes(char *filename, struct timespec64 *ts);
diff --git a/init/initramfs.c b/init/initramfs.c
index 8f7e39f06547ff..d5351737624edd 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -111,8 +111,7 @@ static long __init do_utime(char *filename, time64_t mtime)
 	t[0].tv_nsec = 0;
 	t[1].tv_sec = mtime;
 	t[1].tv_nsec = 0;
-
-	return do_utimes(AT_FDCWD, filename, t, AT_SYMLINK_NOFOLLOW);
+	return init_utimes(filename, t);
 }
 
 static __initdata LIST_HEAD(dir_list);
-- 
2.27.0
