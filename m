From: rgoldwyn@suse.de
Subject: [PATCH 5/5] Fix adding of new disk with new reload code
Date: Mon,  5 Oct 2015 10:09:54 -0500
Message-ID: <1444057794-17256-6-git-send-email-rgoldwyn@suse.de>
References: <1444057794-17256-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444057794-17256-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Adding the disk worked incorrectly with the new reload code. Fix it:

 - No operation should be performed on rdev marked as Candidate
 - After a metadata update operation, kick disk if role is 0xfffe
   else clear Candidate bit and continue with the regular change check.
 - On the initiating node, cancel the metadata_update (unlock token),
   in case of an error while adding

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 75d14e3..e324544 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3246,14 +3246,6 @@ static void analyze_sbs(struct mddev *mddev)
 				md_kick_rdev_from_array(rdev);
 				continue;
 			}
-			/* No device should have a Candidate flag
-			 * when reading devices
-			 */
-			if (test_bit(Candidate, &rdev->flags)) {
-				pr_info("md: kicking Cluster Candidate %s from array!\n",
-					bdevname(rdev->bdev, b));
-				md_kick_rdev_from_array(rdev);
-			}
 		}
 		if (mddev->level == LEVEL_MULTIPATH) {
 			rdev->desc_nr = i++;
@@ -5962,7 +5954,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 				/* --add initiated by this node */
 				err = md_cluster_ops->add_new_disk_start(mddev, rdev);
 				if (err) {
-					md_cluster_ops->add_new_disk_finish(mddev);
+					md_cluster_ops->metadata_update_cancel(mddev);
 					export_rdev(rdev);
 					return err;
 				}
@@ -5973,11 +5965,11 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err)
 			export_rdev(rdev);
-		else
+		else if (!(info->state & (1 << MD_DISK_CANDIDATE)))
 			err = add_bound_rdev(rdev);
-		if (mddev_is_clustered(mddev) &&
+		if (err && mddev_is_clustered(mddev) &&
 				(info->state & (1 << MD_DISK_CLUSTER_ADD)))
-			md_cluster_ops->add_new_disk_finish(mddev);
+			md_cluster_ops->metadata_update_cancel(mddev);
 		return err;
 	}
 
@@ -8038,6 +8030,8 @@ static int remove_and_add_spares(struct mddev *mddev,
 	rdev_for_each(rdev, mddev) {
 		if (this && this != rdev)
 			continue;
+		if (test_bit(Candidate, &rdev->flags))
+			continue;
 		if (rdev->raid_disk >= 0 &&
 		    !test_bit(In_sync, &rdev->flags) &&
 		    !test_bit(Faulty, &rdev->flags))
@@ -8955,6 +8949,19 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 
 		/* Check if the roles changed */
 		role = le16_to_cpu(sb->dev_roles[rdev2->desc_nr]);
+
+		if (test_bit(Candidate, &rdev2->flags)) {
+			if (role == 0xfffe) {
+				pr_info("md: Removing Candidate device %s because add failed\n", bdevname(rdev2->bdev,b));
+				md_kick_rdev_from_array(rdev2);
+				continue;
+			}
+			else {
+				clear_bit(Candidate, &rdev2->flags);
+				rdev2->raid_disk = -1;
+			}
+		}
+
 		if (role != rdev2->raid_disk) {
 			/* got activated */
 			if (rdev2->raid_disk == -1 && role != 0xffff) {
-- 
1.8.5.6

