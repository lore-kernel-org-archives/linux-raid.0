From: Shaohua Li <shli@fb.com>
Subject: [PATCH] md: set rotational bit
Date: Fri, 30 Sep 2016 09:45:40 -0700
Message-ID: <475298bb0650722bf38a2bf0d260a20579ee14e3.1475253807.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com
List-Id: linux-raid.ids

if all disks in an array are non-rotational, set the array
non-rotational.

This only works for array with all disks populated at startup. Support
for disk hotadd/hotremove could be added later if necessary.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 457b538..eac84d8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5297,6 +5297,21 @@ int md_run(struct mddev *mddev)
 		return err;
 	}
 	if (mddev->queue) {
+		bool nonrot = true;
+
+		rdev_for_each(rdev, mddev) {
+			if (rdev->raid_disk >= 0 &&
+			    !blk_queue_nonrot(bdev_get_queue(rdev->bdev))) {
+				nonrot = false;
+				break;
+			}
+		}
+		if (mddev->degraded)
+			nonrot = false;
+		if (nonrot)
+			queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mddev->queue);
+		else
+			queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, mddev->queue);
 		mddev->queue->backing_dev_info.congested_data = mddev;
 		mddev->queue->backing_dev_info.congested_fn = md_congested;
 	}
-- 
2.9.3

