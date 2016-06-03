From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 1/2] md-cluster: fix deadlock issue when add disk to an recoverying array
Date: Thu,  2 Jun 2016 23:32:04 -0400
Message-ID: <1464924725-18096-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Add a disk to an array which is performing recovery
is a little complicated, we need to do both reap the
sync thread and perform add disk for the case, then
it caused deadlock as follows.

linux44:~ # ps aux|grep md|grep D
root      1822  0.0  0.0      0     0 ?        D    16:50   0:00 [md127_resync]
root      1848  0.0  0.0  19860   952 pts/0    D+   16:50   0:00 mdadm --manage /dev/md127 --re-add /dev/vdb
linux44:~ # cat /proc/1848/stack
[<ffffffff8107afde>] kthread_stop+0x6e/0x120
[<ffffffffa051ddb0>] md_unregister_thread+0x40/0x80 [md_mod]
[<ffffffffa0526e45>] md_reap_sync_thread+0x15/0x150 [md_mod]
[<ffffffffa05271e0>] action_store+0x260/0x270 [md_mod]
[<ffffffffa05206b4>] md_attr_store+0xb4/0x100 [md_mod]
[<ffffffff81214a7e>] sysfs_write_file+0xbe/0x140
[<ffffffff811a6b98>] vfs_write+0xb8/0x1e0
[<ffffffff811a75b8>] SyS_write+0x48/0xa0
[<ffffffff8152a5c9>] system_call_fastpath+0x16/0x1b
[<00007f068ea1ed30>] 0x7f068ea1ed30
linux44:~ # cat /proc/1822/stack
[<ffffffffa05251a6>] md_do_sync+0x846/0xf40 [md_mod]
[<ffffffffa052402d>] md_thread+0x16d/0x180 [md_mod]
[<ffffffff8107ad94>] kthread+0xb4/0xc0
[<ffffffff8152a518>] ret_from_fork+0x58/0x90

                        Task1848                                Task1822
md_attr_store (held reconfig_mutex by call mddev_lock())
                        action_store
			md_reap_sync_thread
			md_unregister_thread
			kthread_stop                    md_wakeup_thread(mddev->thread);
						wait_event(mddev->sb_wait, !test_bit(MD_CHANGE_PENDING))

md_check_recovery is triggered by wakeup mddev->thread,
but it can't clear MD_CHANGE_PENDING flag since it can't
get lock which was held by md_attr_store already.

To solve the deadlock problem, we move "->resync_finish()"
from md_do_sync to md_reap_sync_thread (after md_update_sb),
also MD_HELD_RESYNC_LOCK is introduced since it is possible
that node can't get resync lock in md_do_sync.

Then we do not need to wait for MD_CHANGE_PENDING is cleared
or not since metadata should be updated after md_update_sb,
so just call resync_finish if MD_HELD_RESYNC_LOCK is set.

We also unified the code after skip label, since set PENDING
for non-clustered case should be harmless.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 23 +++++++++++------------
 drivers/md/md.h |  3 +++
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 866825f..25d4542 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7809,6 +7809,7 @@ void md_do_sync(struct md_thread *thread)
 		if (ret)
 			goto skip;
 
+		set_bit(MD_CLUSTER_RESYNC_LOCKED, &mddev->flags);
 		if (!(test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
 			test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ||
 			test_bit(MD_RECOVERY_RECOVER, &mddev->recovery))
@@ -8147,18 +8148,11 @@ void md_do_sync(struct md_thread *thread)
 		}
 	}
  skip:
-	if (mddev_is_clustered(mddev) &&
-	    ret == 0) {
-		/* set CHANGE_PENDING here since maybe another
-		 * update is needed, so other nodes are informed */
-		set_mask_bits(&mddev->flags, 0,
-			      BIT(MD_CHANGE_PENDING) | BIT(MD_CHANGE_DEVS));
-		md_wakeup_thread(mddev->thread);
-		wait_event(mddev->sb_wait,
-			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
-		md_cluster_ops->resync_finish(mddev);
-	} else
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	/* set CHANGE_PENDING here since maybe another update is needed,
+	 * so other nodes are informed. It should be harmless for normal
+	 * raid */
+	set_mask_bits(&mddev->flags, 0,
+		      BIT(MD_CHANGE_PENDING) | BIT(MD_CHANGE_DEVS));
 
 	spin_lock(&mddev->lock);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
@@ -8502,6 +8496,11 @@ void md_reap_sync_thread(struct mddev *mddev)
 			rdev->saved_raid_disk = -1;
 
 	md_update_sb(mddev, 1);
+	/* MD_CHANGE_PENDING should be cleared by md_update_sb, so we can
+	 * call resync_finish here if MD_CLUSTER_RESYNC_LOCKED is set by
+	 * clustered raid */
+	if (test_and_clear_bit(MD_CLUSTER_RESYNC_LOCKED, &mddev->flags))
+		md_cluster_ops->resync_finish(mddev);
 	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b5c4be7..03b19aa 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -204,6 +204,9 @@ struct mddev {
 #define MD_RELOAD_SB	7	/* Reload the superblock because another node
 				 * updated it.
 				 */
+#define MD_CLUSTER_RESYNC_LOCKED 8 /* cluster raid only, which means node
+				    * already took resync lock, need to
+				    * release the lock */
 
 	int				suspended;
 	atomic_t			active_io;
-- 
2.6.6

