From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 1/6] md-cluster: correct the num for comparison
Date: Tue, 14 Apr 2015 10:42:32 -0500
Message-ID: <20150414154232.GA4079@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: GQJiang@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Author: Guoqing Jiang <gqjiang@suse.com>

Since the node num of md-cluster is from zero, and
cinfo->slot_number represents the slot num of dlm,
no need to check for equality.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 96679b2..6bdc45e 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -612,7 +612,7 @@ static int join(struct mddev *mddev, int nodes)
 	if (ret)
 		goto err;
 	wait_for_completion(&cinfo->completion);
-	if (nodes <= cinfo->slot_number) {
+	if (nodes < cinfo->slot_number) {
 		pr_err("md-cluster: Slot allotted(%d) greater than available slots(%d)", cinfo->slot_number - 1,
 			nodes);
 		ret = -ERANGE;
-- 
2.1.4

