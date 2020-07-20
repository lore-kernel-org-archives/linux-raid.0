From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/24] fs: add a kern_chdir helper
Date: Mon, 20 Jul 2020 17:58:44 +0200
Message-ID: <20200720155902.181712-7-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper for a chdir with a kernelspace name and use it in the
early init code instead of relying on the implicit set_fs(KERNEL_DS)
there.  Remove the now unused ksys_chdir.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/base/devtmpfs.c  |  2 +-
 fs/open.c                | 15 ++++++++++-----
 include/linux/fs.h       |  2 ++
 include/linux/syscalls.h |  1 -
 init/do_mounts.c         |  2 +-
 init/do_mounts_initrd.c  |  8 ++++----
 6 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 03221ca708c91c..2cedeb62706f18 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -388,7 +388,7 @@ static int devtmpfs_setup(void *p)
 	err = do_kern_mount("devtmpfs", "/", "devtmpfs", MS_SILENT, NULL);
 	if (err)
 		goto out;
-	ksys_chdir("/.."); /* will traverse into overmounted root */
+	kern_chdir("/.."); /* will traverse into overmounted root */
 	ksys_chroot(".");
 out:
 	*(int *)p = err;
diff --git a/fs/open.c b/fs/open.c
index b316dd6a86a8b9..3d62f4d2604739 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -482,15 +482,15 @@ SYSCALL_DEFINE2(access, const char __user *, filename, int, mode)
 	return do_faccessat(AT_FDCWD, filename, mode, 0);
 }
 
-int ksys_chdir(const char __user *filename)
+static int do_chdir(struct filename *name)
 {
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
 retry:
-	error = user_path_at(AT_FDCWD, filename, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (error)
-		goto out;
+		return error;
 
 	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR);
 	if (error)
@@ -504,13 +504,18 @@ int ksys_chdir(const char __user *filename)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
+	putname(name);
 	return error;
 }
 
+int kern_chdir(const char *filename)
+{
+	return do_chdir(getname_kernel(filename));
+}
+
 SYSCALL_DEFINE1(chdir, const char __user *, filename)
 {
-	return ksys_chdir(filename);
+	return do_chdir(getname(filename));
 }
 
 SYSCALL_DEFINE1(fchdir, unsigned int, fd)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fbeadaa1a185fb..dccb37407e9bad 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3671,4 +3671,6 @@ static inline int inode_drain_writes(struct inode *inode)
 	return filemap_write_and_wait(inode->i_mapping);
 }
 
+int kern_chdir(const char *filename);
+
 #endif /* _LINUX_FS_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3b1b8ebcda1d8c..f2a181776b0409 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1238,7 +1238,6 @@ asmlinkage long sys_ni_syscall(void);
 
 int ksys_chroot(const char __user *filename);
 ssize_t ksys_write(unsigned int fd, const char __user *buf, size_t count);
-int ksys_chdir(const char __user *filename);
 int ksys_fchown(unsigned int fd, uid_t user, gid_t group);
 ssize_t ksys_read(unsigned int fd, char __user *buf, size_t count);
 void ksys_sync(void);
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 2fef92a8ed3c15..8c3fca8e2d3c6e 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -408,7 +408,7 @@ static int __init do_mount_root(const char *name, const char *fs,
 	if (ret)
 		goto out;
 
-	ksys_chdir("/root");
+	kern_chdir("/root");
 	s = current->fs->pwd.dentry->d_sb;
 	ROOT_DEV = s->s_dev;
 	printk(KERN_INFO
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index d3858620707893..522554d703b785 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -61,7 +61,7 @@ static int __init init_linuxrc(struct subprocess_info *info, struct cred *new)
 	ksys_unshare(CLONE_FS | CLONE_FILES);
 	console_on_rootfs();
 	/* move initrd over / and chdir/chroot in initrd root */
-	ksys_chdir("/root");
+	kern_chdir("/root");
 	do_kern_mount(".", "/", NULL, MS_MOVE, NULL);
 	ksys_chroot(".");
 	ksys_setsid();
@@ -82,7 +82,7 @@ static void __init handle_initrd(void)
 	/* mount initrd on rootfs' /root */
 	mount_block_root("/dev/root.old", root_mountflags & ~MS_RDONLY);
 	ksys_mkdir("/old", 0700);
-	ksys_chdir("/old");
+	kern_chdir("/old");
 
 	/*
 	 * In case that a resume from disk is carried out by linuxrc or one of
@@ -104,11 +104,11 @@ static void __init handle_initrd(void)
 	ksys_chroot("..");
 
 	if (new_decode_dev(real_root_dev) == Root_RAM0) {
-		ksys_chdir("/old");
+		kern_chdir("/old");
 		return;
 	}
 
-	ksys_chdir("/");
+	kern_chdir("/");
 	ROOT_DEV = new_decode_dev(real_root_dev);
 	mount_root();
 
-- 
2.27.0
