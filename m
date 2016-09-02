From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] md-cluster: make md-cluster also can work when compiled into kernel
Date: Fri,  2 Sep 2016 06:51:40 -0400
Message-ID: <1472813500-4921-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Guoqing Jiang <gqjiang@suse.com>, stable@vger.kernel.org#v4.1+, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

The md-cluster is compiled as module by default,
if it is compiled by built-in way, then we can't
make md-cluster works.

[64782.630008] md/raid1:md127: active with 2 out of 2 mirrors
[64782.630528] md-cluster module not found.
[64782.630530] md127: Could not setup cluster service (-2)

Fixes: edb39c9 ("Introduce md_cluster_operations to handle cluster functions")
Cc: stable@vger.kernel.org # v4.1+
Cc: NeilBrown <neilb@suse.com>
Reported-by: Marc Smith <marc.smith@mcc.edu>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bdbbb6e1..3b19d21 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7619,20 +7619,17 @@ EXPORT_SYMBOL(unregister_md_cluster_operations);
 
 int md_setup_cluster(struct mddev *mddev, int nodes)
 {
-	int err;
-
-	err = request_module("md-cluster");
-	if (err) {
-		pr_err("md-cluster module not found.\n");
-		return -ENOENT;
-	}
-
-	spin_lock(&pers_lock);
-	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
+	if (!md_cluster_ops) {
+		/* load module and ensure it won't be unloaded */
+		request_module("md-cluster");
+		spin_lock(&pers_lock);
+		if (!try_module_get(md_cluster_mod)) {
+			pr_err("can't get md-cluster module reference.\n");
+			spin_unlock(&pers_lock);
+			return -ENODEV;
+		}
 		spin_unlock(&pers_lock);
-		return -ENOENT;
 	}
-	spin_unlock(&pers_lock);
 
 	return md_cluster_ops->join(mddev, nodes);
 }
-- 
2.6.6

