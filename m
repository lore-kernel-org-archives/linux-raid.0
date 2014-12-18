From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 20/24] Send RESYNCING while performing resync start/stop
Date: Thu, 18 Dec 2014 10:18:37 -0600
Message-ID: <20141218161837.GA29658@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When a resync is initiated, RESYNCING message is sent to all active
nodes with the range (lo,hi). When the resync is over, a RESYNCING
message is sent with (0,0). A high sector value of zero indicates
that the resync is over.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 31 +++++++++++++++++++++++++++++++
 drivers/md/md-cluster.h |  2 ++
 drivers/md/md.c         |  4 ++--
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 084834d..fff40a0 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -644,11 +644,42 @@ static int metadata_update_cancel(struct mddev *mddev)
 	return dlm_unlock_sync(cinfo->token_lockres);
 }
 
+static int resync_send(struct mddev *mddev, enum msg_type type,
+		sector_t lo, sector_t hi)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	struct cluster_msg cmsg;
+	int slot = cinfo->slot_number - 1;
+	pr_info("%s:%d lo: %llu hi: %llu\n", __func__, __LINE__,
+			(unsigned long long)lo,
+			(unsigned long long)hi);
+	resync_info_update(mddev, lo, hi);
+	cmsg.type = cpu_to_le32(type);
+	cmsg.slot = cpu_to_le32(slot);
+	cmsg.low = cpu_to_le64(lo);
+	cmsg.high = cpu_to_le64(hi);
+	return sendmsg(cinfo, &cmsg);
+}
+
+static int resync_start(struct mddev *mddev, sector_t lo, sector_t hi)
+{
+	pr_info("%s:%d\n", __func__, __LINE__);
+	return resync_send(mddev, RESYNCING, lo, hi);
+}
+
+static void resync_finish(struct mddev *mddev)
+{
+	pr_info("%s:%d\n", __func__, __LINE__);
+	resync_send(mddev, RESYNCING, 0, 0);
+}
+
 static struct md_cluster_operations cluster_ops = {
 	.join   = join,
 	.leave  = leave,
 	.slot_number = slot_number,
 	.resync_info_update = resync_info_update,
+	.resync_start = resync_start,
+	.resync_finish = resync_finish,
 	.metadata_update_start = metadata_update_start,
 	.metadata_update_finish = metadata_update_finish,
 	.metadata_update_cancel = metadata_update_cancel
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index 658982a..054f9ea 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -12,6 +12,8 @@ struct md_cluster_operations {
 	int (*leave)(struct mddev *mddev);
 	int (*slot_number)(struct mddev *mddev);
 	void (*resync_info_update)(struct mddev *mddev, sector_t lo, sector_t hi);
+	int (*resync_start)(struct mddev *mddev, sector_t lo, sector_t hi);
+	void (*resync_finish)(struct mddev *mddev);
 	int (*metadata_update_start)(struct mddev *mddev);
 	int (*metadata_update_finish)(struct mddev *mddev);
 	int (*metadata_update_cancel)(struct mddev *mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 829086c..1532b36 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7679,7 +7679,7 @@ void md_do_sync(struct md_thread *thread)
 	update_time = jiffies;
 
 	if (mddev_is_clustered(mddev))
-		md_cluster_ops->resync_info_update(mddev, j, max_sectors);
+		md_cluster_ops->resync_start(mddev, j, max_sectors);
 
 	blk_start_plug(&plug);
 	while (j < max_sectors) {
@@ -7803,7 +7803,7 @@ void md_do_sync(struct md_thread *thread)
 	mddev->pers->sync_request(mddev, max_sectors, &skipped, 1);
 
 	if (mddev_is_clustered(mddev))
-		md_cluster_ops->resync_info_update(mddev, 0, 0);
+		md_cluster_ops->resync_finish(mddev);
 
 	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
 	    mddev->curr_resync > 2) {
-- 
2.1.2

