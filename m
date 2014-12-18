From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 04/24] DLM lock and unlock functions
Date: Thu, 18 Dec 2014 10:15:56 -0600
Message-ID: <20141218161556.GA29589@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A dlm_lock_resource is a structure which contains all information
required for locking using DLM. The init function allocates the
lock and acquires the lock in NL mode. The unlock function
converts the lock resource to NL mode. This is done to preserve
LVB and for faster processing of locks. The lock resource is
DLM unlocked only in the lockres_free function, which is the end
of life of the lock resource.

Signed-off-by: Lidong Zhong <lzhong@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 6f21bba..e555b76 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -13,6 +13,110 @@
 
 
 #include <linux/module.h>
+#include <linux/dlm.h>
+#include <linux/sched.h>
+#include "md.h"
+
+#define LVB_SIZE	64
+
+struct dlm_lock_resource {
+	dlm_lockspace_t *ls;
+	struct dlm_lksb lksb;
+	char *name; /* lock name. */
+	uint32_t flags; /* flags to pass to dlm_lock() */
+	void (*bast)(void *arg, int mode); /* blocking AST function pointer*/
+	struct completion completion; /* completion for synchronized locking */
+};
+
+static void sync_ast(void *arg)
+{
+	struct dlm_lock_resource *res;
+	res = (struct dlm_lock_resource *) arg;
+	complete(&res->completion);
+}
+
+static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
+{
+	int ret = 0;
+	init_completion(&res->completion);
+	ret = dlm_lock(res->ls, mode, &res->lksb,
+			res->flags, res->name, strlen(res->name),
+			0, sync_ast, res, res->bast);
+	if (ret)
+		return ret;
+	wait_for_completion(&res->completion);
+	return res->lksb.sb_status;
+}
+
+static int dlm_unlock_sync(struct dlm_lock_resource *res)
+{
+	return dlm_lock_sync(res, DLM_LOCK_NL);
+}
+
+static struct dlm_lock_resource *lockres_init(dlm_lockspace_t *lockspace,
+		char *name, void (*bastfn)(void *arg, int mode), int with_lvb)
+{
+	struct dlm_lock_resource *res = NULL;
+	int ret, namelen;
+
+	res = kzalloc(sizeof(struct dlm_lock_resource), GFP_KERNEL);
+	if (!res)
+		return NULL;
+	res->ls = lockspace;
+	namelen = strlen(name);
+	res->name = kzalloc(namelen + 1, GFP_KERNEL);
+	if (!res->name) {
+		pr_err("md-cluster: Unable to allocate resource name for"
+				" resource %s\n", name);
+		goto out_err;
+	}
+	strlcpy(res->name, name, namelen + 1);
+	if (with_lvb) {
+		res->lksb.sb_lvbptr = kzalloc(LVB_SIZE, GFP_KERNEL);
+		if (!res->lksb.sb_lvbptr) {
+			pr_err("md-cluster: Unable to allocate LVB for"
+				" resource %s\n", name);
+			goto out_err;
+		}
+		res->flags = DLM_LKF_VALBLK;
+	}
+
+	if (bastfn)
+		res->bast = bastfn;
+
+	res->flags |= DLM_LKF_EXPEDITE;
+
+	ret = dlm_lock_sync(res, DLM_LOCK_NL);
+	if (ret) {
+		pr_err("md-cluster: Unable to lock NL on new lock"
+			" resource %s\n", name);
+		goto out_err;
+	}
+	res->flags &= ~DLM_LKF_EXPEDITE;
+	res->flags |= DLM_LKF_CONVERT;
+
+	return res;
+out_err:
+	kfree(res->lksb.sb_lvbptr);
+	kfree(res->name);
+	kfree(res);
+	return NULL;
+}
+
+static void lockres_free(struct dlm_lock_resource *res)
+{
+	if (!res)
+		return;
+
+	init_completion(&res->completion);
+	dlm_unlock(res->ls, res->lksb.sb_lkid, 0, &res->lksb, res);
+	wait_for_completion(&res->completion);
+
+	kfree(res->name);
+	kfree(res->lksb.sb_lvbptr);
+	kfree(res);
+	return;
+}
 
 static int __init cluster_init(void)
 {
-- 
2.1.2

