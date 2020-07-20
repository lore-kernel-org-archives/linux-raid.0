From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/24] fs: remove vfs_stat_set_lookup_flags
Date: Mon, 20 Jul 2020 17:59:00 +0200
Message-ID: <20200720155902.181712-23-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

The function really obsfucates checking for valid flags and setting the
lookup flags.  The fact that it returns -EINVAL through and unsigned
return value, which is then used as boolean really doesn't help either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/stat.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index ddf0176d4dbcd7..8acc4b14ac24c9 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -148,24 +148,6 @@ int vfs_fstat(int fd, struct kstat *stat)
 	return error;
 }
 
-static inline unsigned vfs_stat_set_lookup_flags(unsigned *lookup_flags,
-						 int flags)
-{
-	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
-		       AT_EMPTY_PATH | KSTAT_QUERY_FLAGS)) != 0)
-		return -EINVAL;
-
-	*lookup_flags = LOOKUP_FOLLOW | LOOKUP_AUTOMOUNT;
-	if (flags & AT_SYMLINK_NOFOLLOW)
-		*lookup_flags &= ~LOOKUP_FOLLOW;
-	if (flags & AT_NO_AUTOMOUNT)
-		*lookup_flags &= ~LOOKUP_AUTOMOUNT;
-	if (flags & AT_EMPTY_PATH)
-		*lookup_flags |= LOOKUP_EMPTY;
-
-	return 0;
-}
-
 /**
  * vfs_statx - Get basic and extra attributes by filename
  * @dfd: A file descriptor representing the base dir for a relative filename
@@ -185,11 +167,20 @@ static int vfs_statx(int dfd, const char __user *filename, int flags,
 	      struct kstat *stat, u32 request_mask)
 {
 	struct path path;
-	int error = -EINVAL;
-	unsigned lookup_flags;
+	unsigned lookup_flags = 0;
+	int error;
 
-	if (vfs_stat_set_lookup_flags(&lookup_flags, flags))
+	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT | AT_EMPTY_PATH |
+		      KSTAT_QUERY_FLAGS))
 		return -EINVAL;
+
+	if (!(flags & AT_SYMLINK_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+	if (!(flags & AT_NO_AUTOMOUNT))
+		lookup_flags |= LOOKUP_AUTOMOUNT;
+	if (flags & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
+
 retry:
 	error = user_path_at(dfd, filename, lookup_flags, &path);
 	if (error)
-- 
2.27.0
