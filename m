From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/24] init: add an init_lstat helper
Date: Tue, 21 Jul 2020 18:28:18 +0200
Message-ID: <20200721162818.197315-25-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200721162818.197315-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Add a simple helper to lstat with a kernel space file name and switch
the early init code over to it.  Remove the now unused ksys_lstat.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts.h |  1 +
 init/fs.c        | 14 ++++++++++++++
 init/initramfs.c |  2 +-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/init/do_mounts.h b/init/do_mounts.h
index a793bafc6c6f2b..20766cfe549b48 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -16,6 +16,7 @@ int __init init_chroot(const char *filename);
 int __init init_chown(const char *filename, uid_t user, gid_t group, int flags);
 int __init init_chmod(const char *filename, umode_t mode);
 int __init init_eaccess(const char *filename);
+int __init init_lstat(const char *filename, struct kstat *stat);
 int __init init_mknod(const char *filename, umode_t mode, unsigned int dev);
 int __init init_link(const char *oldname, const char *newname);
 int __init init_symlink(const char *oldname, const char *newname);
diff --git a/init/fs.c b/init/fs.c
index 7f0e50a877fc98..b387ff67f365db 100644
--- a/init/fs.c
+++ b/init/fs.c
@@ -103,6 +103,20 @@ int __init init_eaccess(const char *filename)
 	return error;
 }
 
+int __init init_lstat(const char *filename, struct kstat *stat)
+{
+	struct path path;
+	int error;
+
+	error = kern_path(filename, 0, &path);
+	if (error)
+		return error;
+	error = vfs_getattr(&path, stat, STATX_BASIC_STATS,
+			    AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT);
+	path_put(&path);
+	return error;
+}
+
 int __init init_mknod(const char *filename, umode_t mode, unsigned int dev)
 {
 	struct dentry *dentry;
diff --git a/init/initramfs.c b/init/initramfs.c
index bd685fdb5840f3..8c9f92f1660b96 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -304,7 +304,7 @@ static void __init clean_path(char *path, umode_t fmode)
 {
 	struct kstat st;
 
-	if (!vfs_lstat(path, &st) && (st.mode ^ fmode) & S_IFMT) {
+	if (!init_lstat(path, &st) && (st.mode ^ fmode) & S_IFMT) {
 		if (S_ISDIR(st.mode))
 			init_rmdir(path);
 		else
-- 
2.27.0
