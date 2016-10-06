From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 13/15] md-cluster: Less function calls in join() after
 error detection
Date: Thu, 6 Oct 2016 17:16:14 +0200
Message-ID: <754146c7-f029-270f-4ea5-3a6e2fde3373@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
 <c0a9d85c-39d4-901e-a93f-d419d9f7159b@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <c0a9d85c-39d4-901e-a93f-d419d9f7159b@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 6 Oct 2016 16:48:51 +0200

A few resource release functions were called in some cases
by the join() function during error handling
even if the passed data structure member contained a null pointer.

* Adjust jump targets according to the Linux coding style convention.

* Delete a repeated check which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---

v2: Julia Lawall wrote on 2016-10-01 at 19:07:
> Please check lines 919 and 920.
> 
> julia
> 
> ---------- Forwarded message ----------
> Date: Sun, 2 Oct 2016 01:03:19 +0800
> From: kbuild test robot <fengguang.wu@intel.com>
> To: kbuild@01.org
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Subject:
>     [linux-review:SF-Markus-Elfring/md-cluster-Fine-tuning-for-ten-function-impl
>     ementations/20161001-230311 13/15] drivers/md/md-cluster.c:920:23-28: ERROR:
>      reference preceded by free on line 919
> 
> CC: kbuild-all@01.org
> TO: Markus Elfring <elfring@users.sourceforge.net>
> CC: 0day robot <fengguang.wu@intel.com>
> 
> tree:   https://github.com/0day-ci/linux SF-Markus-Elfring/md-cluster-Fine-tuning-for-ten-function-implementations/20161001-230311
> head:   7b2084c76eb1c60f2ae5c2778470124b5b68e9fb
> commit: 6955234a0083a739f595e753e89ba7b5b3962f50 [13/15] md-cluster: Less function calls in join() after error detection
> :::::: branch date: 2 hours ago
> :::::: commit date: 2 hours ago
> 
>>> drivers/md/md-cluster.c:920:23-28: ERROR: reference preceded by free on line 919
> 
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout 6955234a0083a739f595e753e89ba7b5b3962f50
> vim +920 drivers/md/md-cluster.c
> 
> 6955234a Markus Elfring    2016-10-01  913  	lockres_free(cinfo->message_lockres);
> 6955234a Markus Elfring    2016-10-01  914  unregister_recv:
> 6955234a Markus Elfring    2016-10-01  915  	md_unregister_thread(&cinfo->recv_thread);
> 6955234a Markus Elfring    2016-10-01  916  release_lockspace:
> c4ce867f Goldwyn Rodrigues 2014-03-29  917  	dlm_release_lockspace(cinfo->lockspace, 2);
> 6955234a Markus Elfring    2016-10-01  918  free_cluster_info:
> c4ce867f Goldwyn Rodrigues 2014-03-29 @919  	kfree(cinfo);
> 6955234a Markus Elfring    2016-10-01 @920  	md_unregister_thread(&cinfo->recovery_thread);
> 6955234a Markus Elfring    2016-10-01  921  	mddev->cluster_info = NULL;
> c4ce867f Goldwyn Rodrigues 2014-03-29  922  	return ret;
> edb39c9d Goldwyn Rodrigues 2014-03-29  923  }
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


This automatic notification pointed out that I should have switched the order
of calls for the functions "kfree" and "md_unregister_thread".
I hope that my second approach could be integrated into another
source code repository.


 drivers/md/md-cluster.c | 47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index e1ebcc4..e60511a 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -837,39 +837,39 @@ static int join(struct mddev *mddev, int nodes)
 				DLM_LSFL_FS, LVB_SIZE,
 				&md_ls_ops, mddev, &ops_rv, &cinfo->lockspace);
 	if (ret)
-		goto err;
+		goto unregister_recovery_thread;
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
+unregister_recovery_thread:
+	md_unregister_thread(&cinfo->recovery_thread);
 	kfree(cinfo);
+	mddev->cluster_info = NULL;
 	return ret;
 }
 
-- 
2.10.1

