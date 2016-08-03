From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2 1/8] md-cluster: call md_kick_rdev_from_array once ack failed
Date: Wed,  3 Aug 2016 10:26:40 +0800
Message-ID: <1470191200-29036-1-git-send-email-gqjiang@suse.com>
References: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The new_disk_ack could return failure if WAITING_FOR_NEWDISK
is not set, so we need to kick the dev from array in case
failure happened.

And we missed to check err before call new_disk_ack othwise
we could kick a rdev which isn't in array, thanks for the
reminder from Shaohua.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
Changes:
1. add the check for "err" before call new_disk_ack.

 drivers/md/md.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2c3ab6f..e6eb66b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6102,7 +6102,11 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 
 		if (mddev_is_clustered(mddev)) {
 			if (info->state & (1 << MD_DISK_CANDIDATE))
-				md_cluster_ops->new_disk_ack(mddev, (err == 0));
+				if (!err) {
+					err = md_cluster_ops->new_disk_ack(mddev, (err == 0));
+					if (err)
+						md_kick_rdev_from_array(rdev);
+				}
 			else {
 				if (err)
 					md_cluster_ops->add_new_disk_cancel(mddev);
-- 
2.6.2

