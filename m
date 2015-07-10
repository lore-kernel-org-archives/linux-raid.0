From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 12/12] md-cluster: handle error situations more precisely in lockres_init
Date: Fri, 10 Jul 2015 17:01:23 +0800
Message-ID: <1436518883-12783-9-git-send-email-gqjiang@suse.com>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518883-12783-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In lockres_init, it's better to distinguish different err conditions.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index c35a03a..54d225c 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -131,14 +131,14 @@ static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 	res->name = kzalloc(namelen + 1, GFP_KERNEL);
 	if (!res->name) {
 		pr_err("md-cluster: Unable to allocate resource name for resource %s\n", name);
-		goto out_err;
+		goto out_err_name;
 	}
 	strlcpy(res->name, name, namelen + 1);
 	if (with_lvb) {
 		res->lksb.sb_lvbptr = kzalloc(LVB_SIZE, GFP_KERNEL);
 		if (!res->lksb.sb_lvbptr) {
 			pr_err("md-cluster: Unable to allocate LVB for resource %s\n", name);
-			goto out_err;
+			goto out_err_lvb;
 		}
 		res->flags = DLM_LKF_VALBLK;
 	}
@@ -159,7 +159,9 @@ static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 	return res;
 out_err:
 	kfree(res->lksb.sb_lvbptr);
+out_err_lvb:
 	kfree(res->name);
+out_err_name:
 	kfree(res);
 	return NULL;
 }
@@ -627,7 +629,6 @@ static int gather_all_resync_info(struct mddev *mddev, int total_slots)
 	char str[64];
 	sector_t lo, hi;
 
-
 	for (i = 0; i < total_slots; i++) {
 		memset(str, '\0', 64);
 		snprintf(str, 64, "bitmap%04d", i);
-- 
1.7.12.4

