From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 11/24] Gather on-going resync information of other nodes
Date: Thu, 18 Dec 2014 10:17:15 -0600
Message-ID: <20141218161715.GA29618@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When a node joins, it does not know of other nodes performing resync.
So, each node keeps the resync information in it's LVB. When a new
node joins, it reads the LVB of each "online" bitmap.

[TODO] The new node attempts to get the PW lock on other bitmap, if
it is successful, it reads the bitmap and performs the resync (if
required) on it's behalf.

If the node does not get the PW, it requests CR and reads the LVB
for the resync information.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 111 +++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md-cluster.h |   1 +
 drivers/md/md.c         |   8 ++++
 3 files changed, 119 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 4c3ad2c..7d57f3f 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -30,6 +30,18 @@ struct dlm_lock_resource {
 	void (*bast)(void *arg, int mode); /* blocking AST function pointer*/
 };
 
+struct suspend_info {
+	int slot;
+	sector_t lo;
+	sector_t hi;
+	struct list_head list;
+};
+
+struct resync_info {
+	__le64 lo;
+	__le64 hi;
+};
+
 struct md_cluster_info {
 	/* dlm lock space and resources for clustered raid. */
 	dlm_lockspace_t *lockspace;
@@ -38,6 +50,8 @@ struct md_cluster_info {
 	struct dlm_lock_resource *sb_lock;
 	struct mutex sb_mutex;
 	struct dlm_lock_resource *bitmap_lockres;
+	struct list_head suspend_list;
+	spinlock_t suspend_lock;
 };
 
 static void sync_ast(void *arg)
@@ -143,6 +157,36 @@ static char *pretty_uuid(char *dest, char *src)
 	return dest;
 }
 
+static void add_resync_info(struct mddev *mddev, struct dlm_lock_resource *lockres,
+		sector_t lo, sector_t hi)
+{
+	struct resync_info *ri;
+	ri = (struct resync_info *)lockres->lksb.sb_lvbptr;
+	ri->lo = cpu_to_le64(lo);
+	ri->hi = cpu_to_le64(hi);
+}
+
+static struct suspend_info *read_resync_info(struct mddev *mddev, struct dlm_lock_resource *lockres)
+{
+	struct resync_info ri;
+	struct suspend_info *s = NULL;
+	sector_t hi = 0;
+
+	dlm_lock_sync(lockres, DLM_LOCK_CR);
+	memcpy(&ri, lockres->lksb.sb_lvbptr, sizeof(struct resync_info));
+	hi = le64_to_cpu(ri.hi);
+	if (ri.hi > 0) {
+		s = kzalloc(sizeof(struct suspend_info), GFP_KERNEL);
+		if (!s)
+			goto out;
+		s->hi = hi;
+		s->lo = le64_to_cpu(ri.lo);
+	}
+	dlm_unlock_sync(lockres);
+out:
+	return s;
+}
+
 static void recover_prep(void *arg)
 {
 }
@@ -174,6 +218,53 @@ static const struct dlm_lockspace_ops md_ls_ops = {
 	.recover_done = recover_done,
 };
 
+static int gather_all_resync_info(struct mddev *mddev, int total_slots)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	int i, ret = 0;
+	struct dlm_lock_resource *bm_lockres;
+	struct suspend_info *s;
+	char str[64];
+
+
+	for (i = 0; i < total_slots; i++) {
+		memset(str, '\0', 64);
+		snprintf(str, 64, "bitmap%04d", i);
+		bm_lockres = lockres_init(mddev, str, NULL, 1);
+		if (!bm_lockres)
+			return -ENOMEM;
+		if (i == (cinfo->slot_number - 1))
+			continue;
+
+		bm_lockres->flags |= DLM_LKF_NOQUEUE;
+		ret = dlm_lock_sync(bm_lockres, DLM_LOCK_PW);
+		if (ret == -EAGAIN) {
+			memset(bm_lockres->lksb.sb_lvbptr, '\0', LVB_SIZE);
+			s = read_resync_info(mddev, bm_lockres);
+			if (s) {
+				pr_info("%s:%d Resync[%llu..%llu] in progress on %d\n",
+						__func__, __LINE__,
+						(unsigned long long) s->lo,
+						(unsigned long long) s->hi, i);
+				spin_lock_irq(&cinfo->suspend_lock);
+				s->slot = i;
+				list_add(&s->list, &cinfo->suspend_list);
+				spin_unlock_irq(&cinfo->suspend_lock);
+			}
+			ret = 0;
+			lockres_free(bm_lockres);
+			continue;
+		}
+		if (ret)
+			goto out;
+		/* TODO: Read the disk bitmap sb and check if it needs recovery */
+		dlm_unlock_sync(bm_lockres);
+		lockres_free(bm_lockres);
+	}
+out:
+	return ret;
+}
+
 static int join(struct mddev *mddev, int nodes)
 {
 	struct md_cluster_info *cinfo;
@@ -227,8 +318,17 @@ static int join(struct mddev *mddev, int nodes)
 		goto err;
 	}
 
+	INIT_LIST_HEAD(&cinfo->suspend_list);
+	spin_lock_init(&cinfo->suspend_lock);
+
+	ret = gather_all_resync_info(mddev, nodes);
+	if (ret)
+		goto err;
+
 	return 0;
 err:
+	lockres_free(cinfo->bitmap_lockres);
+	lockres_free(cinfo->sb_lock);
 	if (cinfo->lockspace)
 		dlm_release_lockspace(cinfo->lockspace, 2);
 	mddev->cluster_info = NULL;
@@ -258,10 +358,19 @@ static int slot_number(struct mddev *mddev)
 	return cinfo->slot_number - 1;
 }
 
+static void resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	add_resync_info(mddev, cinfo->bitmap_lockres, lo, hi);
+	/* Re-acquire the lock to refresh LVB */
+	dlm_lock_sync(cinfo->bitmap_lockres, DLM_LOCK_PW);
+}
+
 static struct md_cluster_operations cluster_ops = {
 	.join   = join,
 	.leave  = leave,
-	.slot_number = slot_number
+	.slot_number = slot_number,
+	.resync_info_update = resync_info_update
 };
 
 static int __init cluster_init(void)
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index 52a21e0..51a24df 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -11,6 +11,7 @@ struct md_cluster_operations {
 	int (*join)(struct mddev *mddev, int nodes);
 	int (*leave)(struct mddev *mddev);
 	int (*slot_number)(struct mddev *mddev);
+	void (*resync_info_update)(struct mddev *mddev, sector_t lo, sector_t hi);
 };
 
 #endif /* _MD_CLUSTER_H */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index db28f21..a2c1cac 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7618,6 +7618,9 @@ void md_do_sync(struct md_thread *thread)
 	md_new_event(mddev);
 	update_time = jiffies;
 
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->resync_info_update(mddev, j, max_sectors);
+
 	blk_start_plug(&plug);
 	while (j < max_sectors) {
 		sector_t sectors;
@@ -7678,6 +7681,8 @@ void md_do_sync(struct md_thread *thread)
 		j += sectors;
 		if (j > 2)
 			mddev->curr_resync = j;
+		if (mddev_is_clustered(mddev))
+			md_cluster_ops->resync_info_update(mddev, j, max_sectors);
 		mddev->curr_mark_cnt = io_sectors;
 		if (last_check == 0)
 			/* this is the earliest that rebuild will be
@@ -7737,6 +7742,9 @@ void md_do_sync(struct md_thread *thread)
 	/* tell personality that we are finished */
 	mddev->pers->sync_request(mddev, max_sectors, &skipped, 1);
 
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->resync_info_update(mddev, 0, 0);
+
 	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
 	    mddev->curr_resync > 2) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-- 
2.1.2

