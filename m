From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 04/12] md-cluster: fix deadlock issue on message lock
Date: Fri, 10 Jul 2015 17:01:15 +0800
Message-ID: <1436518883-12783-1-git-send-email-gqjiang@suse.com>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is problem with previous communication mechanism, and we got below
deadlock scenario with cluster which has 3 nodes.

	Sender                	    Receiver        		Receiver

	token(EX)
       message(EX)
      writes message
   downconverts message(CR)
      requests ack(EX)
		                  get message(CR)            gets message(CR)
                		  reads message                reads message
		               requests EX on message    requests EX on message

To fix this problem, we do the following changes:

1. the sender downconverts MESSAGE to CW rather than CR.
2. and the receiver request PR lock not EX lock on message.

And in case we failed to down-convert EX to CW on message, it is better to
unlock message otherthan still hold the lock.

Signed-off-by: Lidong Zhong <ldzhong@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Documentation/md-cluster.txt |  4 ++--
 drivers/md/md-cluster.c      | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/md-cluster.txt b/Documentation/md-cluster.txt
index de1af7d..1b79436 100644
--- a/Documentation/md-cluster.txt
+++ b/Documentation/md-cluster.txt
@@ -91,7 +91,7 @@ The algorithm is:
     this message inappropriate or redundant.
 
  3. sender write LVB.
-    sender down-convert MESSAGE from EX to CR
+    sender down-convert MESSAGE from EX to CW
     sender try to get EX of ACK
     [ wait until all receiver has *processed* the MESSAGE ]
 
@@ -112,7 +112,7 @@ The algorithm is:
     sender down-convert ACK from EX to CR
     sender release MESSAGE
     sender release TOKEN
-                               receiver upconvert to EX of MESSAGE
+                               receiver upconvert to PR of MESSAGE
                                receiver get CR of ACK
                                receiver release MESSAGE
 
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 47199ad..85b7836 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -488,8 +488,8 @@ static void recv_daemon(struct md_thread *thread)
 
 	/*release CR on ack_lockres*/
 	dlm_unlock_sync(ack_lockres);
-	/*up-convert to EX on message_lockres*/
-	dlm_lock_sync(message_lockres, DLM_LOCK_EX);
+	/*up-convert to PR on message_lockres*/
+	dlm_lock_sync(message_lockres, DLM_LOCK_PR);
 	/*get CR on ack_lockres again*/
 	dlm_lock_sync(ack_lockres, DLM_LOCK_CR);
 	/*release CR on message_lockres*/
@@ -522,7 +522,7 @@ static void unlock_comm(struct md_cluster_info *cinfo)
  * The function:
  * 1. Grabs the message lockresource in EX mode
  * 2. Copies the message to the message LVB
- * 3. Downconverts message lockresource to CR
+ * 3. Downconverts message lockresource to CW
  * 4. Upconverts ack lock resource from CR to EX. This forces the BAST on other nodes
  *    and the other nodes read the message. The thread will wait here until all other
  *    nodes have released ack lock resource.
@@ -543,12 +543,12 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 
 	memcpy(cinfo->message_lockres->lksb.sb_lvbptr, (void *)cmsg,
 			sizeof(struct cluster_msg));
-	/*down-convert EX to CR on Message*/
-	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_CR);
+	/*down-convert EX to CW on Message*/
+	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_CW);
 	if (error) {
-		pr_err("md-cluster: failed to convert EX to CR on MESSAGE(%d)\n",
+		pr_err("md-cluster: failed to convert EX to CW on MESSAGE(%d)\n",
 				error);
-		goto failed_message;
+		goto failed_ack;
 	}
 
 	/*up-convert CR to EX on Ack*/
-- 
1.7.12.4

