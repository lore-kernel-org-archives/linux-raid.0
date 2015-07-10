From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 05/12] md-cluster: init completion within lockres_init
Date: Fri, 10 Jul 2015 17:01:16 +0800
Message-ID: <1436518883-12783-2-git-send-email-gqjiang@suse.com>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518883-12783-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We should init completion within lockres_init, otherwise
completion could be initialized more than one time during
it's life cycle.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 85b7836..2a57f19 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -100,7 +100,6 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
 {
 	int ret = 0;
 
-	init_completion(&res->completion);
 	ret = dlm_lock(res->ls, mode, &res->lksb,
 			res->flags, res->name, strlen(res->name),
 			0, sync_ast, res, res->bast);
@@ -125,6 +124,7 @@ static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 	res = kzalloc(sizeof(struct dlm_lock_resource), GFP_KERNEL);
 	if (!res)
 		return NULL;
+	init_completion(&res->completion);
 	res->ls = cinfo->lockspace;
 	res->mddev = mddev;
 	namelen = strlen(name);
@@ -169,7 +169,6 @@ static void lockres_free(struct dlm_lock_resource *res)
 	if (!res)
 		return;
 
-	init_completion(&res->completion);
 	dlm_unlock(res->ls, res->lksb.sb_lkid, 0, &res->lksb, res);
 	wait_for_completion(&res->completion);
 
-- 
1.7.12.4

