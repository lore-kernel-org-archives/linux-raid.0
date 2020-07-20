From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/24] fs: move the putname from filename_create to the callers
Date: Mon, 20 Jul 2020 17:58:42 +0200
Message-ID: <20200720155902.181712-5-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

This allows reusing the struct filename for retries, and will also allow
pushing the getname up the stack for a few places to allower for better
handling of kernel space filenames.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/namei.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 72d4219c93acb7..6ebe400c9736d2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3478,7 +3478,6 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 		error = err2;
 		goto fail;
 	}
-	putname(name);
 	return dentry;
 fail:
 	dput(dentry);
@@ -3496,8 +3495,12 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 struct dentry *kern_path_create(int dfd, const char *pathname,
 				struct path *path, unsigned int lookup_flags)
 {
-	return filename_create(dfd, getname_kernel(pathname),
-				path, lookup_flags);
+	struct filename *name = getname_kernel(pathname);
+	struct dentry *dentry = filename_create(dfd, name, path, lookup_flags);
+
+	if (!IS_ERR(dentry))
+		putname(name);
+	return dentry;
 }
 EXPORT_SYMBOL(kern_path_create);
 
@@ -3513,7 +3516,12 @@ EXPORT_SYMBOL(done_path_create);
 inline struct dentry *user_path_create(int dfd, const char __user *pathname,
 				struct path *path, unsigned int lookup_flags)
 {
-	return filename_create(dfd, getname(pathname), path, lookup_flags);
+	struct filename *name = getname(pathname);
+	struct dentry *dentry = filename_create(dfd, name, path, lookup_flags);
+
+	if (!IS_ERR(dentry))
+		putname(name);
+	return dentry;
 }
 EXPORT_SYMBOL(user_path_create);
 
-- 
2.27.0
