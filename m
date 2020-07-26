From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/21] init: add an init_eaccess helper
Date: Sun, 26 Jul 2020 09:13:50 +0200
Message-ID: <20200726071356.287160-16-hch@lst.de>
References: <20200726071356.287160-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200726071356.287160-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to check if a file exists based on kernel space file
name and switch the early init code over to it.  Note that this
theoretically changes behavior as it always is based on the effective
permissions.  But during early init that doesn't make a difference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/for_init.c                 | 13 +++++++++++++
 fs/open.c                     |  2 +-
 include/linux/init_syscalls.h |  1 +
 include/linux/syscalls.h      |  7 -------
 init/main.c                   |  4 ++--
 5 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/for_init.c b/fs/for_init.c
index 098e9b69c32ef6..abc152f41e648b 100644
--- a/fs/for_init.c
+++ b/fs/for_init.c
@@ -105,6 +105,19 @@ int __init init_chmod(const char *filename, umode_t mode)
 	return error;
 }
 
+int __init init_eaccess(const char *filename)
+{
+	struct path path;
+	int error;
+
+	error = kern_path(filename, LOOKUP_FOLLOW, &path);
+	if (error)
+		return error;
+	error = inode_permission(d_inode(path.dentry), MAY_ACCESS);
+	path_put(&path);
+	return error;
+}
+
 int __init init_unlink(const char *pathname)
 {
 	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
diff --git a/fs/open.c b/fs/open.c
index 7ba89eae46c560..aafecd1f7ba1a5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -394,7 +394,7 @@ static const struct cred *access_override_creds(void)
 	return old_cred;
 }
 
-long do_faccessat(int dfd, const char __user *filename, int mode, int flags)
+static long do_faccessat(int dfd, const char __user *filename, int mode, int flags)
 {
 	struct path path;
 	struct inode *inode;
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
index 2b1b4dc586825f..7031c0934bee9f 100644
--- a/include/linux/init_syscalls.h
+++ b/include/linux/init_syscalls.h
@@ -7,5 +7,6 @@ int __init init_chdir(const char *filename);
 int __init init_chroot(const char *filename);
 int __init init_chown(const char *filename, uid_t user, gid_t group, int flags);
 int __init init_chmod(const char *filename, umode_t mode);
+int __init init_eaccess(const char *filename);
 int __init init_unlink(const char *pathname);
 int __init init_rmdir(const char *pathname);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 8b71fa321ca20c..a2779638e41445 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1304,13 +1304,6 @@ static inline long ksys_link(const char __user *oldname,
 	return do_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
 
-long do_faccessat(int dfd, const char __user *filename, int mode, int flags);
-
-static inline long ksys_access(const char __user *filename, int mode)
-{
-	return do_faccessat(AT_FDCWD, filename, mode, 0);
-}
-
 extern int do_fchownat(int dfd, const char __user *filename, uid_t user,
 		       gid_t group, int flag);
 
diff --git a/init/main.c b/init/main.c
index c2c9143db96795..6e2a4a078b78c4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -96,6 +96,7 @@
 #include <linux/jump_label.h>
 #include <linux/mem_encrypt.h>
 #include <linux/kcsan.h>
+#include <linux/init_syscalls.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -1514,8 +1515,7 @@ static noinline void __init kernel_init_freeable(void)
 	 * check if there is an early userspace init.  If yes, let it do all
 	 * the work
 	 */
-	if (ksys_access((const char __user *)
-			ramdisk_execute_command, 0) != 0) {
+	if (init_eaccess(ramdisk_execute_command) != 0) {
 		ramdisk_execute_command = NULL;
 		prepare_namespace();
 	}
-- 
2.27.0
