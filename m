From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 1/2] md-cluster: update comments for MD_CLUSTER_SEND_LOCKED_ALREADY
Date: Sat,  5 Dec 2015 02:32:51 +0800
Message-ID: <1449253972-26997-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: gqjiang@suse.com, neilb@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

1. fix unbalanced parentheses.
2. add more description about that MD_CLUSTER_SEND_LOCKED_ALREADY
   will be cleared after set it in add_new_disk.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index ad3ec7d..0ded8e9 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -53,11 +53,12 @@ struct resync_info {
  * accomodate lock and hold. See next comment.
  */
 #define		MD_CLUSTER_SEND_LOCK			4
-/* If cluster operations must lock the communication channel,
- * so as to perform extra operations (and no other operation
- * is allowed on the MD, such as adding a disk. Token needs
- * to be locked and held until the operation completes with
- * a md_update_sb(), which would eventually release the lock.
+/* If cluster operations (such as adding a disk) must lock the
+ * communication channel, so as to perform extra operations
+ * (update metadata) and no other operation is allowed on the
+ * MD. Token needs to be locked and held until the operation
+ * completes witha md_update_sb(), which would eventually release
+ * the lock.
  */
 #define		MD_CLUSTER_SEND_LOCKED_ALREADY		5
 
@@ -1021,6 +1022,18 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
 		unlock_comm(cinfo);
 	else {
 		dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
+		/* Since MD_CHANGE_DEVS will be set in add_bound_rdev which
+		 * will run soon after add_new_disk, the below path will be
+		 * invoked:
+		 *   md_wakeup_thread(mddev->thread)
+		 *	-> conf->thread (raid1d)
+		 *	-> md_check_recovery -> md_update_sb
+		 *	-> metadata_update_start/finish
+		 * MD_CLUSTER_SEND_LOCKED_ALREADY will be cleared eventually.
+		 *
+		 * For other failure cases, metadata_update_cancel and
+		 * add_new_disk_cancel also clear below bit as well.
+		 * */
 		set_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
 		wake_up(&cinfo->wait);
 	}
-- 
2.1.4

