From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 09/15] md-cluster: Improve another size determination in
 lockres_init()
Date: Sat, 1 Oct 2016 16:54:07 +0200
Message-ID: <9c4e9391-324d-8e88-14fb-691035e27a05@users.sourceforge.net>
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
Date: Sat, 1 Oct 2016 13:02:18 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-cluster.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 0918108..bec8035 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -190,7 +190,7 @@ static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 	int ret, namelen;
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 
-	res = kzalloc(sizeof(struct dlm_lock_resource), GFP_KERNEL);
+	res = kzalloc(sizeof(*res), GFP_KERNEL);
 	if (!res)
 		return NULL;
 	init_waitqueue_head(&res->sync_locking);
-- 
2.10.0

