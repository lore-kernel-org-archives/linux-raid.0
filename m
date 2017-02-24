From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 05/14] md-cluster: add new parameter for lock_token
Date: Fri, 24 Feb 2017 11:15:15 +0800
Message-ID: <1487906124-20107-6-git-send-email-gqjiang@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

lock_token is called from either lock_comm or
metadata_update_start, if we look back more for
the call chain, some of them are called with the
reconfig_mutex held while a few of them don't.

Specifically, resync_info_update is mostly called
without the protection of reconfig_mutex. But
resync_finish calls resync_info_update within
the mutex.

We make the change to lock_token since we need
to use synchronous way to handle METADATA_UPDATED
message in latter patch.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 1ec89273ff99..a6cf02c5c7bc 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -646,7 +646,7 @@ static void recv_daemon(struct md_thread *thread)
  * Takes the lock on the TOKEN lock resource so no other
  * node can communicate while the operation is underway.
  */
-static int lock_token(struct md_cluster_info *cinfo)
+static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
 {
 	int error;
 
@@ -663,12 +663,12 @@ static int lock_token(struct md_cluster_info *cinfo)
 /* lock_comm()
  * Sets the MD_CLUSTER_SEND_LOCK bit to lock the send channel.
  */
-static int lock_comm(struct md_cluster_info *cinfo)
+static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
 {
 	wait_event(cinfo->wait,
 		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
 
-	return lock_token(cinfo);
+	return lock_token(cinfo, mddev_locked);
 }
 
 static void unlock_comm(struct md_cluster_info *cinfo)
@@ -743,11 +743,12 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 	return error;
 }
 
-static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
+static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg,
+		   bool mddev_locked)
 {
 	int ret;
 
-	lock_comm(cinfo);
+	lock_comm(cinfo, mddev_locked);
 	ret = __sendmsg(cinfo, cmsg);
 	unlock_comm(cinfo);
 	return ret;
@@ -944,7 +945,7 @@ static void resync_bitmap(struct mddev *mddev)
 	int err;
 
 	cmsg.type = cpu_to_le32(BITMAP_NEEDS_SYNC);
-	err = sendmsg(cinfo, &cmsg);
+	err = sendmsg(cinfo, &cmsg, 1);
 	if (err)
 		pr_err("%s:%d: failed to send BITMAP_NEEDS_SYNC message (%d)\n",
 			__func__, __LINE__, err);
@@ -1007,7 +1008,7 @@ static int metadata_update_start(struct mddev *mddev)
 	if (cinfo->token_lockres->mode == DLM_LOCK_EX)
 		return 0;
 
-	return lock_token(cinfo);
+	return lock_token(cinfo, 1);
 }
 
 static int metadata_update_finish(struct mddev *mddev)
@@ -1070,7 +1071,14 @@ static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
 	cmsg.low = cpu_to_le64(lo);
 	cmsg.high = cpu_to_le64(hi);
 
-	return sendmsg(cinfo, &cmsg);
+	/*
+	 * mddev_lock is held if resync_info_update is called from
+	 * resync_finish (md_reap_sync_thread -> resync_finish)
+	 */
+	if (lo == 0 && hi == 0)
+		return sendmsg(cinfo, &cmsg, 1);
+	else
+		return sendmsg(cinfo, &cmsg, 0);
 }
 
 static int resync_finish(struct mddev *mddev)
@@ -1120,7 +1128,7 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
 	cmsg.type = cpu_to_le32(NEWDISK);
 	memcpy(cmsg.uuid, uuid, 16);
 	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
-	lock_comm(cinfo);
+	lock_comm(cinfo, 1);
 	ret = __sendmsg(cinfo, &cmsg);
 	if (ret)
 		return ret;
@@ -1180,7 +1188,7 @@ static int remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 	cmsg.type = cpu_to_le32(REMOVE);
 	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
-	return sendmsg(cinfo, &cmsg);
+	return sendmsg(cinfo, &cmsg, 1);
 }
 
 static int lock_all_bitmaps(struct mddev *mddev)
@@ -1244,7 +1252,7 @@ static int gather_bitmaps(struct md_rdev *rdev)
 
 	cmsg.type = cpu_to_le32(RE_ADD);
 	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
-	err = sendmsg(cinfo, &cmsg);
+	err = sendmsg(cinfo, &cmsg, 1);
 	if (err)
 		goto out;
 
-- 
2.6.2

