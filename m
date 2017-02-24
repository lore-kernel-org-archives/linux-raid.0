From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 02/14] md-cluster: free md_cluster_info if node leave cluster
Date: Fri, 24 Feb 2017 11:15:12 +0800
Message-ID: <1487906124-20107-3-git-send-email-gqjiang@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

To avoid memory leak, we need to free the cinfo which
is allocated when node join cluster.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 03c38ed222ce..84c001063983 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -973,6 +973,7 @@ static int leave(struct mddev *mddev)
 	lockres_free(cinfo->bitmap_lockres);
 	unlock_all_bitmaps(mddev);
 	dlm_release_lockspace(cinfo->lockspace, 2);
+	kfree(cinfo);
 	return 0;
 }
 
-- 
2.6.2

