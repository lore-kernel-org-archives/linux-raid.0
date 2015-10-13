From: rgoldwyn@suse.de
Subject: [PATCH 08/14] md-cluster: make other members of cluster_msg is handled by little endian funcs
Date: Tue, 13 Oct 2015 09:25:29 -0500
Message-ID: <1444746335-22624-9-git-send-email-rgoldwyn@suse.de>
References: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 85d0a1f..3c18185 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -418,7 +418,7 @@ static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
 
 	len = snprintf(disk_uuid, 64, "DEVICE_UUID=");
 	sprintf(disk_uuid + len, "%pU", cmsg->uuid);
-	snprintf(raid_slot, 16, "RAID_DISK=%d", cmsg->raid_slot);
+	snprintf(raid_slot, 16, "RAID_DISK=%d", le32_to_cpu(cmsg->raid_slot));
 	pr_info("%s:%d Sending kobject change with %s and %s\n", __func__, __LINE__, disk_uuid, raid_slot);
 	init_completion(&cinfo->newdisk_completion);
 	set_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
@@ -438,22 +438,26 @@ static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg
 
 static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
 {
-	struct md_rdev *rdev = md_find_rdev_nr_rcu(mddev, msg->raid_slot);
+	struct md_rdev *rdev = md_find_rdev_nr_rcu(mddev,
+						   le32_to_cpu(msg->raid_slot));
 
 	if (rdev)
 		md_kick_rdev_from_array(rdev);
 	else
-		pr_warn("%s: %d Could not find disk(%d) to REMOVE\n", __func__, __LINE__, msg->raid_slot);
+		pr_warn("%s: %d Could not find disk(%d) to REMOVE\n",
+			__func__, __LINE__, le32_to_cpu(msg->raid_slot));
 }
 
 static void process_readd_disk(struct mddev *mddev, struct cluster_msg *msg)
 {
-	struct md_rdev *rdev = md_find_rdev_nr_rcu(mddev, msg->raid_slot);
+	struct md_rdev *rdev = md_find_rdev_nr_rcu(mddev,
+						   le32_to_cpu(msg->raid_slot));
 
 	if (rdev && test_bit(Faulty, &rdev->flags))
 		clear_bit(Faulty, &rdev->flags);
 	else
-		pr_warn("%s: %d Could not find disk(%d) which is faulty", __func__, __LINE__, msg->raid_slot);
+		pr_warn("%s: %d Could not find disk(%d) which is faulty",
+			__func__, __LINE__, le32_to_cpu(msg->raid_slot));
 }
 
 static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
@@ -936,7 +940,7 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
 	memset(&cmsg, 0, sizeof(cmsg));
 	cmsg.type = cpu_to_le32(NEWDISK);
 	memcpy(cmsg.uuid, uuid, 16);
-	cmsg.raid_slot = rdev->desc_nr;
+	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
 	lock_comm(cinfo);
 	ret = __sendmsg(cinfo, &cmsg);
 	if (ret)
@@ -979,8 +983,8 @@ static int remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct cluster_msg cmsg;
 	struct md_cluster_info *cinfo = mddev->cluster_info;
-	cmsg.type = REMOVE;
-	cmsg.raid_slot = rdev->desc_nr;
+	cmsg.type = cpu_to_le32(REMOVE);
+	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
 	return __sendmsg(cinfo, &cmsg);
 }
 
@@ -992,8 +996,8 @@ static int gather_bitmaps(struct md_rdev *rdev)
 	struct mddev *mddev = rdev->mddev;
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 
-	cmsg.type = RE_ADD;
-	cmsg.raid_slot = rdev->desc_nr;
+	cmsg.type = cpu_to_le32(RE_ADD);
+	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
 	err = sendmsg(cinfo, &cmsg);
 	if (err)
 		goto out;
-- 
1.8.5.6

