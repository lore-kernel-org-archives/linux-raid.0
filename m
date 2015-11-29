From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V3 2/2] md-cluster: Protect communication with mutexes
Date: Mon, 30 Nov 2015 01:43:09 +0800
Message-ID: <1448818989-8280-1-git-send-email-gqjiang@suse.com>
References: <1448787432-4138-2-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448787432-4138-2-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

Communication can happen through multiple threads. It is possible that
one thread steps over another threads sequence. So, we use mutexes to
protect both the send and receive sequences.

Send communication is locked through state bit, MD_CLUSTER_SEND_LOCK.
Communication is locked with bit manipulation in order to allow
"lock and hold" for the add operation. In case of an add operation,
if the lock is held, MD_CLUSTER_SEND_LOCKED_ALREADY is set.
When md_update_sb() calls metadata_update_start(), it checks
(in a single statement to avoid races), if the communication
is already locked. If yes, it merely returns zero, else it
locks the token lockresource.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
v3 change: add missed mutex_unlock in recv_daemon

v2 changes:
1. replace send_mutex with wait_queue.
2. change MD_CLUSTER_COMM_LOCKED to MD_CLUSTER_SEND_LOCKED_ALREADY,
   and set it later with add_new_disk.
3. add a new lock_token and change lock_comm to make it better
   suit for the specific cases of locking communication.

 drivers/md/md-cluster.c | 73 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 63 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index b659ef7..ad3ec7d 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -48,12 +48,26 @@ struct resync_info {
 #define		MD_CLUSTER_SUSPEND_READ_BALANCING	2
 #define		MD_CLUSTER_BEGIN_JOIN_CLUSTER		3
 
+/* Lock the send communication. This is done through
+ * bit manipulation as opposed to a mutex in order to
+ * accomodate lock and hold. See next comment.
+ */
+#define		MD_CLUSTER_SEND_LOCK			4
+/* If cluster operations must lock the communication channel,
+ * so as to perform extra operations (and no other operation
+ * is allowed on the MD, such as adding a disk. Token needs
+ * to be locked and held until the operation completes with
+ * a md_update_sb(), which would eventually release the lock.
+ */
+#define		MD_CLUSTER_SEND_LOCKED_ALREADY		5
+
 
 struct md_cluster_info {
 	/* dlm lock space and resources for clustered raid. */
 	dlm_lockspace_t *lockspace;
 	int slot_number;
 	struct completion completion;
+	struct mutex recv_mutex;
 	struct dlm_lock_resource *bitmap_lockres;
 	struct dlm_lock_resource **other_bitmap_lockres;
 	struct dlm_lock_resource *resync_lockres;
@@ -68,6 +82,7 @@ struct md_cluster_info {
 	struct dlm_lock_resource *no_new_dev_lockres;
 	struct md_thread *recv_thread;
 	struct completion newdisk_completion;
+	wait_queue_head_t wait;
 	unsigned long state;
 };
 
@@ -508,9 +523,11 @@ static void recv_daemon(struct md_thread *thread)
 	struct cluster_msg msg;
 	int ret;
 
+	mutex_lock(&cinfo->recv_mutex);
 	/*get CR on Message*/
 	if (dlm_lock_sync(message_lockres, DLM_LOCK_CR)) {
 		pr_err("md/raid1:failed to get CR on MESSAGE\n");
+		mutex_unlock(&cinfo->recv_mutex);
 		return;
 	}
 
@@ -534,33 +551,45 @@ static void recv_daemon(struct md_thread *thread)
 	ret = dlm_unlock_sync(message_lockres);
 	if (unlikely(ret != 0))
 		pr_info("unlock msg failed return %d\n", ret);
+	mutex_unlock(&cinfo->recv_mutex);
 }
 
-/* lock_comm()
+/* lock_token()
  * Takes the lock on the TOKEN lock resource so no other
  * node can communicate while the operation is underway.
- * If called again, and the TOKEN lock is alread in EX mode
- * return success. However, care must be taken that unlock_comm()
- * is called only once.
  */
-static int lock_comm(struct md_cluster_info *cinfo)
+static int lock_token(struct md_cluster_info *cinfo)
 {
 	int error;
 
-	if (cinfo->token_lockres->mode == DLM_LOCK_EX)
-		return 0;
-
 	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
 	if (error)
 		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
 				__func__, __LINE__, error);
+
+	/* Lock the receive sequence */
+	mutex_lock(&cinfo->recv_mutex);
 	return error;
 }
 
+/* lock_comm()
+ * Sets the MD_CLUSTER_SEND_LOCK bit to lock the send channel.
+ */
+static int lock_comm(struct md_cluster_info *cinfo)
+{
+	wait_event(cinfo->wait,
+		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
+
+	return lock_token(cinfo);
+}
+
 static void unlock_comm(struct md_cluster_info *cinfo)
 {
 	WARN_ON(cinfo->token_lockres->mode != DLM_LOCK_EX);
+	mutex_unlock(&cinfo->recv_mutex);
 	dlm_unlock_sync(cinfo->token_lockres);
+	clear_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state);
+	wake_up(&cinfo->wait);
 }
 
 /* __sendmsg()
@@ -713,6 +742,8 @@ static int join(struct mddev *mddev, int nodes)
 	spin_lock_init(&cinfo->suspend_lock);
 	init_completion(&cinfo->completion);
 	set_bit(MD_CLUSTER_BEGIN_JOIN_CLUSTER, &cinfo->state);
+	init_waitqueue_head(&cinfo->wait);
+	mutex_init(&cinfo->recv_mutex);
 
 	mddev->cluster_info = cinfo;
 
@@ -843,9 +874,25 @@ static int slot_number(struct mddev *mddev)
 	return cinfo->slot_number - 1;
 }
 
+/*
+ * Check if the communication is already locked, else lock the communication
+ * channel.
+ * If it is already locked, token is in EX mode, and hence lock_token()
+ * should not be called.
+ */
 static int metadata_update_start(struct mddev *mddev)
 {
-	return lock_comm(mddev->cluster_info);
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+
+	wait_event(cinfo->wait,
+		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state) ||
+		   test_and_clear_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state));
+
+	/* If token is already locked, return 0 */
+	if (cinfo->token_lockres->mode == DLM_LOCK_EX)
+		return 0;
+
+	return lock_token(cinfo);
 }
 
 static int metadata_update_finish(struct mddev *mddev)
@@ -870,6 +917,7 @@ static int metadata_update_finish(struct mddev *mddev)
 		ret = __sendmsg(cinfo, &cmsg);
 	} else
 		pr_warn("md-cluster: No good device id found to send\n");
+	clear_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
 	unlock_comm(cinfo);
 	return ret;
 }
@@ -877,6 +925,7 @@ static int metadata_update_finish(struct mddev *mddev)
 static void metadata_update_cancel(struct mddev *mddev)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
+	clear_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
 	unlock_comm(cinfo);
 }
 
@@ -970,14 +1019,18 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
 		ret = -ENOENT;
 	if (ret)
 		unlock_comm(cinfo);
-	else
+	else {
 		dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
+		set_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
+		wake_up(&cinfo->wait);
+	}
 	return ret;
 }
 
 static void add_new_disk_cancel(struct mddev *mddev)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
+	clear_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
 	unlock_comm(cinfo);
 }
 
-- 
2.1.4

