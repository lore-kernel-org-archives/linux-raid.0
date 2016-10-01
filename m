From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 13/15] md-cluster: Less function calls in join() after error
 detection
Date: Sat, 1 Oct 2016 16:58:32 +0200
Message-ID: <c0a9d85c-39d4-901e-a93f-d419d9f7159b@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 15:40:32 +0200

A few resource release functions were called in some cases
by the join() function during error handling
even if the passed data structure member contained a null pointer.

* Adjust jump targets according to the Linux coding style convention.

* Delete a repeated check which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-cluster.c | 47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index e1ebcc4..36bb962 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -837,39 +837,39 @@ static int join(struct mddev *mddev, int nodes)
 				DLM_LSFL_FS, LVB_SIZE,
 				&md_ls_ops, mddev, &ops_rv, &cinfo->lockspace);
 	if (ret)
-		goto err;
+		goto free_cluster_info;
 	wait_for_completion(&cinfo->completion);
 	if (nodes < cinfo->slot_number) {
 		pr_err("md-cluster: Slot allotted(%d) is greater than available slots(%d).",
 			cinfo->slot_number, nodes);
 		ret = -ERANGE;
-		goto err;
+		goto release_lockspace;
 	}
 	/* Initiate the communication resources */
 	ret = -ENOMEM;
 	cinfo->recv_thread = md_register_thread(recv_daemon, mddev, "cluster_recv");
 	if (!cinfo->recv_thread)
-		goto err;
+		goto release_lockspace;
 	cinfo->message_lockres = lockres_init(mddev, "message", NULL, 1);
 	if (!cinfo->message_lockres)
-		goto err;
+		goto unregister_recv;
 	cinfo->token_lockres = lockres_init(mddev, "token", NULL, 0);
 	if (!cinfo->token_lockres)
-		goto err;
+		goto free_message;
 	cinfo->no_new_dev_lockres = lockres_init(mddev, "no-new-dev", NULL, 0);
 	if (!cinfo->no_new_dev_lockres)
-		goto err;
+		goto free_token;
 
 	ret = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
 	if (ret) {
 		ret = -EAGAIN;
 		pr_err("md-cluster: can't join cluster to avoid lock issue\n");
-		goto err;
+		goto free_no_new_dev;
 	}
 	cinfo->ack_lockres = lockres_init(mddev, "ack", ack_bast, 0);
 	if (!cinfo->ack_lockres) {
 		ret = -ENOMEM;
-		goto err;
+		goto free_no_new_dev;
 	}
 	/* get sync CR lock on ACK. */
 	if (dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR))
@@ -886,34 +886,39 @@ static int join(struct mddev *mddev, int nodes)
 	cinfo->bitmap_lockres = lockres_init(mddev, str, NULL, 1);
 	if (!cinfo->bitmap_lockres) {
 		ret = -ENOMEM;
-		goto err;
+		goto free_ack;
 	}
 	if (dlm_lock_sync(cinfo->bitmap_lockres, DLM_LOCK_PW)) {
 		pr_err("Failed to get bitmap lock\n");
 		ret = -EINVAL;
-		goto err;
+		goto free_bitmap;
 	}
 
 	cinfo->resync_lockres = lockres_init(mddev, "resync", NULL, 0);
 	if (!cinfo->resync_lockres) {
 		ret = -ENOMEM;
-		goto err;
+		goto free_bitmap;
 	}
 
 	return 0;
-err:
-	md_unregister_thread(&cinfo->recovery_thread);
-	md_unregister_thread(&cinfo->recv_thread);
-	lockres_free(cinfo->message_lockres);
-	lockres_free(cinfo->token_lockres);
+free_bitmap:
+	lockres_free(cinfo->bitmap_lockres);
+free_ack:
 	lockres_free(cinfo->ack_lockres);
+free_no_new_dev:
 	lockres_free(cinfo->no_new_dev_lockres);
-	lockres_free(cinfo->resync_lockres);
-	lockres_free(cinfo->bitmap_lockres);
-	if (cinfo->lockspace)
-		dlm_release_lockspace(cinfo->lockspace, 2);
-	mddev->cluster_info = NULL;
+free_token:
+	lockres_free(cinfo->token_lockres);
+free_message:
+	lockres_free(cinfo->message_lockres);
+unregister_recv:
+	md_unregister_thread(&cinfo->recv_thread);
+release_lockspace:
+	dlm_release_lockspace(cinfo->lockspace, 2);
+free_cluster_info:
 	kfree(cinfo);
+	md_unregister_thread(&cinfo->recovery_thread);
+	mddev->cluster_info = NULL;
 	return ret;
 }
 
-- 
2.10.0
