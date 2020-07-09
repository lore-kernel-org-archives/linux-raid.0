From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/17] fs: remove ksys_open
Date: Thu,  9 Jul 2020 17:18:14 +0200
Message-ID: <20200709151814.110422-18-hch@lst.de>
References: <20200709151814.110422-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200709151814.110422-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Just open code it in the two callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/open.c                | 11 ++++++++---
 include/linux/syscalls.h | 11 -----------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 6348173532e663..4375a5a8e726ea 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1193,7 +1193,9 @@ long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
 
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 {
-	return ksys_open(filename, flags, mode);
+	if (force_o_largefile())
+		flags |= O_LARGEFILE;
+	return do_sys_open(AT_FDCWD, filename, flags, mode);
 }
 
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
@@ -1255,9 +1257,12 @@ COMPAT_SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, fla
  */
 SYSCALL_DEFINE2(creat, const char __user *, pathname, umode_t, mode)
 {
-	return ksys_open(pathname, O_CREAT | O_WRONLY | O_TRUNC, mode);
-}
+	int flags = O_CREAT | O_WRONLY | O_TRUNC;
 
+	if (force_o_largefile())
+		flags |= O_LARGEFILE;
+	return do_sys_open(AT_FDCWD, pathname, flags, mode);
+}
 #endif
 
 /*
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 59af62090ac400..39ff738997a172 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1372,17 +1372,6 @@ static inline int ksys_close(unsigned int fd)
 	return __close_fd(current->files, fd);
 }
 
-extern long do_sys_open(int dfd, const char __user *filename, int flags,
-			umode_t mode);
-
-static inline long ksys_open(const char __user *filename, int flags,
-			     umode_t mode)
-{
-	if (force_o_largefile())
-		flags |= O_LARGEFILE;
-	return do_sys_open(AT_FDCWD, filename, flags, mode);
-}
-
 extern long do_sys_truncate(const char __user *pathname, loff_t length);
 
 static inline long ksys_truncate(const char __user *pathname, loff_t length)
-- 
2.26.2
