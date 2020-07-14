From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/23] fs: remove ksys_open
Date: Tue, 14 Jul 2020 21:04:24 +0200
Message-ID: <20200714190427.4332-21-hch@lst.de>
References: <20200714190427.4332-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-1-hch@lst.de>
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
index 75166f071d280a..ab3671af8a9705 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1208,7 +1208,9 @@ long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
 
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 {
-	return ksys_open(filename, flags, mode);
+	if (force_o_largefile())
+		flags |= O_LARGEFILE;
+	return do_sys_open(AT_FDCWD, filename, flags, mode);
 }
 
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
@@ -1270,9 +1272,12 @@ COMPAT_SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, fla
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
index a998651629c71b..363baaadf8e19a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1374,17 +1374,6 @@ static inline int ksys_close(unsigned int fd)
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
2.27.0
