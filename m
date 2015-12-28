From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] md: remove unnecesary md_new_event_inintr
Date: Mon, 28 Dec 2015 10:46:38 +0800
Message-ID: <1451270798-25056-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

md_new_event had removed sysfs_notify since 'commit 72a23c211e45
("Make sure all changes to md/sync_action are notified.")', so we
can use md_new_event and delete md_new_event_inintr.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c0c3e6d..43a1404 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -205,15 +205,6 @@ void md_new_event(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_new_event);
 
-/* Alternate version that can be called from interrupts
- * when calling sysfs_notify isn't needed.
- */
-static void md_new_event_inintr(struct mddev *mddev)
-{
-	atomic_inc(&md_event_count);
-	wake_up(&md_event_waiters);
-}
-
 /*
  * Enables to iterate over all existing md arrays
  * all_mddevs_lock protects this list.
@@ -7209,7 +7200,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 	md_wakeup_thread(mddev->thread);
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
-	md_new_event_inintr(mddev);
+	md_new_event(mddev);
 }
 EXPORT_SYMBOL(md_error);
 
-- 
2.6.2

