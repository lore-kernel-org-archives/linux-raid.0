From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 1/8] md-cluster: call md_kick_rdev_from_array once ack failed
Date: Thu, 28 Jul 2016 02:16:45 -0400
Message-ID: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The new_disk_ack could return failure if WAITING_FOR_NEWDISK
is not set, so we need to kick the dev from array in case
failure happened.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2ed547f..743cd21 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6092,9 +6092,11 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 			export_rdev(rdev);
 
 		if (mddev_is_clustered(mddev)) {
-			if (info->state & (1 << MD_DISK_CANDIDATE))
-				md_cluster_ops->new_disk_ack(mddev, (err == 0));
-			else {
+			if (info->state & (1 << MD_DISK_CANDIDATE)) {
+				err = md_cluster_ops->new_disk_ack(mddev, (err == 0));
+				if (err)
+					md_kick_rdev_from_array(rdev);
+			} else {
 				if (err)
 					md_cluster_ops->add_new_disk_cancel(mddev);
 				else
-- 
2.6.2

