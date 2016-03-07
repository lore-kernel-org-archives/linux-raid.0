From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 2/2] Remove dead code about LKF_CONVERT flag
Date: Mon,  7 Mar 2016 17:31:03 +0800
Message-ID: <1457343063-14884-2-git-send-email-gqjiang@suse.com>
References: <1457343063-14884-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457343063-14884-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com, neilb@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Since flags is only set as LKF_NOQUEUE, the code
with LKF_CONVERT flag should be delete.

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 mdadm.h | 1 -
 util.c  | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 355c455..97aac52 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -64,7 +64,6 @@ typedef uint64_t cmap_handle_t;
 #include	<errno.h>
 #else
 #define LKF_NOQUEUE	0x00000001
-#define LKF_CONVERT	0x00000004
 #define LKM_PWMODE	4
 #define EUNLOCK		0x10002
 
diff --git a/util.c b/util.c
index 96a806d..09c2f6f 100644
--- a/util.c
+++ b/util.c
@@ -147,13 +147,7 @@ int cluster_get_dlmlock(int *lockid)
 		return -ENOMEM;
 	}
 
-	/* Conversions need the lockid in the LKSB */
-	if (flags & LKF_CONVERT)
-		dlm_lock_res->lksb.sb_lkid = *lockid;
-
 	snprintf(str, 64, "bitmap%s", cluster_name);
-	/* if flags with LKF_CONVERT causes below return ENOENT which means
-	 * "No such file or directory" */
 	ret = dlm_hooks->ls_lock(dlm_lock_res->ls, LKM_PWMODE, &dlm_lock_res->lksb,
 			  flags, str, strlen(str), 0, dlm_ast,
 			  dlm_lock_res, NULL, NULL);
@@ -177,8 +171,6 @@ int cluster_release_dlmlock(int lockid)
 	if (!cluster_name)
 		return -1;
 
-	/* if flags with LKF_CONVERT causes below return EINVAL which means
-	 * "Invalid argument" */
 	ret = dlm_hooks->ls_unlock(dlm_lock_res->ls, lockid, 0,
 				     &dlm_lock_res->lksb, dlm_lock_res);
 	if (ret) {
-- 
2.6.2

