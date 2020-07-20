From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/24] fs: add a kern_umount helper
Date: Mon, 20 Jul 2020 17:58:41 +0200
Message-ID: <20200720155902.181712-4-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Like ksys_umount, but takes a kernel pointer for the destination path.
Switch over the umount in the init code to it, which just happens to work
due to the implicit set_fs(KERNEL_DS) during early init right now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/namespace.c           | 53 ++++++++++++++++++++++++----------------
 include/linux/fs.h       |  1 +
 include/linux/syscalls.h |  1 -
 init/do_mounts_initrd.c  |  2 +-
 4 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index d208a389aac3c0..cfcee6a1bd5dd2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1706,36 +1706,26 @@ static inline bool may_mandlock(void)
 }
 #endif
 
-/*
- * Now umount can handle mount points as well as block devices.
- * This is important for filesystems which use unnamed block devices.
- *
- * We now support a flag for forced unmount like the other 'big iron'
- * unixes. Our API is identical to OSF/1 to avoid making a mess of AMD
- */
+static int umount_lookup_flags(int flags)
+{
+	if (flags & UMOUNT_NOFOLLOW)
+		return LOOKUP_MOUNTPOINT;
+	return LOOKUP_MOUNTPOINT | LOOKUP_FOLLOW;
+}
 
-int ksys_umount(char __user *name, int flags)
+static int path_umount(struct path *path, int flags)
 {
-	struct path path;
 	struct mount *mnt;
 	int retval;
-	int lookup_flags = LOOKUP_MOUNTPOINT;
 
 	if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | UMOUNT_NOFOLLOW))
 		return -EINVAL;
-
 	if (!may_mount())
 		return -EPERM;
 
-	if (!(flags & UMOUNT_NOFOLLOW))
-		lookup_flags |= LOOKUP_FOLLOW;
-
-	retval = user_path_at(AT_FDCWD, name, lookup_flags, &path);
-	if (retval)
-		goto out;
-	mnt = real_mount(path.mnt);
+	mnt = real_mount(path->mnt);
 	retval = -EINVAL;
-	if (path.dentry != path.mnt->mnt_root)
+	if (path->dentry != path->mnt->mnt_root)
 		goto dput_and_out;
 	if (!check_mnt(mnt))
 		goto dput_and_out;
@@ -1748,12 +1738,33 @@ int ksys_umount(char __user *name, int flags)
 	retval = do_umount(mnt, flags);
 dput_and_out:
 	/* we mustn't call path_put() as that would clear mnt_expiry_mark */
-	dput(path.dentry);
+	dput(path->dentry);
 	mntput_no_expire(mnt);
-out:
 	return retval;
 }
 
+static int ksys_umount(char __user *name, int flags)
+{
+	struct path path;
+	int ret;
+
+	ret = user_path_at(AT_FDCWD, name, umount_lookup_flags(flags), &path);
+	if (ret)
+		return ret;
+	return path_umount(&path, flags);
+}
+
+int __init kern_umount(char *name, int flags)
+{
+	struct path path;
+	int ret;
+
+	ret = kern_path(name, umount_lookup_flags(flags), &path);
+	if (ret)
+		return ret;
+	return path_umount(&path, flags);
+}
+
 SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 {
 	return ksys_umount(name, flags);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8f628f9868711d..fbeadaa1a185fb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2339,6 +2339,7 @@ extern long do_mount(const char *, const char __user *,
 		     const char *, unsigned long, void *);
 int do_kern_mount(const char *dev_name, const char *dir_name,
 		const char *type_page, unsigned long flags, void *data_page);
+int __init kern_umount(char *name, int flags);
 extern struct vfsmount *collect_mounts(const struct path *);
 extern void drop_collected_mounts(struct vfsmount *);
 extern int iterate_mounts(int (*)(struct vfsmount *, void *), void *,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 5b0f1fca4cfb9d..3b1b8ebcda1d8c 100644
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
index 604ce78af9acfa..d3858620707893 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -122,7 +122,7 @@ static void __init handle_initrd(void)
 		else
 			printk("failed\n");
 		printk(KERN_NOTICE "Unmounting old root\n");
-		ksys_umount("/old", MNT_DETACH);
+		kern_umount("/old", MNT_DETACH);
 	}
 }
 
-- 
2.27.0
