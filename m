From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/21] init: add an init_rmdir helper
Date: Sun, 26 Jul 2020 09:13:45 +0200
Message-ID: <20200726071356.287160-11-hch@lst.de>
References: <20200726071356.287160-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200726071356.287160-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to rmdir with a kernel space file name and switch
the early init code over to it.  Remove the now unused ksys_rmdir.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/for_init.c                 | 5 +++++
 include/linux/init_syscalls.h | 1 +
 include/linux/syscalls.h      | 7 -------
 init/initramfs.c              | 2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/for_init.c b/fs/for_init.c
index 32472206d64136..1f10ebe78c1ba1 100644
--- a/fs/for_init.c
+++ b/fs/for_init.c
@@ -38,3 +38,8 @@ int __init init_unlink(const char *pathname)
 {
 	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
 }
+
+int __init init_rmdir(const char *pathname)
+{
+	return do_rmdir(AT_FDCWD, getname_kernel(pathname));
+}
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
index 00d597249549ee..abf3af563c0b3a 100644
--- a/include/linux/init_syscalls.h
+++ b/include/linux/init_syscalls.h
@@ -4,3 +4,4 @@ int __init init_mount(const char *dev_name, const char *dir_name,
 		const char *type_page, unsigned long flags, void *data_page);
 int __init init_umount(const char *name, int flags);
 int __init init_unlink(const char *pathname);
+int __init init_rmdir(const char *pathname);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 26f9738e5ab861..a7b14258d245e2 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1273,13 +1273,6 @@ int compat_ksys_ipc(u32 call, int first, int second,
  * The following kernel syscall equivalents are just wrappers to fs-internal
  * functions. Therefore, provide stubs to be inlined at the callsites.
  */
-long do_rmdir(int dfd, struct filename *name);
-
-static inline long ksys_rmdir(const char __user *pathname)
-{
-	return do_rmdir(AT_FDCWD, getname(pathname));
-}
-
 extern long do_mkdirat(int dfd, const char __user *pathname, umode_t mode);
 
 static inline long ksys_mkdir(const char __user *pathname, umode_t mode)
diff --git a/init/initramfs.c b/init/initramfs.c
index 574ab3755203da..1ceba88cfcc052 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -299,7 +299,7 @@ static void __init clean_path(char *path, umode_t fmode)
 
 	if (!vfs_lstat(path, &st) && (st.mode ^ fmode) & S_IFMT) {
 		if (S_ISDIR(st.mode))
-			ksys_rmdir(path);
+			init_rmdir(path);
 		else
 			init_unlink(path);
 	}
-- 
2.27.0
