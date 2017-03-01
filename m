From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 06/14] md-cluster: use sync way to handle METADATA_UPDATED msg
Date: Wed,  1 Mar 2017 10:02:36 +0800
Message-ID: <1488333756-16372-1-git-send-email-gqjiang@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Previously, when node received METADATA_UPDATED msg, it just
need to wakeup mddev->thread, then md_reload_sb will be called
eventually.

We taken the asynchronous way to avoid a deadlock issue, the
deadlock issue could happen when one node is receiving the
METADATA_UPDATED msg (wants reconfig_mutex) and trying to run
the path:

md_check_recovery -> mddev_trylock(hold reconfig_mutex)
                  -> md_update_sb-metadata_update_start
		     (want EX on token however token is
		      got by the sending node)

Since we will support resizing for clustered raid, and we
need the metadata update handling to be synchronous so that
the initiating node can detect failure, so we need to change
the way for handling METADATA_UPDATED msg.

But, we obviously need to avoid above deadlock with the
sync way. To make this happen, we considered to not hold
reconfig_mutex to call md_reload_sb, if some other thread
has already taken reconfig_mutex and waiting for the 'token',
then process_recvd_msg() can safely call md_reload_sb()
without taking the mutex. This is because we can be certain
that no other thread will take the mutex, and we also certain
that the actions performed by md_reload_sb() won't interfere
with anything that the other thread is in the middle of.

To make this more concrete, we added a new cinfo->state bit
        MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD

Which is set in lock_token() just before dlm_lock_sync() is
called, and cleared just after. As lock_token() is always
called with reconfig_mutex() held (the specific case is the
resync_info_update which is distinguished well in previous
patch), if process_recvd_msg() finds that the new bit is set,
then the mutex must be held by some other thread, and it will
keep waiting.

So process_metadata_update() can call md_reload_sb() if either
mddev_trylock() succeeds, or if MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD
is set. The tricky bit is what to do if neither of these apply.
We need to wait. Fortunately mddev_unlock() always calls wake_up()
on mddev->thread->wqueue. So we can get lock_token() to call
wake_up() on that when it sets the bit.

Also remove RELOAD_SB related codes since there are not valid
anymore.

Finally, thanks to Neil for his great idea and help!

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 28 +++++++++++++++++++++++++---
 drivers/md/md.c         |  4 ----
 drivers/md/md.h         |  3 ---
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index a6cf02c5c7bc..0aad477d1b20 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -66,7 +66,7 @@ struct resync_info {
  * set up all the related infos such as bitmap and personality */
 #define		MD_CLUSTER_ALREADY_IN_CLUSTER		6
 #define		MD_CLUSTER_PENDING_RECV_EVENT		7
-
+#define 	MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD		8
 
 struct md_cluster_info {
 	struct mddev *mddev; /* the md device which md_cluster_info belongs to */
@@ -523,11 +523,17 @@ static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
 
 static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg)
 {
+	int got_lock = 0;
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 	mddev->good_device_nr = le32_to_cpu(msg->raid_slot);
-	set_bit(MD_RELOAD_SB, &mddev->flags);
+
 	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
-	md_wakeup_thread(mddev->thread);
+	wait_event(mddev->thread->wqueue,
+		   (got_lock = mddev_trylock(mddev)) ||
+		    test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state));
+	md_reload_sb(mddev, mddev->good_device_nr);
+	if (got_lock)
+		mddev_unlock(mddev);
 }
 
 static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
@@ -649,8 +655,24 @@ static void recv_daemon(struct md_thread *thread)
 static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
 {
 	int error;
+	struct mddev *mddev = cinfo->mddev;
 
+	/*
+	 * If resync thread run after raid1d thread, then process_metadata_update
+	 * could not continue if raid1d held reconfig_mutex (and raid1d is blocked
+	 * since another node already got EX on Token and waitting the EX of Ack),
+	 * so let resync wake up thread in case flag is set.
+	 */
+	if (mddev_locked) {
+		error = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
+					      &cinfo->state);
+		WARN_ON_ONCE(error);
+		md_wakeup_thread(mddev->thread);
+	}
 	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
+	if (mddev_locked)
+		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
+
 	if (error)
 		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
 				__func__, __LINE__, error);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 55e7e7a8714e..6e910d99c9c1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8389,7 +8389,6 @@ void md_check_recovery(struct mddev *mddev)
 		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
-		test_bit(MD_RELOAD_SB, &mddev->flags) ||
 		(mddev->external == 0 && mddev->safemode == 1) ||
 		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
 		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
@@ -8438,9 +8437,6 @@ void md_check_recovery(struct mddev *mddev)
 						rdev->raid_disk < 0)
 					md_kick_rdev_from_array(rdev);
 			}
-
-			if (test_and_clear_bit(MD_RELOAD_SB, &mddev->flags))
-				md_reload_sb(mddev, mddev->good_device_nr);
 		}
 
 		if (!mddev->external) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b8859cbf84b6..ec5ffde03ccf 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -219,9 +219,6 @@ enum mddev_flags {
 				 * it then */
 	MD_JOURNAL_CLEAN,	/* A raid with journal is already clean */
 	MD_HAS_JOURNAL,		/* The raid array has journal feature set */
-	MD_RELOAD_SB,		/* Reload the superblock because another node
-				 * updated it.
-				 */
 	MD_CLUSTER_RESYNC_LOCKED, /* cluster raid only, which means node
 				   * already took resync lock, need to
 				   * release the lock */
-- 
2.6.2

