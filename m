From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/24] fs: add a kern_unlink helper
Date: Mon, 20 Jul 2020 17:58:55 +0200
Message-ID: <20200720155902.181712-18-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to unlink with a kernel space file name and switch
the early init and coredump code over to it.  Remove the now unused
ksys_unlink.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/coredump.c            | 2 +-
 fs/internal.h            | 1 -
 fs/namei.c               | 7 ++++++-
 include/linux/fs.h       | 1 +
 include/linux/syscalls.h | 7 -------
 init/do_mounts.h         | 2 +-
 init/do_mounts_initrd.c  | 4 ++--
 init/do_mounts_rd.c      | 2 +-
 init/initramfs.c         | 2 +-
 9 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 7237f07ff6bed2..fc82170e78c71d 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -719,7 +719,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 			 * If it doesn't exist, that's fine. If there's some
 			 * other problem, we'll catch it at the filp_open().
 			 */
-			do_unlinkat(AT_FDCWD, getname_kernel(cn.corename));
+			kern_unlink(cn.corename);
 		}
 
 		/*
diff --git a/fs/internal.h b/fs/internal.h
index 46f727c0bd84e2..62e17871f16316 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -63,7 +63,6 @@ extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct path *);
 long do_rmdir(int dfd, const char __user *pathname);
-long do_unlinkat(int dfd, struct filename *name);
 
 /*
  * namespace.c
diff --git a/fs/namei.c b/fs/namei.c
index 01e43676008644..3cbaca386d3189 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3883,7 +3883,7 @@ EXPORT_SYMBOL(vfs_unlink);
  * writeout happening, and we don't want to prevent access to the directory
  * while waiting on the I/O.
  */
-long do_unlinkat(int dfd, struct filename *name)
+static int do_unlinkat(int dfd, struct filename *name)
 {
 	int error;
 	struct dentry *dentry;
@@ -3954,6 +3954,11 @@ long do_unlinkat(int dfd, struct filename *name)
 	goto exit2;
 }
 
+int kern_unlink(const char *pathname)
+{
+	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
+}
+
 SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
 {
 	if ((flag & ~AT_REMOVEDIR) != 0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7a7b3bf1b8aa53..306e58ff54f69f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3681,5 +3681,6 @@ int kern_mkdir(const char *pathname, umode_t mode);
 int kern_mknod(const char *filename, umode_t mode, unsigned int dev);
 int __init kern_link(const char *oldname, const char *newname);
 int __init kern_symlink(const char *oldname, const char *newname);
+int kern_unlink(const char *pathname);
 
 #endif /* _LINUX_FS_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 474d5d165048c8..483431765ac823 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1270,13 +1270,6 @@ int compat_ksys_ipc(u32 call, int first, int second,
  * The following kernel syscall equivalents are just wrappers to fs-internal
  * functions. Therefore, provide stubs to be inlined at the callsites.
  */
-extern long do_unlinkat(int dfd, struct filename *name);
-
-static inline long ksys_unlink(const char __user *pathname)
-{
-	return do_unlinkat(AT_FDCWD, getname(pathname));
-}
-
 extern long do_rmdir(int dfd, const char __user *pathname);
 
 static inline long ksys_rmdir(const char __user *pathname)
diff --git a/init/do_mounts.h b/init/do_mounts.h
index b9ec1d522f0ce1..0b3c72ee6670b2 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -15,7 +15,7 @@ extern int root_mountflags;
 
 static inline int create_dev(char *name, dev_t dev)
 {
-	ksys_unlink(name);
+	kern_unlink(name);
 	return kern_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
 }
 
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index b9a749ebe85c2d..1b74a0a5c38f8b 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -137,11 +137,11 @@ bool __init initrd_load(void)
 		 * mounted in the normal path.
 		 */
 		if (rd_load_image("/initrd.image") && ROOT_DEV != Root_RAM0) {
-			ksys_unlink("/initrd.image");
+			kern_unlink("/initrd.image");
 			handle_initrd();
 			return true;
 		}
 	}
-	ksys_unlink("/initrd.image");
+	kern_unlink("/initrd.image");
 	return false;
 }
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 7b64390c075043..1737f1d2ee9fd7 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -271,7 +271,7 @@ int __init rd_load_image(char *from)
 	fput(out_file);
 out:
 	kfree(buf);
-	ksys_unlink("/dev/ram");
+	kern_unlink("/dev/ram");
 	return res;
 }
 
diff --git a/init/initramfs.c b/init/initramfs.c
index 4efd78427996da..86d3750a47499d 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -300,7 +300,7 @@ static void __init clean_path(char *path, umode_t fmode)
 		if (S_ISDIR(st.mode))
 			ksys_rmdir(path);
 		else
-			ksys_unlink(path);
+			kern_unlink(path);
 	}
 }
 
-- 
2.27.0
