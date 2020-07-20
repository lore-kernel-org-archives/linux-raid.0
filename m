From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/24] fs: move vfs_fstatat out of line
Date: Mon, 20 Jul 2020 17:58:59 +0200
Message-ID: <20200720155902.181712-22-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

This allows to keep vfs_statx static in fs/stat.c to prepare for the following
changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/stat.c          | 9 +++++++--
 include/linux/fs.h | 9 ++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 2683a051ce07fa..ddf0176d4dbcd7 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -181,7 +181,7 @@ static inline unsigned vfs_stat_set_lookup_flags(unsigned *lookup_flags,
  *
  * 0 will be returned on success, and a -ve error code if unsuccessful.
  */
-int vfs_statx(int dfd, const char __user *filename, int flags,
+static int vfs_statx(int dfd, const char __user *filename, int flags,
 	      struct kstat *stat, u32 request_mask)
 {
 	struct path path;
@@ -209,8 +209,13 @@ int vfs_statx(int dfd, const char __user *filename, int flags,
 out:
 	return error;
 }
-EXPORT_SYMBOL(vfs_statx);
 
+int vfs_fstatat(int dfd, const char __user *filename,
+			      struct kstat *stat, int flags)
+{
+	return vfs_statx(dfd, filename, flags | AT_NO_AUTOMOUNT,
+			 stat, STATX_BASIC_STATS);
+}
 
 #ifdef __ARCH_WANT_OLD_STAT
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4d9d33c62fa2e5..0e0cd6a988bb38 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3296,15 +3296,10 @@ extern const struct inode_operations simple_symlink_inode_operations;
 
 extern int iterate_dir(struct file *, struct dir_context *);
 
-extern int vfs_statx(int, const char __user *, int, struct kstat *, u32);
+int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
+		int flags);
 int vfs_fstat(int fd, struct kstat *stat);
 
-static inline int vfs_fstatat(int dfd, const char __user *filename,
-			      struct kstat *stat, int flags)
-{
-	return vfs_statx(dfd, filename, flags | AT_NO_AUTOMOUNT,
-			 stat, STATX_BASIC_STATS);
-}
 static inline int vfs_stat(const char __user *filename, struct kstat *stat)
 {
 	return vfs_fstatat(AT_FDCWD, filename, stat, 0);
-- 
2.27.0
