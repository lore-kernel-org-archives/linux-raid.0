From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/24] init: add an init_eaccess helper
Date: Tue, 21 Jul 2020 18:28:13 +0200
Message-ID: <20200721162818.197315-20-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200721162818.197315-1-hch@lst.de>
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
 fs/open.c                |  2 +-
 include/linux/syscalls.h |  7 -------
 init/do_mounts.h         |  1 +
 init/fs.c                | 13 +++++++++++++
 init/main.c              |  3 +--
 5 files changed, 16 insertions(+), 10 deletions(-)

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
 
diff --git a/init/do_mounts.h b/init/do_mounts.h
index b323d9755d7e5e..b886aaa0d09716 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -15,6 +15,7 @@ int __init init_chdir(const char *filename);
 int __init init_chroot(const char *filename);
 int __init init_chown(const char *filename, uid_t user, gid_t group, int flags);
 int __init init_chmod(const char *filename, umode_t mode);
+int __init init_eaccess(const char *filename);
 int __init init_unlink(const char *pathname);
 int __init init_rmdir(const char *pathname);
 
diff --git a/init/fs.c b/init/fs.c
index c636f25c9a6d69..9929cdd19affbe 100644
--- a/init/fs.c
+++ b/init/fs.c
@@ -90,6 +90,19 @@ int __init init_chmod(const char *filename, umode_t mode)
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
diff --git a/init/main.c b/init/main.c
index b952e4cd685af4..227e206b9ffee2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1516,8 +1516,7 @@ static noinline void __init kernel_init_freeable(void)
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
