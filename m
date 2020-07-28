From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/23] fs: refactor ksys_umount
Date: Tue, 28 Jul 2020 18:33:55 +0200
Message-ID: <20200728163416.556521-3-hch@lst.de>
References: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200728163416.556521-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Factor out a path_umount helper that takes a struct path * instead of the
actual file name.  This will allow to convert the init and devtmpfs code
to properly mount based on a kernel pointer instead of relying on the
implicit set_fs(KERNEL_DS) during early init.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/namespace.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 6f8234f74bed90..43834b59eff6c3 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1706,36 +1706,19 @@ static inline bool may_mandlock(void)
 }
 #endif
 
-/*
- * Now umount can handle mount points as well as block devices.
- * This is important for filesystems which use unnamed block devices.
- *
- * We now support a flag for forced unmount like the other 'big iron'
- * unixes. Our API is identical to OSF/1 to avoid making a mess of AMD
- */
-
-int ksys_umount(char __user *name, int flags)
+static int path_umount(struct path *path, int flags)
 {
-	struct path path;
 	struct mount *mnt;
 	int retval;
-	int lookup_flags = LOOKUP_MOUNTPOINT;
 
 	if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | UMOUNT_NOFOLLOW))
 		return -EINVAL;
-
 	if (!may_mount())
 		return -EPERM;
 
-	if (!(flags & UMOUNT_NOFOLLOW))
-		lookup_flags |= LOOKUP_FOLLOW;
-
-	retval = user_path_at(AT_FDCWD, name, lookup_flags, &path);
-	if (retval)
-		goto out;
-	mnt = real_mount(path.mnt);
+	mnt = real_mount(path->mnt);
 	retval = -EINVAL;
-	if (path.dentry != path.mnt->mnt_root)
+	if (path->dentry != path->mnt->mnt_root)
 		goto dput_and_out;
 	if (!check_mnt(mnt))
 		goto dput_and_out;
@@ -1748,12 +1731,25 @@ int ksys_umount(char __user *name, int flags)
 	retval = do_umount(mnt, flags);
 dput_and_out:
 	/* we mustn't call path_put() as that would clear mnt_expiry_mark */
-	dput(path.dentry);
+	dput(path->dentry);
 	mntput_no_expire(mnt);
-out:
 	return retval;
 }
 
+int ksys_umount(char __user *name, int flags)
+{
+	int lookup_flags = LOOKUP_MOUNTPOINT;
+	struct path path;
+	int ret;
+
+	if (!(flags & UMOUNT_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+	ret = user_path_at(AT_FDCWD, name, lookup_flags, &path);
+	if (ret)
+		return ret;
+	return path_umount(&path, flags);
+}
+
 SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 {
 	return ksys_umount(name, flags);
-- 
2.27.0
