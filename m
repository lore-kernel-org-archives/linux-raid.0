From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/21] init: add an init_mount helper
Date: Sun, 26 Jul 2020 09:13:42 +0200
Message-ID: <20200726071356.287160-8-hch@lst.de>
References: <20200726071356.287160-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200726071356.287160-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Like do_mount, but takes a kernel pointer for the destination path.
Switch over the mounts in the init code and devtmpfs to it, which
just happen to work due to the implicit set_fs(KERNEL_DS) during early
init right now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/base/devtmpfs.c       |  5 +++--
 fs/Makefile                   |  2 +-
 fs/for_init.c                 | 21 +++++++++++++++++++++
 fs/internal.h                 |  4 ++++
 fs/namespace.c                |  2 +-
 include/linux/init_syscalls.h |  4 ++++
 init/do_mounts.c              |  8 ++++----
 init/do_mounts.h              |  1 +
 init/do_mounts_initrd.c       |  6 +++---
 9 files changed, 42 insertions(+), 11 deletions(-)
 create mode 100644 fs/for_init.c
 create mode 100644 include/linux/init_syscalls.h

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index a103ee7e229930..03051e8c12bdc9 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
+#include <linux/init_syscalls.h>
 #include <uapi/linux/mount.h>
 #include "base.h"
 
@@ -359,7 +360,7 @@ int __init devtmpfs_mount(void)
 	if (!thread)
 		return 0;
 
-	err = do_mount("devtmpfs", "dev", "devtmpfs", MS_SILENT, NULL);
+	err = init_mount("devtmpfs", "dev", "devtmpfs", MS_SILENT, NULL);
 	if (err)
 		printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
 	else
@@ -408,7 +409,7 @@ static int __init devtmpfs_setup(void *p)
 	err = ksys_unshare(CLONE_NEWNS);
 	if (err)
 		goto out;
-	err = do_mount("devtmpfs", "/", "devtmpfs", MS_SILENT, NULL);
+	err = init_mount("devtmpfs", "/", "devtmpfs", MS_SILENT, NULL);
 	if (err)
 		goto out;
 	ksys_chdir("/.."); /* will traverse into overmounted root */
diff --git a/fs/Makefile b/fs/Makefile
index 2ce5112b02c867..837512ff387ccd 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -13,7 +13,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o splice.o sync.o utimes.o d_path.o \
 		stack.o fs_struct.o statfs.o fs_pin.o nsfs.o \
-		fs_types.o fs_context.o fs_parser.o fsopen.o
+		fs_types.o fs_context.o fs_parser.o fsopen.o for_init.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o block_dev.o direct-io.o mpage.o
diff --git a/fs/for_init.c b/fs/for_init.c
new file mode 100644
index 00000000000000..6a04cc8d8557c4
--- /dev/null
+++ b/fs/for_init.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/init.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/fs.h>
+#include <linux/init_syscalls.h>
+#include "internal.h"
+
+int __init init_mount(const char *dev_name, const char *dir_name,
+		const char *type_page, unsigned long flags, void *data_page)
+{
+	struct path path;
+	int ret;
+
+	ret = kern_path(dir_name, LOOKUP_FOLLOW, &path);
+	if (ret)
+		return ret;
+	ret = path_mount(dev_name, &path, type_page, flags, data_page);
+	path_put(&path);
+	return ret;
+}
diff --git a/fs/internal.h b/fs/internal.h
index e903d5aae139a2..72ea0b6f7435a4 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -89,6 +89,10 @@ extern int __mnt_want_write_file(struct file *);
 extern void __mnt_drop_write_file(struct file *);
 
 extern void dissolve_on_fput(struct vfsmount *);
+
+int path_mount(const char *dev_name, struct path *path,
+		const char *type_page, unsigned long flags, void *data_page);
+
 /*
  * fs_struct.c
  */
diff --git a/fs/namespace.c b/fs/namespace.c
index 43834b59eff6c3..2c4d7592097485 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3111,7 +3111,7 @@ char *copy_mount_string(const void __user *data)
  * Therefore, if this magic number is present, it carries no information
  * and must be discarded.
  */
-static int path_mount(const char *dev_name, struct path *path,
+int path_mount(const char *dev_name, struct path *path,
 		const char *type_page, unsigned long flags, void *data_page)
 {
 	unsigned int mnt_flags = 0, sb_flags;
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
new file mode 100644
index 00000000000000..af9ea88a60e0bd
--- /dev/null
+++ b/include/linux/init_syscalls.h
@@ -0,0 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+int __init init_mount(const char *dev_name, const char *dir_name,
+		const char *type_page, unsigned long flags, void *data_page);
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 4f4ceb35805503..4812e21d149cab 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -395,16 +395,16 @@ static int __init do_mount_root(const char *name, const char *fs,
 	int ret;
 
 	if (data) {
-		/* do_mount() requires a full page as fifth argument */
+		/* init_mount() requires a full page as fifth argument */
 		p = alloc_page(GFP_KERNEL);
 		if (!p)
 			return -ENOMEM;
 		data_page = page_address(p);
-		/* zero-pad. do_mount() will make sure it's terminated */
+		/* zero-pad. init_mount() will make sure it's terminated */
 		strncpy(data_page, data, PAGE_SIZE);
 	}
 
-	ret = do_mount(name, "/root", fs, flags, data_page);
+	ret = init_mount(name, "/root", fs, flags, data_page);
 	if (ret)
 		goto out;
 
@@ -628,7 +628,7 @@ void __init prepare_namespace(void)
 	mount_root();
 out:
 	devtmpfs_mount();
-	do_mount(".", "/", NULL, MS_MOVE, NULL);
+	init_mount(".", "/", NULL, MS_MOVE, NULL);
 	ksys_chroot(".");
 }
 
diff --git a/init/do_mounts.h b/init/do_mounts.h
index 021e2f60223e25..20e7fec8cb499e 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -8,6 +8,7 @@
 #include <linux/mount.h>
 #include <linux/major.h>
 #include <linux/root_dev.h>
+#include <linux/init_syscalls.h>
 
 void  mount_block_root(char *name, int flags);
 void  mount_root(void);
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index e08669187d63be..1f9336209ad9cc 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -62,7 +62,7 @@ static int __init init_linuxrc(struct subprocess_info *info, struct cred *new)
 	console_on_rootfs();
 	/* move initrd over / and chdir/chroot in initrd root */
 	ksys_chdir("/root");
-	do_mount(".", "/", NULL, MS_MOVE, NULL);
+	init_mount(".", "/", NULL, MS_MOVE, NULL);
 	ksys_chroot(".");
 	ksys_setsid();
 	return 0;
@@ -99,7 +99,7 @@ static void __init handle_initrd(void)
 	current->flags &= ~PF_FREEZER_SKIP;
 
 	/* move initrd to rootfs' /old */
-	do_mount("..", ".", NULL, MS_MOVE, NULL);
+	init_mount("..", ".", NULL, MS_MOVE, NULL);
 	/* switch root and cwd back to / of rootfs */
 	ksys_chroot("..");
 
@@ -113,7 +113,7 @@ static void __init handle_initrd(void)
 	mount_root();
 
 	printk(KERN_NOTICE "Trying to move old root to /initrd ... ");
-	error = do_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
+	error = init_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
 	if (!error)
 		printk("okay\n");
 	else {
-- 
2.27.0
