From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 05/15] md-cluster: Improve another size determination in
 recv_daemon()
Date: Sat, 1 Oct 2016 16:50:03 +0200
Message-ID: <2eb2819e-9477-12ec-b4a2-91207cf16fd7@users.sourceforge.net>
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
Date: Sat, 1 Oct 2016 12:28:19 +0200

Replace the specification of a data structure by a variable name
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-cluster.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index c81eed4..adf9555 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -617,7 +617,7 @@ static void recv_daemon(struct md_thread *thread)
 	}
 
 	/* read lvb and wake up thread to process this message_lockres */
-	memcpy(&msg, message_lockres->lksb.sb_lvbptr, sizeof(struct cluster_msg));
+	memcpy(&msg, message_lockres->lksb.sb_lvbptr, sizeof(msg));
 	ret = process_recvd_msg(thread->mddev, &msg);
 	if (ret)
 		goto out;
-- 
2.10.0

