From: rgoldwyn@suse.de
Subject: [PATCH 12/14] md-cluster: Add 'SUSE' as author for md-cluster.c
Date: Tue, 13 Oct 2015 09:25:33 -0500
Message-ID: <1444746335-22624-13-git-send-email-rgoldwyn@suse.de>
References: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index c7b8027..35ac2e8 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1051,5 +1051,6 @@ static void cluster_exit(void)
 
 module_init(cluster_init);
 module_exit(cluster_exit);
+MODULE_AUTHOR("SUSE");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Clustering support for MD");
-- 
1.8.5.6

