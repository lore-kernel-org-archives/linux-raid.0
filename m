From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 17/24] init: add an init_chown helper
Date: Tue, 21 Jul 2020 18:28:11 +0200
Message-ID: <20200721162818.197315-18-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200721162818.197315-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Add a simple helper to chown with a kernel space file name and switch
the early init code over to it.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/internal.h    |  2 +-
 fs/open.c        |  2 +-
 init/do_mounts.h |  1 +
 init/fs.c        | 18 ++++++++++++++++++
 init/initramfs.c |  6 +++---
 5 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index e903d5aae139a2..4a66730fabefa7 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -129,7 +129,7 @@ long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
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
diff --git a/init/do_mounts.h b/init/do_mounts.h
index 810b37ce1db882..db42564080a2f9 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -13,6 +13,7 @@ int __init init_mount(const char *dev_name, const char *dir_name,
 		const char *type_page, unsigned long flags, void *data_page);
 int __init init_chdir(const char *filename);
 int __init init_chroot(const char *filename);
+int __init init_chown(const char *filename, uid_t user, gid_t group, int flags);
 int __init init_unlink(const char *pathname);
 int __init init_rmdir(const char *pathname);
 
diff --git a/init/fs.c b/init/fs.c
index af55e6d40357dc..30000b7097b9f0 100644
--- a/init/fs.c
+++ b/init/fs.c
@@ -59,6 +59,24 @@ int __init init_chroot(const char *filename)
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
diff --git a/init/initramfs.c b/init/initramfs.c
index 41491149fb1f29..076413dbe8bcf3 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -353,14 +353,14 @@ static int __init do_name(void)
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
+			init_chown(collected, uid, gid, AT_SYMLINK_NOFOLLOW);
 			ksys_chmod(collected, mode);
 			do_utime(collected, mtime);
 		}
@@ -398,7 +398,7 @@ static int __init do_symlink(void)
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
