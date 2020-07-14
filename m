From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/23] fs: remove ksys_fchmod
Date: Tue, 14 Jul 2020 21:04:26 +0200
Message-ID: <20200714190427.4332-23-hch@lst.de>
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
 fs/open.c                | 7 +------
 include/linux/syscalls.h | 1 -
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index ab3671af8a9705..b316dd6a86a8b9 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -608,7 +608,7 @@ int vfs_fchmod(struct file *file, umode_t mode)
 	return chmod_common(&file->f_path, mode);
 }
 
-int ksys_fchmod(unsigned int fd, umode_t mode)
+SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
 {
 	struct fd f = fdget(fd);
 	int err = -EBADF;
@@ -620,11 +620,6 @@ int ksys_fchmod(unsigned int fd, umode_t mode)
 	return err;
 }
 
-SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
-{
-	return ksys_fchmod(fd, mode);
-}
-
 int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
 {
 	struct path path;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b6d90057476260..39ff738997a172 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1240,7 +1240,6 @@ int ksys_umount(char __user *name, int flags);
 int ksys_chroot(const char __user *filename);
 ssize_t ksys_write(unsigned int fd, const char __user *buf, size_t count);
 int ksys_chdir(const char __user *filename);
-int ksys_fchmod(unsigned int fd, umode_t mode);
 int ksys_fchown(unsigned int fd, uid_t user, gid_t group);
 int ksys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg);
 ssize_t ksys_read(unsigned int fd, char __user *buf, size_t count);
-- 
2.27.0
