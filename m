From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH] md/raid1/10: remove unused queue
Date: Fri, 21 Apr 2017 15:21:38 +0800
Message-ID: <20170421072138.1117-1-lzhong@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Lidong Zhong <lidong.zhong@suse.com>

A queue is declared and get from the disk of the array, but it's not
used anywhere. So removing it from the source.

Signed-off-by: Lidong Zhong <lzhong@suse.com>
---
 drivers/md/raid1.c  | 3 ---
 drivers/md/raid10.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a34f58772022..559f848794a6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3064,7 +3064,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	err = -EINVAL;
 	spin_lock_init(&conf->device_lock);
 	rdev_for_each(rdev, mddev) {
-		struct request_queue *q;
 		int disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
 		    || disk_idx < 0)
@@ -3077,8 +3076,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		if (disk->rdev)
 			goto abort;
 		disk->rdev = rdev;
-		q = bdev_get_queue(rdev->bdev);
-
 		disk->head_position = 0;
 		disk->seq_start = MaxSector;
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e89a8d78a9ed..5c629f289216 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3759,7 +3759,6 @@ static int raid10_run(struct mddev *mddev)
 
 	rdev_for_each(rdev, mddev) {
 		long long diff;
-		struct request_queue *q;
 
 		disk_idx = rdev->raid_disk;
 		if (disk_idx < 0)
@@ -3778,7 +3777,6 @@ static int raid10_run(struct mddev *mddev)
 				goto out_free_conf;
 			disk->rdev = rdev;
 		}
-		q = bdev_get_queue(rdev->bdev);
 		diff = (rdev->new_data_offset - rdev->data_offset);
 		if (!mddev->reshape_backwards)
 			diff = -diff;
-- 
2.12.0

