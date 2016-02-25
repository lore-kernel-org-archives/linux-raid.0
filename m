From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/2] MD: warn for potential deadlock
Date: Thu, 25 Feb 2016 10:45:04 -0800
Message-ID: <2931bfb770bec6f77a05314863e819338b36af26.1456424579.git.shli@fb.com>
References: <b228d35f9a8e94969d667edbcc9d7f613d706b02.1456424579.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b228d35f9a8e94969d667edbcc9d7f613d706b02.1456424579.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: artur.paszkiewicz@intel.com, neilb@suse.com
List-Id: linux-raid.ids

The personality thread shouldn't call mddev_suspend(). Because
mddev_suspend() will for all IO finish, but IO is handled in personality
thread, so this could cause deadlock. To trigger this early, add a
warning if mddev_suspend() is called from personality thread.

Suggested-by: NeilBrown <neilb@suse.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 464627b..c068f17 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -305,6 +305,7 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
  */
 void mddev_suspend(struct mddev *mddev)
 {
+	WARN_ON_ONCE(current == mddev->thread->tsk);
 	if (mddev->suspended++)
 		return;
 	synchronize_rcu();
-- 
2.6.5

