From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2 01/10] md-cluster: call md_kick_rdev_from_array once ack failed
Date: Fri, 12 Aug 2016 13:42:34 +0800
Message-ID: <1470980563-26062-2-git-send-email-gqjiang@suse.com>
References: <1470980563-26062-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1470980563-26062-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, Guoqing Jiang <gqjiang@suse.com>
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
 drivers/md/md.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2c3ab6f..d6ae9bc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6101,9 +6101,13 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 			export_rdev(rdev);
 
 		if (mddev_is_clustered(mddev)) {
-			if (info->state & (1 << MD_DISK_CANDIDATE))
-				md_cluster_ops->new_disk_ack(mddev, (err == 0));
-			else {
+			if (info->state & (1 << MD_DISK_CANDIDATE)) {
+				if (!err) {
+					err = md_cluster_ops->new_disk_ack(mddev, (err == 0));
+					if (err)
+						md_kick_rdev_from_array(rdev);
+				}
+			} else {
 				if (err)
 					md_cluster_ops->add_new_disk_cancel(mddev);
 				else
-- 
2.6.2

