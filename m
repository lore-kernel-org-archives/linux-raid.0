From: rgoldwyn@suse.de
Subject: [PATCH 03/14] md-cluster: Improve md_reload_sb to be less error prone
Date: Tue, 13 Oct 2015 09:25:24 -0500
Message-ID: <1444746335-22624-4-git-send-email-rgoldwyn@suse.de>
References: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

md_reload_sb is too simplistic and it explicitly needs to determine
the changes made by the writing node. However, there are multiple areas
where a simple reload could fail.

Instead, read the superblock of one of the "good" rdevs and update
the necessary information:

- read the superblock into a newly allocated page, by temporarily
  swapping out rdev->sb_page and calling ->load_super.
- if that fails return
- if it succeeds, call check_sb_changes
  1. iterates over list of active devices and checks the matching
   dev_roles[] value.
   	If that is 'faulty', the device must be  marked as faulty
	 - call md_error to mark the device as faulty. Make sure
	   not to set CHANGE_DEVS and wakeup mddev->thread or else
	   it would initiate a resync process, which is the responsibility
	   of the "primary" node.
	 - clear the Blocked bit
	 - Call remove_and_add_spares() to hot remove the device.
	If the device is 'spare':
	 - call remove_and_add_spares() to get the number of spares
	   added in this operation.
	 - Reduce mddev->degraded to mark the array as not degraded.
  2. reset recovery_cp
- read the rest of the rdevs to update recovery_offset. If recovery_offset
  is equal to MaxSector, call spare_active() to set it In_sync

This required that recovery_offset be initialized to MaxSector, as
opposed to zero so as to communicate the end of sync for a rdev.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c |  27 ++++++-----
 drivers/md/md.c         | 121 ++++++++++++++++++++++++++++++++++++++++++------
 drivers/md/md.h         |   2 +-
 drivers/md/raid1.c      |   9 ++++
 4 files changed, 133 insertions(+), 26 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 58eadc0..2eb3a50 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -427,8 +427,7 @@ static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
 static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
-
-	md_reload_sb(mddev);
+	md_reload_sb(mddev, le32_to_cpu(msg->raid_slot));
 	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
 }
 
@@ -834,11 +833,23 @@ static int metadata_update_finish(struct mddev *mddev)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 	struct cluster_msg cmsg;
-	int ret;
+	struct md_rdev *rdev;
+	int ret = 0;
 
 	memset(&cmsg, 0, sizeof(cmsg));
 	cmsg.type = cpu_to_le32(METADATA_UPDATED);
-	ret = __sendmsg(cinfo, &cmsg);
+	cmsg.raid_slot = -1;
+	/* Pick up a good active device number to send.
+	 */
+	rdev_for_each(rdev, mddev)
+		if (rdev->raid_disk > -1 && !test_bit(Faulty, &rdev->flags)) {
+			cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
+			break;
+		}
+	if (cmsg.raid_slot >= 0)
+		ret = __sendmsg(cinfo, &cmsg);
+	else
+		pr_warn("md-cluster: No good device id found to send\n");
 	unlock_comm(cinfo);
 	return ret;
 }
@@ -922,15 +933,9 @@ static int add_new_disk_start(struct mddev *mddev, struct md_rdev *rdev)
 
 static int add_new_disk_finish(struct mddev *mddev)
 {
-	struct cluster_msg cmsg;
-	struct md_cluster_info *cinfo = mddev->cluster_info;
-	int ret;
 	/* Write sb and inform others */
 	md_update_sb(mddev, 1);
-	cmsg.type = METADATA_UPDATED;
-	ret = __sendmsg(cinfo, &cmsg);
-	unlock_comm(cinfo);
-	return ret;
+	return metadata_update_finish(mddev);
 }
 
 static int new_disk_ack(struct mddev *mddev, bool ack)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index e21a2fe..12cc28a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8924,25 +8924,118 @@ err_wq:
 	return ret;
 }
 
-void md_reload_sb(struct mddev *mddev)
+static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 {
-	struct md_rdev *rdev, *tmp;
+	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
+	struct md_rdev *rdev2;
+	int role, ret;
+	char b[BDEVNAME_SIZE];
 
-	rdev_for_each_safe(rdev, tmp, mddev) {
-		rdev->sb_loaded = 0;
-		ClearPageUptodate(rdev->sb_page);
+	/* Check for change of roles in the active devices */
+	rdev_for_each(rdev2, mddev) {
+		if (test_bit(Faulty, &rdev2->flags))
+			continue;
+
+		/* Check if the roles changed */
+		role = le16_to_cpu(sb->dev_roles[rdev2->desc_nr]);
+		if (role != rdev2->raid_disk) {
+			/* got activated */
+			if (rdev2->raid_disk == -1 && role != 0xffff) {
+				rdev2->saved_raid_disk = role;
+				ret = remove_and_add_spares(mddev, rdev2);
+				pr_info("Activated spare: %s\n",
+						bdevname(rdev2->bdev,b));
+				continue;
+			}
+			/* device faulty
+			 * We just want to do the minimum to mark the disk
+			 * as faulty. The recovery is performed by the
+			 * one who initiated the error.
+			 */
+			if ((role == 0xfffe) || (role == 0xfffd)) {
+				md_error(mddev, rdev2);
+				clear_bit(Blocked, &rdev2->flags);
+			}
+		}
 	}
-	mddev->raid_disks = 0;
-	analyze_sbs(mddev);
-	rdev_for_each_safe(rdev, tmp, mddev) {
-		struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
-		/* since we don't write to faulty devices, we figure out if the
-		 *  disk is faulty by comparing events
-		 */
-		if (mddev->events > sb->events)
-			set_bit(Faulty, &rdev->flags);
+
+	/* recovery_cp changed */
+	if (le64_to_cpu(sb->resync_offset) != mddev->recovery_cp)
+		mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
+
+	/* Finally set the event to be up to date */
+	mddev->events = le64_to_cpu(sb->events);
+}
+
+static int read_rdev(struct mddev *mddev, struct md_rdev *rdev)
+{
+	int err;
+	struct page *swapout = rdev->sb_page;
+	struct mdp_superblock_1 *sb;
+
+	/* Store the sb page of the rdev in the swapout temporary
+	 * variable in case we err in the future
+	 */
+	rdev->sb_page = NULL;
+	alloc_disk_sb(rdev);
+	ClearPageUptodate(rdev->sb_page);
+	rdev->sb_loaded = 0;
+	err = super_types[mddev->major_version].load_super(rdev, NULL, mddev->minor_version);
+
+	if (err < 0) {
+		pr_warn("%s: %d Could not reload rdev(%d) err: %d. Restoring old values\n",
+				__func__, __LINE__, rdev->desc_nr, err);
+		put_page(rdev->sb_page);
+		rdev->sb_page = swapout;
+		rdev->sb_loaded = 1;
+		return err;
 	}
 
+	sb = page_address(rdev->sb_page);
+	/* Read the offset unconditionally, even if MD_FEATURE_RECOVERY_OFFSET
+	 * is not set
+	 */
+
+	if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_RECOVERY_OFFSET))
+		rdev->recovery_offset = le64_to_cpu(sb->recovery_offset);
+
+	/* The other node finished recovery, call spare_active to set
+	 * device In_sync and mddev->degraded
+	 */
+	if (rdev->recovery_offset == MaxSector &&
+	    !test_bit(In_sync, &rdev->flags) &&
+	    mddev->pers->spare_active(mddev))
+		sysfs_notify(&mddev->kobj, NULL, "degraded");
+
+	put_page(swapout);
+	return 0;
+}
+
+void md_reload_sb(struct mddev *mddev, int nr)
+{
+	struct md_rdev *rdev;
+	int err;
+
+	/* Find the rdev */
+	rdev_for_each_rcu(rdev, mddev) {
+		if (rdev->desc_nr == nr)
+			break;
+	}
+
+	if (!rdev || rdev->desc_nr != nr) {
+		pr_warn("%s: %d Could not find rdev with nr %d\n", __func__, __LINE__, nr);
+		return;
+	}
+
+	err = read_rdev(mddev, rdev);
+	if (err < 0)
+		return;
+
+	check_sb_changes(mddev, rdev);
+
+	/* Read all rdev's to update recovery_offset */
+	rdev_for_each_rcu(rdev, mddev)
+		read_rdev(mddev, rdev);
 }
 EXPORT_SYMBOL(md_reload_sb);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ab33957..2ea0035 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -658,7 +658,7 @@ extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 				   struct mddev *mddev);
 
 extern void md_unplug(struct blk_plug_cb *cb, bool from_schedule);
-extern void md_reload_sb(struct mddev *mddev);
+extern void md_reload_sb(struct mddev *mddev, int raid_disk);
 extern void md_update_sb(struct mddev *mddev, int force);
 extern void md_kick_rdev_from_array(struct md_rdev * rdev);
 struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1dd13bb..b54fefc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1592,6 +1592,15 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
+	/*
+	 * find the disk ... but prefer rdev->saved_raid_disk
+	 * if possible.
+	 */
+	if (rdev->saved_raid_disk >= 0 &&
+	    rdev->saved_raid_disk >= first &&
+	    conf->mirrors[rdev->saved_raid_disk].rdev == NULL)
+		first = last = rdev->saved_raid_disk;
+
 	for (mirror = first; mirror <= last; mirror++) {
 		p = conf->mirrors+mirror;
 		if (!p->rdev) {
-- 
1.8.5.6

