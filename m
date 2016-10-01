From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 10/15] md-cluster: Delete an unnecessary variable
 initialisation in lockres_init()
Date: Sat, 1 Oct 2016 16:55:10 +0200
Message-ID: <2d9e50ba-6bf3-167d-4752-46d6b4ea47dd@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 13:07:52 +0200

The local variable "res" will be set to an appropriate pointer a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-cluster.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index bec8035..b91b552 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -186,7 +186,7 @@ static int dlm_lock_sync_interruptible(struct dlm_lock_resource *res, int mode,
 static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 		char *name, void (*bastfn)(void *arg, int mode), int with_lvb)
 {
-	struct dlm_lock_resource *res = NULL;
+	struct dlm_lock_resource *res;
 	int ret, namelen;
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 
-- 
2.10.0

