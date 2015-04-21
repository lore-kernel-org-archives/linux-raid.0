From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH RESEND] md-cluster: correct the num for comparison
Date: Tue, 21 Apr 2015 11:25:52 -0500
Message-ID: <20150421162551.GA18339@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: GQJiang@suse.com
List-Id: linux-raid.ids

Author: Guoqing Jiang <gqjiang@suse.com>

Since the node num of md-cluster is from zero, and
cinfo->slot_number represents the slot num of dlm,
no need to check for equality.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 96679b2..8ef9e3d 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -612,9 +612,9 @@ static int join(struct mddev *mddev, int nodes)
 	if (ret)
 		goto err;
 	wait_for_completion(&cinfo->completion);
-	if (nodes <= cinfo->slot_number) {
-		pr_err("md-cluster: Slot allotted(%d) greater than available slots(%d)", cinfo->slot_number - 1,
-			nodes);
+	if (nodes < cinfo->slot_number) {
+		pr_err("md-cluster: Slot allotted(%d) is greater than available slots(%d).",
+			cinfo->slot_number, nodes);
 		ret = -ERANGE;
 		goto err;
 	}
