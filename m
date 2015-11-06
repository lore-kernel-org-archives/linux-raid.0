From: rgoldwyn@suse.de
Subject: [PATCH 3/6] md-cluster: remove a disk asynchronously from cluster environment
Date: Thu,  5 Nov 2015 21:50:16 -0600
Message-ID: <1446781819-25571-3-git-send-email-rgoldwyn@suse.de>
References: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, linux-raid@vger.kernel.org
Cc: Guoqing Jiang <gqjiang@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

For cluster raid, if one disk couldn't be reach in one node, then
other nodes would receive the REMOVE message for the disk.

In receiving node, we can't call md_kick_rdev_from_array to remove
the disk from array synchronously since the disk might still be busy
in this node. So let's set a ClusterRemove flag on the disk, then
let the thread to do the removal job eventually.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c |  7 +++++--
 drivers/md/md.c         | 12 ++++++++++++
 drivers/md/md.h         |  1 +
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 3daa464..a681706 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -443,8 +443,11 @@ static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
 	struct md_rdev *rdev = md_find_rdev_nr_rcu(mddev,
 						   le32_to_cpu(msg->raid_slot));
 
-	if (rdev)
-		md_kick_rdev_from_array(rdev);
+	if (rdev) {
+		set_bit(ClusterRemove, &rdev->flags);
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
+	}
 	else
 		pr_warn("%s: %d Could not find disk(%d) to REMOVE\n",
 			__func__, __LINE__, le32_to_cpu(msg->raid_slot));
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 44d0342..32ca592 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8222,6 +8222,18 @@ void md_check_recovery(struct mddev *mddev)
 			goto unlock;
 		}
 
+		if (mddev_is_clustered(mddev)) {
+			struct md_rdev *rdev;
+			/* kick the device if another node issued a
+			 * remove disk.
+			 */
+			rdev_for_each(rdev, mddev) {
+				if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
+						rdev->raid_disk < 0)
+					md_kick_rdev_from_array(rdev);
+			}
+		}
+
 		if (!mddev->external) {
 			int did_change = 0;
 			spin_lock(&mddev->lock);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2ea0035..db54341 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -172,6 +172,7 @@ enum flag_bits {
 				 * This device is seen locally but not
 				 * by the whole cluster
 				 */
+	ClusterRemove,
 };
 
 #define BB_LEN_MASK	(0x00000000000001FFULL)
-- 
1.8.5.6

