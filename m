From: rgoldwyn@suse.de
Subject: [PATCH 10/14] md-cluster: make sure the node do not receive it's own msg
Date: Tue, 13 Oct 2015 09:25:31 -0500
Message-ID: <1444746335-22624-11-git-send-email-rgoldwyn@suse.de>
References: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

During the past test, the node occasionally received the msg which is
sent from itself, this case should not happen in theory, but it is
better to avoid it in case something wrong happened.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index ba80df9..8bddd78 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -462,6 +462,9 @@ static void process_readd_disk(struct mddev *mddev, struct cluster_msg *msg)
 
 static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 {
+	if (WARN(mddev->cluster_info->slot_number - 1 == le32_to_cpu(msg->slot),
+		"node %d received it's own msg\n", le32_to_cpu(msg->slot)))
+		return;
 	switch (msg->type) {
 	case METADATA_UPDATED:
 		process_metadata_update(mddev, msg);
-- 
1.8.5.6

