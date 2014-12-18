From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 10/24] Lock bitmap while joining the cluster
Date: Thu, 18 Dec 2014 10:17:05 -0600
Message-ID: <20141218161705.GA29614@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 43b3cda..4c3ad2c 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -37,6 +37,7 @@ struct md_cluster_info {
 	struct completion completion;
 	struct dlm_lock_resource *sb_lock;
 	struct mutex sb_mutex;
+	struct dlm_lock_resource *bitmap_lockres;
 };
 
 static void sync_ast(void *arg)
@@ -212,6 +213,20 @@ static int join(struct mddev *mddev, int nodes)
 		ret = -ENOMEM;
 		goto err;
 	}
+
+	pr_info("Joined cluster %s slot %d\n", str, cinfo->slot_number);
+
+	memset(str, '\0', 64);
+	snprintf(str, 64, "bitmap%04d", cinfo->slot_number - 1);
+	cinfo->bitmap_lockres = lockres_init(mddev, str, NULL, 1);
+	if (!cinfo->bitmap_lockres)
+		goto err;
+	if (dlm_lock_sync(cinfo->bitmap_lockres, DLM_LOCK_PW)) {
+		pr_err("Failed to get bitmap lock\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
 	return 0;
 err:
 	if (cinfo->lockspace)
@@ -228,6 +243,7 @@ static int leave(struct mddev *mddev)
 	if (!cinfo)
 		return 0;
 	lockres_free(cinfo->sb_lock);
+	lockres_free(cinfo->bitmap_lockres);
 	dlm_release_lockspace(cinfo->lockspace, 2);
 	return 0;
 }
-- 
2.1.2

