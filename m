From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 19/24] Reload superblock if METADATA_UPDATED is received
Date: Thu, 18 Dec 2014 10:18:28 -0600
Message-ID: <20141218161828.GA29654@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Re-reads the devices by invalidating the cache.
Since we don't write to faulty devices, this is detected using
events recorded in the devices. If it is old as compared to the mddev
mark it is faulty.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c |  1 +
 drivers/md/md.c         | 21 +++++++++++++++++++++
 drivers/md/md.h         |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index db81ef1..084834d 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -322,6 +322,7 @@ static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 		case METADATA_UPDATED:
 			pr_info("%s: %d Received message: METADATA_UPDATE from %d\n",
 					__func__, __LINE__, msg->slot);
+			md_reload_sb(mddev);
 			break;
 		case RESYNCING:
 			pr_info("%s: %d Received message: RESYNCING from %d\n",
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2288137..829086c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8752,6 +8752,27 @@ err_wq:
 	return ret;
 }
 
+void md_reload_sb(struct mddev *mddev)
+{
+	struct md_rdev *rdev, *tmp;
+	rdev_for_each_safe(rdev, tmp, mddev) {
+		rdev->sb_loaded = 0;
+		ClearPageUptodate(rdev->sb_page);
+	}
+	mddev->raid_disks = 0;
+	analyze_sbs(mddev);
+	rdev_for_each_safe(rdev, tmp, mddev) {
+		struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
+		/* since we don't write to faulty devices, we figure out if the
+		 *  disk is faulty by comparing events
+		 */
+		if (mddev->events > sb->events)
+			set_bit(Faulty, &rdev->flags);
+	}
+
+}
+EXPORT_SYMBOL(md_reload_sb);
+
 #ifndef MODULE
 
 /*
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6c6e992..620384a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -633,6 +633,7 @@ extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 				   struct mddev *mddev);
 
 extern void md_unplug(struct blk_plug_cb *cb, bool from_schedule);
+extern void md_reload_sb(struct mddev *mddev);
 static inline int mddev_check_plugged(struct mddev *mddev)
 {
 	return !!blk_check_plugged(md_unplug, mddev,
-- 
2.1.2

