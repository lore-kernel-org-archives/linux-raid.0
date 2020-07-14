From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/23] fs: remove ksys_dup
Date: Tue, 14 Jul 2020 21:04:25 +0200
Message-ID: <20200714190427.4332-22-hch@lst.de>
References: <20200714190427.4332-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Fold it into the only remaining caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/file.c                | 7 +------
 include/linux/syscalls.h | 1 -
 2 files changed, 1 insertion(+), 7 deletions(-)

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
index 363baaadf8e19a..b6d90057476260 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1237,7 +1237,6 @@ asmlinkage long sys_ni_syscall(void);
  */
 
 int ksys_umount(char __user *name, int flags);
-int ksys_dup(unsigned int fildes);
 int ksys_chroot(const char __user *filename);
 ssize_t ksys_write(unsigned int fd, const char __user *buf, size_t count);
 int ksys_chdir(const char __user *filename);
-- 
2.27.0
