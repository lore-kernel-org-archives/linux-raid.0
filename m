From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 22/24] Suspend writes in RAID1 if within range
Date: Thu, 18 Dec 2014 10:18:54 -0600
Message-ID: <20141218161854.GA29667@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If there is a resync going on, all nodes must suspend writes to the
range. This is recorded in the suspend_info/suspend_list.

If there is an I/O within the ranges of any of the suspend_info,
should_suspend will return 1.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 22 +++++++++++++++++++++-
 drivers/md/md-cluster.h |  1 +
 drivers/md/md.c         |  1 +
 drivers/md/raid1.c      | 11 ++++++++---
 4 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 6f156a8..9feb6ff2 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -719,6 +719,25 @@ static void resync_finish(struct mddev *mddev)
 	resync_send(mddev, RESYNCING, 0, 0);
 }
 
+static int area_resyncing(struct mddev *mddev, sector_t lo, sector_t hi)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	int ret = 0;
+	struct suspend_info *s;
+
+	spin_lock_irq(&cinfo->suspend_lock);
+	if (list_empty(&cinfo->suspend_list))
+		goto out;
+	list_for_each_entry(s, &cinfo->suspend_list, list)
+		if (hi > s->lo && lo < s->hi) {
+			ret = 1;
+			break;
+		}
+out:
+	spin_unlock_irq(&cinfo->suspend_lock);
+	return ret;
+}
+
 static struct md_cluster_operations cluster_ops = {
 	.join   = join,
 	.leave  = leave,
@@ -728,7 +747,8 @@ static struct md_cluster_operations cluster_ops = {
 	.resync_finish = resync_finish,
 	.metadata_update_start = metadata_update_start,
 	.metadata_update_finish = metadata_update_finish,
-	.metadata_update_cancel = metadata_update_cancel
+	.metadata_update_cancel = metadata_update_cancel,
+	.area_resyncing = area_resyncing
 };
 
 static int __init cluster_init(void)
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index 054f9ea..0378540 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -17,6 +17,7 @@ struct md_cluster_operations {
 	int (*metadata_update_start)(struct mddev *mddev);
 	int (*metadata_update_finish)(struct mddev *mddev);
 	int (*metadata_update_cancel)(struct mddev *mddev);
+	int (*area_resyncing)(struct mddev *mddev, sector_t lo, sector_t hi);
 };
 
 #endif /* _MD_CLUSTER_H */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1532b36..5be7719 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -68,6 +68,7 @@ static LIST_HEAD(pers_list);
 static DEFINE_SPINLOCK(pers_lock);
 
 struct md_cluster_operations *md_cluster_ops;
+EXPORT_SYMBOL(md_cluster_ops);
 struct module *md_cluster_mod;
 EXPORT_SYMBOL(md_cluster_mod);
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 55de4f6..eb8fd2e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1113,8 +1113,10 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	md_write_start(mddev, bio); /* wait on superblock update early */
 
 	if (bio_data_dir(bio) == WRITE &&
-	    bio_end_sector(bio) > mddev->suspend_lo &&
-	    bio->bi_iter.bi_sector < mddev->suspend_hi) {
+	    ((bio_end_sector(bio) > mddev->suspend_lo &&
+	    bio->bi_iter.bi_sector < mddev->suspend_hi) ||
+	    (mddev_is_clustered(mddev) &&
+	     md_cluster_ops->area_resyncing(mddev, bio->bi_iter.bi_sector, bio_end_sector(bio))))) {
 		/* As the suspend_* range is controlled by
 		 * userspace, we want an interruptible
 		 * wait.
@@ -1125,7 +1127,10 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_INTERRUPTIBLE);
 			if (bio_end_sector(bio) <= mddev->suspend_lo ||
-			    bio->bi_iter.bi_sector >= mddev->suspend_hi)
+			    bio->bi_iter.bi_sector >= mddev->suspend_hi ||
+			    (mddev_is_clustered(mddev) &&
+			     !md_cluster_ops->area_resyncing(mddev,
+				     bio->bi_iter.bi_sector, bio_end_sector(bio))))
 				break;
 			schedule();
 		}
-- 
2.1.2

