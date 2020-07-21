From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/24] devtmpfs: open code do_mount
Date: Tue, 21 Jul 2020 18:27:58 +0200
Message-ID: <20200721162818.197315-5-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200721162818.197315-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Replace do_umount with an open coded version that takes the proper
kernel pointer instead of relying on the implicit set_fs(KERNEL_DS)
during early init.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/base/devtmpfs.c | 17 +++++++++++++++--
 fs/namespace.c          |  2 +-
 include/linux/mount.h   |  3 +++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index c9017e0584c003..5e8d677ee783bc 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -345,6 +345,19 @@ static int handle_remove(const char *nodename, struct device *dev)
 	return err;
 }
 
+static int devtmpfs_do_mount(const char __user *dir_name)
+{
+	struct path p;
+	int ret;
+
+	ret = kern_path(dir_name, LOOKUP_FOLLOW, &p);
+	if (ret)
+		return ret;
+	ret = path_mount("devtmpfs", &p, "devtmpfs", MS_SILENT, NULL);
+	path_put(&p);
+	return ret;
+}
+
 /*
  * If configured, or requested by the commandline, devtmpfs will be
  * auto-mounted after the kernel mounted the root filesystem.
@@ -359,7 +372,7 @@ int __init devtmpfs_mount(void)
 	if (!thread)
 		return 0;
 
-	err = do_mount("devtmpfs", "dev", "devtmpfs", MS_SILENT, NULL);
+	err = devtmpfs_do_mount("dev");
 	if (err)
 		printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
 	else
@@ -385,7 +398,7 @@ static int devtmpfs_setup(void *p)
 	err = ksys_unshare(CLONE_NEWNS);
 	if (err)
 		goto out;
-	err = do_mount("devtmpfs", "/", "devtmpfs", MS_SILENT, NULL);
+	err = devtmpfs_do_mount("/");
 	if (err)
 		goto out;
 	ksys_chdir("/.."); /* will traverse into overmounted root */
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
diff --git a/include/linux/mount.h b/include/linux/mount.h
index de657bd211fa64..bf9896f86a48f4 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -113,4 +113,7 @@ extern bool path_is_mountpoint(const struct path *path);
 
 extern void kern_unmount_array(struct vfsmount *mnt[], unsigned int num);
 
+int path_mount(const char *dev_name, struct path *path, const char *type_page,
+		unsigned long flags, void *data_page);
+
 #endif /* _LINUX_MOUNT_H */
-- 
2.27.0
