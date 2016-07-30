From: shli@kernel.org
Subject: [PATCH 3/3] MD: hold mddev lock for md-cluster receive thread
Date: Sat, 30 Jul 2016 16:54:40 -0700
Message-ID: <7763e508fb97d44bd61e826912055617b8be2c2d.1469922791.git.shli@fb.com>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
In-Reply-To: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

md-cluster receive thread calls .quiesce too, let it hold mddev lock.

Cc: NeilBrown <neilb@suse.com>
Cc: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md-cluster.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 41573f1..f420060 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -567,11 +567,13 @@ static void recv_daemon(struct md_thread *thread)
 	struct cluster_msg msg;
 	int ret;
 
+	mddev_lock_nointr(thread->mddev);
 	mutex_lock(&cinfo->recv_mutex);
 	/*get CR on Message*/
 	if (dlm_lock_sync(message_lockres, DLM_LOCK_CR)) {
 		pr_err("md/raid1:failed to get CR on MESSAGE\n");
 		mutex_unlock(&cinfo->recv_mutex);
+		mddev_unlock(thread->mddev);
 		return;
 	}
 
@@ -599,6 +601,7 @@ static void recv_daemon(struct md_thread *thread)
 	if (unlikely(ret != 0))
 		pr_info("unlock msg failed return %d\n", ret);
 	mutex_unlock(&cinfo->recv_mutex);
+	mddev_unlock(thread->mddev);
 }
 
 /* lock_token()
-- 
2.7.4

