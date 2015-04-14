From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 2/6] md: Export and rename kick_rdev_from_array
Date: Tue, 14 Apr 2015 10:43:24 -0500
Message-ID: <20150414154324.GA4088@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: GQJiang@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This export is required for clustering module in order to
co-ordinate remove/readd a rdev from all nodes.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c | 17 +++++++++--------
 drivers/md/md.h |  1 +
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d566ade..2949c4a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2172,11 +2172,12 @@ static void export_rdev(struct md_rdev *rdev)
 	kobject_put(&rdev->kobj);
 }
 
-static void kick_rdev_from_array(struct md_rdev *rdev)
+void md_kick_rdev_from_array(struct md_rdev *rdev)
 {
 	unbind_rdev_from_array(rdev);
 	export_rdev(rdev);
 }
+EXPORT_SYMBOL_GPL(md_kick_rdev_from_array);
 
 static void export_array(struct mddev *mddev)
 {
@@ -2185,7 +2186,7 @@ static void export_array(struct mddev *mddev)
 	while (!list_empty(&mddev->disks)) {
 		rdev = list_first_entry(&mddev->disks, struct md_rdev,
 					same_set);
-		kick_rdev_from_array(rdev);
+		md_kick_rdev_from_array(rdev);
 	}
 	mddev->raid_disks = 0;
 	mddev->major_version = 0;
@@ -2480,7 +2481,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			struct mddev *mddev = rdev->mddev;
 			if (mddev_is_clustered(mddev))
 				md_cluster_ops->metadata_update_start(mddev);
-			kick_rdev_from_array(rdev);
+			md_kick_rdev_from_array(rdev);
 			if (mddev->pers)
 				md_update_sb(mddev, 1);
 			md_new_event(mddev);
@@ -3138,7 +3139,7 @@ static void analyze_sbs(struct mddev *mddev)
 				"md: fatal superblock inconsistency in %s"
 				" -- removing from array\n",
 				bdevname(rdev->bdev,b));
-			kick_rdev_from_array(rdev);
+			md_kick_rdev_from_array(rdev);
 		}
 
 	super_types[mddev->major_version].
@@ -3153,7 +3154,7 @@ static void analyze_sbs(struct mddev *mddev)
 			       "md: %s: %s: only %d devices permitted\n",
 			       mdname(mddev), bdevname(rdev->bdev, b),
 			       mddev->max_disks);
-			kick_rdev_from_array(rdev);
+			md_kick_rdev_from_array(rdev);
 			continue;
 		}
 		if (rdev != freshest) {
@@ -3162,7 +3163,7 @@ static void analyze_sbs(struct mddev *mddev)
 				printk(KERN_WARNING "md: kicking non-fresh %s"
 					" from array!\n",
 					bdevname(rdev->bdev,b));
-				kick_rdev_from_array(rdev);
+				md_kick_rdev_from_array(rdev);
 				continue;
 			}
 			/* No device should have a Candidate flag
@@ -3171,7 +3172,7 @@ static void analyze_sbs(struct mddev *mddev)
 			if (test_bit(Candidate, &rdev->flags)) {
 				pr_info("md: kicking Cluster Candidate %s from array!\n",
 					bdevname(rdev->bdev, b));
-				kick_rdev_from_array(rdev);
+				md_kick_rdev_from_array(rdev);
 			}
 		}
 		if (mddev->level == LEVEL_MULTIPATH) {
@@ -5973,7 +5974,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 	if (rdev->raid_disk >= 0)
 		goto busy;
 
-	kick_rdev_from_array(rdev);
+	md_kick_rdev_from_array(rdev);
 	md_update_sb(mddev, 1);
 	md_new_event(mddev);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6dc0ce0..d98c0d7 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -671,6 +671,7 @@ extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 extern void md_unplug(struct blk_plug_cb *cb, bool from_schedule);
 extern void md_reload_sb(struct mddev *mddev);
 extern void md_update_sb(struct mddev *mddev, int force);
+extern void md_kick_rdev_from_array(struct md_rdev * rdev);
 static inline int mddev_check_plugged(struct mddev *mddev)
 {
 	return !!blk_check_plugged(md_unplug, mddev,
-- 
2.1.4

