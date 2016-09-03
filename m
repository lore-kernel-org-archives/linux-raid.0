From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2] md-cluster: make md-cluster also can work when compiled into kernel
Date: Sat,  3 Sep 2016 10:03:30 -0400
Message-ID: <1472911410-15469-1-git-send-email-gqjiang@suse.com>
References: <1472813500-4921-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1472813500-4921-1-git-send-email-gqjiang@suse.com>
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
Changes:
1. call try_module_get if md_cluster_ops is already set,
otherwise try_module_get/module_put are unbalanced.

 drivers/md/md.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 67642ba..6ac5abe 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7610,16 +7610,12 @@ EXPORT_SYMBOL(unregister_md_cluster_operations);
 
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
+	if (!md_cluster_ops)
+		request_module("md-cluster");
 	spin_lock(&pers_lock);
-	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
+	/* ensure module won't be unloaded */
+	if (!try_module_get(md_cluster_mod)) {
+		pr_err("can't get md-cluster module reference.\n");
 		spin_unlock(&pers_lock);
 		return -ENOENT;
 	}
-- 
2.6.6

