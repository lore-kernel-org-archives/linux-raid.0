From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/23] fs: remove ksys_ioctl
Date: Tue, 14 Jul 2020 21:04:27 +0200
Message-ID: <20200714190427.4332-24-hch@lst.de>
References: <20200714190427.4332-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Fold it into the only remaining caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ioctl.c               | 7 +------
 include/linux/syscalls.h | 1 -
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index d69786d1dd9115..4e6cc0a7d69c9f 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -736,7 +736,7 @@ static int do_vfs_ioctl(struct file *filp, unsigned int fd,
 	return -ENOIOCTLCMD;
 }
 
-int ksys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
+SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
 {
 	struct fd f = fdget(fd);
 	int error;
@@ -757,11 +757,6 @@ int ksys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
 	return error;
 }
 
-SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
-{
-	return ksys_ioctl(fd, cmd, arg);
-}
-
 #ifdef CONFIG_COMPAT
 /**
  * compat_ptr_ioctl - generic implementation of .compat_ioctl file operation
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 39ff738997a172..5b0f1fca4cfb9d 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1241,7 +1241,6 @@ int ksys_chroot(const char __user *filename);
 ssize_t ksys_write(unsigned int fd, const char __user *buf, size_t count);
 int ksys_chdir(const char __user *filename);
 int ksys_fchown(unsigned int fd, uid_t user, gid_t group);
-int ksys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg);
 ssize_t ksys_read(unsigned int fd, char __user *buf, size_t count);
 void ksys_sync(void);
 int ksys_unshare(unsigned long unshare_flags);
-- 
2.27.0
