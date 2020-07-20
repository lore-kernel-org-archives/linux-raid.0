From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 19/24] fs: remove vfs_statx_fd
Date: Mon, 20 Jul 2020 17:58:57 +0200
Message-ID: <20200720155902.181712-20-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200720155902.181712-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

vfs_statx_fd is only used to implement vfs_fstat.  Remove vfs_statx_fd
and just implement vfs_fstat directly.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/stat.c          | 22 +++++++---------------
 include/linux/fs.h |  7 +------
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 44f8ad346db4ca..2683a051ce07fa 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -126,35 +126,27 @@ int vfs_getattr(const struct path *path, struct kstat *stat,
 EXPORT_SYMBOL(vfs_getattr);
 
 /**
- * vfs_statx_fd - Get the enhanced basic attributes by file descriptor
+ * vfs_fstat - Get the basic attributes by file descriptor
  * @fd: The file descriptor referring to the file of interest
  * @stat: The result structure to fill in.
- * @request_mask: STATX_xxx flags indicating what the caller wants
- * @query_flags: Query mode (KSTAT_QUERY_FLAGS)
  *
  * This function is a wrapper around vfs_getattr().  The main difference is
  * that it uses a file descriptor to determine the file location.
  *
  * 0 will be returned on success, and a -ve error code if unsuccessful.
  */
-int vfs_statx_fd(unsigned int fd, struct kstat *stat,
-		 u32 request_mask, unsigned int query_flags)
+int vfs_fstat(int fd, struct kstat *stat)
 {
 	struct fd f;
-	int error = -EBADF;
-
-	if (query_flags & ~KSTAT_QUERY_FLAGS)
-		return -EINVAL;
+	int error;
 
 	f = fdget_raw(fd);
-	if (f.file) {
-		error = vfs_getattr(&f.file->f_path, stat,
-				    request_mask, query_flags);
-		fdput(f);
-	}
+	if (!f.file)
+		return -EBADF;
+	error = vfs_getattr(&f.file->f_path, stat, STATX_BASIC_STATS, 0);
+	fdput(f);
 	return error;
 }
-EXPORT_SYMBOL(vfs_statx_fd);
 
 static inline unsigned vfs_stat_set_lookup_flags(unsigned *lookup_flags,
 						 int flags)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6100b9f92cee8b..0169d3efa844d0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3297,7 +3297,7 @@ extern const struct inode_operations simple_symlink_inode_operations;
 extern int iterate_dir(struct file *, struct dir_context *);
 
 extern int vfs_statx(int, const char __user *, int, struct kstat *, u32);
-extern int vfs_statx_fd(unsigned int, struct kstat *, u32, unsigned int);
+int vfs_fstat(int fd, struct kstat *stat);
 
 static inline int vfs_stat(const char __user *filename, struct kstat *stat)
 {
@@ -3315,11 +3315,6 @@ static inline int vfs_fstatat(int dfd, const char __user *filename,
 	return vfs_statx(dfd, filename, flags | AT_NO_AUTOMOUNT,
 			 stat, STATX_BASIC_STATS);
 }
-static inline int vfs_fstat(int fd, struct kstat *stat)
-{
-	return vfs_statx_fd(fd, stat, STATX_BASIC_STATS, 0);
-}
-
 
 extern const char *vfs_get_link(struct dentry *, struct delayed_call *);
 extern int vfs_readlink(struct dentry *, char __user *, int);
-- 
2.27.0
