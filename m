From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 09/12] md-cluster: add missed lockres_free
Date: Fri, 10 Jul 2015 17:01:20 +0800
Message-ID: <1436518883-12783-6-git-send-email-gqjiang@suse.com>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518883-12783-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We also need to free the lock resource before goto out.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 057a973..411b430 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -647,8 +647,10 @@ static int gather_all_resync_info(struct mddev *mddev, int total_slots)
 			lockres_free(bm_lockres);
 			continue;
 		}
-		if (ret)
+		if (ret) {
+			lockres_free(bm_lockres);
 			goto out;
+		}
 		/* TODO: Read the disk bitmap sb and check if it needs recovery */
 		dlm_unlock_sync(bm_lockres);
 		lockres_free(bm_lockres);
-- 
1.7.12.4

