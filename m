From: Abhijit Bhopatkar <abhopatk@cisco.com>
Subject: [PATCH] md-cluster: avoid deadlock on MESSAGE lock resource
Date: Fri, 08 May 2015 18:40:51 +0530
Message-ID: <554CB5DB.4020305@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Lidong Zhong <lzhong@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: "Reese Faucette (rfaucett)" <rfaucett@cisco.com>
List-Id: linux-raid.ids


Every receiver has CR lock on MESSAGE while processing the message. When
every receiver releases ACK lock and for some reason fails to grab EX on
MESSAGE resource in time, a waiting sender could queue an EX on MESSAGE
instead. Now when receiver queues its up convert request on MESSAGE it
will end up in a deadlock situation.

Setting NOQUEUE flag on MESSAGE lock resource while grabbing the EX on
MESSAGE on sender will avoid this deadlock. If sender can not grab
MESSAGE lock immediately it should retry until the lock is granted.

Signed-off-by: Abhijit Bhopatkar <abhopatk@cisco.com>
---
This has been minimally tested on a three node cluster. 

 drivers/md/md-cluster.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index fcfc4b9..04ac309 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -512,7 +512,10 @@ static void unlock_comm(struct md_cluster_info *cinfo)
  * This function performs the actual sending of the message. This function is
  * usually called after performing the encompassing operation
  * The function:
- * 1. Grabs the message lockresource in EX mode
+ * 1. Grabs the message lockresource in EX. Do not queue the request if not granted
+      immediately. This avoids deadlock with receivers when receivers try to
+      upconvert CR to EX of message lockresource. The thread will retry until the
+      request is granted.
  * 2. Copies the message to the message LVB
  * 3. Downconverts message lockresource to CR
  * 4. Upconverts ack lock resource from CR to EX. This forces the BAST on other nodes
@@ -526,12 +529,19 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 	int slot = cinfo->slot_number - 1;
 
 	cmsg->slot = cpu_to_le32(slot);
-	/*get EX on Message*/
+
+	/* get EX on Message with noqueue flag */
+	cinfo->message_lockres->flags |= DLM_LKF_NOQUEUE;
+
+retry:
 	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
 	if (error) {
+		if (error == -EAGAIN)
+			goto retry;
 		pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", error);
 		goto failed_message;
 	}
+	cinfo->message_lockres->flags &= ~DLM_LKF_NOQUEUE;
 
 	memcpy(cinfo->message_lockres->lksb.sb_lvbptr, (void *)cmsg,
 			sizeof(struct cluster_msg));
-- 2.1.0 
