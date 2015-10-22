From: rgoldwyn@suse.de
Subject: [PATCH] md-cluster: Only one thread should request DLM lock
Date: Thu, 22 Oct 2015 08:31:08 -0500
Message-ID: <1445520669-4406-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

If a DLM lock is in progress, requesting the same DLM lock will
result in -EBUSY. Use a mutex to make sure only one thread requests
for dlm_lock() function at a time.

This will fix the error -EBUSY returned from DLM's validate_lock_args().

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 35ac2e8..9b977a2 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -29,6 +29,7 @@ struct dlm_lock_resource {
 	void (*bast)(void *arg, int mode); /* blocking AST function pointer*/
 	struct mddev *mddev; /* pointing back to mddev. */
 	int mode;
+	struct mutex res_lock;
 };
 
 struct suspend_info {
@@ -102,14 +103,19 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
 {
 	int ret = 0;
 
+	mutex_lock(&res->res_lock);
+
 	ret = dlm_lock(res->ls, mode, &res->lksb,
 			res->flags, res->name, strlen(res->name),
 			0, sync_ast, res, res->bast);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&res->res_lock);
 		return ret;
+	}
 	wait_for_completion(&res->completion);
 	if (res->lksb.sb_status == 0)
 		res->mode = mode;
+	mutex_unlock(&res->res_lock);
 	return res->lksb.sb_status;
 }
 
@@ -134,6 +140,7 @@ static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 	res->mode = DLM_LOCK_IV;
 	namelen = strlen(name);
 	res->name = kzalloc(namelen + 1, GFP_KERNEL);
+	mutex_init(&res->res_lock);
 	if (!res->name) {
 		pr_err("md-cluster: Unable to allocate resource name for resource %s\n", name);
 		goto out_err;
-- 
1.8.5.6

