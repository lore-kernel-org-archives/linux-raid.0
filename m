From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 03/14] md-cluster: remove useless memset from gather_all_resync_info
Date: Fri, 24 Feb 2017 11:15:13 +0800
Message-ID: <1487906124-20107-4-git-send-email-gqjiang@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

This memset is not needed.  The lvb is already zeroed because
it was recently allocated by lockres_init, which uses kzalloc(),
and read_resync_info() doesn't need it to be zero anyway.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 84c001063983..620828e56dc8 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -776,7 +776,6 @@ static int gather_all_resync_info(struct mddev *mddev, int total_slots)
 		bm_lockres->flags |= DLM_LKF_NOQUEUE;
 		ret = dlm_lock_sync(bm_lockres, DLM_LOCK_PW);
 		if (ret == -EAGAIN) {
-			memset(bm_lockres->lksb.sb_lvbptr, '\0', LVB_SIZE);
 			s = read_resync_info(mddev, bm_lockres);
 			if (s) {
 				pr_info("%s:%d Resync[%llu..%llu] in progress on %d\n",
-- 
2.6.2

