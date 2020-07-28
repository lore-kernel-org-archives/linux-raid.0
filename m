From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/23] init: add an init_umount helper
Date: Tue, 28 Jul 2020 18:34:02 +0200
Message-ID: <20200728163416.556521-10-hch@lst.de>
References: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200728163416.556521-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Like ksys_umount, but takes a kernel pointer for the destination path.
Switch over the umount in the init code, which just happen to work due to
the implicit set_fs(KERNEL_DS) during early init right now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/init.c                     | 14 ++++++++++++++
 fs/internal.h                 |  1 +
 fs/namespace.c                |  4 ++--
 include/linux/init_syscalls.h |  1 +
 include/linux/syscalls.h      |  1 -
 init/do_mounts_initrd.c       |  2 +-
 6 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index c6eb724e1c7b22..9c8e31fdb048c8 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -23,3 +23,17 @@ int __init init_mount(const char *dev_name, const char *dir_name,
 	path_put(&path);
 	return ret;
 }
+
+int __init init_umount(const char *name, int flags)
+{
+	int lookup_flags = LOOKUP_MOUNTPOINT;
+	struct path path;
+	int ret;
+
+	if (!(flags & UMOUNT_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+	ret = kern_path(name, lookup_flags, &path);
+	if (ret)
+		return ret;
+	return path_umount(&path, flags);
+}
diff --git a/fs/internal.h b/fs/internal.h
index 72ea0b6f7435a4..491d1e63809b37 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -92,6 +92,7 @@ extern void dissolve_on_fput(struct vfsmount *);
 
 int path_mount(const char *dev_name, struct path *path,
 		const char *type_page, unsigned long flags, void *data_page);
+int path_umount(struct path *path, int flags);
 
 /*
  * fs_struct.c
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
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
index af9ea88a60e0bd..a5a2e7f1991691 100644
--- a/include/linux/init_syscalls.h
+++ b/include/linux/init_syscalls.h
@@ -2,3 +2,4 @@
 
 int __init init_mount(const char *dev_name, const char *dir_name,
 		const char *type_page, unsigned long flags, void *data_page);
+int __init init_umount(const char *name, int flags);
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
index 1f9336209ad9cc..6b020a06990251 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -122,7 +122,7 @@ static void __init handle_initrd(void)
 		else
 			printk("failed\n");
 		printk(KERN_NOTICE "Unmounting old root\n");
-		ksys_umount("/old", MNT_DETACH);
+		init_umount("/old", MNT_DETACH);
 	}
 }
 
-- 
2.27.0
