From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] util: fix wrong return value of cluster_get_dlmlock
Date: Wed, 20 Jan 2016 16:21:25 +0800
Message-ID: <1453278085-19883-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Actually lksb.sb_status means that a node get the lock
or not instead of the return value of dlm_lock.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 util.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/util.c b/util.c
index f1b0b95..cf9572b 100644
--- a/util.c
+++ b/util.c
@@ -142,7 +142,7 @@ int cluster_get_dlmlock(int *lockid)
 	dlm_lock_res->ls = dlm_hooks->create_lockspace(cluster_name, O_RDWR);
 	if (!dlm_lock_res->ls) {
 		pr_err("%s failed to create lockspace\n", cluster_name);
-                goto out;
+		return -ENOMEM;
 	}
 
 	/* Conversions need the lockid in the LKSB */
@@ -157,21 +157,15 @@ int cluster_get_dlmlock(int *lockid)
 			  dlm_lock_res, NULL, NULL);
 	if (ret) {
 		pr_err("error %d when get PW mode on lock %s\n", errno, str);
-                goto out;
+		dlm_hooks->release_lockspace(cluster_name, dlm_lock_res->ls, 1);
+		return ret;
 	}
 
 	/* Wait for it to complete */
 	poll_for_ast(dlm_lock_res->ls);
 	*lockid = dlm_lock_res->lksb.sb_lkid;
 
-	errno =	dlm_lock_res->lksb.sb_status;
-	if (errno) {
-		pr_err("error %d happened in ast with lock %s\n", errno, str);
-		goto out;
-	}
-
-out:
-	return ret;
+	return dlm_lock_res->lksb.sb_status;
 }
 
 int cluster_release_dlmlock(int lockid)
-- 
2.6.2

