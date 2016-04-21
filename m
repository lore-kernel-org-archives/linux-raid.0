From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 06/13] md-cluster: change array_sectors and update size are not supported
Date: Thu, 21 Apr 2016 13:58:07 +0800
Message-ID: <1461218294-4960-7-git-send-email-gqjiang@suse.com>
References: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1461218294-4960-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Currently, some features are not supported yet,
such as change array_sectors and update size, so
return EINVAL for them and listed it in document.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Documentation/md-cluster.txt | 6 ++++++
 drivers/md/md.c              | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/Documentation/md-cluster.txt b/Documentation/md-cluster.txt
index c100c71..3888327 100644
--- a/Documentation/md-cluster.txt
+++ b/Documentation/md-cluster.txt
@@ -316,3 +316,9 @@ The algorithm is:
  nodes are using the raid which is achieved by lock all bitmap
  locks within the cluster, and also those locks are unlocked
  accordingly.
+
+7. Unsupported features
+
+There are somethings which are not supported by cluster MD yet.
+
+- update size and change array_sectors.
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0639c01..1b26397 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4812,6 +4812,10 @@ array_size_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err)
 		return err;
 
+	/* cluster raid doesn't support change array_sectors */
+	if (mddev_is_clustered(mddev))
+		return -EINVAL;
+
 	if (strncmp(buf, "default", 7) == 0) {
 		if (mddev->pers)
 			sectors = mddev->pers->size(mddev, 0, 0);
@@ -6433,6 +6437,10 @@ static int update_size(struct mddev *mddev, sector_t num_sectors)
 	int rv;
 	int fit = (num_sectors == 0);
 
+	/* cluster raid doesn't support update size */
+	if (mddev_is_clustered(mddev))
+		return -EINVAL;
+
 	if (mddev->pers->resize == NULL)
 		return -EINVAL;
 	/* The "num_sectors" is the number of sectors of each device that
-- 
2.6.6

