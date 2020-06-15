From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/16] init: open code setting up stdin/stdout/stderr
Date: Mon, 15 Jun 2020 14:53:22 +0200
Message-ID: <20200615125323.930983-16-hch@lst.de>
References: <20200615125323.930983-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200615125323.930983-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Don't rely on the implicit set_fs(KERNEL_DS) for ksys_open to work, but
instead open a struct file for /dev/console and then install it as FD
0/1/2 manually.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/file.c                |  7 +------
 include/linux/syscalls.h |  1 -
 init/main.c              | 16 ++++++++++------
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index abb8b7081d7a44..85b7993165dd2f 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -985,7 +985,7 @@ SYSCALL_DEFINE2(dup2, unsigned int, oldfd, unsigned int, newfd)
 	return ksys_dup3(oldfd, newfd, 0);
 }
 
-int ksys_dup(unsigned int fildes)
+SYSCALL_DEFINE1(dup, unsigned int, fildes)
 {
 	int ret = -EBADF;
 	struct file *file = fget_raw(fildes);
@@ -1000,11 +1000,6 @@ int ksys_dup(unsigned int fildes)
 	return ret;
 }
 
-SYSCALL_DEFINE1(dup, unsigned int, fildes)
-{
-	return ksys_dup(fildes);
-}
-
 int f_dupfd(unsigned int from, struct file *file, unsigned flags)
 {
 	int err;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 5215bd413b6eb1..bde56097a7c27e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1237,7 +1237,6 @@ asmlinkage long sys_ni_syscall(void);
  */
 
 int ksys_umount(char __user *name, int flags);
-int ksys_dup(unsigned int fildes);
 int ksys_chroot(const char __user *filename);
 ssize_t ksys_write(unsigned int fd, const char __user *buf, size_t count);
 int ksys_chdir(const char __user *filename);
diff --git a/init/main.c b/init/main.c
index 0ead83e86b5aa2..db0621dfbb0468 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1457,15 +1457,19 @@ static int __ref kernel_init(void *unused)
 	      "See Linux Documentation/admin-guide/init.rst for guidance.");
 }
 
+/* Open /dev/console, for stdin/stdout/stderr, this should never fail */
 void console_on_rootfs(void)
 {
-	/* Open the /dev/console as stdin, this should never fail */
-	if (ksys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
-		pr_err("Warning: unable to open an initial console.\n");
+	struct file *file = filp_open("/dev/console", O_RDWR, 0);
 
-	/* create stdout/stderr */
-	(void) ksys_dup(0);
-	(void) ksys_dup(0);
+	if (IS_ERR(file)) {
+		pr_err("Warning: unable to open an initial console.\n");
+		return;
+	}
+	get_file_rcu_many(file, 2);
+	fd_install(get_unused_fd_flags(0), file);
+	fd_install(get_unused_fd_flags(0), file);
+	fd_install(get_unused_fd_flags(0), file);
 }
 
 static noinline void __init kernel_init_freeable(void)
-- 
2.26.2
