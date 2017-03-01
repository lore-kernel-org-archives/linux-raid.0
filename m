From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2 3/5] md-cluster: add CHANGE_CAPACITY message type
Date: Wed,  1 Mar 2017 16:42:38 +0800
Message-ID: <1488357760-7893-4-git-send-email-gqjiang@suse.com>
References: <1488357760-7893-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488357760-7893-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The msg type CHANGE_CAPACITY is introduced to support
resize clustered raid in later patch, and it is sent
after all the nodes have the same sync_size, receiver
node just need to set new capacity once received this
msg.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 5cf0a9d29bf0..8b7d55bf5aa2 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -104,6 +104,7 @@ enum msg_type {
 	REMOVE,
 	RE_ADD,
 	BITMAP_NEEDS_SYNC,
+	CHANGE_CAPACITY,
 };
 
 struct cluster_msg {
@@ -579,6 +580,10 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 	case METADATA_UPDATED:
 		process_metadata_update(mddev, msg);
 		break;
+	case CHANGE_CAPACITY:
+		set_capacity(mddev->gendisk, mddev->array_sectors);
+		revalidate_disk(mddev->gendisk);
+		break;
 	case RESYNCING:
 		process_suspend_info(mddev, le32_to_cpu(msg->slot),
 				     le64_to_cpu(msg->low),
-- 
2.6.2

