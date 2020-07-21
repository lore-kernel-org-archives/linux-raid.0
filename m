From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/24] init: open code ksys_umount in handle_initrd
Date: Tue, 21 Jul 2020 18:28:04 +0200
Message-ID: <20200721162818.197315-11-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200721162818.197315-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Replace ksys_umount with an open coded version that takes the proper
kernel pointer instead of relying on the implicit set_fs(KERNEL_DS)
during early init.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/namespace.c           | 4 ++--
 include/linux/mount.h    | 1 +
 include/linux/syscalls.h | 1 -
 init/do_mounts_initrd.c  | 6 +++++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2c4d7592097485..a7301790abb211 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1706,7 +1706,7 @@ static inline bool may_mandlock(void)
 }
 #endif
 
-static int path_umount(struct path *path, int flags)
+int path_umount(struct path *path, int flags)
 {
 	struct mount *mnt;
 	int retval;
@@ -1736,7 +1736,7 @@ static int path_umount(struct path *path, int flags)
 	return retval;
 }
 
-int ksys_umount(char __user *name, int flags)
+static int ksys_umount(char __user *name, int flags)
 {
 	int lookup_flags = LOOKUP_MOUNTPOINT;
 	struct path path;
diff --git a/include/linux/mount.h b/include/linux/mount.h
index bf9896f86a48f4..e868b1ac7af90c 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -115,5 +115,6 @@ extern void kern_unmount_array(struct vfsmount *mnt[], unsigned int num);
 
 int path_mount(const char *dev_name, struct path *path, const char *type_page,
 		unsigned long flags, void *data_page);
+int path_umount(struct path *path, int flags);
 
 #endif /* _LINUX_MOUNT_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e43816198e6001..1a4f5d8ee7044b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1236,7 +1236,6 @@ asmlinkage long sys_ni_syscall(void);
  * the ksys_xyzyyz() functions prototyped below.
  */
 
-int ksys_umount(char __user *name, int flags);
 int ksys_chroot(const char __user *filename);
 ssize_t ksys_write(unsigned int fd, const char __user *buf, size_t count);
 int ksys_chdir(const char __user *filename);
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index e08669187d63be..3fabbc82513506 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -9,6 +9,7 @@
 #include <linux/freezer.h>
 #include <linux/kmod.h>
 #include <uapi/linux/mount.h>
+#include <linux/namei.h>
 
 #include "do_mounts.h"
 
@@ -117,12 +118,15 @@ static void __init handle_initrd(void)
 	if (!error)
 		printk("okay\n");
 	else {
+		struct path path;
+
 		if (error == -ENOENT)
 			printk("/initrd does not exist. Ignored.\n");
 		else
 			printk("failed\n");
 		printk(KERN_NOTICE "Unmounting old root\n");
-		ksys_umount("/old", MNT_DETACH);
+		if (!kern_path("/old", LOOKUP_MOUNTPOINT, &path))
+			path_umount(&path, MNT_DETACH);
 	}
 }
 
-- 
2.27.0
