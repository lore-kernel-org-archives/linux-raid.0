From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 2/2] md: clear THREAD_WAKEUP flag in mddev_trylock
Date: Fri, 29 Sep 2017 09:16:44 +0800
Message-ID: <1506647804-469-2-git-send-email-gqjiang@suse.com>
References: <1506647804-469-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1506647804-469-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Since commit 4ad23a976413aa57fe5ba7a25953dc35ccca5b71 ("MD: use
per-cpu counter for writes_pending"), the wait_queue is only got
invoked if THREAD_WAKEUP is not set previously.

With above change, I can see process_metadata_update could always
hang on the wait queue, because mddev->thread could stay on 'D'
status and the THREAD_WAKEUP flag is not cleared since there are
lots of place to wake up mddev->thread. Then deadlock happened
as follows:

linux175:~ # ps aux|grep md|grep D
root    20117   0.0 0.0         0   0 ? D   03:45   0:00 [md0_raid1]
root    20125   0.0 0.0         0   0 ? D   03:45   0:00 [md0_cluster_rec]
linux175:~ # cat /proc/20117/stack
[<ffffffffa0635604>] dlm_lock_sync+0x94/0xd0 [md_cluster]
[<ffffffffa0635674>] lock_token+0x34/0xd0 [md_cluster]
[<ffffffffa0635804>] metadata_update_start+0x64/0x110 [md_cluster]
[<ffffffffa04d985b>] md_update_sb.part.58+0x9b/0x860 [md_mod]
[<ffffffffa04da035>] md_update_sb+0x15/0x30 [md_mod]
[<ffffffffa04dc066>] md_check_recovery+0x266/0x490 [md_mod]
[<ffffffffa06450e2>] raid1d+0x42/0x810 [raid1]
[<ffffffffa04d2252>] md_thread+0x122/0x150 [md_mod]
[<ffffffff81091741>] kthread+0x101/0x140
linux175:~ # cat /proc/20125/stack
[<ffffffffa0636679>] recv_daemon+0x3f9/0x5c0 [md_cluster]
[<ffffffffa04d2252>] md_thread+0x122/0x150 [md_mod]
[<ffffffff81091741>] kthread+0x101/0x140

To resolve the problem, we need to clear THREAD_WAKEUP in case
mddev_trylock failed to get reconfig_mutex, which could ensure
the wait queue can be waked by call md_wakeup_thread. And this
issue maybe affects mddev_trylock in md_check_recovery as well.

With the new change, mddev_trylock is not suitable as static-inline
function, so move it to md.c.

Fixes: 4ad23a976413 ("MD: use per-cpu counter for writes_pending")
Suggested-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 14 ++++++++++++++
 drivers/md/md.h |  5 +----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0ff1bbf..7c2517a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -623,6 +623,20 @@ static struct mddev *mddev_find(dev_t unit)
 
 static struct attribute_group md_redundancy_group;
 
+int mddev_trylock(struct mddev *mddev)
+{
+	if (mutex_trylock(&mddev->reconfig_mutex))
+		return 1;
+
+	spin_lock(&pers_lock);
+	if (mddev->thread)
+		clear_bit(THREAD_WAKEUP, &mddev->thread->flags);
+	spin_unlock(&pers_lock);
+
+	return mutex_trylock(&mddev->reconfig_mutex);
+}
+EXPORT_SYMBOL_GPL(mddev_trylock);
+
 void mddev_unlock(struct mddev *mddev)
 {
 	if (mddev->to_remove) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d8287d3..7fe7b48 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -499,10 +499,7 @@ static inline int mddev_is_locked(struct mddev *mddev)
 	return mutex_is_locked(&mddev->reconfig_mutex);
 }
 
-static inline int mddev_trylock(struct mddev *mddev)
-{
-	return mutex_trylock(&mddev->reconfig_mutex);
-}
+extern int mddev_trylock(struct mddev *mddev);
 extern void mddev_unlock(struct mddev *mddev);
 
 static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
-- 
2.6.6

