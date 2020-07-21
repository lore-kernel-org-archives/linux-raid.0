From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/24] init: add an init_chroot helper
Date: Tue, 21 Jul 2020 18:28:10 +0200
Message-ID: <20200721162818.197315-17-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200721162818.197315-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to chroot with a kernel space file name and switch
the early init code over to it.  Remove the now unused ksys_chroot.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/open.c                |  7 +------
 include/linux/syscalls.h |  2 --
 init/do_mounts.c         |  2 +-
 init/do_mounts.h         |  1 +
 init/do_mounts_initrd.c  |  4 ++--
 init/fs.c                | 23 +++++++++++++++++++++++
 6 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 723e0ac898935e..f62f4752bb436d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -530,7 +530,7 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd)
 	return error;
 }
 
-int ksys_chroot(const char __user *filename)
+SYSCALL_DEFINE1(chroot, const char __user *, filename)
 {
 	struct path path;
 	int error;
@@ -563,11 +563,6 @@ int ksys_chroot(const char __user *filename)
 	return error;
 }
 
-SYSCALL_DEFINE1(chroot, const char __user *, filename)
-{
-	return ksys_chroot(filename);
-}
-
 static int chmod_common(const struct path *path, umode_t mode)
 {
 	struct inode *inode = path->dentry->d_inode;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 31fa67fb9894b3..e89d62e944dc0e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1235,8 +1235,6 @@ asmlinkage long sys_ni_syscall(void);
  * Instead, use one of the functions which work equivalently, such as
  * the ksys_xyzyyz() functions prototyped below.
  */
-
-int ksys_chroot(const char __user *filename);
 ssize_t ksys_write(unsigned int fd, const char __user *buf, size_t count);
 int ksys_fchown(unsigned int fd, uid_t user, gid_t group);
 ssize_t ksys_read(unsigned int fd, char __user *buf, size_t count);
diff --git a/init/do_mounts.c b/init/do_mounts.c
index cc08ed7b44e764..c8ccdc80ffcdd5 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -629,7 +629,7 @@ void __init prepare_namespace(void)
 out:
 	devtmpfs_mount();
 	init_mount(".", "/", NULL, MS_MOVE, NULL);
-	ksys_chroot(".");
+	init_chroot(".");
 }
 
 static bool is_tmpfs;
diff --git a/init/do_mounts.h b/init/do_mounts.h
index c82fcb27575877..810b37ce1db882 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -12,6 +12,7 @@
 int __init init_mount(const char *dev_name, const char *dir_name,
 		const char *type_page, unsigned long flags, void *data_page);
 int __init init_chdir(const char *filename);
+int __init init_chroot(const char *filename);
 int __init init_unlink(const char *pathname);
 int __init init_rmdir(const char *pathname);
 
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index ef214a78e7ee49..697d45e4aa8c87 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -64,7 +64,7 @@ static int __init init_linuxrc(struct subprocess_info *info, struct cred *new)
 	/* move initrd over / and chdir/chroot in initrd root */
 	init_chdir("/root");
 	init_mount(".", "/", NULL, MS_MOVE, NULL);
-	ksys_chroot(".");
+	init_chroot(".");
 	ksys_setsid();
 	return 0;
 }
@@ -102,7 +102,7 @@ static void __init handle_initrd(void)
 	/* move initrd to rootfs' /old */
 	init_mount("..", ".", NULL, MS_MOVE, NULL);
 	/* switch root and cwd back to / of rootfs */
-	ksys_chroot("..");
+	init_chroot("..");
 
 	if (new_decode_dev(real_root_dev) == Root_RAM0) {
 		init_chdir("/old");
diff --git a/init/fs.c b/init/fs.c
index f3d8da00662572..af55e6d40357dc 100644
--- a/init/fs.c
+++ b/init/fs.c
@@ -36,6 +36,29 @@ int __init init_chdir(const char *filename)
 	return error;
 }
 
+int __init init_chroot(const char *filename)
+{
+	struct path path;
+	int error;
+
+	error = kern_path(filename, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path);
+	if (error)
+		return error;
+	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR);
+	if (error)
+		goto dput_and_out;
+	error = -EPERM;
+	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT))
+		goto dput_and_out;
+	error = security_path_chroot(&path);
+	if (error)
+		goto dput_and_out;
+	set_fs_root(current->fs, &path);
+dput_and_out:
+	path_put(&path);
+	return error;
+}
+
 int __init init_unlink(const char *pathname)
 {
 	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
-- 
2.27.0
