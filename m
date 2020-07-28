From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/23] fs: push the getname from do_rmdir into the callers
Date: Tue, 28 Jul 2020 18:33:56 +0200
Message-ID: <20200728163416.556521-4-hch@lst.de>
References: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200728163416.556521-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

This mirrors do_unlinkat and will make life a little easier for
the init code to reuse the whole function with a kernel filename.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/internal.h            |  2 +-
 fs/namei.c               | 10 ++++------
 include/linux/syscalls.h |  4 ++--
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 9b863a7bd70892..e903d5aae139a2 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -65,7 +65,7 @@ extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 		unsigned int dev);
 long do_mkdirat(int dfd, const char __user *pathname, umode_t mode);
-long do_rmdir(int dfd, const char __user *pathname);
+long do_rmdir(int dfd, struct filename *name);
 long do_unlinkat(int dfd, struct filename *name);
 long do_symlinkat(const char __user *oldname, int newdfd,
 		  const char __user *newname);
diff --git a/fs/namei.c b/fs/namei.c
index 72d4219c93acb7..d75a6039ae3966 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3720,17 +3720,16 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 }
 EXPORT_SYMBOL(vfs_rmdir);
 
-long do_rmdir(int dfd, const char __user *pathname)
+long do_rmdir(int dfd, struct filename *name)
 {
 	int error = 0;
-	struct filename *name;
 	struct dentry *dentry;
 	struct path path;
 	struct qstr last;
 	int type;
 	unsigned int lookup_flags = 0;
 retry:
-	name = filename_parentat(dfd, getname(pathname), lookup_flags,
+	name = filename_parentat(dfd, name, lookup_flags,
 				&path, &last, &type);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
@@ -3781,7 +3780,7 @@ long do_rmdir(int dfd, const char __user *pathname)
 
 SYSCALL_DEFINE1(rmdir, const char __user *, pathname)
 {
-	return do_rmdir(AT_FDCWD, pathname);
+	return do_rmdir(AT_FDCWD, getname(pathname));
 }
 
 /**
@@ -3926,8 +3925,7 @@ SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
 		return -EINVAL;
 
 	if (flag & AT_REMOVEDIR)
-		return do_rmdir(dfd, pathname);
-
+		return do_rmdir(dfd, getname(pathname));
 	return do_unlinkat(dfd, getname(pathname));
 }
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 5b0f1fca4cfb9d..e43816198e6001 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1281,11 +1281,11 @@ static inline long ksys_unlink(const char __user *pathname)
 	return do_unlinkat(AT_FDCWD, getname(pathname));
 }
 
-extern long do_rmdir(int dfd, const char __user *pathname);
+long do_rmdir(int dfd, struct filename *name);
 
 static inline long ksys_rmdir(const char __user *pathname)
 {
-	return do_rmdir(AT_FDCWD, pathname);
+	return do_rmdir(AT_FDCWD, getname(pathname));
 }
 
 extern long do_mkdirat(int dfd, const char __user *pathname, umode_t mode);
-- 
2.27.0
