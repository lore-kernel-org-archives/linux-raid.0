From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/24] fs: move the putname from filename_lookup to the callers
Date: Mon, 20 Jul 2020 17:58:43 +0200
Message-ID: <20200720155902.181712-6-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

This allows reusing the struct filename for retries, and will also allow
pushing the getname up the stack for a few places to allower for better
handling of kernel space filenames.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs_parser.c |  1 +
 fs/namei.c     | 28 ++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/fs_parser.c b/fs/fs_parser.c
index ab53e42a874aaa..58d5e53d74eeb7 100644
--- a/fs/fs_parser.c
+++ b/fs/fs_parser.c
@@ -171,6 +171,7 @@ int fs_lookup_param(struct fs_context *fc,
 		errorf(fc, "%s: Lookup failure for '%s'", param->key, f->name);
 		goto out;
 	}
+	putname(f);
 
 	if (want_bdev &&
 	    !S_ISBLK(d_backing_inode(_path->dentry)->i_mode)) {
diff --git a/fs/namei.c b/fs/namei.c
index 6ebe400c9736d2..6daffd59e97270 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2372,8 +2372,9 @@ int filename_lookup(int dfd, struct filename *name, unsigned flags,
 	if (likely(!retval))
 		audit_inode(name, path->dentry,
 			    flags & LOOKUP_MOUNTPOINT ? AUDIT_INODE_NOEVAL : 0);
+	else
+		putname(name);
 	restore_nameidata();
-	putname(name);
 	return retval;
 }
 
@@ -2450,8 +2451,12 @@ struct dentry *kern_path_locked(const char *name, struct path *path)
 
 int kern_path(const char *name, unsigned int flags, struct path *path)
 {
-	return filename_lookup(AT_FDCWD, getname_kernel(name),
-			       flags, path, NULL);
+	struct filename *f = getname_kernel(name);
+	int ret = filename_lookup(AT_FDCWD, f, flags, path, NULL);
+
+	if (!ret)
+		putname(f);
+	return ret;
 }
 EXPORT_SYMBOL(kern_path);
 
@@ -2468,9 +2473,12 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
 		    struct path *path)
 {
 	struct path root = {.mnt = mnt, .dentry = dentry};
-	/* the first argument of filename_lookup() is ignored with root */
-	return filename_lookup(AT_FDCWD, getname_kernel(name),
-			       flags , path, &root);
+	struct filename *f = getname_kernel(name);
+	int ret = filename_lookup(AT_FDCWD, f, flags, path, &root);
+
+	if (!ret)
+		putname(f);
+	return ret;
 }
 EXPORT_SYMBOL(vfs_path_lookup);
 
@@ -2643,8 +2651,12 @@ int path_pts(struct path *path)
 int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
 		 struct path *path, int *empty)
 {
-	return filename_lookup(dfd, getname_flags(name, flags, empty),
-			       flags, path, NULL);
+	struct filename *f = getname_flags(name, flags, empty);
+	int ret = filename_lookup(dfd, f, flags, path, NULL);
+
+	if (!ret)
+		putname(f);
+	return ret;
 }
 EXPORT_SYMBOL(user_path_at_empty);
 
-- 
2.27.0
