From: gqjiang@suse.com
Subject: [PATCH] md-cluster: correct the num for comparison
Date: Fri, 10 Apr 2015 16:06:12 +0800
Message-ID: <1428653172-12678-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

Since the node num of md-cluster is from zero, and
cinfo->slot_number represents the slot num of dlm,
here also need to deduct one to keep consistency
with other codes.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index ae8bb54..531cc2b 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -612,7 +612,7 @@ static int join(struct mddev *mddev, int nodes)
 	if (ret)
 		goto err;
 	wait_for_completion(&cinfo->completion);
-	if (nodes <= cinfo->slot_number) {
+	if (nodes <= cinfo->slot_number - 1) {
 		pr_err("md-cluster: Slot allotted(%d) greater than available slots(%d)", cinfo->slot_number - 1,
 			nodes);
 		ret = -ERANGE;
-- 
1.7.12.4

