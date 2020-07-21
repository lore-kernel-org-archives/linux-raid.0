From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/24] init: add an init_rmdir helper
Date: Tue, 21 Jul 2020 18:28:08 +0200
Message-ID: <20200721162818.197315-15-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200721162818.197315-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to rmdir with a kernel space file name and switch
the early init code over to it.  Remove the now unused ksys_rmdir.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/syscalls.h | 7 -------
 init/do_mounts.h         | 1 +
 init/fs.c                | 5 +++++
 init/initramfs.c         | 2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

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
diff --git a/init/do_mounts.h b/init/do_mounts.h
index d2f1f335b5b5b9..58605396d358d7 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -12,6 +12,7 @@
 int __init init_mount(const char *dev_name, const char *dir_name,
 		const char *type_page, unsigned long flags, void *data_page);
 int __init init_unlink(const char *pathname);
+int __init init_rmdir(const char *pathname);
 
 void  mount_block_root(char *name, int flags);
 void  mount_root(void);
diff --git a/init/fs.c b/init/fs.c
index 1bdb5dc5ec12ba..b69b2f949b6132 100644
--- a/init/fs.c
+++ b/init/fs.c
@@ -24,3 +24,8 @@ int __init init_unlink(const char *pathname)
 {
 	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
 }
+
+int __init init_rmdir(const char *pathname)
+{
+	return do_rmdir(AT_FDCWD, getname_kernel(pathname));
+}
diff --git a/init/initramfs.c b/init/initramfs.c
index 664be397c6b41e..41491149fb1f29 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -306,7 +306,7 @@ static void __init clean_path(char *path, umode_t fmode)
 
 	if (!vfs_lstat(path, &st) && (st.mode ^ fmode) & S_IFMT) {
 		if (S_ISDIR(st.mode))
-			ksys_rmdir(path);
+			init_rmdir(path);
 		else
 			init_unlink(path);
 	}
-- 
2.27.0
