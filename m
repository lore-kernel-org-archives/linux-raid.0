From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 05/13] md-cluster: fix locking when node joins cluster during message broadcast
Date: Thu, 21 Apr 2016 13:58:06 +0800
Message-ID: <1461218294-4960-6-git-send-email-gqjiang@suse.com>
References: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

If a node joins the cluster while a message broadcast
is under way, a lock issue could happen as follows.

For a cluster which included two nodes, if node A is
calling __sendmsg before up-convert CR to EX on ack,
and node B released CR on ack. But if a new node C
joins the cluster and it doesn't receive the message
which A sent before, so it could hold CR on ack before
A up-convert CR to EX on ack.

So a node joining the cluster should get an EX lock on
the "token" first to ensure no broadcast is ongoing,
then release it after held CR on ack.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 76f88f7..30f1160 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -781,17 +781,24 @@ static int join(struct mddev *mddev, int nodes)
 	cinfo->token_lockres = lockres_init(mddev, "token", NULL, 0);
 	if (!cinfo->token_lockres)
 		goto err;
-	cinfo->ack_lockres = lockres_init(mddev, "ack", ack_bast, 0);
-	if (!cinfo->ack_lockres)
-		goto err;
 	cinfo->no_new_dev_lockres = lockres_init(mddev, "no-new-dev", NULL, 0);
 	if (!cinfo->no_new_dev_lockres)
 		goto err;
 
+	ret = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
+	if (ret) {
+		ret = -EAGAIN;
+		pr_err("md-cluster: can't join cluster to avoid lock issue\n");
+		goto err;
+	}
+	cinfo->ack_lockres = lockres_init(mddev, "ack", ack_bast, 0);
+	if (!cinfo->ack_lockres)
+		goto err;
 	/* get sync CR lock on ACK. */
 	if (dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR))
 		pr_err("md-cluster: failed to get a sync CR lock on ACK!(%d)\n",
 				ret);
+	dlm_unlock_sync(cinfo->token_lockres);
 	/* get sync CR lock on no-new-dev. */
 	if (dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR))
 		pr_err("md-cluster: failed to get a sync CR lock on no-new-dev!(%d)\n", ret);
-- 
2.6.6

