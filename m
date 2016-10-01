From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 14/15] md-cluster: Less function calls in lockres_init() after
 error detection
Date: Sat, 1 Oct 2016 16:59:20 +0200
Message-ID: <6f650168-02dc-91e5-c47a-e3ead380252f@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 16:01:05 +0200

The kfree() function was called in up to three cases
by the lockres_init() function during error handling even if
the passed data structure member (or variable) contained a null pointer.

Adjust jump targets according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-cluster.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 36bb962..0cade1a 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -201,12 +201,12 @@ static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 	namelen = strlen(name);
 	res->name = kzalloc(namelen + 1, GFP_KERNEL);
 	if (!res->name)
-		goto out_err;
+		goto free_resource;
 	strlcpy(res->name, name, namelen + 1);
 	if (with_lvb) {
 		res->lksb.sb_lvbptr = kzalloc(LVB_SIZE, GFP_KERNEL);
 		if (!res->lksb.sb_lvbptr)
-			goto out_err;
+			goto free_name;
 		res->flags = DLM_LKF_VALBLK;
 	}
 
@@ -218,15 +218,17 @@ static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 	ret = dlm_lock_sync(res, DLM_LOCK_NL);
 	if (ret) {
 		pr_err("md-cluster: Unable to lock NL on new lock resource %s\n", name);
-		goto out_err;
+		goto free_lvb;
 	}
 	res->flags &= ~DLM_LKF_EXPEDITE;
 	res->flags |= DLM_LKF_CONVERT;
 
 	return res;
-out_err:
+free_lvb:
 	kfree(res->lksb.sb_lvbptr);
+free_name:
 	kfree(res->name);
+free_resource:
 	kfree(res);
 	return NULL;
 }
-- 
2.10.0

