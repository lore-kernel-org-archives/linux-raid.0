From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 12/24] init: add an init_mount helper
Date: Tue, 21 Jul 2020 18:28:06 +0200
Message-ID: <20200721162818.197315-13-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200721162818.197315-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Like do_mount, but takes a kernel pointer for the destination path.
Switch over the mounts in the init code and devtmpfs to it, which
just happen to work due to the implicit set_fs(KERNEL_DS) during early
init right now.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 init/Makefile           |  2 +-
 init/do_mounts.c        |  8 ++++----
 init/do_mounts.h        |  3 +++
 init/do_mounts_initrd.c |  6 +++---
 init/fs.c               | 20 ++++++++++++++++++++
 5 files changed, 31 insertions(+), 8 deletions(-)
 create mode 100644 init/fs.c

diff --git a/init/Makefile b/init/Makefile
index 6bc37f64b3617c..7d4b57d3cf7eac 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -5,7 +5,7 @@
 
 ccflags-y := -fno-function-sections -fno-data-sections
 
-obj-y                          := main.o version.o mounts.o
+obj-y                          := main.o version.o fs.o mounts.o
 ifneq ($(CONFIG_BLK_DEV_INITRD),y)
 obj-y                          += noinitramfs.o
 else
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
index 15d256658a3093..ce4f95fff6bc16 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -9,6 +9,9 @@
 #include <linux/major.h>
 #include <linux/root_dev.h>
 
+int __init init_mount(const char *dev_name, const char *dir_name,
+		const char *type_page, unsigned long flags, void *data_page);
+
 void  mount_block_root(char *name, int flags);
 void  mount_root(void);
 void prepare_namespace(void);
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 3fabbc82513506..63a3eebd36e76b 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -63,7 +63,7 @@ static int __init init_linuxrc(struct subprocess_info *info, struct cred *new)
 	console_on_rootfs();
 	/* move initrd over / and chdir/chroot in initrd root */
 	ksys_chdir("/root");
-	do_mount(".", "/", NULL, MS_MOVE, NULL);
+	init_mount(".", "/", NULL, MS_MOVE, NULL);
 	ksys_chroot(".");
 	ksys_setsid();
 	return 0;
@@ -100,7 +100,7 @@ static void __init handle_initrd(void)
 	current->flags &= ~PF_FREEZER_SKIP;
 
 	/* move initrd to rootfs' /old */
-	do_mount("..", ".", NULL, MS_MOVE, NULL);
+	init_mount("..", ".", NULL, MS_MOVE, NULL);
 	/* switch root and cwd back to / of rootfs */
 	ksys_chroot("..");
 
@@ -114,7 +114,7 @@ static void __init handle_initrd(void)
 	mount_root();
 
 	printk(KERN_NOTICE "Trying to move old root to /initrd ... ");
-	error = do_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
+	error = init_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
 	if (!error)
 		printk("okay\n");
 	else {
diff --git a/init/fs.c b/init/fs.c
new file mode 100644
index 00000000000000..73423f5461f934
--- /dev/null
+++ b/init/fs.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/init.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/fs.h>
+#include "do_mounts.h"
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
-- 
2.27.0
