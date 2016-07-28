From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 8/8] md-cluster: remove EXPERIMENTAL info
Date: Thu, 28 Jul 2016 02:16:52 -0400
Message-ID: <1469686612-16126-8-git-send-email-gqjiang@suse.com>
References: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

We can remove "EXPERIMENTAL" for md-cluster after
several rounds of development and bug fixes.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/Kconfig      | 2 +-
 drivers/md/md-cluster.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 02a5345..74bc3ca 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -178,7 +178,7 @@ config MD_FAULTY
 
 
 config MD_CLUSTER
-	tristate "Cluster Support for MD (EXPERIMENTAL)"
+	tristate "Cluster Support for MD"
 	depends on BLK_DEV_MD
 	depends on DLM
 	default n
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 0984771..678f0a6 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1266,7 +1266,6 @@ static struct md_cluster_operations cluster_ops = {
 
 static int __init cluster_init(void)
 {
-	pr_warn("md-cluster: EXPERIMENTAL. Use with caution\n");
 	pr_info("Registering Cluster MD functions\n");
 	register_md_cluster_operations(&cluster_ops, THIS_MODULE);
 	return 0;
-- 
2.6.2

