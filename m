From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/23] initramfs: simplify clean_rootfs
Date: Tue, 14 Jul 2020 21:04:20 +0200
Message-ID: <20200714190427.4332-17-hch@lst.de>
References: <20200714190427.4332-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Just use d_genocide instead of iterating through the root directory with
cumbersome userspace-like APIs.  This also ensures we actually remove files
that are not direct children of the root entry, which the old code failed
to do.

Fixes: df52092f3c97 ("fastboot: remove duplicate unpack_to_rootfs()")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/initramfs.c | 46 +++++-----------------------------------------
 1 file changed, 5 insertions(+), 41 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index d10404625c31f0..d42ec8329cd840 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -11,6 +11,7 @@
 #include <linux/utime.h>
 #include <linux/file.h>
 #include <linux/memblock.h>
+#include <linux/namei.h>
 
 static ssize_t __init xwrite(int fd, const char *p, size_t count)
 {
@@ -572,51 +573,14 @@ static inline bool kexec_free_initrd(void)
 #endif /* CONFIG_KEXEC_CORE */
 
 #ifdef CONFIG_BLK_DEV_RAM
-#define BUF_SIZE 1024
 static void __init clean_rootfs(void)
 {
-	int fd;
-	void *buf;
-	struct linux_dirent64 *dirp;
-	int num;
+	struct path path;
 
-	fd = ksys_open("/", O_RDONLY, 0);
-	WARN_ON(fd < 0);
-	if (fd < 0)
-		return;
-	buf = kzalloc(BUF_SIZE, GFP_KERNEL);
-	WARN_ON(!buf);
-	if (!buf) {
-		ksys_close(fd);
+	if (kern_path("/", 0, &path))
 		return;
-	}
-
-	dirp = buf;
-	num = ksys_getdents64(fd, dirp, BUF_SIZE);
-	while (num > 0) {
-		while (num > 0) {
-			struct kstat st;
-			int ret;
-
-			ret = vfs_lstat(dirp->d_name, &st);
-			WARN_ON_ONCE(ret);
-			if (!ret) {
-				if (S_ISDIR(st.mode))
-					ksys_rmdir(dirp->d_name);
-				else
-					ksys_unlink(dirp->d_name);
-			}
-
-			num -= dirp->d_reclen;
-			dirp = (void *)dirp + dirp->d_reclen;
-		}
-		dirp = buf;
-		memset(buf, 0, BUF_SIZE);
-		num = ksys_getdents64(fd, dirp, BUF_SIZE);
-	}
-
-	ksys_close(fd);
-	kfree(buf);
+	d_genocide(path.dentry);
+	path_put(&path);
 }
 
 static void __init populate_initrd_image(char *err)
-- 
2.27.0
