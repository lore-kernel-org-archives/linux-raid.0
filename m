From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/24] fs: implement vfs_stat and vfs_lstat in terms of vfs_fstatat
Date: Mon, 20 Jul 2020 17:58:58 +0200
Message-ID: <20200720155902.181712-21-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Go through vfs_fstatat instead of duplicating the *stat to statx mapping
three times.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fs.h | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0169d3efa844d0..4d9d33c62fa2e5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3299,21 +3299,19 @@ extern int iterate_dir(struct file *, struct dir_context *);
 extern int vfs_statx(int, const char __user *, int, struct kstat *, u32);
 int vfs_fstat(int fd, struct kstat *stat);
 
-static inline int vfs_stat(const char __user *filename, struct kstat *stat)
+static inline int vfs_fstatat(int dfd, const char __user *filename,
+			      struct kstat *stat, int flags)
 {
-	return vfs_statx(AT_FDCWD, filename, AT_NO_AUTOMOUNT,
+	return vfs_statx(dfd, filename, flags | AT_NO_AUTOMOUNT,
 			 stat, STATX_BASIC_STATS);
 }
-static inline int vfs_lstat(const char __user *name, struct kstat *stat)
+static inline int vfs_stat(const char __user *filename, struct kstat *stat)
 {
-	return vfs_statx(AT_FDCWD, name, AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT,
-			 stat, STATX_BASIC_STATS);
+	return vfs_fstatat(AT_FDCWD, filename, stat, 0);
 }
-static inline int vfs_fstatat(int dfd, const char __user *filename,
-			      struct kstat *stat, int flags)
+static inline int vfs_lstat(const char __user *name, struct kstat *stat)
 {
-	return vfs_statx(dfd, filename, flags | AT_NO_AUTOMOUNT,
-			 stat, STATX_BASIC_STATS);
+	return vfs_fstatat(AT_FDCWD, name, stat, AT_SYMLINK_NOFOLLOW);
 }
 
 extern const char *vfs_get_link(struct dentry *, struct delayed_call *);
-- 
2.27.0
