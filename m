From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 09/14] md-cluster: set MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD in metadata_update_start
Date: Fri, 24 Feb 2017 11:15:19 +0800
Message-ID: <1487906124-20107-10-git-send-email-gqjiang@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Since we have switched to sync way to handle METADATA_UPDATED
msg, then process_metadata_update can only continue with either
get the reconfig_mutex or MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD is
set.

However, there is a deadlock issue which happened as follows:

1. Node A sends METADATA_UPDATED msg (held Token lock).
2. Node B wants to do resync, and is blocked since it can't
   get Token lock, but MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD is
   not set since the callchain
   (md_do_sync -> sync_request
               -> resync_info_update
	       -> sendmsg
	       -> lock_comm -> lock_token)
   doesn't hold reconfig_mutex.
3. Node B trys to update sb (held reconfig_mutex), but stopped
   at wait_event() in metadata_update_start since we have set
   MD_CLUSTER_SEND_LOCK flag in lock_comm (step 2).
4. Then Node B receives METADATA_UPDATED msg from A, of course
   recv_daemon is blocked forever.

The followings are more detailed infos.
betalinux240:~ # cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 vdc[1] vdb[0]
2095104 blocks super 1.2 [2/2] [UU]
[>....................]  resync =  4.6% (98112/2095104) finish=28.8min speed=1154K/sec
bitmap: 1/1 pages [4KB], 65536KB chunk

unused devices: <none>
betalinux240:~ # ps aux|grep md|grep D
root      4393  0.0  0.0      0     0 ?        D    11:42   0:00 [md0_raid1]
root      4402  0.0  0.0      0     0 ?        D    11:42   0:00 [md0_cluster_rec]
root      4407  0.0  0.0      0     0 ?        D    11:42   0:00 [md0_resync]
betalinux240:~ # cat /proc/4407/stack
[<ffffffffa05eb531>] dlm_lock_sync+0x81/0xc0 [md_cluster]
[<ffffffffa05eba23>] lock_token+0x23/0xa0 [md_cluster]
[<ffffffffa05ebad2>] lock_comm+0x32/0x90 [md_cluster]
[<ffffffffa05ebb45>] sendmsg+0x15/0x30 [md_cluster]
[<ffffffffa05ebd5a>] resync_info_update+0x8a/0xc0 [md_cluster]
[<ffffffffa06b6ae7>] sync_request+0xa57/0xaf0 [raid1]
[<ffffffffa069825d>] md_do_sync+0x90d/0xe70 [md_mod]
[<ffffffffa0694c50>] md_thread+0x130/0x150 [md_mod]
[<ffffffff810995ed>] kthread+0xbd/0xe0
[<ffffffff815e96bf>] ret_from_fork+0x3f/0x70
[<ffffffff81099530>] kthread+0x0/0xe0
betalinux240:~ # cat /proc/4402/stack
[<ffffffffa05ecf77>] recv_daemon+0x1d7/0x570 [md_cluster]
[<ffffffffa0694c50>] md_thread+0x130/0x150 [md_mod]
[<ffffffff810995ed>] kthread+0xbd/0xe0
[<ffffffff815e96bf>] ret_from_fork+0x3f/0x70
[<ffffffff81099530>] kthread+0x0/0xe0
betalinux240:~ # cat /proc/4393/stack
[<ffffffffa05ec0e5>] metadata_update_start+0xa5/0xb0 [md_cluster]
[<ffffffffa069913e>] md_update_sb.part.50+0x8e/0x850 [md_mod]
[<ffffffffa069ab1d>] md_check_recovery+0x21d/0x4e0 [md_mod]
[<ffffffffa06b9322>] raid1d+0x42/0x7d0 [raid1]
[<ffffffffa0694c50>] md_thread+0x130/0x150 [md_mod]
[<ffffffff810995ed>] kthread+0xbd/0xe0
[<ffffffff815e96bf>] ret_from_fork+0x3f/0x70
[<ffffffff81099530>] kthread+0x0/0xe0

Since metadata_update_start always calls lock_token with
reconfig_mutex, we need to set MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD
here as well, and lock_token don't need to set it twice unless
lock_token is invoked from lock_comm.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 5e2c54be6f30..bcc269312b71 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -654,7 +654,7 @@ static void recv_daemon(struct md_thread *thread)
  */
 static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
 {
-	int error;
+	int error, set_bit = 0;
 	struct mddev *mddev = cinfo->mddev;
 
 	/*
@@ -663,14 +663,16 @@ static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
 	 * since another node already got EX on Token and waitting the EX of Ack),
 	 * so let resync wake up thread in case flag is set.
 	 */
-	if (mddev_locked) {
+	if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
+				      &cinfo->state)) {
 		error = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
 					      &cinfo->state);
 		WARN_ON_ONCE(error);
 		md_wakeup_thread(mddev->thread);
+		set_bit = 1;
 	}
 	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
-	if (mddev_locked)
+	if (set_bit)
 		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
 
 	if (error)
@@ -1023,16 +1025,30 @@ static int slot_number(struct mddev *mddev)
 static int metadata_update_start(struct mddev *mddev)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
+	int ret;
+
+	/*
+	 * metadata_update_start is always called with the protection of
+	 * reconfig_mutex, so set WAITING_FOR_TOKEN here.
+	 */
+	ret = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
+				    &cinfo->state);
+	WARN_ON_ONCE(ret);
+	md_wakeup_thread(mddev->thread);
 
 	wait_event(cinfo->wait,
 		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state) ||
 		   test_and_clear_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state));
 
 	/* If token is already locked, return 0 */
-	if (cinfo->token_lockres->mode == DLM_LOCK_EX)
+	if (cinfo->token_lockres->mode == DLM_LOCK_EX) {
+		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
 		return 0;
+	}
 
-	return lock_token(cinfo, 1);
+	ret = lock_token(cinfo, 1);
+	clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
+	return ret;
 }
 
 static int metadata_update_finish(struct mddev *mddev)
-- 
2.6.2

