From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 17/24] Communication Framework: Sending functions
Date: Thu, 18 Dec 2014 10:18:10 -0600
Message-ID: <20141218161810.GA29646@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The sending part is split in two functions to make sure
atomicity of the operations, such as the MD superblock update.

Signed-off-by: Lidong Zhong <lzhong@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 259d4c2..1e11a9b 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -360,6 +360,90 @@ static void recv_daemon(struct md_thread *thread)
 	dlm_unlock_sync(message_lockres);
 }
 
+/* lock_comm()
+ * Takes the lock on the TOKEN lock resource so no other
+ * node can communicate while the operation is underway.
+ */
+static int lock_comm(struct md_cluster_info *cinfo)
+{
+	int error;
+	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
+	if (error)
+		pr_err("md-cluster(%s:%d): failed to get EX on "
+			"TOKEN (%d)\n",	__func__, __LINE__, error);
+	return error;
+}
+
+static void unlock_comm(struct md_cluster_info *cinfo)
+{
+	dlm_unlock_sync(cinfo->token_lockres);
+}
+
+/* __sendmsg()
+ * This function performs the actual sending of the message. This function is
+ * usually called after performing the encompassing operation
+ * The function:
+ * 1. Grabs the message lockresource in EX mode
+ * 2. Copies the message to the message LVB
+ * 3. Downconverts message lockresource to CR
+ * 4. Upconverts ack lock resource from CR to EX. This forces the BAST on other nodes
+ *    and the other nodes read the message. The thread will wait here until all other
+ *    nodes have released ack lock resource.
+ * 5. Downconvert ack lockresource to CR
+ */
+static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
+{
+	int error;
+	int slot = cinfo->slot_number - 1;
+	cmsg->slot = cpu_to_le32(slot);
+	/*get EX on Message*/
+	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
+	if (error) {
+		pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", error);
+		goto failed_message;
+	}
+
+	memcpy(cinfo->message_lockres->lksb.sb_lvbptr, (void *)cmsg,
+			sizeof(struct cluster_msg));
+	/*down-convert EX to CR on Message*/
+	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_CR);
+	if (error) {
+		pr_err("md-cluster: failed to convert EX to CR "
+				"on MESSAGE(%d)\n", error);
+		goto failed_message;
+	}
+
+	/*up-convert CR to EX on Ack*/
+	error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_EX);
+	if (error) {
+		pr_err("md-cluster: failed to convert CR to EX "
+				"on ACK(%d)\n", error);
+		goto failed_ack;
+	}
+
+	/*down-convert EX to CR on Ack*/
+	error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR);
+	if (error) {
+		pr_err("md-cluster: failed to convert EX to CR "
+				"on ACK(%d)\n", error);
+		goto failed_ack;
+	}
+
+failed_ack:
+	dlm_unlock_sync(cinfo->message_lockres);
+failed_message:
+	return error;
+}
+
+static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
+{
+	int ret;
+	lock_comm(cinfo);
+	ret = __sendmsg(cinfo, cmsg);
+	unlock_comm(cinfo);
+	return ret;
+}
+
 static int gather_all_resync_info(struct mddev *mddev, int total_slots)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
-- 
2.1.2

