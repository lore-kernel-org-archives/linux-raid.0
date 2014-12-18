From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 16/24] Communication Framework: Receiving
Date: Thu, 18 Dec 2014 10:18:01 -0600
Message-ID: <20141218161801.GA29642@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

1. receive status

   sender                         receiver                   receiver
   ACK:CR                          ACK:CR                     ACK:CR

2. sender get EX of TOKEN
   sender get EX of MESSAGE
   sender                          receiver                   receiver
   TOKEN:EX                         ACK:CR                     ACK:CR
   MESSAGE:EX
   ACK:CR

3. sender write LVB.
   sender down-convert MESSAGE from EX to CR
   sender try to get EX of ACK
   [ wait until all receiver has *processed* the MESSAGE ]

                                     [ triggered by bast of ACK ]
                                     receiver get CR of MESSAGE
                                     receiver read LVB
                                     receiver processes the message
				     [ wait finish ]
                                     receiver release ACK

   sender                         receiver                   receiver
   TOKEN:EX                       MESSAGE:CR                 MESSAGE:CR
   MESSAGE:CR
   ACK:EX

4. sender down-convert ACK from EX to CR
   sender release MESSAGE
   sender release TOKEN
				  receiver upconvert to EX of MESSAGE
                                  receiver get CR of ACK
				  receiver release MESSAGE

   sender                        receiver                   receiver
   ACK:CR                         ACK:CR                     ACK:CR

Signed-off-by: Lidong Zhong <lzhong@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 617ffee..259d4c2 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -55,6 +55,23 @@ struct md_cluster_info {
 	spinlock_t suspend_lock;
 	struct md_thread *recovery_thread;
 	unsigned long recovery_map;
+	/* communication loc resources */
+	struct dlm_lock_resource *ack_lockres;
+	struct dlm_lock_resource *message_lockres;
+	struct dlm_lock_resource *token_lockres;
+	struct md_thread *recv_thread;
+};
+
+enum msg_type {
+	METADATA_UPDATED = 0,
+	RESYNCING
+};
+
+struct cluster_msg {
+	int type;
+	int slot;
+	sector_t low;
+	sector_t high;
 };
 
 static void sync_ast(void *arg)
@@ -286,6 +303,63 @@ static const struct dlm_lockspace_ops md_ls_ops = {
 	.recover_done = recover_done,
 };
 
+/*
+ * The BAST function for the ack lock resource
+ * This function wakes up the receive thread in
+ * order to receive and process the message.
+ */
+static void ack_bast(void *arg, int mode)
+{
+	struct dlm_lock_resource *res = (struct dlm_lock_resource *)arg;
+	struct md_cluster_info *cinfo = res->mddev->cluster_info;
+	if (mode == DLM_LOCK_EX)
+		md_wakeup_thread(cinfo->recv_thread);
+}
+
+static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
+{
+	switch (msg->type) {
+		case METADATA_UPDATED:
+			pr_info("%s: %d Received message: METADATA_UPDATE from %d\n",
+					__func__, __LINE__, msg->slot);
+			break;
+		case RESYNCING:
+			pr_info("%s: %d Received message: RESYNCING from %d\n",
+					__func__, __LINE__, msg->slot);
+			break;
+	};
+}
+
+/*
+ * thread for receiving message
+ */
+static void recv_daemon(struct md_thread *thread)
+{
+	struct md_cluster_info *cinfo = thread->mddev->cluster_info;
+	struct dlm_lock_resource *ack_lockres = cinfo->ack_lockres;
+	struct dlm_lock_resource *message_lockres = cinfo->message_lockres;
+	struct cluster_msg msg;
+
+	/*get CR on Message*/
+	if (dlm_lock_sync(message_lockres, DLM_LOCK_CR)) {
+		pr_err("md/raid1:failed to get CR on MESSAGE\n");
+		return;
+	}
+
+	/* read lvb and wake up thread to process this message_lockres */
+	memcpy(&msg, message_lockres->lksb.sb_lvbptr, sizeof(struct cluster_msg));
+	process_recvd_msg(thread->mddev, &msg);
+
+	/*release CR on ack_lockres*/
+	dlm_unlock_sync(ack_lockres);
+	/*up-convert to EX on message_lockres*/
+	dlm_lock_sync(message_lockres, DLM_LOCK_EX);
+	/*get CR on ack_lockres again*/
+	dlm_lock_sync(ack_lockres, DLM_LOCK_CR);
+	/*release CR on message_lockres*/
+	dlm_unlock_sync(message_lockres);
+}
+
 static int gather_all_resync_info(struct mddev *mddev, int total_slots)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
@@ -372,6 +446,26 @@ static int join(struct mddev *mddev, int nodes)
 		ret = -ENOMEM;
 		goto err;
 	}
+	/* Initiate the communication resources */
+	ret = -ENOMEM;
+	cinfo->recv_thread = md_register_thread(recv_daemon, mddev, "cluster_recv");
+	if (!cinfo->recv_thread) {
+		pr_err("md-cluster: cannot allocate memory for recv_thread!\n");
+		goto err;
+	}
+	cinfo->message_lockres = lockres_init(mddev, "message", NULL, 1);
+	if (!cinfo->message_lockres)
+		goto err;
+	cinfo->token_lockres = lockres_init(mddev, "token", NULL, 0);
+	if (!cinfo->token_lockres)
+		goto err;
+	cinfo->ack_lockres = lockres_init(mddev, "ack", ack_bast, 0);
+	if (!cinfo->ack_lockres)
+		goto err;
+	/* get sync CR lock on ACK. */
+	if (dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR))
+		pr_err("md-cluster: failed to get a sync CR lock on ACK!(%d)\n",
+				ret);
 
 	pr_info("Joined cluster %s slot %d\n", str, cinfo->slot_number);
 
@@ -395,6 +489,9 @@ static int join(struct mddev *mddev, int nodes)
 
 	return 0;
 err:
+	lockres_free(cinfo->message_lockres);
+	lockres_free(cinfo->token_lockres);
+	lockres_free(cinfo->ack_lockres);
 	lockres_free(cinfo->bitmap_lockres);
 	lockres_free(cinfo->sb_lock);
 	if (cinfo->lockspace)
@@ -411,6 +508,10 @@ static int leave(struct mddev *mddev)
 	if (!cinfo)
 		return 0;
 	md_unregister_thread(&cinfo->recovery_thread);
+	md_unregister_thread(&cinfo->recv_thread);
+	lockres_free(cinfo->message_lockres);
+	lockres_free(cinfo->token_lockres);
+	lockres_free(cinfo->ack_lockres);
 	lockres_free(cinfo->sb_lock);
 	lockres_free(cinfo->bitmap_lockres);
 	dlm_release_lockspace(cinfo->lockspace, 2);
-- 
2.1.2

