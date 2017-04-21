From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH] md/raid1: remove unused queue
Date: Fri, 21 Apr 2017 11:52:16 +0800
Message-ID: <20170421035216.25771-1-lzhong@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Lidong Zhong <lidong.zhong@suse.com>

A queue is declared and get from the disk of the array, but it's not
used anywhere. So removing it from the source.

Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
---
 drivers/md/raid1.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a34f587..559f848 100644
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
-- 
2.10.0

