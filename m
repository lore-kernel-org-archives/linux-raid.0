From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/24] devtmpfs: open code ksys_chdir and ksys_chroot
Date: Tue, 21 Jul 2020 18:27:59 +0200
Message-ID: <20200721162818.197315-6-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200721162818.197315-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

devtmpfs is the only non-early init caller of ksys_chdir and ksys_chroot
with kernel pointers.  Just open code the two operations which only
really need a single path lookup anyway in devtmpfs_setup instead.
The open coded verson doesn't need any of the stale dentry revalidation
logic from the full blown version as those can't happen on tmpfs and
ramfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/base/devtmpfs.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 5e8d677ee783bc..f798d3976b4052 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
+#include <linux/fs_struct.h>
 #include <uapi/linux/mount.h>
 #include "base.h"
 
@@ -393,6 +394,7 @@ static int handle(const char *name, umode_t mode, kuid_t uid, kgid_t gid,
 
 static int devtmpfs_setup(void *p)
 {
+	struct path path;
 	int err;
 
 	err = ksys_unshare(CLONE_NEWNS);
@@ -401,8 +403,16 @@ static int devtmpfs_setup(void *p)
 	err = devtmpfs_do_mount("/");
 	if (err)
 		goto out;
-	ksys_chdir("/.."); /* will traverse into overmounted root */
-	ksys_chroot(".");
+
+	/* traverse into overmounted root and then chroot to it */
+	if (!kern_path("/..", LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path) &&
+	    !inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR) &&
+	    ns_capable(current_user_ns(), CAP_SYS_CHROOT) &&
+	    !security_path_chroot(&path)) {
+		set_fs_pwd(current->fs, &path);
+		set_fs_root(current->fs, &path);
+	}
+	path_put(&path);
 out:
 	*(int *)p = err;
 	complete(&setup_done);
-- 
2.27.0
