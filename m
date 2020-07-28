From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/23] init: add an init_unlink helper
Date: Tue, 28 Jul 2020 18:34:03 +0200
Message-ID: <20200728163416.556521-11-hch@lst.de>
References: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200728163416.556521-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to unlink with a kernel space file name and switch
the early init code over to it.  Remove the now unused ksys_unlink.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/init.c                     | 5 +++++
 include/linux/init_syscalls.h | 1 +
 include/linux/syscalls.h      | 7 -------
 init/do_mounts.h              | 2 +-
 init/do_mounts_initrd.c       | 4 ++--
 init/do_mounts_rd.c           | 2 +-
 init/initramfs.c              | 3 ++-
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index 9c8e31fdb048c8..507ffbb5d146d6 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -37,3 +37,8 @@ int __init init_umount(const char *name, int flags)
 		return ret;
 	return path_umount(&path, flags);
 }
+
+int __init init_unlink(const char *pathname)
+{
+	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
+}
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
index a5a2e7f1991691..00d597249549ee 100644
--- a/include/linux/init_syscalls.h
+++ b/include/linux/init_syscalls.h
@@ -3,3 +3,4 @@
 int __init init_mount(const char *dev_name, const char *dir_name,
 		const char *type_page, unsigned long flags, void *data_page);
 int __init init_umount(const char *name, int flags);
+int __init init_unlink(const char *pathname);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 1a4f5d8ee7044b..26f9738e5ab861 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1273,13 +1273,6 @@ int compat_ksys_ipc(u32 call, int first, int second,
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
 long do_rmdir(int dfd, struct filename *name);
 
 static inline long ksys_rmdir(const char __user *pathname)
diff --git a/init/do_mounts.h b/init/do_mounts.h
index 20e7fec8cb499e..104d8431725aeb 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -16,7 +16,7 @@ extern int root_mountflags;
 
 static inline __init int create_dev(char *name, dev_t dev)
 {
-	ksys_unlink(name);
+	init_unlink(name);
 	return ksys_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
 }
 
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 6b020a06990251..8b44dd017842a8 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -137,11 +137,11 @@ bool __init initrd_load(void)
 		 * mounted in the normal path.
 		 */
 		if (rd_load_image("/initrd.image") && ROOT_DEV != Root_RAM0) {
-			ksys_unlink("/initrd.image");
+			init_unlink("/initrd.image");
 			handle_initrd();
 			return true;
 		}
 	}
-	ksys_unlink("/initrd.image");
+	init_unlink("/initrd.image");
 	return false;
 }
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index d4255c10432a8b..ac021ae6e6fa78 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -272,7 +272,7 @@ int __init rd_load_image(char *from)
 	fput(out_file);
 out:
 	kfree(buf);
-	ksys_unlink("/dev/ram");
+	init_unlink("/dev/ram");
 	return res;
 }
 
diff --git a/init/initramfs.c b/init/initramfs.c
index 584bc8fe88e77c..7e9db1cfa3c060 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -12,6 +12,7 @@
 #include <linux/file.h>
 #include <linux/memblock.h>
 #include <linux/namei.h>
+#include <linux/init_syscalls.h>
 
 static ssize_t __init xwrite(struct file *file, const char *p, size_t count,
 		loff_t *pos)
@@ -301,7 +302,7 @@ static void __init clean_path(char *path, umode_t fmode)
 		if (S_ISDIR(st.mode))
 			ksys_rmdir(path);
 		else
-			ksys_unlink(path);
+			init_unlink(path);
 	}
 }
 
-- 
2.27.0
