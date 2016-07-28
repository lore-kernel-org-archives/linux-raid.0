From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 4/8] md-cluster: introduce dlm_lock_sync_interruptible to fix tasks hang
Date: Thu, 28 Jul 2016 02:16:48 -0400
Message-ID: <1469686612-16126-4-git-send-email-gqjiang@suse.com>
References: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

When some node leaves cluster, then it's bitmap need to be
synced by another node, so "md*_recover" thread is triggered
for the purpose. However, with below steps. we can find tasks
hang happened either in B or C.

1. Node A create a resyncing cluster raid1, assemble it in
   other two nodes (B and C).
2. stop array in B and C.
3. stop array in A.

linux44:~ # ps aux|grep md|grep D
root	5938	0.0  0.1  19852  1964 pts/0    D+   14:52   0:00 mdadm -S md0
root	5939	0.0  0.0      0     0 ?        D    14:52   0:00 [md0_recover]

linux44:~ # cat /proc/5939/stack
[<ffffffffa04cf321>] dlm_lock_sync+0x71/0x90 [md_cluster]
[<ffffffffa04d0705>] recover_bitmaps+0x125/0x220 [md_cluster]
[<ffffffffa052105d>] md_thread+0x16d/0x180 [md_mod]
[<ffffffff8107ad94>] kthread+0xb4/0xc0
[<ffffffff8152a518>] ret_from_fork+0x58/0x90

linux44:~ # cat /proc/5938/stack
[<ffffffff8107afde>] kthread_stop+0x6e/0x120
[<ffffffffa0519da0>] md_unregister_thread+0x40/0x80 [md_mod]
[<ffffffffa04cfd20>] leave+0x70/0x120 [md_cluster]
[<ffffffffa0525e24>] md_cluster_stop+0x14/0x30 [md_mod]
[<ffffffffa05269ab>] bitmap_free+0x14b/0x150 [md_mod]
[<ffffffffa0523f3b>] do_md_stop+0x35b/0x5a0 [md_mod]
[<ffffffffa0524e83>] md_ioctl+0x873/0x1590 [md_mod]
[<ffffffff81288464>] blkdev_ioctl+0x214/0x7d0
[<ffffffff811dd3dd>] block_ioctl+0x3d/0x40
[<ffffffff811b92d4>] do_vfs_ioctl+0x2d4/0x4b0
[<ffffffff811b9538>] SyS_ioctl+0x88/0xa0
[<ffffffff8152a5c9>] system_call_fastpath+0x16/0x1b

The problem is caused by recover_bitmaps can't reliably abort
when the thread is unregistered. So dlm_lock_sync_interruptible
is introduced to detect the thread's situation to fix the problem.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index ea2699e..f3d584e 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -10,6 +10,8 @@
 
 
 #include <linux/module.h>
+#include <linux/completion.h>
+#include <linux/kthread.h>
 #include <linux/dlm.h>
 #include <linux/sched.h>
 #include <linux/raid/md_p.h>
@@ -141,6 +143,40 @@ static int dlm_unlock_sync(struct dlm_lock_resource *res)
 	return dlm_lock_sync(res, DLM_LOCK_NL);
 }
 
+/* An variation of dlm_lock_sync, which make lock request could
+ * be interrupted */
+static int dlm_lock_sync_interruptible(struct dlm_lock_resource *res, int mode,
+				       struct mddev *mddev)
+{
+	int ret = 0;
+
+	ret = dlm_lock(res->ls, mode, &res->lksb,
+			res->flags, res->name, strlen(res->name),
+			0, sync_ast, res, res->bast);
+	if (ret)
+		return ret;
+
+	wait_event(res->completion.wait,
+		   res->completion.done || kthread_should_stop());
+	if (!res->completion.done) {
+		/*
+		 * the convert queue contains the lock request when request is
+		 * interrupted, and sync_ast could still be run, so need to
+		 * cancel the request and reset completion
+		 */
+		ret = dlm_unlock(res->ls, res->lksb.sb_lkid, DLM_LKF_CANCEL, &res->lksb, res);
+		reinit_completion(&res->completion);
+		if (unlikely(ret != 0))
+			pr_info("failed to cancel previous lock request "
+				 "%s return %d\n", res->name, ret);
+		return -EPERM;
+	}
+	wait_for_completion(&res->completion);
+	if (res->lksb.sb_status == 0)
+		res->mode = mode;
+	return res->lksb.sb_status;
+}
+
 static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
 		char *name, void (*bastfn)(void *arg, int mode), int with_lvb)
 {
@@ -272,7 +308,7 @@ static void recover_bitmaps(struct md_thread *thread)
 			goto clear_bit;
 		}
 
-		ret = dlm_lock_sync(bm_lockres, DLM_LOCK_PW);
+		ret = dlm_lock_sync_interruptible(bm_lockres, DLM_LOCK_PW, mddev);
 		if (ret) {
 			pr_err("md-cluster: Could not DLM lock %s: %d\n",
 					str, ret);
-- 
2.6.2

