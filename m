From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] md-cluster: fix error return code in join()
Date: Sun, 21 Aug 2016 14:42:25 +0000
Message-ID: <1471790545-3301-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENOMEM from the lockres_init() error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/md/md-cluster.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 333f0cf..2b13117 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -874,8 +874,10 @@ static int join(struct mddev *mddev, int nodes)
 		goto err;
 	}
 	cinfo->ack_lockres = lockres_init(mddev, "ack", ack_bast, 0);
-	if (!cinfo->ack_lockres)
+	if (!cinfo->ack_lockres) {
+		ret = -ENOMEM;
 		goto err;
+	}
 	/* get sync CR lock on ACK. */
 	if (dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR))
 		pr_err("md-cluster: failed to get a sync CR lock on ACK!(%d)\n",
@@ -889,8 +891,10 @@ static int join(struct mddev *mddev, int nodes)
 	pr_info("md-cluster: Joined cluster %s slot %d\n", str, cinfo->slot_number);
 	snprintf(str, 64, "bitmap%04d", cinfo->slot_number - 1);
 	cinfo->bitmap_lockres = lockres_init(mddev, str, NULL, 1);
-	if (!cinfo->bitmap_lockres)
+	if (!cinfo->bitmap_lockres) {
+		ret = -ENOMEM;
 		goto err;
+	}
 	if (dlm_lock_sync(cinfo->bitmap_lockres, DLM_LOCK_PW)) {
 		pr_err("Failed to get bitmap lock\n");
 		ret = -EINVAL;
@@ -898,8 +902,10 @@ static int join(struct mddev *mddev, int nodes)
 	}
 
 	cinfo->resync_lockres = lockres_init(mddev, "resync", NULL, 0);
-	if (!cinfo->resync_lockres)
+	if (!cinfo->resync_lockres) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
 	return 0;
 err:

