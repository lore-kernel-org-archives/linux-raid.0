From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 08/12] md-cluster: remove the unused sb_lock
Date: Fri, 10 Jul 2015 17:01:19 +0800
Message-ID: <1436518883-12783-5-git-send-email-gqjiang@suse.com>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518883-12783-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The sb_lock is not used anywhere, so let's remove it.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 6f1ea3c..057a973 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -52,7 +52,6 @@ struct md_cluster_info {
 	dlm_lockspace_t *lockspace;
 	int slot_number;
 	struct completion completion;
-	struct dlm_lock_resource *sb_lock;
 	struct mutex sb_mutex;
 	struct dlm_lock_resource *bitmap_lockres;
 	struct list_head suspend_list;
@@ -692,12 +691,6 @@ static int join(struct mddev *mddev, int nodes)
 		ret = -ERANGE;
 		goto err;
 	}
-	cinfo->sb_lock = lockres_init(mddev, "cmd-super",
-					NULL, 0);
-	if (!cinfo->sb_lock) {
-		ret = -ENOMEM;
-		goto err;
-	}
 	/* Initiate the communication resources */
 	ret = -ENOMEM;
 	cinfo->recv_thread = md_register_thread(recv_daemon, mddev, "cluster_recv");
@@ -749,7 +742,6 @@ err:
 	lockres_free(cinfo->ack_lockres);
 	lockres_free(cinfo->no_new_dev_lockres);
 	lockres_free(cinfo->bitmap_lockres);
-	lockres_free(cinfo->sb_lock);
 	if (cinfo->lockspace)
 		dlm_release_lockspace(cinfo->lockspace, 2);
 	mddev->cluster_info = NULL;
@@ -770,7 +762,6 @@ static int leave(struct mddev *mddev)
 	lockres_free(cinfo->token_lockres);
 	lockres_free(cinfo->ack_lockres);
 	lockres_free(cinfo->no_new_dev_lockres);
-	lockres_free(cinfo->sb_lock);
 	lockres_free(cinfo->bitmap_lockres);
 	dlm_release_lockspace(cinfo->lockspace, 2);
 	return 0;
-- 
1.7.12.4

