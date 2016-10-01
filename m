From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 06/15] md-cluster: Rename a jump label in recv_daemon()
Date: Sat, 1 Oct 2016 16:51:04 +0200
Message-ID: <fefc108f-ff73-9999-8c96-1a014804117a@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 12:36:30 +0200

Adjust a jump label according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-cluster.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index adf9555..94835b5 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -620,7 +620,7 @@ static void recv_daemon(struct md_thread *thread)
 	memcpy(&msg, message_lockres->lksb.sb_lvbptr, sizeof(msg));
 	ret = process_recvd_msg(thread->mddev, &msg);
 	if (ret)
-		goto out;
+		goto unlock;
 
 	/*release CR on ack_lockres*/
 	ret = dlm_unlock_sync(ack_lockres);
@@ -634,7 +634,7 @@ static void recv_daemon(struct md_thread *thread)
 	ret = dlm_lock_sync(ack_lockres, DLM_LOCK_CR);
 	if (unlikely(ret != 0))
 		pr_info("lock CR on ack failed return %d\n", ret);
-out:
+unlock:
 	/*release CR on message_lockres*/
 	ret = dlm_unlock_sync(message_lockres);
 	if (unlikely(ret != 0))
-- 
2.10.0

