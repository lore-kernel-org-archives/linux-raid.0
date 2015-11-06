From: rgoldwyn@suse.de
Subject: [PATCH 5/6] md-cluster: Fix the remove sequence with the new MD reload code
Date: Thu,  5 Nov 2015 21:50:18 -0600
Message-ID: <1446781819-25571-5-git-send-email-rgoldwyn@suse.de>
References: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

The remove disk message does not need metadata_update_start(), but
can be an independent message.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 2 +-
 drivers/md/md.c         | 9 +--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 9a36ad6..33f5d7a 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1018,7 +1018,7 @@ static int remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 	cmsg.type = cpu_to_le32(REMOVE);
 	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
-	return __sendmsg(cinfo, &cmsg);
+	return sendmsg(cinfo, &cmsg);
 }
 
 static int gather_bitmaps(struct md_rdev *rdev)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 65b6326..4222285 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6045,15 +6045,11 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 {
 	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
-	int ret = -1;
 
 	rdev = find_rdev(mddev, dev);
 	if (!rdev)
 		return -ENXIO;
 
-	if (mddev_is_clustered(mddev))
-		ret = md_cluster_ops->metadata_update_start(mddev);
-
 	if (rdev->raid_disk < 0)
 		goto kick_rdev;
 
@@ -6064,7 +6060,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		goto busy;
 
 kick_rdev:
-	if (mddev_is_clustered(mddev) && ret == 0)
+	if (mddev_is_clustered(mddev))
 		md_cluster_ops->remove_disk(mddev, rdev);
 
 	md_kick_rdev_from_array(rdev);
@@ -6073,9 +6069,6 @@ kick_rdev:
 
 	return 0;
 busy:
-	if (mddev_is_clustered(mddev) && ret == 0)
-		md_cluster_ops->metadata_update_cancel(mddev);
-
 	printk(KERN_WARNING "md: cannot remove active disk %s from %s ...\n",
 		bdevname(rdev->bdev,b), mdname(mddev));
 	return -EBUSY;
-- 
1.8.5.6

