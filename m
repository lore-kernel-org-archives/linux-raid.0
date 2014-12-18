From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 06/24] Introduce md_cluster_info
Date: Thu, 18 Dec 2014 10:16:29 -0600
Message-ID: <20141218161629.GA29597@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

md_cluster_info stores the cluster information in the MD device.

The join() is called when mddev detects it is a clustered device.
The main responsibilities are:
	1. Setup a DLM lockspace
	2. Setup all initial locks such as super block locks and bitmap lock (will come later)

The leave() clears up the lockspace and all the locks held.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/bitmap.c     |  4 +++
 drivers/md/md-cluster.c | 67 +++++++++++++++++++++++++++++++++++++++++++++----
 drivers/md/md.h         |  8 ++++++
 3 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 4195a01..33374de 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -420,6 +420,7 @@ void bitmap_update_sb(struct bitmap *bitmap)
 	/* This might have been changed by a reshape */
 	sb->sync_size = cpu_to_le64(bitmap->mddev->resync_max_sectors);
 	sb->chunksize = cpu_to_le32(bitmap->mddev->bitmap_info.chunksize);
+	sb->nodes = cpu_to_le32(bitmap->mddev->bitmap_info.nodes);
 	sb->sectors_reserved = cpu_to_le32(bitmap->mddev->
 					   bitmap_info.space);
 	kunmap_atomic(sb);
@@ -531,6 +532,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	bitmap_super_t *sb;
 	unsigned long chunksize, daemon_sleep, write_behind;
 	unsigned long long events;
+	int nodes = 0;
 	unsigned long sectors_reserved = 0;
 	int err = -EINVAL;
 	struct page *sb_page;
@@ -570,6 +572,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
 	write_behind = le32_to_cpu(sb->write_behind);
 	sectors_reserved = le32_to_cpu(sb->sectors_reserved);
+	nodes = le32_to_cpu(sb->nodes);
 
 	/* verify that the bitmap-specific fields are valid */
 	if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
@@ -630,6 +633,7 @@ out_no_sb:
 	bitmap->mddev->bitmap_info.chunksize = chunksize;
 	bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
 	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
+	bitmap->mddev->bitmap_info.nodes = nodes;
 	if (bitmap->mddev->bitmap_info.space == 0 ||
 	    bitmap->mddev->bitmap_info.space > sectors_reserved)
 		bitmap->mddev->bitmap_info.space = sectors_reserved;
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index d2d4d33..fa28aed 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -25,8 +25,16 @@ struct dlm_lock_resource {
 	struct dlm_lksb lksb;
 	char *name; /* lock name. */
 	uint32_t flags; /* flags to pass to dlm_lock() */
-	void (*bast)(void *arg, int mode); /* blocking AST function pointer*/
 	struct completion completion; /* completion for synchronized locking */
+	struct mddev *mddev; /* pointing back to mddev. */
+	void (*bast)(void *arg, int mode); /* blocking AST function pointer*/
+};
+
+struct md_cluster_info {
+	/* dlm lock space and resources for clustered raid. */
+	dlm_lockspace_t *lockspace;
+	struct dlm_lock_resource *sb_lock;
+	struct mutex sb_mutex;
 };
 
 static void sync_ast(void *arg)
@@ -54,16 +62,18 @@ static int dlm_unlock_sync(struct dlm_lock_resource *res)
 	return dlm_lock_sync(res, DLM_LOCK_NL);
 }
 
-static struct dlm_lock_resource *lockres_init(dlm_lockspace_t *lockspace,
+static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 		char *name, void (*bastfn)(void *arg, int mode), int with_lvb)
 {
 	struct dlm_lock_resource *res = NULL;
 	int ret, namelen;
+	struct md_cluster_info *cinfo = mddev->cluster_info;
 
 	res = kzalloc(sizeof(struct dlm_lock_resource), GFP_KERNEL);
 	if (!res)
 		return NULL;
-	res->ls = lockspace;
+	res->ls = cinfo->lockspace;
+	res->mddev = mddev;
 	namelen = strlen(name);
 	res->name = kzalloc(namelen + 1, GFP_KERNEL);
 	if (!res->name) {
@@ -119,13 +129,60 @@ static void lockres_free(struct dlm_lock_resource *res)
 	return;
 }
 
-static int join(struct mddev *md, int nodes)
+static char *pretty_uuid(char *dest, char *src)
 {
+	int i, len = 0;
+	for (i=0; i<16; i++) {
+		if (i==4 || i==6 || i==8 || i==10)
+			len += sprintf(dest + len, "-");
+		len += sprintf(dest + len, "%02x", (__u8)src[i]);
+	}
+	return dest;
+}
+
+static int join(struct mddev *mddev, int nodes)
+{
+	struct md_cluster_info *cinfo;
+	int ret;
+	char str[64];
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENOENT;
+
+	cinfo = kzalloc(sizeof(struct md_cluster_info), GFP_KERNEL);
+	if (!cinfo)
+		return -ENOMEM;
+
+	memset(str, 0, 64);
+	pretty_uuid(str, mddev->uuid);
+	ret = dlm_new_lockspace(str, NULL, DLM_LSFL_FS, LVB_SIZE,
+				NULL, NULL, NULL, &cinfo->lockspace);
+	if (ret)
+		goto err;
+	cinfo->sb_lock = lockres_init(mddev, "cmd-super",
+					NULL, 0);
+	if (!cinfo->sb_lock) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	mutex_init(&cinfo->sb_mutex);
+	mddev->cluster_info = cinfo;
 	return 0;
+err:
+	if (cinfo->lockspace)
+		dlm_release_lockspace(cinfo->lockspace, 2);
+	kfree(cinfo);
+	module_put(THIS_MODULE);
+	return ret;
 }
 
-static int leave(struct mddev *md)
+static int leave(struct mddev *mddev)
 {
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	if (!cinfo)
+		return 0;
+	lockres_free(cinfo->sb_lock);
+	dlm_release_lockspace(cinfo->lockspace, 2);
 	return 0;
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 076e1ae..8017e18 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -203,6 +203,8 @@ extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 				int is_new);
 extern void md_ack_all_badblocks(struct badblocks *bb);
 
+struct md_cluster_info;
+
 struct mddev {
 	void				*private;
 	struct md_personality		*pers;
@@ -420,6 +422,7 @@ struct mddev {
 		unsigned long		daemon_sleep; /* how many jiffies between updates? */
 		unsigned long		max_write_behind; /* write-behind mode */
 		int			external;
+		int			nodes;
 	} bitmap_info;
 
 	atomic_t 			max_corr_read_errors; /* max read retries */
@@ -438,6 +441,7 @@ struct mddev {
 	struct work_struct flush_work;
 	struct work_struct event_work;	/* used by dm to report failure event */
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
+	struct md_cluster_info		*cluster_info;
 };
 
 
@@ -634,4 +638,8 @@ static inline int mddev_check_plugged(struct mddev *mddev)
 				   sizeof(struct blk_plug_cb));
 }
 extern struct md_cluster_operations *md_cluster_ops;
+static inline int mddev_is_clustered(struct mddev *mddev)
+{
+	return mddev->cluster_info && mddev->bitmap_info.nodes > 1;
+}
 #endif /* _MD_MD_H */
-- 
2.1.2

