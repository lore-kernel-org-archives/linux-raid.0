From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/23] init: add an init_chown helper
Date: Tue, 28 Jul 2020 18:34:07 +0200
Message-ID: <20200728163416.556521-15-hch@lst.de>
References: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200728163416.556521-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to chown with a kernel space file name and switch
the early init code over to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/init.c                     | 18 ++++++++++++++++++
 fs/internal.h                 |  2 +-
 fs/open.c                     |  2 +-
 include/linux/init_syscalls.h |  1 +
 init/initramfs.c              |  6 +++---
 5 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index 2c78f24814dde4..edd0244655956e 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -78,6 +78,24 @@ int __init init_chroot(const char *filename)
 	return error;
 }
 
+int __init init_chown(const char *filename, uid_t user, gid_t group, int flags)
+{
+	int lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	struct path path;
+	int error;
+
+	error = kern_path(filename, lookup_flags, &path);
+	if (error)
+		return error;
+	error = mnt_want_write(path.mnt);
+	if (!error) {
+		error = chown_common(&path, user, group);
+		mnt_drop_write(path.mnt);
+	}
+	path_put(&path);
+	return error;
+}
+
 int __init init_unlink(const char *pathname)
 {
 	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
diff --git a/fs/internal.h b/fs/internal.h
index 491d1e63809b37..e81b9e23c3ea3f 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -134,7 +134,7 @@ long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 int do_fchmodat(int dfd, const char __user *filename, umode_t mode);
 int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 		int flag);
-
+int chown_common(const struct path *path, uid_t user, gid_t group);
 extern int vfs_open(const struct path *, struct file *);
 
 /*
diff --git a/fs/open.c b/fs/open.c
index f62f4752bb436d..49960a1248f14b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -639,7 +639,7 @@ SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
 	return do_fchmodat(AT_FDCWD, filename, mode);
 }
 
-static int chown_common(const struct path *path, uid_t user, gid_t group)
+int chown_common(const struct path *path, uid_t user, gid_t group)
 {
 	struct inode *inode = path->dentry->d_inode;
 	struct inode *delegated_inode = NULL;
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
index e07099a14b91db..0da59d76133e17 100644
--- a/include/linux/init_syscalls.h
+++ b/include/linux/init_syscalls.h
@@ -5,5 +5,6 @@ int __init init_mount(const char *dev_name, const char *dir_name,
 int __init init_umount(const char *name, int flags);
 int __init init_chdir(const char *filename);
 int __init init_chroot(const char *filename);
+int __init init_chown(const char *filename, uid_t user, gid_t group, int flags);
 int __init init_unlink(const char *pathname);
 int __init init_rmdir(const char *pathname);
diff --git a/init/initramfs.c b/init/initramfs.c
index fb7210731d9e5d..24a8dcc6734064 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -349,14 +349,14 @@ static int __init do_name(void)
 		}
 	} else if (S_ISDIR(mode)) {
 		ksys_mkdir(collected, mode);
-		ksys_chown(collected, uid, gid);
+		init_chown(collected, uid, gid, 0);
 		ksys_chmod(collected, mode);
 		dir_add(collected, mtime);
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
 			ksys_mknod(collected, mode, rdev);
-			ksys_chown(collected, uid, gid);
+			init_chown(collected, uid, gid, 0);
 			ksys_chmod(collected, mode);
 			do_utime(collected, mtime);
 		}
@@ -394,7 +394,7 @@ static int __init do_symlink(void)
 	collected[N_ALIGN(name_len) + body_len] = '\0';
 	clean_path(collected, 0);
 	ksys_symlink(collected + N_ALIGN(name_len), collected);
-	ksys_lchown(collected, uid, gid);
+	init_chown(collected, uid, gid, AT_SYMLINK_NOFOLLOW);
 	do_utime(collected, mtime);
 	state = SkipIt;
 	next_state = Reset;
-- 
2.27.0
