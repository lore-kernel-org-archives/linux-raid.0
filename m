From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 10/12] md-cluster: only call complete(&cinfo->completion) when node join cluster
Date: Fri, 10 Jul 2015 17:01:21 +0800
Message-ID: <1436518883-12783-7-git-send-email-gqjiang@suse.com>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518883-12783-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Introduce MD_CLUSTER_BEGIN_JOIN_CLUSTER flag to make sure
complete(&cinfo->completion) is only be invoked when node
join cluster. Otherwise node failure could also call the
complete, and it doesn't make sense to do it.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 411b430..29f65e2 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -45,6 +45,7 @@ struct resync_info {
 /* md_cluster_info flags */
 #define		MD_CLUSTER_WAITING_FOR_NEWDISK		1
 #define		MD_CLUSTER_SUSPEND_READ_BALANCING	2
+#define		MD_CLUSTER_BEGIN_JOIN_CLUSTER		3
 
 
 struct md_cluster_info {
@@ -320,10 +321,17 @@ static void recover_done(void *arg, struct dlm_slot *slots,
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 
 	cinfo->slot_number = our_slot;
-	complete(&cinfo->completion);
+	/* completion is only need to be complete when node join cluster,
+	 * it doesn't need to run during another node's failure */
+	if (test_bit(MD_CLUSTER_BEGIN_JOIN_CLUSTER, &cinfo->state)) {
+		complete(&cinfo->completion);
+		clear_bit(MD_CLUSTER_BEGIN_JOIN_CLUSTER, &cinfo->state);
+	}
 	clear_bit(MD_CLUSTER_SUSPEND_READ_BALANCING, &cinfo->state);
 }
 
+/* the ops is called when node join the cluster, and do lock recovery
+ * if node failure occurs */
 static const struct dlm_lockspace_ops md_ls_ops = {
 	.recover_prep = recover_prep,
 	.recover_slot = recover_slot,
@@ -675,6 +683,7 @@ static int join(struct mddev *mddev, int nodes)
 	INIT_LIST_HEAD(&cinfo->suspend_list);
 	spin_lock_init(&cinfo->suspend_lock);
 	init_completion(&cinfo->completion);
+	set_bit(MD_CLUSTER_BEGIN_JOIN_CLUSTER, &cinfo->state);
 
 	mutex_init(&cinfo->sb_mutex);
 	mddev->cluster_info = cinfo;
-- 
1.7.12.4

