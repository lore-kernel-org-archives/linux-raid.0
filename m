From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/24] fs: remove KSTAT_QUERY_FLAGS
Date: Mon, 20 Jul 2020 17:59:01 +0200
Message-ID: <20200720155902.181712-24-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

KSTAT_QUERY_FLAGS expands to AT_STATX_SYNC_TYPE, which itself already
is a mask.  Remove the double name, especially given that the prefix
is a little confusing vs the normal AT_* flags.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/stat.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 8acc4b14ac24c9..dacecdda2e7967 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -56,7 +56,7 @@ EXPORT_SYMBOL(generic_fillattr);
  * @path: file to get attributes from
  * @stat: structure to return attributes in
  * @request_mask: STATX_xxx flags indicating what the caller wants
- * @query_flags: Query mode (KSTAT_QUERY_FLAGS)
+ * @query_flags: Query mode (AT_STATX_SYNC_TYPE)
  *
  * Get attributes without calling security_inode_getattr.
  *
@@ -71,7 +71,7 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 
 	memset(stat, 0, sizeof(*stat));
 	stat->result_mask |= STATX_BASIC_STATS;
-	query_flags &= KSTAT_QUERY_FLAGS;
+	query_flags &= AT_STATX_SYNC_TYPE;
 
 	/* allow the fs to override these if it really wants to */
 	/* SB_NOATIME means filesystem supplies dummy atime value */
@@ -97,7 +97,7 @@ EXPORT_SYMBOL(vfs_getattr_nosec);
  * @path: The file of interest
  * @stat: Where to return the statistics
  * @request_mask: STATX_xxx flags indicating what the caller wants
- * @query_flags: Query mode (KSTAT_QUERY_FLAGS)
+ * @query_flags: Query mode (AT_STATX_SYNC_TYPE)
  *
  * Ask the filesystem for a file's attributes.  The caller must indicate in
  * request_mask and query_flags to indicate what they want.
@@ -171,7 +171,7 @@ static int vfs_statx(int dfd, const char __user *filename, int flags,
 	int error;
 
 	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT | AT_EMPTY_PATH |
-		      KSTAT_QUERY_FLAGS))
+		      AT_STATX_SYNC_TYPE))
 		return -EINVAL;
 
 	if (!(flags & AT_SYMLINK_NOFOLLOW))
-- 
2.27.0
