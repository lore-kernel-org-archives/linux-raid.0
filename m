From: Guoqing Jiang <gqjiang@suse.com>
Subject: [V2 PATCH 04/13] md-cluster: unregister thread if err happened
Date: Mon,  2 May 2016 11:33:11 -0400
Message-ID: <1462203200-1375-5-git-send-email-gqjiang@suse.com>
References: <1462203200-1375-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1462203200-1375-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The two threads need to be unregistered if a node
can't join cluster successfully.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 0d4ddf8..76f88f7 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -818,6 +818,8 @@ static int join(struct mddev *mddev, int nodes)
 
 	return 0;
 err:
+	md_unregister_thread(&cinfo->recovery_thread);
+	md_unregister_thread(&cinfo->recv_thread);
 	lockres_free(cinfo->message_lockres);
 	lockres_free(cinfo->token_lockres);
 	lockres_free(cinfo->ack_lockres);
-- 
2.6.6

