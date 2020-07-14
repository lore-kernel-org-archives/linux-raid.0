From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/23] fs: remove ksys_getdents64
Date: Tue, 14 Jul 2020 21:04:23 +0200
Message-ID: <20200714190427.4332-20-hch@lst.de>
References: <20200714190427.4332-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Just open code it in the only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/readdir.c             | 11 ++---------
 include/linux/syscalls.h |  2 --
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index a49f07c11cfbd0..19434b3c982cd3 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -348,8 +348,8 @@ static int filldir64(struct dir_context *ctx, const char *name, int namlen,
 	return -EFAULT;
 }
 
-int ksys_getdents64(unsigned int fd, struct linux_dirent64 __user *dirent,
-		    unsigned int count)
+SYSCALL_DEFINE3(getdents64, unsigned int, fd,
+		struct linux_dirent64 __user *, dirent, unsigned int, count)
 {
 	struct fd f;
 	struct getdents_callback64 buf = {
@@ -380,13 +380,6 @@ int ksys_getdents64(unsigned int fd, struct linux_dirent64 __user *dirent,
 	return error;
 }
 
-
-SYSCALL_DEFINE3(getdents64, unsigned int, fd,
-		struct linux_dirent64 __user *, dirent, unsigned int, count)
-{
-	return ksys_getdents64(fd, dirent, count);
-}
-
 #ifdef CONFIG_COMPAT
 struct compat_old_linux_dirent {
 	compat_ulong_t	d_ino;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 10843a6adb770d..a998651629c71b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1243,8 +1243,6 @@ ssize_t ksys_write(unsigned int fd, const char __user *buf, size_t count);
 int ksys_chdir(const char __user *filename);
 int ksys_fchmod(unsigned int fd, umode_t mode);
 int ksys_fchown(unsigned int fd, uid_t user, gid_t group);
-int ksys_getdents64(unsigned int fd, struct linux_dirent64 __user *dirent,
-		    unsigned int count);
 int ksys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg);
 ssize_t ksys_read(unsigned int fd, char __user *buf, size_t count);
 void ksys_sync(void);
-- 
2.27.0
