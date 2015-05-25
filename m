From: Abhijit Bhopatkar <abhopatk@cisco.com>
Subject: [PATCH V2] md-cluster: avoid deadlock on MESSAGE lock resource
Date: Mon, 25 May 2015 22:04:24 +0530
Message-ID: <55634F10.8090809@cisco.com>
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

Setting HEADQUE flag on MESSAGE lock resource while grabbing the EX on
MESSAGE on receiver will avoid this deadlock. Any queued request by
sender will be processed only after all receivers have released their
EX on MESSAGE.

Signed-off-by: Abhijit Bhopatkar <abhopatk@cisco.com>
---
Version 2 changes from v1: Made receiver HEADQUE rather than
making sender NOQUEUE, also get rid of goto pollution  

Minimaly tested on three node cluster, operations create,assemble
tested on two a shared raid disks.

 drivers/md/md-cluster.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index fcfc4b9..cb76c0f 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -480,8 +480,17 @@ static void recv_daemon(struct md_thread *thread)
 
 	/*release CR on ack_lockres*/
 	dlm_unlock_sync(ack_lockres);
-	/*up-convert to EX on message_lockres*/
+
+	/* up-convert to EX on message_lockres
+	 * Since another sender might already be ready to send data.
+	 * Use DLM_LKF_HEADQUE to move this lock request ahead of
+	 * that sender.
+	 */
+
+	message_lockres->flags |= DLM_LKF_HEADQUE;
 	dlm_lock_sync(message_lockres, DLM_LOCK_EX);
+	message_lockres->flags &= ~DLM_LKF_HEADQUE;
+
 	/*get CR on ack_lockres again*/
 	dlm_lock_sync(ack_lockres, DLM_LOCK_CR);
 	/*release CR on message_lockres*/
-- 
2.1.0
