From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V3] md-cluster: make md-cluster also can work when compiled into kernel
Date: Sun,  4 Sep 2016 22:17:28 -0400
Message-ID: <1473041848-28009-1-git-send-email-gqjiang@suse.com>
References: <1472813500-4921-1-git-send-email-gqjiang@suse.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1472813500-4921-1-git-send-email-gqjiang@suse.com>
Sender: stable-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Guoqing Jiang <gqjiang@suse.com>, "v4.1+" <stable@vger.kernel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

The md-cluster is compiled as module by default,
if it is compiled by built-in way, then we can't
make md-cluster works.

[64782.630008] md/raid1:md127: active with 2 out of 2 mirrors
[64782.630528] md-cluster module not found.
[64782.630530] md127: Could not setup cluster service (-2)

Fixes: edb39c9 ("Introduce md_cluster_operations to handle cluster functions")
Cc: stable@vger.kernel.org (v4.1+)
Cc: NeilBrown <neilb@suse.com>
Reported-by: Marc Smith <marc.smith@mcc.edu>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
V3 changes:
1. add the "!md_cluster_ops" test back
2. fix wrong mail info of stable kernel

V2 changes:
1. call try_module_get if md_cluster_ops is already set,
   otherwise try_module_get/module_put are unbalanced.

 drivers/md/md.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 67642ba..915e84d 100644
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
+	/* ensure module won't be unloaded */
 	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
+		pr_err("can't find md-cluster module or get it's reference.\n");
 		spin_unlock(&pers_lock);
 		return -ENOENT;
 	}
-- 
2.6.6
